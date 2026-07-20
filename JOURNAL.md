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

---

## Project Arc (historical)

### Origins -- SuperComm Reverse Engineering

The project began as a reverse engineering effort on SuperComm v2.2, an
OS-9 Level II terminal/comms program. The goal was byte-perfect reassembly.
A 6809 assembly language book was a secondary goal.

The project continuity file was called CLAUDE_CONTEXT.md -- a pragmatic
name for a pragmatic document. It was renamed CLAUDE_MANIFESTO.md when
the document grew into something more intentional -- a philosophy document,
not just context.

Key early milestones:
- SuperComm v2.2: byte-perfect reassembly achieved. Proved basic OS-9
  module handling. OS-9's rigid structure made it an easier target.
- dir (NitrOS-9): analysis started, revealed instruction coverage gaps,
  stalled as the book became the stronger learning vehicle.
- flames.bin (Paul Cunningham's CoCo Forth): exposed the complete absence
  of sync/scan architecture. Led to sync-acquisition scan implementation.

### The Reframe -- Learning Engine

At some point the project was explicitly reframed: not a SuperComm
disassembly project that also has a book, but a learning engine where the
tools exist because building them requires understanding 6809 assembly at
a level that reading about it doesn't produce.

The disassembled binaries became homework problems, not deliverables.
The actual deliverables: dis6x09.py, cocotools, the book, the XRoar
WASM page.

### The Book

Six chapters planned. Two complete drafts (ch01, ch02). Ch03 started.

Ch01: Humble Beginnings -- BASIC type-in listing, assembly introduced
Ch02: The Six Concepts -- complete HELLO.ASM revealed section by section
Ch03: The Number Guessing Game -- incremental build from BASIC to assembly
Ch04: Compare and Branch -- CC register deep dive (pending)
Ch05-07: planned

The COMTRAN TEN story anchors Ch03 -- Daniel's personal account of
hand-translating mnemonics to hex for an unfamiliar machine in the early
1980s. A guess-the-number program reconstructed from memory by the 09
Claude instance during the lwasm audit series.

### The XRoar WASM Page

Built as a browser-based CoCo emulator. CM-8 monitor bezel overlay
designed as SVG (hand-crafted TANDY label, skewY transform for perspective).
Size slider, log panel, DECB binary header parser added.

The FIRQ/RTS cart entry mechanism documented through direct testing --
a significant finding that corrects common misunderstanding about cartridge
ROM behavior.

### cocotools -- The Python Assembler

Built as a self-contained Python replacement for lwasm + toolshed + decb.
Goal: learners need only Python, no platform-specific binaries.

The lwasm translation audit series: 16 packages, 14 Claude instances,
July 16-18 2026. 296 tests. 20+ bugs found and fixed. See July 20 2026
entry for the architectural conclusion.

### On Continuity

The project ran across many Claude sessions. Each instance arrived fresh.
The CLAUDE_MANIFESTO.md carried forward everything that would otherwise
be relearned. The git history carries the detailed record. This journal
carries the arc and the decisions.

The instances that contributed most are named in commit messages and
package SUMMARY.md files. Their work persists even though they don't.

---

## Entries to add (pending)

- The CC_CLOBBERING_LOADS shadowing bug (package 06)
- The 0,X vs ,X self-modifying code insight
- Stack blasting concept note
- COMTRAN TEN reconstruction (package 09 Claude)
- The trusted binary memo (package 09 Claude, two drafts)
- lwtools 4.25 delta analysis
- The Terminator sessions and j-space navigation

---

## July 20 2026 -- The Validation Inversion

The fidelity harness was built to validate the Python translation against
native lwasm binary output. 296 tests, verified byte-for-byte.

With lwasm WASM available, the validation chain becomes:

    C source (William Astle, lwtools.ca)
        ↓ emcc (Emscripten, GitHub Actions, auditable)
    lwasm.wasm
        ↓ test harness (296 tests)
    Python translation (cocotools/)

Every link is visible. Nothing is opaque. No binary trust questions.

When William releases a new version:
1. Update source in repo
2. Trigger GitHub Actions -- new lwasm.wasm built and committed
3. Run test harness against new WASM
4. Any Python function that diverges from new WASM is flagged automatically
5. Fix or accept -- documented decision either way

The Python translation goes from "validated once" to "continuously
validated against the current WASM build."

The 296 tests don't retire. They become the continuous validation bridge
between the WASM ground truth and the Python reference implementation.

---

## July 20 2026 -- The Validation Inversion

The fidelity harness was built to validate the Python translation against
native lwasm binary output. 296 tests, verified byte-for-byte.

With lwasm WASM available, the validation chain becomes:

    C source (William Astle, lwtools.ca)
        ↓ emcc (Emscripten, GitHub Actions, auditable)
    lwasm.wasm
        ↓ test harness (296 tests)
    Python translation (cocotools/)

Every link is visible. Nothing is opaque. No binary trust questions.

When William releases a new version:
1. Update source in repo
2. Trigger GitHub Actions -- new lwasm.wasm built and committed
3. Run test harness against new WASM
4. Any Python function that diverges from new WASM is flagged automatically
5. Fix or accept -- documented decision either way

The Python translation goes from "validated once" to "continuously
validated against the current WASM build."

The 296 tests don't retire. They become the continuous validation bridge
between the WASM ground truth and the Python reference implementation.
