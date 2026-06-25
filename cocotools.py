#!/usr/bin/env python3
"""
cocotools.py — CoCo Assembly and Disk Image Toolkit

Provides the tools needed to write, assemble, and run 6809 assembly
programs on a TRS-80 Color Computer (emulated via XRoar WASM).

No external dependencies.  Python 3.8+ required.

Commands:
  assemble  FILE.ASM [-o FILE.BIN] [--format decb|raw] [-- assembler flags]
  makedsk   FILE.DSK FILE...
  binfo     FILE.BIN [-e] [--hex]
  dskls     FILE.DSK

Usage examples:
  python cocotools.py assemble HELLO.ASM
  python cocotools.py assemble HELLO.ASM -o HELLO.BIN -- -b $3F00
  python cocotools.py makedsk GAME.DSK GAME.BIN GAME.BAS
  python cocotools.py binfo HELLO.BIN -e
  python cocotools.py dskls HELLO.DSK
"""

import sys
import os
import argparse

# Allow running from the repo root without installing
sys.path.insert(0, os.path.dirname(__file__))

from cocotools.lwasm_types import OUTPUT_DECB, OUTPUT_RAW
from cocotools.lwasm_core  import AsmState
from cocotools.input_system import InputSystem
from cocotools.pass1        import do_pass1
from cocotools.passes       import assemble as _run_passes, collect_decb_bytes, _collect_raw
from cocotools.decb  import (
    Dsk, make_bin, parse_bin, infer_ftype,
    FTYPE_ML, FTYPE_BASIC, FTYPE_DATA, FTYPE_TEXT,
)


# ─────────────────────────────────────────────────────────────────────────────
# lwasm-style flag parser for -- passthrough
# ─────────────────────────────────────────────────────────────────────────────

def _parse_asm_flags(as_, flags):
    """
    Parse lwasm-style flags passed after -- and apply them to AsmState.
    Unknown flags are reported but do not stop assembly.

    Supported flags:
      -b / --base ADDR      Base address for PIC output (hex: $3F00 or 0x3F00)
      -I / --include DIR    Add directory to include search path
      -D / --define SYM[=VAL]  Pre-define a symbol (default value: 1)
      -9 / --6309           Enable HD6309 instruction set
    """
    from cocotools.lwasm_types import PRAGMA_6809

    base_addr = None
    i = 0
    # strip leading -- separator if present
    if flags and flags[0] == '--':
        i = 1

    while i < len(flags):
        f = flags[i]

        if f in ('-b', '--base'):
            i += 1
            if i < len(flags):
                try:
                    base_addr = _parse_addr(flags[i])
                except ValueError:
                    die(f"invalid base address: {flags[i]}")
            else:
                die(f"{f} requires an address argument")

        elif f in ('-I', '--include'):
            i += 1
            if i < len(flags):
                as_.include_list.append(flags[i])
            else:
                die(f"{f} requires a directory argument")

        elif f in ('-D', '--define'):
            i += 1
            if i < len(flags):
                spec = flags[i]
                if '=' in spec:
                    sym, val_str = spec.split('=', 1)
                    try:
                        val = _parse_addr(val_str)
                    except ValueError:
                        die(f"invalid value in -D {spec}")
                else:
                    sym, val = spec, 1
                # Store for pre-registration before pass1
                if not hasattr(as_, '_cmdline_defines'):
                    as_._cmdline_defines = {}
                as_._cmdline_defines[sym.upper()] = val
            else:
                die(f"{f} requires a SYM[=VAL] argument")

        elif f in ('-9', '--6309'):
            as_.pragmas &= ~PRAGMA_6809

        elif f in ('-f', '--format'):
            i += 1   # format handled by --format in cocotools args; skip value

        else:
            print(f"  note: assembler flag '{f}' not supported, ignored",
                  file=sys.stderr)

        i += 1

    return base_addr   # caller applies to output if not None


def _parse_addr(s):
    """Parse $XXXX, 0xXXXX, or decimal address string to int."""
    s = s.strip()
    if s.startswith('$'):
        return int(s[1:], 16)
    if s.lower().startswith('0x'):
        return int(s[2:], 16)
    return int(s, 0)


