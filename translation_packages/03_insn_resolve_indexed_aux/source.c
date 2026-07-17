/* insn_resolve_indexed_aux
   lwtools-4.24/lwasm/insn_indexed.c lines 480-750 */

void insn_resolve_indexed_aux(asmstate_t *as, line_t *l, int force, int elen)
{
	// here, we have an expression which needs to be
	// resolved; the post byte is determined here as well
	lw_expr_t e, e2;
	int pb = -1;
	int v;
	
	if (l -> len != -1)
		return;

	e = lwasm_fetch_expr(l, 0);
	if (!lw_expr_istype(e, lw_expr_type_int))
	{
		// temporarily set the instruction length to see if we get a
		// constant for our expression; if so, we can select an instruction
		// size
		e2 = lw_expr_copy(e);
		// magic 2 for 8 bit (post byte + offset)
		l -> len = OPLEN(instab[l -> insn].ops[0]) + elen + 2;
		lwasm_reduce_expr(as, e2);
//		l -> len += 1;
//		e3 = lw_expr_copy(e);
//		lwasm_reduce_expr(as, e3);
		l -> len = -1;
		if (lw_expr_istype(e2, lw_expr_type_int))
		{
			v = lw_expr_intval(e2);
			// we have a reducible expression here which depends on
			// the size of this instruction
			if (v == 0 && !CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) && (l -> pb & 0x07) <= 4)
			{
				if ((l -> pb & 0x07) < 4)
				{
					pb = 0x84 | ((l -> pb & 0x03) << 5) | ((l -> pb & 0x80) ? 0x10 : 0);
				}
				else
				{
					pb = (l -> pb & 0x80) ? 0x90 : 0x8F;
				}
				l -> pb = pb;
				lw_expr_destroy(e2);
				l -> lint = 0;
				return;
			}
			else if (v < -128 || v > 127)
			{
				l -> lint = 2;
				switch (l -> pb & 0x07)
				{
				case 0:
				case 1:
				case 2:
				case 3:
					pb = 0x89 | ((l -> pb & 0x03) << 5) | ((l -> pb & 0x80) ? 0x10 : 0);
					break;
			
				case 4: // W
					pb = (l -> pb & 0x80) ? 0xB0 : 0xAF;
					break;
				
				case 5: // PCR
				case 6: // PC
					pb = (l -> pb & 0x80) ? 0x9D : 0x8D;
					break;
				}
				
				l -> pb = pb;
				lw_expr_destroy(e2);
//				lw_expr_destroy(e3);
				return;
			}
			else if ((l -> pb & 0x80) || ((l -> pb & 0x07) > 3) || v < -16 || v > 15)
			{
				// if not a 5 bit value, is indirect, or is not X,Y,U,S
				l -> lint = 1;
				switch (l -> pb & 0x07)
				{
				case 0:
				case 1:
				case 2:
				case 3:
					pb = 0x88 | ((l -> pb & 0x03) << 5) | ((l -> pb & 0x80) ? 0x10 : 0);
					break;
			
				case 4: // W
					// use 16 bit because W doesn't have 8 bit, unless 0
					if (v == 0 && !(CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) || l -> pb & 0x40))
					{
						pb = (l -> pb & 0x80) ? 0x90 : 0x8F;
						l -> lint = 0;
					}
					else
					{
						pb = (l -> pb & 0x80) ? 0xB0 : 0xAF;
						l -> lint = 2;
					}
					break;
				
				case 5: // PCR
				case 6: // PC
					pb = (l -> pb & 0x80) ? 0x9C : 0x8C;
					break;
				}
			
				l -> pb = pb;
				lw_expr_destroy(e2);
				return;
			}
			else
			{
				// we have X,Y,U,S and a possible 5 bit here
				l -> lint = 0;
				
				if (v == 0 && !(CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) || l -> pb & 0x40))
				{
					pb = (l -> pb & 0x03) << 5 | 0x84;
				}	
				else
				{
					pb = ((l -> pb & 0x03) << 5) | (v & 0x1F);
				}
				l -> pb = pb;
				lw_expr_destroy(e2);
				return;
			}
		}
		else
		{
			if ((l -> pb & 0x07) == 5 || (l -> pb & 0x07) == 6)
			{
				// NOTE: this will break in some particularly obscure corner cases
				// which are not likely to show up in normal code. Notably, if, for
				// some reason, the target gets *farther* away if shorter addressing
				// modes are chosen, which should only happen if the symbol is before
				// the instruction in the source file and there is some sort of ORG
				// statement or similar in between which forces the address of this
				// instruction, and the differences happen to cross the 8 bit boundary.
				// For this reason, we use a heuristic and allow a margin on the 8
				// bit boundary conditions.
				v = as -> pretendmax;
				as -> pretendmax = 1;
				lwasm_reduce_expr(as, e2);
				as -> pretendmax = v;
				if (lw_expr_istype(e2, lw_expr_type_int))
				{
					v = lw_expr_intval(e2);
					// Actual range is -128 <= offset <= 127; we're allowing a fudge
					// factor of 25 or so bytes so that we're less likely to accidentally
					// cross into the 16 bit boundary in weird corner cases.
					if (v >= -100 && v <= 100)
					{
						l -> lint = 1;
						l -> pb = (l -> pb & 0x80) ? 0x9C : 0x8C;
						lw_expr_destroy(e2);
						return;
					}
				}
			}
		}
		lw_expr_destroy(e2);
	}
		
	if (lw_expr_istype(e, lw_expr_type_int))
	{
		// we know how big it is
		v = lw_expr_intval(e);
			
		if (v == 0 && !CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) && (l -> pb & 0x07) <= 4 && ((l -> pb & 0x40) == 0))
		{
			if ((l -> pb & 0x07) < 4)
			{
				pb = 0x84 | ((l -> pb & 0x03) << 5) | ((l -> pb & 0x80) ? 0x10 : 0);
			}
			else
			{
				pb = (l -> pb & 0x80) ? 0x90 : 0x8F;
			}
			l -> pb = pb;
			l -> lint = 0;
			return;
		}
		else if (v < -128 || v > 127)
		{
		do16bit:
			l -> lint = 2;
			switch (l -> pb & 0x07)
			{
			case 0:
			case 1:
			case 2:
			case 3:
				pb = 0x89 | (l -> pb & 0x03) << 5 | ((l -> pb & 0x80) ? 0x10 : 0);
				break;
			
			case 4: // W
				pb = (l -> pb & 0x80) ? 0xB0 : 0xAF;
				break;
				
			case 5: // PCR
			case 6: // PC
				pb = (l -> pb & 0x80) ? 0x9D : 0x8D;
				break;
			}
			
			l -> pb = pb;
			return;
		}
		else if ((l -> pb & 0x80) || ((l -> pb & 0x07) > 3) || v < -16 || v > 15)
		{
			// if not a 5 bit value, is indirect, or is not X,Y,U,S
			l -> lint = 1;
			switch (l -> pb & 0x07)
			{
			case 0:
			case 1:
			case 2:
			case 3:
				pb = 0x88 | (l -> pb & 0x03) << 5 | ((l -> pb & 0x80) ? 0x10 : 0);
				break;
			
			case 4: // W
				// use 16 bit because W doesn't have 8 bit, unless 0
				if (v == 0 && !(CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) || l -> pb & 0x40))
				{
					pb = (l -> pb & 0x80) ? 0x90 : 0x8F;
					l -> lint = 0;
				}
				else
				{
					pb = (l -> pb & 0x80) ? 0xB0 : 0xAF;
					l -> lint = 2;
				}
				break;
				
			case 5: // PCR
			case 6: // PC
				pb = (l -> pb & 0x80) ? 0x9C : 0x8C;
				break;
			}
			
			l -> pb = pb;
			return;
		}
		else
		{
			// we have X,Y,U,S and a possible 5 bit here
			l -> lint = 0;
			
			if (v == 0 && !(CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) || l -> pb & 0x40))
			{
				pb = (l -> pb & 0x03) << 5 | 0x84;
			}
			else
			{
				pb = ((l -> pb & 0x03) << 5) | (v & 0x1F);
			}
			l -> pb = pb;
			return;
		}
	}
	else
	{
		// we don't know how big it is
		if (!force)
			return;
		// force 16 bit if we don't know
		l -> lint = 2;
		goto do16bit;
	}
}
