/* insn_parse_indexed_aux
   lwtools-4.24/lwasm/insn_indexed.c lines 39-464 */

void insn_parse_indexed_aux(asmstate_t *as, line_t *l, char **p)
{
	static const char *regs9 = "X  Y  U  S     PCRPC ";
	static const char *regs  = "X  Y  U  S  W  PCRPC ";
	int i, rn;
	int indir = 0;
	int f0 = 0;
	const char *reglist;
	lw_expr_t e;
	char *tstr;
	

	if (CURPRAGMA(l, PRAGMA_6809))
	{
		reglist = regs9;
	}
	else
	{
		reglist = regs;
	}
	// is it indirect?
	if (**p == '[')
	{
		indir = 1;
		(*p)++;
	}
	lwasm_skip_to_next_token(l, p);
	if (**p == ',')
	{
		int incdec = 0;
		/* we have a pre-dec, post-inc, or no offset mode here */
		(*p)++;
		lwasm_skip_to_next_token(l, p);
		if (**p == '-')
		{
			incdec = -1;
			(*p)++;
			if (**p == '-')
			{
				incdec = -2;
				(*p)++;
			}
			lwasm_skip_to_next_token(l, p);
		}
		/* allowed registers: X, Y, U, S, or W (6309) */
		switch (**p)
		{
		case 'x':
		case 'X':
			rn = 0;
			break;
		
		case 'y':
		case 'Y':
			rn = 1;
			break;
			
		case 'u':
		case 'U':
			rn = 2;
			break;
			
		case 's':
		case 'S':
			rn = 3;
			break;
			
		case 'w':
		case 'W':
			if (CURPRAGMA(l, PRAGMA_6809))
			{
				lwasm_register_error(as, l, E_OPERAND_BAD);
				return;
			}
			rn = 4;
			break;
			
		default:
			lwasm_register_error(as, l, E_OPERAND_BAD);
			return;
		}
		(*p)++;
		lwasm_skip_to_next_token(l, p);
		if (**p == '+')
		{
			if (incdec != 0)
			{
				lwasm_register_error(as, l, E_OPERAND_BAD);
				return;
			}
			incdec = 1;
			(*p)++;
			if (**p == '+')
			{
				incdec = 2;
				(*p)++;
			}
			lwasm_skip_to_next_token(l, p);
		}
		if (indir)
		{
			if (**p != ']')
			{
				lwasm_register_error(as, l, E_OPERAND_BAD);
				return;
			}
			(*p)++;
		}
		if (indir || rn == 4)
		{
			if (incdec == 1 || incdec == -1)
			{
				lwasm_register_error(as, l, E_OPERAND_BAD);
				return;
			}
		}
		if (rn == 4)
		{
			if (indir)
			{
				if (incdec == 0)
					i = 0x90;
				else if (incdec == -2)
					i = 0xF0;
				else
					i = 0xD0;
			}
			else
			{
				if (incdec == 0)
					i = 0x8F;
				else if (incdec == -2)
					i = 0xEF;
				else
					i = 0xCF;
			}
		}
		else
		{
			switch (incdec)
			{
			case 0:
				i = 0x84;
				break;
			case 1:
				i = 0x80;
				break;
			case 2:
				i = 0x81;
				break;
			case -1:
				i = 0x82;
				break;
			case -2:
				i = 0x83;
				break;
			}
			i = (rn << 5) | i | (indir << 4);
		}
		l -> pb = i;
		l -> lint = 0;
		return;
	}
	i = toupper(**p);
	if (
			(i == 'A' || i == 'B' || i == 'D') ||
			(!CURPRAGMA(l, PRAGMA_6809) && (i == 'E' || i == 'F' || i == 'W'))
	   )
	{
		tstr = *p + 1;
		lwasm_skip_to_next_token(l, &tstr);
		if (*tstr == ',')
		{
			*p = tstr + 1;
			lwasm_skip_to_next_token(l, p);
			switch (**p)
			{
			case 'x':
			case 'X':
				rn = 0;
				break;
		
			case 'y':
			case 'Y':
				rn = 1;
				break;
			
			case 'u':
			case 'U':
				rn = 2;
				break;
			
			case 's':
			case 'S':
				rn = 3;
				break;
			
			default:
				lwasm_register_error(as, l, E_OPERAND_BAD);
				return;
			}
			(*p)++;
			lwasm_skip_to_next_token(l, p);
			if (indir)
			{
				if (**p != ']')
				{
					lwasm_register_error(as, l, E_OPERAND_BAD);
					return;
				}
				(*p)++;
			}
			
			switch (i)
			{
			case 'A':
				i = 0x86;
				break;
			
			case 'B':
				i = 0x85;
				break;
			
			case 'D':
				i = 0x8B;
				break;
			
			case 'E':
				i = 0x87;
				break;
			
			case 'F':
				i = 0x8A;
				break;
			
			case 'W':
				i = 0x8E;
				break;
			}
			l -> pb = i | (indir << 4) | (rn << 5);
			l -> lint = 0;
			return;
		}
	}
	
	/* we have the "expression" types now */
	if (**p == '<')
	{
		l -> lint = 1;
		(*p)++;
		if (**p == '<')
		{
			l -> lint = 3;
			(*p)++;
			if (indir)
			{
				lwasm_register_error(as, l, E_ILL5);
				return;
			}
		}
	}
	else if (**p == '>')
	{
		l -> lint = 2;
		(*p)++;
	}
	lwasm_skip_to_next_token(l, p);
	if (**p == '0')
	{
		tstr = *p + 1;
		lwasm_skip_to_next_token(l, &tstr);
		if (*tstr == ',')
		{
			f0 = 1;
		}
	}

	// now we have to evaluate the expression
	e = lwasm_parse_expr(as, p);
	if (!e)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	lwasm_save_expr(l, 0, e);
	
	if (**p != ',')
	{
		/* if no comma, we have extended indirect */
		if (l -> lint == 1 || **p != ']')
		{
			lwasm_register_error(as, l, E_OPERAND_BAD);
			return;
		}
		(*p)++;
		l -> lint = 2;
		l -> pb = 0x9F;
		return;
	}
	(*p)++;
	lwasm_skip_to_next_token(l, p);
	// now get the register
	rn = lwasm_lookupreg3(reglist, p);
	if (rn < 0)
	{
		lwasm_register_error(as, l, E_REGISTER_BAD);
		return;
	}
	
	if (indir)
	{
		if (**p != ']')
		{
			lwasm_register_error(as, l, E_OPERAND_BAD);
			return;
		}
		else
			(*p)++;
	}

	if (rn <= 3)
	{
		// X,Y,U,S
		if (l -> lint == 1)
		{
			l -> pb = 0x88 | (rn << 5) | (indir ? 0x10 : 0);
			return;
		}
		else if (l -> lint == 2)
		{
			l -> pb = 0x89 | (rn << 5) | (indir ? 0x10 : 0);
			return;
		}
		else if (l -> lint == 3)
		{
			l -> pb = (rn << 5);
		}
	}

	// nnnn,W is only 16 bit (or 0 bit)
	if (rn == 4)
	{
		if (l -> lint == 1)
		{
			lwasm_register_error(as, l, E_NW_8);
			return;
		}
		else if (l -> lint == 3)
		{
			lwasm_register_error(as, l, E_ILL5);
			return;
		}

		if (l -> lint == 2)
		{
			l -> pb = indir ? 0xb0 : 0xaf;
			l -> lint = 2;
			return;
		}
		
		l -> pb = (0x80 * indir) | rn;

/* [,w] and ,w
			if (indir)
				*b1 = 0x90;
			else
				*b1 = 0x8f;
*/
		return;
	}
	
	// PCR? then we have PC relative addressing (like B??, LB??)
	if (rn == 5 || (rn == 6 && CURPRAGMA(l, PRAGMA_PCASPCR)))
	{
		lw_expr_t e1, e2;
		// external references are handled exactly the same as for
		// relative addressing modes
		// on pass 1, adjust the expression for a subtraction of the
		// current address
		// e - (addr + linelen) => e - addr - linelen
		
		e2 = lw_expr_build(lw_expr_type_special, lwasm_expr_linelen, l);
		e1 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_minus, e, e2);
		lw_expr_destroy(e2);
		e2 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_minus, e1, l -> addr);
		lw_expr_destroy(e1);
		lwasm_save_expr(l, 0, e2);
		if (l -> lint == 1)
		{
			l -> pb = indir ? 0x9C : 0x8C;
			return;
		}
		else if (l -> lint == 2)
		{
			l -> pb = indir ? 0x9D : 0x8D;
			return;
		}
		else if (l -> lint == 3)
		{
			lwasm_register_error(as, l, E_ILL5);
			return;
		}
	}
	
	if (rn == 6)
	{
		if (l -> lint == 1)
		{
			l -> pb = indir ? 0x9C : 0x8C;
			return;
		}
		else if (l -> lint == 2)
		{
			l -> pb = indir ? 0x9D : 0x8D;
			return;
		}
		else if (l -> lint == 3)
		{
			lwasm_register_error(as, l, E_ILL5);
			return;
		}
	}

	if (l -> lint != 3)
		l -> pb = (indir * 0x80) | rn | (f0 * 0x40);
}
