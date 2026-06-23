# Chapter 1: Humble Beginnings

## Type It In

This is a type-in program. That is how things worked. You found a listing in a
magazine or a book, you sat down at the keyboard, and you typed. If you made a
mistake you found it, fixed it, and ran it again. Eventually it worked.

Type this into your Color Computer:

| `10 REM HELLO WORLD      ` | `140 DATA 138,64,32,2    ` |
| `20 REM HUMBLE BEGINNINGS` | `150 DATA 134,96,167,128 ` |
| `30 REM                  ` | `160 DATA 90,38,237,204  ` |
| `40 CLEAR 200            ` | `170 DATA 4,240,221,136  ` |
| `50 A=&H3F00             ` | `180 DATA 48,141,0,33    ` |
| `60 FOR I=0 TO 79        ` | `190 DATA 141,14,204,5   ` |
| `61 READ D:POKE A+I,D    ` | `200 DATA 160,221,136,28 ` |
| `62 NEXT I               ` | `210 DATA 239,173,159,160` |
| `70 EXEC A               ` | `220 DATA 0,39,248,57    ` |
| `80 REM DATA             ` | `230 DATA 166,128,39,6   ` |
| `90 DATA 189,169,40,142  ` | `240 DATA 173,159,160,2  ` |
| `100 DATA 4,234,49,141   ` | `250 DATA 32,246,57,72   ` |
| `110 DATA 0,57,198,6     ` | `260 DATA 69,76,76,79    ` |
| `120 DATA 166,160,129,32 ` | `270 DATA 32,87,79,82    ` |
| `130 DATA 39,6,132,63    ` | `280 DATA 76,68,33,0     ` |

Type `RUN` and press Enter.

The screen clears. Centered on row seven you see:

```
        HELLO WORLD!
```

The cursor sits at row thirteen. Press any key and BASIC returns with `OK`.

That is a machine language program running on your Color Computer. The DATA
statements contain the program — 80 bytes of 6809 machine code. BASIC loaded
those bytes into memory and handed control to them. The code ran, did its work,
and handed control back to BASIC.

The rest of this chapter explains what those 80 bytes do and why.

---

## The Assembly Source

Machine language is bytes. Programmers don't write bytes directly — they write
assembly language, a human-readable notation where each instruction has a name
and each address can have a label. An assembler translates that notation into
bytes.

Here is the assembly source for the program you just ran:

```
  1  POLCAT    EQU     $A000
  2  CHROUT    EQU     $A002
  3  CLRSCR    EQU     $A928
  4  CURPOS    EQU     $0088
  5  SCREEN    EQU     $0400
  6  COLS      EQU     32
  7  HELLO_POS EQU     SCREEN+(7*COLS)+10
  8  WORLD_POS EQU     SCREEN+(7*COLS)+16
  9  EXIT_POS  EQU     SCREEN+(13*COLS)+0
 10            ORG     0
 11  Start
 12            JSR     CLRSCR
 13            LDX     #HELLO_POS
 14            LEAY    Hello,PCR
 15            LDB     #6
 16  WriteHello
 17            LDA     ,Y+
 18            CMPA    #' '
 19            BEQ     WriteSpace
 20            ANDA    #$3F
 21            ORA     #$40
 22            BRA     StoreChar
 23  WriteSpace
 24            LDA     #$60
 25  StoreChar
 26            STA     ,X+
 27            DECB
 28            BNE     WriteHello
 29            LDD     #WORLD_POS
 30            STD     <CURPOS
 31            LEAX    World,PCR
 32            BSR     PrintStr
 33            LDD     #EXIT_POS
 34            STD     <CURPOS
 35  WaitKey
 36            JSR     [POLCAT]
 37            BEQ     WaitKey
 38            RTS
 39  PrintStr
 40            LDA     ,X+
 41            BEQ     PrintDone
 42            JSR     [CHROUT]
 43            BRA     PrintStr
 44  PrintDone
 45            RTS
 46  Hello     FCC     "HELLO "
 47  World     FCC     "WORLD!"
 48            FCB     0
 49            END     Start
```

49 lines of source produce 80 bytes of machine code. The rest of this chapter
works through those lines, section by section, explaining what each instruction
does and why it is there. The line numbers are reference points — when the text
says "line 17" you can find it in the listing above.

---

## Before the Code: Lines 1-10

### Names for Numbers

Lines 1 through 9 produce no machine code. They give names to numbers.

```
  1  POLCAT    EQU     $A000
  2  CHROUT    EQU     $A002
  3  CLRSCR    EQU     $A928
  4  CURPOS    EQU     $0088
  5  SCREEN    EQU     $0400
  6  COLS      EQU     32
  7  HELLO_POS EQU     SCREEN+(7*COLS)+10
  8  WORLD_POS EQU     SCREEN+(7*COLS)+16
  9  EXIT_POS  EQU     SCREEN+(13*COLS)+0
```

