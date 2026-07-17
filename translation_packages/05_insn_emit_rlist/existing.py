# Current Python translation of insn_emit_rlist
# cocotools/insn_funcs.py

def insn_emit_rlist(as_, cl):
    if cl.lint == 1:
        insn_emit_imm8(as_, cl); return
    cl.emitop(_ops(cl)[0])
    cl.emit(cl.pb)


# ─────────────────────────────────────────────────────────────────────────────
# Logic-mem (6309 AIM/EIM/OIM/TIM) — stub
# ─────────────────────────────────────────────────────────────────────────────

# ─────────────────────────────────────────────────────────────────────────────
# Logic-mem (6309 AIM/EIM/OIM/TIM)  (insn_logicmem.c)
# ─────────────────────────────────────────────────────────────────────────────
# Syntax: AIM #imm,<gen-mode-operand>  (also OIM/EIM/TIM)
# The immediate value is saved in expression slot 100 (matching the C
# source's use of that slot number as an "extra" operand outside the
# normal 0/1/2 slots used by the general addressing-mode machinery), then
# the remaining operand is parsed exactly like any other general-mode
# instruction, with elen=1 to account for the extra immediate byte that
# will be emitted alongside the addressing-mode bytes.

