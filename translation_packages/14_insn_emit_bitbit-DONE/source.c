/* insn_emit_bitbit
   lwtools-4.24/lwasm/insn_bitbit.c lines 101-147 */

EMITFUNC(insn_emit_bitbit)
{
	int v1, v2;
	lw_expr_t e;
	
	e = lwasm_fetch_expr(l, 0);
	if (!lw_expr_istype(e, lw_expr_type_int))
	{
		lwasm_register_error(as, l, E_BITNUMBER_UNRESOLVED);
		return;
	}
	v1 = lw_expr_intval(e);
	if (v1 < 0 || v1 > 7)
	{
		lwasm_register_error(as, l, E_BITNUMBER_INVALID);
		v1 = 0;
	}

	e = lwasm_fetch_expr(l, 1);
	if (!lw_expr_istype(e, lw_expr_type_int))
	{
		lwasm_register_error(as, l, E_BITNUMBER_UNRESOLVED);
		return;
	}
	v2 = lw_expr_intval(e);
	if (v2 < 0 || v2 > 7)
	{
		lwasm_register_error(as, l, E_BITNUMBER_INVALID);
		v2 = 0;
	}
	l -> pb = (l -> lint << 6) | (v1 << 3) | v2;
	
	e = lwasm_fetch_expr(l, 2);
	if (lw_expr_istype(e, lw_expr_type_int))
	{
		v1 = lw_expr_intval(e) & 0xFFFF;
		v2 = v1 - ((l -> dpval) << 8);
		if (v2 > 0xFF || v2 < 0)
		{
			lwasm_register_error(as, l, E_BYTE_OVERFLOW);
			return;
		}
	}
	lwasm_emitop(l, instab[l -> insn].ops[0]);
	lwasm_emit(l, l -> pb);
	lwasm_emitexpr(l, e, 1);
}
