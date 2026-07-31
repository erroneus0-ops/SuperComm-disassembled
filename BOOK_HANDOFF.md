# Book Handoff

This file holds everything specific to **the book** -- the 6809 assembly
teaching book built around a running CoCo2/Extended Color BASIC 1.1/DECB
example. Extracted out of CLAUDE_MANIFESTO.md (2026-07-31) as part of
splitting project-specific content into its own dedicated handoff,
separate from the manifesto's general, project-agnostic behavior/style
guidance and the Environment and Tools handoffs.

Full chapter map: `documentation/book/BOOK_OUTLINE.md`.

Status as of the split: Chapters 1 and 2 are complete drafts. Chapter 3
(the incremental number-guessing game) has its structure defined and a
draft started, not finished. The book hasn't advanced further since --
it's genuinely just waiting for Daniel to be inspired to write more, not
blocked on anything.

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

