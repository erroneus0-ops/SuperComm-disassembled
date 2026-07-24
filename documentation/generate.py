#!/usr/bin/env python3
"""
generate.py — 6809 Reference Manual HTML generator
Reads opcodes/*.json and produces HTML reference pages.

Usage:
    python generate.py [--output html]

========================================================================
JSON SCHEMA DOCUMENTATION
========================================================================

Each opcodes_<group>.json file has this top-level structure:
{
  "group":        string  -- matches GROUP_ORDER key (e.g. "load")
  "description":  string  -- one-line group description
  "instructions": [ ... ] -- list of instruction objects (see below)
}

Each instruction object:
{
  "mnemonic":        string  -- e.g. "LDA"
  "full_name":       string  -- e.g. "Load Accumulator A"
  "operation":       string  -- register-transfer notation e.g. "A <- M"
  "description":     string  -- optional longer description (HTML ok)
  "condition_codes": {       -- each value is one of: "↕" "-" "0" "1" "?"
    "H": string,             -- Half carry
    "N": string,             -- Negative
    "Z": string,             -- Zero
    "V": string,             -- Overflow
    "C": string              -- Carry
  },
  "modes": [                 -- list of addressing mode entries
    {
      "mode":   string,      -- "immediate" "direct" "indexed" "extended"
                             --  "inherent" "relative"
      "syntax": string,      -- assembler syntax e.g. "LDA #n"
      "opcode": string,      -- hex without $ e.g. "86" or "10A6" (prefixed)
      "bytes":  int|string,  -- byte count; "2+" means 2 + postbyte for indexed
      "cycles": int|string   -- cycle count; "4+" means 4 + postbyte cycles
    },
    ...
  ],
  "flow":  string,           -- "sequential" "branch" "call" "return"
  "notes": string            -- optional footnote (HTML ok)
}

INDEXED ADDRESSING POSTBYTE
----------------------------
The "indexed" mode entry shows bytes as "2+" and cycles as "4+" (or
similar) because the actual byte count and cycle count depend on the
postbyte that follows the opcode. The postbyte encodes:
  - which pointer register (X, Y, U, S)
  - the type of indexing (constant offset, auto-increment/decrement,
    accumulator offset, PC-relative, indirect)
  - the size of any offset

The postbyte encoding is documented separately in:
  opcodes_indexed_postbyte.json   -- machine-readable postbyte table
  html/groups/indexed_postbyte.html -- rendered reference page

Every group page that contains instructions with indexed mode links to
the postbyte reference page. The generator checks for the presence of
any "indexed" mode entry and adds the link automatically.

ADDING A NEW GROUP
------------------
1. Create opcodes_<group>.json following the schema above.
2. Add ("group_key", "Display Title") to GROUP_ORDER below.
3. Run generate.py to rebuild all HTML pages.

REGENERATING HTML
-----------------
Run from the repo root:
    python documentation/generate.py
Output goes to documentation/html/groups/<group>.html
"""

import json
import glob
import os
import sys

# ============================================================
# GLOBAL ENCODING FIX
# ============================================================
# This overrides the built-in open() function to default to UTF-8.
# Why? Windows defaults to 'cp1252', which crashes on Unicode symbols 
# (like arrows ←, ↕) found in our JSON and CSS files.
# This ensures the script works identically on Windows, Linux, and Mac.
# ============================================================

import builtins  # <--- THIS LINE IS REQUIRED

# 1. Save the ORIGINAL open function to a safe variable name
_original_open = builtins.open

def _utf8_open(file, mode='r', *args, **kwargs):
    # If mode is text (not binary 'b'), force encoding to utf-8 unless explicitly set
    if 'b' not in mode:
        kwargs.setdefault('encoding', 'utf-8')

    # 2. Call the SAVED original function, NOT builtins.open
    return _original_open(file, mode, *args, **kwargs)

# 3. NOW replace the global built-in
builtins.open = _utf8_open

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), 'html')
OPCODES_DIR = os.path.join(os.path.dirname(__file__), 'opcodes')

# Group display order and titles
GROUP_ORDER = [
    ('load',      'Load'),
    ('store',     'Store'),
    ('transfer',  'Transfer and Exchange'),
    ('arithmetic','Arithmetic'),
    ('compare',   'Compare and Test'),
    ('logical',   'Logical'),
    ('shift',     'Shift and Rotate'),
    ('incdec',    'Increment and Decrement'),
    ('branch',    'Branch and Jump'),
    ('stack',     'Stack'),
    ('address',   'Load Effective Address'),
    ('misc',      'Miscellaneous'),
]

CC_SYMBOLS = {
    '↕': '<span class="cc-affected" title="Set or cleared based on result">↕</span>',
    '0': '<span class="cc-cleared" title="Always cleared">0</span>',
    '1': '<span class="cc-set"     title="Always set">1</span>',
    '-': '<span class="cc-unchanged" title="Not affected">—</span>',
    '?': '<span class="cc-undefined" title="Undefined">?</span>',
}

def cc_html(val):
    return CC_SYMBOLS.get(val, val)

def _load_indexed_postbyte_data():
    """Load indexed postbyte extra cycles/bytes from JSON."""
    import json, os
    pb_path = os.path.join(os.path.dirname(__file__),
                           'opcodes', 'opcodes_indexed_postbyte.json')
    with open(pb_path) as f:
        return json.load(f)['modes']

_PB_MODES = None

def _expand_indexed(mode_entry):
    """Expand a single indexed mode row into all postbyte variants."""
    global _PB_MODES
    if _PB_MODES is None:
        _PB_MODES = _load_indexed_postbyte_data()

    cycles_str = str(mode_entry.get('cycles', ''))
    if not cycles_str.endswith('+'):
        return [mode_entry]

    base_cycles = int(cycles_str[:-1])
    base_bytes  = 2  # opcode + postbyte minimum
    opcode = mode_entry['opcode']
    rows = []

    # Build rows, merging A,R and B,R if they have identical specs
    # Insert merged A/B row in-place when B is encountered (after A)
    acc_ab_pending = None
    for m in _PB_MODES:
        extra_c  = m.get('extra_cycles', 0)
        extra_b  = m.get('extra_bytes', 0)
        syntax   = m.get('syntax', '')
        mtype    = m.get('type', '')
        indirect = m.get('indirect_available', False)

        total_bytes  = base_bytes + extra_b
        total_cycles = base_cycles + extra_c

        # Accumulator A -- save for merging with B
        if 'Accumulator A offset' in mtype:
            acc_ab_pending = {
                'mode':     'indexed — accumulator A/B offset',
                'syntax':   'A/B,R',
                'opcode':   opcode,
                'bytes':    total_bytes,
                'cycles':   total_cycles,
                'indirect': indirect,
            }
            continue

        # Accumulator B -- flush the merged A/B row here in-place
        if 'Accumulator B offset' in mtype:
            if acc_ab_pending:
                r = acc_ab_pending
                rows.append({'mode': r['mode'], 'syntax': r['syntax'],
                             'opcode': r['opcode'], 'bytes': r['bytes'], 'cycles': r['cycles']})
                if r['indirect']:
                    rows.append({'mode': r['mode'] + ', indirect',
                                 'syntax': f'[{r["syntax"]}]',
                                 'opcode': r['opcode'], 'bytes': r['bytes'], 'cycles': r['cycles'] + 3})
                acc_ab_pending = None
            continue

        rows.append({
            'mode':   f'indexed — {mtype}',
            'syntax': syntax,
            'opcode': opcode,
            'bytes':  total_bytes,
            'cycles': total_cycles,
        })

        if indirect:
            rows.append({
                'mode':   f'indexed — {mtype}, indirect',
                'syntax': f'[{syntax}]',
                'opcode': opcode,
                'bytes':  total_bytes,
                'cycles': total_cycles + 3,
            })

    return rows


