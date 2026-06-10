#!/usr/bin/env python3
"""
edits_to_json.py — Analyst directive processor for disassembly projects.

Reads analyst directives embedded in a proj.asm file and updates the
corresponding proj.json with the changes. Safe to run multiple times
(idempotent). Does not modify the proj.asm file — directives remain
visible until the analyst regenerates from the disassembler.

Usage:
    python3 edits_to_json.py appname_proj.asm [appname_proj.json]

If the JSON path is not specified, it is inferred from the ASM filename
by replacing _proj.asm with _proj.json (or .asm → .json).

Directive syntax (all directives begin with / in column 1):

    /label/ Name
        Assigns Name to the address of the next non-directive line.
        If that address already has a name in the JSON, it is replaced.

    /comment/
    Line one of comment.
    Line two of comment.
    /end-comment/
        Adds a block comment above the address of the next non-directive line.

    /; comment text/
        Appended to end of a listing line — sets the inline comment for
        that line's address. Replaces any existing line_comment for that addr.
        Example:
            $0BCC  30 8D F4 9F   LEAX Dat_006F,PC  /; load splash block into X/

    /replace/
    <original disassembler lines>
    /with/
    <replacement source lines>
    /end-replace/
        Records a substitution at the address of the first line in the
        /replace/ block. The replacement lines are stored verbatim and
        emitted by the disassembler in place of the original bytes.

    /end-label/
        Marks the current position as the end of the preceding named data
        region. Adds end_label:true to that data_region entry and emits
        a <label>end label at this address on future disassembly runs.

    /format/ formatname
        Sets the rendering format for the current data region.
        Known formats: auto, fdb, raw, writeblock, iwrite.

    /region-comment/
    Comment text.
    /end-region-comment/
        Sets the descriptive comment for the current data region.

    /routine/ Name
        Declares the start of a named routine at the next address.
        All anonymous Sub_XXXX labels between this and /routine-end/
        are renamed Name_01, Name_02, etc. in address order.
        Analyst-assigned labels within the range are left untouched.

    /routine-end/ Name
        Declares the last instruction of the named routine at the
        current address. Emits a <Name>end label at this address.
"""

import json
import re


def _count_data_bytes(lines):
    """Count binary bytes represented by a list of FCB/FCC/FDB/FCS lines."""
    total = 0
    for line in lines:
        s = line.strip()
        if not s or s.startswith(';'):
            continue
        if ';' in s:
            s = s[:s.index(';')].strip()
        upper = s.upper()
        if upper.startswith('FCB'):
            args = s[3:].strip()
            total += len([a for a in args.split(',') if a.strip()])
        elif upper.startswith('FDB'):
            args = s[3:].strip()
            total += 2 * len([a for a in args.split(',') if a.strip()])
        elif upper.startswith('FCC') or upper.startswith('FCS'):
            m = re.search(r'["\'](.+?)["\']', s)
            if m:
                total += len(m.group(1))
        elif upper.startswith('RMB'):
            try:
                total += int(s[3:].strip())
            except ValueError:
                pass
    return total
import sys
import os
from collections import defaultdict

# ── Address extraction ────────────────────────────────────────────────────────

ADDR_RE = re.compile(r'^\$([0-9A-Fa-f]{4})\s')
LABEL_LINE_RE = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)\s*$')

def extract_addr(line):
    """Extract hex address from a listing line like '$0BCC  30 8D ...'"""
    m = ADDR_RE.match(line)
    return int(m.group(1), 16) if m else None

def extract_inline_directive(line):
    """Extract /; comment/ from end of a listing line. Returns (clean_line, comment) or (line, None)."""
    m = re.search(r'\s*/;(.+?)/$', line)
    if m:
        clean = line[:m.start()].rstrip()
        return clean, m.group(1).strip()
    return line, None

def next_addr_from_lines(lines, start_idx):
    """Find the address of the next non-directive line from start_idx."""
    for i in range(start_idx, len(lines)):
        line = lines[i].rstrip()
        if line.startswith('/'):
            continue
        addr = extract_addr(line)
        if addr is not None:
            return addr
    return None

