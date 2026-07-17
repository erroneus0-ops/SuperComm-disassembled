# Pre-Translation Checklist: `insn_emit_rlist`

Metrics: 13 lines, 1 branches, 0 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  None.

## 2. Division / modulo
Not found.

## 3. char ** pointer parameters
Not found.

## 4. goto statements
  None.
Classify each: A=exit (return), B=shared code (helper fn), C=alternate parse (call fn).

## 5. char signedness
Low risk.

## 6. Argument evaluation order
Check for `(*p)++` in function argument position.
Python evaluates left-to-right -- verify this matches C behavior.

## 7. Integer promotion
Check compound expressions. Add mask only where C destination type truncates.

## 8. Bitwise complement
Not found.

## 9. Register lookup advancement
N/A.

## Character classification



## Interaction risks identified

1. **Missing side effect, not a width/sign/goto bug.** The single branch
   (`l->lint == 1`) delegates entirely to `insn_emit_imm8` and returns --
   no risk there. The risk is in the non-imm8 path: the C function's last
   line, `l->cycle_adj = lwasm_cycle_calc_rlist(l);`, calls a *second* C
   function (`cycle.c` line 656) that has no existing Python translation
   anywhere in `cocotools/`. A translator working only from `existing.py`
   or copy-pasting the emit logic could easily drop this line since it
   has no visible effect on assembled *bytes* -- `cycle_adj` only shows up
   in listing-file cycle counts (`list.c`), never in the object/binary
   output the byte-fidelity harness checks. This is exactly the kind of
   divergence that "looks correct, passes the easy tests, fails silently"
   the TRANSLATION_GUIDE warns about.
2. **Ordering with `cl.emitop()`'s own cycle_adj reset.** `lwasm_emitop`
   (`Line.emitop`) calls `cycle_update_count` on the *first* emitop for a
   line, which itself sets `cl->cycle_adj = 0` (`cycle.c` line 682) before
   `insn_emit_rlist` overwrites it with the real rlist tally. The Python
   translation must preserve this order (emitop, then emit, then the
   cycle_adj assignment) or the rlist-specific tally could be clobered
   back to 0, or computed before pb is fully known.

## Mitigations applied

- Added `_cycle_calc_rlist(cl)`, a direct translation of
  `lwasm_cycle_calc_rlist` (`cycle.c` lines 656-670), as a private helper
  in `insn_funcs.py`, and call it as the final statement of
  `insn_emit_rlist`, matching the C statement order exactly
  (`emitop` -> `emit` -> `cycle_adj = ...`).
- No width/mask primitives needed: `cl.pb` is already constrained to a
  byte value by parse time, and the accumulation in
  `_cycle_calc_rlist` is over an unbounded-safe range (max 8 cycles),
  well within Python's native int and matching C's `int cycles` with no
  truncation on assignment back to `cl->cycle_adj` (also plain `int`).
- Added 5 new structural tests asserting `cycle_adj` directly (PSHS D,
  PSHS PC, PSHS A,B,X, PULS A,B,X,PC, and the PSHS #$06 imm8-branch case)
  since this field has no effect on assembled bytes and the byte-fidelity
  harness alone would not have caught its absence.
