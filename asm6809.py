#!/usr/bin/env python3
"""
asm6809.py -- Minimal 6809 assembler for SuperComm disassembly testing.

Handles exactly what strip_listing generates:
  - 6809 instruction set (all addressing modes)
  - OS9 directive (SWI2 + function code)
  - EQU, FCB, FDB, FCC, FCS directives
  - Short branches as *+N / *-N
  - PCR-relative addressing (label,PCR)
  - Indexed addressing (n,U  n,X  n,Y  n,S  ,X+  etc.)
  - Two-pass assembly for forward references
  - OS-9 module output (raw binary, no CRC -- use fixmod separately)

Usage:
    python asm6809.py input.asm output.bin
"""

import sys, re, struct
from typing import Optional

# ── Opcode tables ────────────────────────────────────────────────────────────

# Inherent (no operand)
INHERENT = {
    'ABX':0x3A, 'ASLA':0x48, 'ASLB':0x58, 'ASRA':0x47, 'ASRB':0x57,
    'CLRA':0x4F, 'CLRB':0x5F, 'COMA':0x43, 'COMB':0x53,
    'DAA':0x19, 'DECA':0x4A, 'DECB':0x5A,
    'INCA':0x4C, 'INCB':0x5C, 'LSLA':0x48, 'LSLB':0x58,
    'LSRA':0x44, 'LSRB':0x54, 'MUL':0x3D, 'NEGA':0x40, 'NEGB':0x50,
    'NOP':0x12, 'ROLA':0x49, 'ROLB':0x59, 'RORA':0x46, 'RORB':0x56,
    'RTI':0x3B, 'RTS':0x39, 'SEX':0x1D, 'SWI':0x3F,
    'TSTA':0x4D, 'TSTB':0x5D,
}

# SWI2 (OS-9 system calls) and SWI3
SWI2 = 0x103F
SWI3 = 0x113F

# Short branches: opcode byte
SHORT_BRANCH = {
    'BRA':0x20,'BRN':0x21,'BHI':0x22,'BLS':0x23,
    'BCC':0x24,'BCS':0x25,'BNE':0x26,'BEQ':0x27,
    'BVC':0x28,'BVS':0x29,'BPL':0x2A,'BMI':0x2B,
    'BGE':0x2C,'BLT':0x2D,'BGT':0x2E,'BLE':0x2F,
    'BSR':0x8D,
    # Aliases
    'BHS':0x24,'BLO':0x25,
}

# Long branches: opcode word (10 xx)
LONG_BRANCH = {
    'LBRA':0x1016,'LBRN':0x1021,'LBHI':0x1022,'LBLS':0x1023,
    'LBCC':0x1024,'LBCS':0x1025,'LBNE':0x1026,'LBEQ':0x1027,
    'LBVC':0x1028,'LBVS':0x1029,'LBPL':0x102A,'LBMI':0x102B,
    'LBGE':0x102C,'LBLT':0x102D,'LBGT':0x102E,'LBLE':0x102F,
    'LBSR':0x17,  # special: single byte opcode
    # Aliases
    'LBHS':0x1024,'LBLO':0x1025,
}

# Register-register: TFR, EXG
REG_PAIR = {'TFR':0x1F, 'EXG':0x1E}
REG_NUM = {
    'D':0,'X':1,'Y':2,'U':3,'S':4,'PC':5,
    'A':8,'B':9,'CC':10,'DP':11,
}

# PSHS/PULS/PSHU/PULU
STACK_OPS = {
    'PSHS':0x34,'PULS':0x35,'PSHU':0x36,'PULU':0x37,
}
STACK_REG = {
    'CC':0x01,'A':0x02,'B':0x04,'DP':0x08,
    'X':0x10,'Y':0x20,'U':0x40,'S':0x40,'PC':0x80,
}