def current_data_label(lines, directive_idx):
    """
    Scan backward from directive_idx to find the most recent bare data label.
    Returns the label string or None.
    """
    for i in range(directive_idx - 1, -1, -1):
        line = lines[i].rstrip()
        if line.startswith('/'):
            continue
        if line.startswith(';') or line == '':
            continue
        # Bare label: starts in col 0, no $ address prefix, no leading whitespace
        if LABEL_LINE_RE.match(line):
            return line.strip()
        # If we hit an address line, stop
        if ADDR_RE.match(line):
            break
    return None

# ── Auto-generated label detection ───────────────────────────────────────────

AUTO_LABEL_RE = re.compile(r'^(Sub|Dat|Insn)_[0-9A-Fa-f]{4}$')

def is_auto_label(name):
    return bool(AUTO_LABEL_RE.match(name))

# ── Main parser ───────────────────────────────────────────────────────────────

def parse_directives(lines, json_path=None):
    """
    Two-pass parse:
      Pass 1 — collect routine boundaries
      Pass 2 — process all directives in order

    Returns a dict of changes to apply to the JSON.
    """

    changes = {
        'labels':          {},   # addr -> name
        'block_comments':  {},   # addr -> [lines]
        'line_comments':   {},   # addr -> text
        'substitutions':   {},   # addr -> {replace_bytes, with_lines}
        'data_regions':    [],   # list of {start, end?, label?, end_label?, format?, comment?}
        'routines':        [],   # list of {name, start, end}
        'warnings':        [],   # list of warning strings
    }

    # ── Pass 1: collect routine boundaries ───────────────────────────────────
    routine_stack = {}   # name -> start_addr
    routine_ends  = []   # list of (name, start_addr, end_addr)

    for idx, raw in enumerate(lines):
        line = raw.rstrip()
        if line.startswith('/routine-end/'):
            name = line[len('/routine-end/'):].strip()
            addr = next_addr_from_lines(lines, idx + 1)
            # routine-end addr is the CURRENT address line, not the next one
            # scan backward for the nearest address line
            for j in range(idx - 1, -1, -1):
                a = extract_addr(lines[j].rstrip())
                if a is not None:
                    addr = a
                    break
            if name in routine_stack:
                start = routine_stack.pop(name)
                routine_ends.append({'name': name, 'start': start, 'end': addr})
                changes['routines'].append({'name': name, 'start': start, 'end': addr})
            else:
                changes['warnings'].append(
                    f"/routine-end/ '{name}' has no matching /routine/ — ignored")

        elif line.startswith('/routine/'):
            name = line[len('/routine/'):].strip()
            addr = next_addr_from_lines(lines, idx + 1)
            if addr is not None:
                routine_stack[name] = addr
                changes['labels'][addr] = name
            else:
                changes['warnings'].append(f"/routine/ '{name}' — could not find address")

    for name in routine_stack:
        changes['warnings'].append(f"/routine/ '{name}' has no matching /routine-end/")

    # ── Pass 2: all other directives ─────────────────────────────────────────
    i = 0
    current_addr = None

    # Build reverse lookup: label_name -> addr
    # Combines pass-1 discovered labels with existing JSON labels
    label_to_addr = {v: k for k,v in changes['labels'].items()}
    if json_path and os.path.exists(json_path):
        with open(json_path) as f:
            _d = json.load(f)
        for k,v in _d.get('labels',{}).items():
            label_to_addr[v] = int(k, 16)
        # Also build from auto-generated names visible in the listing
        # by scanning for Dat_XXXX / Sub_XXXX patterns
    # Additionally scan the listing itself for bare labels with addresses on nearby lines
    # Build label→address map from LEAX/LEAY/LEAU xref lines in the listing.
    # Pre-exec data labels have no $XXXX prefix on their own line, but
    # code that references them has lines like:
    #   $0BCC  30 8D F4 9F   LEAX Dat_006F,PC   ; X → Dat_006F
    # We extract the target label and look up the instruction's PC-relative target.
    # Simpler: parse "; X → Label" or "; Y → Label" comments which give us the label
    # name, then find the LEAX instruction's address and operand to compute target.
    # Even simpler: scan for lines where a known label appears as a bare label
    # preceded by an address in the LISTING hex dump format:
    # $HHHH  HH ...   Label:   mnemonic
    LABELED_INSN_RE = re.compile(
        r'^\$([0-9A-Fa-f]{4})\s+(?:[0-9A-Fa-f]{2}\s+)+\s*([A-Za-z_][A-Za-z0-9_]*):\s')
    # Also scan for xref comments: "; X → Label" or "; Y → Label"
    XREF_RE = re.compile(r';\s*[XYUS]\s*→\s*([A-Za-z_][A-Za-z0-9_]*)')
    # And LEAX/LEAY with PCR: $HHHH  30 8D xx xx   LEAX Label,PC
    LEAX_RE = re.compile(
        r'^\$([0-9A-Fa-f]{4})\s+3[0123] 8D ([0-9A-Fa-f]{2}) ([0-9A-Fa-f]{2})\s')

    listing_labels = {}

    for _idx, _raw in enumerate(lines):
        _line = _raw.rstrip()

        # Labeled instruction: $HHHH  xx xx  Label:  mnemonic
        m = LABELED_INSN_RE.match(_line)
        if m:
            listing_labels[m.group(2)] = int(m.group(1), 16)
            continue

        # LEAX/LEAY PC-relative — compute target from offset
        m = LEAX_RE.match(_line)
        if m:
            insn_addr = int(m.group(1), 16)
            hi = int(m.group(2), 16)
            lo = int(m.group(3), 16)
            raw_off = (hi << 8) | lo
            signed_off = raw_off - 0x10000 if raw_off >= 0x8000 else raw_off
            target = insn_addr + 4 + signed_off  # PC after 4-byte LEAX ,PCR
            # Find the label name from the xref comment on this line
            xm = XREF_RE.search(_line)
            if xm:
                lbl = xm.group(1)
                if lbl not in listing_labels:
                    listing_labels[lbl] = target

    label_to_addr.update(listing_labels)

    while i < len(lines):
        line = lines[i].rstrip()

        # Track current address from listing lines ($XXXX prefix)
        addr = extract_addr(line)
        if addr is not None:
            current_addr = addr

        # Also track from bare label lines (col 0, no $, known in label map)
        elif LABEL_LINE_RE.match(line):
            lbl = line.strip()
            if lbl in label_to_addr:
                current_addr = label_to_addr[lbl]

        # Inline /; comment/ directive
        clean, inline_cmt = extract_inline_directive(line)
        if inline_cmt is not None and current_addr is not None:
            changes['line_comments'][current_addr] = inline_cmt
            i += 1
            continue

        if not line.startswith('/'):
            i += 1
            continue

        # ── /label/ Name ─────────────────────────────────────────────────────
        if line.startswith('/label/'):
            name = line[len('/label/'):].strip()
            addr = next_addr_from_lines(lines, i + 1)
            if addr is not None:
                changes['labels'][addr] = name
            else:
                changes['warnings'].append(f"/label/ '{name}' — could not find address")

        # ── /comment/ ... /end-comment/ ──────────────────────────────────────
        elif line == '/comment/':
            comment_lines = []
            i += 1
            while i < len(lines) and lines[i].rstrip() != '/end-comment/':
                comment_lines.append(lines[i].rstrip())
                i += 1
            addr = next_addr_from_lines(lines, i + 1)
            if addr is not None:
                changes['block_comments'][addr] = comment_lines
            else:
                changes['warnings'].append("/comment/ block — could not find target address")

        # ── /replace/ ... /with/ ... /end-replace/ ───────────────────────────
        elif line == '/replace/':
            replace_lines = []
            i += 1
            while i < len(lines) and lines[i].rstrip() != '/with/':
                replace_lines.append(lines[i].rstrip())
                i += 1
            with_lines = []
            i += 1
            while i < len(lines) and lines[i].rstrip() != '/end-replace/':
                with_lines.append(lines[i].rstrip())
                i += 1
            # Determine start address from first line of replace block
            # Determine start address — first try lines in replace block,
            # then fall back to current_addr (for data lines without $ prefix)
            rep_addr = None
            for rl in replace_lines:
                rep_addr = extract_addr(rl)
                if rep_addr is not None:
                    break
            if rep_addr is None:
                rep_addr = current_addr  # fall back to address context before /replace/
            if rep_addr is not None:
                replace_count = _count_data_bytes(replace_lines)
                with_count    = _count_data_bytes(with_lines)
                if replace_count != with_count:
                    changes['warnings'].append(
                        f"/replace/ at ${rep_addr:04X} — size mismatch: "
                        f"/replace/ = {replace_count} bytes, /with/ = {with_count} bytes. "
                        f"This will break assembly.")
                changes['substitutions'][rep_addr] = {
                    'replace_lines': replace_lines,
                    'with_lines':    with_lines,
                }
            else:
                changes['warnings'].append("/replace/ block — could not determine address")

        # ── /end-label/ ──────────────────────────────────────────────────────
        elif line == '/end-label/':
            lbl = current_data_label(lines, i)
            if lbl:
                changes['data_regions'].append({
                    'action':     'end_label',
                    'label':      lbl,
                    'label_addr': label_to_addr.get(lbl),
                })
            else:
                changes['warnings'].append(
                    f"/end-label/ — could not find preceding data label")

        # ── /format/ name ────────────────────────────────────────────────────
        elif line.startswith('/format/'):
            fmt = line[len('/format/'):].strip()
            lbl = current_data_label(lines, i)
            if lbl:
                changes['data_regions'].append({
                    'action': 'format',
                    'label':  lbl,
                    'format': fmt,
                })
            else:
                changes['warnings'].append(f"/format/ '{fmt}' — could not find preceding data label")

        # ── /region-comment/ ... /end-region-comment/ ────────────────────────
        elif line == '/region-comment/':
            rc_lines = []
            i += 1
            while i < len(lines) and lines[i].rstrip() != '/end-region-comment/':
                rc_lines.append(lines[i].rstrip())
                i += 1
            lbl = current_data_label(lines, i)
            if lbl:
                changes['data_regions'].append({
                    'action':  'comment',
                    'label':   lbl,
                    'comment': '\n'.join(rc_lines),
                })
            else:
                changes['warnings'].append("/region-comment/ — could not find preceding data label")

        # ── /routine/ and /routine-end/ already handled in pass 1 ────────────
        elif line.startswith('/routine'):
            pass  # already processed

        else:
            changes['warnings'].append(f"Unknown directive: {line!r}")

        i += 1

    return changes

