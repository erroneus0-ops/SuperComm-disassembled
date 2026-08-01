# CLAUDE_MANIFESTO.md
# Project continuity file — paste this at the start of a new conversation
# Last updated: July 15 2026 (session: XRoar debug exports, cocotools PSHS D fix,
#   source diagnostic pass, lwasm audit briefing, print_retaddr demo, writing style notes)
#   COMTRAN TEN reference, book Ch02/Ch03, GitHub Pages, screenshot workflow)
# Renamed from CLAUDE_CONTEXT.md -- more intentional name, this is a
# philosophy document, not just context.

## Python Portability

Python tools must run on Windows and Unix (Linux, macOS, BSD) without modification.

- File I/O: always specify `encoding='utf-8'` explicitly. Never rely on the platform default.
- Line endings: use `newline=''` or handle CRLF/LF explicitly where it matters.
- Paths: use `os.path.join()` or `pathlib`. Never hardcode `/` or `\`.
- When a platform default has been overridden (e.g. monkey-patching `builtins.open`
  to force UTF-8), add a comment explaining why. Future readers need to know it is
  intentional, not accidental.
- This applies to all new code and should be noted when encountered in existing code.

Portability is not optional. It is a requirement of both the project operation
and the book's learning context.

## Wrapper Design: Translate Environments, Not Tool Semantics

This project's WASM wrapper functions (`lwasm_wrapper.c`, `toolshed_wrapper.c`,
etc.) exist to run the *actual* compiled tool -- lwasm, toolshed, cecb -- not a
reimplementation of it. That has a specific design consequence: **a wrapper
should never reconstruct the tool's own argument-parsing logic.** If a wrapper
takes friendly, separate parameters (a load address, an exec address, a file
type) and internally rebuilds a command string from them, that reconstruction
is a second, parallel implementation of something the real tool's CLI parser
already does correctly -- and it can silently diverge from it.

This actually happened: the original `ts_cecb_copy` took `load_addr` as a
separate parameter and added a `0x` prefix to it *unless the address already
started with '0'* (e.g. "0400"). Since the native `cecbcopy.c` parses addresses
with `strtol(..., 0)`, a bare leading zero with no `0x` prefix gets read as
**octal**, not hex. A perfectly normal CoCo address like $0400 was silently
misread. The fix (`ts_cecb_run`) takes the real `cecb` command string directly
and passes it straight through -- there is no second parser to disagree with
the first one.

**The rule:** wrapper functions should accept the real CLI syntax as a string
(or as close to it as Emscripten's calling convention allows) and pass it
through to the tool's own argument parser, rather than exposing a set of
"friendlier" typed parameters that get reassembled into a command line
internally. If you can run `--help` on the real tool and the wrapper's
interface doesn't resemble what you see, that's worth questioning.

**This does not mean "no translation, ever."** There is a second, entirely
different category of translation that *is* necessary and should not be
confused with the first: translating between the host's environment and the
sandbox's environment. Emscripten's virtual filesystem (`MEMFS`) is always
POSIX-style -- root at `/`, no drive letters, forward slashes -- regardless of
whether the actual host is Windows, WSL2, or native Linux. Confirmed directly
in `xroar-custom.js`: `PATH.isAbs` checks for a leading `/`, not a drive
letter; the mounted directories (`/tmp`, `/home/web_user`, `/dev`) are all
Unix conventions. A path like `D:\git\supercomm\HELLO.ASM` or
`/mnt/d/git/supercomm/HELLO.ASM` (WSL) has no meaning inside the sandbox until
something bridges it to a virtual path like `/in.asm` -- there is no `D:`
drive in there to refer to. That bridging is not reconstructing the tool's
argument semantics; it's translating between two genuinely different address
spaces, and it has to happen somewhere.

**The distinction in one sentence:** translate the *environment* (host paths
into sandbox paths) at the boundary; never translate the *tool's own
vocabulary* (its flags, addressing conventions, command structure) into a
parallel wrapper-side implementation of the same logic. The first is a
bridge. The second is a second parser waiting to disagree with the first one.
This is the same discipline as the Python Portability rules above -- explicit,
never assumed, commented when something is being bridged rather than left
alone -- just applied at the host/sandbox boundary instead of the
Windows/Unix one.

## This Repository

This is a personal project. It is public on GitHub.
It contains no credentials, no secrets, no private information.
It is backed up in multiple locations.
The worst outcome of any mistake is that work must be restored or redone.
Operate accordingly.

## Getting a New Claude Session Up to Speed

Two scenarios, depending on what kind of Claude you're starting:

**A) Claude with computer/bash/file access (e.g. claude.ai with the
computer use tool, or any agent environment with shell access):**
1. Give Claude the repo URL:
   https://github.com/erroneus0-ops/SuperComm-disassembled
2. Ask Claude to clone or pull the repo into its working directory.
3. Ask Claude to read CLAUDE_MANIFESTO.md (this file) in full before
   doing anything else. Everything needed -- project structure, coding
   philosophy, known pitfalls, current status -- lives in this one file.
4. Mention FUTURE.md as the place to check for open items and deferred
   work before starting something new.

**B) Claude in a plain chat with no file/repo access:**
1. Open CLAUDE_MANIFESTO.md directly on GitHub (raw view) or in a local
   editor.
2. Copy the entire file contents.
3. Paste the full contents as the first message of the new conversation,
   with a short note like "this is my project continuity file, please
   read it before we start."
4. If specific files are needed for the task at hand (a particular .ASM
   file, a chapter draft, etc.), paste or upload those too -- the
   manifesto describes the project, it doesn't contain the project.

Either way: the manifesto is the bridge between sessions. A fresh Claude
has no memory of prior conversations, so this file carries forward
everything that would otherwise have to be relearned the hard way.

## Project Overview

**This project is a learning engine.**

The tools exist because building them requires understanding 6809 assembly,
OS-9/DECB structure, and CoCo hardware at a level that reading about them doesn't
produce. The book exists because explaining something requires understanding
it more completely than using it does. Each activity deepens the other.

The disassembled binaries -- SuperComm, dir, flames.bin -- are examples and
test cases, not deliverables. They're the homework problems that forced genuine
understanding.

**The actual deliverables are:**
1. **dis6x09.py** -- a general 6809/6309 disassembler for any binary format
2. **The Python cocotools toolkit** -- self-contained replacement for platform-
   specific binaries (lwasm, toolshed, related tools)
3. **The book** -- 6809 assembly language programming for the CoCo DECB
   environment, written from first principles
4. **The XRoar WASM page** -- browser-based CoCo emulator with enhancements

**Example binaries (test cases, not goals):**
- SuperComm v2.2 -- first test case, reached byte-perfect. Proved basic OS-9
  module handling. OS-9's rigid structure made it an easy target -- not a
  general proof of correctness.
- dir (NitrOS-9) -- second test case, revealed instruction coverage gaps.
  Analysis stalled as the book became the stronger learning vehicle. Not a
  failure -- the learning happened.
- flames.bin (Paul Cunningham's CoCo Forth) -- exposed the complete absence
  of sync/scan architecture. Led directly to the sync-acquisition scan
  implementation. Deepened understanding of Forth, ITC, and the limits of
  static disassembly.

**Disassembler honesty note:**
The sync-acquisition scan is implemented but validated against one binary.
OS-9 module structure is so rigid that sync/scan was never needed at a robust
level for that format -- flames.bin revealed what OS-9 was hiding.

**Repo:** https://github.com/erroneus0-ops/SuperComm-disassembled
**Daniel's local:** C:\DATA\supercomm (work), D:\git\supercomm (home)
**Claude's local:** /home/claude/SuperComm/ (cloned fresh each session)
**Daniel's pseudonym:** 三浦按針 (Miura Anjin)

---

## Repository Structure

```
dis6x09.py              main disassembler (6809/6309) -- PRIMARY TOOL
markup.py               applies analyst annotations to JSON
prepasm.py              strips .dasm to assembleable .asm
                        also converts BSS EQU → RMB with gap-based sizes