def _apply_base(binary, base_addr):
    """
    Rewrite a single-segment DECB binary to load at base_addr instead of $0000.
    The exec address is also set to base_addr.
    Only applied when load address in the binary is $0000 (PIC code).
    """
    if len(binary) < 10:
        return binary   # too short to be valid

    data = bytearray(binary)

    # Walk preamble records and patch load addresses
    pos = 0
    while pos < len(data) - 4:
        if data[pos] == 0xFF:
            # Postamble — patch exec address to base_addr
            data[pos+3] = (base_addr >> 8) & 0xFF
            data[pos+4] =  base_addr       & 0xFF
            break
        if data[pos] != 0x00:
            break
        seg_len  = (data[pos+1] << 8) | data[pos+2]
        load_hi  =  data[pos+3]
        load_lo  =  data[pos+4]
        load     = (load_hi << 8) | load_lo
        if load == 0x0000:
            data[pos+3] = (base_addr >> 8) & 0xFF
            data[pos+4] =  base_addr       & 0xFF
        pos += 5 + seg_len

    return bytes(data)


# ─────────────────────────────────────────────────────────────────────────────
# assemble command
# ─────────────────────────────────────────────────────────────────────────────

def cmd_assemble(args):
    src_path = args.source
    out_path = args.output

    if not os.path.isfile(src_path):
        die(f"source file not found: {src_path}")

    if out_path is None:
        base = os.path.splitext(src_path)[0]
        out_path = base + '.BIN'

    fmt_map = {'decb': OUTPUT_DECB, 'raw': OUTPUT_RAW}
    output_fmt = fmt_map.get(args.format, OUTPUT_DECB)

    as_ = AsmState(output_fmt)
    as_.input = InputSystem(as_)

    # Apply -- passthrough flags before opening source
    base_addr = None
    if hasattr(args, 'asm_flags') and args.asm_flags:
        base_addr = _parse_asm_flags(as_, args.asm_flags)

    # Pre-register any -D defines
    if hasattr(as_, '_cmdline_defines'):
        from cocotools.lw_expr import Expr
        for sym, val in as_._cmdline_defines.items():
            as_.register_symbol(None, sym, Expr.int(val), 0)

    as_.input.open(src_path)

    do_pass1(as_)
    _run_passes(as_)

    # Collect and display errors
    errors = []
    cl = as_.line_head
    while cl:
        if cl.err:
            e = cl.err
            while e:
                errors.append(f"{src_path}:{cl.lineno}: {e.mess}")
                e = e.next
        cl = cl.next

    if errors:
        for msg in errors:
            print(msg, file=sys.stderr)
        die(f"assembly failed: {as_.errorcount} error(s)")

    if args.format == 'decb':
        binary = collect_decb_bytes(as_)
        if base_addr is not None:
            binary = _apply_base(binary, base_addr)
    else:
        binary = bytes(_collect_raw(as_))

    with open(out_path, 'wb') as f:
        f.write(binary)

    # Report
    if args.format == 'decb':
        try:
            segs, exec_addr = parse_bin(binary)
            print(f"  assembled: {src_path}")
            print(f"  output:    {out_path}  ({len(binary)} bytes)")
            for load, data in segs:
                print(f"  segment:   load=${load:04X}  size={len(data)} bytes")
            if base_addr is not None:
                print(f"  base:      ${base_addr:04X}  (applied)")
            print(f"  exec:      ${exec_addr:04X}" if exec_addr else "  exec:      (none)")
        except Exception:
            print(f"  assembled {src_path} -> {out_path}  ({len(binary)} bytes)")
    else:
        print(f"  assembled {src_path} -> {out_path}  ({len(binary)} bytes)")


# ─────────────────────────────────────────────────────────────────────────────
# makedsk command
# ─────────────────────────────────────────────────────────────────────────────

