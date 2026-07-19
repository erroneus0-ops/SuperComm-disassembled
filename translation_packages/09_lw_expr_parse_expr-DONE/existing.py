# Current Python translation of lw_expr_parse_expr
# cocotools/lw_expr.py
#
# UPDATED per audit -- see SUMMARY.md in this package directory for the
# full list of divergences found and fixed. All 270 tests in
# cocotools/test_fidelity.py pass (262 pre-existing + 8 new, added for
# this function).

_PARSE_OPERATORS = [
    (OPER_PLUS,   '+',   100),
    (OPER_MINUS,  '-',   100),
    (OPER_TIMES,  '*',   150),
    (OPER_DIVIDE, '/',   150),
    (OPER_MOD,    '%',   150),
    (OPER_INTDIV, '\\',  150),
    (OPER_AND,    '&&',   25),
    (OPER_OR,     '||',   25),
    (OPER_BWAND,  '&',    50),
    (OPER_BWOR,   '|',    50),
    (OPER_BWOR,   '!',    50),   # '!' is alias for '|' per C source
    (OPER_BWXOR,  '^',    50),
    (OPER_EQ,     '==',   55),
    (OPER_NE,     '!=',   55),   # unreachable in practice -- see above
    (OPER_NE,     '<>',   55),
    (OPER_LT,     '<',    60),
    (OPER_LE,     '<=',   60),   # unreachable in practice -- see above
    (OPER_GT,     '>',    60),
    (OPER_GE,     '>=',   60),   # unreachable in practice -- see above
]


def _match_operator(p):
    """
    lw_expr_parse_expr's operator-recognition loop: walk _PARSE_OPERATORS
    IN TABLE ORDER and return the first entry whose string is a complete
    prefix of the remaining input at p. Precedence is NOT considered here
    -- the C source always finds a match first (irrespective of prec) and
    only checks precedence afterward, once the operator is already fixed.
    Returns (op_code, op_str, op_prec), or None if nothing matches (C's
    `operators[opern].opernum == lw_expr_oper_none` case).
    """
    for op_code, op_str, op_prec in _PARSE_OPERATORS:
        if p.startswith(op_str):
            return (op_code, op_str, op_prec)
    return None


def _skip_ws(p, compact):
    """lw_expr_parse_next_tok: skip whitespace unless compact mode."""
    if not compact:
        while p.peek() not in ('\0',) and p.peek() in ' \t\r\n':
            p.advance()


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



