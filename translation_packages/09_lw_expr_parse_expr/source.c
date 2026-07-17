/* lw_expr_parse_expr
   lwtools-4.24/lwlib/lw_expr.c lines 1216-1224 */

lw_expr_t lw_expr_parse_expr(char **p, void *priv, int prec);

static void lw_expr_parse_next_tok(char **p)
{
	if (parse_compact)
		return;
	for (; **p && isspace(**p); (*p)++)
		/* do nothing */ ;
}
