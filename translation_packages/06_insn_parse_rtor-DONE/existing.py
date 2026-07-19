# Current Python translation of insn_parse_rtor
# cocotools/insn_funcs.py
#
# Updated 2026-07-17: fixed a divergence in comma-check cursor advancement.
# See checklist.md and SUMMARY.md for the full analysis.

def insn_parse_rtor(as_, cl, operand):
    p = Ptr(operand)
    ops  = _ops(cl)
    regs = _RTOR_REGS9 if curpragma(cl, PRAGMA_6809) else _RTOR_REGS

    r0 = AsmState.lookupreg2(regs, p)
    _skip_to_next_token(cl, p)
    if r0 < 0:
        as_.register_error(cl, E_OPERAND_BAD); r0 = r1 = 0
    else:
        # C: *(*p)++ != ',' -- read the current char AND advance p by one
        # unconditionally (short-circuited || means we only get here when
        # r0 >= 0), THEN compare what was read against ','.
        c = p.peek()
        p.advance()
        if c != ',':
            as_.register_error(cl, E_OPERAND_BAD); r0 = r1 = 0
        else:
            _skip_to_next_token(cl, p)
            r1 = AsmState.lookupreg2(regs, p)
            if r1 < 0:
                as_.register_error(cl, E_OPERAND_BAD); r0 = r1 = 0

    cl.pb  = (r0 << 4) | r1
    cl.len = _oplen(ops[0]) + 1
    return p.remaining()
