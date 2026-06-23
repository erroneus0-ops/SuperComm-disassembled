# CLAUDE_CONTEXT.md
# Project continuity file — paste this at the start of a new conversation
# Last updated: by Claude at end of session

## Project Overview

Reverse-engineering SuperComm v2.2 (OS-9 Level II terminal/comms program) toward
byte-perfect reassembly. Secondary goal: 6809 assembly language book.

**Repo:** https://github.com/erroneus0-ops/SuperComm-disassembled
**Daniel's local:** C:\DATA\supercomm (work) and D:\git\supercomm (home)
**Claude's local:** /home/claude/SuperComm/ (cloned fresh each session)

**Daniel's pseudonym:** 三浦按針 (Miura Anjin / Anjin Miura)

---

## Pushing from Claude's Environment

At the start of each session, Daniel provides a base64-encoded, reversed GitHub
token. Decode and reverse it, then configure git:

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

## Key Files

    dis6x09.py              main disassembler (6809/6309)
    markup.py               applies analyst annotations to JSON
    prepasm.py              strips .dasm to assembleable .asm
                            also converts BSS EQU → RMB
    asm6809.py              internal assembler/validator
    compare_bins.py         binary comparison

    dir                     VHD-extracted dir binary (1728 bytes)
    dir_proj.json           dir project -- active analysis
    dir_proj.dasm           dir disassembly listing

    supercomm22             SuperComm v2.2 binary (17861 bytes)
    supercomm22.json        SuperComm project -- byte-perfect
    supercomm22_proj.dasm   SuperComm listing

    supercomm21             SuperComm v2.1 binary -- corrupt CRC
    supercomm21.json        minimal project, not fully annotated

    mdir, mdir.asm, mdir.hlp    NitrOS-9 mdir binary with source

    documentation/
      generate.py           generates HTML opcode reference
      opcodes/              12 JSON files, 131 instructions total
      html/                 generated HTML reference site
      book/
        ch01_humble_beginnings/
          HELLO.ASM         fully annotated source
          HELLO_book.ASM    stripped 49-line numbered listing
          HELLO_numbered.ASM  annotated with line numbers
          HELLO.BAS         BASIC loader (POKE to $3F00, EXEC)
          HELLO.DSK         CoCo DSK image (HELLO.BIN + HELLO.BAS)
          HELLO.BIN         DECB binary
          ch01_draft.md     chapter 1 first draft (restructured)
          assemble.py       Python assembler for Hello World

---

## Toolchain & Workflow

```
# Disasm pass (NPP Run command):
cmd /c cd /d $(CURRENT_DIRECTORY) && python dis6x09.py --proj $(NAME_PART).json -n --markup

# Markup pass (NPP Run command):
cmd /c cd /d $(CURRENT_DIRECTORY) && python markup.py $(NAME_PART).dasm $(NAME_PART).json
```

File extensions:
- `.dasm` — disassembler output, not directly assembleable, edit annotations here
- `.asm`  — prepasm.py output, assembleable by lwasm

BSS format in JSON (unified since refactor):
```json
"bss": {
  "88": {"name": "BSS.DEName", "comment": "29-byte filename field"}
}
```

---

## SuperComm22 Status

**BYTE-PERFECT** — assembles to exact match of original binary including CRC.

```
python dis6x09.py --proj supercomm22.json -n
python prepasm.py supercomm22_proj.dasm /tmp/sc22.asm
python asm6809.py /tmp/sc22.asm /tmp/sc22.bin
# CRC verification produces BYTE-PERFECT
```

forced_equs: $3BC5, $3F3A (genuine mid-instruction overlaps from indirect branches)

---

## dir Binary Status

Active analysis in progress. 1728 bytes, OS-9 Level II `dir` command.
NitrOS-9 additions confirmed: wildcard matching, -d/-f/-c/-a/-s/-l options
were added to the original Microware dir which only had -e and -x.

### BSS Map (confirmed)

| Offset | Name | Description |
|--------|------|-------------|
| $00 | BSS.DirPath | path number for directory opened for reading |
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
| $13 | BSS.DENameLen | filename length after FCS→CR reformat |
| $15 | BSS.PatTmp | temp char in Sub_0317 |
| $17 | BSS.OpenMode | I$Open mode byte |
| $25 | BSS.PathBuf | output buffer for path display |
| $58 | BSS.DEName | RBF directory entry buffer (32 bytes from I$Read) |
| $75 | BSS.DENend | last byte of FCS name / CR terminator position |
| $76 | BSS.wLSN0 | working LSN high byte (shifted from $75 before reformat) |
| $77 | BSS.wLSN1 | working LSN middle byte |
| $78 | BSS.wLSN2 | working LSN low byte |
| $79 | BSS.$79 | purpose unknown |
| $7A | BSS.DotChar | dot-file filter (init='.', cleared by -a) |

### Key Labels

