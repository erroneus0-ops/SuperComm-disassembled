# Translation Delta Brief: lwtools 4.24 → 4.25

## Why this project exists

Learners cannot distinguish between errors in their own assembly code and
errors in the tools they use -- and will blame themselves when the tools
are wrong. The Python cocotools assembler must match lwasm behavior exactly
for this reason. A learner who writes correct 6809 assembly and gets wrong
output will conclude they don't understand the instruction set. That is the
failure mode this project exists to prevent.

## Your task

Compare the 4.24 and 4.25 versions of the C source files provided and:

1. Identify every behavioral difference between the two versions
2. Explain what each change does and why it matters
3. Produce updated Python for any affected functions in cocotools
4. Flag anything uncertain for discussion

This is a text comparison task. No compilation. No execution. No binaries.
You are reading two versions of C source and writing Python.

## The files

Two directories are provided alongside this brief:

- `4.24/` -- lwtools 4.24 source (the version cocotools was translated from)
- `4.25/` -- lwtools 4.25 source (the current release, July 18 2026)

Files present:
- `insn_indexed.c` -- indexed addressing mode parser/resolver/emitter
- `insn_gen.c` -- general addressing mode handling
- `lw_expr.c` -- expression parser and simplifier
- `lwasm.h` -- assembler type definitions, error/warning codes
- `lw_expr.h` -- expression type definitions

Fetch them using web_fetch from these raw GitHub URLs:

4.24 versions:
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.24/insn_indexed.c
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.24/insn_gen.c
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.24/lw_expr.c
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.24/lwasm.h
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.24/lw_expr.h

4.25 versions:
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.25/insn_indexed.c
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.25/insn_gen.c
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.25/lw_expr.c
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.25/lwasm.h
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/translation_packages/4.25_delta/4.25/lw_expr.h

Note: ignore date changes in file headers. William does not update them
on every release. They are not meaningful for this comparison.

## What we already know

From prior analysis:

1. `insn_indexed.c` (+26 bytes): one line changed in the PCR section --
   `l -> addr` became `l -> phase ? l -> phase : l -> addr`
   This adds phase/assume directive support to PCR addressing.
   The corresponding Python function is `insn_parse_indexed_aux` in
   `cocotools/insn_funcs.py`.

2. `lw_expr.c` (+significant): shift operators `<<` and `>>` added.
   These were not supported in 4.24. The corresponding Python is
   `lw_expr_parse_expr` in `cocotools/lw_expr.py`. This is a known
   gap -- the function needs updating.

3. `insn_gen.c` (+35 bytes): unknown change. Investigate.

4. `lwasm.h` (+572 bytes): likely new error/warning codes and possibly
   new pragma flags. Check for anything relevant to our translations.

## The Python codebase

The relevant Python files are in cocotools/:
- `insn_funcs.py` -- translations of insn_indexed.c, insn_gen.c
- `lw_expr.py` -- translation of lw_expr.c
- `c_compat.py` -- C compatibility primitives

Fetch them here:
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/insn_funcs.py
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/lw_expr.py
- https://raw.githubusercontent.com/erroneus0-ops/SuperComm-disassembled/main/cocotools/c_compat.py

## Process

1. Fetch all files via web_fetch
2. Compare 4.24 vs 4.25 for each C file -- identify every difference
3. For each difference: explain what changed and what it means
4. Identify the corresponding Python function(s)
5. Produce updated Python that matches 4.25 behavior
6. Document everything in SUMMARY.md

## Deliverables

Package as a zip containing:
- `SUMMARY.md` -- all differences found, explained, with disposition
- Updated Python files (only files that actually changed)
- Any questions or observations for the project maintainer

A full Q&A session follows delivery -- questions about the project,
the 6809, lwasm behavior, or anything else observed are welcome.
The maintainer knows this codebase well and will answer directly.

## Repository

https://github.com/erroneus0-ops/SuperComm-disassembled
