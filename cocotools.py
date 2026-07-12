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
  dskdir     FILE.DSK

Usage examples:
  python cocotools.py assemble HELLO.ASM
  python cocotools.py assemble HELLO.ASM -o HELLO.BIN -- -b $3F00
  python cocotools.py makedsk GAME.DSK GAME.BIN GAME.BAS
  python cocotools.py binfo HELLO.BIN -e
  python cocotools.py dskdir HELLO.DSK
"""

import sys
import os
import argparse

# ── Translation provenance ─────────────────────────────────────────────────────
# This toolkit is a faithful Python translation of lwasm from LWTools.
# If lwasm behavior changes in a future version, the translation must be
# updated to match -- not "improved" independently.
LWASM_BASE_VERSION = "4.24"
LWASM_BASE_DATE    = "2024"          # approximate -- latest at time of translation
COCOTOOLS_VERSION  = "1.0-dev"
UPSTREAM_URL       = "https://www.lwtools.ca/"

# Allow running from the repo root without installing
sys.path.insert(0, os.path.dirname(__file__))

from cocotools.lwasm_types import OUTPUT_DECB, OUTPUT_RAW, FLAG_LIST, FLAG_SYMDUMP, \
                                   FLAG_SYMBOLS, FLAG_SYMBOLS_NOLOCALS
from cocotools.lwasm_core  import AsmState
from cocotools.input_system import InputSystem
from cocotools.pass1        import do_pass1
from cocotools.passes       import assemble as _run_passes, collect_decb_bytes, _collect_raw
from cocotools.decb  import (
    Dsk, DskError, make_bin, parse_bin, infer_ftype,
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
      -I / --include DIR    Add directory to include search path
      -I / --include DIR    Add directory to include search path
      -D / --define SYM[=VAL]  Pre-define a symbol (default value: 1)
      -9 / --6809           6809-only mode
      -3 / --6309           Enable HD6309 instruction set (default)
      --6800compat           Enable 6800 compatibility instructions
    """
    from cocotools.lwasm_types import PRAGMA_6809


    i = 0
    # strip leading -- separator if present
    if flags and flags[0] == '--':
        i = 1

    while i < len(flags):
        f = flags[i]

        if f in ('-I', '--include', '--includedir'):
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

        elif f in ('-9', '--6809'):
            as_.pragmas &= ~PRAGMA_6809

        elif f in ('-3', '--6309'):
            from cocotools.lwasm_types import PRAGMA_6809
            as_.pragmas &= ~PRAGMA_6809   # already default; ensure cleared

        elif f in ('--6800compat',):
            from cocotools.lwasm_types import PRAGMA_6800COMPAT
            as_.pragmas |= PRAGMA_6800COMPAT

        elif f in ('-l', '--list'):
            as_.flags |= FLAG_LIST
            i += 1
            if i < len(flags) and (flags[i] == '-' or not flags[i].startswith('-')):
                as_.list_file = flags[i]
            else:
                as_.list_file = '-'   # stdout
                i -= 1

        elif f in ('-s', '--symbols'):
            as_.flags |= FLAG_SYMBOLS

        elif f in ('--symbols-nolocals',):
            as_.flags |= FLAG_SYMBOLS_NOLOCALS

        elif f in ('--symbol-dump',):
            as_.flags |= FLAG_SYMDUMP
            i += 1
            if i < len(flags) and (flags[i] == '-' or not flags[i].startswith('-')):
                as_.symbol_dump_file = flags[i]
            else:
                as_.symbol_dump_file = '-'
                i -= 1

        elif f in ('--list-nofiles',):
            as_.listnofile = 1

        elif f in ('-t', '--tabs'):
            i += 1
            if i < len(flags):
                try:
                    as_.tabwidth = int(flags[i])
                except ValueError:
                    die(f"invalid tab width: {flags[i]}")

        elif f in ('-p', '--pragma'):
            i += 1
            # pragma handling is a stub — pragmas are complex
            if i < len(flags):
                print(f"  note: --pragma not yet fully implemented", file=sys.stderr)

        else:
            print(f"  note: assembler flag '{f}' not supported, ignored",
                  file=sys.stderr)

        i += 1

    return


