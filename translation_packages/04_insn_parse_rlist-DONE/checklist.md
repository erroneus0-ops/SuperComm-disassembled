# Pre-Translation Checklist: `insn_parse_rlist`

Metrics: 62 lines, 12 branches, 0 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  None. `rb`, `rn` are plain `int` accumulating small values (max 0xFF
  after all register bits are OR'd in); no C fixed-width type is ever
  assigned, so no `c_uint8`/`c_uint16` mitigation is needed.

## 2. Division / modulo
**CORRECTED -- NOT FOUND.** The pre-filled checklist claimed this was
found, but a grep of `source.c` for `/` and `%` turns up zero division
or modulo operators. The only `%` occurrences are `"%s"` format-string
specifiers inside `lwasm_register_error2(...)` calls, not the modulo
operator. `c_trunc_div`/`c_trunc_mod` are not needed by this function.
(This looks like a copy-paste artifact from another function's
checklist -- worth double-checking pre-filled checklists in general
rather than trusting them at face value.)

## 3. char ** pointer parameters
**CORRECTED -- FOUND, and this is where the real bug was.**
The function itself receives `char **p` (the macro-expanded
`PARSEFUNC` signature). Two sub-calls matter:

- `insn_parse_imm8(as, l, p)` in the `#` branch -- receives the SAME
  `p`, so C advances the caller's cursor through this call by side
  effect. The Python translation must thread the same `Ptr` (or, since
  `insn_parse_imm8`'s Python signature takes a string and returns the
  new remainder, thread its *return value*) back out to the caller.
  The existing translation created its own `Ptr(operand)` inside
  `insn_parse_imm8`, called it, threw away the returned remainder, and
  returned the outer (unadvanced) `p.remaining()` instead. This broke
  aliasing exactly as warned against in TRANSLATION_GUIDE.md #3 ("Never
  create a new `Ptr` from `p.remaining()` and pass that").
- `lwasm_lookupreg2(regs, p)` -- receives the same `p` used by the
  rest of the function; the existing translation passes the same `Ptr`
  instance throughout the `while` loop, which is correct.

## 4. goto statements
  None.
Classify each: A=exit (return), B=shared code (helper fn), C=alternate parse (call fn).
N/A -- no gotos present.

## 5. char signedness
Low risk. All comparisons are against ASCII punctuation/whitespace
characters (`'#'`, `';'`, `'*'`, `','`) well within the 0-127 range, so
signed-vs-unsigned `char` never matters here.

## 6. Argument evaluation order
Checked for `(*p)++` in function argument position: none found.
`(*p)++` appears only as a bare statement (`(*p)++;`), never nested
inside a function call's argument list, so Python's left-to-right
evaluation order can't diverge from C here.

## 7. Integer promotion
Checked compound expressions: `rb |= rn`, `1 << rn`, literal `0x40`.
All intermediate values fit comfortably in Python's unbounded int and
are never assigned back into a C fixed-width destination in this
function (`l->pb` is a plain C `int` per the struct audit, not a
fixed-width type) -- no masking needed.

## 8. Bitwise complement
Not found. No `~` operator anywhere in this function.

## 9. Register lookup advancement
`lwasm_lookupreg2(regs, p)` advances `p` past the matched register
name as a side effect (0, 1, or 2 characters depending on match).
The Python translation (`AsmState.lookupreg2`) reproduces this by
mutating the same `Ptr` instance in place -- verified correct by
direct inspection of `lwasm_lookupreg2` in `lwasm.c` against
`AsmState.lookupreg2` in `lwasm_core.py`; both advance by the same
rule (`regs[1]==' '` and next char not alpha => advance 1, else
advance 2 when the two-char match succeeds).

## Character classification

`isspace` found -- use `c_isspace(c)`. (Note: the existing translation
uses Python's `str.isspace()` directly at the two `while` guard sites
instead of `c_isspace()`. This is a difference in *style*, not
behavior -- verified no divergence: `c_isspace` only recognizes ASCII
space/tab/CR/LF/FF/VT, and `str.isspace()` agrees with C's `isspace()`
for every character actually reachable here (7-bit assembly source).
Left as-is since it isn't a behavioral bug, but noting it for anyone
doing a stricter style pass later.)

## Interaction risks identified

1. **Cursor aliasing through the `'#'` immediate branch** (see #3
   above) -- the only interaction risk with real behavioral impact.
   `insn_parse_rlist` shares its cursor with `insn_parse_imm8` in the
   C source; the Python translation must preserve that sharing by
   returning `insn_parse_imm8`'s result, not recomputing its own
   (stale) remainder.
2. Downstream consumer (`cocotools/pass1.py`) uses the parse
   function's *return value* as the authoritative post-parse cursor
   position to decide whether to raise `E_OPERAND_BAD` for leftover
   operand text. Any function in this family that discards or
   miscomputes its return value will produce spurious "Bad operand"
   errors on otherwise-valid source lines, or (worse, in a different
   function shape) silently accept invalid trailing text.

## Mitigations applied

- Changed the `'#'` branch to capture and return `insn_parse_imm8`'s
  return value instead of the outer (unadvanced) `p.remaining()`.
- No other mitigations were necessary -- the register-list loop,
  bit-mapping table, and U/S exclusivity checks were already faithful
  to the C source.
