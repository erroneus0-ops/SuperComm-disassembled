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

def render_modes_table(modes):
    rows = []
    for m in modes:
        cycles = m.get('cycles', '?')
        bytes_ = m.get('bytes', '?')
        syntax = m['syntax'].replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
        rows.append(
            f'<tr>'
            f'<td class="mode">{m["mode"].replace("-", "&#8209;")}</td>'
            f'<td class="syntax"><code>{syntax}</code></td>'
            f'<td class="opcode"><code>${m["opcode"]}</code></td>'
            f'<td class="bytes">{bytes_}</td>'
            f'<td class="cycles">{cycles}</td>'
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
        <thead><tr><th colspan="2">16-bit</th></tr><tr><th>Reg</th><th>Code</th></tr></thead>
        <tbody>{rows16}</tbody>
      </table>
      <table class="modes-table" style="width:auto">
        <thead><tr><th colspan="2">8-bit</th></tr><tr><th>Reg</th><th>Code</th></tr></thead>
        <tbody>{rows8}</tbody>
      </table>
    </div>
    <div class="interactive no-print" style="margin-top:1rem">
      <h4>{mnemonic} builder</h4>
      <div style="display:flex;gap:2rem;flex-wrap:wrap">
        <div>
          <div style="font-size:0.8rem;color:var(--text-secondary,#666);margin-bottom:4px">16-bit transfers</div>
          <div style="display:flex;gap:8px;margin-bottom:6px">
            <div>
              <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">from</div>
              <div id="src16-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
            </div>
            <div>
              <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">to</div>
              <div id="dst16-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
            </div>
          </div>
          <div id="out16-{mnemonic}" style="font-family:monospace;font-size:0.9rem;min-height:1.4em;padding:4px 6px;border:1px solid var(--border,#ccc);border-radius:4px;background:var(--surface-1,#f8f8f8);color:var(--text-primary,#111);min-width:160px">&nbsp;</div>
        </div>
        <div>
          <div style="font-size:0.8rem;color:var(--text-secondary,#666);margin-bottom:4px">8-bit transfers</div>
          <div style="display:flex;gap:8px;margin-bottom:6px">
            <div>
              <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">from</div>
              <div id="src8-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
            </div>
            <div>
              <div style="font-size:0.75rem;color:var(--text-muted,#888);margin-bottom:3px">to</div>
              <div id="dst8-{mnemonic}" style="display:flex;flex-direction:column;gap:4px"></div>
            </div>
          </div>
          <div id="out8-{mnemonic}" style="font-family:monospace;font-size:0.9rem;min-height:1.4em;padding:4px 6px;border:1px solid var(--border,#ccc);border-radius:4px;background:var(--surface-1,#f8f8f8);color:var(--text-primary,#111);min-width:160px">&nbsp;</div>
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
  <table class="modes-table">
    <thead>
      <tr>
        <th>Mode</th><th>Syntax</th><th>Opcode</th><th>Bytes</th><th>Cycles</th>
      </tr>
    </thead>
    <tbody>
      {render_modes_table(modes)}
    </tbody>
  </table>
  <table class="cc-table">
    <thead>
      <tr><th colspan="5">Condition Codes</th></tr>
      <tr><th>H</th><th>N</th><th>Z</th><th>V</th><th>C</th></tr>
    </thead>
    <tbody>
      <tr>{cc_html_cells}</tr>
    </tbody>
  </table>
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
}

* { box-sizing: border-box; margin: 0; padding: 0; }

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
.modes-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 0.75rem;
  font-size: 0.9rem;
}

