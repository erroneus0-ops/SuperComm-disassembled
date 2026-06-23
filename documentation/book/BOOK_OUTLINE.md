# Book Outline: Progressive Reveal Map

The assembly listing is revealed section by section across chapters.
Each chapter introduces one concept and reveals the relevant source lines.
The complete annotated listing appears at the end.

---

## Chapter 1: Humble Beginnings

- BASIC type-in listing (the hook)
- The shape of the program in pseudocode — labels and plain English
- What assembly language is and why mnemonics exist
- No assembly instructions revealed yet
- Ends with a question: why does HELLO need special handling?

---

## Chapter 2: Data Movement

**Concept:** Loading values into registers, storing them to memory.
Addressing modes — immediate, direct page, extended, indexed.

**Lines revealed:**
```
  1  POLCAT    EQU     $A000          ; names for fixed ROM addresses
  2  CHROUT    EQU     $A002
  3  CLRSCR    EQU     $A928
  4  CURPOS    EQU     $0088          ; BASIC cursor register
  5  SCREEN    EQU     $0400          ; VDG text screen base
  6  COLS      EQU     32

 12            JSR     CLRSCR         ; call ROM to clear screen
 13            LDX     #HELLO_POS     ; immediate: load address into X
 15            LDB     #6             ; immediate: load counter into B
 24            LDA     #$60           ; immediate: load VDG space code
 26            STA     ,X+            ; indexed: store to screen, advance X
 29            LDD     #WORLD_POS     ; immediate 16-bit: load cursor address
 30            STD     <CURPOS        ; direct page: store to BASIC cursor register
 33            LDD     #EXIT_POS      ; immediate 16-bit
 34            STD     <CURPOS        ; direct page
```

**VDG display introduced here:** the screen is not ASCII, each byte is a
character cell, write a byte and it appears immediately.

---

## Chapter 3: Arithmetic

**Concept:** The assembler as a calculator. Runtime arithmetic.

**Lines revealed:**
```
  7  HELLO_POS EQU     SCREEN+(7*COLS)+10    ; assembler computes $04EA
  8  WORLD_POS EQU     SCREEN+(7*COLS)+16    ; assembler computes $04F0
  9  EXIT_POS  EQU     SCREEN+(13*COLS)+0    ; assembler computes $0560

 10            ORG     0              ; position independent code introduced
 27            DECB                   ; runtime: decrement loop counter
```

**Key insight:** the assembler computed the screen positions before producing
a single byte of code. The CPU only ever sees the answers.

---

## Chapter 4: Logic

**Concept:** AND, OR — clearing and setting bits. The VDG encoding explained.

**Lines revealed:**
```
 20            ANDA    #$3F           ; strip bits 7-6: ASCII to VDG code
 21            ORA     #$40           ; set bit 6: normal to alternate display
```

**The VDG encoding fully explained here:** green-on-black is the default,
bit 6 set gives dark-on-green. `ANDA #$3F` converts ASCII letter to VDG code.
`ORA #$40` selects the display mode. The result is visible on screen.
Space is the special case — its VDG code (`$60`) already has bit 6 set,
which is why line 24 loads it directly rather than converting.

---

## Chapter 5: Compare and Branch

**Concept:** Condition codes, conditional branches, unconditional branches.
The decision-making machinery.

**Lines revealed:**
```
 17            LDA     ,Y+            ; indexed: load char from string, advance Y
 18            CMPA    #' '           ; compare A to space — sets flags, no result
 19            BEQ     WriteSpace     ; branch if equal (zero flag set)
 22            BRA     StoreChar      ; branch always (unconditional)
 28            BNE     WriteHello     ; branch if not equal (loop back)
 36            JSR     [POLCAT]       ; indirect call: poll keyboard
 37            BEQ     WaitKey        ; loop if A=0 (no key pressed)
```

**Jump table indirect addressing introduced here:** `JSR [POLCAT]` vs
`JSR POLCAT` — calling through a vector vs calling directly.

---

## Chapter 6: Stack and Subroutines

**Concept:** The hardware stack, JSR/RTS, BSR/RTS. Subroutine structure.

**Lines revealed:**
```
 32            BSR     PrintStr       ; branch to subroutine (PC-relative)
 38            RTS                    ; return from main code to BASIC

 39  PrintStr                         ; subroutine entry point
 40            LDA     ,X+            ; load char, advance X
 41            BEQ     PrintDone      ; null terminator check
 42            JSR     [CHROUT]       ; call ROM character output via vector
 43            BRA     PrintStr       ; loop
 44  PrintDone
 45            RTS                    ; return to caller
```