# ALU ops: (imm_op, direct_op, indexed_op, extended_op)
# None means mode not available
ALU = {
    'SUBA': (0x80, 0x90, 0xA0, 0xB0),
    'CMPA': (0x81, 0x91, 0xA1, 0xB1),
    'SBCA': (0x82, 0x92, 0xA2, 0xB2),
    'SUBD': (0x83, 0x93, 0xA3, 0xB3),
    'ANDA': (0x84, 0x94, 0xA4, 0xB4),
    'BITA': (0x85, 0x95, 0xA5, 0xB5),
    'LDA':  (0x86, 0x96, 0xA6, 0xB6),
    'STA':  (None, 0x97, 0xA7, 0xB7),
    'EORA': (0x88, 0x98, 0xA8, 0xB8),
    'ADCA': (0x89, 0x99, 0xA9, 0xB9),
    'ORA':  (0x8A, 0x9A, 0xAA, 0xBA),
    'ADDA': (0x8B, 0x9B, 0xAB, 0xBB),
    'CMPX': (0x8C, 0x9C, 0xAC, 0xBC),
    'LDX':  (0x8E, 0x9E, 0xAE, 0xBE),
    'STX':  (None, 0x9F, 0xAF, 0xBF),
    'SUBB': (0xC0, 0xD0, 0xE0, 0xF0),
    'CMPB': (0xC1, 0xD1, 0xE1, 0xF1),
    'SBCB': (0xC2, 0xD2, 0xE2, 0xF2),
    'ADDD': (0xC3, 0xD3, 0xE3, 0xF3),
    'ANDB': (0xC4, 0xD4, 0xE4, 0xF4),
    'BITB': (0xC5, 0xD5, 0xE5, 0xF5),
    'LDB':  (0xC6, 0xD6, 0xE6, 0xF6),
    'STB':  (None, 0xD7, 0xE7, 0xF7),
    'EORB': (0xC8, 0xD8, 0xE8, 0xF8),
    'ADCB': (0xC9, 0xD9, 0xE9, 0xF9),
    'ORB':  (0xCA, 0xDA, 0xEA, 0xFA),
    'ADDB': (0xCB, 0xDB, 0xEB, 0xFB),
    'LDD':  (0xCC, 0xDC, 0xEC, 0xFC),
    'STD':  (None, 0xDD, 0xED, 0xFD),
    'LDU':  (0xCE, 0xDE, 0xEE, 0xFE),
    'STU':  (None, 0xDF, 0xEF, 0xFF),
    # Page 2 (10 prefix)
    'CMPD': (0x1083, 0x1093, 0x10A3, 0x10B3),
    'CMPY': (0x108C, 0x109C, 0x10AC, 0x10BC),
    'LDY':  (0x108E, 0x109E, 0x10AE, 0x10BE),
    'STY':  (None,   0x109F, 0x10AF, 0x10BF),
    'LDS':  (0x10CE, 0x10DE, 0x10EE, 0x10FE),
    'STS':  (None,   0x10DF, 0x10EF, 0x10FF),
    # Page 3 (11 prefix)
    'CMPU': (0x1183, 0x1193, 0x11A3, 0x11B3),
    'CMPS': (0x118C, 0x119C, 0x11AC, 0x11BC),
}

# Single-operand: (direct, indexed, extended)
UNARY = {
    'NEG':  (0x00, 0x60, 0x70),
    'COM':  (0x03, 0x63, 0x73),
    'LSR':  (0x04, 0x64, 0x74),
    'ROR':  (0x06, 0x66, 0x76),
    'ASR':  (0x07, 0x67, 0x77),
    'ASL':  (0x08, 0x68, 0x78),
    'LSL':  (0x08, 0x68, 0x78),
    'ROL':  (0x09, 0x69, 0x79),
    'DEC':  (0x0A, 0x6A, 0x7A),
    'INC':  (0x0C, 0x6C, 0x7C),
    'TST':  (0x0D, 0x6D, 0x7D),
    'JMP':  (0x0E, 0x6E, 0x7E),
    'CLR':  (0x0F, 0x6F, 0x7F),
}

# LEA ops: (indexed only)
LEA = {
    'LEAX': 0x30, 'LEAY': 0x31, 'LEAS': 0x32, 'LEAU': 0x33,
}

# JSR/BSR (call instructions)
JSR_OPS = {'JSR': (0x9D, 0xAD, 0xBD)}

# STX indexed only variant for PSHS-like?
# ANDCC / ORCC
CCOPS = {'ANDCC': 0x1C, 'ORCC': 0x1A, 'CWAI': 0x3C}

