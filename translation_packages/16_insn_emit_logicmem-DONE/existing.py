# Current Python translation of insn_emit_logicmem
# cocotools/insn_funcs.py

def insn_emit_logicmem(as_, cl):
    e = cl.fetch_expr(100)
    if not (e and e.istype(TYPE_INT)):
        as_.register_error(cl, E_IMMEDIATE_UNRESOLVED)
        return
    v = e.intval()
    _insn_emit_gen_aux(as_, cl, v & 0xFF)


# ─────────────────────────────────────────────────────────────────────────────
# 6309 conv instructions (NEGQ, TSTQ etc.)
# ─────────────────────────────────────────────────────────────────────────────