`EQU` is short for *equate*. When the assembler sees `CLRSCR` later in the
program, it substitutes `$A928`. The names exist only during assembly — they
help the programmer, not the machine.

The addresses written with four hex digits — `$A000`, `$0088`, `$0400` — are
memory addresses. Two digits would be valid too, but four digits make the intent
clear at a glance. `$88` could be a constant. `$0088` is an address.

### What These Addresses Are

`$A000`, `$A002`, and `$A928` are in the Color BASIC ROM. This is firmware
burned permanently into the CoCo's chips. `POLCAT` polls the keyboard. `CHROUT`
sends a character to the screen. `CLRSCR` clears the screen and moves the
cursor to the top left. These addresses are the same on every CoCo ever made.

`$0088` is different. It is in RAM, not ROM. BASIC uses the two bytes at
`$0088` and `$0089` as its cursor position register — when BASIC writes a
character to the screen, it reads this address to find out where to put it. The
program writes to `$0088` directly to control where CHROUT will place characters.

`$0400` is the start of the VDG text screen. The Color Computer displays text
by reading 512 bytes of RAM starting at this address — 32 columns across, 16
rows down, one byte per character position. Writing a byte to this area puts a
character on screen immediately.

### Screen Position Arithmetic

Lines 7 through 9 use the assembler as a calculator:

```
  7  HELLO_POS EQU     SCREEN+(7*COLS)+10
```

This is: start of screen, plus seven complete rows of 32 columns, plus 10
columns into that row. The assembler computes the result and bakes the number
`$04EA` into the machine code. The CPU never sees the arithmetic — only the
answer.

### Position Independent Code

Line 10:

```
 10            ORG     0
```

This tells the assembler to generate code as if the program starts at address
zero. The BASIC loader puts the code at `$3F00`. Both are correct.

The program contains no references to its own absolute address. Every reference
to data or code within the program is expressed as an offset from the current
position. Move the program anywhere in memory and those offsets remain correct
because the distance between instructions and their data does not change.
This is called position independent code.

---

## Clearing the Screen: Line 12

```
 12            JSR     CLRSCR
```

`JSR` is *Jump to SubRoutine*. It pushes the address of the next instruction
onto the hardware stack and jumps to `$A928`. The ROM routine runs, clears the
screen, moves the cursor to the top left, and executes `RTS` — *Return from
SubRoutine* — which pops the saved address and returns here. Execution continues
at line 13.

The ROM routine is dozens of instructions. We call it with one.

**The Stack**

The 6809 maintains a hardware stack — a region of RAM used for saving and
restoring addresses automatically. `JSR` pushes a 2-byte return address onto the
stack. `RTS` pops it off and jumps there. The stack grows downward in memory.
Every `JSR` must have a corresponding `RTS` or the program will not return
correctly.

---

## Writing HELLO to the Screen: Lines 13-28

The Color Computer's text screen does not use ASCII. The Video Display Generator
chip has its own character encoding. Understanding why requires a brief detour.

**The VDG Character Set**

The normal display on a CoCo is green characters on a black background. This is
not inverted — this is the default. In most other contexts green-on-black would
be considered reversed, but the CoCo's phosphor screen simply looks that way
normally.

The VDG character codes map to a character set where `$01` is 'A', `$02` is
'B', and so on through `$1A` for 'Z'. ASCII uppercase letters run from `$41`
('A') through `$5A` ('Z'). The relationship between the two:

```
ASCII 'H' = $48 = %01001000
VDG  'H'  = $08 = %00001000
```

Strip bits 7 and 6 from the ASCII code and you have the VDG code. The
instruction `ANDA #$3F` does this — `$3F` is `%00111111`, which zeroes bits 7
and 6 while leaving the rest unchanged.

Bit 6 of a VDG character byte controls display mode. Bit 6 clear produces a
normal green character on black. Bit 6 set produces a dark character on a green
background. The instruction `ORA #$40` sets bit 6 — `$40` is `%01000000`.

In this program, `HELLO ` is written with bit 6 set and `WORLD!` is written
without. The two words appear visually different on screen — one with a green
background behind each character, the other without.

Space is a special case. The VDG space — a blank character cell — is `$60`.
Stripping bits 7 and 6 from ASCII space (`$20`) gives `$00`, which is the VDG
`@` character, not a space. So the space character is handled separately rather
than going through the conversion.

### Setting Up: Lines 13-15