.modes-table th {
  background: var(--bg3);
  color: var(--text-dim);
  padding: 0.4rem 0.75rem;
  text-align: left;
  border: 1px solid var(--border);
  font-weight: normal;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.modes-table td {
  padding: 0.4rem 0.75rem;
  border: 1px solid var(--border);
  background: var(--bg2);
}

.modes-table code {
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
  color: var(--accent);
}

td.mode  { color: var(--text-dim); font-size: 0.85rem; }
td.bytes, td.cycles { text-align: center; color: var(--text-dim); }

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
    reg_rows = ''.join(
        f'<tr><td><code>%{r["bits"]}xxxxx</code></td><td>{r["register"]}</td></tr>'
        for r in data['register_bits']['values']
    )

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
        op2 = f' <code>${ex["postbyte"]}</code>' if 'postbyte' in ex else ''
        op3 = f' <code>${ex.get("operand","")}</code>' if 'operand' in ex else ''
        ex_rows.append(f'''
<tr>
  <td><code>{ex["syntax"]}</code></td>
  <td><code>${ex["opcode"]}</code>{op2}{op3}</td>
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
    <table class="modes-table reg-table">
      <thead><tr><th>Bit pattern</th><th>Register</th></tr></thead>
      <tbody>{reg_rows}</tbody>
    </table>

    <h3>Postbyte Bit Map</h3>
    <p>All postbyte values shown for register X (bits 6-5 = 00). For Y add $20, U add $40, S add $60.</p>
    <table class="modes-table postbyte-table" style="width:100%; font-family: monospace; font-size: 0.85rem;">
      <thead>
        <tr>
          <th style="text-align:left">Syntax</th>
          <th>7</th><th>6</th><th>5</th><th>4</th>
          <th>3</th><th>2</th><th>1</th><th>0</th>
          <th style="text-align:left">Notes</th>
        </tr>
        <tr style="font-size:0.75rem; color:var(--text-dim)">
          <th></th>
          <th>r</th><th>R</th><th>R</th><th>i</th>
          <th>m</th><th>m</th><th>m</th><th>m</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr class="section-header"><td colspan="10"><strong>Register select (bits 6-5 when bit 7=1)</strong></td></tr>
        <tr><td>,X</td><td>1</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td contenteditable="true"></td></tr>
        <tr><td>,Y</td><td>1</td><td>0</td><td>1</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td contenteditable="true"></td></tr>
        <tr><td>,U</td><td>1</td><td>1</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td contenteditable="true"></td></tr>
        <tr><td>,S</td><td>1</td><td>1</td><td>1</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td contenteditable="true"></td></tr>
        <tr class="section-header"><td colspan="10"><strong>5-bit signed offset mode (bit 7=0, no indirect)</strong></td></tr>
        <tr><td>n,R</td><td>0</td><td>R</td><td>R</td><td>n</td><td>n</td><td>n</td><td>n</td><td>n</td><td contenteditable="true">offset -16 to +15</td></tr>
        <tr class="section-header"><td colspan="10"><strong>Standard indexed (bit 7=1, bit 4=0, no indirect)</strong></td></tr>
        <tr><td>,R+</td>  <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td contenteditable="true">post-increment by 1</td></tr>
        <tr><td>,R++</td> <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td contenteditable="true">post-increment by 2</td></tr>
        <tr><td>,-R</td>  <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td contenteditable="true">pre-decrement by 1</td></tr>
        <tr><td>,--R</td> <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>0</td><td>1</td><td>1</td><td contenteditable="true">pre-decrement by 2</td></tr>
        <tr><td>,R</td>   <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td contenteditable="true">zero offset</td></tr>
        <tr><td>B,R</td>  <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td contenteditable="true">B accumulator offset</td></tr>
        <tr><td>A,R</td>  <td>1</td><td>R</td><td>R</td><td>0</td><td>0</td><td>1</td><td>1</td><td>0</td><td contenteditable="true">A accumulator offset</td></tr>
        <tr><td>n8,R</td> <td>1</td><td>R</td><td>R</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td><td contenteditable="true">8-bit signed offset follows</td></tr>
        <tr><td>n16,R</td><td>1</td><td>R</td><td>R</td><td>0</td><td>1</td><td>0</td><td>0</td><td>1</td><td contenteditable="true">16-bit signed offset follows (2 bytes)</td></tr>
        <tr><td>D,R</td>  <td>1</td><td>R</td><td>R</td><td>0</td><td>1</td><td>0</td><td>1</td><td>1</td><td contenteditable="true">D accumulator offset (16-bit)</td></tr>
        <tr><td>n8,PCR</td> <td>1</td><td>R</td><td>R</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td><td contenteditable="true">8-bit PC-relative offset follows</td></tr>
        <tr><td>n16,PCR</td><td>1</td><td>R</td><td>R</td><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td><td contenteditable="true">16-bit PC-relative offset follows</td></tr>
        <tr class="section-header"><td colspan="10"><strong>Indirect variants (bit 4=1) — EA is address of address</strong></td></tr>
        <tr><td>[,R++]</td>  <td>1</td><td>R</td><td>R</td><td>1</td><td>0</td><td>0</td><td>0</td><td>1</td><td contenteditable="true"></td></tr>
        <tr><td>[,--R]</td>  <td>1</td><td>R</td><td>R</td><td>1</td><td>0</td><td>0</td><td>1</td><td>1</td><td contenteditable="true"></td></tr>
        <tr><td>[,R]</td>    <td>1</td><td>R</td><td>R</td><td>1</td><td>0</td><td>1</td><td>0</td><td>0</td><td contenteditable="true"></td></tr>
        <tr><td>[B,R]</td>   <td>1</td><td>R</td><td>R</td><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td contenteditable="true"></td></tr>
        <tr><td>[A,R]</td>   <td>1</td><td>R</td><td>R</td><td>1</td><td>0</td><td>1</td><td>1</td><td>0</td><td contenteditable="true"></td></tr>
        <tr><td>[n8,R]</td>  <td>1</td><td>R</td><td>R</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td contenteditable="true">8-bit offset follows</td></tr>
        <tr><td>[n16,R]</td> <td>1</td><td>R</td><td>R</td><td>1</td><td>1</td><td>0</td><td>0</td><td>1</td><td contenteditable="true">16-bit offset follows</td></tr>
        <tr><td>[D,R]</td>   <td>1</td><td>R</td><td>R</td><td>1</td><td>1</td><td>0</td><td>1</td><td>1</td><td contenteditable="true"></td></tr>
        <tr><td>[n8,PCR]</td> <td>1</td><td>R</td><td>R</td><td>1</td><td>1</td><td>1</td><td>0</td><td>0</td><td contenteditable="true">8-bit PC-relative offset follows</td></tr>
        <tr><td>[n16,PCR]</td><td>1</td><td>R</td><td>R</td><td>1</td><td>1</td><td>1</td><td>0</td><td>1</td><td contenteditable="true">16-bit PC-relative offset follows</td></tr>
        <tr><td>[addr]</td>  <td>1</td><td>0</td><td>0</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td contenteditable="true">extended indirect $9F — fixed, no register variant</td></tr>
      </tbody>
    </table>

    <h3>Deriving a Postbyte</h3>
    <p>The postbyte is the bitwise OR of the register field and the mode field.
    The fields occupy non-overlapping bit positions, so no arithmetic is needed —
    just OR the two rows together.</p>
    <p><strong>Example: <code>STA ,-X</code> &rarr; opcode <code>$A7</code>, postbyte <code>$82</code></strong></p>
    <table class="modes-table postbyte-table" style="width:auto; font-family:monospace;">
      <thead>
        <tr><th style="text-align:left">Field</th><th>7</th><th>6</th><th>5</th><th>4</th><th>3</th><th>2</th><th>1</th><th>0</th><th style="text-align:left">Hex</th></tr>
      </thead>
      <tbody>
        <tr><td>Register X (bits 6-5 = 00)</td><td>1</td><td>0</td><td>0</td><td>x</td><td>x</td><td>x</td><td>x</td><td>x</td><td>$80</td></tr>
        <tr><td>Mode ,-R (pre-decrement 1)</td><td>x</td><td>x</td><td>x</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>$02</td></tr>
        <tr class="section-header"><td>OR result</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td><strong>$82</strong></td></tr>
      </tbody>
    </table>
    <p>To use a different register, change bits 6-5. To use a different mode, change bits 3-0.
    The fields never overlap so the OR always produces a unique, valid postbyte.</p>

    <div style="margin: 1rem 0;">
      <button onclick="collectNotes()" style="font-family:monospace; padding:0.4rem 1rem; background:var(--bg3); color:var(--accent); border:1px solid var(--border); border-radius:3px; cursor:pointer;">Collect Notes as CSV</button>
      <textarea id="notes-csv" rows="6" style="display:none; width:100%; margin-top:0.5rem; font-family:monospace; font-size:0.8rem; background:var(--code-bg); color:var(--accent2); border:1px solid var(--border); border-radius:3px; padding:0.5rem;" readonly></textarea>
    </div>
    <script>
    function collectNotes() {{
      var rows = document.querySelectorAll('.postbyte-table tbody tr:not(.section-header)');
      var lines = ['syntax,notes'];
      rows.forEach(function(row) {{
        var cells = row.querySelectorAll('td');
        if (cells.length < 10) return;
        var syntax = cells[0].textContent.trim();
        var notes  = cells[9].textContent.trim();
        if (!syntax) return;
        // CSV-escape: wrap in quotes, double any internal quotes
        function esc(s) {{ return '"' + s.replace(/"/g, '""') + '"'; }}
        lines.push(esc(syntax) + ',' + esc(notes));
      }});
      var ta = document.getElementById('notes-csv');
      ta.value = lines.join('\\n');
      ta.style.display = 'block';
      ta.select();
    }}
    </script>

    <h3>Encoding Examples</h3>
    <table class="modes-table" style="width:100%">
      <thead>
        <tr><th>Syntax</th><th>Bytes</th><th>Total bytes</th><th>Description</th></tr>
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
