/* insn_parse_rtor
   lwtools-4.24/lwasm/insn_rtor.c lines 25-56 */

PARSEFUNC(insn_parse_rtor)
{
	int r0, r1;

	static const char *regs = "D X Y U S PCW V A B CCDP0 0 E F ";
	static const char *regs9 = "D X Y U S PC    A B CCDP        ";
		
	// register to register (r0,r1)
	// registers are in order:
	// D,X,Y,U,S,PC,W,V
	// A,B,CC,DP,0,0,E,F

	r0 = lwasm_lookupreg2(!CURPRAGMA(l, PRAGMA_6809) ? regs : regs9, p);
	lwasm_skip_to_next_token(l, p);
	if (r0 < 0 || *(*p)++ != ',')
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		r0 = r1 = 0;
	}
	else
	{
		lwasm_skip_to_next_token(l, p);
		r1 = lwasm_lookupreg2(!CURPRAGMA(l, PRAGMA_6809) ? regs : regs9, p);
		if (r1 < 0)
		{
			lwasm_register_error(as, l, E_OPERAND_BAD);
			r0 = r1 = 0;
		}
	}
	l -> pb = (r0 << 4) | r1;
	l -> len = OPLEN(instab[l -> insn].ops[0]) + 1;
}
