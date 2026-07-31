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
  generate.py           generates HTML opcode reference from JSON
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

## Toolchain & NPP Workflow

```
# Disasm pass (NPP Run command):
cmd /c cd /d $(CURRENT_DIRECTORY) && python dis6x09.py --proj $(NAME_PART).json -n --markup

# Markup pass (NPP Run command):
cmd /c cd /d $(CURRENT_DIRECTORY) && python markup.py $(NAME_PART).dasm $(NAME_PART).json
```

File extensions:
- `.dasm` -- disassembler output, annotated, NOT directly assembleable
- `.asm`  -- prepasm.py output, assembleable by lwasm

BSS format in JSON (unified):
```json
"bss": {
  "88": {"name": "BSS.DEName", "comment": "29-byte filename field"}
}
```
Auto-migrates old plain-string format on load.

---

## Book -- see BOOK_HANDOFF.md

Everything specific to the book itself (chapter status, structure,
COMTRAN TEN reference, pending chapter work, the Unravelled series
OCR-conversion idea) has been moved to `BOOK_HANDOFF.md` at the repo
root, as part of splitting project-specific content out of this
manifesto. Read that file for anything book-related; this manifesto
stays focused on general, project-agnostic behavior and style guidance.

---

## cocotools -- Python Toolkit (IN PROGRESS)

**Goal:** Fully self-contained Python replacement for lwasm + toolshed + decb.
Python is everywhere. No platform binaries. Works in browser via XRoar WASM.

**Workflow vision:**
```
python cocotools.py assemble GUESS.ASM -o GUESS.BIN
python cocotools.py makedsk GUESS.DSK GUESS.BIN GUESS.BAS
# Mount GUESS.DSK in XRoar WASM -- done
```

### Source References for Translation

**lwasm (assembler):**
- Source: http://www.lwtools.ca/hg/index.cgi/file/tip/lwasm/
- Language: C (GPL v3), author: William Astle <lost@l-w.ca>
- Also mirrored: https://github.com/stahta01/LWTools
- Also mirrored: https://github.com/jmatzen/LWTools
- Key files to translate:
  - lwasm/instab.c (47KB) -- instruction table (DONE in instab.py)
  - lwasm/instab.h -- structure definitions
  - lwasm/insn_gen.c -- general addressing mode handling
  - lwasm/insn_indexed.c (13KB) -- indexed postbyte encoding (COMPLEX)
  - lwasm/insn_rel.c -- branch instruction encoding
  - lwasm/insn_inh.c -- inherent instructions
  - lwasm/insn_rlist.c -- register list (PSHS/PULS)
  - lwasm/insn_rtor.c -- register-to-register (TFR/EXG)
  - lwasm/pass1.c -- first pass (parse, symbol collection)
  - lwasm/pass2.c through pass6.c -- resolution and emission passes
  - lwasm/output.c -- DECB and raw output format
  - lwasm/os9.c -- OS-9 module output
  - lwasm/lwasm.c -- main assembler logic
  - lwasm/main.c -- CLI entry point

**toolshed/decb (disk image tools):**
- Source: https://github.com/hathaway3/toolshed
- Also: https://github.com/n6il/toolshed
- Language: C (GPL), key tool: decb (Disk Extended Color BASIC utility)
- Key operations needed: dskini, copy, dir, dump

**BASIC tokenizer:**
- No single authoritative source
- CoCo BASIC token table documented in "Color BASIC Unravelled" series
- Scanned copies at: https://techheap.packetizer.com/computers/coco/unravelled_series/

**XRoar WASM:**
- https://www.6809.org.uk/xroar/
- Browser-based CoCo emulator -- no installation needed

### cocotools Status

| File | Status | Notes |
|------|--------|-------|
| cocotools/DESIGN.md | DONE | Full architecture document |
| cocotools/instab.py | DONE | 139 instructions, 15 spot checks pass |
| cocotools/lw_expr.py | DONE | Faithful translation of lw_expr.c — expression trees, simplify, parser |
| cocotools/lwasm.py | STUB | Phase 1 reimplementation (not a translation) — to be replaced |
| cocotools/decb.py | DONE | DSK builder + BIN formatter, Dsk class |
| cocotools/basic.py | NOT STARTED | BASIC tokenizer |
| cocotools.py | DONE | CLI: assemble, makedsk, binin, dskls |

