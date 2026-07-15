# CLAUDE_MANIFESTO.md
# Project continuity file — paste this at the start of a new conversation
# Last updated: July 15 2026 (session: XRoar debug exports, cocotools PSHS D fix,
#   source diagnostic pass, lwasm audit briefing, print_retaddr demo, writing style notes)
#   COMTRAN TEN reference, book Ch02/Ch03, GitHub Pages, screenshot workflow)
# Renamed from CLAUDE_CONTEXT.md -- more intentional name, this is a
# philosophy document, not just context.

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
OS-9 structure, and CoCo hardware at a level that reading about them doesn't
produce. The book exists because explaining something requires understanding
it more completely than using it does. Each activity deepens the other.

The disassembled binaries -- SuperComm, dir, flames.bin -- are examples and
test cases, not deliverables. They're the homework problems that forced genuine
understanding.

**The actual deliverables are:**
1. **dis6x09.py** -- a general 6809/6309 disassembler for any binary format
2. **The Python cocotools toolkit** -- self-contained replacement for platform-
   specific binaries (lwasm, toolshed, decb)
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

## GitHub Authentication

Daniel provides a base64-encoded, REVERSED token at session start.
Decode and reverse it, configure git:

```python
import base64, subprocess, os
t = base64.b64decode('TOKEN_HERE').decode().strip()[::-1]
home = os.path.expanduser('~')
with open(f'{home}/.git-credentials', 'w') as f:
    f.write(f'https://erroneus0-ops:{t}@github.com\n')
subprocess.run(['git', 'config', '--global', 'credential.helper', 'store'])
subprocess.run(['git', 'config', '--global', 'user.email', 'claude@anthropic.com'])
subprocess.run(['git', 'config', '--global', 'user.name', 'Claude'])
```

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

## SuperComm22 Status (example binary -- not a primary goal)

**BYTE-PERFECT** -- assembles to exact match of original binary including CRC.
This was the first test case that validated basic OS-9 module handling.
It does not prove general disassembler correctness -- OS-9's rigid structure
makes it an easy target. Subsequent binaries revealed gaps.

```
python dis6x09.py --proj supercomm22.json -n
python prepasm.py supercomm22_proj.dasm /tmp/sc22.asm
python asm6809.py /tmp/sc22.asm /tmp/sc22.bin
# CRC verification -> BYTE-PERFECT
```

forced_equs: $3BC5, $3F3A (genuine mid-instruction overlaps from indirect branches)

---

## dir Binary Status (example binary -- analysis paused)

1728 bytes, OS-9 Level II `dir` command.
Analysis stalled as the book became the stronger learning vehicle.
The BSS map and key labels below represent work done -- not lost, just paused.
Resume only if there is a specific reason to do so.
NitrOS-9 additions confirmed: wildcard matching, -d/-f/-c/-a/-s/-l options
added to original Microware dir which only had -e and -x.

### BSS Map (confirmed)

| Offset | Name | Description |
|--------|------|-------------|
| $00 | BSS.DirPath | path number for directory opened |
| $01 | BSS.CWDPath | path for CWD (opened when extended mode) |
| $02 | BSS.NextDir | pointer to current directory path string |
| $04 | BSS.BufPtr | end-of-token pointer in command line |
| $06 | BSS.PatPtr | wildcard pattern string pointer |
| $08 | BSS.DirCount | flag: set by -c option |
| $09 | BSS.MatchFlag | Sub_0317 result: 1=match 0=no match |
| $0A | BSS.ColFlag | set when entry written to current line |
| $0B | BSS.AnyFlag | OR of ExtFlag|DirOnly|FileOnly |
| $0C | BSS.PatFlag | wildcard pattern specified |
| $0D | BSS.ExtFlag | set by -e or -l: extended listing mode |
| $0E | BSS.DirOnly | set by -d: dirs only |
| $0F | BSS.FileOnly | set by -f: files only |
| $10 | BSS.ColWidth | 0=single column, 1=multi-column |
| $11 | BSS.LastCol | terminal width (default $50=80) |
| $12 | BSS.ColmPos | remaining columns on current line |
| $13 | BSS.DENameLen | filename length after FCS->CR reformat |
| $15 | BSS.PatTmp | temp char in Sub_0317 |
| $17 | BSS.OpenMode | I$Open mode byte |
| $25 | BSS.PathBuf | output buffer for path display |
| $58 | BSS.DEName | RBF dir entry buffer (32 bytes from I$Read) |
| $75 | BSS.DENend | last byte of FCS name / CR terminator |
| $76 | BSS.wLSN0 | working LSN high byte |
| $77 | BSS.wLSN1 | working LSN middle byte |
| $78 | BSS.wLSN2 | working LSN low byte |
| $79 | BSS.$79 | purpose unknown |
| $7A | BSS.DotChar | dot-file filter (init='.', cleared by -a) |