def _compact_indexed(mode_entry):
    """Produce compact grouped rows for indexed mode -- screen version."""
    global _PB_MODES
    if _PB_MODES is None:
        _PB_MODES = _load_indexed_postbyte_data()

    cycles_str = str(mode_entry.get('cycles', ''))
    if not cycles_str.endswith('+'):
        return None  # not an indexed mode entry
    base_cycles = int(cycles_str[:-1])
    base_bytes  = 2
    opcode = mode_entry['opcode']

    # Collect all variants into families
    families = {
        'auto':   {'direct': [], 'indirect': []},
        'offset': {'direct': [], 'indirect': []},
        'pc':     {'direct': [], 'indirect': []},
    }

    acc_ab_pending = None
    for m in _PB_MODES:
        extra_c  = m.get('extra_cycles', 0)
        extra_b  = m.get('extra_bytes', 0)
        syntax   = m.get('syntax', '')
        mtype    = m.get('type', '')
        indirect = m.get('indirect_available', False)
        total_bytes  = base_bytes + extra_b
        total_cycles = base_cycles + extra_c

        # Extended indirect handled separately on the instruction page
        if mtype == 'Extended indirect':
            continue

        # PC-relative family
        if 'PC-relative' in mtype or 'PC relative' in mtype:
            families['pc']['direct'].append((syntax, total_bytes, total_cycles))
            if indirect:
                families['pc']['indirect'].append((f'[{syntax}]', total_bytes, total_cycles + 3))
            continue

        # Auto-increment/decrement family
        if 'increment' in mtype.lower() or 'decrement' in mtype.lower():
            families['auto']['direct'].append((syntax, total_bytes, total_cycles))
            if indirect:
                families['auto']['indirect'].append((f'[{syntax}]', total_bytes, total_cycles + 3))
            continue

        # Accumulator A -- merge with B
        if 'Accumulator A offset' in mtype:
            acc_ab_pending = (total_bytes, total_cycles, indirect)
            continue
        if 'Accumulator B offset' in mtype:
            if acc_ab_pending:
                ab_bytes, ab_cycles, ab_ind = acc_ab_pending
                families['offset']['direct'].append(('A/B,R', ab_bytes, ab_cycles))
                if ab_ind:
                    families['offset']['indirect'].append(('[A/B,R]', ab_bytes, ab_cycles + 3))
            acc_ab_pending = None
            continue

        # Everything else is offset family
        families['offset']['direct'].append((syntax, total_bytes, total_cycles))
        if indirect:
            families['offset']['indirect'].append((f'[{syntax}]', total_bytes, total_cycles + 3))

    def rng(items, idx):
        vals = [x[idx] for x in items]
        mn, mx = min(vals), max(vals)
        return str(mn) if mn == mx else f'{mn}&#8211;{mx}'

    def syns(items):
        seen = []
        for x in items:
            if x[0] not in seen:
                seen.append(x[0])
        return ' &nbsp; '.join(seen)

    rows = []
    first_indexed = True

    for fname, flabel, fsyntax_key in [
        ('auto',   'indexed — auto ±',    None),
        ('offset', 'indexed — offset',    None),
        ('pc',     'indexed — PC-relative', None),
    ]:
        fam = families[fname]
        if not fam['direct']:
            continue

        op_cell = opcode if first_indexed else '″'
        first_indexed = False

        rows.append({
            'mode':   flabel,
            'syntax': syns(fam['direct']),
            'opcode': op_cell,
            'bytes':  rng(fam['direct'], 1),
            'cycles': rng(fam['direct'], 2),
            'group_top': True,
            'italic': True,
        })
        if fam['indirect']:
            rows.append({
                'mode':   'indirect',
                'syntax': syns(fam['indirect']),
                'opcode': '″',
                'bytes':  rng(fam['indirect'], 1),
                'cycles': rng(fam['indirect'], 2),
                'italic': True,
            })

    return rows, opcode


def render_modes_table_compact(modes, ref_url='../groups/indexed_postbyte.html'):
    """Compact grouped table for screen display."""
    rows = []
    ext_indirect_opcode = None

    # Sort order: immediate, direct, extended, indexed
    mode_order = ['immediate', 'direct', 'extended', 'indexed']
    def mode_key(m):
        base = m.get('mode', '').split()[0].lower()
        try: return mode_order.index(base)
        except ValueError: return len(mode_order)
    sorted_modes = sorted(modes, key=mode_key)

    for m in sorted_modes:
        cycles_str = str(m.get('cycles', ''))
        if cycles_str.endswith('+'):
            # Extended indirect row -- extract before indexed compact
            ext_indirect_opcode = m['opcode']
            continue  # indexed handled below

        rows.append({
            'mode':   m['mode'],
            'syntax': m['syntax'],
            'opcode': m['opcode'],
            'bytes':  m.get('bytes', '?'),
            'cycles': m.get('cycles', '?'),
        })

        # Extended indirect slots in right after extended
        if m['mode'] == 'extended' and ext_indirect_opcode:
            rows.append({
                'mode':   'indirect',
                'syntax': '[$addr]',
                'opcode': ext_indirect_opcode,
                'bytes':  3,
                'cycles': 9,
                'italic': True,
            })
            ext_indirect_opcode = None

    # Now add compact indexed groups
    for m in sorted_modes:
        if not str(m.get('cycles','')).endswith('+'):
            continue
        result = _compact_indexed(m)
        if result:
            indexed_rows, _ = result
            rows.extend(indexed_rows)

    # Build HTML
    html_rows = []
    for r in rows:
        italic = r.get('italic', False)
        group_top = r.get('group_top', False)
        top_style = 'border-top:1px solid var(--border-strong)' if group_top else ''
        mode_style = 'color:var(--text-muted);font-size:0.8rem;font-style:italic' if italic else ''
        op = r['opcode']
        op_cell = f'<td style="text-align:center;font-family:monospace;font-size:0.85rem;color:var(--text-muted)">{op}</td>' if op == '″' else f'<td class="col-opcode"><code>${op}</code></td>'
        is_indexed = 'indexed' in r.get('mode','').lower() or r.get('italic', False)
        pb_attr = ' class="pb-row"' if is_indexed else ''
        html_rows.append(
            f'<tr style="{top_style}"{pb_attr}>'
            f'<td style="{mode_style}">{r["mode"]}</td>'
            f'<td style="font-family:monospace;font-size:0.85rem">{r["syntax"]}</td>'
            f'{op_cell}'
            f'<td class="col-bytes">{r["bytes"]}</td>'
            f'<td class="col-cycles">{r["cycles"]}</td>'
            f'</tr>'
        )

    ref = f'<p class="pb-note" style="font-size:0.8rem;color:var(--text-secondary);margin-top:0.5rem;padding:0.3rem 0.5rem;border-radius:3px">Precise cycle counts and postbyte encoding &rarr; <a href="{ref_url}">Indexed Addressing Reference</a></p>'

    return '\n'.join(html_rows), ref


