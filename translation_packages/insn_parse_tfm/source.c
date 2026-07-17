/* insn_parse_tfm
   lwtools-4.24/lwasm/insn_tfm.c lines 27-118 */

PARSEFUNC(insn_parse_tfm)
{
	static const char *reglist = "DXYUS   AB  00EF";
	int r0, r1;
	char *c;
	int tfm = 0;
			
	c = strchr(reglist, toupper(*(*p)++));
	if (!c)
	{
		lwasm_register_error(as, l, E_REGISTER_BAD);
		return;
	}
	r0 = c - reglist;
	if (**p == '+')
	{
		(*p)++;
		tfm = 1;
	}
	else if (**p == '-')
	{
		(*p)++;
		tfm = 2;
	}
	lwasm_skip_to_next_token(l, p);
	if (*(*p)++ != ',')
	{
		lwasm_register_error(as, l, E_UNKNOWN_OPERATION);
		return;
	}
	lwasm_skip_to_next_token(l, p);
	c = strchr(reglist, toupper(*(*p)++));
	if (!c)
	{
		lwasm_register_error(as, l, E_REGISTER_BAD);
		return;
	}
	r1 = c - reglist;

	if (**p == '+')
	{
		(*p)++;
		tfm |= 4;
	}
	else if (**p == '-')
	{
		(*p)++;
		tfm |= 8;
	}
	
	if (**p && !isspace(**p))
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	/* only D, X, Y, U, S are valid tfm registers */
	if (r0 > 4 || r1 > 4)
	{
		if (r0 < r1) r0 = r1;
		lwasm_register_error2(as, l, E_REGISTER_BAD, "'%c'", reglist[r0]);
	}

	// valid values of tfm here are:
	// 1: r0+,r1 (2)
	// 4: r0,r1+ (3)
	// 5: r0+,r1+ (0)
	// 10: r0-,r1- (1)
	switch (tfm)
	{
	case 5: //r0+,r1+
		l -> lint =  instab[l -> insn].ops[0];
		break;

	case 10: //r0-,r1-
		l -> lint = instab[l -> insn].ops[1];
		break;

	case 1: // r0+,r1
		l -> lint = instab[l -> insn].ops[2];
		break;

	case 4: // r0,r1+
		l -> lint = instab[l -> insn].ops[3];
		break;

	default:
		lwasm_register_error(as, l, E_UNKNOWN_OPERATION);
		return;
	}
	l -> pb = (r0 << 4) | r1;
	l -> len = OPLEN(l -> lint) + 1;
}