# OS-9 system call table
OS9_CALLS = {
    # F$ calls
    'F$Link':0x00,'F$Load':0x01,'F$UnLink':0x02,'F$Fork':0x03,
    'F$Wait':0x04,'F$Chain':0x05,'F$Exit':0x06,'F$Mem':0x07,
    'F$Send':0x08,'F$Icpt':0x09,'F$Sleep':0x0A,'F$SSpd':0x0B,
    'F$ID':0x0C,'F$SPrior':0x0D,'F$SSWI':0x0E,'F$PErr':0x0F,
    'F$PrsNam':0x10,'F$CmpNam':0x11,'F$SchBit':0x12,'F$AllBit':0x13,
    'F$DelBit':0x14,'F$Time':0x15,'F$STime':0x16,'F$CRC':0x17,
    'F$GPrDsc':0x18,'F$GBlkMp':0x19,'F$GModDr':0x1A,'F$CpyMem':0x1B,
    'F$SUser':0x1C,'F$UnLoad':0x1D,'F$RTE':0x1E,'F$GPrDBT':0x1F,
    'F$Julian':0x27,'F$TLink':0x28,'F$DFork':0x29,'F$DExec':0x2A,
    'F$DExit':0x2B,'F$Alarm':0x38,'F$NMLink':0x42,'F$SigMask':0x4E,
    'F$Datim':0x51,
    # I$ calls
    'I$Attach':0x80,'I$Detach':0x81,'I$Dup':0x82,'I$Create':0x83,
    'I$Open':0x84,'I$MakDir':0x85,'I$ChgDir':0x86,'I$Delete':0x87,
    'I$Seek':0x88,'I$Read':0x89,'I$Write':0x8A,'I$ReadLn':0x8B,
    'I$WritLn':0x8C,'I$GetStt':0x8D,'I$SetStt':0x8E,'I$Close':0x8F,
    'I$DupS':0x90,
}

# ── Indexed post-byte encoding ────────────────────────────────────────────────

INDEX_REG = {'X':0x00,'Y':0x20,'U':0x40,'S':0x60}

def encode_indexed(operand: str, pc: int, symbols: dict, pass2: bool):
    """
    Encode indexed addressing post-byte(s).
    Returns (postbyte_list, extra_bytes) or raises ValueError.
    operand examples:
      ,X+   ,X++   ,-X   ,--X
      0,X   127,X  -128,X  3200,U  (8-bit or 16-bit offset)
      A,X   B,Y   D,U
      ,PCR  label,PCR  $1234,PCR
      [,X]  [label,PCR]   (indirect -- adds 0x10 to postbyte)
    """
    indirect = False
    op = operand.strip()
    if op.startswith('[') and op.endswith(']'):
        indirect = True
        op = op[1:-1].strip()

    ib = 0x10 if indirect else 0x00  # indirect bit

    # Auto-increment / auto-decrement
    if op == ',X+':   return ([0x80|ib], [])
    if op == ',-X':   return ([0x82|ib], [])
    if op == ',X++':  return ([0x81|ib], [])
    if op == ',-X':   return ([0x82|ib], [])
    if op == ',--X':  return ([0x83|ib], [])
    if op == ',Y+':   return ([0xA0|ib], [])
    if op == ',-Y':   return ([0xA2|ib], [])
    if op == ',Y++':  return ([0xA1|ib], [])
    if op == ',-Y':   return ([0xA2|ib], [])
    if op == ',--Y':  return ([0xA3|ib], [])
    if op == ',U+':   return ([0xC0|ib], [])
    if op == ',-U':   return ([0xC2|ib], [])
    if op == ',U++':  return ([0xC1|ib], [])
    if op == ',-U':   return ([0xC2|ib], [])
    if op == ',--U':  return ([0xC3|ib], [])
    if op == ',S+':   return ([0xE0|ib], [])
    if op == ',-S':   return ([0xE2|ib], [])
    if op == ',S++':  return ([0xE1|ib], [])
    if op == ',-S':   return ([0xE2|ib], [])
    if op == ',--S':  return ([0xE3|ib], [])

    # Zero-offset from register
    if op in (',X', '0,X'): return ([0x84|ib], [])
    if op in (',Y', '0,Y'): return ([0xA4|ib], [])
    if op in (',U', '0,U'): return ([0xC4|ib], [])
    if op in (',S', '0,S'): return ([0xE4|ib], [])

    # Accumulator offset
    if op == 'A,X': return ([0x86|ib], [])
    if op == 'B,X': return ([0x85|ib], [])
    if op == 'D,X': return ([0x8B|ib], [])
    if op == 'A,Y': return ([0xA6|ib], [])
    if op == 'B,Y': return ([0xA5|ib], [])
    if op == 'D,Y': return ([0xAB|ib], [])
    if op == 'A,U': return ([0xC6|ib], [])
    if op == 'B,U': return ([0xC5|ib], [])
    if op == 'D,U': return ([0xCB|ib], [])
    if op == 'A,S': return ([0xE6|ib], [])
    if op == 'B,S': return ([0xE5|ib], [])
    if op == 'D,S': return ([0xEB|ib], [])

    # PCR-relative
    pcr_m = re.match(r'^(.*),PCR$', op, re.IGNORECASE)
    if pcr_m:
        expr = pcr_m.group(1).strip()
        if expr == '':
            # ,PCR with no offset = 0,PCR (16-bit)
            return ([0x8D|ib], [0x00, 0x00])
        val = resolve_expr(expr, symbols, pass2, pc)
        if val is None:
            # Pass 1 unknown -- use 16-bit
            return ([0x8D|ib], [0x00, 0x00])
        # PCR instruction size: postbyte(1) + offset(2) = 3 extra bytes
        # pc here is address AFTER the full instruction
        # We don't know pc precisely without knowing instruction length,
        # so use 16-bit offset always (matches original binary behavior)
        offset = val - (pc + 3)  # 3 = postbyte + 2 offset bytes
        if -128 <= offset <= 127 and not indirect:
            # 8-bit PCR -- but original always uses 16-bit for named labels
            # Force 16-bit to match original
            pass
        offset16 = val - (pc + 3)
        return ([0x8D|ib], [(offset16 >> 8) & 0xFF, offset16 & 0xFF])

    # Numeric offset from register: n,R
    m = re.match(r'^([^,]+),([XYUS])$', op)
    if m:
        expr, reg = m.group(1).strip(), m.group(2).upper()
        rb = INDEX_REG[reg]
        val = resolve_expr(expr, symbols, pass2, pc)
        if val is None:
            # Pass 1: use 16-bit
            return ([0xC9|rb|ib], [0x00, 0x00])
        val = to_signed(val, 16)
        if -16 <= val <= 15 and not indirect:
            # 5-bit signed offset (bits 4-0 of post-byte, bit7=0)
            v5 = val & 0x1F
            return ([rb | v5 | ib], [])
        elif -128 <= val <= 127:
            # 8-bit signed offset: base $88 | register_bits
            return ([0x88|rb|ib], [val & 0xFF])
        else:
            # 16-bit signed offset: base $89 | register_bits
            return ([0x89|rb|ib], [(val>>8)&0xFF, val&0xFF])

    # Extended indirect: [$1234] or [label]
    if indirect:
        val = resolve_expr(op, symbols, pass2, pc)
        if val is None: val = 0
        return ([0x9F], [(val>>8)&0xFF, val&0xFF])

    raise ValueError(f"Cannot encode indexed operand: {operand!r}")

