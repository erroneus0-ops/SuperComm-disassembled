# Current Python translation of insn_emit_rtor
# cocotools/insn_funcs.py

def insn_emit_rtor(as_, cl):
    cl.emitop(_ops(cl)[0])
    cl.emit(cl.pb)


# ─────────────────────────────────────────────────────────────────────────────
# Register list  (insn_rlist.c) — PSHS, PULS, PSHU, PULU
# ─────────────────────────────────────────────────────────────────────────────
# Register bits for stack list:
# bit 0=CC  1=A  2=B  3=DP  4=X  5=Y  6=U/S  7=PC

_RLIST_REGS = 'CCA B DPX Y U PCD S '

