# Current Python translation of lw_expr_parse_term
# cocotools/lw_expr.py

def _parse_term(p, ctx, compact):
    """
    lw_expr_parse_term: handle prefix operators and parentheses,
    then delegate to ctx.parse_term for atomic terms.
    """
    _skip_ws(p, compact)
    c = p.peek()

    if c == '\0' or c.isspace() or c in (')', ']'):
        return None

    # Parentheses
    if c == '(':
        p.advance()
        term = _parse_expr(p, ctx, 0, compact)
        _skip_ws(p, compact)
        if p.peek() != ')':
            return None       # syntax error; C returns NULL
        p.advance()
        return term

    # Unary +  (no-op, just consume and re-enter)
    if c == '+':
        p.advance()
        return _parse_term(p, ctx, compact)   # goto eval_next in C

    # Unary -  (prec 200)
    if c == '-':
        p.advance()
        term = _parse_expr(p, ctx, 200, compact)
        if term is None:
            return None
        return Expr.oper(OPER_NEG, term)

    # Unary ^ or ~  (complement; prec 200)
    if c in ('^', '~'):
        p.advance()
        term = _parse_expr(p, ctx, 200, compact)
        if term is None:
            return None
        if ctx.expr_width == 8:
            return Expr.oper(OPER_COM8, term)
        return Expr.oper(OPER_COM, term)

    # Delegate to assembler-supplied atom parser (lwasm_parse_term)
    if ctx.parse_term:
        return ctx.parse_term(p, ctx)

    return None


