#!/usr/bin/env python3
"""
dis_project.py — Project-driven OS-9 6809 Disassembly Driver
=============================================================
Loads a project JSON file, runs the engine, writes annotated ASM.

First run (no JSON exists yet):
    python3 dis_project.py supercomm22

    The script detects that supercomm22_proj.json does not exist,
    creates a scaffold JSON with binary CRC recorded, then disassembles.

Subsequent runs:
    python3 dis_project.py supercomm22_proj.json

    The script verifies the binary CRC matches the JSON. If it does not
    match, it offers to create a new JSON importing analyst work from the
    old one.

Options:
    --stats         Show pass-1 classification stats only, no output
    --update-labels Add auto-generated labels back into the project JSON
"""

import sys, os, argparse, json, shutil

def main():
    parser = argparse.ArgumentParser(
        description='Project-driven OS-9 6809 disassembler')
    parser.add_argument('project',
        help='Binary file (first run) or project JSON file')
    parser.add_argument('--stats', action='store_true',
        help='Show pass-1 classification stats only, no output')
    parser.add_argument('--update-labels', action='store_true',
        help='Add auto-generated labels back into the project JSON '
             '(preserves existing names, adds only new ones)')
    args = parser.parse_args()

    # ── Import engine ─────────────────────────────────────────────────────
    here = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, here)
    try:
        from dis6809_os9_engine import Engine, Project, KIND_CODE, KIND_DATA, binary_crc
    except ImportError as e:
        print(f"ERROR: cannot import dis6809_os9_engine: {e}", file=sys.stderr)
        sys.exit(1)

    # ── Resolve project path ──────────────────────────────────────────────
    arg = args.project

    if arg.endswith('.json'):
        json_path = arg
    else:
        # Argument is a binary path — infer JSON path
        stem = arg
        if stem.endswith('_proj'):
            stem = stem[:-5]
        json_path = stem + '_proj.json'

    # ── First run: create scaffold if JSON doesn't exist ─────────────────
    if not os.path.exists(json_path):
        # Determine binary path from argument
        binary_path = arg if not arg.endswith('.json') else None
        if binary_path is None:
            # JSON path given but doesn't exist — infer binary from stem
            binary_path = os.path.splitext(json_path)[0]
            if binary_path.endswith('_proj'):
                binary_path = binary_path[:-5]

        if not os.path.exists(binary_path):
            print(f"ERROR: binary not found: {binary_path!r}", file=sys.stderr)
            print(f"  Looked for JSON: {json_path}", file=sys.stderr)
            sys.exit(1)

        print(f"No project file found. Creating: {json_path}")
        stem = os.path.splitext(json_path)[0]
        if stem.endswith('_proj'):
            stem = stem[:-5]
        proj = Project.scaffold(binary_path, stem + '_proj.asm')
        proj.to_json(json_path)
        print(f"  Binary CRC: {proj.binary_crc}")
        print(f"  Output:     {proj.output}")
        print()

    # ── Load project ──────────────────────────────────────────────────────
    proj = Project.from_json(json_path)

    if not proj.binary or not os.path.exists(proj.binary):
        print(f"ERROR: binary not found: {proj.binary!r}", file=sys.stderr)
        sys.exit(1)

    # ── CRC verification ──────────────────────────────────────────────────
    actual_crc = binary_crc(proj.binary)

    if proj.binary_crc is None:
        # Old JSON without CRC — update it silently
        proj.binary_crc = actual_crc
        proj.to_json(json_path)
        print(f"; CRC recorded: {actual_crc}  (added to {json_path})",
              file=sys.stderr)

    elif proj.binary_crc.upper() != actual_crc.upper():
        print()
        print(f"  WARNING: Binary CRC mismatch")
        print(f"    JSON was created for: {proj.binary}")
        print(f"      Recorded CRC:       {proj.binary_crc.upper()}")
        print(f"      Current binary CRC: {actual_crc.upper()}")
        print()
        print("  Options:")
        print("    [1] Create new JSON importing analyst work from old JSON")
        print("    [2] Proceed with old JSON anyway (output may be incorrect)")
        print("    [3] Abort")
        print()

        try:
            choice = input("  Choice [1/2/3]: ").strip()
        except (EOFError, KeyboardInterrupt):
            choice = '3'

        if choice == '1':
            proj = _import_project(proj, json_path, actual_crc)
            # json_path now points to the new JSON
            json_path = proj._json_path

        elif choice == '2':
            print("  Proceeding with mismatched JSON.", file=sys.stderr)

        else:
            print("  Aborted.", file=sys.stderr)
            sys.exit(0)

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
        print(f"; Pass 1: {len(labels)} labels  ({n_code} code  {n_data} data in code section)",
              file=sys.stderr)
        print(f"Binary:         {proj.binary}")
        print(f"Module:         {eng.hdr['mod_name']}")
        print(f"Entry:          ${exec_off:04X}")
        print(f"Total labels:   {len(labels)}")
        print(f"  Code:         {n_code}")
        print(f"  Data (code):  {n_data}")
        print(f"  Data (pre):   {n_pre}")
        return

    # ── --update-labels ───────────────────────────────────────────────────
    if args.update_labels:
        added = 0
        for addr, lbl in eng.labels.items():
            if addr not in proj.labels:
                proj.labels[addr] = lbl
                added += 1
        proj.to_json(json_path)
        print(f"Added {added} labels to {json_path}")
        return

    # ── Render and write ──────────────────────────────────────────────────
    asm = eng.render()

    out_path = proj.output or (proj.binary + '_proj.asm')
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(asm)
    print(f"Written: {out_path}  ({len(asm.splitlines())} lines)", file=sys.stderr)


