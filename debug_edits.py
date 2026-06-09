import re, json, sys

ADDR_RE = re.compile(r'^\$([0-9A-Fa-f]{4})\s')
LABEL_LINE_RE = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)\s*$')
LEAX_RE = re.compile(r'^\$([0-9A-Fa-f]{4})\s+30 8D ([0-9A-Fa-f]{2}) ([0-9A-Fa-f]{2})\s')
XREF_RE = re.compile(r';\s*[XYUS]\s*\u2192\s*([A-Za-z_][A-Za-z0-9_]*)')

asm_path = sys.argv[1]
json_path = sys.argv[2]

with open(asm_path, encoding='utf-8', errors='replace') as f:
    lines = f.readlines()

with open(json_path) as f:
    d = json.load(f)

label_to_addr = {v: int(k,16) for k,v in d.get('labels',{}).items()}

for idx, raw in enumerate(lines):
    line = raw.rstrip()
    m = LEAX_RE.match(line)
    if m:
        insn_addr = int(m.group(1), 16)
        hi = int(m.group(2), 16)
        lo = int(m.group(3), 16)
        raw_off = (hi << 8) | lo
        signed_off = raw_off - 0x10000 if raw_off >= 0x8000 else raw_off
        target = insn_addr + 4 + signed_off
        xm = XREF_RE.search(line)
        if xm:
            lbl = xm.group(1)
            label_to_addr[lbl] = target

addr_006F = label_to_addr.get('Dat_006F', -1)
print("Dat_006F resolves to: $%04X" % addr_006F)

current_addr = None
for idx, raw in enumerate(lines):
    line = raw.rstrip()
    a = ADDR_RE.match(line)
    if a:
        current_addr = int(a.group(1), 16)
    elif LABEL_LINE_RE.match(line):
        lbl = line.strip()
        if lbl in label_to_addr:
            current_addr = label_to_addr[lbl]
    if line.strip() == '/replace/':
        ca_str = "$%04X" % current_addr if current_addr is not None else "None"
        print("/replace/ found at line %d, current_addr=%s" % (idx+1, ca_str))
        print("Next 3 lines:")
        for j in range(idx+1, min(idx+4, len(lines))):
            print("  " + repr(lines[j].rstrip()))
        break
else:
    print("ERROR: /replace/ not found in file!")
    print("First 10 lines of file:")
    for i,l in enumerate(lines[:10]):
        print("  %d: %s" % (i+1, repr(l.rstrip())))