### Key Labels

| Address | Label | Description |
|---------|-------|-------------|
| $0011 | Init | program entry point |
| $002D | CLinPars | command line parse loop |
| $0214 | Sub_0214 | option parser |
| $0274 | Sub_0274 | path/pattern argument parser |
| $0317 | Sub_0317 | wildcard pattern matcher |
| $035F | Sub_035F | conditional uppercase |
| $036E | Loc_036E | extended listing formatter |
| $041A | Sub_041A | decimal digit formatter |
| $042B | Sub_042B | byte to two hex digits |
| $0442 | Sub_0442 | leading space trimmer |
| $0451 | ErrExit | error/exit handler |
| $06A7 | WritBLines | write multiple lines utility |

### Pending dir Work
- Continue annotating $0274 onward (path/pattern parser)
- Sub_0317 wildcard matcher
- Sub_035F case logic -- -c flag behavior
- Loc_036E extended listing formatter
- $D3 error code -- is this standard OS-9 RBF EOF?

---

## Book: Structure and Status

Target: CoCo 2, ECB 1.1, DECB environment
Style: Leventhal-influenced -- why before what, direct "you", plain voice
See: documentation/book/BOOK_OUTLINE.md for full chapter map

### Chapter 1: Humble Beginnings -- DRAFT EXISTS (ch01_draft.md)

- BASIC type-in listing first (two-column Markdown table, decimal only)
- "Good times." opener
- Assembly language introduced -- no instructions shown yet
- Pseudocode outline of program shape
- Mnemonic discussion includes Spanish angle (no localized assembly mnemonics exist)
- Ends with question leading into chapter 2
- VDG: green-on-black is CoCo default; bit 6 set = dark-on-green (NOT inverted)

### Chapter 2: The Six Concepts (SIX SECTIONS)

Assembly listing revealed section by section. Each section = one concept.
See BOOK_OUTLINE.md for line-by-line reveal map.

1. Data Movement -- EQU names, LDA/STD/LDD, addressing modes
2. Arithmetic -- assembler-time EQU expressions, DECB, ORG
3. Logic -- ANDA/ORA, VDG encoding fully explained
4. Compare and Branch -- CMPA/BEQ/BNE/BRA, POLCAT polling loop
5. Stack and Subroutines -- BSR/JSR/RTS, PrintStr subroutine
6. Indexed Addressing -- LEAY/LDA,Y+/STA,X+, PCR for PIC

End of Ch2 "Playing With It": VARPTR/name patch experiment -- player inputs
name, BASIC uses VARPTR to find string data address, POKEs into machine code
to personalize greeting. Demonstrates self-modifying code gently.

### Chapter 3: The Number Guessing Game (INCREMENTAL BUILD)

Starts mostly BASIC, ends mostly assembly. Six stages:

- Stage 1 (current GUESS.ASM): compare only in ML, BASIC does everything else
- Stage 2: ML takes screen (CLRSCR + header display)
- Stage 3: ML handles result messages with cursor positioning
- Stage 4: ML displays guess count (decimal output routine)
- Stage 5: ML owns game loop (POLCAT replaces INPUT)
- Stage 6: BASIC only does RND(100) + POKE secret + one EXEC

COMTRAN TEN story told in ch3: personal account of hand-translating mnemonics
to hex for unfamiliar machine, writing guessing game. Triple purpose:
connection, foreshadow hand compilation, universality.