def render_modes_table(modes):
    # Render extended before indexed so the expanded indexed block
    # doesn't bury extended at the bottom
    mode_order = ['immediate', 'direct', 'extended', 'indexed']
    def mode_key(m):
        base = m.get('mode', '').split()[0].lower()
        try:
            return mode_order.index(base)
        except ValueError:
            return len(mode_order)
    modes = sorted(modes, key=mode_key)

    rows = []
    for m in modes:
        # Expand indexed mode into all postbyte variants
        for em in _expand_indexed(m):
            cycles = em.get('cycles', '?')
            bytes_ = em.get('bytes', '?')
            syntax = em['syntax'].replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
            mode_label = em["mode"].replace("-", "&#8209;")
            rows.append(
                f'<tr>'
                f'<td class="mode">{mode_label}</td>'
                f'<td class="syntax"><code>{syntax}</code></td>'
                f'<td class="col-opcode"><code>${em["opcode"]}</code></td>'
                f'<td class="col-bytes">{bytes_}</td>'
                f'<td class="col-cycles">{cycles}</td>'
                f'</tr>'
            )
    return '\n'.join(rows)

def render_instruction(instr):
    mnemonic = instr['mnemonic']
    full_name = instr['full_name']
    operation = instr.get('operation', '').replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
    description = instr.get('description', '')
    notes = instr.get('notes', '')
    cc = instr.get('condition_codes', {})
    modes = instr.get('modes', [])

    cc_html_cells = ''.join(
        f'<td class="cc-cell">{cc_html(cc.get(f, "-"))}</td>'
        for f in ['H', 'N', 'Z', 'V', 'C']
    )

    notes_html = f'<p class="notes">{notes}</p>' if notes else ''
    desc_html  = f'<p class="description">{description}</p>' if description else ''

    # Compact table for screen display
    compact_rows, compact_ref = render_modes_table_compact(modes)

    # Register codes table (TFR/EXG)
    reg_codes = instr.get('register_codes', {})
    reg_codes_html = ''
    if reg_codes:
        # Sort by binary value
        sorted_regs = sorted(reg_codes.items(), key=lambda x: int(x[1], 2))
        rows16 = ''
        rows8  = ''
        for reg, bits in sorted_regs:
            nibble = f'${int(bits, 2):X}'
            if int(bits, 2) < 8:
                rows16 += f'<tr><td style="text-align:center"><code>{reg}</code></td><td style="text-align:center"><code>{nibble}</code></td></tr>'
            else:
                rows8  += f'<tr><td style="text-align:center"><code>{reg}</code></td><td style="text-align:center"><code>{nibble}</code></td></tr>'
        reg_codes_html = f'''
  <div class="reg-codes">
    <h4>Register codes</h4>
    <p>Postbyte: source in high nibble, destination in low nibble.
    <code>TFR D,X</code> &rarr; <code>$0</code>&nbsp;|&nbsp;<code>$1</code> &rarr; postbyte <code>$01</code> &rarr; bytes <code>$1F $01</code>.</p>
    <div style="display:flex;gap:2rem;align-items:flex-start">
      <table class="modes-table" style="width:auto">
        <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead><tr><th colspan="2">16-bit</th></tr><tr><th>Reg</th><th>Code</th></tr></thead>
        <tbody>{rows16}</tbody>
      </table>
      <table class="modes-table" style="width:auto">
        <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead><tr><th colspan="2">8-bit</th></tr><tr><th>Reg</th><th>Code</th></tr></thead>
        <tbody>{rows8}</tbody>
      </table>
    </div>
    <div class="interactive no-print" style="margin-top:1rem">
      <h4>{mnemonic} builder</h4>
      <div style="display:flex;flex-direction:column;gap:8px;display:inline-flex">
        <div style="display:flex;gap:2rem">
          <div>
            <div style="font-size:0.8rem;color:var(--text-secondary,#666);margin-bottom:4px;min-width:200px">16-bit transfers</div>
            <div style="display:flex;gap:8px">
              <div>
                <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">from</div>
                <div id="src16-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
              </div>
              <div>
                <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">to</div>
                <div id="dst16-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
              </div>
            </div>
          </div>
          <div>
            <div style="font-size:0.8rem;color:var(--text-secondary,#666);margin-bottom:4px;min-width:200px">8-bit transfers</div>
            <div style="display:flex;gap:8px">
              <div>
                <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">from</div>
                <div id="src8-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
              </div>
              <div>
                <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">to</div>
                <div id="dst8-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
              </div>
            </div>
          </div>
        </div>
        <div style="display:flex;gap:2rem">
          <div id="out16-{mnemonic}" style="font-family:monospace;font-size:0.9rem;min-height:1.4em;padding:4px 6px;border:1px solid var(--border,#ccc);border-radius:4px;background:var(--surface-1,#f8f8f8);color:var(--text-primary,#111);flex:1;min-width:200px;white-space:nowrap">&nbsp;</div>
          <div id="out8-{mnemonic}" style="font-family:monospace;font-size:0.9rem;min-height:1.4em;padding:4px 6px;border:1px solid var(--border,#ccc);border-radius:4px;background:var(--surface-1,#f8f8f8);color:var(--text-primary,#111);flex:1;min-width:200px;white-space:nowrap">&nbsp;</div>
        </div>
      </div>
      <script>
      (function() {{
        var mn = '{mnemonic}';
        var regs16 = {[r for r, b in reg_codes.items() if int(b,2) < 8]!r};
        var regs8  = {[r for r, b in reg_codes.items() if int(b,2) >= 8]!r};
        var nibbles = {{{', '.join([f'"{r}": "{int(b,2):X}"' for r,b in reg_codes.items()])}}};
        var opcodes = {{"TFR":"1F","EXG":"1E"}};
        var opcode = opcodes[mn];

        function makeGroup(containerId, regs, role, partner16, partner8) {{
          var c = document.getElementById(containerId);
          regs.forEach(function(reg) {{
            var b = document.createElement('button');
            b.textContent = reg;
            b.dataset.reg = reg;
            b.style.cssText = 'font-family:monospace;padding:2px 8px;border:1px solid var(--border-strong,#bbb);border-radius:3px;background:var(--surface-2,#fff);color:var(--text-primary,#111);cursor:pointer;font-size:0.85rem';
            b.addEventListener('click', function() {{
              c.querySelectorAll('button').forEach(function(x){{x.style.background='var(--surface-2,#fff)';x.style.borderColor='var(--border-strong,#bbb)';x.style.color='var(--text-primary,#111)';}});
              b.style.background = (role==='src') ? 'var(--bg-accent,#dbeafe)' : 'var(--bg-success,#dcfce7)';
              b.style.borderColor = (role==='src') ? 'var(--border-accent,#3b82f6)' : 'var(--border-success,#22c55e)';
              b.style.color = (role==='src') ? 'var(--text-accent,#1d4ed8)' : 'var(--text-success,#15803d)';
              updateOut(containerId, role, reg);
            }});
            c.appendChild(b);
          }});
        }}

        var state = {{src16: null, dst16: null, src8: null, dst8: null}};

        function updateOut(containerId, role, reg) {{
          var is16 = containerId.includes('16');
          var srcKey = is16 ? 'src16' : 'src8';
          var dstKey = is16 ? 'dst16' : 'dst8';
          state[srcKey.replace('src','src')] = (role==='src') ? reg : state[srcKey];
          state[dstKey.replace('dst','dst')] = (role==='dst') ? reg : state[dstKey];
          if (role==='src') state[srcKey] = reg;
          else state[dstKey] = reg;
          var outId = is16 ? 'out16-'+mn : 'out8-'+mn;
          var src = is16 ? state.src16 : state.src8;
          var dst = is16 ? state.dst16 : state.dst8;
          var out = document.getElementById(outId);
          if (src && dst) {{
            var pb = (parseInt(nibbles[src],16) << 4) | parseInt(nibbles[dst],16);
            var pbHex = pb.toString(16).toUpperCase().padStart(2,'0');
            out.textContent = mn+' '+src+','+dst+'  →  $'+opcode+' $'+pbHex;
          }} else if (src) {{
            out.textContent = mn+' '+src+',?';
          }} else if (dst) {{
            out.textContent = mn+' ?,'+dst;
          }} else {{
            out.innerHTML = '&nbsp;';
          }}
        }}

        makeGroup('src16-'+mn, regs16, 'src');
        makeGroup('dst16-'+mn, regs16, 'dst');
        makeGroup('src8-'+mn,  regs8,  'src');
        makeGroup('dst8-'+mn,  regs8,  'dst');
      }})();
      </script>
    </div>
  </div>'''

    return f'''
<div class="instruction" id="{mnemonic}">
  <h3 class="mnemonic">{mnemonic} <span class="full-name">— {full_name}</span></h3>
  <div class="operation"><code>{operation}</code></div>
  {desc_html}
  <div class="tables-wrap no-print">
    <table class="modes-table">
      <colgroup>
        <col class="col-mode"><col class="col-syntax"><col class="col-opcode"><col class="col-bytes"><col class="col-cycles">
      </colgroup>
      <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead>
        <tr>
          <th>Mode</th><th>Syntax</th><th class="col-opcode">Opcode</th><th class="col-bytes">Bytes</th><th class="col-cycles">Cycles</th>
        </tr>
      </thead>
      <tbody>
        {compact_rows}
      </tbody>
    </table>
    <table class="cc-table">
      <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead>
        <tr><th colspan="5">Condition Codes</th></tr>
        <tr><th>H</th><th>N</th><th>Z</th><th>V</th><th>C</th></tr>
      </thead>
      <tbody>
        <tr>{cc_html_cells}</tr>
      </tbody>
    </table>
  </div>
  {compact_ref}
  <div class="tables-wrap print-only">
    <table class="modes-table">
      <colgroup>
        <col class="col-mode"><col class="col-syntax"><col class="col-opcode"><col class="col-bytes"><col class="col-cycles">
      </colgroup>
      <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead>
        <tr>
          <th>Mode</th><th>Syntax</th><th class="col-opcode">Opcode</th><th class="col-bytes">Bytes</th><th class="col-cycles">Cycles</th>
        </tr>
      </thead>
      <tbody>
        {render_modes_table(modes)}
      </tbody>
    </table>
    <table class="cc-table">
      <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead>
        <tr><th colspan="5">Condition Codes</th></tr>
        <tr><th>H</th><th>N</th><th>Z</th><th>V</th><th>C</th></tr>
      </thead>
      <tbody>
        <tr>{cc_html_cells}</tr>
      </tbody>
    </table>
  </div>
  {reg_codes_html}
  {notes_html}
</div>
'''

