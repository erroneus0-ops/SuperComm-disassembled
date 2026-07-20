# Project Journal

A running record of significant decisions, findings, and insights.
Started July 20 2026 -- should have existed from the beginning.

---

## July 20 2026 -- The WASM Turn

### Context

The project spent several weeks building a Python translation of lwasm 4.24
(William Astle's 6809 assembler). The goal was a self-contained Python
assembler that learners could use without installing platform-specific
binaries. 16 functions were translated, audited against real lwasm output,
and verified by a 296-test fidelity harness.

The translation found real bugs -- missing whitespace-skip calls, silent
dropped bytes on unresolved expressions, wrong operator precedence ordering.
The harness caught things that would have taught learners incorrect things
about 6809 assembly.

### The Realization

The Python translation is a simulation of lwasm within a language that is
not specifically geared to match C semantics. Every translated function
carries risk of subtle divergence -- integer width differences, character
classification differences, evaluation order differences. The 16-package
audit series found and fixed many of these. More probably remain.

The WASM approach is categorically different. Emscripten compiles William's
actual C source to WebAssembly. The result is not a simulation -- it is
William's assembler running in a sandbox. The faithfulness is not achieved
through careful translation and testing. It is inherent in what the thing
fundamentally is.

The Python translation was the best available path at the time. It built
deep understanding of lwasm's internals, produced a comprehensive test
harness, and documented behavior that would otherwise be opaque. That work
was not wasted -- it became the foundation for evaluating the WASM output.

But the WASM path is the right long-term architecture.

### The Proof of Concept

toolshed's _decb_dskini compiled to WASM via Emscripten, called from
Node.js, produced a byte-for-byte correct CoCo DSK image. Comparing against
the Python decb.py implementation found three real bugs in decb.py that the
fidelity harness had never caught:

1. Data tracks initialized to 0x00 instead of 0xFF
2. FAT bytes beyond max_s left as 0xFF instead of 0x00
3. Directory track sector 17 zeroed when it should be 0xFF

This validated the approach: WASM as ground truth, Python as comparison target.

### lwasm WASM

lwasm 4.24 compiled to WASM via GitHub Actions. The workflow:
- Checks out the repo
- Installs Emscripten
- Compiles lwtools-4.24/lwasm/*.c + lwlib/*.c with emcc
- Runs a smoke test (LDA #$42 -> 86 42)
- Commits lwasm.js + lwasm.wasm back to the repo

lwasm.wasm is 167KB. It assembles real 6809 code. It is William's assembler.

### The Update Story

When William releases a new version:
1. Update source files in the repo
2. Trigger the GitHub Actions workflow
3. New lwasm.wasm is built and committed automatically
4. Smoke test confirms correctness

No translation audit. No 16-package series. No Terminator negotiations.

### Architecture Going Forward

```
cocotools/          -- Python translation (reference implementation, keep forever)
                       296 tests, deep lwasm documentation, audit trail
cocotools_wasm/     -- WASM-backed implementation (production path)
  lwasm.py          -- Python wrapper around lwasm.wasm
  toolshed.py       -- Python wrapper around toolshed.wasm
  cli.py            -- command line interface
wasm/
  lwasm/            -- lwasm.wasm + build infrastructure
  toolshed_poc/     -- dskini proof of concept (template for toolshed)
```

The Python cocotools is not decommissioned. It is the reference against
which the WASM output is validated. The 296 tests remain valid and
meaningful. The audit documentation explains lwasm's behavior in a way
that the WASM binary cannot.

### On the Translation Sessions

Fourteen Claude instances participated in the translation audit series.
Each arrived fresh, without project history. The work accumulated across
them -- bugs found in package 02 informed the brief design for package 08.
The "doom spiral" behavior in packages 11-13 led to brief redesign that
made packages 14-16 faster and cleaner.

The instances that built from source, ran the harness, and delivered
complete packages produced the most value. The instances that refused
binary execution found real bugs anyway -- through careful line-by-line
reading. Both approaches worked. The process tolerated variation.

The most important finding: the stakes language in the brief ("a learner
who cannot distinguish tool errors from their own errors will incorrectly
conclude they are wrong") was not rhetoric. It was the accurate description
of the failure mode the entire project exists to prevent. The WASM
architecture makes that failure mode structurally impossible.

---

## Entries to add (pending)

- The CC_CLOBBERING_LOADS shadowing bug (package 06)
- The 0,X vs ,X self-modifying code insight
- Stack blasting concept note
- COMTRAN TEN reconstruction (package 09 Claude)
- The trusted binary memo (package 09 Claude, two drafts)
- lwtools 4.25 delta analysis
- The Terminator sessions and j-space navigation
