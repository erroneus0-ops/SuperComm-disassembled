/* insn_emit_indexed_aux
   lwtools-4.24/lwasm/insn_indexed.c lines 766-829 */

void insn_emit_indexed_aux(asmstate_t *as, line_t *l)
{
	lw_expr_t e;
	
	if (l -> lint == 1)
	{
		int i;
		e = lwasm_fetch_expr(l, 0);
		i = lw_expr_intval(e);
		if (i < -128 || i > 127)
		{
			lwasm_register_error(as, l, E_BYTE_OVERFLOW);
		}
	}
	
	// exclude expr,W since that can only be 16 bits
	if (l -> lint == 3)
	{
		int offs;
		e = lwasm_fetch_expr(l, 0);
		if (lw_expr_istype(e, lw_expr_type_int))
		{
			offs = lw_expr_intval(e);
			if ((offs >= -16 && offs <= 15) || offs >= 0xFFF0)
			{
				l -> pb |= offs & 0x1f;
				l -> lint = 0;
			}
			else
			{
				lwasm_register_error(as, l, E_BYTE_OVERFLOW);
			}
		}
		else
		{
			lwasm_register_error(as, l, E_EXPRESSION_NOT_RESOLVED);
		}
	}
	// note that extended indirect (post byte 0x9f) can only be 16 bits
	else if (l -> lint == 2 && CURPRAGMA(l, PRAGMA_OPERANDSIZE) && (l -> pb != 0xAF && l -> pb != 0xB0 && l -> pb != 0x9f))
	{
		int offs;
		e = lwasm_fetch_expr(l, 0);
		if (lw_expr_istype(e, lw_expr_type_int))
		{
			offs = lw_expr_intval(e);
			if ((offs >= -128 && offs <= 127) || offs >= 0xFF80)
			{
				lwasm_register_error(as, l, W_OPERAND_SIZE);
			}
		}
	}
	
	lwasm_emitop(l, instab[l -> insn].ops[0]);
	lwasm_emitop(l, l -> pb);

	l -> cycle_adj = lwasm_cycle_calc_ind(l);

	if (l -> lint > 0)
	{
		e = lwasm_fetch_expr(l, 0);
		lwasm_emitexpr(l, e, l -> lint);
	}
}