def has_indexed_mode(instructions):
    """Return True if any instruction in the group has an indexed mode."""
    return any(
        any(m.get('mode') == 'indexed' for m in i.get('modes', []))
        for i in instructions
    )

def render_group_page(group_key, group_title, instructions):
    instruction_html = '\n'.join(render_instruction(i) for i in instructions)
    postbyte_link = (
        '<a href="indexed_postbyte.html" class="postbyte-link">'
        'Indexed Addressing Postbyte Reference</a>'
        if has_indexed_mode(instructions) else ''
    )
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>6809 Reference — {group_title}</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
  <nav class="topnav">
    <a href="../index.html">Index</a>
    <span class="group-title">{group_title}</span>
    {postbyte_link}
  </nav>
  <main>
    <h2>{group_title}</h2>
    {instruction_html}
  </main>
  <footer>
    <p>Motorola MC6809 Instruction Reference</p>
  </footer>
</body>
</html>
'''

def render_index(groups):
    nav_items = []
    for key, title, instructions in groups:
        count = len(instructions)
        links = ' '.join(
            f'<a href="groups/{key}.html#{i["mnemonic"]}">{i["mnemonic"]}</a>'
            for i in instructions
        )
        nav_items.append(f'''
<section class="index-group">
  <h3><a href="groups/{key}.html">{title}</a> <span class="count">({count})</span></h3>
  <div class="mnemonic-list">{links}</div>
</section>
''')

    return f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Motorola MC6809 Instruction Reference</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>Motorola MC6809</h1>
    <h2>Instruction Reference</h2>
  </header>
  <main>
    <section class="index-group">
      <h3>Addressing References</h3>
      <div class="mnemonic-list"><a href="groups/indexed_postbyte.html">Indexed Addressing Postbyte</a></div>
    </section>
    {''.join(nav_items)}
  </main>
  <footer>
    <p>Generated from opcode database. Cycle counts and flag behavior per Motorola MC6809 Programming Reference Manual.</p>
  </footer>
</body>
</html>
'''