def _parse_addr(s):
    """Parse $XXXX, 0xXXXX, or decimal address string to int."""
    s = s.strip()
    if s.startswith('$'):
        return int(s[1:], 16)
    if s.lower().startswith('0x'):
        return int(s[2:], 16)
    return int(s, 0)


# ─────────────────────────────────────────────────────────────────────────────
# Post-processor  (-pp key=val,key=val,...)
# ─────────────────────────────────────────────────────────────────────────────

def _parse_pp(pp_str):
    """
    Parse -pp argument string into a dict of post-processor options.

    Supported keys (aliases accepted):
      b=ADDR  / load=ADDR    Set load address (patches DECB preamble)
      e=ADDR  / exec=ADDR    Set exec address (patches DECB postamble)

    Address values: $3F00, 0x3F00, or decimal.

    Example: -pp b=$3F00,e=$3F10
             -pp load=$3F00,exec=$3F00
    """
    opts = {}
    for pair in pp_str.split(','):
        pair = pair.strip()
        if not pair:
            continue
        if '=' not in pair:
            die(f"-pp: expected key=value, got '{pair}'")
        key, val = pair.split('=', 1)
        key = key.strip().lower()
        val = val.strip()
        try:
            addr = _parse_addr(val)
        except ValueError:
            die(f"-pp: invalid address '{val}' for key '{key}'")

        if key in ('b', 'load'):
            opts['load'] = addr
        elif key in ('e', 'exec'):
            opts['exec'] = addr
        else:
            die(f"-pp: unknown key '{key}'")

    return opts


def _apply_pp(binary, pp_opts):
    """
    Apply post-processor options to a DECB binary.
    Returns modified bytes.
    """
    if not pp_opts:
        return binary

    data = bytearray(binary)
    load_addr = pp_opts.get('load')
    exec_addr = pp_opts.get('exec')

    pos = 0
    while pos < len(data) - 4:
        if data[pos] == 0xFF:
            # Postamble
            if exec_addr is not None:
                data[pos+3] = (exec_addr >> 8) & 0xFF
                data[pos+4] =  exec_addr       & 0xFF
            elif load_addr is not None and 'exec' not in pp_opts:
                # If only load specified, set exec to match
                data[pos+3] = (load_addr >> 8) & 0xFF
                data[pos+4] =  load_addr       & 0xFF
            break
        if data[pos] != 0x00:
            break
        seg_len = (data[pos+1] << 8) | data[pos+2]
        if load_addr is not None:
            data[pos+3] = (load_addr >> 8) & 0xFF
            data[pos+4] =  load_addr       & 0xFF
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
    if hasattr(args, 'asm_flags') and args.asm_flags:
        _parse_asm_flags(as_, args.asm_flags)

    # Parse post-processor options
    pp_opts = {}
    if hasattr(args, 'pp') and args.pp:
        pp_opts = _parse_pp(args.pp)

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

    # Generate listing if requested
    if as_.flags & FLAG_LIST:
        from cocotools.listing import do_list
        do_list(as_, as_.list_file)

    # Generate symbol dump if requested
    if as_.flags & FLAG_SYMDUMP:
        from cocotools.listing import do_symdump
        do_symdump(as_, as_.symbol_dump_file)

    if args.format == 'decb':
        binary = collect_decb_bytes(as_)
        if pp_opts:
            binary = _apply_pp(binary, pp_opts)
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
            if pp_opts:
                applied = ', '.join(f"{k}=${v:04X}" for k,v in pp_opts.items())
                print(f"  post-proc: {applied}")
            print(f"  exec:      ${exec_addr:04X}" if exec_addr else "  exec:      (none)")
        except Exception:
            print(f"  assembled {src_path} -> {out_path}  ({len(binary)} bytes)")
    else:
        print(f"  assembled {src_path} -> {out_path}  ({len(binary)} bytes)")


# ─────────────────────────────────────────────────────────────────────────────
# makerom command
# ─────────────────────────────────────────────────────────────────────────────

