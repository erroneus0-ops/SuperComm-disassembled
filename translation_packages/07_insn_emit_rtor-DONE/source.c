/* insn_emit_rtor
   lwtools-4.24/lwasm/insn_rtor.c lines 58-62 */

EMITFUNC(insn_emit_rtor)
{
	lwasm_emitop(l, instab[l -> insn].ops[0]);
	lwasm_emit(l, l -> pb);
}