def render_css():
    return '''/* 6809 Reference Manual — stylesheet */

:root {
  --bg:          #1a1a1a;
  --bg2:         #242424;
  --bg3:         #2e2e2e;
  --border:      #404040;
  --text:        #e0e0e0;
  --text-dim:    #888;
  --accent:      #5b9bd5;
  --accent2:     #7ec8a4;
  --mnemonic:    #f0c060;
  --code-bg:     #1e1e1e;
  --cc-affected: #7ec8a4;
  --cc-set:      #f0c060;
  --cc-cleared:  #888;
  --cc-undef:    #c05050;
  --pb-tint:     #1e2a1e;
  --accent-visited: #7aaac8;
}

@media (prefers-color-scheme: light) {
  :root {
    --bg:          #f8f6f0;
    --bg2:         #eeeae0;
    --bg3:         #e4e0d4;
    --border:      #c8c0b0;
    --text:        #2a2010;
    --text-dim:    #6a5a40;
    --accent:      #2255aa;
    --accent2:     #227755;
    --mnemonic:    #995500;
    --code-bg:     #f0ece0;
    --cc-affected: #227755;
    --cc-set:      #995500;
    --cc-cleared:  #6a5a40;
    --cc-undef:    #aa2222;
    --pb-tint:     #e8f0e8;
    --accent-visited: #4477aa;
  }
}

* { box-sizing: border-box; margin: 0; padding: 0; }

@media print {
  h3 { break-after: avoid; page-break-after: avoid; }
  table { break-inside: avoid; page-break-inside: avoid; }
  h3 + table, h3 + p + table, h3 + p + p + table { break-before: avoid; }
  p.pb-note { break-after: avoid; page-break-after: avoid; }
}

tr.pb-row td { background: var(--pb-tint); }
p.pb-note { background: var(--pb-tint); display: inline-block; border-radius: 3px; }
a:visited { color: var(--accent-visited, #8ab4d8); }
a.postbyte-link:visited { color: var(--accent-visited, #8ab4d8); }

body {
  font-family: Georgia, 'Times New Roman', serif;
  background: var(--bg);
  color: var(--text);
  line-height: 1.6;
  max-width: 960px;
  margin: 0 auto;
  padding: 0 1.5rem;
}

header {
  padding: 2rem 0 1rem;
  border-bottom: 2px solid var(--border);
  margin-bottom: 2rem;
}

header h1 {
  font-size: 2rem;
  color: var(--mnemonic);
  letter-spacing: 0.05em;
}

header h2 {
  font-size: 1.1rem;
  color: var(--text-dim);
  font-weight: normal;
}

/* Top nav */
.topnav {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem 0;
  border-bottom: 1px solid var(--border);
  margin-bottom: 2rem;
  font-family: monospace;
  font-size: 0.9rem;
}

.topnav a {
  color: var(--accent);
  text-decoration: none;
}

.topnav a:hover { text-decoration: underline; }

.group-title {
  color: var(--mnemonic);
  font-weight: bold;
}

/* Index page */
.index-group {
  margin-bottom: 2rem;
  padding: 1rem 1.25rem;
  background: var(--bg2);
  border: 1px solid var(--border);
  border-radius: 4px;
}

.index-group h3 {
  margin-bottom: 0.5rem;
  font-size: 1rem;
  color: var(--text);
}

.index-group h3 a {
  color: var(--mnemonic);
  text-decoration: none;
}

.index-group h3 a:hover { text-decoration: underline; }

.count { color: var(--text-dim); font-weight: normal; font-size: 0.85rem; }

.mnemonic-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
}

.mnemonic-list a {
  font-family: 'Courier New', monospace;
  font-size: 0.85rem;
  color: var(--accent);
  text-decoration: none;
  padding: 0.1rem 0.4rem;
  background: var(--bg3);
  border-radius: 3px;
  border: 1px solid var(--border);
}

.mnemonic-list a:hover {
  background: var(--accent);
  color: var(--bg);
}

/* Instruction entries */
.instruction {
  margin-bottom: 3rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--border);
}

h2 {
  font-size: 1.4rem;
  color: var(--mnemonic);
  margin-bottom: 1.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid var(--border);
}

h3.mnemonic {
  font-family: 'Courier New', monospace;
  font-size: 1.3rem;
  color: var(--mnemonic);
  margin-bottom: 0.5rem;
}

.full-name {
  font-family: Georgia, serif;
  font-size: 0.9rem;
  color: var(--text-dim);
  font-weight: normal;
}

.operation {
  margin-bottom: 0.75rem;
}

.operation code {
  font-size: 0.95rem;
  color: var(--accent2);
  background: var(--code-bg);
  padding: 0.2rem 0.5rem;
  border-radius: 3px;
}

.description {
  color: var(--text-dim);
  font-size: 0.95rem;
  margin-bottom: 0.75rem;
}

/* Modes table */
.encoding-examples-table td:last-child {
  white-space: normal;
  overflow: hidden;
  word-wrap: break-word;
}

.postbyte-table {
  table-layout: fixed;
  width: 100%;
}
.postbyte-table td,
.postbyte-table th {
  text-align: center;
}
.postbyte-table td:first-child,
.postbyte-table th:first-child,
.postbyte-table td:nth-child(10),
.postbyte-table th:nth-child(10),
.postbyte-table td:nth-child(11),
.postbyte-table th:nth-child(11) {
  text-align: left;
}

.modes-table {
  width: max-content;
  table-layout: fixed;
  border-collapse: collapse;
  margin-bottom: 0.75rem;
  font-size: 0.9rem;
}

.modes-table col.col-mode   { width: 8rem; }
.modes-table col.col-syntax { width: 16rem; }
.modes-table col.col-opcode { width: 4.5rem; }
.modes-table col.col-bytes  { width: 3.5rem; }
.modes-table col.col-cycles { width: 3.5rem; }

.modes-table th {
  background: var(--bg3);
  color: var(--text-dim);
  padding: 0.4rem 0.6rem;
  text-align: left;
  border: 1px solid var(--border);
  font-weight: normal;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  white-space: nowrap;
}

.modes-table th.col-opcode,
.modes-table th.col-bytes,
.modes-table th.col-cycles { text-align: center; }

.modes-table td {
  padding: 0.4rem 0.6rem;
  border: 1px solid var(--border);
  background: var(--bg2);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.modes-table td.col-opcode,
.modes-table td.col-bytes,
.modes-table td.col-cycles { text-align: center; color: var(--text-dim); }

.modes-table code {
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  color: var(--accent);
}

td.mode  { color: var(--text-dim); font-size: 0.85rem; }

.tables-wrap {
  display: flex;
  gap: 1.5rem;
  align-items: flex-start;
  margin-bottom: 0.75rem;
}

.print-only { display: none; }

/* Condition codes table */
.cc-table {
  border-collapse: collapse;
  margin-bottom: 0.75rem;
  font-size: 0.85rem;
}

.cc-table th {
  background: var(--bg3);
  color: var(--text-dim);
  padding: 0.3rem 0.75rem;
  border: 1px solid var(--border);
  font-weight: normal;
  text-align: center;
  font-size: 0.8rem;
}

.cc-table th:first-child {
  text-align: left;
  color: var(--text-dim);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-size: 0.75rem;
}

.cc-table td {
  padding: 0.3rem 0.75rem;
  border: 1px solid var(--border);
  background: var(--bg2);
  text-align: center;
  font-family: 'Courier New', monospace;
}

.cc-affected  { color: var(--cc-affected); }
.cc-set       { color: var(--cc-set); }
.cc-cleared   { color: var(--cc-cleared); }
.cc-unchanged { color: var(--text-dim); }
.cc-undefined { color: var(--cc-undef); }

/* Notes */
.notes {
  font-size: 0.9rem;
  color: var(--text-dim);
  padding: 0.5rem 0.75rem;
  border-left: 3px solid var(--border);
  margin-top: 0.5rem;
}

footer {
  padding: 2rem 0;
  color: var(--text-dim);
  font-size: 0.8rem;
  border-top: 1px solid var(--border);
  margin-top: 2rem;
}

/* ── Print / PDF ─────────────────────────────────────────────── */
@media print {
  :root {
    --bg:          #ffffff;
    --bg2:         #f8f8f8;
    --bg3:         #eeeeee;
    --border:      #cccccc;
    --text:        #000000;
    --text-dim:    #444444;
    --accent:      #000000;
    --accent2:     #000000;
    --mnemonic:    #000000;
    --code-bg:     #f4f4f4;
    --cc-affected: #000000;
    --cc-set:      #000000;
    --cc-cleared:  #666666;
    --cc-undef:    #000000;
  }

  body {
    font-family: 'Times New Roman', Times, serif;
    font-size: 10pt;
    max-width: none;
    padding: 0;
    margin: 0;
  }

  @page {
    size: letter;
    margin: 1in 0.9in 1in 1.1in;  /* inner margin wider for binding */
  }

  @page :left  { margin-left: 1.1in; margin-right: 0.9in; }
  @page :right { margin-left: 0.9in; margin-right: 1.1in; }

  header {
    border-bottom: 2pt solid black;
    padding-bottom: 0.5rem;
    margin-bottom: 1rem;
  }

  header h1 { font-size: 18pt; }
  header h2 { font-size: 12pt; font-style: italic; }

  .topnav { display: none; }

  h2 {
    font-size: 14pt;
    border-bottom: 1pt solid black;
    page-break-after: avoid;
  }

  h3.mnemonic {
    font-size: 12pt;
    page-break-after: avoid;
  }

  .instruction {
    page-break-inside: avoid;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 0.5pt solid #ccc;
  }

  .modes-table,
  .cc-table {
    font-size: 9pt;
    page-break-inside: avoid;
    border: 0.5pt solid #ccc;
  }

  .modes-table th,
  .modes-table td,
  .cc-table th,
  .cc-table td {
    border: 0.5pt solid #ccc;
    padding: 0.2rem 0.4rem;
    background: none !important;
  }

  .modes-table th,
  .cc-table th {
    background: #eeeeee !important;
    font-weight: bold;
  }

  code {
    font-family: 'Courier New', Courier, monospace;
    font-size: 9pt;
    background: none;
  }

  .notes {
    font-size: 9pt;
    border-left: 2pt solid #ccc;
    padding-left: 0.5rem;
  }

  .mnemonic-list a { color: black; text-decoration: none; }
  .index-group { page-break-inside: avoid; border: 0.5pt solid #ccc; }

  a[href]::after { content: none; }  /* suppress URL printing */

  footer { font-size: 8pt; border-top: 0.5pt solid #ccc; }
}
'''

