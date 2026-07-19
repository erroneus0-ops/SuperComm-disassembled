# Pre-Translation Checklist: `lw_expr_simplify_l`

Metrics: 576 lines, 117 branches, 5 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  - `tr = ~(E -> operands -> p -> value) & 0xff;`

## 2. Division / modulo
**FOUND** -- use `c_trunc_div()` / `c_trunc_mod()` for signed operands.

## 3. char ** pointer parameters
Not found.

## 4. goto statements
  - `goto again;`
  - `goto again;`
  - `goto tryagainplus;`
  - `goto tryagaintimes;`
  - `goto again;`
Classify each: A=exit (return), B=shared code (helper fn), C=alternate parse (call fn).

## 5. char signedness
Low risk.

## 6. Argument evaluation order
Check for `(*p)++` in function argument position.
Python evaluates left-to-right -- verify this matches C behavior.

## 7. Integer promotion
Check compound expressions. Add mask only where C destination type truncates.

## 8. Bitwise complement
**FOUND** -- use `c_complement8(v)` for 8-bit, `c_uint16(~v)` for 16-bit.

## 9. Register lookup advancement
N/A.

## Character classification



## Interaction risks identified
[ Fill in before translating ]

## Mitigations applied
[ Fill in during translation ]