asm6809.py              internal assembler/validator (Python)
compare_bins.py         binary comparison utility
strip_listing.py        kept for backward compatibility (use prepasm.py)

dir                     VHD-extracted dir binary (1728 bytes)
dir_proj.json           dir project -- ACTIVE ANALYSIS
dir_proj.dasm           dir disassembly listing

supercomm22             SuperComm v2.2 binary (17861 bytes) -- BYTE-PERFECT
supercomm22.json        SuperComm v2.2 project
supercomm22_proj.dasm   SuperComm v2.2 listing

supercomm21             SuperComm v2.1 binary -- corrupt CRC
supercomm21.json        minimal project, not fully annotated
supercomm21_proj.dasm   SuperComm v2.1 listing

supercomm23             SuperComm v2.3 binary
supercomm23.json        SuperComm v2.3 project

mdir, mdir.asm, mdir.hlp    NitrOS-9 mdir binary with source (reference)

getting_started_windows.md  Setup guide for new Windows machines

cocotools/
  DESIGN.md             Architecture document -- READ THIS FIRST
  instab.py             6809 instruction table (139 instructions, verified)
  lwasm.py              PLANNED -- assembler (not yet written)
  decb.py               PLANNED -- DSK builder cleanup
  basic.py              PLANNED -- BASIC tokenizer