def render_postbyte_page(data):
    """Render the indexed addressing postbyte reference page from JSON."""

    notes_html = ''.join(f'<li>{n}</li>' for n in data.get('notes', []))

    # Register bits table
    def reg_bit_row(r):
        b6, b5 = r['bits'][0], r['bits'][1]
        return (f'<tr>'
                f'<td style="color:var(--cc-set,#f0c060);font-weight:bold">1</td>'
                f'<td>{b6}</td><td>{b5}</td>'
                f'<td>-</td><td>-</td><td>-</td><td>-</td><td>-</td>'
                f'<td style="text-align:left"><strong>{r["register"]}</strong></td>'
                f'</tr>')
    reg_rows = ''.join(reg_bit_row(r) for r in data['register_bits']['values'])

    # Main postbyte modes table
    mode_rows = []
    for m in data['modes']:
        pb_vals = m.get('postbyte_values', {})
        ipb_vals = m.get('indirect_postbyte_values', {})

        # Format postbyte values as $XX per register
        def fmt_vals(d):
            return '  '.join(f'{r}=<code>${v}</code>' for r, v in d.items()) if d else '—'

        indirect_cell = fmt_vals(ipb_vals) if m.get('indirect_available') else '—'
        note = m.get('note', '')

        mode_rows.append(f'''
<tr>
  <td><code>{m["syntax"]}</code></td>
  <td class="description">{m["description"]}{(" " + note) if note else ""}</td>
  <td>{fmt_vals(pb_vals)}</td>
  <td class="center">{m.get("extra_bytes", 0)}</td>
  <td class="center">+{m.get("extra_cycles", 0)}</td>
  <td>{indirect_cell}</td>
</tr>''')

    # Hand assembly examples
    ex_rows = []
    for ex in data.get('encoding_examples', []):
        def fmt_byte(b):
            return b if b.startswith('$') else f'${b}'
        def fmt_operand(s):
            return ' '.join(fmt_byte(b) for b in s.split())
        # Build entire bytes cell as one <code> block for clean copy-paste
        postbyte_str = f' {fmt_byte(ex["postbyte"])}' if 'postbyte' in ex else ''
        operand_str  = f' {fmt_operand(ex["operand"])}' if 'operand' in ex else ''
        bytes_cell   = f'<code>${ex["opcode"]}{postbyte_str}{operand_str}</code>'
        ex_rows.append(f'''
<tr>
  <td><code>{ex["syntax"]}</code></td>
  <td>{bytes_cell}</td>
  <td class="center">{ex["total_bytes"]}</td>
  <td>{ex["description"]}</td>
</tr>''')

    return f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>6809 Reference — Indexed Addressing Postbyte</title>
  <link rel="stylesheet" href="../style.css">
  <style>
    .postbyte-table td.center {{ text-align: center; }}
    .postbyte-table td.description {{ font-size: 0.85rem; color: var(--text-dim); }}
    .or-derive-table td {{ text-align: center; }}
