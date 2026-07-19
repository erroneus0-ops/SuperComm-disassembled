# Pre-Translation Checklist: `insn_emit_bitbit`

Metrics: 47 lines, 6 branches, 0 gotos
Status: AUDITED -- no divergence found, existing.py confirmed faithful.

## 1. Integer width at assignment sites
Bit mask found: `v1 = lw_expr_intval(e) & 0xFFFF;`
AND with a positive mask (0xFFFF) is a known-safe pattern -- Python's `&`
on a negative int agrees with C's two's-complement AND in the low bits,
so no wraparound bug here. The existing translation renames this local
to `vv` (and the subsequent `v2` to `diff`) purely to avoid re-using the
bit-number variable names from earlier in the function; no behavioral
difference from the C.

## 2. Division / modulo
Not found.

## 3. char ** pointer parameters
Not found (emit function; no operand parsing).

## 4. goto statements
None.

## 5. char signedness
N/A -- no character comparisons in this function.

## 6. Argument evaluation order
N/A -- no `(*p)++` in argument position.

## 7. Integer promotion
`l->pb = (l->lint << 6) | (v1 << 3) | v2` -- lint in {0,1,2}, v1/v2 in
0-7 (or 0 when invalid), so pb tops out at 0xC3. Fits comfortably in an
`int` in C and needs no masking in Python either. Matches the "postbyte
OR operations stay within 8 bits by construction" known-safe pattern.

## 8. Bitwise complement
Not found.

## 9. Register lookup advancement
N/A.

## Interaction risks identified
`lwasm_fetch_expr` (C) can return NULL when the requested expr id was
never saved. C's `lw_expr_istype(NULL, lw_expr_type_int)` is explicitly
null-safe (returns 0 -- see lw_expr.c line 63-71: "NULL expression is
never of any type"). Python's `e.istype(...)` is an ordinary instance
method with no such guard: calling it on `None` raises `AttributeError`,
which is a *new* failure mode C never has at this call site. A literal
line-by-line translation (`if not e.istype(TYPE_INT):`) would crash on
any line where an expr id was never populated, instead of registering
the expected E_BITNUMBER_UNRESOLVED/E_BITNUMBER_INVALID error and
continuing like the reference implementation does.

## Mitigations applied
Guarded all three `fetch_expr` results with `e and e.istype(...)`
(ids 0, 1, and 2) rather than calling `.istype()` unconditionally. This
reproduces C's null-safe `lw_expr_istype` behavior exactly using Python's
short-circuit `and`, with no change to which branch is taken versus a
non-NULL expr (since a real `Expr` object is always truthy).

## Verification
Built lwasm 4.24 from its own published source tarball (not the
repo's precompiled binary) and ran the fidelity harness plus 6 new
behavioral test cases covering all six bitbit mnemonics and all three
error branches (invalid bit number, byte overflow, unresolved
bit-number expression). All match lwasm byte-for-byte / error-for-error.
See SUMMARY.md for full detail.
