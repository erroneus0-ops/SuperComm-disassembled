# Current Python translation of lw_expr_parse_expr
# cocotools/lw_expr.py

def _parse_expr(p, ctx, prec, compact):
    """
    lw_expr_parse_expr: Pratt-style precedence climbing.
    Returns Expr or None.
    """
    _skip_ws(p, compact)
    c = p.peek()
    if c == '\0' or c.isspace() or c in (')', ',', ']', ';'):
        return None

    term1 = _parse_term(p, ctx, compact)
    if term1 is None:
        return None

    while True:
        _skip_ws(p, compact)
        c = p.peek()
        if c == '\0' or c.isspace() or c in (')', ',', ']', ';'):
            return term1

        # Find the longest matching operator whose precedence > prec
        matched = None
        for op_code, op_str, op_prec in _PARSE_OPERATORS:
            if op_prec <= prec:
                continue
            if p.startswith(op_str):
                matched = (op_code, op_str, op_prec)
                break   # already sorted by length desc; take first match

        if matched is None:
            return term1   # unrecognised -> return what we have

        op_code, op_str, op_prec = matched
        p.advance(len(op_str))

        term2 = _parse_expr(p, ctx, op_prec, compact)
        if term2 is None:
            return term1   # C returns NULL here; we keep term1 to be safe

        term1 = Expr.oper(op_code, term1, term2)
        # Loop continues: eval_next in C