.or-derive-table td:first-child, .or-derive-table th:first-child {{ text-align: left; }}
.or-derive-table td:last-child, .or-derive-table th:last-child {{ text-align: center; }}
.reg-table td, .reg-table th {{ text-align: center; }}
.reg-table td:last-child, .reg-table th:last-child {{ text-align: left; }}

.encoding-examples-table td:nth-child(3) {{ text-align: center; }}

.encoding-examples-table td:last-child {{
  white-space: normal;
  overflow: hidden;
  word-wrap: break-word;
}}

.postbyte-table {{ font-family: "Courier New", monospace; font-size: 0.82rem; }}
    .postbyte-table td, .postbyte-table th {{ text-align: center; white-space: nowrap; }}
    .postbyte-table td:first-child, .postbyte-table th:first-child,
    .postbyte-table td:last-child, .postbyte-table th:last-child {{ text-align: left; white-space: nowrap; }}
    .postbyte-table td:first-child, .postbyte-table th:first-child {{ width: 6rem; }}
    .postbyte-table td:nth-child(2), .postbyte-table th:nth-child(2),
    .postbyte-table td:nth-child(3), .postbyte-table th:nth-child(3),
    .postbyte-table td:nth-child(4), .postbyte-table th:nth-child(4),
    .postbyte-table td:nth-child(5), .postbyte-table th:nth-child(5),
    .postbyte-table td:nth-child(6), .postbyte-table th:nth-child(6),
    .postbyte-table td:nth-child(7), .postbyte-table th:nth-child(7),
    .postbyte-table td:nth-child(8), .postbyte-table th:nth-child(8),
    .postbyte-table td:nth-child(9), .postbyte-table th:nth-child(9) {{ width: 1.8rem; padding: 0.2rem 0.1rem; }}
    .postbyte-table td:last-child, .postbyte-table th:last-child {{ width: auto; }}
    .postbyte-table td[contenteditable] {{ background: var(--bg3); min-width: 8rem; }}
    .postbyte-table td[contenteditable]:focus {{ outline: 1px solid var(--accent); background: var(--bg2); }}
    .postbyte-table tr.section-header td {{
      background: var(--bg3) !important;
      color: var(--mnemonic);
      font-size: 0.8rem;
      padding: 0.3rem 0.5rem;
    }}
    .reg-table {{ width: auto; margin-bottom: 1.5rem; }}
    .reg-table td, .reg-table th {{ padding: 0.25rem 1rem; }}
  </style>
