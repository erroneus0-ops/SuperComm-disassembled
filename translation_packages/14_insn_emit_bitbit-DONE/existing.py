# Current Python translation of insn_emit_bitbit
# cocotools/insn_funcs.py

def insn_emit_bitbit(as_, cl):
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

