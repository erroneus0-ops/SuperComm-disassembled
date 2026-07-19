# Current Python translation of insn_parse_bitbit
# cocotools/insn_funcs.py

def insn_parse_bitbit(as_, cl, operand):
    # ---------------------------------------------------------------------------
    # FUNCTION: insn_parse_bitbit
    # SOURCE:   lwtools-4.24/lwasm/insn_bitbit.c lines 30-99
    # Fix by 13 Claude: added two missing _skip_to_next_token calls
    #   (1) after register letter, before first comma
    #   (2) after second comma, before '<' base-page check
    # Also fixed comma check to always advance cursor (matches C's *(*p)++)
    # ---------------------------------------------------------------------------
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

    # lwasm_skip_to_next_token(l, p) -- missing in original translation
    _skip_to_next_token(cl, p)

    # *(*p)++ != ',' -- advance regardless of match (C semantics)
    c = p.peek(); p.advance()
    if c != ',':
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()

    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(0, e)

    c = p.peek(); p.advance()
    if c != ',':
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()

    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(1, e)

    c = p.peek(); p.advance()
    if c != ',':
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()

    # lwasm_skip_to_next_token(l, p) -- missing in original translation
    _skip_to_next_token(cl, p)

    if p.peek() == '<':
        p.advance()   # ignore base-page address modifier
    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()
    cl.save_expr(2, e)

    ops = _ops(cl)
    cl.lint = r
    cl.len  = _oplen(ops[0]) + 2
    return p.remaining()

