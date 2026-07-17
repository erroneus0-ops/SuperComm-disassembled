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
[ Fill in before translating ]

## Mitigations applied
[ Fill in during translation ]
