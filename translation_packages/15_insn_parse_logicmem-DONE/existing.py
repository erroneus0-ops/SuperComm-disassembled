# Current Python translation of insn_parse_logicmem
# cocotools/insn_funcs.py

def insn_parse_logicmem(as_, cl, operand):
    p = Ptr(operand)
    if p.peek() == '#':
        p.advance()
    s = as_.parse_expr(p)
    if not s:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(100, s)
    if p.peek() not in (',', ';'):
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    p.advance()
    _insn_parse_gen_aux(as_, cl, p, 1)
    return p.remaining()

