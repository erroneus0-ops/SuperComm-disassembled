/* lw_expr_parse_expr
   lwtools-4.24/lwlib/lw_expr.c lines 1290-1391 */

lw_expr_t lw_expr_parse_expr(char **p, void *priv, int prec)
{
	static const struct operinfo
	{
		int opernum;
		char *operstr;
		int operprec;
	} operators[] =
	{
		{ lw_expr_oper_plus, "+", 100 },
		{ lw_expr_oper_minus, "-", 100 },
		{ lw_expr_oper_times, "*", 150 },
		{ lw_expr_oper_divide, "/", 150 },
		{ lw_expr_oper_mod, "%", 150 },
		{ lw_expr_oper_intdiv, "\\", 150 },
		
		{ lw_expr_oper_and, "&&", 25 },
		{ lw_expr_oper_or, "||", 25 },
		
		{ lw_expr_oper_bwand, "&", 50 },
		{ lw_expr_oper_bwor, "|", 50 },
		{ lw_expr_oper_bwor, "!", 50 },
		{ lw_expr_oper_bwxor, "^", 50 },
		
		{ lw_expr_oper_eq, "==", 55 },
		{ lw_expr_oper_ne, "!=", 55 },
		{ lw_expr_oper_ne, "<>", 55 },
		{ lw_expr_oper_lt, "<", 60 },
		{ lw_expr_oper_le, "<=", 60 },
		{ lw_expr_oper_gt, ">", 60 },
		{ lw_expr_oper_ge, ">=", 60 },
		
		{ lw_expr_oper_none, "", 0 }
	};
	
	int opern, i;
	lw_expr_t term1, term2, term3;
	
	lw_expr_parse_next_tok(p);
	if (!**p || isspace(**p) || **p == ')' || **p == ',' || **p == ']' || **p == ';')
		return NULL;

	term1 = lw_expr_parse_term(p, priv);
	if (!term1)
		return NULL;

eval_next:
	lw_expr_parse_next_tok(p);
	if (!**p || isspace(**p) || **p == ')' || **p == ',' || **p == ']' || **p == ';')
		return term1;
	
	// expecting an operator here
	for (opern = 0; operators[opern].opernum != lw_expr_oper_none; opern++)
	{
		for (i = 0; (*p)[i] && operators[opern].operstr[i] && ((*p)[i] == operators[opern].operstr[i]); i++)
			/* do nothing */;
		if (operators[opern].operstr[i] == '\0')
			break;
	}
	
	if (operators[opern].opernum == lw_expr_oper_none)
	{
		// unrecognized operator
		lw_expr_destroy(term1);
		return NULL;
	}

	// operator number is in opern, length of oper in i
	
	// logic:
	// if the precedence of this operation is <= to the "prec" flag,
	// we simply return without advancing the input pointer; the operator
	// will be evaluated again in the enclosing function call
	if (operators[opern].operprec <= prec)
		return term1;
	
	// logic:
	// we have a higher precedence operator here so we will advance the
	// input pointer to the next term and let the expression evaluator
	// loose on it after which time we will push our operator onto the
	// stack and then go on with the expression evaluation
	(*p) += i;
	
	// evaluate next expression(s) of higher precedence
	term2 = lw_expr_parse_expr(p, priv, operators[opern].operprec);
	if (!term2)
	{
		lw_expr_destroy(term1);
		return NULL;
	}
	
	// now create operator
	term3 = lw_expr_build(lw_expr_type_oper, operators[opern].opernum, term1, term2);
	lw_expr_destroy(term1);
	lw_expr_destroy(term2);
	
	// the new "expression" is the next "left operand"
	term1 = term3;
	
	// continue evaluating
	goto eval_next;
}
