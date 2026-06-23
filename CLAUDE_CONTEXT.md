# CLAUDE_CONTEXT.md
# Project continuity file — paste this at the start of a new conversation
# Last updated: end of session (June 23 2026)

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
| cocotools/lwasm.py | DONE | Phase 1 complete — GUESS.ASM + HELLO.ASM byte-perfect vs lwasm |
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
