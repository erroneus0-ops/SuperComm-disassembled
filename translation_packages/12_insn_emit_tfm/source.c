/* insn_emit_tfm
   lwtools-4.24/lwasm/insn_tfm.c lines 120-124 */

EMITFUNC(insn_emit_tfm)
{
	lwasm_emitop(l, l -> lint);
	lwasm_emit(l, l -> pb);
}