# ── Expression evaluator ─────────────────────────────────────────────────────

def resolve_expr(expr: str, symbols: dict, pass2: bool, pc: int = 0) -> Optional[int]:
    """Evaluate an expression. Returns None if symbol unknown in pass1."""
    expr = expr.strip()

    # Strip direct page force operator <
    if expr.startswith('<'):
        expr = expr[1:]
    # Handle * (current PC)
    expr = re.sub(r'\*(?!\+|-)', str(pc), expr)

    # Tokenize and evaluate
    try:
        val = _eval_expr(expr, symbols, pass2)
        return val
    except (KeyError, ValueError, TypeError):
        if pass2:
            raise
        return None

def _eval_expr(expr: str, symbols: dict, pass2: bool) -> int:
    """Simple expression evaluator: handles +, -, *, labels, hex, decimal."""
    expr = expr.strip()
    if not expr:
        raise ValueError("Empty expression")

    # Try integer literal
    try:
        if expr.startswith('$'):
            return int(expr[1:], 16)
        if expr.startswith('%'):
            return int(expr[1:], 2)
        if expr.startswith("'") and len(expr) == 3 and expr.endswith("'"):
            return ord(expr[1])
        return int(expr)
    except ValueError:
        pass

    # Single symbol
    if re.match(r'^[A-Za-z_.][A-Za-z0-9_.]*$', expr):
        if expr in symbols:
            return symbols[expr]
        if pass2:
            raise KeyError(f"Undefined symbol: {expr}")
        return None

    # Binary operations (simple left-to-right, + and - only at top level)
    # Split on + or - not inside parens, handling hex prefixes
    result = _parse_additive(expr, symbols, pass2)
    return result

