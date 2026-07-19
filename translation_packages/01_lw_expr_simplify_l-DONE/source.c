/* lw_expr_simplify_l
   lwtools-4.24/lwlib/lw_expr.c lines 578-1153 */

void lw_expr_simplify_l(lw_expr_t E, void *priv);

void lw_expr_simplify_go(lw_expr_t E, void *priv)
{
	struct lw_expr_opers *o;

	// replace subtraction with O1 + -1(O2)...
	// needed for like term collection
	if (E -> type == lw_expr_type_oper && E -> value == lw_expr_oper_minus)
	{
		for (o = E -> operands -> next; o; o = o -> next)
		{
			lw_expr_t e1, e2;
			
			e2 = lw_expr_build(lw_expr_type_int, -1);
			e1 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_times, e2, o -> p);
			lw_expr_destroy(o -> p);
			lw_expr_destroy(e2);
			o -> p = e1;
		}
		E -> value = lw_expr_oper_plus;
	}

	// turn "NEG" into -1(O) - needed for like term collection
	if (E -> type == lw_expr_type_oper && E -> value == lw_expr_oper_neg)
	{
		lw_expr_t e1;
		
		E -> value = lw_expr_oper_times;
		e1 = lw_expr_build(lw_expr_type_int, -1);
		lw_expr_add_operand(E, e1);
		lw_expr_destroy(e1);
	}
	
