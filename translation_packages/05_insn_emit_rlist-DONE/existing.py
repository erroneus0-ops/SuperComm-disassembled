# Current Python translation of insn_emit_rlist
# cocotools/insn_funcs.py
#
# UPDATED 2026-07-17: fixed missing cycle_adj computation (was silently
# dropping the l->cycle_adj = lwasm_cycle_calc_rlist(l) line from source.c).
# See SUMMARY.md in this package for the full audit.

def _cycle_calc_rlist(cl):
    """lwasm_cycle_calc_rlist(cl): extra ticks for pushed/pulled registers.

    1 cycle for each of the four 8-bit registers (bits 0-3: CC,A,B,DP),
    2 cycles for each of the four 16-bit registers (bits 4-7: X,Y,U/S,PC).
    """
    cycles = 0
    for i in range(8):
        if cl.pb & (1 << i):
            cycles += 1 if i <= 3 else 2
    return cycles

def insn_emit_rlist(as_, cl):
    if cl.lint == 1:
        insn_emit_imm8(as_, cl); return

    cl.emitop(_ops(cl)[0])
    cl.emit(cl.pb)

    cl.cycle_adj = _cycle_calc_rlist(cl)


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
