# Translation Brief: `lw_expr_simplify_l`

## Your task

Produce a faithful Python translation of the C function `lw_expr_simplify_l`.

**Translate this faithfully because a learner who cannot distinguish tool
errors from their own errors will incorrectly conclude they are wrong.**

This is a mechanical translation task. The output must match lwasm 4.24
behavior exactly -- same bytes, same errors, same internal state.

## The function

C source: `lwtools-4.24/lwlib/lw_expr.c`
Python target: `cocotools/lw_expr.py`
Size: 576 lines, 117 branches, 5 gotos

The C function is in `source.c`.
The current Python translation (if any) is in `existing.py`.

## Required reading (in order)

1. `source.c` -- the C function. This is the spec. This is the truth.
2. `checklist.md` -- pre-filled risk analysis. Complete before writing Python.
3. `cocotools/TRANSLATION_GUIDE.md` -- full checklist and risk catalog
4. `cocotools/DATA_STRUCTURE_AUDIT.md` -- shared struct reference
5. `cocotools/c_compat.py` -- C compatibility primitives

## Translation order (critical)

1. Read `source.c` -- understand the C function completely
2. Fill in checklist "Interaction risks" and "Mitigations applied" sections
3. Write the Python translation from the C -- independently, not from existing.py
4. Read `existing.py` -- compare your translation against it
   - Any difference is either a bug in existing.py OR a mistake in your translation
   - Investigate each difference. Do not assume existing.py is correct.
   - existing.py is SUSPECT. The C is the truth.
5. Run the harness -- `python cocotools/test_fidelity.py`
6. Fix until all 211 tests pass. Add 3+ new tests for this function.

## Compat primitives

```python
from cocotools.c_compat import (
    c_uint8, c_int8, c_uint16, c_int16,
    c_5bit, c_complement8,
    c_trunc_div, c_trunc_mod,
    c_isspace, c_toupper,
    Ptr,
)
```

## Verification

After translating:
1. Run `python cocotools/test_fidelity.py` -- all 211 tests must pass
2. Add 3+ new test cases covering branches in this function
3. Run `-v` to inspect structural state for new tests

Do not modify existing tests to make them pass.
Fix the translation until the tests pass.

## Reference

C source (from repo tarball): https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/lwtools-4.24/lwlib/lw_expr.c
Repository: https://github.com/erroneus0-ops/SuperComm-disassembled
TRANSLATION_GUIDE: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/TRANSLATION_GUIDE.md
DATA_STRUCTURE_AUDIT: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/DATA_STRUCTURE_AUDIT.md
c_compat.py: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/c_compat.py
source.c: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/01_lw_expr_simplify_l/source.c
checklist.md: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/01_lw_expr_simplify_l/checklist.md
existing.py: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/01_lw_expr_simplify_l/existing.py