def _parse_additive(expr: str, symbols: dict, pass2: bool) -> int:
    """Parse additive expression."""
    # Split on + or - at top level
    parts = []
    ops = []
    i = 0
    current = ''
    while i < len(expr):
        c = expr[i]
        if c in '+-' and current.strip() and not current.strip().endswith('$'):
            parts.append(current)
            ops.append(c)
            current = ''
        else:
            current += c
        i += 1
    parts.append(current)

    val = _parse_term(parts[0].strip(), symbols, pass2)
    for op, part in zip(ops, parts[1:]):
        v = _parse_term(part.strip(), symbols, pass2)
        if op == '+':
            val += v
        else:
            val -= v
    return val

def _parse_term(expr: str, symbols: dict, pass2: bool) -> int:
    expr = expr.strip()
    if not expr:
        return 0
    if expr.startswith('$'):
        return int(expr[1:], 16) if len(expr) > 1 else 0
    if expr.startswith('%'):
        return int(expr[1:], 2)
    if expr.startswith("'") and len(expr) >= 2:
        return ord(expr[1])
    try:
        return int(expr)
    except ValueError:
        if expr in symbols:
            return symbols[expr]
        if pass2:
            raise KeyError(f"Undefined: {expr!r}")
        return 0

def to_signed(val: int, bits: int) -> int:
    mask = (1 << bits) - 1
    val &= mask
    if val >= (1 << (bits - 1)):
        val -= (1 << bits)
    return val

# ── Assembler core ────────────────────────────────────────────────────────────

def parse_operand_list(s: str) -> list:
    """Split comma-separated operand list respecting brackets."""
    parts = []
    depth = 0
    current = ''
    for c in s:
        if c == '[': depth += 1
        elif c == ']': depth -= 1
        if c == ',' and depth == 0:
            parts.append(current.strip())
            current = ''
        else:
            current += c
    if current.strip():
        parts.append(current.strip())
    return parts