def cmd_makedsk(args):
    dsk_path = args.dsk
    dsk = Dsk.blank()

    for file_path in args.files:
        if not os.path.isfile(file_path):
            die(f"file not found: {file_path}")

        base  = os.path.basename(file_path)
        stem, ext = os.path.splitext(base)
        if ext.startswith('.'):
            ext = ext[1:]

        coco_name = stem.upper()[:8]
        coco_ext  = ext.upper()[:3]
        ftype     = infer_ftype(ext)

        data = open(file_path, 'rb').read()
        dsk.write_file(coco_name, coco_ext, ftype, data)
        print(f"  added: {coco_name}.{coco_ext}  ({len(data)} bytes, type={ftype})")

    with open(dsk_path, 'wb') as f:
        f.write(dsk.to_bytes())

    print(f"  written: {dsk_path}  ({161280} bytes)")


# ─────────────────────────────────────────────────────────────────────────────
# CoCo memory map for binfo -e analysis
# ─────────────────────────────────────────────────────────────────────────────

_COCO_REGIONS = [
    (0x0000, 0x00FF, 'direct page / system variables'),
    (0x0100, 0x01FF, 'system stack area'),
    (0x0200, 0x03FF, 'BASIC/DOS work area'),
    (0x0400, 0x05FF, 'VDG text screen (512 bytes)'),
    (0x0600, 0x7FFF, 'free RAM (typical program area)'),
    (0x8000, 0x9FFF, 'cartridge ROM / pak space'),
    (0xA000, 0xBFFF, 'Color BASIC ROM'),
    (0xC000, 0xFEFF, 'Extended BASIC ROM'),
    (0xFF00, 0xFFFF, 'hardware registers'),
]

def _region(addr):
    for start, end, name in _COCO_REGIONS:
        if start <= addr <= end:
            return name
    return 'unknown'

def _binfo_enhanced(segs, exec_addr):
    notes = []

    for i, (load, data) in enumerate(segs):
        seg_end = load + len(data) - 1

        if load == 0x0000:
            notes.append(
                f"segment {i+1}: load=$0000 — position-independent code (PIC)\n"
                f"           use LOADM\"file\",offset,offset to place at runtime")
        else:
            region = _region(load)
            if load < 0x0600:
                notes.append(
                    f"segment {i+1}: load=${load:04X} — {region}")
            elif load >= 0x8000:
                notes.append(
                    f"segment {i+1}: load=${load:04X} — {region}")

        # Check if segment spans a region boundary
        if _region(load) != _region(seg_end):
            notes.append(
                f"segment {i+1}: spans region boundary "
                f"${load:04X}–${seg_end:04X} "
                f"({_region(load)} \u2192 {_region(seg_end)})")

    # Check exec address
    if exec_addr is not None:
        in_seg = any(load <= exec_addr <= load + len(data) - 1
                     for load, data in segs)
        if not in_seg and not any(load == 0 for load, _ in segs):
            notes.append(
                f"exec=${exec_addr:04X} — outside all loaded segments")
        if exec_addr >= 0x8000:
            notes.append(
                f"exec=${exec_addr:04X} — {_region(exec_addr)}")

    if not notes:
        notes.append("nothing unusual to report")

    print()
    print("  enhanced analysis:")
    for note in notes:
        for line in note.splitlines():
            print(f"    {line}")


# ─────────────────────────────────────────────────────────────────────────────
# binin command  (show info about a .BIN file)
# ─────────────────────────────────────────────────────────────────────────────

def cmd_binin(args):
    path = args.binfile
    if not os.path.isfile(path):
        die(f"file not found: {path}")

    data = open(path, 'rb').read()
    try:
        segs, exec_addr = parse_bin(data)
    except ValueError as e:
        die(str(e))

    print(f"DECB binary: {path}  ({len(data)} bytes total)")
    for i, (load, code) in enumerate(segs):
        print(f"  segment {i+1}: load=${load:04X}  size={len(code)}  "
              f"end=${load+len(code)-1:04X}")
    if exec_addr is not None:
        print(f"  exec:       ${exec_addr:04X}")
    else:
        print(f"  exec:       (none)")

    if args.hex:
        for load, code in segs:
            print()
            print(f"  [{load:04X}]")
            for i in range(0, len(code), 16):
                chunk = code[i:i+16]
                hex_part = ' '.join(f'{b:02X}' for b in chunk)
                asc_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
                print(f"    {load+i:04X}  {hex_part:<47}  {asc_part}")

    if args.enhanced:
        _binfo_enhanced(segs, exec_addr)