### instab.py Design (for lwasm.py author)

INSTAB dict structure:
```python
INSTAB['LDA'] = {
  'imm': 0x86,   # immediate opcode
  'dir': 0x96,   # direct page opcode
  'idx': 0xA6,   # indexed opcode
  'ext': 0xB6,   # extended opcode
  'parse': 'gen8'  # parser class
}
# Prefixed opcodes: P10 = 0x1000, P11 = 0x1100
# None = mode not supported for this instruction
```

Parser classes: inh, gen8, gen16, gen0, rel8, rel16, relgen,
                rtor, rlist, imm8, leax, mem

Indexed register postbyte bits [6:5]: X=00, Y=01, U=10, S=11
PCR addressing uses postbyte 0x8C (8-bit) or 0x8D (16-bit)

### Verification Strategy

For each program:
1. Assemble with lwasm -> reference binary
2. Assemble with Python cocotools -> test binary
3. Compare byte-for-byte -> must match exactly

Start with GUESS.ASM (30 bytes, simple)
Then HELLO.ASM (80 bytes)
Then dir/supercomm22 (real-world)

---

## Engine Features (dis6x09.py)

- `target`: "os9" emits mod/emod/rmb/size idioms; "raw" keeps EQU output
- `hex_offsets`: ["U"] shows hex offsets on unnamed U-relative addressing
- `--source` optional when `binary` field set in JSON
- BSS: unified dict format, auto-migrates old plain-string format
- `prev_ret = is_ret` -- separator fires after labeled RTS too
- `/bss/ $XX Name "comment"` -- quoted comment replaces size annotation

## prepasm.py Features

- Converts BSS EQU -> RMB with gap-based size calculation
- Preserves analyst comments on RMB lines
- Handles "raw" (.dasm EQU style) input

## markup.py Directives (quick reference)

Key ones: /label/, /bss/, /comment/.../end-comment/, /; line comment/,
/region/, /routine/, /rename-label/, /remove-comment/
Full reference in any .dasm file at bottom as MARKUP QUICK REFERENCE

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

## Cartridge ROM Entry Mechanisms (CoCo $C000, confirmed by direct testing)

A cartridge ROM at $C000 can be entered two genuinely different ways, and
the closing instruction MUST match the entry mechanism or the result is
silent stack corruption that can look deceptively like success.

**Path A -- FIRQ autostart (real hardware: pin 8 tied to pin 7, CART* signal)**
CPU pushes only PC (2 bytes) then CC (1 byte), then JMPs (not JSRs) to
$C000 via the FIRQ vector chain. There is no JSR-style return-address
frame. The routine MUST end in RTI to correctly restore CC (unmasking
IRQ/FIRQ) and PC. Confirmed working: clean return to BASIC's own
cold-start sequence, full register restoration, keyboard and cursor
remain live afterward.

