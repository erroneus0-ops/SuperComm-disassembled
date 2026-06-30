# CLAUDE_MANIFESTO.md
# Project continuity file — paste this at the start of a new conversation
# Last updated: end of session (June 30 2026)
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

Two parallel tracks:
1. Reverse-engineering SuperComm v2.2 (OS-9 Level II terminal/comms program)
   toward byte-perfect reassembly
2. Writing a 6809 assembly language book for the CoCo DECB environment,
   with a companion Python toolkit replacing platform-specific binaries

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

## SuperComm22 Status

**BYTE-PERFECT** -- assembles to exact match of original binary including CRC.

```
python dis6x09.py --proj supercomm22.json -n
python prepasm.py supercomm22_proj.dasm /tmp/sc22.asm
python asm6809.py /tmp/sc22.asm /tmp/sc22.bin
# CRC verification -> BYTE-PERFECT
```

forced_equs: $3BC5, $3F3A (genuine mid-instruction overlaps from indirect branches)

---

## dir Binary Status

**ACTIVE ANALYSIS.** 1728 bytes, OS-9 Level II `dir` command.
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

Avoid: short punchy sentences with em-dashes, performed enthusiasm,
"Forty-nine lines. The program is complete." style (AI dramatic-reading).
Aim for: direct, plain, trusts the reader.
Reference: Leventhal 6809 Assembly Language Programming book (scanned at
https://colorcomputerarchive.com/repo/Documents/Books/6809%20Assembly%20Language%20Programming%20(Lance%20Leventhal).pdf
and at https://archive.org/details/6809_Assembly_Language_Programming_by_Lance_Leventhal)

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
