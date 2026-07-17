# Translation Brief: `insn_emit_indexed_aux`

## Your task

Produce a faithful Python translation of the C function `insn_emit_indexed_aux`.

**Translate this faithfully because a learner who cannot distinguish tool
errors from their own errors will incorrectly conclude they are wrong.**

This is a mechanical translation task. The output must match lwasm 4.24
behavior exactly -- same bytes, same errors, same internal state.

## The function

C source: `lwtools-4.24/lwasm/insn_indexed.c`
Python target: `cocotools/insn_funcs.py`
Size: 64 lines, 10 branches, 0 gotos

The C function is in `source.c`.
The current Python translation (if any) is in `existing.py`.

## FIRST ACTION -- before reading anything else

Run this bash_tool command block immediately. Do not use web_fetch for any repo files.
web_fetch cannot access this repository reliably. bash_tool can. Use bash_tool.

```bash
git clone https://github.com/erroneus0-ops/SuperComm-disassembled.git /tmp/supercomm && echo "READY"
```

lwasm 4.24 is pre-built at /tmp/supercomm/lwtools-4.24/lwasm/lwasm -- no build step needed.

Wait for READY before proceeding. All files are now in /tmp/supercomm/.
Do not use web_fetch to fetch any files from this repository. Use bash_tool to read them:
```bash
cat /tmp/supercomm/translation_packages/08_insn_emit_indexed_aux/source.c
cat /tmp/supercomm/translation_packages/08_insn_emit_indexed_aux/checklist.md
cat /tmp/supercomm/translation_packages/08_insn_emit_indexed_aux/existing.py
cat /tmp/supercomm/cocotools/TRANSLATION_GUIDE.md
cat /tmp/supercomm/cocotools/DATA_STRUCTURE_AUDIT.md
cat /tmp/supercomm/cocotools/c_compat.py
cat /tmp/supercomm/cocotools/insn_funcs.py
```

## Required reading (in order)

After cloning, read these files locally:

1. `translation_packages/08_insn_emit_indexed_aux/source.c` -- THE SPEC. THE TRUTH.
2. `translation_packages/08_insn_emit_indexed_aux/checklist.md` -- pre-filled risk analysis
3. `cocotools/TRANSLATION_GUIDE.md` -- full checklist and risk catalog
4. `cocotools/DATA_STRUCTURE_AUDIT.md` -- shared struct reference
5. `cocotools/c_compat.py` -- C compatibility primitives
6. `translation_packages/08_insn_emit_indexed_aux/existing.py` -- current translation (SUSPECT)
7. `cocotools/insn_funcs.py` -- full Python file containing the translation target

## Translation order (critical)

1. Read `source.c` -- understand the C function completely
2. Fill in checklist "Interaction risks" and "Mitigations applied" sections
3. Write the Python translation from the C -- independently, not from existing.py
4. Read `existing.py` -- compare your translation against the existing Python
   - Any difference is either a bug in existing.py OR a mistake in your translation
   - Investigate each difference. Do not assume existing.py is correct.
   - existing.py is SUSPECT. The C is the truth.
5. Run the harness:
   ```bash
   cd /tmp/supercomm && python cocotools/test_fidelity.py
   ```
6. Fix until all tests pass. Add 3+ new tests for this function.

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
1. Run `python cocotools/test_fidelity.py` -- all existing tests must pass
2. Add 3+ new test cases covering branches in this function
3. Run `-v` to inspect structural state for new tests

Do not modify existing tests to make them pass.
Fix the translation until the tests pass.

## Deliverables (required at end of session)

When all tests pass, produce the following and present for download:

1. **SUMMARY.md** -- document containing:
   - What you read and in what order
   - Pre-translation checklist completed (all 9 categories filled in)
   - Every divergence found between existing.py and the C source
   - For each divergence: was it a bug in existing.py or correct behavior? Why?
   - Every bug fixed with: C code, old Python, new Python, verification method
   - New test cases added and what they cover
   - Final test counts (X passed, 0 failed)

2. **Updated files** -- any cocotools/*.py files that were changed

3. **Updated package files** -- checklist.md and existing.py updated to reflect
   current state of the translation

Package all of the above into a zip file named `insn_emit_indexed_aux_audit.zip`
and present it for download. This zip will be placed in the
`translation_packages/08_insn_emit_indexed_aux/` directory for review.

## Reference

C source (from repo tarball): https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/lwtools-4.24/lwasm/insn_indexed.c
Repository: https://github.com/erroneus0-ops/SuperComm-disassembled
TRANSLATION_GUIDE: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/TRANSLATION_GUIDE.md
DATA_STRUCTURE_AUDIT: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/DATA_STRUCTURE_AUDIT.md
c_compat.py: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/c_compat.py
source.c: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/08_insn_emit_indexed_aux/source.c
checklist.md: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/08_insn_emit_indexed_aux/checklist.md
existing.py: https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/08_insn_emit_indexed_aux/existing.py
