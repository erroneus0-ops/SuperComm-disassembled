/* insn_resolve_indexed_aux
   lwtools-4.24/lwasm/insn_gen.c lines 36-190 */

void insn_resolve_indexed_aux(asmstate_t *as, line_t *l, int force, int elen);

// "extra" is required due to the way OIM, EIM, TIM, and AIM work
void insn_parse_gen_aux(asmstate_t *as, line_t *l, char **p, int elen)
{
	char *optr2;
	int v1, tv;
	lw_expr_t s;
	
	if (!**p)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}

	/* this is the easy case - start it [ or , means indexed */
	if (**p == ',' || **p == '[')
	{
indexed:
		l -> lint = -1;
		l -> lint2  = 1;
		insn_parse_indexed_aux(as, l, p);
		l -> minlen = OPLEN(instab[l -> insn].ops[1]) + 1 + elen;
		l -> maxlen = OPLEN(instab[l -> insn].ops[1]) + 3 + elen;
		goto out;
	}

	/* we have to parse the first expression to find if we have a comma after it */
	optr2 = *p;
	if (**p == '<')
	{
		(*p)++;
		l -> lint2 = 0;
		if (**p == '<')
		{
			*p = optr2;
			goto indexed;
		}
	}
	// for compatibility with asxxxx
	// * followed by a digit, alpha, or _, or ., or ?, or another * is "f8"
	else if (**p == '*')
	{
		tv = *(*p + 1);
		if (isdigit(tv) || isalpha(tv) || tv == '_' || tv == '.' || tv == '?' || tv == '@' || tv == '*' || tv == '+' || tv == '-')
		{
			l -> lint2 = 0;
			(*p)++;
		}
	}
	else if (**p == '>')
	{
		(*p)++;
		l -> lint2 = 2;
	}
	else
	{
		l -> lint2 = -1;
	}
	lwasm_skip_to_next_token(l, p);
	
	s = lwasm_parse_expr(as, p);
	
	if (**p == ',')
	{
		/* we have an indexed mode here - reset and transfer control to indexing mode */
		lw_expr_destroy(s);
		*p = optr2;
		goto indexed;
	}
	if (!s)
	{
		lwasm_register_error(as, l, E_OPERAND_BAD);
		return;
	}
	
	lwasm_save_expr(l, 0, s);

	l -> minlen = OPLEN(instab[l -> insn].ops[0]) + 1 + elen;
	l -> maxlen = OPLEN(instab[l -> insn].ops[2]) + 2 + elen;
	if (as -> output_format == OUTPUT_OBJ && l -> lint2 == -1)
	{
		l -> lint2 = 2;
		goto out;
	}

	if (l -> lint2 != -1)
		goto out;

	// if we have a constant now, figure out dp vs nondp
	if (lw_expr_istype(s, lw_expr_type_int))
	{
		if (s -> value > 0xffff) lwasm_register_error(as, l, E_BYTE_OVERFLOW);

		v1 = lw_expr_intval(s);
		if (((v1 >> 8) & 0xff) == (l -> dpval & 0xff))
		{
			l -> lint2 = 0;
			goto out;
		}
		l -> lint2 = 2;
	}
	else
	{
		int min;
		int max;
		
		if (lwasm_calculate_range(as, s, &min, &max) == 0)
		{
//			fprintf(stderr, "range (P) %d...%d for %s\n", min, max, lw_expr_print(s));
			if (min > max)
			{
				// we don't know what to do in this case so don't do anything
				goto out;
			}
			min = (min >> 8) & 0xff;
			max = (max >> 8) & 0xff;
			if ((l -> dpval & 0xff) < min || (l -> dpval & 0xff) > max)
			{
				l -> lint2 = 2;
				goto out;
			}
			if (min == max && (l -> dpval & 0xff) == min)
			{
				l -> lint2 = 0;
				goto out;
			}
			// if here, we don't know if the value is in the DP or not
			{
				l -> lint2 = -1;
				goto out;
			}
		}
	}

out:
	if (l -> lint2 != -1)
	{
		if (l -> lint2 == 0)
		{
			l -> len = OPLEN(instab[l -> insn].ops[0]) + 1 + elen;
		}
		else if (l -> lint2 == 2)
		{
			l -> len = OPLEN(instab[l -> insn].ops[2]) + 2 + elen;
		}
		else if (l -> lint2 == 1 && l -> lint != -1)
		{
			if (l -> lint == 3)
				l -> len = OPLEN(instab[l -> insn].ops[1]) + 1 + elen;
			else
				l -> len = OPLEN(instab[l -> insn].ops[1]) + l -> lint + 1 + elen;
		}
	}
}
