# Current Python translation of insn_emit_rtor
# cocotools/insn_funcs.py
#
# Pre-translation checklist results (2026-07-17 audit,
# translation_packages/07_insn_emit_rtor):
#   - Integer width: no assignments in this function; N/A
#   - Division/modulo: none
#   - char **p: N/A (no operand cursor)
#   - goto: none
#   - char signedness: N/A
#   - Argument order: N/A (single-value arguments only)
#   - Promotion: N/A (no arithmetic)
#   - Complement: none
#   - lookupreg: N/A
#
# Interaction risks: instab[l->insn].ops[0] may be a two-byte opcode
#   (> 0xFF) for 6309-only rtor-family instructions (ADCR/ADDR/ANDR/
#   CMPR/EORR/ORR/SBCR/SUBR), driving a branch inside lwasm_emitop/
#   cl.emitop() not visible in this function's own source.
# Mitigations applied: none needed -- straight pass-through, verified
#   byte-for-byte against real lwasm 4.24 including the two-byte-opcode
#   path (see translation_packages/07_insn_emit_rtor/ and
#   cocotools/test_fidelity.py: rtor-two-byte-opcode-adcr-6309,
#   struct-tfr-d-x-output-bytes, struct-exg-a-b-output-bytes).

def insn_emit_rtor(as_, cl):
    cl.emitop(_ops(cl)[0])
    cl.emit(cl.pb)


# ─────────────────────────────────────────────────────────────────────────────
# Register list  (insn_rlist.c) — PSHS, PULS, PSHU, PULU
# ─────────────────────────────────────────────────────────────────────────────
# Register bits for stack list:
# bit 0=CC  1=A  2=B  3=DP  4=X  5=Y  6=U/S  7=PC

_RLIST_REGS = 'CCA B DPX Y U PCD S '
