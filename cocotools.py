#!/usr/bin/env python3
"""
cocotools.py — CoCo Assembly and Disk Image Toolkit

Provides the tools needed to write, assemble, and run 6809 assembly
programs on a TRS-80 Color Computer (emulated via XRoar WASM).

No external dependencies.  Python 3.8+ required.

Commands:
  assemble  FILE.ASM [-o FILE.BIN] [--format decb|raw] [--dp N]
  makedsk   FILE.DSK FILE... [--name NAME] [--org ADDR]
  binin     FILE.BIN            Show info about a DECB .BIN file
  dskls     FILE.DSK            List files in a DSK image

Usage examples:
  python cocotools.py assemble GUESS.ASM -o GUESS.BIN
  python cocotools.py makedsk GAME.DSK GAME.BIN GAME.BAS
  python cocotools.py binin HELLO.BIN
  python cocotools.py dskls HELLO.DSK
"""

import sys
import os
import argparse

# Allow running from the repo root without installing
sys.path.insert(0, os.path.dirname(__file__))

from cocotools.lwasm import assemble as asm_assemble, AsmError
from cocotools.decb  import (
    Dsk, make_bin, parse_bin, infer_ftype,
    FTYPE_ML, FTYPE_BASIC, FTYPE_DATA, FTYPE_TEXT,
)


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

    source = open(src_path, 'r', encoding='utf-8', errors='replace').read()

    try:
        binary = asm_assemble(source, fmt=args.format, dp=args.dp)
    except AsmError as e:
        die(str(e))

    with open(out_path, 'wb') as f:
        f.write(binary)

    # Report
    if args.format == 'decb':
        try:
            segs, exec_addr = parse_bin(binary)
            total_code = sum(len(d) for _, d in segs)
            print(f"  assembled: {src_path}")
            print(f"  output:    {out_path}  ({len(binary)} bytes)")
            for load, data in segs:
                print(f"  segment:   load=${load:04X}  size={len(data)} bytes")
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
    p_asm = sub.add_parser('assemble', aliases=['asm'],
                            help='Assemble a .ASM file to DECB .BIN')
    p_asm.add_argument('source',           help='Source file (.ASM)')
    p_asm.add_argument('-o', '--output',   help='Output file (default: same name, .BIN)')
    p_asm.add_argument('--format',         choices=['decb', 'raw'], default='decb',
                       help='Output format (default: decb)')
    p_asm.add_argument('--dp',             type=lambda x: int(x, 0), default=0,
                       help='Initial direct page register (default: 0)')

    # makedsk
    p_dsk = sub.add_parser('makedsk',
                            help='Build a CoCo DSK image from files')
    p_dsk.add_argument('dsk',              help='Output DSK file')
    p_dsk.add_argument('files', nargs='+', help='Files to add to the disk')

    # binin
    p_bin = sub.add_parser('binin',
                            help='Show info about a DECB .BIN file')
    p_bin.add_argument('binfile',          help='DECB binary file')
    p_bin.add_argument('--hex', action='store_true',
                       help='Also show hex dump of code')

    # dskls
    p_ls  = sub.add_parser('dskls',
                            help='List files in a DSK image')
    p_ls.add_argument('dskfile',           help='DSK image file')

    args = parser.parse_args()

    if args.command in ('assemble', 'asm'):
        cmd_assemble(args)
    elif args.command == 'makedsk':
        cmd_makedsk(args)
    elif args.command == 'binin':
        cmd_binin(args)
    elif args.command == 'dskls':
        cmd_dskls(args)


if __name__ == '__main__':
    main()
