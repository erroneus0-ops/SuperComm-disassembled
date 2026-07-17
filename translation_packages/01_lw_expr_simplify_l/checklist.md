# Pre-Translation Checklist: `lw_expr_simplify_l`

Metrics: 576 lines, 117 branches, 5 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  - `tr = ~(E -> operands -> p -> value) & 0xff;`  (OPER_COM8 -- masks)

**FINDING (bug fixed):** the sibling case just above it,
`tr = ~(E -> operands -> p -> value);` (OPER_COM, no COM8 suffix), has
**no mask at all**. A prior version of this translation applied
`& 0xFFFF` to OPER_COM anyway (evidently over-generalizing from the
"16-bit complement" comment on the OPER_COM constant, which describes
when the *parser* chooses this operator, not how it's computed). Verified
against a real lwtools-4.24 build: `~5` simplifies to `-0x6` (plain int
complement), not `0xfffa`. Fixed: `_compute()` now returns `~vals[0]`
unmasked for OPER_COM, matching source.c exactly. OPER_COM8 is untouched
(`~vals[0] & 0xFF`, already correct).

## 2. Division / modulo
**FOUND** -- use `c_trunc_div()` / `c_trunc_mod()` for signed operands.
Already correctly applied in the existing `_compute()` for
OPER_DIVIDE / OPER_MOD / OPER_INTDIV. No change needed here.

## 3. char ** pointer parameters
Not found.

## 4. goto statements
  - `goto again;`        (SPECIAL resolution, on successful replace)
  - `goto again;`        (VAR resolution, on successful replace)
  - `goto tryagainplus;` (flatten nested PLUS -- restart scan after splice)
  - `goto tryagaintimes;`(flatten nested TIMES -- restart scan after splice)
  - `goto again;`        (like-term collection, after each merge)

Classify each: A=exit (return), B=shared code (helper fn), C=alternate parse (call fn).

  - The two `goto again` in SPECIAL/VAR resolution: **B** (shared code) --
    translated as a direct recursive call `self._simplify_go(ctx)` right
    after `_become(te)`. Verified safe: the label `again:` sits *after*
    the one-time MINUS->PLUS / NEG->TIMES normalization at the top of the
    C function, so C skips re-normalizing on this jump; the Python
    recursive call re-enters at the top and *would* re-run those checks,
    but since by definition `self.value` is no longer MINUS/NEG right
    after normalization ran (or never was), the checks are idempotent
    no-ops on re-entry -- confirmed no observable divergence.
  - The `goto tryagainplus` / `goto tryagaintimes`: **B** -- translated as
    Python `while changed: ...` loops that repeat the splice-and-rescan
    until no nested PLUS/TIMES operand remains. Equivalent full
    flattening, different mechanism.
  - The `goto again` inside like-term collection: **B**, but *not*
    replicated as a full jump back to the top of the whole function --
    translated as restarting only the like-term double loop (`restart =
    True` outer `while`). Analysis: a full C `goto again` here re-runs
    everything (flatten/cval-collect/sort-const-first/etc.) on the
    partially-modified tree in the *same* call; the narrower Python
    restart defers that re-run to the next iteration of
    `_simplify_l`'s outer "simplify until stable" loop instead. Since
    that outer loop already iterates to a fixed point and simplification
    is monotonic/idempotent, both reach the identical final tree -- just
    potentially in a different number of iterations, which is not
    externally observable. (This mirrors a simplification already present
    in the pre-existing flatten-PLUS/TIMES translation above, so it's
    consistent with the rest of this file rather than a new shortcut.)

## 5. char signedness
Low risk. N/A -- no char comparisons in this function.

## 6. Argument evaluation order
Checked -- no `(*p)++`-in-argument-position patterns; this function
doesn't touch the char-cursor parser at all.

## 7. Integer promotion
Checked all compound expressions (PLUS/MINUS/TIMES accumulation, `tr` in
the all-integer compute switch). All are plain C `int`, matching Python's
default unbounded ints -- no assignment here ever declares a fixed-width
destination, so no masking needed **except** the OPER_COM8 case already
covered under item 1.

## 8. Bitwise complement
**FOUND** -- see item 1 above for the full finding. Short version:
COM8 masks to 8 bits (`c_uint8`-equivalent, i.e. `& 0xFF`); plain COM
does **not** mask at all in source.c, despite the "16-bit complement"
naming/comment. Fixed to match.

## 9. Register lookup advancement
N/A.

## Character classification
N/A -- no character parsing in this function.

## Interaction risks identified

1. **`lw_expr_simplify_sortconstfirst` was called by this function but was
   never implemented anywhere in the existing Python codebase** (verified
   by grep -- no definition, no call site). Its absence didn't produce
   wrong final *values* in the common case (there's normally at most one
   literal-int operand per PLUS/TIMES list by the time it would run,
   since integer collection already merged them), but it does affect
   **operand order** in the resulting expression tree, and the like-term
   coefficient-extraction code in source.c specifically only reads the
   *first* operand of a TIMES node -- which is only reliably the
   coefficient if constants have been sorted to the front. Implemented
   `_sort_const_first()` faithfully (including the same "last-int-found
   ends up frontmost when the list has multiple" quirk of the real
   linked-list splice algorithm, verified against the C by hand-trace)
   and call it in the correct position (after TIMES zero-check, before
   like-term collection), matching source.c line ordering.

2. **The existing `_is_like_term` / `_coef_of` / `_base_of` helpers used a
   "single base expression" model** (grab the first non-int operand of a
   TIMES node and treat that as "the" base), which cannot represent a
   term with more than one non-constant factor (e.g. `2*X*Y`). Confirmed
   with a live before/after run of the *unfixed* code: `2*X*Y + 3*X*Y`
   simplified to `X*5` -- the `Y` factor was silently dropped from the
   result. Rewrote to operate on full operand lists (matching
   `lw_expr_simplify_isliketerm`'s actual TIMES-vs-TIMES /
   TIMES-vs-non-TIMES / neither-TIMES structure, including the C's
   "exactly 2 operands" requirement for the mixed case) and to read the
   coefficient only from the first operand (now safe, given fix #1).
   Verified fix against the real C: `2*X*Y + 3*X*Y` -> `5*X*Y`.

3. **A prior version of this function collapsed a PLUS node to a single
   operand (or to literal 0) immediately after integer-term collection**,
   before sort-const-first or like-term collection had run. In source.c
   this collapse is a *separate*, *later* block (lines 449-522) that only
   runs after like-term collection. In practice the early-exit only fired
   when 0 or 1 non-constant operands remained, in which case sort/like-term
   collection have nothing to do anyway -- so this was not independently
   confirmed to produce a wrong final value, but it *was* clearly the
   wrong place to put it relative to the C, and combined with bug #2
   above (which needs sort-const-first to have already run) it was
   fragile. Reordered to match source.c: cval-collect PLUS (no early
   return) -> cval-collect TIMES -> TIMES zero-check -> sort-const-first
   -> like-term collection -> dedicated PLUS collapse block (now the only
   place a PLUS node collapses) -> TIMES-distribute (moved to be last,
   matching source.c, instead of sitting between cval-collection and
   like-term collection).

4. **`_compute()`'s "unknown operator" fallback returns `None`**, which the
   caller currently reads as "don't collapse yet". In source.c, the `tr`
   local is uninitialized (`-42424242`) and the switch has no `default:`
   -- if `E->value` were ever an operator code outside the 20 defined
   ones, C would *still* unconditionally collapse the node to
   `TYPE_INT` with that sentinel garbage value. Every operator constant
   currently defined (1-20) is covered by the switch, so this path is
   unreachable for well-formed trees; left as `None`/skip rather than
   replicating the sentinel, since doing so would add a footgun (a
   literal `-42424242` appearing in output) for a case that cannot occur
   via any of this codebase's factory functions. Documented here rather
   than silently ignored, per "no exceptions, no this looks right".

## Mitigations applied
- `c_complement8` continues to be used for OPER_COM8 (`& 0xFF`).
- OPER_COM's mask removed entirely (no `c_uint16` applied) -- see item 1/8.
- `c_trunc_div` / `c_trunc_mod` unchanged, already correct for
  DIVIDE/MOD/INTDIV.
- New `_sort_const_first()`, `_compare_operand_list()`, and a fully
  rewritten `_is_like_term()` added to `cocotools/lw_expr.py`, replacing
  the old `_coef_of()` / `_base_of()` / `_is_like_term()` trio (confirmed
  via grep these were only used by the one call site being replaced).
- `_simplify_go`'s PLUS/TIMES tail (integer-term collection through
  distribution) reordered and partially rewritten to match source.c's
  block order exactly; see interaction risk #3.

## Verification method
Built lwtools-4.24 from source (`make` in the extracted tarball already
present in the repo) to get a real `lwasm` binary, and separately wrote a
small standalone C program linked directly against `liblw.a` that builds
hand-crafted `lw_expr_t` trees and calls the real `lw_expr_simplify()` on
them, printing results in the same postfix notation as `Expr.__repr__`.
This gave authoritative ground truth (not "what we think it should do")
for every edge case identified above. Cross-checked the *unfixed* Python
against the same cases first to confirm each bug was real (not just a
theoretical structural risk) before fixing, then re-checked the fixed
Python against the ground truth to confirm exact matches. All 8 new cases
now live in `cocotools/test_fidelity.py` as `EXPRESSION_SIMPLIFY_TESTS`.

Full harness run (`python cocotools/test_fidelity.py`) after the fix:
`166 + 27 + 18 + 8 = 219` tests, all passing. (211 pre-existing + 8 new.)