ROM_SIZE = 8192   # Standard CoCo cartridge ROM size
ROM_FILL = 0x12   # NOP -- safe padding if CPU wanders into unused space

def cmd_makerom(args):
    raw_path = args.raw
    rom_path = args.rom

    if not os.path.isfile(raw_path):
        die(f"file not found: {raw_path}")

    data = open(raw_path, 'rb').read()

    if len(data) > ROM_SIZE:
        die(f"raw binary is {len(data)} bytes -- exceeds 8K ROM size ({ROM_SIZE} bytes)")

    if os.path.isfile(rom_path) and not args.overwrite:
        answer = input(f"{rom_path} already exists. Overwrite? (y/N): ").strip().lower()
        if answer != 'y':
            print("Cancelled.")
            return

    padded = data + bytes([ROM_FILL] * (ROM_SIZE - len(data)))

    with open(rom_path, 'wb') as f:
        f.write(padded)

    print(f"  input:   {raw_path}  ({len(data)} bytes)")
    print(f"  padded:  {ROM_SIZE - len(data)} bytes of NOP (\\$12)")
    print(f"  written: {rom_path}  ({ROM_SIZE} bytes)")


# makedsk command
# ─────────────────────────────────────────────────────────────────────────────

def cmd_makedsk(args):
    dsk_path = args.dsk

    if os.path.isfile(dsk_path) and not args.overwrite:
        answer = input(f"{dsk_path} already exists. Overwrite? (y/N): ").strip().lower()
        if answer != 'y':
            print("Cancelled.")
            return

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
        notes.append("all checks passed")

    print()
    print("  extended information:")
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
# dskget command  (extract a file from a DSK image)
# ─────────────────────────────────────────────────────────────────────────────

def cmd_dskget(args):
    dsk_path  = args.dskfile
    coco_path = args.cocofile    # format: NAME.EXT
    out_path  = args.output

    if not os.path.isfile(dsk_path):
        die(f"file not found: {dsk_path}")

    # Parse CoCo filename
    parts = coco_path.upper().split('.')
    name  = parts[0]
    ext   = parts[1] if len(parts) > 1 else ''

    if out_path is None:
        out_path = coco_path   # write to current directory with same name

    data = open(dsk_path, 'rb').read()
    try:
        dsk = Dsk.from_bytes(data)
    except Exception as e:
        die(str(e))

    try:
        file_data, ftype, ascii_flag = dsk.read_file(name, ext)
    except DskError as e:
        die(str(e))

    # Apply token translation if requested or if ASCII file
    if args.translate:
        if ascii_flag:
            # Already ASCII — just decode, normalise line endings
            file_data = bytes(file_data).replace(b'\r', b'\n').strip(b'\n') + b'\n'
        else:
            # Tokenized binary — detokenize to ASCII
            from cocotools.decb import detoken_basic
            file_data = detoken_basic(file_data).encode('ascii', errors='replace') + b'\n'

    if os.path.isfile(out_path) and not args.overwrite:
        answer = input(f"{out_path} already exists. Overwrite? (y/N): ").strip().lower()
        if answer != 'y':
            print("Cancelled.")
            return

    with open(out_path, 'wb') as f:
        f.write(file_data)

    FTYPE_NAMES = {0: 'BASIC', 1: 'DATA', 2: 'ML', 3: 'TEXT'}
    tname = FTYPE_NAMES.get(ftype, f'?{ftype}')
    print(f"  extracted: {name}.{ext}  ({len(file_data)} bytes, type={tname})")
    print(f"  output:    {out_path}")

FTYPE_NAMES = {0: 'BASIC', 1: 'DATA', 2: 'ML', 3: 'TEXT'}

def cmd_dskdir(args):
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

