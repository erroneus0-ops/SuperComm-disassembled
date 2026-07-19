# Current Python translation of insn_parse_indexed_aux
# cocotools/insn_funcs.py

def insn_parse_indexed_aux(as_, cl, p):
    """
    Faithful translation of insn_parse_indexed_aux (insn_indexed.c 39-464).

    Parses one indexed-addressing operand starting at Ptr p. Side effects
    (matching the C out-parameter line_t *l):
        cl.pb    -- either a fully-resolved postbyte, or (when the offset
                    size can't be decided yet) a marker byte consumed by
                    _insn_resolve_indexed_aux.
        cl.lint  -- 0/1/2/3 = decided (no-offset/8-bit/16-bit/5-bit), or
                    left at -1 (or whatever the caller preset) when still
                    undetermined.
        p        -- advanced past the consumed operand text.
    Errors are registered on cl via as_.register_error and the function
    returns (void, like the C original); every error path in the C is an
    immediate return with no further side effects, reproduced here as an
    early Python `return`.
    """
    if curpragma(cl, PRAGMA_6809):
        reglist = _REGS9
    else:
        reglist = _REGS

    indir = 0

    # is it indirect?
    if p.peek() == '[':
        indir = 1
        p.advance()

    _skip_to_next_token(cl, p)

    if p.peek() == ',':
        incdec = 0
        # pre-dec, post-inc, or no-offset mode
        p.advance()
        _skip_to_next_token(cl, p)
        if p.peek() == '-':
            incdec = -1
            p.advance()
            if p.peek() == '-':
                incdec = -2
                p.advance()
            _skip_to_next_token(cl, p)

        # allowed registers here: X, Y, U, S, or W (6309) -- NOT PC/PCR
        c = p.peek()
        if c in ('x', 'X'):
            rn = 0
        elif c in ('y', 'Y'):
            rn = 1
        elif c in ('u', 'U'):
            rn = 2
        elif c in ('s', 'S'):
            rn = 3
        elif c in ('w', 'W'):
            if curpragma(cl, PRAGMA_6809):
                as_.register_error(cl, E_OPERAND_BAD)
                return
            rn = 4
        else:
            as_.register_error(cl, E_OPERAND_BAD)
            return
        p.advance()
        _skip_to_next_token(cl, p)

        if p.peek() == '+':
            if incdec != 0:
                as_.register_error(cl, E_OPERAND_BAD)
                return
            incdec = 1
            p.advance()
            if p.peek() == '+':
                incdec = 2
                p.advance()
            _skip_to_next_token(cl, p)

        if indir:
            if p.peek() != ']':
                as_.register_error(cl, E_OPERAND_BAD)
                return
            p.advance()

        if indir or rn == 4:
            if incdec == 1 or incdec == -1:
                as_.register_error(cl, E_OPERAND_BAD)
                return

        if rn == 4:
            if indir:
                if incdec == 0:
                    i = 0x90
                elif incdec == -2:
                    i = 0xF0
                else:
                    i = 0xD0
            else:
                if incdec == 0:
                    i = 0x8F
                elif incdec == -2:
                    i = 0xEF
                else:
                    i = 0xCF
        else:
            if incdec == 0:
                i = 0x84
            elif incdec == 1:
                i = 0x80
            elif incdec == 2:
                i = 0x81
            elif incdec == -1:
                i = 0x82
            elif incdec == -2:
                i = 0x83
            i = (rn << 5) | i | (indir << 4)

        cl.pb   = i
        cl.lint = 0
        return

    # accumulator-offset forms: A,R  B,R  D,R  (and 6309 E,R  F,R  W,R)
    i = p.peek().upper() if p.peek() else ''
    if (i in ('A', 'B', 'D')) or (not curpragma(cl, PRAGMA_6809) and i in ('E', 'F', 'W')):
        # Lookahead only -- a SEPARATE cursor, not shared with p, matching
        # C's `tstr = *p + 1` local pointer that is only copied back into
        # *p if the comma actually matches (see checklist note above).
        tstr = Ptr(p.s, p.pos + 1)
        _skip_to_next_token(cl, tstr)
        if tstr.peek() == ',':
            p.pos = tstr.pos + 1
            _skip_to_next_token(cl, p)
            c = p.peek()
            if c in ('x', 'X'):
                rn = 0
            elif c in ('y', 'Y'):
                rn = 1
            elif c in ('u', 'U'):
                rn = 2
            elif c in ('s', 'S'):
                rn = 3
            else:
                as_.register_error(cl, E_OPERAND_BAD)
                return
            p.advance()
            _skip_to_next_token(cl, p)
            if indir:
                if p.peek() != ']':
                    as_.register_error(cl, E_OPERAND_BAD)
                    return
                p.advance()

            if i == 'A':
                i = 0x86
            elif i == 'B':
                i = 0x85
            elif i == 'D':
                i = 0x8B
            elif i == 'E':
                i = 0x87
            elif i == 'F':
                i = 0x8A
            elif i == 'W':
                i = 0x8E

            cl.pb   = i | (indir << 4) | (rn << 5)
            cl.lint = 0
            return
        # else: not actually an accumulator-offset (e.g. a label starting
        # with A/B/D/E/F/W) -- fall through to expression parsing below,
        # exactly as C does (p was never advanced, only the local tstr).

    # we have the "expression" types now
    if p.peek() == '<':
        cl.lint = 1
        p.advance()
        if p.peek() == '<':
            cl.lint = 3
            p.advance()
            if indir:
                as_.register_error(cl, E_ILL5)
                return
    elif p.peek() == '>':
        cl.lint = 2
        p.advance()

    _skip_to_next_token(cl, p)

    f0 = 0
    if p.peek() == '0':
        tstr = Ptr(p.s, p.pos + 1)
        _skip_to_next_token(cl, tstr)
        if tstr.peek() == ',':
            f0 = 1

    # now we have to evaluate the expression
    e = as_.parse_expr(p)
    if not e:
        as_.register_error(cl, E_OPERAND_BAD)
        return
    cl.save_expr(0, e)

    if p.peek() != ',':
        # if no comma, we have extended indirect
        if cl.lint == 1 or p.peek() != ']':
            as_.register_error(cl, E_OPERAND_BAD)
            return
        p.advance()
        cl.lint = 2
        cl.pb   = 0x9F
        return

    p.advance()
    _skip_to_next_token(cl, p)

    # now get the register
    rn = AsmState.lookupreg3(reglist, p)
    if rn < 0:
        as_.register_error(cl, E_REGISTER_BAD)
        return

    if indir:
        if p.peek() != ']':
            as_.register_error(cl, E_OPERAND_BAD)
            return
        else:
            p.advance()

    if rn <= 3:
        # X,Y,U,S
        if cl.lint == 1:
            cl.pb = 0x88 | (rn << 5) | (0x10 if indir else 0)
            return
        elif cl.lint == 2:
            cl.pb = 0x89 | (rn << 5) | (0x10 if indir else 0)
            return
        elif cl.lint == 3:
            cl.pb = (rn << 5)
            # NOTE: no return here -- matches C exactly. Execution falls
            # through to the bottom of the function, where the final
            # `if (l->lint != 3)` guard prevents cl.pb being overwritten;
            # the 5-bit offset itself gets merged into cl.pb later, at
            # emit time (see _insn_emit_gen_aux / insn_emit_indexed).

    # nnnn,W is only 16 bit (or 0 bit)
    if rn == 4:
        if cl.lint == 1:
            as_.register_error(cl, E_NW_8)
            return
        elif cl.lint == 3:
            as_.register_error(cl, E_ILL5)
            return
        if cl.lint == 2:
            cl.pb   = 0xb0 if indir else 0xaf
            cl.lint = 2
            return
        cl.pb = (0x80 * indir) | rn
        return

    # PCR? then we have PC relative addressing (like B??, LB??)
    if rn == 5 or (rn == 6 and curpragma(cl, PRAGMA_PCASPCR)):
        # e - (addr + linelen) => e - addr - linelen
        e2 = Expr.special(lwasm_expr_linelen, cl)
        e1 = Expr.oper(OPER_MINUS, e, e2)
        e2 = Expr.oper(OPER_MINUS, e1, cl.addr)
        cl.save_expr(0, e2)
        if cl.lint == 1:
            cl.pb = 0x9C if indir else 0x8C
            return
        elif cl.lint == 2:
            cl.pb = 0x9D if indir else 0x8D
            return
        elif cl.lint == 3:
            as_.register_error(cl, E_ILL5)
            return

    if rn == 6:
        if cl.lint == 1:
            cl.pb = 0x9C if indir else 0x8C
            return
        elif cl.lint == 2:
            cl.pb = 0x9D if indir else 0x8D
            return
        elif cl.lint == 3:
            as_.register_error(cl, E_ILL5)
            return

    if cl.lint != 3:
        cl.pb = (indir * 0x80) | rn | (f0 * 0x40)