| Address | Label | Description |
|---------|-------|-------------|
| $0011 | Init | program entry point |
| $002D | CLinPars | command line parse loop |
| $0214 | Sub_0214 | option parser (-e -s -d -f -x -c -a) |
| $0274 | Sub_0274 | path/pattern argument parser |
| $0317 | Sub_0317 | wildcard pattern matcher |
| $035F | Sub_035F | conditional uppercase for case-insensitive match |
| $036E | Loc_036E | extended listing formatter |
| $041A | Sub_041A | decimal digit formatter |
| $042B | Sub_042B | byte to two hex digits |
| $0437 | Sub_0437 | nibble to hex ASCII |
| $0442 | Sub_0442 | leading space trimmer |
| $0451 | ErrExit | error/exit handler ($D3=normal EOF, else error) |
| $06A7 | WritBLines | write multiple lines utility |

### RBF Directory Entry Structure (32 bytes from I$Read)

The dir program reads 32-byte RBF directory entries. After reading, it
pre-shifts the 3-byte LSN one position to make room for CR terminator:

- Bytes 0-28: filename in FCS format (last char has bit 7 set)
- Byte 29: LSN high byte (BSS.DENend/$75 — overwritten by CR after reformat)
- Byte 30: LSN middle byte (BSS.wLSN0/$76 — shifted here before reformat)
- Byte 31: LSN low byte (BSS.wLSN1/$77)
- Beyond: BSS.wLSN2/$78 receives old $77 value

Working structure after shift:
- $58-$75: CR-terminated filename string
- $76-$78: 3-byte file descriptor LSN

### Open Questions

1. Sub_035F case logic — does -c mean case-sensitive or insensitive?
   TST BSS.DirCount, BNE skip_uppercase. If flag SET, skips uppercase.
   Help text says "case insensitive" — logic seems inverted.