def _import_project(old_proj, old_json_path, new_crc):
    """
    Create a new project JSON for the same binary, importing analyst work
    from the old JSON. Fields that are binary-specific are not carried over.

    Returns the new Project object with _json_path set.
    """
    from dis6809_os9_engine import Project

    # Derive new JSON path from binary name
    binary = old_proj.binary
    stem   = binary
    if '_restored' not in stem and '_patched' not in stem:
        # Add _new suffix to avoid overwriting old JSON
        base, ext = os.path.splitext(old_json_path)
        new_json = base + '_new' + ext
    else:
        stem_clean = os.path.splitext(stem)[0]
        if stem_clean.endswith('_proj'):
            stem_clean = stem_clean[:-5]
        new_json = stem_clean + '_proj.json'

    print(f"\n  Creating new project: {new_json}")
    print(f"  Importing from:       {old_json_path}")
    print()

    new = Project.scaffold(binary, old_proj.output)
    new.binary_crc = new_crc

    # ── Fields that carry over cleanly ────────────────────────────────────
    new.cpu           = old_proj.cpu
    new.module_notes  = old_proj.module_notes
    new.custom_equates= old_proj.custom_equates
    new.labels        = dict(old_proj.labels)
    new.bss           = dict(old_proj.bss)
    new.line_comments = dict(old_proj.line_comments)
    new.block_comments= dict(old_proj.block_comments)
    new.data_regions  = list(old_proj.data_regions)
    new.routines      = list(old_proj.routines)

    # ── Substitutions: carry over with warning ────────────────────────────
    if old_proj.substitutions:
        new.substitutions = dict(old_proj.substitutions)
        print(f"  WARNING: {len(old_proj.substitutions)} substitution(s) imported.")
        print(f"    These reference specific binary bytes — verify they still")
        print(f"    apply to the new binary before assembling.")
        print()

    # ── Fields that do NOT carry over ─────────────────────────────────────
    # forced_equs: workarounds for binary corruption — not valid for new binary
    # patches:     binary-specific byte insertions — not valid for new binary
    if old_proj.forced_equs:
        print(f"  NOTE: {len(old_proj.forced_equs)} forced_equ(s) NOT imported")
        print(f"    (binary corruption workarounds — may not apply to new binary)")
        print()
    if old_proj.patches:
        print(f"  NOTE: {len(old_proj.patches)} patch(es) NOT imported")
        print(f"    (binary-specific — may not apply to new binary)")
        print()

    # Backup old JSON
    backup = old_json_path + '.bak'
    shutil.copy2(old_json_path, backup)
    print(f"  Old JSON backed up to: {backup}")

    new.to_json(new_json)
    print(f"  New JSON written:      {new_json}")
    print()

    new._json_path = new_json
    return new


if __name__ == '__main__':
    main()