```
 13            LDX     #HELLO_POS
 14            LEAY    Hello,PCR
 15            LDB     #6
```

Three registers, three purposes.

`LDX #HELLO_POS` loads the address `$04EA` into X. The `#` means the value is
encoded directly in the instruction — this is *immediate addressing*. X will
point to the screen position where HELLO begins and will advance as characters
are written.

`LEAY Hello,PCR` loads the address of the string data at line 46 into Y. `PCR`
means the address is calculated as an offset from the current program counter.
This keeps the code position independent — wherever the program lives in memory,
Y will correctly point to the Hello string within it.

`LDB #6` loads the number 6 into B. This is the loop counter — six characters
to write.

### The Loop: Lines 16-28

```
 16  WriteHello
 17            LDA     ,Y+
 18            CMPA    #' '
 19            BEQ     WriteSpace
 20            ANDA    #$3F
 21            ORA     #$40
 22            BRA     StoreChar
 23  WriteSpace
 24            LDA     #$60
 25  StoreChar
 26            STA     ,X+
 27            DECB
 28            BNE     WriteHello
```

`WriteHello` is a label — a name for this memory address. It marks the top of
the loop.

**Line 17: `LDA ,Y+`** loads the byte at Y into A, then advances Y. The `,Y+`
notation is *post-increment indexed addressing*: use the register, then
increment it. Each pass through the loop Y moves one byte forward in the
string data.

**Lines 18-19: `CMPA #' '` / `BEQ WriteSpace`** compares A to the ASCII space
character. `CMPA` performs a subtraction and sets condition flags based on the
result but does not store the result. `BEQ` — *Branch if Equal* — jumps to
`WriteSpace` if the result was zero, meaning the characters were equal. If the
character is not a space, execution continues at line 20.

**Lines 20-21: `ANDA #$3F` / `ORA #$40`** perform the ASCII-to-VDG conversion
described above. Strip the high bits, then set bit 6 for the alternate display
mode. The result written to screen memory will display as a dark character on a
green background.

**Line 22: `BRA StoreChar`** branches unconditionally past the WriteSpace
handling.

**Lines 23-24: `WriteSpace` / `LDA #$60`** handles the space character by
loading the VDG space code directly.

**Lines 25-26: `StoreChar` / `STA ,X+`** stores the prepared VDG code to the
screen memory address in X, then advances X. The character appears on screen at
the moment this instruction executes.

**Lines 27-28: `DECB` / `BNE WriteHello`** decrement B and branch back to
`WriteHello` if B is not yet zero. When B reaches zero `BNE` does not branch
and execution falls through to line 29. This is the counted loop pattern.

---

## Positioning the Cursor: Lines 29-30

```
 29            LDD     #WORLD_POS
 30            STD     <CURPOS
```

The D register is A and B treated as a 16-bit pair — A is the high byte, B is
the low byte. `LDD #WORLD_POS` loads the address `$04F0` into D in one
instruction, setting both bytes at once.

`STD <CURPOS` stores D to `$0088` and `$0089`. The `<` prefix means *direct
page addressing* — the 6809 can address the first 256 bytes of memory with a
shorter, faster instruction. `<CURPOS` uses this form. The result is that BASIC's
cursor position register now holds `$04F0`, which is row 7, column 16.

---

## Writing WORLD! via the ROM: Lines 31-32

```
 31            LEAX    World,PCR
 32            BSR     PrintStr
```

`LEAX World,PCR` loads the address of the World string data into X using
PC-relative addressing, the same technique used for Y at line 14.

`BSR PrintStr` — *Branch to SubRoutine* — pushes a return address and jumps to
the `PrintStr` subroutine at line 39. Unlike `JSR`, `BSR` uses a signed offset
from the current program counter rather than an absolute address. It is one byte
shorter than `JSR` and inherently position independent.

---

## Setting the Exit Cursor Position: Lines 33-34

```
 33            LDD     #EXIT_POS
 34            STD     <CURPOS
```

The same pattern as lines 29-30. The cursor moves to row 13, column 0. When the
program returns to BASIC, BASIC prints `OK` at the cursor position. Placing the
cursor here keeps the BASIC output clear of the displayed text.

---

## Waiting for a Keypress: Lines 35-37

```
 35  WaitKey
 36            JSR     [POLCAT]
 37            BEQ     WaitKey
```

`JSR [POLCAT]` uses indirect addressing — the square brackets mean "jump to the
address stored at `$A000`" rather than jumping to `$A000` itself. The ROM
keyboard routine address can be redirected by other software. Using the indirect
form respects any such redirection, consistent with how the BASIC ROM itself
calls the routine.

