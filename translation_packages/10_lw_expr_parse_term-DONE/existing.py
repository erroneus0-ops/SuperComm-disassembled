# Current Python translation of lw_expr_parse_term
# cocotools/lw_expr.py
#
# Updated by the translation-package-10 audit: fixed two bugs found by
# comparing against source.c (see checklist.md and SUMMARY.md for detail).
#   1. End-of-input check was `c == '\0'`; Ptr.peek() never returns '\0',
#      only ''. Fixed to `c == ''`.
#   2. `c.isspace()` diverges from C's isspace() for several characters
#      (ASCII FS/GS/RS/US 0x1C-0x1F, non-ASCII Unicode space separators).
#      Fixed to use the shared `c_isspace()` primitive from c_compat, per
#      this package's own checklist.md instruction.
#
# Requires: from .c_compat import c_isspace (alongside the existing
# c_trunc_div, Ptr imports already at the top of lw_expr.py).

def _parse_term(p, ctx, compact):
    """
    lw_expr_parse_term: handle prefix operators and parentheses,
    then delegate to ctx.parse_term for atomic terms.

    ---------------------------------------------------------------------
    Pre-translation checklist results (see checklist.md for full detail):
      Integer width: none (no fixed-width assignments)
      Division/modulo: none (no / or % in this function)
      char **p: FOUND -- p is a Ptr, shared with _parse_expr and (via the
        unary-'+' goto) with itself; never rebuilt from p.remaining().
      goto: FOUND -- `goto eval_next;` is a self re-entry after consuming
        a unary '+' with no other state to preserve; translated as a
        direct recursive call to this same function.
      char signedness: safe -- only ASCII punctuation is compared to *p.
      Argument order: safe -- no (*p)++ in argument position.
      Promotion: safe -- no fixed-width destination anywhere here.
      Complement: N/A at this level -- OPER_COM/OPER_COM8 are only built
        as tree nodes here; the actual ~ computation (and its 8-bit
        mask) happens later in Expr._compute, not in the parser.
      lookupreg: N/A.

    Interaction risks identified (found comparing against existing.py):
      1. Ptr.peek() returns '' (empty string) at end of input, never the
         C NUL character '\\0' -- the same sentinel mistake already
         identified and fixed in _parse_expr's docstring (risk #3
         there). existing.py's check here was `c == '\\0'`, which can
         never be true, so the C's `if (!**p) return NULL;` case was
         never reached directly -- true end-of-input instead fell
         through every other branch and reached
         `ctx.parse_term(p, ctx)`, asking the atom parser to parse a
         term out of nothing.
      2. checklist.md flags `isspace(**p)` with the mitigation
         `c_isspace(c)`. existing.py used Python's `c.isspace()`
         directly. Python's str.isspace() agrees with C's isspace()
         (C locale) for the whitespace characters lwasm's own source
         actually emits (space/tab/CR/LF/FF/VT), but ALSO returns True
         for characters C's isspace() does not treat as whitespace --
         concretely, the ASCII control characters U+001C-U+001F
         (file/group/record/unit separator) and non-ASCII Unicode space
         separators such as U+00A0 (NBSP). Confirmed directly:
         '\\x1c'.isspace() is True in Python but isspace(0x1C) is false
         in C's "C" locale. Any of these characters appearing where a
         term is expected would be (incorrectly) treated as an
         immediate end-of-term by existing.py, when the C source would
         instead fall through to attempt `parse_term(p, priv)` on it.

    Mitigations applied:
      1. End-of-input check changed from `c == '\\0'` to `c == ''`,
         matching Ptr's actual sentinel value (mirrors the identical
         fix already applied in _parse_expr).
      2. `c.isspace()` replaced with `c_isspace(c)` (imported from
         c_compat), matching the checklist's explicit instruction and
         removing the divergence documented in risk #2 above.

    Both fixes are provably observable at the direct-unit-test level
    (see UNIT_TESTS_PARSE_TERM in test_fidelity.py): a stub parse_term
    callback shows existing.py either wrongly invoking it (case 1, via
    fallthrough) or wrongly skipping it (case 2, via the FS-control-char
    false positive) relative to the fixed version.
    ---------------------------------------------------------------------
    """
    _skip_ws(p, compact)
    c = p.peek()

    if c == '' or c_isspace(c) or c in (')', ']'):
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


