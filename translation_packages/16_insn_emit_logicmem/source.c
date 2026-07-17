/* insn_emit_logicmem
   lwtools-4.24/lwasm/insn_logicmem.c lines 74-95 */

EMITFUNC(insn_emit_logicmem)
{
	lw_expr_t e;
	int v;
	
	e = lwasm_fetch_expr(l, 100);
	if (!lw_expr_istype(e, lw_expr_type_int))
	{
		lwasm_register_error(as, l, E_IMMEDIATE_UNRESOLVED);
		return;
	}
	
	v = lw_expr_intval(e);
/*	if (v < -128 || v > 255)
	{
		fprintf(stderr, "BYTE: %d\n", v);
		lwasm_register_error(as, l, E_BYTE_OVERFLOW);
		return;
	}
*/	
	insn_emit_gen_aux(as, l, v & 0xff);
}