# ─────────────────────────────────────────────────────────────────────────────
# dskls command  (list files in DSK image)
# ─────────────────────────────────────────────────────────────────────────────

FTYPE_NAMES = {0: 'BASIC', 1: 'DATA', 2: 'ML', 3: 'TEXT'}

def cmd_dskls(args):
    path = args.dskfile
    if not os.path.isfile(path):
        die(f"file not found: {path}")

    data = open(path, 'rb').read()
    try:
        dsk = Dsk.from_bytes(data)
    except Exception as e:
        die(str(e))

    files = dsk.list_files()
    if not files:
        print(f"{path}: (empty disk)")
        return

    print(f"{path}:")
    print(f"  {'NAME':<8}  {'EXT':<3}  {'TYPE':<5}  SIZE")
    for name, ext, ftype, size in files:
        tname = FTYPE_NAMES.get(ftype, f'?{ftype}')
        print(f"  {name:<8}  {ext:<3}  {tname:<5}  {size}")


# ─────────────────────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────────────────────

def die(msg):
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


# ─────────────────────────────────────────────────────────────────────────────
# Argument parser
# ─────────────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        prog='cocotools',
        description='CoCo 6809 assembly and disk image toolkit',
    )
    sub = parser.add_subparsers(dest='command', required=True)

    # assemble
    _asm_epilog = """\
assembler flags (passed after --):
  -b / --base ADDR        Set load and exec address for PIC output
  -I / --include DIR      Add directory to include file search path
  -D / --define SYM[=VAL] Pre-define a symbol (default value: 1)
  -9 / --6309             Enable HD6309 instruction set

examples:
  python cocotools.py assemble HELLO.ASM
  python cocotools.py assemble HELLO.ASM -o HELLO.BIN
  python cocotools.py assemble HELLO.ASM -o HELLO.BIN -- -b $3F00
  python cocotools.py assemble HELLO.ASM -- -I ./include -D DEBUG=1
  python cocotools.py assemble HELLO.ASM --format raw -o HELLO.RAW
"""
    p_asm = sub.add_parser('assemble', aliases=['asm'],
                            help='Assemble a .ASM source file',
                            formatter_class=argparse.RawDescriptionHelpFormatter,
                            epilog=_asm_epilog)
    p_asm.add_argument('source',           help='Source file (.ASM)')
    p_asm.add_argument('-o', '--output',   help='Output file (default: source name with .BIN)')
    p_asm.add_argument('--format',         choices=['decb', 'raw'], default='decb',
                       help='Output format: decb (default) or raw')

    # makedsk
    p_dsk = sub.add_parser('makedsk',
                            help='Build a CoCo DSK image from files')
    p_dsk.add_argument('dsk',              help='Output DSK file')
    p_dsk.add_argument('files', nargs='+', help='Files to add to the disk')

    # binfo
    p_bin = sub.add_parser('binfo',
                            help='Show info about a DECB .BIN file')
    p_bin.add_argument('binfile',          help='DECB binary file')
    p_bin.add_argument('--hex', action='store_true',
                       help='Show hex dump of code')
    p_bin.add_argument('-e', '--enhanced', action='store_true',
                       help='Show enhanced analysis (memory regions, unusual patterns)')

    # dskls
    p_ls  = sub.add_parser('dskls',
                            help='List files in a DSK image')
    p_ls.add_argument('dskfile',           help='DSK image file')

    # Split sys.argv at -- so assembler flags never reach argparse
    argv = sys.argv[1:]
    if '--' in argv:
        split_at = argv.index('--')
        cocotools_argv = argv[:split_at]
        asm_flags      = argv[split_at+1:]
    else:
        cocotools_argv = argv
        asm_flags      = []

    args = parser.parse_args(cocotools_argv)
    args.asm_flags = asm_flags

    if args.command in ('assemble', 'asm'):
        cmd_assemble(args)
    elif args.command == 'makedsk':
        cmd_makedsk(args)
    elif args.command == 'binfo':
        cmd_binin(args)
    elif args.command == 'dskls':
        cmd_dskls(args)


if __name__ == '__main__':
    main()
