# Current Python translation of insn_emit_bitbit (and its parse/resolve
# siblings, for context) -- audited, matches cocotools/insn_funcs.py
# exactly as of this package's closeout.
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

def insn_resolve_bitbit(as_, cl, force):
    pass

def insn_emit_bitbit(as_, cl):
    # ---------------------------------------------------------------------------
    # FUNCTION: insn_emit_bitbit
    # SOURCE:   lwtools-4.24/lwasm/insn_bitbit.c lines 101-147
    # AUDITED:  14 Claude, 2026-07 (translation_packages/14)
    #
    # Pre-translation checklist results:
    #   [x] Integer width: `v1 = lw_expr_intval(e) & 0xFFFF` -- safe pattern,
    #       AND with a positive mask agrees with C on negatives in both
    #       languages (renamed to `vv` here purely to avoid shadowing the
    #       earlier bit-number `v1`; no behavioral difference from the C).
    #   [x] Division/modulo: none.
    #   [x] char **p: N/A (emit function, no parsing).
    #   [x] goto: none.
    #   [x] char signedness: N/A.
    #   [x] Argument order: N/A.
    #   [x] Promotion: pb = (lint<<6)|(v1<<3)|v2 stays well within int range
    #       for all valid lint (0-2) and v1/v2 (0-7, or 0 when invalid) --
    #       known-safe postbyte pattern, no mask needed.
    #   [x] Complement: none.
    #   [x] lookupreg: N/A.
    #
    # Interaction risk found: lwasm_fetch_expr can return NULL (id not
    # saved). C's lw_expr_istype(NULL, ...) is null-safe and returns 0,
    # but Python's e.istype(...) is an instance method -- calling it on
    # None raises AttributeError where C would not have errored. Mitigation:
    # guard every fetch_expr result with `e and e.istype(...)` rather than
    # a bare `e.istype(...)`, at all three fetch_expr call sites (ids 0, 1, 2).
    # Verified byte-for-byte against a from-source build of lwasm 4.24 for
    # all six bitbit mnemonics (BAND/BEOR/BIOR/BOR/LDBT/STBT) and against
    # all error branches (invalid bit number, byte overflow, unresolved
    # bit-number expression) -- see BEHAVIOR_TESTS_6309 in test_fidelity.py.
    # ---------------------------------------------------------------------------
    ops = _ops(cl)

    e = cl.fetch_expr(0)
    if not (e and e.istype(TYPE_INT)):
        as_.register_error(cl, E_BITNUMBER_UNRESOLVED)
        return
    v1 = e.intval()
    if v1 < 0 or v1 > 7:
        as_.register_error(cl, E_BITNUMBER_INVALID)
        v1 = 0

    e = cl.fetch_expr(1)
    if not (e and e.istype(TYPE_INT)):
        as_.register_error(cl, E_BITNUMBER_UNRESOLVED)
        return
    v2 = e.intval()
    if v2 < 0 or v2 > 7:
        as_.register_error(cl, E_BITNUMBER_INVALID)
        v2 = 0

    cl.pb = (cl.lint << 6) | (v1 << 3) | v2

    e = cl.fetch_expr(2)
    if e and e.istype(TYPE_INT):
        vv = e.intval() & 0xFFFF
        diff = vv - (cl.dpval << 8)
        if diff > 0xFF or diff < 0:
            as_.register_error(cl, E_BYTE_OVERFLOW)
            return

    cl.emitop(ops[0])
    cl.emit(cl.pb)
    cl.emitexpr(e, 1)