**BSR vs JSR explained:** BSR uses a PC-relative offset (position independent),
JSR uses an absolute address. Both push a return address and jump.

---

## Chapter 7: Indexed Addressing

**Concept:** The full indexed addressing mode — registers, auto-increment,
auto-decrement, offsets, PC-relative. The 6809's most powerful feature.

**Lines revealed:**
```
 14            LEAY    Hello,PCR      ; PC-relative: load address of string data
 17            LDA     ,Y+            ; post-increment: load and advance
 26            STA     ,X+            ; post-increment: store and advance
 31            LEAX    World,PCR      ; PC-relative: load address of string data
 40            LDA     ,X+            ; post-increment in PrintStr
```

**Position independent code fully explained:** why `LEAY Hello,PCR` works
regardless of where the program is loaded, while `LDY #Hello` would not.

---

## Final Listing: The Complete Program

The complete annotated source, assembled from all seven chapters.
Introduces assembler directives and assembly-time expressions not seen before:

```
 46  Hello     FCC     "HELLO "       ; Form Constant Characters
 47  Hello_end                        ; label marks end of Hello string
 48  HelloLen  equ     Hello_end-Hello  ; assembler computes string length

 49  World     FCC     "WORLD!"
 50  World_end
 51  WorldLen  equ     World_end-World

 52            FCB     0              ; null terminator for PrintStr

 53  ProgramEnd equ    *              ; current address = end of program
 54  CodeSize  equ     ProgramEnd-Start  ; total program size

 55            END     Start
```

**Assembler arithmetic revisited:** `Hello_end - Hello` computes the string
length at assembly time. If the string changes, the length adjusts automatically.
`ProgramEnd - Start` gives the total byte count. These are not runtime values —
they exist only during assembly.

Full source with comments explaining each section in terms of all six concepts.

---

## Appendix: The Complete Listing (Reference)

The full 6809 assembly source with all comments, all directives, line numbers.
This is the reference copy — everything in one place for the reader who has
completed all seven chapters and wants the program in its entirety.

---

## Chapter 3: The Number Guessing Game

A second complete program, building on everything from chapters 1 and 2.
Introduces new concepts while using familiar structure.

### New Concepts

- **Signed comparison** — higher/lower requires different branch instructions
  than equality. `CMPD` with `BGT`/`BLT` vs `BEQ`/`BNE`.
- **Persistent loop** — program does not return to BASIC until player wins.
  A loop that spans the entire program execution.
- **Calling BASIC ROM math** — RND() is in ROM, reachable from assembly.
  The relationship goes both directions: BASIC launches machine code,
  machine code uses BASIC's routines.
- **Simple decimal output** — displaying the guess count introduces
  divide-by-10 and digit extraction.

### The COMTRAN TEN Story

Brief personal account: an unfamiliar machine, a table of mnemonics,
translating by hand on paper to hex, keying it in, making it work.
A guessing game was the program then too.

Three purposes:
1. Personal connection — this is how the author first understood that
   machine code is just numbers with meaning attached
2. Foreshadow hand compilation — you did it by hand. The reader is
   about to learn exactly what you did and why it works.
3. Universality — the concepts transfer. A guessing game is a guessing
   game on any machine. The mnemonics change. The ideas do not.

### "Playing With It"

Change the range. Change the number of allowed guesses. Add a message
for winning quickly vs. taking many tries. The reader now has enough
understanding to make these changes without retyping everything.

---

## Hand Compilation (Appendix or Chapter 4 interlude)

After the reader understands assembly language — its mnemonics, its
addressing modes, its structure — a section on hand compilation closes
the loop between the concept and the DATA statements they typed in
chapter 1.

Show the process: take a short sequence of instructions, look up each
opcode and addressing mode in a table, write down the bytes. Then verify
against the DATA statements from chapter 1. The reader sees that those
80 numbers are not magic — they are the direct mechanical result of a
process they can now perform themselves.

This is what was done on the COMTRAN TEN. It is what programmers did
before assemblers were widely available. Understanding it makes the
assembler's job obvious — and makes the reader appreciate both the
tedium it replaces and the clarity it provides.