def assemble_line(mne: str, operand: str, pc: int, symbols: dict,
                  pass2: bool, dp: int = 0) -> bytes:
    """Assemble a single instruction. Returns bytes."""
    mne = mne.upper()
    op = operand.strip() if operand else ''

    # Inherent
    if mne in INHERENT and not op:
        return bytes([INHERENT[mne]])

    # OS9 system call
    if mne == 'OS9':
        fn_name = op.strip()
        if fn_name in OS9_CALLS:
            code = OS9_CALLS[fn_name]
        else:
            code = resolve_expr(fn_name, symbols, pass2, pc)
            if code is None: code = 0
        return bytes([0x10, 0x3F, code & 0xFF])

    # Short branches
    if mne in SHORT_BRANCH:
        opcode = SHORT_BRANCH[mne]
        # Operand is *+N or *-N
        m = re.match(r'^\*([+-]\d+)$', op)
        if m:
            n = int(m.group(1))
            offset = n - 2
        else:
            # Absolute address label
            target = resolve_expr(op, symbols, pass2, pc)
            if target is None: target = pc + 2
            offset = target - (pc + 2)
        if not (-128 <= offset <= 127):
            raise ValueError(f"Short branch offset out of range at ${pc:04X}: {offset}")
        return bytes([opcode, offset & 0xFF])

    # Long branches
    if mne in LONG_BRANCH:
        info = LONG_BRANCH[mne]
        target = resolve_expr(op, symbols, pass2, pc)
        if target is None: target = pc + (3 if mne == 'LBSR' else 4)
        if mne == 'LBSR':
            # 17 hi lo (3 bytes)
            offset = target - (pc + 3)
            return bytes([0x17, (offset >> 8) & 0xFF, offset & 0xFF])
        else:
            # 10 xx hi lo (4 bytes) or 16 hi lo (LBRA)
            if mne == 'LBRA':
                offset = target - (pc + 3)
                return bytes([0x16, (offset >> 8) & 0xFF, offset & 0xFF])
            ophi = (info >> 8) & 0xFF
            oplo = info & 0xFF
            offset = target - (pc + 4)
            return bytes([ophi, oplo, (offset >> 8) & 0xFF, offset & 0xFF])

    # TFR / EXG
    if mne in REG_PAIR:
        opcode = REG_PAIR[mne]
        parts = parse_operand_list(op)
        r1 = REG_NUM.get(parts[0].upper(), 0)
        r2 = REG_NUM.get(parts[1].upper(), 0)
        return bytes([opcode, (r1 << 4) | r2])

    # PSHS/PULS/PSHU/PULU
    if mne in STACK_OPS:
        opcode = STACK_OPS[mne]
        mask = 0
        for reg in parse_operand_list(op):
            r = reg.strip().upper()
            # For PSHS/PULS, U is U (0x40); for PSHU/PULU, S is S (0x40)
            mask |= STACK_REG.get(r, 0)
        return bytes([opcode, mask])

    # ANDCC / ORCC / CWAI
    if mne in CCOPS:
        val = resolve_expr(op, symbols, pass2, pc)
        if val is None: val = 0
        return bytes([CCOPS[mne], val & 0xFF])

    # LEA ops
    if mne in LEA:
        opcode = LEA[mne]
        pb, extra = encode_indexed(op, pc + 1, symbols, pass2)
        return bytes([opcode] + pb + extra)

    # JSR
    if mne == 'JSR':
        # Try indexed first
        if any(c in op for c in ',[]') or op.startswith('A,') or op.startswith('B,') or op.startswith('D,'):
            pb, extra = encode_indexed(op, pc + 1, symbols, pass2)
            return bytes([0xAD] + pb + extra)
        # Direct or extended
        val = resolve_expr(op, symbols, pass2, pc)
        if val is None: val = 0
        if 0 <= val <= 0xFF and (val >> 8) == dp:
            return bytes([0x9D, val & 0xFF])
        return bytes([0xBD, (val >> 8) & 0xFF, val & 0xFF])

    # ALU ops
    if mne in ALU:
        imm_op, dir_op, idx_op, ext_op = ALU[mne]

        # Immediate: #value
        if op.startswith('#'):
            if imm_op is None:
                raise ValueError(f"{mne} has no immediate mode")
            val = resolve_expr(op[1:], symbols, pass2, pc)
            if val is None: val = 0
            val &= 0xFFFF
            # Determine size: 16-bit ops
            wide_ops = {'SUBD','CMPD','CMPY','CMPX','CMPU','CMPS',
                        'LDD','LDX','LDY','LDU','LDS','ADDD'}
            if mne in wide_ops:
                opcodes = _opcode_bytes(imm_op)
                return bytes(opcodes + [(val >> 8) & 0xFF, val & 0xFF])
            else:
                opcodes = _opcode_bytes(imm_op)
                return bytes(opcodes + [val & 0xFF])

        # Indexed: has , not starting with # and has index indicator
        if _is_indexed(op):
            if idx_op is None:
                raise ValueError(f"{mne} has no indexed mode")
            pb, extra = encode_indexed(op, pc + len(_opcode_bytes(idx_op)) + 1, symbols, pass2)
            return bytes(_opcode_bytes(idx_op) + pb + extra)

        # Direct or Extended
        val = resolve_expr(op, symbols, pass2, pc)
        if val is None: val = 0
        val &= 0xFFFF
        # Force extended if value > 0xFF or if label clearly in high memory
        if val > 0xFF:
            if ext_op is None:
                raise ValueError(f"{mne} has no extended mode")
            return bytes(_opcode_bytes(ext_op) + [(val >> 8) & 0xFF, val & 0xFF])
        else:
            if dir_op is not None:
                return bytes(_opcode_bytes(dir_op) + [val & 0xFF])
            return bytes(_opcode_bytes(ext_op) + [0x00, val & 0xFF])

    # Single-operand (unary)
    if mne in UNARY:
        dir_op, idx_op, ext_op = UNARY[mne]

        if _is_indexed(op):
            pb, extra = encode_indexed(op, pc + 1 + 1, symbols, pass2)
            return bytes([idx_op] + pb + extra)

        val = resolve_expr(op, symbols, pass2, pc)
        if val is None: val = 0
        val &= 0xFFFF
        if val > 0xFF:
            return bytes([ext_op, (val >> 8) & 0xFF, val & 0xFF])
        else:
            return bytes([dir_op, val & 0xFF])

    raise ValueError(f"Unknown mnemonic: {mne!r} operand={op!r}")

def _opcode_bytes(op: int) -> list:
    """Convert opcode int to byte list (handles page2/page3 with prefix)."""
    if op > 0xFFFF:
        return [(op >> 16) & 0xFF, (op >> 8) & 0xFF, op & 0xFF]
    elif op > 0xFF:
        return [(op >> 8) & 0xFF, op & 0xFF]
    return [op]

