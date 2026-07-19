# Verified Python translation of insn_emit_tfm
# cocotools/insn_funcs.py (lines 1515-1517)
#
# Status: VERIFIED FAITHFUL (2026-07-18 audit, package 12)
# No changes were needed -- the translation already present in
# cocotools/insn_funcs.py matched the C source exactly. See SUMMARY.md
# in this package directory for the full audit trail.

def insn_emit_tfm(as_, cl):
    cl.emitop(cl.lint)
    cl.emit(cl.pb)