# ---------------------------------------------------------------------------
# FUNCTION: insn_resolve_indexed_aux  (module-private: _insn_resolve_indexed_aux)
# SOURCE:   lwtools-4.24/lwasm/insn_indexed.c lines 479-707 (approx.)
# TRANSLATED / RE-TRANSLATED: 2026-07-17
#
# Not the primary subject of this translation package (that is package
# 03), but re-translated here as required glue: this is the *only*
# consumer of the "undetermined offset" marker byte that the newly
# faithful insn_parse_indexed_aux (above) writes into cl.pb, and the
# marker's bit layout changed as a direct result of that translation
# (register field now unshifted in bits 0-2, indirect at bit 7, explicit
# "f0" zero-offset flag at bit 6 -- see insn_parse_indexed_aux's header
# comment). The previous hand-rolled resolve helper decoded a different,
# incompatible layout (register pre-shifted into bits 5-6, indirect at
# bit 4) that matched the previous hand-rolled parse helper. Plugging in
# a faithful parser without also fixing this decoder would silently
# corrupt every forward-referenced indexed operand. A full line-by-line
# audit of this function (matching package 02's process: checklist,
# independent translation, comparison, tests) is still recommended as
# follow-up under package 03 -- this translation is a faithful, complete
# transliteration of the C but has not been through that separate audit
# process.
# ---------------------------------------------------------------------------