`POLCAT` returns the ASCII code of any pressed key in A, or zero if no key is
pressed. `BEQ WaitKey` loops back when A is zero. When a key is pressed A is
non-zero, `BEQ` does not branch, and execution continues to line 38.

---

## Returning to BASIC: Line 38

```
 38            RTS
```

`EXEC` in BASIC pushed a return address before jumping to the program. `RTS`
pops it and returns — BASIC resumes and prints `OK` at the cursor position set
at line 34.

---

## The PrintStr Subroutine: Lines 39-45

```
 39  PrintStr
 40            LDA     ,X+
 41            BEQ     PrintDone
 42            JSR     [CHROUT]
 43            BRA     PrintStr
 44  PrintDone
 45            RTS
```

`PrintStr` prints a null-terminated string. X must point to the string on entry.

**Line 40: `LDA ,X+`** loads the character at X into A and advances X.

**Line 41: `BEQ PrintDone`** — a zero byte signals the end of the string. Branch
to `PrintDone` and return.

**Line 42: `JSR [CHROUT]`** calls the ROM character output routine via indirect
addressing. `CHROUT` reads the cursor position from `$0088`/`$0089`, writes the
character in A to that screen location, and advances the cursor.

**Line 43: `BRA PrintStr`** loops back for the next character.

**Line 45: `RTS`** returns to the caller. The return address was pushed by `BSR`
at line 32.

---

## The String Data: Lines 46-48

```
 46  Hello     FCC     "HELLO "
 47  World     FCC     "WORLD!"
 48            FCB     0
```

`FCC` — *Form Constant Characters* — places the ASCII codes of the string
directly into the binary output. `FCB` places a single byte. The zero at line 48
is the null terminator that `PrintStr` uses to detect the end of the string.

`Hello` and `World` are labels. Lines 14 and 31 reference them by name. The
assembler calculates the PC-relative offsets to each.

The two strings are adjacent in memory. The null terminator at line 48 follows
immediately after `WORLD!` and serves only that string — `Hello` is accessed
directly via the loop at lines 16-28 and does not need one.

---

## The Six Concepts

This program demonstrates six things that appear in every assembly language
program ever written for any processor:

**Data Movement** — loading values into registers (`LDA`, `LDB`, `LDD`, `LDX`),
storing them to memory (`STA`, `STD`), and the addressing modes that determine
where the data comes from or goes.

**Arithmetic** — the assembler computed `SCREEN+(7*COLS)+10` before producing a
single byte of output. At runtime, `DECB` decrements a counter. The counted
loop — load a count, do work, decrement, branch if not done — is one of the
most common structures in assembly programming.

**Logic** — `ANDA #$3F` clears bits. `ORA #$40` sets a bit. Two instructions
convert an ASCII character code to a VDG display code. The result is visible on
screen.

**Compare and Branch** — `CMPA` sets condition flags. `BEQ` and `BNE` act on
those flags. `BRA` branches regardless of flags. These are the building blocks
of all control flow in assembly language.

**Stack and Subroutines** — `JSR` and `BSR` save a return address on the stack
and jump. `RTS` retrieves that address and returns. The hardware stack makes
subroutines possible. Every call must be paired with a return.

**Indexed Addressing** — `,Y+` and `,X+` read or write through a register and
advance it. This is how you work through strings, arrays, and blocks of memory.
`PCR` addressing locates data by offset from the current program counter,
keeping the code position independent.

These six concepts are the subject of the chapters that follow. Each will be
developed further using examples from real programs — not contrived exercises,
but working code that does something useful.

---

## About the BASIC Loader

The BASIC program that loaded the machine code is worth understanding briefly,
because it uses a technique with implications worth knowing.

`CLEAR 200` reserves 200 bytes of string space at the top of RAM. It also resets
all variable values — which is why `A` is assigned on the next line rather than
assuming any prior value. `CLEAR` clears everything.

`A=&H3F00` uses BASIC's `&H` prefix for hexadecimal. The address `$3F00` is in
the upper RAM area, below BASIC's program space, and available for machine
language use.

The loop reads each DATA value and POKEs it to the corresponding address. `POKE`
writes a byte to an arbitrary memory location — the same operation as `STA` in
assembly language, just expressed in BASIC. After 80 iterations the machine code
sits at `$3F00` through `$3F4F`.

`EXEC A` transfers control to address A. BASIC pushes a return address and jumps
to the machine code. When the machine code executes `RTS`, BASIC resumes.

The DATA values are the machine code bytes expressed as decimal numbers.
`189,169,40` is `$BD $A9 $28` — the three bytes of `JSR $A928`, which is the
CLRSCR call at line 12 of the assembly listing. Every instruction in the program
is encoded in those DATA statements.