# ── Routine interior label auto-naming ───────────────────────────────────────

def apply_routine_naming(proj_labels, routines, warnings):
    """
    For each routine boundary, find all auto-generated labels within
    [start, end] that are not analyst-assigned, and rename them
    routinename_01, _02, etc. in address order.
    Returns updated labels dict.
    """
    labels = dict(proj_labels)

    for r in routines:
        name  = r['name']
        start = r['start']
        end   = r['end']

        # Collect auto-generated labels in range (exclusive of start and end
        # which are the routine entry/exit — already named)
        interior = sorted([
            addr for addr, lbl in labels.items()
            if start < addr < end and is_auto_label(lbl)
        ])

        for seq, addr in enumerate(interior, start=1):
            new_name = f"{name}_{seq:02d}"
            old_name = labels[addr]
            labels[addr] = new_name

    return labels

# ── JSON merger ───────────────────────────────────────────────────────────────

def merge_into_json(json_path, changes, warn):
    """Load existing JSON, apply changes, write back."""

    if os.path.exists(json_path):
        with open(json_path) as f:
            d = json.load(f)
    else:
        warn(f"JSON file not found: {json_path} — creating new")
        d = {}

    # ── labels ───────────────────────────────────────────────────────────────
    existing_labels = d.get('labels', {})
    for addr, name in changes['labels'].items():
        key = f'{addr:04X}'
        if key in existing_labels and existing_labels[key] != name:
            warn(f"Label at ${key} renamed: '{existing_labels[key]}' → '{name}'")
        existing_labels[key] = name
    d['labels'] = dict(sorted(existing_labels.items()))

    # ── block_comments ───────────────────────────────────────────────────────
    bc = d.get('block_comments', {})
    for addr, lines in changes['block_comments'].items():
        bc[f'{addr:04X}'] = lines
    d['block_comments'] = dict(sorted(bc.items()))

    # ── line_comments ────────────────────────────────────────────────────────
    lc = d.get('line_comments', {})
    for addr, text in changes['line_comments'].items():
        lc[f'{addr:04X}'] = text
    d['line_comments'] = dict(sorted(lc.items()))

    # ── substitutions ────────────────────────────────────────────────────────
    subs = d.get('substitutions', {})
    for addr, sub in changes['substitutions'].items():
        subs[f'{addr:04X}'] = {
            'replace_lines': sub['replace_lines'],
            'with':          sub['with_lines'],
        }
    d['substitutions'] = dict(sorted(subs.items()))

    # ── data_regions: apply end_label, format, comment actions ───────────────
    regions = d.get('data_regions', [])

    def find_region(label):
        for r in regions:
            if r.get('label') == label:
                return r
        return None

    def add_or_get_region(label):
        r = find_region(label)
        if r is None:
            r = {'label': label}
            regions.append(r)
        return r

    for action in changes['data_regions']:
        lbl = action['label']
        r   = add_or_get_region(lbl)
        if action['action'] == 'end_label':
            r['end_label'] = True
            if 'start' not in r and action.get('label_addr') is not None:
                r['start'] = f"{action['label_addr']:04X}"
        elif action['action'] == 'format':
            r['format'] = action['format']
        elif action['action'] == 'comment':
            r['comment'] = action['comment']

    d['data_regions'] = regions

    # ── routines ─────────────────────────────────────────────────────────────
    existing_routines = d.get('routines', [])
    for r in changes['routines']:
        # Replace existing entry with same name, or append
        replaced = False
        for j, er in enumerate(existing_routines):
            if er['name'] == r['name']:
                if er != {'name': r['name'], 'start': f"{r['start']:04X}", 'end': f"{r['end']:04X}"}:
                    warn(f"Routine '{r['name']}' boundary updated")
                existing_routines[j] = {
                    'name':  r['name'],
                    'start': f"{r['start']:04X}",
                    'end':   f"{r['end']:04X}",
                }
                replaced = True
                break
        if not replaced:
            existing_routines.append({
                'name':  r['name'],
                'start': f"{r['start']:04X}",
                'end':   f"{r['end']:04X}",
            })
    d['routines'] = existing_routines

    # ── write back ───────────────────────────────────────────────────────────
    with open(json_path, 'w') as f:
        json.dump(d, f, indent=2)