again:
	// try to resolve non-constant terms to constants here
	if (E -> type == lw_expr_type_special && evaluate_special)
	{
		lw_expr_t te;
		
		te = evaluate_special(E -> value, E -> value2, priv);
		if (lw_expr_contains(te, E))
			lw_expr_destroy(te);
		else if (te)
		{
			for (o = E -> operands; o; o = o -> next)
				lw_expr_destroy(o -> p);
			if (E -> type == lw_expr_type_var)
				lw_free(E -> value2);
			*E = *te;
			E -> operands = NULL;
	
			if (te -> type == lw_expr_type_var)
				E -> value2 = lw_strdup(te -> value2);
			for (o = te -> operands; o; o = o -> next)
			{
				lw_expr_t xxx;
				xxx = lw_expr_copy(o -> p);
				lw_expr_add_operand(E, xxx);
				lw_expr_destroy(xxx);
			}
			lw_expr_destroy(te);
			goto again;
		}
		return;
	}

	if (E -> type == lw_expr_type_var && evaluate_var)
	{
		lw_expr_t te;
		
		te = evaluate_var(E -> value2, priv);
		if (!te)
			return;
		if (lw_expr_contains(te, E))
			lw_expr_destroy(te);
		else if (te)
		{
			for (o = E -> operands; o; o = o -> next)
				lw_expr_destroy(o -> p);
			if (E -> type == lw_expr_type_var)
				lw_free(E -> value2);
			*E = *te;
			E -> operands = NULL;
	
			if (te -> type == lw_expr_type_var)
				E -> value2 = lw_strdup(te -> value2);
			for (o = te -> operands; o; o = o -> next)
			{
				lw_expr_add_operand(E, lw_expr_copy(o -> p));
			}
			lw_expr_destroy(te);
			goto again;
		}
		return;
	}

	// non-operators have no simplification to do!
	if (E -> type != lw_expr_type_oper)
		return;

	// merge plus operations
	if (E -> value == lw_expr_oper_plus)
	{
	tryagainplus:
		for (o = E -> operands; o; o = o -> next)
		{
			if (o -> p -> type == lw_expr_type_oper && o -> p -> value == lw_expr_oper_plus)
			{
				struct lw_expr_opers *o2;
				// we have a + operation - bring operands up
				
				for (o2 = E -> operands; o2 && o2 -> next != o; o2 = o2 -> next)
					/* do nothing */ ;
				if (o2)
					o2 -> next = o -> p -> operands;
				else
					E -> operands = o -> p -> operands;
				for (o2 = o -> p -> operands; o2 -> next; o2 = o2 -> next)
					/* do nothing */ ;
				o2 -> next = o -> next;
				o -> p -> operands = NULL;
				lw_expr_destroy(o -> p);
				lw_free(o);
				goto tryagainplus;
			}
		}
	}
	
	// merge times operations
	if (E -> value == lw_expr_oper_times)
	{
	tryagaintimes:
		for (o = E -> operands; o; o = o -> next)
		{
			if (o -> p -> type == lw_expr_type_oper && o -> p -> value == lw_expr_oper_times)
			{
				struct lw_expr_opers *o2;
				// we have a + operation - bring operands up
				
				for (o2 = E -> operands; o2 && o2 -> next != o; o2 = o2 -> next)
					/* do nothing */ ;
				if (o2)
					o2 -> next = o -> p -> operands;
				else
					E -> operands = o -> p -> operands;
				for (o2 = o -> p -> operands; o2 -> next; o2 = o2 -> next)
					/* do nothing */ ;
				o2 -> next = o -> next;
				o -> p -> operands = NULL;
				lw_expr_destroy(o -> p);
				lw_free(o);
				goto tryagaintimes;
			}
		}
	}
	
	// simplify operands
	for (o = E -> operands; o; o = o -> next)
		if (o -> p -> type != lw_expr_type_int)
			lw_expr_simplify_l(o -> p, priv);

	for (o = E -> operands; o; o = o -> next)
	{
		if (o -> p -> type != lw_expr_type_int)
			break;
	}

	if (!o)
	{
		// we can do the operation here!
		int tr = -42424242;
		
		switch (E -> value)
		{
		case lw_expr_oper_neg:
			tr = -(E -> operands -> p -> value);
			break;

		case lw_expr_oper_com:
			tr = ~(E -> operands -> p -> value);
			break;
		
		case lw_expr_oper_com8:
			tr = ~(E -> operands -> p -> value) & 0xff;
			break;
		
		case lw_expr_oper_plus:
			tr = E -> operands -> p -> value;
			for (o = E -> operands -> next; o; o = o -> next)
				tr += o -> p -> value;
			break;

		case lw_expr_oper_minus:
			tr = E -> operands -> p -> value;
			for (o = E -> operands -> next; o; o = o -> next)
				tr -= o -> p -> value;
			break;

		case lw_expr_oper_times:
			tr = E -> operands -> p -> value;
			for (o = E -> operands -> next; o; o = o -> next)
				tr *= o -> p -> value;
			break;

		case lw_expr_oper_divide:
			if (E -> operands -> next -> p -> value == 0)
			{
				tr = 0;
				lw_expr_divzero(priv);
				break;
			}
			tr = E -> operands -> p -> value / E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_mod:
			if (E -> operands -> next -> p -> value == 0)
			{
				tr = 0;
				lw_expr_divzero(priv);
				break;
			}
			tr = E -> operands -> p -> value % E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_intdiv:
			if (E -> operands -> next -> p -> value == 0)
			{
				tr = 0;
				lw_expr_divzero(priv);
				break;
			}
			tr = E -> operands -> p -> value / E -> operands -> next -> p -> value;
			break;

		case lw_expr_oper_bwand:
			tr = E -> operands -> p -> value & E -> operands -> next -> p -> value;
			break;

		case lw_expr_oper_bwor:
			tr = E -> operands -> p -> value | E -> operands -> next -> p -> value;
			break;

		case lw_expr_oper_bwxor:
			tr = E -> operands -> p -> value ^ E -> operands -> next -> p -> value;
			break;

		case lw_expr_oper_and:
			tr = E -> operands -> p -> value && E -> operands -> next -> p -> value;
			break;

		case lw_expr_oper_or:
			tr = E -> operands -> p -> value || E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_eq:
			tr = E -> operands -> p -> value == E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_ne:
			tr = E -> operands -> p -> value != E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_lt:
			tr = E -> operands -> p -> value < E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_le:
			tr = E -> operands -> p -> value <= E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_gt:
			tr = E -> operands -> p -> value > E -> operands -> next -> p -> value;
			break;
		
		case lw_expr_oper_ge:
			tr = E -> operands -> p -> value >= E -> operands -> next -> p -> value;
			break;
		
		}
		
		while (E -> operands)
		{
			o = E -> operands;
			E -> operands = o -> next;
			lw_expr_destroy(o -> p);
			lw_free(o);
		}
		E -> type = lw_expr_type_int;
		E -> value = tr;
		return;
	}

	if (E -> value == lw_expr_oper_plus)
	{
		lw_expr_t e1;
		int cval = 0;
		
		e1 = lw_expr_create();
		e1 -> operands = E -> operands;
		E -> operands = 0;
		
		for (o = e1 -> operands; o; o = o -> next)
		{
			if (o -> p -> type == lw_expr_type_int)
				cval += o -> p -> value;
			else
				lw_expr_add_operand(E, o -> p);
		}
		lw_expr_destroy(e1);
		if (cval)
		{
			e1 = lw_expr_build(lw_expr_type_int, cval);
			lw_expr_add_operand(E, e1);
			lw_expr_destroy(e1);
		}
	}

	if (E -> value == lw_expr_oper_times)
	{
		lw_expr_t e1;
		int cval = 1;
		
		e1 = lw_expr_create();
		e1 -> operands = E -> operands;
		E -> operands = 0;
		
		for (o = e1 -> operands; o; o = o -> next)
		{
			if (o -> p -> type == lw_expr_type_int)
				cval *= o -> p -> value;
			else
				lw_expr_add_operand(E, o -> p);
		}
		lw_expr_destroy(e1);
		if (cval != 1)
		{
			e1 = lw_expr_build(lw_expr_type_int, cval);
			lw_expr_add_operand(E, e1);
			lw_expr_destroy(e1);
		}
	}

	if (E -> value == lw_expr_oper_times)
	{
		for (o = E -> operands; o; o = o -> next)
		{
			if (o -> p -> type == lw_expr_type_int && o -> p -> value == 0)
			{
				// one operand of times is 0, replace operation with 0
				while (E -> operands)
				{
					o = E -> operands;
					E -> operands = o -> next;
					lw_expr_destroy(o -> p);
					lw_free(o);
				}
				E -> type = lw_expr_type_int;
				E -> value = 0;
				return;
			}
		}
	}
	
	// sort "constants" to the start of each operand list for + and *
	if (E -> value == lw_expr_oper_plus || E -> value == lw_expr_oper_times)
		lw_expr_simplify_sortconstfirst(E);
	
	// look for like terms and collect them together
	if (E -> value == lw_expr_oper_plus)
	{
		struct lw_expr_opers *o2;
		for (o = E -> operands; o; o = o -> next)
		{
			// skip constants
			if (o -> p -> type == lw_expr_type_int)
				continue;
			
			// we have a term to match
			// (o -> p) is first term
			for (o2 = o -> next; o2; o2 = o2 -> next)
			{
				lw_expr_t e1, e2;
				
				if (o2 -> p -> type == lw_expr_type_int)
					continue;

				if (lw_expr_simplify_isliketerm(o -> p, o2 -> p))
				{
					int coef, coef2;
					
					// we have a like term here
					// do something about it
					if (o -> p -> type == lw_expr_type_oper && o -> p -> value == lw_expr_oper_times)
					{
						if (o -> p -> operands -> p -> type == lw_expr_type_int)
							coef = o -> p -> operands -> p -> value;
						else
							coef = 1;
					}
					else
						coef = 1;
					if (o2 -> p -> type == lw_expr_type_oper && o2 -> p -> value == lw_expr_oper_times)
					{
						if (o2 -> p -> operands -> p -> type == lw_expr_type_int)
							coef2 = o2 -> p -> operands -> p -> value;
						else
							coef2 = 1;
					}
					else
						coef2 = 1;
					coef += coef2;
					e1 = lw_expr_create();
					e1 -> type = lw_expr_type_oper;
					e1 -> value = lw_expr_oper_times;
					if (coef != 1)
					{
						e2 = lw_expr_build(lw_expr_type_int, coef);
						lw_expr_add_operand(e1, e2);
						lw_expr_destroy(e2);
					}
					lw_expr_destroy(o -> p);
					o -> p = e1;
					if (o2 -> p -> type == lw_expr_type_oper)
					{
						for (o = o2 -> p -> operands; o; o = o -> next)
						{
							if (o -> p -> type == lw_expr_type_int)
								continue;
							lw_expr_add_operand(e1, o -> p);
						}
					}
					else
					{
						lw_expr_add_operand(e1, o2 -> p);
					}
					lw_expr_destroy(o2 -> p);
					o2 -> p = lw_expr_build(lw_expr_type_int, 0);
					goto again;
				}
			}
		}
	}


	if (E -> value == lw_expr_oper_plus)
	{
		int c = 0, t = 0;
		for (o = E -> operands; o; o = o -> next)
		{
			t++;
			if (!(o -> p -> type == lw_expr_type_int && o -> p -> value == 0))
			{
				c++;
			}
		}
		if (c == 1)
		{
			lw_expr_t r = NULL;
			// find the value and "move it up"
			while (E -> operands)
			{
				o = E -> operands;
				if (o -> p -> type != lw_expr_type_int || o -> p -> value != 0)
				{
					r = lw_expr_copy(o -> p);
				}
				E -> operands = o -> next;
				lw_expr_destroy(o -> p);
				lw_free(o);
			}
			*E = *r;
			lw_free(r);
			return;
		}
		else if (c == 0)
		{
			// replace with 0
			while (E -> operands)
			{
				o = E -> operands;
				E -> operands = o -> next;
				lw_expr_destroy(o -> p);
				lw_free(o);
			}
			E -> type = lw_expr_type_int;
			E -> value = 0;
			return;
		}
		else if (c != t)
		{
			// collapse out zero terms
			struct lw_expr_opers *o2;
			
			for (o = E -> operands; o; o = o -> next)
			{
				if (o -> p -> type == lw_expr_type_int && o -> p -> value == 0)
				{
					if (o == E -> operands)
					{
						E -> operands = o -> next;
						lw_expr_destroy(o -> p);
						lw_free(o);
						o = E -> operands;
					}
					else
					{
						for (o2 = E -> operands; o2 -> next == o; o2 = o2 -> next)
							/* do nothing */ ;
						o2 -> next = o -> next;
						lw_expr_destroy(o -> p);
						lw_free(o);
						o = o2;
					}
				}
			}
		}
		return;
	}
	
	/* handle <int> times <plus> - expand the terms - only with exactly two operands */
	if (E -> value == lw_expr_oper_times)
	{
		lw_expr_t t1;
		lw_expr_t E2;
		lw_expr_t E3;
		if (E -> operands && E -> operands -> next && !(E -> operands -> next -> next))
		{
			if (E -> operands -> p -> type  == lw_expr_type_int)
			{
				/* <int> TIMES <other> */
				E2 = E -> operands -> next -> p;
				E3 = E -> operands -> p;
				if (E2 -> type == lw_expr_type_oper && E2 -> value == lw_expr_oper_plus)
				{
					lw_free(E -> operands -> next);
					lw_free(E -> operands);
					E -> operands = NULL;
					E -> value = lw_expr_oper_plus;
					
					for (o = E2 -> operands; o; o = o -> next)
					{
						t1 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_times, E3, o -> p);
						lw_expr_add_operand(E, t1);
						lw_expr_destroy(t1);
					}
					
					lw_expr_destroy(E2);
					lw_expr_destroy(E3);
				}
			}
			else if (E -> operands -> next -> p -> type == lw_expr_type_int)
			{
				/* <other> TIMES <int> */
				E2 = E -> operands -> p;
				E3 = E -> operands -> next -> p;
				if (E2 -> type == lw_expr_type_oper && E2 -> value == lw_expr_oper_plus)
				{
					lw_free(E -> operands -> next);
					lw_free(E -> operands);
					E -> operands = NULL;
					E -> value = lw_expr_oper_plus;
					
					for (o = E2 -> operands; o; o = o -> next)
					{
						t1 = lw_expr_build(lw_expr_type_oper, lw_expr_oper_times, E3, o -> p);
						lw_expr_add_operand(E, t1);
					}
					
					lw_expr_destroy(E2);
					lw_expr_destroy(E3);
				}
			}
		}
	}
}
