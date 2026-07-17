/* insn_parse_logicmem
   lwtools-4.24/lwasm/insn_logicmem.c lines 37-64 */

PARSEFUNC(insn_parse_logicmem)
{
//	const char *p2;
	lw_expr_t s;
	
	if (**p == '#')
		(*p)++;
	
	s = lwasm_parse_expr(as, p);
	if (!s)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	
	lwasm_save_expr(l, 100, s);
	lwasm_skip_to_next_token(l, p);
	if (**p != ',' && **p != ';')
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	
	(*p)++;
	lwasm_skip_to_next_token(l, p);
	// now we have a general addressing mode - call for it
	insn_parse_gen_aux(as, l, p, 1);
}
