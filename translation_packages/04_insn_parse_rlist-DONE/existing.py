# Current Python translation of insn_parse_rlist
# cocotools/insn_funcs.py
#
# UPDATED per translation_packages/04_insn_parse_rlist audit (see SUMMARY.md):
# the '#' immediate branch now returns insn_parse_imm8's own return value
# (the properly advanced cursor) instead of the outer p's stale,
# unadvanced remainder. See SUMMARY.md for full details, C reference,
# and reproduction.

def insn_parse_rlist(as_, cl, operand):
    p    = Ptr(operand)
    ops  = _ops(cl)
    cl.lint = 0

    if p.peek() == '#':
        # FIXED: capture and return insn_parse_imm8's own remainder.
        # insn_parse_imm8 builds its own independent Ptr internally, so
        # this outer `p` is never advanced by that call -- the ONLY way
        # to get the correct post-parse cursor position back to the
        # caller is to use insn_parse_imm8's return value directly.
        remaining = insn_parse_imm8(as_, cl, operand)
        cl.lint = 1
        return remaining

    rb = 0
    while p.peek() and not p.peek().isspace() \
          and p.peek() not in (';', '*'):
        rn = AsmState.lookupreg2(_RLIST_REGS, p)
        if rn < 0:
            as_.register_error2(cl, E_REGISTER_BAD, "'%s'", p.remaining())
            return p.remaining()

        if curpragma(cl, PRAGMA_NEWSOURCE):
            while p.peek() and p.peek().isspace(): p.advance()

        if p.peek() and p.peek() not in (',',) and \
           not p.peek().isspace() and p.peek() not in (';', '*'):
            as_.register_error(cl, E_OPERAND_BAD)

        if p.peek() == ',':
            p.advance()
            if curpragma(cl, PRAGMA_NEWSOURCE):
                while p.peek() and p.peek().isspace(): p.advance()

        # U and S exclusivity check
        if (ops[0] & 2):   # PSHU/PULU
            if rn == 6:    # U not allowed
                as_.register_error2(cl, E_REGISTER_BAD, "'%s'", 'u')
                return p.remaining()
        else:              # PSHS/PULS
            if rn == 9:    # S not allowed
                as_.register_error2(cl, E_REGISTER_BAD, "'%s'", 's')
                return p.remaining()

        # Map register bits
        # _RLIST_REGS table: CC=0 A=1 B=2 DP=3 X=4 Y=5 U=6 PC=7 D=8 S=9
        if rn == 7:        # PC
            rb |= 0x80
        elif rn == 8:      # D = A|B (lwasm treats D as synonym for A,B in rlist)
            rb |= 0x06
        elif rn == 9:      # S
            rb |= 0x40
        else:
            rb |= (1 << rn)

    if rb == 0:
        as_.register_error(cl, E_OPERAND_BAD)

    cl.len = _oplen(ops[0]) + 1
    cl.pb  = rb
    return p.remaining()