</head>
<body>
  <nav class="topnav">
    <a href="../index.html">Index</a>
    <span class="group-title">Indexed Addressing Postbyte</span>
  </nav>
  <main>
    <h2>Indexed Addressing — Postbyte Encoding</h2>
    <p>{data["description"]}</p>

    <h3>Notes</h3>
    <ul>{notes_html}</ul>

    <h3>Pointer Register Selection (bits 6-5 when bit 7 = 1)</h3>
    <table class="modes-table reg-table" style="font-family:monospace; font-size:0.85rem; width:auto;">
      <colgroup>
        <col style="width:2.5rem"><col style="width:2.5rem"><col style="width:2.5rem"><col style="width:2.5rem">
        <col style="width:2.5rem"><col style="width:2.5rem"><col style="width:2.5rem"><col style="width:2.5rem">
        <col style="min-width:6rem"><!-- Register -->
      </colgroup>
      <thead>
        <tr>
          <th style="text-align:center;color:var(--cc-set,#f0c060)">7</th>
          <th>6</th><th>5</th><th>4</th><th>3</th><th>2</th><th>1</th><th>0</th>
          <th style="text-align:left">Register</th>
        </tr>
      </thead>
      <tbody>{reg_rows}</tbody>
    </table>

    <h3>Postbyte Bit Map</h3>
    <p>All postbyte values shown for register X (bits 6-5 = 00). For Y add $20, U add $40, S add $60.<br>
    <strong style="color:var(--cc-set,#f0c060)">I</strong> = indirect bit set (1); mode also available in indirect form [&hellip;].</p>
    <table class="modes-table postbyte-table" style="font-family: monospace; font-size: 0.85rem;">
      <colgroup>
        <col style="width:32%"><!-- Description -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:20%"><!-- Direct -->
        <col style="width:16%"><!-- Indirect -->
      </colgroup>
      <thead>
        <tr>
          <th style="text-align:left">Description</th>
          <th>7</th><th>6</th><th>5</th><th>4</th>
          <th>3</th><th>2</th><th>1</th><th>0</th>
          <th style="text-align:left">Direct</th>
          <th style="text-align:left">Indirect</th>
        </tr>
        <tr style="font-size:0.75rem; color:var(--text-dim)">
          <th></th>
          <th>r</th><th>R</th><th>R</th><th style="color:var(--cc-set,#f0c060)">I</th>
          <th>m</th><th>m</th><th>m</th><th>m</th>
          <th></th><th></th>
        </tr>
      </thead>
      <tbody>
        <tr class="section-header"><td colspan="11"><strong>Register select (bits 6-5 when bit 7=1)</strong></td></tr>
        <tr><td>register X base</td><td>1</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td></td><td></td></tr>
        <tr><td>register Y base</td><td>1</td><td>0</td><td>1</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td></td><td></td></tr>
        <tr><td>register U base</td><td>1</td><td>1</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td></td><td></td></tr>
        <tr><td>register S base</td><td>1</td><td>1</td><td>1</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td></td><td></td></tr>
        <tr class="section-header"><td colspan="11"><strong>5-bit signed offset (bit 7=0, no indirect)</strong></td></tr>
        <tr><td>5-bit signed offset</td><td>0</td><td>R</td><td>R</td><td>n</td><td>n</td><td>n</td><td>n</td><td>n</td><td><code>LDA -1,X</code></td><td>—</td></tr>
        <tr class="section-header"><td colspan="11"><strong>Standard indexed (bit 7=1)</strong></td></tr>
        <tr><td>post-increment by 1</td><td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td><code>LDA ,X+</code></td><td>—</td></tr>
        <tr><td>post-increment by 2</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>0</td><td>0</td><td>0</td><td>1</td><td><code>LDA ,X++</code></td><td><code>LDA [,X++]</code></td></tr>
        <tr><td>pre-decrement by 1</td><td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td><code>LDA ,-X</code></td><td>—</td></tr>
        <tr><td>pre-decrement by 2</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>0</td><td>0</td><td>1</td><td>1</td><td><code>LDA ,--X</code></td><td><code>LDA [,--X]</code></td></tr>
        <tr><td>zero offset</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>0</td><td>1</td><td>0</td><td>0</td><td><code>LDA ,X</code></td><td><code>LDA [,X]</code></td></tr>
        <tr><td>B accumulator offset</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>0</td><td>1</td><td>0</td><td>1</td><td><code>LDA B,X</code></td><td><code>LDA [B,X]</code></td></tr>
        <tr><td>A accumulator offset</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>0</td><td>1</td><td>1</td><td>0</td><td><code>LDA A,X</code></td><td><code>LDA [A,X]</code></td></tr>
        <tr><td>8-bit signed offset follows</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>1</td><td>0</td><td>0</td><td>0</td><td><code>LDA $01,X</code></td><td><code>LDA [$01,X]</code></td></tr>
        <tr><td>16-bit signed offset follows</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>1</td><td>0</td><td>0</td><td>1</td><td><code>LDA $0100,X</code></td><td><code>LDA [$0100,X]</code></td></tr>
        <tr><td>D accumulator offset (16-bit)</td><td>1</td><td>R</td><td>R</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>1</td><td>0</td><td>1</td><td>1</td><td><code>LDY D,X</code></td><td><code>LDY [D,X]</code></td></tr>
        <tr><td>8-bit PC-relative offset follows</td><td>1</td><td>X</td><td>X</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>1</td><td>1</td><td>0</td><td>0</td><td><code>LDA $01,PCR</code></td><td><code>LDA [$01,PCR]</code></td></tr>
        <tr><td>16-bit PC-relative offset follows</td><td>1</td><td>X</td><td>X</td><td style="color:var(--cc-set,#f0c060);font-weight:bold">I</td><td>1</td><td>1</td><td>0</td><td>1</td><td><code>LDA $0001,PCR</code></td><td><code>LDA [$0001,PCR]</code></td></tr>
        <tr><td>extended indirect — fixed postbyte $9F</td><td>1</td><td>0</td><td>0</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>—</td><td><code>LDA [$0000]</code></td></tr>
      </tbody>
    </table>

    <h3>Deriving a Postbyte</h3>
    <p>The postbyte is the bitwise OR of the register field and the mode field.
    The fields occupy non-overlapping bit positions, so no arithmetic is needed —
    just OR the two rows together.</p>
    <p><strong>Example: <code>STA ,-X</code> &rarr; opcode <code>$A7</code>, postbyte <code>$82</code></strong></p>
    <table class="modes-table or-derive-table" style="width:50; font-family:monospace; font-size:0.85rem;">
      <colgroup>
        <col style="width:17%"><!-- Field -->
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%"><col style="width:3.5%">
        <col style="width:7%"><!-- Hex -->
      </colgroup>
      <thead>
        <tr style="background:var(--bg2,#2a2a2a); color:var(--text-dim,#888)">
          <th style="text-align:left">Field</th>
          <th style="text-align:center">7</th><th style="text-align:center">6</th>
          <th style="text-align:center">5</th><th style="text-align:center">4</th>
          <th style="text-align:center">3</th><th style="text-align:center">2</th>
          <th style="text-align:center">1</th><th style="text-align:center">0</th>
          <th style="text-align:center">Hex</th>
        </tr>
      </thead>
      <tbody>
        <tr><td>Register X (bits 6-5 = 00)</td><td>1</td><td>0</td><td>0</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>$80</td></tr>
        <tr><td>Mode ,&#x2013;R (pre-decrement 1)</td><td>-</td><td>-</td><td>-</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>$02</td></tr>
        <tr style="background:var(--bg2,#2a2a2a); color:var(--cc-set,#f0c060); font-weight:bold"><td>OR result</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>$82</td></tr>
      </tbody>
    </table>
    <p>To use a different register, change bits 6-5. To use a different mode, change bits 3-0.
    The fields never overlap so the OR always produces a unique, valid postbyte.</p>

    <!-- NOTE: "Collect Notes as CSV" button and collectNotes() function removed.
         The feature exported the postbyte table notes column as CSV -- a half-formed
         version of a byte-to-instruction decoder (bytes in, human-readable out).
         The concept is worth revisiting as part of a debugging tool: given a raw
         opcode byte + postbyte, identify the instruction and addressing mode.
         See git history (generate.py around line 1269) for the original implementation.
    -->

    <h3>Encoding Examples</h3>
    <table class="modes-table encoding-examples-table" style="width:100%; table-layout:fixed;">
      <colgroup>
        <col style="width:14%"><!-- Syntax -->
        <col style="width:20%"><!-- Bytes -->
        <col style="width:8%"><!-- Bytes -->
        <col style="width:56%"><!-- Description -->
      </colgroup>
      <thead>
        <tr><th style="text-align:left">Syntax</th><th style="text-align:left">Bytes</th><th style="text-align:center">Bytes</th><th style="text-align:left">Description</th></tr>
      </thead>
      <tbody>{"".join(ex_rows)}</tbody>
    </table>
  </main>
  <footer>
    <p>Motorola MC6809 Instruction Reference</p>
  </footer>
</body>
</html>
'''


def main():
    os.makedirs(os.path.join(OUTPUT_DIR, 'groups'), exist_ok=True)

    # Load all groups in order (skip special files like indexed_postbyte)
    groups_data = {}
    for f in glob.glob(os.path.join(OPCODES_DIR, 'opcodes_*.json')):
        if 'postbyte' in os.path.basename(f):
            continue
        d = json.load(open(f))
        groups_data[d['group']] = d['instructions']

    ordered_groups = []
    for key, title in GROUP_ORDER:
        if key in groups_data:
            ordered_groups.append((key, title, groups_data[key]))

    # Write CSS
    with open(os.path.join(OUTPUT_DIR, 'style.css'), 'w') as f:
        f.write(render_css())
    print('Written: style.css')

    # Write index
    with open(os.path.join(OUTPUT_DIR, 'index.html'), 'w') as f:
        f.write(render_index(ordered_groups))
    print('Written: index.html')

    # Write group pages
    for key, title, instructions in ordered_groups:
        path = os.path.join(OUTPUT_DIR, 'groups', f'{key}.html')
        with open(path, 'w') as f:
            f.write(render_group_page(key, title, instructions))
        print(f'Written: groups/{key}.html  ({len(instructions)} instructions)')

    # Write indexed postbyte reference page
    pb_path = os.path.join(OPCODES_DIR, 'opcodes_indexed_postbyte.json')
    if os.path.exists(pb_path):
        pb_data = json.load(open(pb_path))
        path = os.path.join(OUTPUT_DIR, 'groups', 'indexed_postbyte.html')
        with open(path, 'w') as f:
            f.write(render_postbyte_page(pb_data))
        print('Written: groups/indexed_postbyte.html')

    total = sum(len(i) for _, _, i in ordered_groups)
    print(f'\nDone. {total} instructions across {len(ordered_groups)} groups.')
    print(f'Open: {os.path.join(OUTPUT_DIR, "index.html")}')

if __name__ == '__main__':
    main()
