# Current Python translation of insn_parse_bitbit
# cocotools/insn_funcs.py

def insn_parse_bitbit(as_, cl, operand):
    p = Ptr(operand)
    if not p.peek():
        as_.register_error(cl, E_REGISTER_BAD); return p.remaining()
    r_char = p.peek().upper()
    p.advance()
    if r_char == 'A':
        r = 1
    elif r_char == 'B':
        r = 2
    elif r_char == 'C' and p.peek() and p.peek().upper() == 'C':
        r = 0
        p.advance()
    else:
        as_.register_error(cl, E_REGISTER_BAD); return p.remaining()

    if p.peek() != ',':
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    p.advance()
    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(0, e)

    if p.peek() != ',':
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    p.advance()
    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(1, e)

    if p.peek() != ',':
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    p.advance()
    if p.peek() == '<':
        p.advance()   # ignore base-page address modifier, matches C
    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(2, e)

    ops = _ops(cl)
    cl.lint = r
    cl.len  = _oplen(ops[0]) + 2
    return p.remaining()

