# Current Python translation of insn_emit_tfm
# cocotools/insn_funcs.py

def insn_emit_tfm(as_, cl):
    cl.emitop(cl.lint)
    cl.emit(cl.pb)


# ─────────────────────────────────────────────────────────────────────────────
# Inter-register postbyte form (6309 TFR-style: ADDR/SUBR/CMPR/ANDR/ORR/
# EORR/ADCR/SBCR and similar r0,r1 instructions)  (insn_tfm.c insn_parse_tfmrtor)
# ─────────────────────────────────────────────────────────────────────────────
# Any of the 16 TFR/EXG-style registers is legal here (unlike TFM itself,
# which restricts to D/X/Y/U/S) -- matches lwasm_lookupreg2 over the full
# register table: D,X,Y,U,S,PC,W,V,A,B,CC,DP,0,0,E,F.

_TFMRTOR_REGS = "D X Y U S       A B     0 0 E F "