_ASM_HELP = """\
usage: cocotools assemble [options] SOURCE

options:
  -o FILE            Output file (default: source name with .BIN)
  --format TYPE      Output format: decb (default) or raw
  -pp KEY=VAL,...    Post-processor options (see below)
  --                 Pass remaining arguments to the assembler
  -? / --help        Show this help

post-processor options (-pp):
  b=ADDR / load=ADDR    Set load address in DECB preamble
  e=ADDR / exec=ADDR    Set exec address in DECB postamble

assembler flags (after --):
  use:  python cocotools.py asm -- --help
  or:   python cocotools.py asm -- -?

examples:
  python cocotools.py assemble HELLO.ASM
  python cocotools.py assemble HELLO.ASM -o HELLO.BIN
  python cocotools.py assemble HELLO.ASM -pp b=$3F00
  python cocotools.py assemble HELLO.ASM -pp load=$3F00,exec=$3F10
  python cocotools.py assemble HELLO.ASM -pp b=$3F00 -- -I ./include
  python cocotools.py assemble HELLO.ASM --format raw -o HELLO.RAW
"""

_LWASM_HELP = """\
assembler flags (passed after --):
  -3, --6309                  Set assembler to 6309 mode (default)
      --6800compat            Enable 6800 compatibility instructions,
                              equivalent to --pragma=6800compat
  -9, --6809                  Set assembler to 6809 only mode
  -d, --debug[=LEVEL]         Set debug mode
  -b, --decb                  Generate DECB .bin format output
  -D, --define=SYM[=VAL]      Automatically define SYM to be VAL (or 1)
      --depend                Output dependency list to stdout
      --dependnoerr           Output dependency list; don't bail on missing includes
  -f, --format=TYPE           Output format: decb, basic, raw, obj, os9,
                              ihex, srec, dragon, abs
  -I, --includedir=PATH       Add entry to include path
  -l, --list[=FILE]           Generate listing [to FILE, default stdout]
      --list-nofiles          Omit file names in list output
  -m, --map[=FILE]            Generate map [to FILE]
      --no-output             Inhibit creation of output file
      --no-warn=FLAG          Suppress warnings of the specified type
      --obj                   Generate object file format for linking
  -o, --output=FILE           Output to FILE
  -p, --pragma=PRAGMA         Set assembler pragma
  -P, --preprocess            Preprocess and output revised source to stdout
  -r, --raw                   Generate raw binary format output
      --symbol-dump[=FILE]    Dump global symbol table in assembly format
  -s, --symbols               Generate symbol list in listing
      --symbols-nolocals      Same as --symbols but ignore local labels
  -t, --tabs=WIDTH            Set tab spacing in listing
  -?, --help                  Show this help
"""

