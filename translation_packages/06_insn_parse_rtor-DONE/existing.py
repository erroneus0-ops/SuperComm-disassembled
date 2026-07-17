# Current Python translation of insn_parse_rtor
# cocotools/insn_funcs.py

def insn_parse_rtor(as_, cl, operand):
    p = Ptr(operand)
    ops  = _ops(cl)
    regs = _RTOR_REGS9 if curpragma(cl, PRAGMA_6809) else _RTOR_REGS

    r0 = AsmState.lookupreg2(regs, p)
    if curpragma(cl, PRAGMA_NEWSOURCE):
        while p.peek() and p.peek().isspace(): p.advance()
    if r0 < 0 or p.peek() != ',':
        as_.register_error(cl, E_OPERAND_BAD); r0 = r1 = 0
    else:
        p.advance()
        if curpragma(cl, PRAGMA_NEWSOURCE):
            while p.peek() and p.peek().isspace(): p.advance()
        r1 = AsmState.lookupreg2(regs, p)
        if r1 < 0:
            as_.register_error(cl, E_OPERAND_BAD); r0 = r1 = 0

    cl.pb  = (r0 << 4) | r1
    cl.len = _oplen(ops[0]) + 1
    return p.remaining()

