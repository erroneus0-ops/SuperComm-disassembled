#!/usr/bin/env python3
"""
prepasm.py v2 - Convert disassembler listing to lwasm-assembleable source.
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

def process(infile, outfile, target='asm6809'):
    with open(infile, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # ── Pre-scan: collect BSS EQU offsets to calculate sizes ─────────────────
    import re
    bss_equ_re = re.compile(
        r'^(\S+)\s+EQU\s+\$([0-9A-Fa-f]+)\s*(?:;\s*(\d+)\s*bytes?\s*(?:—\s*(.+))?|;\s*(.+))?$'
    )

    # Collect all BSS EQU entries: (name, offset, comment)
    in_bss = False
    bss_entries = []  # [(name, offset, comment)]
    for l in lines:
        raw = l.rstrip('\n')
        if '── BSS Variable Equates' in raw or '── BSS Variable Declarations' in raw:
            in_bss = True; continue
        if in_bss and raw.strip() == '':
            in_bss = False; continue
        if in_bss and 'EQU' in raw and not raw.strip().startswith(';'):
            m = bss_equ_re.match(raw.strip())
            if m:
                name = m.group(1)
                off  = int(m.group(2), 16)
                # Extract analyst comment (group 4 = after "— ", group 5 = simple)
                analyst = m.group(4) or m.group(5) or ''
                # Strip leading size annotation if present
                if analyst and re.match(r'^\d+\s+bytes?\s*$', analyst.strip()):
                    analyst = ''
                bss_entries.append((name, off, analyst))

    # Build offset→size map from gaps
    bss_size = {}
    for i, (name, off, cmt) in enumerate(bss_entries):
        if i + 1 < len(bss_entries):
            bss_size[name] = bss_entries[i+1][1] - off
        else:
            bss_size[name] = 1  # last entry unknown
    bss_comment = {name: cmt for name, off, cmt in bss_entries}

    in_bss_block = False

    out = []
    for line in lines:
        raw = line.rstrip("\n")

        # Detect BSS block start/end
        if '── BSS Variable Equates' in raw or '── BSS Variable Declarations' in raw:
            in_bss_block = True
            out.append(line)
            continue
        if in_bss_block and raw.strip() == '':
            in_bss_block = False
            out.append(line)
            continue

        # Convert BSS EQU to RMB
        if in_bss_block and 'EQU' in raw and not raw.strip().startswith(';'):
            m = bss_equ_re.match(raw.strip())
            if m:
                name = m.group(1)
                size = bss_size.get(name, 1)
                cmt  = bss_comment.get(name, '')
                if cmt:
                    out.append(f"{name:<14}rmb    {size:<6} ; {cmt}\n")
                else:
                    out.append(f"{name:<14}rmb    {size}\n")
                continue

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

            # Handle PC-relative instructions missing ,PCR
            # Post-byte $8D = PCR-relative indexed addressing
            # Applies to LEA ops AND any load/store with PCR post-byte
            elif len(hex_bytes) >= 2:
                key = (hex_bytes[0], hex_bytes[1])
                # already_pcr: suppress further PCR processing if ,PC or ,PCR present
                already_pcr = ',PCR' in rest or ',PC' in rest
                is_stack_op = hex_bytes[0] in (0x34, 0x35, 0x36, 0x37)
                # Only indexed-capable opcodes have a post-byte as byte 2
                # Direct-page ops ($90-$9F, $D0-$DF) use byte 2 as address, not post-byte
                is_indexed_capable = hex_bytes[0] in (
                    0x30,0x31,0x32,0x33,          # LEA ops
                    0x60,0x63,0x64,0x66,0x67,0x68,0x69,0x6A,0x6C,0x6D,0x6E,0x6F,  # indexed unary
                    0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,  # indexed ALU
                    0xA8,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF,
                    0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,
                    0xE8,0xE9,0xEA,0xEB,0xEC,0xED,0xEE,0xEF,
                )
                has_pcr_postbyte = (len(hex_bytes) >= 2 and
                                    hex_bytes[0] not in (0x20,0x21,0x22,0x23,0x24,0x25,
                                                         0x26,0x27,0x28,0x29,0x2a,0x2b,
                                                         0x2c,0x2d,0x2e,0x2f,0x8D) and
                                    hex_bytes[1] == 0x8D and
                                    not already_pcr and
                                    not is_stack_op and
                                    is_indexed_capable)
                if key in PCR_LEAS and not already_pcr:
                    mne = PCR_LEAS[key]
                    rest = re.sub(
                        rf"({mne}\s+)(\S+?)(\s|$)",
                        lambda mo: mo.group(1) + mo.group(2) + ",PCR" + mo.group(3),
                        rest,
                        count=1
                    )
                elif has_pcr_postbyte:
                    # Add ,PCR to the operand of any other PCR-relative instruction
                    rest = re.sub(
                        r'(\b\w+\s+)(\S+?)(\s|$)',
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

    # ── lwasm dialect: convert ,PC to ,PCR throughout ────────────────────
    # Only convert ,PC that is an addressing mode suffix (LEA/load/store)
    # NOT ,PC in PULS/PSHS/PULU/PSHU register lists where PC is a register name
    STACK_OPS = re.compile(r'\b(PULS|PSHS|PULU|PSHU)\b', re.IGNORECASE)
    if target == 'lwasm':
        converted = []
        for line in out:
            if ',PC' in line and not line.strip().startswith(';'):
                # Skip if this is a stack op — PC is a register, not an addr mode
                if not STACK_OPS.search(line):
                    line = re.sub(r',PC\b(?!R)', ',PCR', line)
            converted.append(line)
        out = converted

    with open(outfile, "w", encoding="utf-8") as f:
        f.writelines(out)

    print(f"Processed {len(lines)} lines -> {outfile}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(
        description='Strip disassembler listing to assembleable source')
    parser.add_argument('input',  help='Input proj.asm file')
    parser.add_argument('output', help='Output clean.asm file')
    parser.add_argument('--target', choices=['asm6809', 'lwasm'], default='asm6809',
        help='Target assembler dialect (default: asm6809). '
             'Use --target lwasm to convert ,PC to ,PCR for lwasm compatibility.')
    args = parser.parse_args()
    process(args.input, args.output, target=args.target)