def main():
    # Pre-process argv before argparse sees it
    argv = sys.argv[1:]

    # Split at -- first
    if '--' in argv:
        split_at       = argv.index('--')
        cocotools_argv = argv[:split_at]
        asm_flags      = argv[split_at+1:]
    else:
        cocotools_argv = argv
        asm_flags      = []

    # asm -- --help / asm -- -?  →  lwasm flag reference
    if asm_flags and asm_flags[0] in ('--help', '-?'):
        print(_LWASM_HELP)
        sys.exit(0)

    # asm --  (bare separator, nothing after)  →  cocotools assemble help
    if '--' in argv and not asm_flags:
        print(_ASM_HELP)
        sys.exit(0)

    # asm -?  →  cocotools assemble help
    if len(cocotools_argv) >= 1 and cocotools_argv[0] in ('asm', 'assemble'):
        if '-?' in cocotools_argv:
            print(_ASM_HELP)
            sys.exit(0)

    parser = argparse.ArgumentParser(
        prog='cocotools',
        description='CoCo 6809 assembly and disk image toolkit',
    )
    sub = parser.add_subparsers(dest='command', required=True)

    # assemble
    _asm_epilog = """\
post-processor options (-pp key=value,...):
  b=ADDR  / load=ADDR    Set load address in DECB preamble
  e=ADDR  / exec=ADDR    Set exec address in DECB postamble
  (aliases b/load and e/exec are equivalent)

assembler flags (passed after --):
  -I / --includedir DIR   Add directory to include file search path
  -D / --define SYM[=VAL] Pre-define a symbol (default value: 1)
  -9 / --6809             6809-only mode
  -3 / --6309             Enable HD6309 instruction set (default)
  --6800compat            Enable 6800 compatibility instructions
  -p / --pragma PRAGMA    Set assembler pragma

examples:
  python cocotools.py assemble HELLO.ASM
  python cocotools.py assemble HELLO.ASM -o HELLO.BIN
  python cocotools.py assemble HELLO.ASM -pp b=$3F00
  python cocotools.py assemble HELLO.ASM -pp load=$3F00,exec=$3F10
  python cocotools.py assemble HELLO.ASM -pp b=$3F00 -- -I ./include
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
    p_asm.add_argument('-pp',              metavar='KEY=VAL,...',
                       help='Post-processor options (e.g. -pp b=$3F00,e=$3F00)')

    # about
    sub.add_parser('about',
        help='Show version and upstream translation provenance')

    # makerom
    p_rom = sub.add_parser('makerom',
                            help='Pad a raw binary to 8K CoCo cartridge ROM image')
    p_rom.add_argument('raw',              help='Raw binary input file')
    p_rom.add_argument('rom',              help='Output ROM file (padded to 8192 bytes)')
    p_rom.add_argument('-o', '--overwrite', action='store_true',
                       help='Overwrite existing ROM file without prompting')

    # makedsk
    p_dsk = sub.add_parser('makedsk',
                            help='Build a CoCo DSK image from files')
    p_dsk.add_argument('dsk',              help='Output DSK file')
    p_dsk.add_argument('files', nargs='+', help='Files to add to the disk')
    p_dsk.add_argument('-o', '--overwrite', action='store_true',
                       help='Overwrite existing disk image without prompting')

    # binfo
    p_bin = sub.add_parser('binfo',
                            help='Show info about a DECB .BIN file')
    p_bin.add_argument('binfile',          help='DECB binary file')
    p_bin.add_argument('--hex', action='store_true',
                       help='Show hex dump of code')
    p_bin.add_argument('-e', '--enhanced', action='store_true',
                       help='Show extended information (memory regions, unusual patterns)')

    # dskget
    p_get = sub.add_parser('dskget',
                            help='Extract a file from a DSK image')
    p_get.add_argument('dskfile',          help='DSK image file')
    p_get.add_argument('cocofile',         help='File to extract (NAME.EXT)')
    p_get.add_argument('-o', '--output',   help='Output file (default: same name)')
    p_get.add_argument('-t', '--translate', action='store_true',
                       help='Translate BASIC tokens to ASCII text on extraction')
    p_get.add_argument('--overwrite', action='store_true',
                       help='Overwrite existing file without prompting')

    # dskdir
    p_ls  = sub.add_parser('dskdir',
                            help='List files in a DSK image')
    p_ls.add_argument('dskfile',           help='DSK image file')

    args = parser.parse_args(cocotools_argv)
    args.asm_flags = asm_flags

    if args.command == 'about':
        print(f"cocotools {COCOTOOLS_VERSION}")
        print(f"Python translation of lwasm {LWASM_BASE_VERSION} (LWTools, William Astle, GPL v3)")
        print(f"Upstream: {UPSTREAM_URL}")
        print()
        print("Translation fidelity: faithful reproduction of lwasm behavior,")
        print("bugs and all, to survive lwasm updates cleanly.")
        print("Diagnostics (W2000, W2001) are separate from the translation layer.")
        print()
        print(f"Upstream status last checked: July 2026")
        print(f"  lwasm core: unchanged since {LWASM_BASE_VERSION}")
        print(f"  Recent LWTools activity: GCC 6809 backend additions (not lwasm core)")
        return

    if args.command in ('assemble', 'asm'):
        cmd_assemble(args)
    elif args.command == 'makerom':
        cmd_makerom(args)
    elif args.command == 'makedsk':
        cmd_makedsk(args)
    elif args.command == 'binfo':
        cmd_binin(args)
    elif args.command == 'dskget':
        cmd_dskget(args)
    elif args.command == 'dskdir':
        cmd_dskdir(args)


if __name__ == '__main__':
    main()