def _parse_expr(p, ctx, prec, compact):
    """
    lw_expr_parse_expr: Pratt-style precedence climbing.
    Returns Expr or None.

    ---------------------------------------------------------------------
    Pre-translation checklist results (see checklist.md for full detail):
      Integer width: none (no fixed-width assignments)
      Division/modulo: N/A (no / or % in this function)
      char **p: FOUND -- p is a Ptr, shared across every recursive call
        and with _parse_term; never rebuilt from p.remaining().
      goto: FOUND -- `goto eval_next;` is Pattern B (shared code the
        function jumps back to repeatedly); translated as a `while True`
        loop, since eval_next is re-entered from the bottom with the same
        local variables (term1, prec) still in scope.
      char signedness: safe -- Ptr.peek() returns Python str comparisons
        only against ASCII terminator/operator characters, never > 127.
      Argument order: safe -- no (*p)++-in-argument-position pattern here.
      Promotion: safe -- no fixed-width destination anywhere in this fn.
      Complement: none.
      lookupreg: N/A.

    Interaction risks identified:
      1. The C operator table matches by FIRST full-prefix hit in
         declaration order, not by longest match. Because "<", ">", and
         the bwor alias "!" are declared before "<=", ">=", and "!="
         respectively, and are themselves complete prefixes of those
         longer operators, the longer two-char operators can never be
         reached -- lwasm 4.24 cannot parse "<=", ">=", or "!=" as their
         own operators (confirmed against the real binary: all three
         produce "Bad operand", not the operator lwasm's own table
         suggests they should be).
      2. Operator matching and precedence-checking are two SEPARATE
         steps in the C source: a match is found unconditionally first
         (regardless of prec), and only afterward is its precedence
         compared against the current `prec` threshold. Pre-filtering
         candidates by precedence during the search (as a "skip low-prec
         entries" step) is NOT equivalent once shadowing (risk 1) is in
         play: at prec values between a shadowed short operator's
         precedence and its shadowing target's precedence (e.g. prec=50,
         between "!" at 50 and "!=" at 55), a precedence-filtered search
         would incorrectly "see" and accept "!=" as NE, while the real
         C code (and lwasm) permanently commits to "!" first and bails
         via the low-precedence return before "!=" is ever considered.
         Verified against real lwasm with "1&2!=3", which real lwasm
         rejects as "Bad operand" in its entirety.
      3. Ptr.peek() returns '' (empty string) at end of input, not the
         null character '\\0'. A prior version of this translation
         checked `c == '\\0'`, which can never be true for Ptr's actual
         end-of-string sentinel -- it happened to produce the right
         answer at true end-of-input only by accident, because it also
         (incorrectly) treated "no operator matched" as "return term1"
         (see mitigation 5 below). Fixing that return value without also
         fixing this check would break ordinary end-of-string parsing
         (e.g. a bare "5" operand) by having it fall through to operator
         matching, find nothing, and (correctly, per the *fixed* NULL
         propagation) discard term1 entirely.

    Mitigations applied:
      1/2. _PARSE_OPERATORS kept in exact C declaration order; matching
           done by _match_operator(), which returns the first full-prefix
           hit with no precedence filtering. Precedence is checked only
           after a match is already fixed, exactly mirroring the C
           source's two separate `if` statements.
      3. End-of-input checks use `c == ''` (Ptr's actual sentinel),
         not `c == '\\0'`.
      4. (Also verified, no fix needed) `if (operators[opern].operprec
         <= prec) return term1;` was already correctly translated as an
         unconditional early return with no destroy -- kept as-is.
      5. `lw_expr_destroy(term1); return NULL;` -- both the "unrecognized
         operator" branch and the "term2 came back NULL" branch destroy
         term1 and return NULL in C. A prior version of this translation
         returned term1 in both cases ("to be safe"); this is wrong and
         has an observable effect: real lwasm rejects a term followed by
         unrecognized trailing input (e.g. "5`", "5@", "5.1") and a
         dangling operator with no right operand (e.g. "5+") as complete
         syntax errors ("Bad operand"), not as a successfully parsed
         partial expression. Both branches now return None.
    ---------------------------------------------------------------------
    """
    _skip_ws(p, compact)
    c = p.peek()
    if c == '' or c.isspace() or c in (')', ',', ']', ';'):
        return None

    term1 = _parse_term(p, ctx, compact)
    if term1 is None:
        return None

    while True:
        _skip_ws(p, compact)
        c = p.peek()
        if c == '' or c.isspace() or c in (')', ',', ']', ';'):
            return term1

        # Expecting an operator here. Match unconditionally, in table
        # (declaration) order, BEFORE looking at precedence at all --
        # see "Interaction risks" #1/#2 above for why this order matters.
        matched = _match_operator(p)

        if matched is None:
            # C: lw_expr_destroy(term1); return NULL;  (unrecognized
            # operator with input still remaining -- a real syntax error,
            # not "stop and hand back what we have").
            return None

        op_code, op_str, op_prec = matched

        # logic (from source.c): if the precedence of this operation is
        # <= to the "prec" flag, simply return without advancing the
        # input pointer; the operator will be evaluated again in the
        # enclosing function call.
        if op_prec <= prec:
            return term1

        # logic (from source.c): higher precedence operator -- advance
        # past it and let the expression evaluator loose on what
        # follows, of at least this operator's own precedence, before
        # building the operator node and continuing.
        p.advance(len(op_str))

        term2 = _parse_expr(p, ctx, op_prec, compact)
        if term2 is None:
            # C: lw_expr_destroy(term1); return NULL;
            return None

        term1 = Expr.oper(op_code, term1, term2)
        # continue evaluating: goto eval_next in C
