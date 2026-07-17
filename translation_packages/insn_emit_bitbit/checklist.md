# Pre-Translation Checklist: `insn_emit_bitbit`

Metrics: 47 lines, 6 branches, 0 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  - `v1 = lw_expr_intval(e) & 0xFFFF;`

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
[ Fill in before translating ]

## Mitigations applied
[ Fill in during translation ]