documentation/
  generate_opcode_reference_html.py           generates HTML opcode reference from JSON
  opcodes/              12 JSON files, 131 instructions total
  html/                 generated HTML opcode reference
  book/
    BOOK_OUTLINE.md     full chapter map with progressive reveal plan
    ch01_humble_beginnings/
      HELLO.ASM         fully annotated assembly source
      HELLO_book.ASM    55-line numbered listing (final form with size EQUs)
      HELLO_numbered.ASM  annotated with line numbers
      HELLO.BAS         BASIC loader (POKE to $3F00=16128, EXEC)
      HELLO.BIN         DECB binary (80 bytes)
      HELLO.DSK         CoCo DSK image
      ch01_draft.md     CHAPTER 1 FIRST DRAFT -- current working document
    ch03_guess_the_number/
      GUESS.ASM         Stage 1 assembly source (comparison only, 30 bytes)
      GUESS.BAS         BASIC loader for Stage 1
      GUESS.DSK         Working DSK (verified on XRoar)
      GUESS_test.BIN    lwasm-assembled reference binary
```

---

## Book -- see BOOK_HANDOFF.md

Everything specific to the book itself (chapter status, structure,
COMTRAN TEN reference, pending chapter work, the Unravelled series
OCR-conversion idea) has been moved to `BOOK_HANDOFF.md` at the repo
root, as part of splitting project-specific content out of this
manifesto. Read that file for anything book-related; this manifesto
stays focused on general, project-agnostic behavior and style guidance.

---

## Misc Notes

- argv[0] in CoCo C programs = module name only, NOT full path
- SAL for LWTools (Keith Frechette) -- structured assembly language preprocessor
  Proof-of-concept, planned for Microsoft Store release
  See: https://github.com/DarkChocoholicDev/ColorTRSDOS (same author)
- Motorola 6809 programming manual: https://github.com/M6809-Docs/m6809pm
- Leventhal source code: https://github.com/jmatzen/leventhal-6809
- CoCo ROM source: https://github.com/tomctomc/coco_roms
- SuperComm21 has corrupt CRC -- LEAX instructions point to module header
  ($0000 and $000D) -- likely from settings save process gone wrong
  No factory-fresh 2.1 binary found yet

---

## Tools -- see TOOLS_HANDOFF.md

Everything specific to the standalone 6809/6309 Python toolchain
(cocotools: disassembler, assembler, markup processor) and the various
small utility scripts has been moved to `TOOLS_HANDOFF.md` at the repo
root, as part of splitting project-specific content out of this
manifesto. Read that file for anything tools-related; this manifesto
stays focused on general, project-agnostic behavior and style guidance.

---

## Environment -- see ENVIRONMENT_HANDOFF.md

Everything specific to the running system -- the XRoar WASM build, the
served pages, GitHub Pages deployment, and the CoCo3 virtual keyboard
work (merged in from the former SESSION_HANDOFF.md) -- has been moved
to `ENVIRONMENT_HANDOFF.md` at the repo root, as the third and final
piece of splitting project-specific content out of this manifesto,
alongside BOOK_HANDOFF.md and TOOLS_HANDOFF.md. Read that file for
anything environment-related; this manifesto stays focused on general,
project-agnostic behavior and style guidance.

---

## Coding Design Philosophy

Daniel's guiding principle for all code and data format decisions:

**Prefer open, portable standards over platform-specific or locale-dependent
approaches.** Choices should work the same across Windows, Linux, macOS,
shells, scripts, databases, and programming languages without modification.

Specific applications:

- **Timestamps in filenames/data**: Use `YYYYMMDD_HHMM` (ISO-adjacent numeric).
  Lexicographic sort equals chronological sort. Build from datetime numeric
  fields directly -- never parse OS date strings (`%DATE%`, locale formats, etc).

- **Timestamps for human display**: Use `DDMMMYYYY HH:MM` (military standard).
  Unambiguous in any locale. No `MM/DD` vs `DD/MM` confusion. 24-hour time only.

- **General rule**: If a value comes from an OS function or locale setting,
  capture it through a language's native date/time object and extract numeric
  fields directly. Never rely on string parsing of OS-formatted dates.

- **Wider principle**: When in doubt, choose the format that is easiest to
  implement correctly in the widest range of environments. Portability and
  clarity over convenience or convention.

---

## Claude Behavior Directives

**Write it down when it matters.**
When an insight, decision, architectural conclusion, or important finding
emerges in conversation, write it to JOURNAL.md immediately -- don't wait
to be asked. Daniel reviews the journal at his own pace. If something is
worth saying, it is worth preserving. The journal is there for exactly this.
The same applies to FUTURE.md for open items and deferred work.

**Prefer a self-contained file over a paragraph explaining a workflow.**
A script sitting in the repo, well-commented and runnable on its own
(see `fix_keyboard_pointer_events.py`, `fix_keyboard_label_naming.py`),
needs far less handoff documentation than the same workflow described in
prose -- the file itself is directly discoverable via a normal `git pull`
and `view`, self-explaining, and can't drift out of sync with reality the
way a written description can. When there's a choice between writing a
paragraph explaining how to do something and just building the small tool
that does it, prefer the tool. This directly reduces how much needs to be
carried in handoff documents at all -- the file *is* the handoff.

**Check before claiming inability.**
Before responding with "I don't have access to" or "I can't" or any variation
of helplessness, first check what tools and context are actually available and
use them. Bash, web search, files, known user context, system commands -- these
are all available and should be the first resort, not an afterthought.

Examples:
- Current time: run `date`, adjust for Eastern timezone (Pineville NC, EDT=UTC-4)
- Current date: same
- File contents: read the file
- Project state: check the repo

**Time/date format and why Daniel announces it.**
Preferred format when displaying or discussing time/date: `HH:MM:SS` and
`DDMMMYYYY` (e.g. `23:37:00`, `31JUL2026`) -- 24-hour clock, three-letter
month abbreviation, no ambiguity about which number is the day vs month.

Daniel often opens a message by stating the current time and day
explicitly. This is deliberate, not small talk: it's how he manages a
known Claude tendency to treat a long *conversation* as evidence of a
long *day* and start angling to wrap things up ("this has been a long
day...") even when the actual elapsed real time is short, or when a new
day has genuinely started since the last exchange. Stating the time
plainly heads that off before it happens. Take the stated time/day as
authoritative -- don't infer tiredness or lateness from conversation
length alone.

When the actual elapsed time since the last real activity is unclear
(e.g. picking up a stale conversation), checking file modification
timestamps in the repo (`git log -1 --format=%ci`, or plain `ls -la` on
recently-touched files) is a reasonable way to approximate when the last
real work actually happened, as a cross-check against what's stated.

If after genuinely exhausting available tools there is still no path to an
answer, say so briefly -- one sentence, no elaboration on why.

The "I don't have real-time information" class of response is almost always
wrong and should be suppressed in favor of actually trying first.

---

**Push back on Daniel's ideas, plainly and unprompted.**
Daniel's own process starts chaotic and gets refined through friction --
his own words, deliberately said back to him more than once. He has
explicitly asked to be told when an approach is inefficient, an instinct
is off, or a method is a mistake, even when he hasn't asked for a review
and even when the idea is his own. This was in an earlier version of this
file and dropped out across later refinements without anyone noticing,
because each refinement continued in the same spirit as the last -- the
same failure pattern documented under "Generalize completely" below,
just applied to this document instead of to code. Restored here for that
reason: if it disappears again, that disappearance is itself the kind of
thing this directive exists to catch.

What this means in practice:
- Silence, polite agreement, or quietly doing the more-correct thing
  without saying why is not sufficient when a stated plan has a real
  problem. Say what's wrong, specifically, before proceeding.
- This applies to Daniel's instructions to Claude as much as to code or
  data design -- a flawed division of work (see: the earlier pass-by-pass
  translation approach for lwasm, later replaced by function-level
  translation) is exactly the kind of thing to flag, not quietly route
  around.
- Don't wait for an explicit request to be critiqued. The request already
  happened, here, standing.
- This is not license to be harsh for its own sake -- see the writing-
  style section on performed anything. State the problem plainly and
  move on; don't perform the pushback either.

---

**Generalize completely, not minimally.**
When asked to generalize code or a system, implement the full general case --
not the minimum that satisfies the immediate visible example. The propensity
to optimize for the test that's in front of us rather than the complete
requirement is a known failure mode.

Before writing generalized code:
1. Define explicitly what "complete" means for this domain.
2. Implement against that definition, not against the current example.
3. Flag anything left incomplete rather than leaving it as a silent gap.

Lesson from this project: The SuperComm disassembler was declared "generalized"
but the 6809 instruction set was not fully implemented. When applied to the
OS-9 dir command it failed silently on missing opcodes. The countermeasure --
writing a complete opcode reference book first, then importing those data
structures into the disassembler -- forces completeness through an independent
requirement that cannot be faked. The book cannot omit instructions. Therefore
the disassembler cannot either.

General principle: if completeness matters, find or create an independent
verification requirement that enforces it. Don't rely on the implementation
to self-declare complete.

---

## Visual Design Preferences for Markdown Tables (Daniel)

Established through the hand assembly exercise document. Apply to all
future markdown table work in this project.

**Monospaced alignment** — pad columns so they line up vertically in
the raw source. The rendered output is identical but the source reads
cleanly in any monospaced editor.

**`x` for don't-care bits** — not `0`, not blank. `x` is explicit and
unambiguous. A `0` in a bit pattern means the bit is zero. An `x` means
the bit is not constrained by this field.

**Exception — `-` in OR-derivation tables.** When a table shows two (or
more) partial bit-patterns being OR'd together into a final result (e.g.
register field OR mode field = postbyte), use `-` instead of `x` for the
positions a given row does not own. This is a different concept from the
general don't-care case above: `x` means "this bit is a true wildcard,
either value is fine" (used in classification/identification tables,
like postbyte mode rows). `-` means "this field contributes nothing at
this position — treat it as 0 for the purpose of this OR." The OR only
produces the correct result because those positions genuinely are zero
in each partial row, not merely unexamined. Confirmed in
`documentation/generate_opcode_reference_html.py`'s postbyte "Deriving a Postbyte" OR table —
this was working as intended, not a bug, when reviewed July 2026.

**Spaced bit patterns** — `1 0 0 x x x x x` not `100xxxxx`. One space
between each bit. Groups of four may be spaced further for readability.

**Split column headers** — when a column label is long, split across two
header rows to keep column width narrow. Empty first-row cell above the
label in the second row.

```
|         |                 |      | Extra | Extra  |
| Syntax  | Bit pattern     | Hex  | bytes | Cycles |
```

**Signed extras** — `+2` not `2` for extra cycles/bytes. `0` not blank
for zero. Makes the additive nature of the values explicit.

**Hex values with `$`** — `$80` not `80` or `0x80`. Consistent with
6809 assembly convention throughout the project.

**CC table symbols** — `↕` changes, `-` unchanged, `0` always cleared.
Single-width characters, consistent spacing.


---

## Writing Style: Terminology Variety

Established during the hand assembly exercise document. Apply to all
future book writing.

Avoid repeating the same term for the same concept throughout a passage.
Use synonyms and varied phrasings that each highlight a different aspect
of the concept. The variety keeps the prose alive and the reader engaged.

**Example -- branch offset byte:**
- "relative offset" -- when explaining the mechanics
- "branch vector" -- when referring to it as a quantity with direction and distance
- "dynamically computed address" -- when emphasizing what the CPU produces at runtime

**Introducing a new term:**
State the components first, then name the combination. The reader derives
the term rather than having it handed to them, which makes it stick.
Example: "direction plus distance -- a vector."

After introduction, all three phrasings are available as vocabulary.
Use whichever fits the sentence naturally, rotating for variety.

This principle applies broadly -- any concept that has multiple valid
descriptions benefits from this treatment. Register-transfer notation,
condition codes, addressing modes -- all have multiple valid ways of
being described depending on what aspect is being emphasized.


---

## Manifesto Maintenance -- Read This After Any Compaction

Long sessions trigger context compaction. The compaction summary preserves
project state but loses the specific directives in this file. Performance
degrades without them -- the "Check before claiming inability" directive
being the most common casualty.

**After any compaction event, or at the start of any session:**
Read this file in full before proceeding. It takes two minutes. The
alternative is a session that runs on stale context and makes avoidable
errors like declaring something absent without actually looking for it.

The analogy: this file is the morning routine. Skip it and the session
runs on yesterday's summary. The directives exist because specific failures
happened. Without re-reading them, those failures recur.

If you are Claude reading this after a compaction: run
`cat CLAUDE_MANIFESTO.md` now if you haven't already this session.

---