# ── Entry point ───────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print("Usage: edits_to_json.py appname_proj.asm [appname_proj.json]")
        sys.exit(1)

    asm_path  = sys.argv[1]
    if len(sys.argv) >= 3:
        json_path = sys.argv[2]
    else:
        # Infer JSON path from ASM path
        json_path = re.sub(r'_proj\.asm$', '_proj.json', asm_path)
        if json_path == asm_path:
            json_path = re.sub(r'\.asm$', '.json', asm_path)

    print(f"Reading:  {asm_path}")
    print(f"Updating: {json_path}")

    with open(asm_path, encoding='utf-8', errors='replace') as f:
        lines = f.readlines()

    warnings = []
    def warn(msg):
        warnings.append(msg)
        print(f"  WARNING: {msg}")

    # Parse directives
    changes = parse_directives(lines, json_path)

    # Report any parse warnings
    for w in changes['warnings']:
        warn(w)

    # Apply routine interior naming to existing + new labels
    if changes['routines']:
        # Load existing labels from JSON for context
        existing_labels = {}
        if os.path.exists(json_path):
            with open(json_path) as f:
                d = json.load(f)
            existing_labels = {int(k,16): v for k,v in d.get('labels',{}).items()}
        # Merge new labels in
        merged = {**existing_labels, **changes['labels']}
        # Apply routine naming
        merged = apply_routine_naming(merged, changes['routines'], warnings)
        # Put results back into changes (overrides)
        changes['labels'] = merged

    # Count meaningful changes
    n_labels  = len(changes['labels'])
    n_bc      = len(changes['block_comments'])
    n_lc      = len(changes['line_comments'])
    n_subs    = len(changes['substitutions'])
    n_regions = len(changes['data_regions'])
    n_routines= len(changes['routines'])

    # Merge into JSON
    merge_into_json(json_path, changes, warn)

    print()
    print("Changes applied:")
    print(f"  Labels:          {n_labels}")
    print(f"  Block comments:  {n_bc}")
    print(f"  Line comments:   {n_lc}")
    print(f"  Substitutions:   {n_subs}")
    print(f"  Data regions:    {n_regions}")
    print(f"  Routines:        {n_routines}")
    if warnings:
        print(f"  Warnings:        {len(warnings)}")
    print()
    print("Done. Run the disassembler to regenerate the proj.asm with changes applied.")

if __name__ == '__main__':
    main()