def _is_indexed(op: str) -> bool:
    """Heuristic: does this operand use indexed addressing?"""
    op = op.strip()
    # Direct register references
    index_patterns = [
        r'^,-?-?[XYUS]',
        r',[XYUS][\+\-]?[\+]?$',
        r'^[\-]+,[XYUS]',
        r',[XYUS]$',
        r',PCR',
        r'^[ABCD],[XYUS]$',
        r'^\[',
        r',[XYUS]$',
    ]
    for pat in index_patterns:
        if re.search(pat, op, re.IGNORECASE):
            return True
    # Numeric offset from register
    if re.match(r'^-?\d+,[XYUS]$', op, re.IGNORECASE):
        return True
    return False

# ── Directive handling ────────────────────────────────────────────────────────

def handle_directive(directive: str, operand: str, pc: int,
                     symbols: dict, pass2: bool) -> bytes:
    d = directive.upper()
    op = operand.strip()

    if d == 'FCB':
        result = []
        for part in parse_operand_list(op):
            part = part.strip()
            if part.startswith('"') or part.startswith("'"):
                # String
                s = part[1:-1] if len(part) > 2 else ''
                result.extend(ord(c) for c in s)
            else:
                val = resolve_expr(part, symbols, pass2, pc)
                if val is None: val = 0
                result.append(val & 0xFF)
        return bytes(result)

    if d == 'FDB':
        result = []
        for part in parse_operand_list(op):
            val = resolve_expr(part.strip(), symbols, pass2, pc)
            if val is None: val = 0
            val &= 0xFFFF
            result.extend([(val >> 8) & 0xFF, val & 0xFF])
        return bytes(result)

    if d in ('FCC', 'FCS'):
        # String: "..." or /.../ 
        s = op
        delim = s[0] if s else '"'
        if s and s[0] in '"/' :
            s = s[1:]
            if s.endswith(delim):
                s = s[:-1]
        data = [ord(c) for c in s]
        if d == 'FCS':
            if data:
                data[-1] |= 0x80  # set high bit on last char
        return bytes(data)

    return bytes()

# ── Line parser ───────────────────────────────────────────────────────────────

LINE_RE = re.compile(
    r'^(?:([A-Za-z_\$\.][A-Za-z0-9_\$\.]*):?\s+)?'  # optional label
    r'([A-Za-z_\$\.][A-Za-z0-9_\.\$]*)'          # mnemonic/directive
    r'(?:\s+(.*))?$'                               # optional operand
)

def parse_line(line: str):
    """
    Returns (label, mnemonic, operand) or None if blank/comment.
    Key rule: labels only appear on non-indented lines.
    """
    indented = line.startswith(' ') or line.startswith('\t')
    stripped = line.strip()

    if not stripped or stripped.startswith(';') or stripped.startswith('*'):
        return None

    # Remove trailing comment
    in_q = False
    q_char = ''
    for i, c in enumerate(stripped):
        if not in_q and c in '"\'':
            in_q = True; q_char = c
        elif in_q and c == q_char:
            in_q = False
        elif not in_q and c == ';':
            stripped = stripped[:i].rstrip()
            break

    if not stripped:
        return None

    # Indented line: no label
    if indented:
        parts = stripped.split(None, 1)
        return (None, parts[0], parts[1].strip() if len(parts) > 1 else '')

    # Non-indented: check for bare label
    if re.match(r'^[A-Za-z_$\.][A-Za-z0-9_$\.]*:?\s*$', stripped):
        return (stripped.rstrip(':').strip(), None, '')

    # Label with colon
    m = re.match(r'^([A-Za-z_$\.][A-Za-z0-9_$\.]*):(.*)$', stripped)
    if m:
        label = m.group(1)
        rest = m.group(2).strip()
        if not rest:
            return (label, None, '')
        parts = rest.split(None, 1)
        return (label, parts[0], parts[1].strip() if len(parts) > 1 else '')

    # Check for "Symbol EQU value" (no colon)
    parts = stripped.split(None, 2)
    if len(parts) >= 2 and parts[1].upper() == 'EQU':
        return (parts[0], 'EQU', parts[2].strip() if len(parts) > 2 else '')

    # Plain mnemonic (no label)
    parts = stripped.split(None, 1)
    return (None, parts[0], parts[1].strip() if len(parts) > 1 else '')

