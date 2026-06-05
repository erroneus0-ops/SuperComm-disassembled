#!/usr/bin/env python3
"""
strip_listing.py v2 - Convert disassembler listing to lwasm-assembleable source.
Short branches use numeric PC-relative offsets (*+N) to avoid lwasm optimization issues.
"""
import sys
import re

KNOWN_MNEMONICS = {
    "LDA","LDB","LDD","LDX","LDY","LDS","LDU",
    "STA","STB","STD","STX","STY","STS","STU",
    "ADDA","ADDB","ADDD","SUBA","SUBB","SUBD","ADCA","ADCB","SBCA","SBCB",
    "ANDA","ANDB","ORA","ORB","EORA","EORB","BITA","BITB",
    "CMPA","CMPB","CMPD","CMPX","CMPY","CMPS","CMPU",
    "BRA","BRN","BHI","BLS","BCC","BCS","BHS","BLO","BNE","BEQ",
    "BVC","BVS","BPL","BMI","BGE","BLT","BGT","BLE",
    "LBRA","LBRN","LBHI","LBLS","LBCC","LBCS","LBHS","LBLO","LBNE","LBEQ",
    "LBVC","LBVS","LBPL","LBMI","LBGE","LBLT","LBGT","LBLE",
    "BSR","LBSR","JSR","RTS","RTI","NOP","SEX","DAA","ABX","MUL",
    "SWI","SWI2","SWI3","CWAI","SYNC",
    "LEAX","LEAY","LEAS","LEAU","PSHS","PULS","PSHU","PULU",
    "CLRA","CLRB","CLR","TSTA","TSTB","TST",
    "INCA","INCB","INC","DECA","DECB","DEC",
    "ROLA","ROLB","ROL","RORA","RORB","ROR",
    "ASLA","ASLB","ASL","ASRA","ASRB","ASR",
    "LSRA","LSRB","LSR","COMA","COMB","COM","NEGA","NEGB","NEG",
    "TFR","EXG","ANDCC","ORCC","OS9","SETDP",
    "FCB","FCC","FCS","FDB","RMB","EQU","ORG","END","NAM","TTL",
    "MOD","EMOD","USE","SECTION","ENDSECT","IFDEF","IFNDEF","ELSE","ENDC",
    "MULD","DIVD","DIVQ","TFM","AIM","OIM","EIM","TIM","LDMD",
}

# Short branch opcodes: opcode byte -> mnemonic
SHORT_BRANCH_OPS = {
    0x20:'BRA', 0x21:'BRN', 0x22:'BHI', 0x23:'BLS',
    0x24:'BCC', 0x25:'BCS', 0x26:'BNE', 0x27:'BEQ',
    0x28:'BVC', 0x29:'BVS', 0x2A:'BPL', 0x2B:'BMI',
    0x2C:'BGE', 0x2D:'BLT', 0x2E:'BGT', 0x2F:'BLE',
    0x8D:'BSR',
}

# PC-relative LEA opcodes
PCR_LEAS = {
    (0x30, 0x8D): "LEAX",
    (0x31, 0x8D): "LEAY",
    (0x32, 0x8D): "LEAS",
    (0x33, 0x8D): "LEAU",
}

addr_line = re.compile(
    r"^(\$[0-9A-Fa-f]{4})  ((?:[0-9A-Fa-f]{2} )*[0-9A-Fa-f]{2})\s+(.*)$"
)

def branch_expr(offset_byte):
    """Convert short branch offset byte to PC-relative expression."""
    signed = offset_byte if offset_byte < 128 else offset_byte - 256
    n = 2 + signed  # branch instruction is 2 bytes
    return f'*+{n}' if n >= 0 else f'*{n}'

def fix_fcc_quotes(raw):
    m = re.match(r'(\s*)(FC[CS])\s+"(.*)"\s*((?:;.*)?)$', raw)
    if not m:
        return raw
    indent, directive, content, comment = m.groups()
    if '"' in content:
        return indent + "FCB    $22" + ("  " + comment if comment else "")
    return raw

def process(infile, outfile):
    with open(infile, "r", encoding="utf-8") as f:
        lines = f.readlines()

    out = []
    for line in lines:
        raw = line.rstrip("\n")

        if not raw.strip() or raw.strip().startswith(";") or raw.strip().startswith("*"):
            out.append(line)
            continue

        m = addr_line.match(raw)
        if m:
            addr_str, hex_str, rest = m.group(1), m.group(2), m.group(3)
            hex_bytes = [int(x, 16) for x in hex_str.split()]

            # Handle ??? unknown opcode -> FCB $xx
            if "???" in rest:
                byte_val = hex_bytes[0] if hex_bytes else 0
                label_m = re.match(r"(\S+:)\s+\?\?\?", rest.strip())
                if label_m:
                    rest = f"{label_m.group(1)}      FCB    ${byte_val:02X}               ; ??? unknown opcode"
                else:
                    rest = f"FCB    ${byte_val:02X}               ; ??? unknown opcode"

            # Handle short branches -> use numeric PC offset
            elif len(hex_bytes) == 2 and hex_bytes[0] in SHORT_BRANCH_OPS:
                mne = SHORT_BRANCH_OPS[hex_bytes[0]]
                expr = branch_expr(hex_bytes[1])
                # Preserve label if present
                label_m = re.match(r"(\S+:)\s+\S+\s+\S+", rest.strip())
                comment_m = re.search(r';.*$', rest)
                comment = '  ' + comment_m.group(0) if comment_m else ''
                if label_m:
                    rest = f"{label_m.group(1)}      {mne} {expr}{comment}"
                else:
                    rest = f"{mne} {expr}{comment}"

            # Handle PC-relative LEA missing ,PCR
            elif len(hex_bytes) >= 2:
                key = (hex_bytes[0], hex_bytes[1])
                if key in PCR_LEAS:
                    mne = PCR_LEAS[key]
                    rest = re.sub(
                        rf"({mne}\s+)(\S+?)(\s|$)",
                        lambda mo: mo.group(1) + mo.group(2) + ",PCR" + mo.group(3),
                        rest,
                        count=1
                    )

            # Indent non-label lines
            first_token = rest.split()[0] if rest.split() else ""
            if first_token and not first_token.endswith(":"):
                rest = "\t" + rest

            out.append(rest + "\n")
        else:
            # Fix FCC/FCS with embedded quote characters
            fixed = fix_fcc_quotes(raw)
            if fixed != raw:
                out.append(fixed + "\n")
                continue

            # Detect prose leaking from block comments
            sline = raw.strip()
            first = sline.split()[0] if sline else ""
            first_bare = first.rstrip(":")
            if (sline
                    and not sline.startswith(";")
                    and not sline.startswith("*")
                    and first_bare not in KNOWN_MNEMONICS
                    and not first.endswith(":")
                    and " " in sline
                    and "EQU" not in sline.upper()
                    and not re.match(r"^\$?[0-9A-Fa-f]+\s", sline)):
                out.append("; " + raw.lstrip() + "\n")
                continue

            out.append(line)

    with open(outfile, "w", encoding="utf-8") as f:
        f.writelines(out)

    print(f"Processed {len(lines)} lines -> {outfile}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python strip_listing.py input.asm output.asm")
        sys.exit(1)
    process(sys.argv[1], sys.argv[2])
