# Current Python translation of insn_emit_logicmem -- audited, matches
# cocotools/insn_funcs.py exactly as of this package's closeout.
# cocotools/insn_funcs.py

def insn_emit_logicmem(as_, cl):
    # ---------------------------------------------------------------------------
    # FUNCTION: insn_emit_logicmem
    # SOURCE:   lwtools-4.24/lwasm/insn_logicmem.c lines 74-95
    # AUDITED:  16 Claude, 2026-07 (translation_packages/16)
    #
    # Pre-translation checklist results:
    #   [x] Integer width: `v & 0xFF` -- safe pattern, positive-mask AND
    #       agrees with C on negatives in both languages.
    #   [x] Division/modulo: the pre-filled checklist template flagged this
    #       as "FOUND", but there is no `/` or `%` anywhere in this
    #       function -- that entry was a stale/incorrect template default,
    #       not an actual finding. Corrected in checklist.md.
    #   [x] char **p: N/A (emit function).
    #   [x] goto: none.
    #   [x] char signedness: N/A.
    #   [x] Argument order: N/A.
    #   [x] Promotion: `v & 0xFF` always yields 0-255, safe as the `extra`
    #       arg to _insn_emit_gen_aux (which treats -1 as sentinel "no
    #       extra byte" -- v & 0xFF can never equal -1, so the extra byte
    #       is always emitted here, matching C's unconditional call).
    #   [x] Complement: none.
    #   [x] lookupreg: N/A.
    #
    # Note: the C source has a commented-out byte-range check
    # (`if (v < -128 || v > 255) ... E_BYTE_OVERFLOW`) that is dead code --
    # never compiled, never executes in real lwasm 4.24. Correctly NOT
    # reproduced here; adding it would be a behavioral deviation from the
    # actual reference binary, not a fidelity improvement.
    #
    # Interaction risk: same NULL-fetch_expr risk as insn_emit_bitbit --
    # fetch_expr(100) can return None, so the guard is `e and
    # e.istype(TYPE_INT)`, not a bare `e.istype(...)`.
    #
    # Verified byte-for-byte against a from-source build of lwasm 4.24 for
    # direct/extended/indexed(5-bit)/indexed-indirect addressing modes and
    # the unresolved-immediate error path -- see the logicmem-* entries in
    # BEHAVIOR_TESTS_6309 in test_fidelity.py.
    # ---------------------------------------------------------------------------
    e = cl.fetch_expr(100)
    if not (e and e.istype(TYPE_INT)):
        as_.register_error(cl, E_IMMEDIATE_UNRESOLVED)
        return
    v = e.intval()
    _insn_emit_gen_aux(as_, cl, v & 0xFF)


# ─────────────────────────────────────────────────────────────────────────────
# 6309 conv instructions (NEGQ, TSTQ etc.)
# ─────────────────────────────────────────────────────────────────────────────