2. BSS.$14/$16 — between DENameLen and PatTmp, purpose unknown
3. BSS.$79 — cleared at init, never seen written again
4. BSS.$18 — loaded at $0190 to check directory attribute bit
5. $D3 error code — is this standard OS-9 RBF EOF?
6. -x option (OptX: ADDB #4) — mode $09 meaning?

---

## Book: Chapter 1 — Humble Beginnings

Target: CoCo 2, ECB 1.1, DECB environment

### Program Summary

Hello World in 49 lines / 80 bytes of PIC 6809 code.
- "HELLO " written directly to VDG screen memory with ASCII→VDG conversion
- "WORLD!" written via ROM CHROUT routine
- Loaded via BASIC POKE loop to $3F00, EXEC'd

### Six Concepts Demonstrated

1. Data Movement — LDA/STD/LDX, immediate/direct page/indexed addressing
2. Arithmetic — assembler-time address calculation, DECB loop counter
3. Logic — ANDA #$3F / ORA #$40 to convert ASCII to VDG with inverted video
4. Compare and Branch — BEQ/BNE loop control, BEQ polling loop
5. Stack and Subroutines — BSR/JSR/RTS, hardware stack
6. Indexed Addressing — ,Y+ ,X+ auto-increment, PCR for PIC data

### VDG Display Notes

- CoCo default display: green characters on black background (NOT inverted)
- VDG bit 6 set = dark character on green background (the "other" mode)
- HELLO written with bit 6 set, WORLD! via CHROUT without — visually different
- ASCII to VDG: ANDA #$3F strips bits 7-6, ORA #$40 sets bit 6
- Space special case: VDG space = $60 (already has bit 6 set)

### Book Structure (Progressive Reveal)

The assembly listing is NOT shown in full in chapter 1. It is revealed
section by section across chapters 2-7, one concept per chapter.
Chapter 1 shows only the BASIC loader and a pseudocode outline.

- Ch 1: BASIC listing (hook) + pseudocode shape of program
- Ch 2: Data Movement -- EQU names, LDA/STD/LDD, addressing modes
- Ch 3: Arithmetic -- assembler-time EQU expressions, DECB, ORG
- Ch 4: Logic -- ANDA/ORA, VDG encoding fully explained
- Ch 5: Compare and Branch -- CMPA/BEQ/BNE/BRA, POLCAT polling loop
- Ch 6: Stack and Subroutines -- BSR/JSR/RTS, PrintStr subroutine
- Ch 7: Indexed Addressing -- LEAY/LDA,Y+/STA,X+, PCR for PIC
- Final: Complete annotated listing with HelloLen/WorldLen/CodeSize EQUs

See BOOK_OUTLINE.md for the full chapter map with lines revealed per chapter.

### Chapter 1 Draft Status

ch01_draft.md current version:
- BASIC listing first (two-column Markdown table)
- Plain English pseudocode outline of the program
- Assembly language introduced conceptually -- no instructions shown yet
- Ends with a question that leads into chapter 2
- No hex in introduction -- decimal only, hex deferred
- Address 16128 described as a safe place to put the code

### Writing Style Notes

Avoid: short punchy sentences with em-dashes, performed enthusiasm.
Aim for: direct, plain, trusts the reader, states things once clearly.
Reference: Leventhal style -- why before what, direct you, honest about
difficulty. See Leventhal sample text in book notes.

---

## Engine Features (dis6x09.py)

- `target`: "os9" emits mod/emod/rmb/size idioms; "raw" keeps EQU output
- `hex_offsets`: ["U"] shows hex offsets on unnamed U-relative addressing
- `--source` optional when `binary` field set in JSON
- BSS format: unified dict `{"name": "...", "comment": "..."}` — auto-migrates old format
- `prev_ret = is_ret` — separator fires after labeled RTS too
- `/bss/ $XX Name "comment"` — quoted comment replaces size annotation

## prepasm.py Features

- Converts BSS EQU → RMB with gap-based size calculation
- Preserves analyst comments on RMB lines
- Handles both "raw" (.dasm EQU style) input

## markup.py Directives (quick reference)

See the MARKUP QUICK REFERENCE at the bottom of any .dasm file.
Key ones: /label/, /bss/, /comment/…/end-comment/, /; line comment/,
/region/, /routine/, /rename-label/, /remove-comment/

---

## Notepad++ Setup

- .dasm extension: Settings → Style Configurator → ASM → User ext: add "dasm"
- Run commands:
  - Markup Pass: `cmd /c cd /d $(CURRENT_DIRECTORY) && python markup.py $(NAME_PART).dasm $(NAME_PART).json`
  - Disasm Pass: `cmd /c cd /d $(CURRENT_DIRECTORY) && python dis6x09.py --proj $(NAME_PART).json -n --markup`

---

## Pending Work

### dir Analysis
- Continue annotating $0274 onward (path/pattern parser)
- Sub_0317 wildcard matcher
- Sub_035F case logic — verify -c flag behavior
- Loc_036E extended listing formatter ($036E through $0451)
- Confirm $D3 = EOF on RBF directory read

### Engine
- Interactive trace/debugger mode (simulated 6809 for pass1 visualization)
- SAL output mode (structured assembly language) — Keith Frechette's SAL for LWTools
- "Referenced by" xref comments on code labels

### Book
- Chapter 1: Daniel to rewrite sections in his own voice as style reference
- Chapter 1: BASIC loader explanation needs VARPTR sidebar
- Chapters 2-6: one per foundational concept
- HTML format for final book output (documentation/html as template)
- Consider SAL as "next step" chapter after teaching raw assembly

---

## cocotools — Python Toolkit (NEW)

Goal: fully self-contained Python replacement for lwasm + toolshed + decb.
Enables: write ASM -> assemble in Python -> build DSK -> run in XRoar WASM,
all without platform-specific binaries. Python is everywhere.

### Files

    cocotools/
      DESIGN.md     -- architecture document, read this first
      instab.py     -- 6809 instruction table (139 instructions, verified)
      lwasm.py      -- assembler (NOT YET WRITTEN)
      decb.py       -- DSK builder (partial, needs cleanup)
      basic.py      -- BASIC tokenizer (NOT YET WRITTEN)
    cocotools.py    -- CLI entry point (NOT YET WRITTEN)

### Design Decisions

- Faithful translation of lwasm C source (GPL v3, William Astle)
  Source: http://lwtools.projects.l-w.ca/
- NOT a shortcut -- proper two-pass assembler matching lwasm behavior exactly
- Verification: byte-for-byte match against lwasm output for every program
- instab.py uses same table structure as lwasm instab.c:
  imm/dir/idx/ext/inh opcodes per instruction, None = mode not supported
  Prefixed opcodes: 0x1000 = 0x10 prefix, 0x1100 = 0x11 prefix

### Instruction Table Structure (instab.py)

  INSTAB[mnemonic] = {
    imm: opcode or None,   # immediate mode
    dir: opcode or None,   # direct page mode
    idx: opcode or None,   # indexed mode
    ext: opcode or None,   # extended mode
    inh: opcode or None,   # inherent (no operand)
    rel: opcode or None,   # relative (branches)
    parse: class_name,     # parser class: gen8/gen16/gen0/inh/rel8/etc.
  }

### Next Steps for cocotools

1. Write lwasm.py -- the assembler proper:
   - Tokenizer (parse label, mnemonic, operand, comment)
   - Expression evaluator (handles arithmetic, hex, labels)
   - Symbol table (two-pass: collect then resolve)
   - Addressing mode detection (see DESIGN.md)
   - Indexed postbyte encoder (the complex part -- see DESIGN.md)
   - Branch offset calculator
   - Directive handlers (ORG, EQU, FCB, FDB, FCC, RMB, END)
   - Output: DECB format and raw binary

2. Verify against lwasm:
   - GUESS.ASM (30 bytes, simple) -- first target
   - HELLO.ASM (80 bytes) -- second target

3. Package as cocotools.py CLI
