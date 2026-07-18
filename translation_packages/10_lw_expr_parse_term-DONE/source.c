/* lw_expr_parse_term
   lwtools-4.24/lwlib/lw_expr.c lines 1226-1288 */

lw_expr_t lw_expr_parse_term(char **p, void *priv)
{
	lw_expr_t term, term2;
	
eval_next:
	lw_expr_parse_next_tok(p);

	if (!**p || isspace(**p) || **p == ')' || **p == ']')
		return NULL;
	// parentheses
	if (**p == '(')
	{
		(*p)++;
		term = lw_expr_parse_expr(p, priv, 0);
		lw_expr_parse_next_tok(p);
		if (**p != ')')
		{
			lw_expr_destroy(term);
			return NULL;
		}
		(*p)++;
		return term;
	}
	
	// unary +
	if (**p == '+')
	{
		(*p)++;
		goto eval_next;
	}
	
	// unary - (prec 200)
	if (**p == '-')
	{
		(*p)++;
		term = lw_expr_parse_expr(p, priv, 200);
		if (!term)
			return NULL;
		
		term2 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_neg, term);
		lw_expr_destroy(term);
		return term2;
	}
	
	// unary ^ or ~ (complement, prec 200)
	if (**p == '^' || **p == '~')
	{
		(*p)++;
		term = lw_expr_parse_expr(p, priv, 200);
		if (!term)
			return NULL;
		
		if (expr_width == 8)
			term2 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_com8, term);
		else
			term2 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_com, term);
		lw_expr_destroy(term);
		return term2;
	}
	
	// non-operator - pass to caller
	return parse_term(p, priv);
}
