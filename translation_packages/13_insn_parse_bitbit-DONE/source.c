/* insn_parse_bitbit
   lwtools-4.24/lwasm/insn_bitbit.c lines 30-99 */

PARSEFUNC(insn_parse_bitbit)
{
	int r;
	lw_expr_t e;
//	int v1;
//	int tv;

	r = toupper(*(*p)++);
	if (r == 'A')
		r = 1;
	else if (r == 'B')
		r = 2;
	else if (r == 'C' && toupper(**p) == 'C')
	{
		r = 0;
		(*p)++;
	}
	else
	{
		lwasm_register_error(as, l, E_REGISTER_BAD);
		return;
	}
	lwasm_skip_to_next_token(l, p);
	if (*(*p)++ != ',')
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	e = lwasm_parse_expr(as, p);
	if (!e)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	lwasm_save_expr(l, 0, e);
	if (*(*p)++ != ',')
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}

	e = lwasm_parse_expr(as, p);
	if (!e)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	lwasm_save_expr(l, 1, e);

	if (*(*p)++ != ',')
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	lwasm_skip_to_next_token(l, p);
	// ignore base page address modifier
	if (**p == '<')
		(*p)++;
			
	e = lwasm_parse_expr(as, p);
	if (!e)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	lwasm_save_expr(l, 2, e);

	l -> lint = r;
	l -> len = OPLEN(instab[l -> insn].ops[0]) + 2;
}