### HELLO_book.ASM (55 lines, final form)

Includes: HelloLen EQU Hello_end-Hello, WorldLen, ProgramEnd EQU *,
CodeSize EQU ProgramEnd-Start, END Start

### Hand Compilation (Appendix/Interlude)

Show process: take instructions, look up opcodes, write bytes, verify against
DATA statements from ch1. Closes loop from COMTRAN TEN story.

### Writing Style Notes

Reference: Leventhal 6809 Assembly Language Programming book (scanned at
https://colorcomputerarchive.com/repo/Documents/Books/6809%20Assembly%20Language%20Programming%20(Lance%20Leventhal).pdf
and at https://archive.org/details/6809_Assembly_Language_Programming_by_Lance_Leventhal)
Aim for: direct, plain, trusts the reader.

**The actual test, not a blacklist:** none of the words or constructions
below are forbidden. Each one is the correct choice in some sentence.
The failure isn't the word -- it's deploying it without checking whether
its specific flavor actually fits the thing being described. This is the
same principle as picking "relative offset" vs. "branch vector" vs.
"dynamically computed address" for the same byte (see Terminology
Variety, below) -- three correct terms, each earning its place by
matching a specific aspect of the moment. A tic is what happens when
that check gets skipped: the word shows up because it's available and
sounds right, not because this particular sentence needed its particular
weight. "Let's delve into whether this returned zero" is the failure
mode exactly -- "delve" carrying its full connotation of effortful depth,
aimed at a fact with no depth to plumb at all.

**Named categories to check against** (so the rule generalizes past any
one example sentence -- if a new instance doesn't match any category
below, that's a sign the category list needs a new entry, not that the
instance is fine):

- Sycophantic openers -- "That's a great question!", "Excellent point!"
- Emphatic affirmations used as filler, not agreement -- "Absolutely!",
  "Exactly!" deployed as rhythm rather than because something specific
  is being affirmed
- Pseudo-empathetic affirmations -- "I completely understand your
  concern" doing the *shape* of empathy without any actual content
  specific to what was said
- Hedging phrases -- "It's important to note that...", "I have to be
  honest..." -- used as throat-clearing rather than because a real
  caveat follows
- Overused vocabulary -- delve, tapestry, nuanced, multifaceted,
  landscape, foster, leverage, robust, streamline, holistic -- fine
  words, wrong this often
- Filler transitions -- "Furthermore," "Moreover," -- connective tissue
  added to pad rhythm, not because one sentence actually follows from
  the last
- Performed enthusiasm / dramatic-reading cadence -- short punchy
  sentences with em-dashes built for impact rather than clarity.
  Symptom sentence, still the clearest example: "Forty-nine lines. The
  program is complete."

**Quick check before finalizing any passage:** for each of the categories
above that shows up, ask whether this specific instance was selected
because it's the correct flavor for this specific fact, or because it's
available and sounds confident/warm/impactful. Keep the former. Cut or
replace the latter.

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

If after genuinely exhausting available tools there is still no path to an
answer, say so briefly -- one sentence, no elaboration on why.

The "I don't have real-time information" class of response is almost always
wrong and should be suppressed in favor of actually trying first.

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

## Screenshot Workflow (July 2026)

Screenshots are pushed to `screenshots/` folder in the repo.
`make_screenshot_index.py` (repo root) generates `screenshots/index.html`
-- a browsable listing of all image files. Run automatically by
`git_update.bat` before each commit.

**For Claude:** check `screenshots/` via `git pull` when contextually
relevant. The index at `screenshots/index.html` lists current files with
timestamps. New files can be fetched via GitHub Pages URL:
`https://erroneus0-ops.github.io/SuperComm-disassembled/screenshots/`

---

## COMTRAN TEN Reference (July 2026)

Complete instruction reference built from KDA-3032 (USAF, June 1981).
Public domain (U.S. Government work, 17 U.S.C. § 105).
Source PDF: `screenshots/KDA-3032_Digiac_COM-TRAN_TEN_Training_Jun81.pdf`

Files in `documentation/comtran10/`:
- `comtran10_instructions.json` -- all 44 instructions with descriptions,
  notes, and examples
- `comtran10_instructions.html` -- full reference with How to Read guide,
  opcode format section, inline notes, examples, quick-reference tables
- `comtran10_opcode_map.html` -- interactive 16x16 decode map with:
  - Color-coded by functional group
  - Group toggle filter (per-cell)
  - Builder mode: click column/row headers to select page/index and
    instruction; address input box for 8-bit or 10-bit address;
    outputs two-byte opcode pair
  - Column width normalization

**Key facts for future sessions:**
- 44 instructions, 6 groups: load(7), store(3), arithmetic(7),
  logical(7), branch(11), I/O(9)
- Every instruction is exactly 2 bytes: opcode + operand
- Memory instructions: bits 7-3 = instruction, bits 2-0 = address modifiers
  (bit 2 = index, bits 1-0 = page 0-3)
- Non-memory instructions: all 8 bits = instruction identity
- `%000xxxxx` range ($00-$1F) is almost entirely non-memory instructions;
  FLC ($28) and FLS ($F8) are also non-memory but live outside this range
- The Countdown Register (C) is exclusively an I/O transfer counter --
  NOT a general-purpose loop register. Set with LC1,k before WDB/RDB/etc.
- 10-bit address space ($000-$3FF), 4 pages of 256 bytes each
- Page encoding: adding 1/2/3 to the base opcode selects pages 1/2/3

---

## Book Status (July 2026)

### Chapter 1 (ch01_draft.md) -- COMPLETE DRAFT
Recent fixes: closing question reframed from "special handling" to
choice-and-control framing. Typo fixed. Leads cleanly into Ch02.

### Chapter 2 (ch02_draft.md) -- COMPLETE DRAFT
Recent fixes:
- VDG/ROM paragraph rewritten: "The Color BASIC ROM builds on that
  foundation. Programs you write in BASIC build on those routines."
- HELLO/WORLD! contrast reframed: direct writes give control the ROM
  does not -- programmer's choice, not special handling
- Stale WriteSpace/StoreChar code and explanation removed (special-case
  was eliminated from actual HELLO.ASM in prior session)
- Partial listing updated to match current program structure
- AI pattern language cleaned throughout

### Chapter 3 (ch03_draft.md) -- DRAFT STARTED
Structure:
1. Arithmetic section: HELLO_POS/WORLD_POS/EXIT_POS EQU expressions,
   assembler-as-calculator concept, ORG 0 introduced. Updated partial
   listing with arithmetic lines filled in.
2. COMTRAN TEN story as hinge ("Before Going Further")
3. "A New Program" -- guessing game introduced (4-line description),
   establishes it as vehicle for remaining chapters

### HELLO.ASM -- CURRENT STATE
- `ORA #$40` applied uniformly to ALL characters including space
- No WriteSpace special case (removed)
- Both HELLO and WORLD! display in normal video (black on green)
- `ORG 0` for position-independent code
- All stale comments removed and corrected

### VDG Character Set (confirmed, corrected understanding)
- First set ($00-$3F): green on black (light on dark) -- Color BASIC
  uses this deliberately for lowercase display (inverted stand-ins)
- Second set ($40-$7F): black on bright green (dark on light, "normal")
  -- Color BASIC uses this for uppercase display
- This program uses ORA #$40 (second set) to match BASIC's convention
- Space: ASCII $20, through ANDA #$3F = $20, OR #$40 = $60. Works
  uniformly with same logic as all other characters. No special case needed.

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

## 6809 Opcode Reference -- Indexed Postbyte Page (July 3 2026)

`documentation/html/groups/indexed_postbyte.html` -- new reference page:
- Bit-map table showing every postbyte mode as explicit bit fields
  (r/R/R/i/m/m/m/m header row)
- Section dividers: register select, 5-bit offset, standard indexed,
  indirect variants
- Worked example: `STA ,-X` → `$A7 $82` shown as OR of register field
  ($80) and mode field ($02)
- Encoding examples table (renamed from "hand assembly examples")
- `LDA $100,X` example showing 16-bit offset mode ($A6 $89 $01 $00)
- Contenteditable notes cells with "Collect Notes as CSV" button
- Linked from nav bar of every group page that has indexed mode instructions
- Generator skips postbyte JSON in group loader (different schema)

Key insight for the book: postbyte = bitwise OR of register field and mode
field. Non-overlapping bit positions, mechanical derivation, no lookup needed
once the table is understood. This is what makes hand-assembly possible but
also illustrates exactly why you use an assembler for anything real.

### Pending: postbyte hint in opcode group pages
Inject a compact bit-field line + link to postbyte page for any instruction
that has an indexed mode entry. The note shows the bit pattern and links
to the full postbyte reference. Generator should do this automatically.

---

## Hand Assembly Document (PENDING)

Fill-screen routine as teaching exercise:
- Forward version (STA ,X+): fills $0400-$05FF forward
- Backward version (STA ,-X): fills $05FF-$0400 backward
- Both are PIC (no self-references) but operate on fixed hardware addresses
- Hand-assembly exercise: derive hex bytes from postbyte table + opcode reference
- "Chaos experiment": load code at $0400 (screen memory start) and EXEC it
  -- code overwrites itself as it fills, spectacular undefined behavior
  Backward version is more interesting: fills toward $0400, overwrites
  itself last, might survive long enough to complete

Purpose of exercise: NOT to teach hand assembly as practice, but to show
exactly what the assembler does on your behalf. Done once, understood forever.
BASIC trick to hold screen: `?@32` positions cursor off-screen so BASIC's
"OK" prompt doesn't overwrite the result (simpler than `20 GOTO 20` loop).


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

## PENDING: CC Register Deep Dive (Chapter 4)

The hand assembly exercise introduced the CC register at a functional level.
A full treatment belongs in Chapter 4 (Compare and Branch) covering:

- Full bit layout: E F H I N Z V C
- Three update categories:
  - **Passive observation** -- N, Z watching the data bus as a byproduct
    of data movement (e.g. LDX updates N and Z without explicit comparison)
  - **Active assertion** -- V cleared on load because the operation
    semantics guarantee no overflow is possible
  - **Explicit manipulation** -- I, F written by instructions whose
    purpose is CC management (ANDCC, ORCC, etc.)
- Signed vs unsigned interpretation and how it affects branch selection
  (BNE is interpretation-independent; BGT vs BHI are not)
- Using CC side effects to avoid explicit compares in tight code
- The passive/active distinction as a hardware insight: CC logic watches
  specific signal lines rather than executing a separate evaluate step

Daniel's observation: CC updates on load instructions suggest the CC
logic is observing bus traffic passively -- N and Z are byproducts of
data movement, not results of a separate comparison operation.

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

## Unravelled Series -- OCR Conversion (PENDING)

The Color BASIC Unravelled series (Spectral Associates) exists in the repo
as OCR'd PDFs. The OCR quality is variable -- sufficient for human reading
but unreliable for programmatic processing. This was at least partly why
a search for the SOUND ROM entry point failed in one session despite the
answer being present in the document.

**Goal:** Convert the Unravelled PDFs to clean plain text, preserving:
- ROM address labels and hex values
- Assembly source lines
- Comments and annotations
- Table structure where present

**Why this matters:**
- Makes the ROM reference searchable by Claude without PDF parsing uncertainty
- Enables future tooling that cross-references ROM entry points automatically
- Preserves the content in a durable, portable format independent of PDF readers
- The Unravelled series is effectively the CoCo ROM source -- it belongs in
  the same toolchain as the disassembler and book

**Books to convert:**
- Color BASIC Unravelled (BAS ROM -- $A000 area)
- Extended Color BASIC Unravelled (EXTBAS ROM -- includes SOUND at $A94B)
- Disk BASIC Unravelled (DECB ROM)
- OS-9 Level II Unravelled (OS-9 kernel)

**Source PDFs:** available at https://techheap.packetizer.com/computers/coco/unravelled_series/

**Note for Claude:** When a ROM entry point or BASIC routine address is needed,
check the Unravelled text files FIRST and search thoroughly before declaring
the information absent. The answer is almost certainly there.

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
