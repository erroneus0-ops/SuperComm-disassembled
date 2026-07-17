# Pre-Translation Checklist: `insn_resolve_indexed_aux`

Metrics: 155 lines, 29 branches, 10 gotos

## 1. Integer width at assignment sites
Check every assignment destination type.
Bit mask operations found (may need `c_uint8` etc.):
  - `if (((v1 >> 8) & 0xff) == (l -> dpval & 0xff))`
  - `min = (min >> 8) & 0xff;`
  - `max = (max >> 8) & 0xff;`
  - `if ((l -> dpval & 0xff) < min || (l -> dpval & 0xff) > max)`
  - `if (min == max && (l -> dpval & 0xff) == min)`

## 2. Division / modulo
**FOUND** -- use `c_trunc_div()` / `c_trunc_mod()` for signed operands.

## 3. char ** pointer parameters
**FOUND** -- pass the same `Ptr` instance through all callers. Do NOT create new Ptr from `p.remaining()`.

## 4. goto statements
  - `goto out;`
  - `goto indexed;`
  - `goto indexed;`
  - `goto out;`
  - `goto out;`
  - `goto out;`
  - `goto out;`
  - `goto out;`
  - `goto out;`
  - `goto out;`
Classify each: A=exit (return), B=shared code (helper fn), C=alternate parse (call fn).

## 5. char signedness
Low risk -- check comparisons of `*p` > 127.

## 6. Argument evaluation order
Check for `(*p)++` in function argument position.
Python evaluates left-to-right -- verify this matches C behavior.

## 7. Integer promotion
Check compound expressions. Add mask only where C destination type truncates.

## 8. Bitwise complement
Not found.

## 9. Register lookup advancement
**Check** lookupreg2/3 calls share Ptr correctly.

## Character classification



## Interaction risks identified
[ Fill in before translating ]

## Mitigations applied
[ Fill in during translation ]
