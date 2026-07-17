/* insn_emit_rlist
   lwtools-4.24/lwasm/insn_rlist.c lines 96-108 */

EMITFUNC(insn_emit_rlist)
{
	if (l -> lint == 1)
	{
		insn_emit_imm8(as, l);
		return;
	}

	lwasm_emitop(l, instab[l -> insn].ops[0]);
	lwasm_emit(l, l -> pb);

	l -> cycle_adj = lwasm_cycle_calc_rlist(l);
}
