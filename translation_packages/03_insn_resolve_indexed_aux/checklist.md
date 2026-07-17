# Pre-Translation Checklist: `insn_resolve_indexed_aux`

Metrics: 271 lines, 56 branches, 1 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  - `if (v == 0 && !CURPRAGMA(l, PRAGMA_NOINDEX0TONONE) && (l -> pb & 0x07) <= 4)`
  - `if ((l -> pb & 0x07) < 4)`
  - `pb = 0x84 | ((l -> pb & 0x03) << 5) | ((l -> pb & 0x80) ? 0x10 : 0);`
  - `pb = (l -> pb & 0x80) ? 0x90 : 0x8F;`
  - `switch (l -> pb & 0x07)`
  - `pb = 0x89 | ((l -> pb & 0x03) << 5) | ((l -> pb & 0x80) ? 0x10 : 0);`

## 2. Division / modulo
Not found.

## 3. char ** pointer parameters
Not found.

## 4. goto statements
  - `goto do16bit;`
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

1. **Shared postbyte bit layout with insn_parse_indexed_aux.** This
   function decodes `l->pb` (regfield = bits 0-2, indirect = bit 7,
   f0/"explicit zero offset" flag = bit 6) exactly as written by the
   parse-side function (package 02). If either side's bit layout ever
   changes, the other must change with it -- confirmed this is already
   documented in insn_funcs.py's header comment for this function and
   is consistent as of this audit.

2. **Cross-file, cross-pass state: `l->lint == -1` as a "not yet
   decided" latch.** This function is only ever invoked by
   `insn_resolve_indexed` (the RESOLVEFUNC wrapper, same file) when
   `l->lint == -1`, and that wrapper never calls it again once `l->lint`
   has been set to anything else. That means whatever this function
   decides on its *first* successful call (whether because the operand
   was already a constant, or because `force=1` compelled a decision
   before the value was known) is final for the rest of assembly. This
   function's own logic is correct in isolation, but its correctness in
   practice depends entirely on the surrounding driver calling it with
   the right `force` value at the right time.

3. **`PRAGMA_FORWARDREFMAX` default -- found to be missing, now fixed.**
   Real lwasm (`main.c`) turns this pragma on by default before CLI
   parsing, specifically so that pass 1 forces indexed (and other
   gen-mode) operands with not-yet-resolvable values to lock into their
   worst-case (16-bit) encoding immediately, via `force=1`, rather than
   waiting for a later pass to discover the true value and picking a
   smaller encoding. `cocotools/lwasm_core.py`'s `AsmState.__init__` set
   `self.pragmas = PRAGMA_6809` only, omitting this bit. The plumbing to
   *act* on the pragma (`cocotools/pass1.py`, force=1 call) already
   existed and was correct -- only the default flag was missing. This
   is not a bug in `insn_resolve_indexed_aux` itself, but it is the
   dominant real-world interaction this function has with the rest of
   the assembler, and the missing default made every forward-referenced
   indexed operand resolve to a smaller-than-lwasm's encoding. Fixed as
   part of this audit; see SUMMARY.md for full detail and verification.

## Mitigations applied

- No mitigation needed inside `_insn_resolve_indexed_aux` itself --
  line-by-line comparison against `source.c` found the existing
  translation (dated 2026-07-17, written as glue for package 02) to
  already be a faithful, branch-for-branch match, including the
  asymmetric `f0` check (present in the final `e`-is-int branch's
  zero-offset condition, absent in the speculative `e2`-is-int branch's
  zero-offset condition -- this asymmetry exists in the C and is
  preserved correctly).
- Added `PRAGMA_FORWARDREFMAX` to `AsmState.__init__`'s default pragma
  set (`cocotools/lwasm_core.py`) to match real lwasm's default.
- Added 5 new regression tests (4 in `BEHAVIOR_TESTS`, 1 in
  `BEHAVIOR_TESTS_6309`) specifically designed so that "resolved to
  worst-case size at the moment the value was unknown" and "resolved to
  minimal size once the value became known" produce different bytes --
  the pre-existing `indexed-fwdref-16bit` test could not distinguish
  these because its forward-referenced value genuinely needs 16 bits
  either way.