def assemble(source_lines: list, origin: int = 0) -> tuple:
    """
    Two-pass assembly.
    Returns (binary_bytes, symbols_dict, errors_list).
    """
    symbols = {}
    errors = []

    def do_pass(pass2: bool) -> list:
        pc = origin
        output = []  # list of (address, bytes) chunks

        for lineno, line in enumerate(source_lines, 1):
            parsed = parse_line(line)
            if parsed is None:
                continue

            label, mne, operand = parsed
            if mne is None:
                # Bare label -- just define it
                if label and not pass2:
                    symbols[label.rstrip(':')] = pc
                elif label and pass2:
                    pass  # already defined
                continue
            mne_upper = mne.upper()

            # Handle label definition
            if label:
                lbl = label.rstrip(':')
                if mne_upper == 'EQU':
                    val = resolve_expr(operand, symbols, pass2, pc)
                    if val is None: val = 0
                    if not pass2:
                        symbols[lbl] = val
                    continue
                else:
                    if not pass2:
                        symbols[lbl] = pc
                    # If ONLY a label (mne is actually another label or nothing)
                    # Check if mne is itself a label with colon
                    if mne.endswith(':'):
                        # mne is actually a second label
                        lbl2 = mne.rstrip(':')
                        if not pass2:
                            symbols[lbl2] = pc
                        # operand is the real mnemonic
                        if not operand:
                            continue
                        parts = operand.split(None, 1)
                        mne = parts[0]
                        operand = parts[1] if len(parts) > 1 else ''
                        mne_upper = mne.upper()

            # EQU without label -- shouldn't happen but skip
            if mne_upper == 'EQU':
                continue

            # ORG
            if mne_upper == 'ORG':
                val = resolve_expr(operand, symbols, pass2, pc)
                if val is not None:
                    pc = val
                continue

            # END / NAM / TTL / USE -- ignore
            if mne_upper in ('END', 'NAM', 'TTL', 'USE', 'SETDP'):
                continue

            # RMB -- reserve bytes (BSS)
            if mne_upper == 'RMB':
                val = resolve_expr(operand, symbols, pass2, pc)
                if val is None: val = 0
                if pass2:
                    output.append((pc, bytes(val)))
                pc += val
                continue

            # Data directives
            if mne_upper in ('FCB', 'FDB', 'FCC', 'FCS'):
                try:
                    data = handle_directive(mne_upper, operand, pc, symbols, pass2)
                except Exception as e:
                    if pass2:
                        errors.append(f"Line {lineno}: {e}")
                    data = bytes(2 if mne_upper == 'FDB' else 1)
                if pass2:
                    output.append((pc, data))
                pc += len(data)
                continue

            # Instruction
            try:
                data = assemble_line(mne_upper, operand, pc, symbols, pass2)
            except Exception as e:
                if pass2:
                    errors.append(f"Line {lineno} (${pc:04X}) {mne} {operand}: {e}")
                # Estimate size for pass1
                data = bytes(_estimate_size(mne_upper, operand))

            if pass2:
                output.append((pc, data))
            pc += len(data)

        return output

    def _estimate_size(mne: str, op: str) -> int:
        """Rough size estimate for pass1 when we can't assemble yet."""
        if mne in INHERENT: return 1
        if mne in SHORT_BRANCH: return 2
        if mne == 'LBSR': return 3
        if mne in LONG_BRANCH: return 4
        if mne in ('OS9',): return 3
        if mne in REG_PAIR: return 2
        if mne in STACK_OPS: return 2
        if mne in CCOPS: return 2
        if mne in LEA:
            return 4  # typical PCR
        if mne in ALU:
            if op.startswith('#'):
                wide = {'SUBD','CMPD','CMPY','CMPX','CMPU','CMPS',
                        'LDD','LDX','LDY','LDU','LDS','ADDD'}
                return 4 if mne in wide else 2
            if _is_indexed(op): return 4
            return 3
        if mne in UNARY:
            if _is_indexed(op): return 3
            return 3
        return 2

    # Pass 1
    do_pass(False)
    # Pass 2
    chunks = do_pass(True)

    # Assemble into flat bytes
    if not chunks:
        return bytes(), symbols, errors

    start = chunks[0][0]
    end = max(addr + len(data) for addr, data in chunks)
    buf = bytearray(end - start)
    for addr, data in chunks:
        buf[addr - start: addr - start + len(data)] = data

    return bytes(buf), symbols, errors

# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 3:
        print("Usage: python asm6809.py input.asm output.bin")
        sys.exit(1)

    src = open(sys.argv[1], 'r', encoding='utf-8', errors='replace').readlines()
    binary, symbols, errors = assemble(src)

    if errors:
        for e in errors:
            print(f"ERROR: {e}", file=sys.stderr)

    with open(sys.argv[2], 'wb') as f:
        f.write(binary)

    print(f"Assembled: {len(binary)} bytes, {len(errors)} errors")

if __name__ == '__main__':
    main()
