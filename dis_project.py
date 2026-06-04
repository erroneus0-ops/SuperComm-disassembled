#!/usr/bin/env python3
"""
dis_project.py — Project-driven OS-9 6809 Disassembly Driver
=============================================================
Loads a project JSON file, runs the engine, writes annotated ASM.

Usage:
    python3 dis_project.py <project.json>          # disassemble
    python3 dis_project.py <project.json> --init   # scaffold new project
    python3 dis_project.py <project.json> --stats  # show label stats only

Project JSON fields (all optional except "binary"):
    binary          Path to OS-9 module binary
    output          Path for .asm output (default: binary + ".asm")
    entry           Hex string override for exec entry point
    module_notes    List of strings shown in file header comment
    custom_equates  List of extra EQU lines added after standard equates
    labels          {"HHHH": "LabelName", ...}  addr overrides
    bss             {"N": "BSS.Name", ...}  U-indexed BSS variable names
    data_regions    [{start, end, label, comment, format}, ...]
                    format: "auto" (default) | "fdb" | "raw"
    line_comments   {"HHHH": "comment text"}  added/appended to instruction
    block_comments  {"HHHH": ["line1", "line2"]}  emitted before instruction

See supercomm.json for a fully-annotated example.
"""

import sys, os, argparse, json

def main():
    parser = argparse.ArgumentParser(
        description='Project-driven OS-9 6809 disassembler')
    parser.add_argument('project',
        help='project JSON file')
    parser.add_argument('--init', action='store_true',
        help='scaffold a new project file for the binary named inside it')
    parser.add_argument('--stats', action='store_true',
        help='show pass-1 classification stats only, no output')
    parser.add_argument('--update-labels', action='store_true',
        help='add auto-generated labels back into the project JSON '
             '(preserves existing names, adds only new ones)')
    args = parser.parse_args()

    # ── Import engine ─────────────────────────────────────────────────────
    here = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, here)
    try:
        from dis6809_os9_engine import Engine, Project, KIND_CODE, KIND_DATA
    except ImportError as e:
        print(f"ERROR: cannot import dis6809_os9_engine: {e}", file=sys.stderr)
        print(f"  Make sure dis6809_os9_engine.py is in {here}", file=sys.stderr)
        sys.exit(1)

    # ── --init: create scaffold ───────────────────────────────────────────
    if args.init:
        if os.path.exists(args.project):
            # Load the binary path from an existing minimal file
            with open(args.project) as f:
                d = json.load(f)
            binary = d.get('binary', '')
        else:
            # Create a minimal file pointing at a binary with the same stem
            stem = os.path.splitext(args.project)[0]
            binary = stem

        proj = Project.scaffold(binary, stem + '.asm'
                                if '.' not in os.path.basename(stem) else stem)
        proj.module_notes = [
            "Add notes about this module here.",
            "Run with --update-labels to populate labels from auto-detection.",
        ]
        proj.to_json(args.project)
        print(f"Scaffolded: {args.project}")
        return

    # ── Load project ──────────────────────────────────────────────────────
    if not os.path.exists(args.project):
        print(f"ERROR: project file not found: {args.project}", file=sys.stderr)
        print(f"  Run with --init to create a scaffold.", file=sys.stderr)
        sys.exit(1)

    proj = Project.from_json(args.project)

    if not proj.binary or not os.path.exists(proj.binary):
        print(f"ERROR: binary not found: {proj.binary!r}", file=sys.stderr)
        sys.exit(1)

    # ── Run engine ────────────────────────────────────────────────────────
    eng = Engine(proj)
    eng.load(open(proj.binary, 'rb').read())
    eng.run()   # pass 1

    # ── --stats ───────────────────────────────────────────────────────────
    if args.stats:
        labels  = eng.labels
        regions = eng.regions
        exec_off= eng.exec_off
        n_code  = sum(1 for k in regions.values() if k==KIND_CODE)
        n_data  = sum(1 for a,k in regions.items() if k==KIND_DATA and a>=exec_off)
        n_pre   = sum(1 for a,k in regions.items() if k==KIND_DATA and a< exec_off)
        print(f"Binary:         {proj.binary}")
        print(f"Module:         {eng.hdr['mod_name']}")
        print(f"Entry:          ${exec_off:04X}")
        print(f"Total labels:   {len(labels)}")
        print(f"  Code:         {n_code}")
        print(f"  Data (code):  {n_data}")
        print(f"  Data (pre):   {n_pre}")
        return

    # ── --update-labels: merge auto labels into project JSON ──────────────
    if args.update_labels:
        added = 0
        for addr, lbl in eng.labels.items():
            if addr not in proj.labels:
                proj.labels[addr] = lbl
                added += 1
        proj.to_json(args.project)
        print(f"Added {added} labels to {args.project}")
        return

    # ── Render and write ──────────────────────────────────────────────────
    asm = eng.render()

    out_path = proj.output or (proj.binary + '.asm')
    with open(out_path, 'w') as f:
        f.write(asm)
    print(f"Written: {out_path}  ({len(asm.splitlines())} lines)", file=sys.stderr)


if __name__ == '__main__':
    main()
