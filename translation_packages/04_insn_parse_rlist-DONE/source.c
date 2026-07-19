/* insn_parse_rlist
   lwtools-4.24/lwasm/insn_rlist.c lines 33-94 */

PARSEFUNC(insn_parse_rlist)
{
	int rb = 0;
	int rn;
	static const char *regs = "CCA B DPX Y U PCD S ";

	l -> lint = 0;
	if (**p == '#')
	{
		insn_parse_imm8(as, l, p);
		l -> lint = 1;
		return;
	}

	while (**p && !isspace(**p) && **p != ';' && **p != '*')
	{
		rn = lwasm_lookupreg2(regs, p);
		if (rn < 0)
		{
			lwasm_register_error2(as, l, E_REGISTER_BAD, "'%s'", *p);
			return;
		}
		lwasm_skip_to_next_token(l, p);
		if (**p && **p != ',' && !isspace(**p) && **p != ';' && **p != '*')
		{
			lwasm_register_error(as, l, E_OPERAND_BAD);
		}
		if (**p == ',')
		{
			(*p)++;
			lwasm_skip_to_next_token(l, p);
		}
		if ((instab[l -> insn].ops[0]) & 2)
		{
			// pshu/pulu
			if (rn == 6)
			{
				lwasm_register_error2(as, l, E_REGISTER_BAD, "'%s'", "u");
				return;
			}
		}
		else
		{
			if (rn == 9)
			{
				lwasm_register_error2(as, l, E_REGISTER_BAD, "'%s'", "s");
				return;
			}
		}
		if (rn == 8)
			rn = 6;
		else if (rn == 9)
			rn = 0x40;
		else
			rn = 1 << rn;
		rb |= rn;
	}
	if (rb == 0)
		lwasm_register_error(as, l, E_OPERAND_BAD);
	l -> len = OPLEN(instab[l -> insn].ops[0]) + 1;
	l -> pb = rb;
}
