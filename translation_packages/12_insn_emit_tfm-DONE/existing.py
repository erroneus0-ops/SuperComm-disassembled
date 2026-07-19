# Current Python translation of insn_emit_tfm
# cocotools/insn_funcs.py

def insn_emit_tfm(as_, cl):
    cl.emitop(cl.lint)
    cl.emit(cl.pb)


# ─────────────────────────────────────────────────────────────────────────────
# Inter-register postbyte form (6309 TFR-style: ADDR/SUBR/CMPR/ANDR/ORR/
# EORR/ADCR/SBCR)  (insn_tfm.c insn_parse_tfmrtor)
# ─────────────────────────────────────────────────────────────────────────────

_TFMRTOR_REGS = "D X Y U S       A B     0 0 E F "

