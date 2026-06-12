#!/usr/bin/env python3
"""
generate.py — 6809 Reference Manual HTML generator
Reads opcodes/*.json and produces HTML reference pages.

Usage:
    python generate.py [--output html]
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
        rows.append(
            f'<tr>'
            f'<td class="mode">{m["mode"].replace("-", "&#8209;")}</td>'
            f'<td class="syntax"><code>{m["syntax"]}</code></td>'
            f'<td class="opcode"><code>${m["opcode"]}</code></td>'
            f'<td class="bytes">{bytes_}</td>'
            f'<td class="cycles">{cycles}</td>'
            f'</tr>'
        )
    return '\n'.join(rows)

def render_instruction(instr):
    mnemonic = instr['mnemonic']
    full_name = instr['full_name']
    operation = instr.get('operation', '')
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
  {notes_html}
</div>
'''

def render_group_page(group_key, group_title, instructions):
    instruction_html = '\n'.join(render_instruction(i) for i in instructions)
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

def main():
    os.makedirs(os.path.join(OUTPUT_DIR, 'groups'), exist_ok=True)

    # Load all groups in order
    groups_data = {}
    for f in glob.glob(os.path.join(OPCODES_DIR, 'opcodes_*.json')):
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

    total = sum(len(i) for _, _, i in ordered_groups)
    print(f'\nDone. {total} instructions across {len(ordered_groups)} groups.')
    print(f'Open: {os.path.join(OUTPUT_DIR, "index.html")}')

if __name__ == '__main__':
    main()
