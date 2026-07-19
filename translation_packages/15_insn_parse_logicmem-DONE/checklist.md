# Pre-Translation Checklist: `insn_parse_logicmem`

Metrics: 28 lines, 3 branches, 0 gotos
Status: AUDITED -- bug found and fixed (missing whitespace-skip calls).

## 1. Integer width at assignment sites
None.

## 2. Division / modulo
Not found.

## 3. char ** pointer parameters
Yes -- one `Ptr` cursor (`p`) shared through the whole function and
handed down into `_insn_parse_gen_aux`, which continues advancing the
same cursor. Confirmed the same `Ptr` instance is passed through, not a
fresh one built from `.remaining()`.

## 4. goto statements
None.

## 5. char signedness
Low risk -- only `#`, `,`, `;` compared; all plain ASCII.

## 6. Argument evaluation order
No `(*p)++` used as a call argument. N/A.

## 7. Integer promotion
N/A -- no arithmetic on fixed-width values in this function.

## 8. Bitwise complement
Not found.

## 9. Register lookup advancement
N/A.

## Interaction risks identified
The C source calls `lwasm_skip_to_next_token(l, p)` **twice**:
  1. right after `lwasm_save_expr(l, 100, s)`, before checking for `,`/`;`
  2. right after advancing past the comma, before calling
     `insn_parse_gen_aux`

Both calls were missing from `existing.py`. `lwasm_skip_to_next_token` is
a no-op unless `PRAGMA_NEWSOURCE` is active (see `lwasm.c`), so this bug
is silent under the default/compatibility source format -- it only
surfaces for source written under `pragma newsource` with whitespace
around the comma (e.g. `AIM #$0F , $20`). Confirmed against a from-source
build of lwasm 4.24 that real lwasm accepts this whitespace under
`pragma newsource` and produces `02 0F 20`; confirmed `existing.py`
(before this fix) raised a spurious `E_OPERAND_BAD` on the same input via
a direct, isolated call to the function (bypassing the rest of the
pipeline -- see note below on why).

Same bug class, in the same instruction family, as the one found and
fixed in `insn_parse_bitbit` (translation_packages/13).

**Scope note on verification:** `PRAGMA_NEWSOURCE` cannot currently be
exercised through the *full* assembler pipeline in this codebase --
forcing the pragma on and running a complete source file through
`do_pass1`...`do_pass7` hangs. The reason is outside this function
entirely: `AsmState.parse_expr` branches to `lw_parse_expr` (the "full"
parser) instead of `lw_parse_expr_compact` when `PRAGMA_NEWSOURCE` is
set, and `lw_parse_expr` does not appear to be implemented anywhere in
`cocotools/` -- a pre-existing gap unrelated to `insn_parse_logicmem`.
This is a real finding worth flagging to whoever coordinates the
packages, but fixing it is out of scope for a single-function package.
Verification here was done with a small local stub harness that isolates
`insn_parse_logicmem` from that broader (incomplete) subsystem -- see
SUMMARY.md for the harness and its output.

## Mitigations applied
Added both missing `_skip_to_next_token(cl, p)` calls at the exact call
sites the C source has them (using the helper that already exists in
`insn_funcs.py` and is already used by the `insn_parse_bitbit` fix).
Verified via the isolated unit harness that:
  - default (non-NEWSOURCE) behavior is unchanged (no regression --
    whitespace before the comma still errors, exactly as before)
  - under NEWSOURCE, whitespace before and/or after the comma is now
    tolerated, matching real lwasm 4.24's actual behavior