**Path B -- manual call (EXEC &HC000 from BASIC)**
EXEC pushes a normal 2-byte return address, same as any JSR. The routine
MUST end in RTS. Using RTI here pops a fabricated "CC" byte (actually
the low byte of the real return address) and miscomputes PC from
adjacent stack bytes -- an uncontrolled jump built from misaligned
stack data. Confirmed: this can land somewhere that happens to look
like a clean result (e.g. BASIC's cold-start banner reprinting) without
actually being one. Don't trust a plausible-looking result from a
known-mismatched entry/exit pairing.

**Using RTS after FIRQ entry** (the inverse mistake): pops [CC][low byte
of PC] as a bogus return address, leaves IRQ/FIRQ masked because RTS
never restores CC. Confirmed: keyboard and cursor go dead, machine
appears frozen, because the periodic VSYNC interrupt that drives system
housekeeping never fires again.

**XRoar WASM cart-loading notes (this build, confirmed via `strings xroar.wasm`):**
- `-cart` and `-cart-type` only accept a fixed set of named hardware
  profiles: cp450, delta, dragondos, gmc, ide, mcx128, mcx128a, mooh,
  orch90, rsdos. There is no generic "rom" type.
- A bare filename passed to `-cart` (e.g. `-cart STRTEST_CART.ROM`) is
  accepted and treated as an ad-hoc ROM cart -- this is how
  `daggorat.ccc` worked with a single argument.
- `-cart-autorun no` did NOT suppress the FIRQ autostart for a
  bare-filename `-cart` load in direct testing (twice). It may only
  apply to the named hardware profiles. Software equivalent of "taping
  over pin 8" is not yet confirmed working through this argument
  combination -- worth raising with Ciaran directly, with this session's
  test results as evidence.
- Swapping the active cartridge via the Hardware tab dropdown WITHOUT a
  reset reproduces the real documented hardware hazard of hot-swapping
  a cartridge while powered on (CoCopedia FAQ: "it is extremely
  dangerous to insert a ROM-Pack with the CoCo switched on"). Confirmed:
  this can hang the emulated machine, including surviving a soft reset,
  because RAM hooks patched by the previous cart's ROM still point into
  memory now occupied by different code (or NOP padding). Always pair a
  cart change with a hard reset.
- cocotools.py `makerom` command pads a raw binary to the standard 8K
  cartridge size (8192 bytes) with NOP ($12), not $FF (SWI) -- chosen
  deliberately so that if the CPU ever wanders into the padding it
  slides through harmlessly rather than trapping.

---

## XRoar WASM Page (wasm/index.html) -- Development History

### Why a rewrite instead of incremental edits

The original page came from the upstream XRoar Online distribution
(https://www.6809.org.uk/xroar/online/) -- a single index.html with all
CSS, layout, and the XRoar control panel markup tightly interwoven. The
goal was to add a CM-8 monitor bezel overlay around the emulator canvas
and restyle the controls panel. Attempting this as incremental CSS edits
against the original markup did not work cleanly -- the existing layout
rules fought the new bezel positioning and panel restyling at every
turn, producing fragile, hard-to-reason-about results.

The decision was made to build new scaffolding from scratch (clean CSS,
new layout structure, the bezel overlay system, the controls panel
redesign) as index_new.html, then import the *functional* guts of the
original page -- the actual working JS that talks to the compiled
xroar.wasm module -- into that new scaffolding, rather than trying to
reconcile two competing sets of CSS.

### What went wrong during the import, and how it surfaced

Some functional pieces ported cleanly (file loading, the type-text
modal, keyboard capture/blur logic). Two small pieces did not survive
the port intact: the Machine and Cartridge dropdown onchange handlers.
They were small enough to look trivial and got reinvented inline
(`wasm_set_machine(value)` / `wasm_set_cart(value)`, passing string
values) instead of being copied verbatim from the original, which used
`wasm_set_int('machine', value, 1)` / `wasm_set_int('cartridge', value, 1)`
-- XRoar's compiled WASM module expects integer index values for these
two controls, not strings.

The bug was invisible for days: the dropdowns rendered correctly, the
onchange fired, there was no console error -- the calls simply did
nothing downstream. It was only caught when machine/cartridge switching
was actually exercised, well after the rewrite session ended.

**Lesson:** when porting functional code into new scaffolding, copy-paste
the wiring verbatim first, before refactoring it -- even for handlers
that look trivial. The trivial-looking ones are exactly where a
plausible-but-wrong rewrite slips in unnoticed, because nothing about
the failure is visible without specifically exercising that control.

### CM-8 bezel: PNG -> hand-patched SVG

The bezel went through several iterations (see wasm/cm8_bezel_v2.svg
through v6, and the various cm8_rebuilt_*.png files) before settling on
a fully vector approach:

1. A clean screenshot was sourced from a YouTuber's 3D CM-8 model as the
   most accurate available reference (better than any owner's-manual
   line drawing).
2. Inkscape's trace function was run against that screenshot to get a
   vector starting point -- but the trace was never going to resolve
   the TANDY label correctly (the trace artifacts inside the CRT opening
   were also a known limitation of this approach, later patched over).
3. The TANDY label was hand-crafted separately and precisely, not
   traced: Microgramma D Extended font (a close match to the real label),
   three RGB color bars drawn by hand, and the whole label group given a
   `skewY(0.41435463)` transform (arrived at by eye, iterating until it
   matched the slight off-axis angle visible in the reference photo) to
   match the perspective of the rest of the traced image.
4. Trace artifacts inside the screen opening were masked with a black
   filled path placed on top -- invisible to users since the XRoar
   canvas sits on top of the bezel's transparent screen cutout anyway
   (z-index layering: canvas behind, bezel overlay on top, canvas shows
   through the transparent CRT opening).
5. The original bitmap PNGs were removed from the SVG entirely once the
   vector version was complete -- wasm/cm8_bezel.svg is now the single
   source of truth for the bezel, referenced directly in index.html's
   background-image.

This is why the bezel scales cleanly to any size with no blurring --
there's no embedded raster image left in the file at all.

### Size slider

`var monitorWidth` already existed as the single config value driving
`applyMonitorLayout()` (canvas position/size computed as a scale factor
against the bezel's native 1073x967 dimensions). The slider in the title
bar is a thin UI layer on top of that existing mechanism:
- Steps through standard display widths (400, 480, 640, 800, 1024, 1280,
  1366, 1400) rather than arbitrary increments, snapping to the nearest
  standard resolution.
- Clicking the pixel readout swaps it for a number input to type a
  custom value directly (any integer 400-1400), Enter/blur commits,
  Escape cancels.
- Implementation note: `sizeSteps`, `nearestIndex()`, and `applySize()`
  must live in GLOBAL scope, not inside a DOMContentLoaded closure --
  an earlier version scoped them locally and the slider silently did
  nothing because the inline `oninput` HTML attribute couldn't see them.
  The working version uses inline `oninput="applySize(...)"` directly on
  the `<input type=range>` element rather than an addEventListener,
  since addEventListener attachment timing proved unreliable against
  whatever DOM activity XRoar's own init does on load.

### Future development
See FUTURE.md for open items: vertical slider alternative (left-side
column, knob-style), cartridge ROM chapter material, and the
-cart-autorun investigation.

---

## XRoar WASM -- cart-autorun Investigation (July 2026)

**Summary:** `-no-cart-autorun` does not suppress FIRQ autostart for
bare-filename ad-hoc carts. Confirmed negative result by direct testing.
Source traced through XRoar's cart.c and xroar.c.

**Three separate code paths identified:**

1. **Bare-filename `-cart` path** (e.g. `-cart STRTEST_CART.ROM`):
   Goes through `cart_special[]` fingerprint table in cart.c. Unknown
   ROMs fall through to generic `cc->autorun = 1` unconditionally in
   the auto-detection logic, before `cart_config_complete()`'s
   `ANY_AUTO` check runs. `-no-cart-autorun` may be set too late to
   affect this path.

2. **Named hardware profile path** (e.g. `-cart rsdos`):
   Goes through `cart_config_complete()` which checks `ANY_AUTO`.
   `-no-cart-autorun` should work here via the standard option mechanism.

3. **`-load` path** (e.g. `-load STRTEST_CART.ROM`):
   Routes through `xroar_load_file_by_type()` -> `FILETYPE_ROM` case.
   Calls `cart_config_by_name()` then unconditionally sets
   `cc->autorun = autorun` where `autorun` comes from `do_load_binaries()`
   checking `autorun_media_slot == media_slot_binary`. The first/only
   media file specified always claims the autorun slot -- no suppression
   flag found for this path.

**`-no-machine-cart`** (`-nodos`): suppresses the default disk-controller
cart (RS-DOS). Confirmed working. Does not affect autorun of loaded ROMs.

**`cart_special[]` table:** hardwired in cart.c. Fingerprints known DOS
ROMs by CRC32 and sets `no_autorun=1` for them specifically. Custom/unknown
ROMs get the generic `autorun=1` fallback. Table is compiled into xroar.wasm.

**Ciaran's note:** "-i should add a note about boolean options - that's the
general form: `-no-<option>`" -- confirmed in xconfig.c: the `no-` prefix
is handled generically by stripping it and calling `unset_option()`.

**Status:** Report sent to Ciaran with test results. He acknowledged
"something screwy about how it auto-makes a rom cart." Open.

---

## XRoar WASM Page -- New Features (July 2026)

### Log Panel (Help tab)
`Module.print` and `Module.printErr` are now wired to a visible
`#xroar-log` div in the Help tab. XRoar's own console output (ROM CRC
results, cart loading, "unknown file type", etc.) appears there on demand.
Toggle with the "..." button. Messages accumulate while hidden.

### DECB .bin Header Parser
`file_input_onload()` now parses `.bin` files client-side before handing
them to `wasm_load_file()`. Reports: block count, bytes loaded, load
address, entry point. Flags entry points that are zero or outside loaded
data range as likely placeholders.

**DECB binary format (corrected):**
- Data block: `[0x00][len_hi][len_lo][addr_hi][addr_lo][data...]`
- EOF block: `[0xFF][0x00][0x00][exec_hi][exec_lo]`
- The EOF block has a 2-byte length field (always 0x0000) before the
  exec address. A common mistake is reading the length bytes as the
  exec address -- produces 0x0000 which looks like a missing exec addr.

### index_new.html
`wasm/index_new.html` is now the active development page (rebuilt clean
from index.html). `index.html` is the stable reference. The transparent
overlay scaffolding file was removed.

---

## GitHub Pages (July 2026)

The repo is now published at:
**https://erroneus0-ops.github.io/SuperComm-disassembled/**

Root `index.html` links to:
- COMTRAN TEN opcode map and instruction reference
- 6809 instruction reference (all groups)
- XRoar standard and development pages

**Do not link from the index:** FUTURE.md, CLAUDE_MANIFESTO.md,
source files, binaries, project JSON files, screenshots folder,
book draft `.md` files (render as plain text on Pages).

Book chapters get linked when converted to HTML and ready to publish.

---

## Screenshots and Similar Artifacts as a Communication Protocol (July 2026)

Screenshots (and by extension, other dropped-in files -- video, exported
assets) aren't just a narrow workflow for one purpose. They're a real
communication channel between Daniel and Claude, on par with text itself
-- a protocol, like any other, for passing rich information (visual
state, recorded behavior) across the gap between "what Daniel can see on
his own screen" and "what Claude can actually examine directly."

**The mechanics:** screenshots go in `screenshots/` at the repo root.
`make_screenshot_index.py` (repo root) generates `screenshots/index.html`
-- a browsable listing of all image files, with timestamps.

**Two ways they get pushed:**
- `git_update.bat` -- the full repo sync, regenerates the index and
  commits everything pending, screenshots included alongside whatever
  else changed.
- `push_images.bat` -- lightweight, dedicated, screenshots-only. Snap a
  screenshot, run this, done, without pulling in unrelated in-progress
  changes elsewhere in the repo. Regenerates the index, stages only
  `screenshots/`, commits, pulls --rebase --autostash, pushes. Exists
  specifically because `git add`/`git commit` *can* be scoped to a
  single subdirectory, but `git push` can't be selectively scoped the
  same way -- it sends whatever's committed, regardless of which paths
  were touched -- so the scoping has to happen at the commit step, and a
  separate dedicated script is the clean way to keep that narrow.

**For Claude:** check `screenshots/` via `git pull` when contextually
relevant. New files can also be fetched via GitHub Pages URL:
`https://erroneus0-ops.github.io/SuperComm-disassembled/screenshots/`

**Do not keep screenshots (or any downloaded/generated media -- video
frames, rendered images, extracted assets) sitting in the sandbox
workspace after they've served their purpose.** Once a screenshot or
similar file has actually been examined for whatever it was needed for,
delete it from the local working directory. Files left lying around in
Claude's own environment don't need to be tracked, explained, or handed
off to a future session the way repo-committed content does -- but only
if they're actually cleaned up. Leaving them around defeats that benefit
and just adds clutter for no reason.

---

## XRoar WASM Mobile Improvements (July 3 2026)

### Hamburger Menu Icon
- `wasm/hamburger.svg` -- custom SVG burger icon (actual hamburger design)
  Top bun as arc path, lettuce with ruffled edge, cheese with corner
  overhangs, thick patty, flat bottom bun. Designed collaboratively,
  geometry specified by Daniel before building.
- Appears in title bar to left of "XRoar Online" text
- Single tap: toggles controls panel show/hide (300ms delay to distinguish
  from double-tap)
- Double-tap (< 300ms): resets overlay to default position without toggling
- `oncontextmenu="return false"` and `-webkit-touch-callout:none` suppress
  browser long-press image menu
- Title bar has `z-index: 101` -- burger always above overlay (z-index 100)

### Mobile Controls Overlay
On mobile (detected by preponderance scoring -- see below):
- Controls panel hidden by default on load
- Shown as `position:fixed` overlay when burger tapped
- Wrapper div contains: drag handle title bar + controls-region (scrollable)
- Drag handle stays fixed above scrollable content -- title bar doesn't
  scroll away when Help tab log is open
- Drag constrained: cannot go above title bar (burger always accessible)
- Width matches monitorWidth, max 95vw
- Max-height 70vh, controls-region scrollable within wrapper
- `ui_set_fullscreen()` updated to use wrapper on mobile

### Mobile Detection (preponderance-of-evidence)
`isMobileDevice()` scores multiple signals, threshold 4/8:
- `ontouchstart` in window: 2pts
- `pointer: coarse` media query: 2pts
- `hover: none` media query: 1pt
- `window.innerWidth < 700`: 1pt
- UA string contains Mobile/Android/iPhone/iPad: 1pt
- `screen.width < 768`: 1pt

Result stored as `window._isMobile` (global, accessible outside IIFE).
Fixes landscape refresh glitch -- phone in landscape scores 6-7 regardless
of viewport width being > 700px.

### Mobile Keyboard Observations (OPEN)
- Soft keyboard appears for the size label input field (numeric keyboard)
- Only `-`, `.`, and tab pass through to the input -- SDL2 captures everything else
- Canvas element does not trigger soft keyboard on tap
- Same issue as Type Text dialog -- SDL2 keyboard capture at document level
- Fix path: hidden `<input type="text">` focused on canvas tap, keystrokes
  forwarded to XRoar. Requires asking Ciaran if WASM build exposes an input path.
- Worth asking Ciaran: is the built-in GDB debugger/monitor accessible in WASM?
  If so, execution trace could appear in the Help tab log panel.

### IIFE Scope Trap (recurring)
Functions defined inside the outer IIFE are invisible to inline event
handlers (`onclick=`) and to code outside the IIFE (like `ui_set_fullscreen`).
Pattern: always use `addEventListener` from inside the IIFE, and expose
values that need global access via `window._name`. This has bitten us
multiple times -- check scope before wondering why something doesn't fire.

---

## zip_backup.py Rewrite (July 3 2026)

Complete rewrite with config file, module system, explicit flags.

### Location
- Office: `C:\Users\dhauck\AppData\Local\scripts\zip_backup.py`
- Home: `C:\Users\Daniel\AppData\Local\scripts\zip_backup.py`
- Config: `zip_backup.json` next to script (not tracked in git, machine-specific)
- Modules: `zip_backup_modules\` folder next to script

### Flags
- No flags → shows help (no accidental runs)
- `--run` → incremental backup
- `--full` → full backup
- `--dry-run` → preview, no zip created
- `--config` → interactive reconfiguration only, no backup
- `--help` / `-h` → help

### Config: zip_backup.json
```json
{
    "source_dir":       "D:\\git",
    "backup_dir":       "D:\\git_backups",
    "log_file":         "D:\\git_backups\\zip_backup_log.log",
    "max_backups":      20,
    "prefix":           "git_",
    "excluded_folders": ["screenshots"],
    "modules":          ["git_bundle"]
}
```
Optional keys: `suffix_incremental` (default `_daily`), `suffix_full` (default `_full`)

### Key behaviors
- Dot-folders (.git, .svn, etc.) always excluded from incremental at runtime
- Not stored in JSON -- handled by code
- Log: weekly rotating (TimedRotatingFileHandler, W0, 4 weeks)
- Config prompts: short labels when value exists, descriptive with platform
  hints when empty. Windows hints `C:\DATA\...`, Unix hints `/home/user/...`
- `X to clear` for folder exclusions
- Scheduled task: exits with error code 2 if no config and no terminal
- `--config` requires interactive terminal, exits with error if not

### Module System
Modules in `zip_backup_modules\` folder. Each is a `.py` file exposing:
- `NAME` -- string, matches config "modules" list entry
- `DESCRIPTION` -- string
- `run(cfg, backup_dir, dry_run)` -- returns list of Path objects to include

Bundled module: `git_bundle.py` -- creates `git bundle --all` snapshot of
each repo found directly under source_dir. Bundle written to backup_dir,
included in zip. Self-contained restore: `git clone repo.bundle restored_repo`

Optional git_bundle config in zip_backup.json:
```json
"git_bundle": { "git_exe": "C:\\Program Files\\Git\\cmd\\git.exe" }
```
If omitted, assumes `git` is in PATH.

README in `zip_backup_modules\README.md` documents module contract.

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
`documentation/generate.py`'s postbyte "Deriving a Postbyte" OR table —
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

## XRoar WASM Build from Source (July 7 2026)

### Environment
- Windows 10 LTSC 2021 (build 19044) -- upgraded from 1809 this session
- WSL2 with Ubuntu 22.04.1 LTS
- Emscripten 6.0.2 (installed via emsdk)
- XRoar source: https://www.6809.org.uk/git/xroar.git

### Setup commands
```bash
# Install emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh   # must run each session or add to .bashrc

# Clone XRoar
mkdir -p ~/src
cd ~/src
git clone https://www.6809.org.uk/git/xroar.git
cd xroar

# Dependencies (most already present on Ubuntu 22.04)
sudo apt install -y build-essential autoconf automake pkg-config \
    libsdl2-dev libpng-dev zlib1g-dev python3 texinfo
```

### Build commands
```bash
autoreconf -fi

emconfigure ./configure --enable-traps --host=wasm32-unknown-emscripten

emmake make -j$(nproc) GL_LIBS=""
```

### Known quirks
- `--host=wasm32-unknown-emscripten` required -- without it configure
  detects Objective-C and sets OBJCLD incorrectly, causing link failure
  with "none: No such file or directory"
- `GL_LIBS=""` required at make time -- configure sets GL_LIBS to the
  literal string "none required" (from the OpenGL check output) which
  gets passed to emcc as an input file and fails
- `texinfo` must be installed or doc build fails

### Output
- `src/xroar.wasm` -- 5.99MB (unoptimized, with debug symbols)
- Ciaran's release build is 1.3MB -- size difference due to -g flag
  and missing Emscripten-specific size optimizations
- Committed to repo as `wasm/xroar-custom.wasm`

### Next steps
- Study Ciaran's build flags for size optimization
- Add debug exports to wasm.c: wasm_set_trace, wasm_set_breakpoint,
  wasm_clear_breakpoint, wasm_get_registers
- Add to exported_functions
- Rebuild and test in browser
- Ciaran's note: build with --enable-traps for trap/breakpoint support

### WSL2 path to Windows files
D: drive is at /mnt/d/ in WSL2
Copy built WASM to repo: cp ~/src/xroar/src/xroar.wasm /mnt/d/git/supercomm/wasm/

---

## Disassembly Workflow: dis6x09.py + markup.py

The disassembler is a multi-tool workflow, not a one-shot script.
Read analyst_json_tutorial.md and analyst_markup_reference.md before
working on any disassembly project.

### Tools in the chain

- **dis6x09.py** — disassembler engine. Produces annotated .dasm output.
  Use --help to see all options. Two formats supported:
  - OS-9 module: requires --proj JSON file (created on first run if absent)
  - DECB/Color BASIC BIN: use --decb flag, no JSON required for first pass
- **markup.py** — reads analyst directives from the .dasm file, updates
  the project JSON. The analyst never edits JSON directly.
- **strip_listing.py** — removes directives and address/byte columns,
  producing a clean .asm file for reassembly
- **compare_bins.py** — verifies reassembled binary matches original

### Workflow

```
First run:
  python3 dis6x09.py --source binary --proj project.json
  → prompts for JSON name if not found (has timeout -- use -n for default)
  → writes project.json and binary_proj.dasm

Work cycle (repeat):
  1. Review binary_proj.dasm
  2. Add /directives/ to .dasm (labels, data regions, comments)
  3. python3 markup.py binary_proj.dasm → updates project.json
  4. Re-run dis6x09.py → cleaner output reflecting analyst knowledge

DECB one-shot:
  python3 dis6x09.py --source file.bin --decb
  → no JSON needed, CoCo hardware equates at top, outputs file_proj.dasm

Product stage:
  strip_listing.py → clean .asm
  assembler → .bin
  compare_bins.py ← must match original
```

### Key docs
- analyst_json_tutorial.md -- full workflow with directive examples
- analyst_markup_reference.md -- complete directive reference

### Notes
- The prompt for JSON name will hang in piped/automated contexts.
  Use -n flag to skip prompts and accept defaults.
- DECB project JSON workflow (--decb --proj) not yet implemented --
  currently DECB is one-shot only. Full DECB workflow is a pending item.

---

## dis6x09.py / markup.py -- Discoverability Design Notes

The tool was redesigned after identifying that the original workflow
punished natural first-contact behavior:

**Problems identified:**
- No args → hung indefinitely waiting for JSON name prompt
- --help showed -h in usage line (unclear)
- No path to useful output without knowing the full JSON workflow
- MARKUP_QUICK_REF embedded in dis6x09.py (duplicate, drift risk)

**Solutions applied:**
- No args → clean usage line + "run with --help" hint, exits cleanly
- --help shown explicitly in usage line
- --quick / -q → first-contact mode: auto-detect format, no JSON,
  no prompts, write .dasm and exit. Natural entry point for new binary.
- Auto-detection: OS-9 ($87CD), DECB (block structure), raw (fallback)
- --os9 / --decb / --raw override detection when needed
- MARKUP_QUICK_REF moved to markup.py as single source of truth
- markup.py --ref → terminal reference; --ref --asm → comment lines
- dis6x09.py --ref calls markup.py --ref --asm via subprocess

**Intended first contact with an unknown binary:**
```bash
python3 dis6x09.py --source unknown.bin --quick
```
Get output, get oriented, then start a full --proj workflow if warranted.

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

## FIXED: PSHS D / PULS D bug in cocotools

`PSHS D` and `PULS D` were assembling incorrectly -- producing postbyte
$80 (PC) instead of $06 (A+B).

**Root cause:** _RLIST_REGS table has D at rval 8, but the mapping code
checked `rn == 8` for PC (should be rval 7). PC and D indices were swapped
in the bit-mapping logic.

**Fix:** insn_funcs.py -- corrected rval→bit mapping:
  rn==7 → PC ($80), rn==8 → D ($06 = A|B), rn==9 → S ($40)

**Status:** Fixed July 2026. `PSHS D` and `PULS D` now produce correct
output identical to `PSHS A,B` and `PULS A,B`.

Discovered: via XRoar test output -- print_retaddr.asm printed `$$`
instead of hex addresses. The bug caused `PSHS D` to push PC instead
of saving the return address, corrupting the stack frame.

---

## cocotools Validation Against asm6809

July 16 2026 -- cocotools and Ciaran's asm6809 2.12 produced byte-for-byte
identical output assembling print_retaddr.asm with 6309 mode enabled.

asm6809 also warns on [,-S] as "illegal indirect indexed mode" --
independently confirming W2000 diagnostic is correct.

TFR 0,D in 6309 mode = $1F $C0 confirmed by both assemblers.
