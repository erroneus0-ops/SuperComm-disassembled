# Chapter 1: Humble Beginnings

This is a type-in program. If you were reading a computer magazine in 1982, you
know what that means. You found a listing, you sat down at the keyboard, and you
typed. If you made a mistake you found it, fixed it, and tried again. Eventually
it worked. The satisfaction was real.

Type this into your Color Computer:

| | |
|---|---|
| `10 REM HELLO WORLD      ` | `140 DATA 138,64,32,2    ` |
| `20 REM HUMBLE BEGINNINGS` | `150 DATA 134,96,167,128 ` |
| `30 REM                  ` | `160 DATA 90,38,237,204  ` |
| `40 CLEAR 200            ` | `170 DATA 4,240,221,136  ` |
| `50 A=16128              ` | `180 DATA 48,141,0,33    ` |
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

The screen clears. Centered on row seven:

```
        HELLO WORLD!
```

The cursor sits at row thirteen. Press any key and BASIC returns with `OK`.

The DATA statements in that listing contain a machine language program — 80 bytes
of 6809 instructions. BASIC read those bytes one at a time, placed them into
memory starting at that address, and then handed control to them. The machine
code ran, did its work, and handed control back to BASIC.

That is what this book is about: what those 80 bytes do, why they do it, and how
to write your own.

---

## What You Need to Know First

You do not have to understand the BASIC program to get started. What BASIC did
is simple enough to explain in one paragraph.

`CLEAR 200` reserves some memory and resets variables. `A=16128` puts a
specific address into A — for now, accept it as a safe place to put the code.
The FOR loop reads each number from the DATA statements and POKEs it into
memory, one byte at a time, starting at that address. `EXEC A` tells BASIC to
jump to that address and run whatever is there.

That is the entire mechanism. BASIC is just a delivery vehicle. The machine
code is the program.

---

## The Same Program in Assembly Language

Machine code is bytes. Programmers do not write bytes directly — not because it
cannot be done (it can, and people did), but because it is slow, error-prone,
and produces code that nobody including the author can read a week later.
Instead, programmers write assembly language: a notation where each instruction
has a name, each address can have a label, and the computer translates it into
bytes. That translation program is called an assembler.

Here is the assembly language source for the program you just ran. The numbers
on the left are line references used throughout this chapter.

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

49 lines of assembly language produced 80 bytes of machine code. The DATA
values in the BASIC listing are those same 80 bytes, expressed as decimal
numbers. `189,169,40` at the start of the DATA is `$BD $A9 $28` — the three
bytes of the `JSR CLRSCR` instruction at line 12.

The rest of this chapter works through the assembly source section by section.
When the text refers to "line 17" or "lines 20-21", find them in the listing
above.

---

## Before the Code: Lines 1-10

### Names for Numbers

Lines 1 through 9 produce no machine code at all. They are `EQU` directives.
`EQU` is short for *equate* — each line gives a name to a number, and wherever
that name appears in the program the assembler substitutes the number.

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

The addresses are written with four hex digits — `$A000`, `$0088`, `$0400`.
Two digits would be technically correct too. Four digits signals at a glance
that these are memory addresses, not arbitrary constants. It is a convention
worth keeping.

Lines 7 through 9 show something useful about assemblers: they do arithmetic.
`SCREEN+(7*COLS)+10` means start of screen memory, plus seven complete rows of
32 columns, plus 10 more — the position on row 7 where HELLO begins. The
assembler computes the answer and puts the number `$04EA` into the machine code.
The CPU never sees the expression. When you want a number that is calculated
from other numbers, let the assembler do it.

### What These Addresses Are

`$A000`, `$A002`, and `$A928` are in the Color BASIC ROM — firmware burned
permanently into chips on the CoCo's circuit board. `POLCAT` polls the keyboard.
`CHROUT` sends a character to the screen. `CLRSCR` clears the screen. Every
CoCo ever made has these routines at these addresses. We call them the same way
BASIC does.

`$0400` is the start of the VDG text screen. The CoCo displays text by reading
512 bytes of RAM starting here — 32 columns, 16 rows, one byte per character
position. Write a byte to this area and it appears on screen immediately.

`$0088` is in RAM. BASIC uses the two bytes at `$0088` and `$0089` as its cursor
position register — when BASIC writes a character, it reads this address to
know where to put it. The program writes here directly to control where the
next CHROUT call will place its character.

### Position Independent Code

Line 10:

```
 10            ORG     0
```

The BASIC loader puts the machine code at address 16128. `ORG 0` tells the assembler
to generate code as if the program starts at address zero. Both are correct
because the program contains no references to its own absolute location. Every
reference to code or data within the program is expressed as an offset from the
current position. Move the program anywhere in memory and those offsets remain
valid. This is called position independent code, and it is why the same DATA
bytes work regardless of where BASIC happens to place them.

---

## Clearing the Screen: Line 12

```
 12            JSR     CLRSCR
```

`JSR` is *Jump to SubRoutine*. It does two things: pushes the address of the
next instruction onto the hardware stack, then jumps to `CLRSCR` (`$A928`).
The ROM routine runs, clears the screen, moves the cursor to the top left, and
executes `RTS` — *Return from SubRoutine*. `RTS` pops the saved address from
the stack and jumps there. Execution returns to line 13 as if nothing happened
except the screen is now clear.

**The Stack**

The 6809 has a hardware stack — a region of RAM used automatically for saving
and restoring addresses. `JSR` pushes a 2-byte return address. `RTS` pops it.
The stack grows downward in memory. Every `JSR` needs a corresponding `RTS` or
the program will not return correctly. This pairing is one of the few absolute
rules in assembly programming.

---

## Writing HELLO to the Screen: Lines 13-28

The CoCo's text screen does not use ASCII. The Video Display Generator chip has
its own character encoding, and understanding it explains lines 20 and 21.

**The VDG Character Set**

The normal display on a CoCo is green characters on a black background. This
is not inverted — it is the default. Bit 6 of each screen byte controls the
display mode: bit 6 clear gives green on black, bit 6 set gives dark on green.
The program uses this to make HELLO look visually different from WORLD!.

The VDG character codes for uppercase letters start at `$01` for A, `$02` for
B, and so on. ASCII uppercase letters start at `$41` for A, `$42` for B.
Stripping bits 7 and 6 from an ASCII letter gives the VDG code:

```
ASCII 'H' = $48 = %01001000
             ↓  ANDA #$3F
VDG   'H' = $08 = %00001000
             ↓  ORA #$40
displayed   $48 = %01001000  (dark H on green background)
```

`ANDA #$3F` strips bits 7 and 6. `ORA #$40` sets bit 6. Two instructions
perform the conversion and choose the display mode. The result is visible on
screen.

Space is a special case. The VDG space — a blank character cell — is `$60`.
Converting ASCII space (`$20`) the same way gives `$00`, which is the VDG `@`
character. So the space in HELLO is handled separately at line 24.

### Setting Up: Lines 13-15

```
 13            LDX     #HELLO_POS
 14            LEAY    Hello,PCR
 15            LDB     #6
```

Three registers, three purposes.

`LDX #HELLO_POS` loads the screen address `$04EA` into X. X will walk forward
through screen memory as characters are written. The `#` means the value is
encoded directly in the instruction — *immediate addressing*.

`LEAY Hello,PCR` loads the address of the string data at line 46 into Y. `PCR`
means the address is calculated as an offset from the program counter — wherever
the program happens to be in memory, Y will correctly point to the Hello data
within it. This is position independent data access.

`LDB #6` loads 6 into B. Six characters to write.

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

`WriteHello` is a label — a name for this address in memory. It marks the top
of the loop.

**Line 17: `LDA ,Y+`** loads the byte at Y into A, then advances Y to the next
byte. The `,Y+` notation is *post-increment indexed addressing*: use the
register, then increment it. Y moves one character forward through the string
data on each pass through the loop.

**Lines 18-19: `CMPA #' '` / `BEQ WriteSpace`** compare A to the ASCII space
character. `CMPA` subtracts without storing the result, setting condition flags.
`BEQ` (*Branch if Equal*) jumps to `WriteSpace` if the result was zero. If the
character is not a space, execution falls through to line 20.

**Lines 20-21: `ANDA #$3F` / `ORA #$40`** perform the ASCII-to-VDG conversion.
Strip the high bits, set bit 6. The converted value written to screen memory
will display as a dark character on a green background.

**Line 22: `BRA StoreChar`** branches unconditionally past the WriteSpace path.

**Lines 23-24: `WriteSpace` / `LDA #$60`** loads the VDG space code directly,
bypassing the conversion.

**Lines 25-26: `StoreChar` / `STA ,X+`** stores the VDG code to screen memory
at X, then advances X. The character appears on screen at that moment.

**Lines 27-28: `DECB` / `BNE WriteHello`** decrement B and branch back to
`WriteHello` if B is not zero. When B reaches zero `BNE` does not branch and
execution continues to line 29. This is the counted loop: load a count, do
work, decrement, branch if not done.

---

## Positioning the Cursor: Lines 29-30

```
 29            LDD     #WORLD_POS
 30            STD     <CURPOS
```

D is A and B treated as one 16-bit register — A is the high byte, B is the low
byte. `LDD #WORLD_POS` loads the address `$04F0` into D in a single instruction,
setting both bytes at once.

`STD <CURPOS` stores D to addresses `$0088` and `$0089`. The `<` prefix means
*direct page addressing* — the 6809 can address the first 256 bytes of memory
with a shorter, faster two-byte instruction form rather than three bytes.
`<CURPOS` uses this form. After this instruction, BASIC's cursor register points
to row 7, column 16, where WORLD! will begin.

---

## Writing WORLD! via the ROM: Lines 31-32

```
 31            LEAX    World,PCR
 32            BSR     PrintStr
```

`LEAX World,PCR` loads the address of the World string data into X, using the
same PC-relative technique as line 14.

`BSR PrintStr` — *Branch to SubRoutine* — pushes a return address and jumps to
the `PrintStr` subroutine at line 39. Unlike `JSR`, `BSR` uses a signed offset
from the current program counter rather than an absolute address. It is one
byte shorter and is inherently position independent.

---

## Positioning the Cursor for Exit: Lines 33-34

```
 33            LDD     #EXIT_POS
 34            STD     <CURPOS
```

The cursor moves to row 13, column 0. When the program returns to BASIC, BASIC
prints `OK` at whatever address is in the cursor register. Placing it here
keeps the BASIC output clear of the display.

---

## Waiting for a Keypress: Lines 35-37

```
 35  WaitKey
 36            JSR     [POLCAT]
 37            BEQ     WaitKey
```

`JSR [POLCAT]` uses *indirect addressing* — the square brackets mean jump to
the address stored at `$A000`, not to `$A000` itself. The ROM keyboard routine
address can be redirected by other software. Using the indirect form respects
that, the same way the BASIC ROM does.

`POLCAT` returns the key pressed in A, or zero if no key is pressed. `BEQ
WaitKey` loops back when A is zero. When a key is pressed, execution falls
through to line 38.

---

## Returning to BASIC: Line 38

```
 38            RTS
```

`EXEC` in BASIC pushed a return address before jumping here. `RTS` pops it and
returns. BASIC resumes and prints `OK` at the cursor position set at line 34.

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

Line 40 loads the character at X into A and advances X. Line 41 checks for a
zero byte — the null terminator — and branches to `PrintDone` if found. Line 42
calls the ROM character output routine via indirect addressing. `CHROUT` reads
the cursor register, writes the character in A to that screen location, and
advances the cursor. Line 43 loops back for the next character. Line 45 returns
to the caller.

`PrintStr` does not know or care that it was called to print WORLD!. Pass it
any null-terminated string and it works the same way. That generality is the
point of a subroutine.

---

## The String Data: Lines 46-48

```
 46  Hello     FCC     "HELLO "
 47  World     FCC     "WORLD!"
 48            FCB     0
```

`FCC` (*Form Constant Characters*) places the ASCII codes of the string
directly into the binary output. `FCB` (*Form Constant Byte*) places a single
byte. The zero at line 48 is the null terminator for `PrintStr`.

`Hello` and `World` are labels that mark these addresses. The assembler
calculates PC-relative offsets to them from lines 14 and 31.

The two strings are adjacent in memory. `Hello` is six bytes, ending just
before `World` begins. Only `World` needs the null terminator because only
`World` is passed to `PrintStr`.

---

## Six Things This Program Demonstrates

Every assembly language program uses the same building blocks regardless of
which processor it runs on. This program uses all six.

**Data Movement** — loading values into registers (`LDA`, `LDB`, `LDD`, `LDX`),
storing them to memory (`STA`, `STD`). The `#` prefix means the value is in the
instruction itself. The `<` prefix means use the shorter direct page form.

**Arithmetic** — the assembler calculated screen positions before producing any
code. At runtime, `DECB` counts down the loop. The counted loop pattern — load
a count, do work, decrement, branch back if not zero — is one of the most
common structures in assembly programming.

**Logic** — `ANDA #$3F` clears bits. `ORA #$40` sets a bit. Two instructions
converted ASCII to VDG codes and selected a display mode. The result was visible
immediately on screen.

**Compare and Branch** — `CMPA` sets flags without storing a result. `BEQ` and
`BNE` act on those flags. `BRA` branches regardless. These instructions are the
only way a sequential machine can make decisions.

**Stack and Subroutines** — `JSR` and `BSR` push a return address and jump.
`RTS` retrieves it and returns. The hardware stack makes subroutines possible.
`BSR` is the position independent form. Every call must pair with a return.

**Indexed Addressing** — `,Y+` and `,X+` load or store through a register and
advance it. This is how you move through strings, arrays, and blocks of memory.
`PCR` addressing locates data relative to the program counter, keeping the code
position independent.

These six concepts are the subject of the chapters that follow.

---

## About the BASIC Loader

The BASIC program that delivered the machine code uses a technique worth
understanding, because it raises a question that has a non-obvious answer.

`CLEAR 200` reserves memory and resets all variable values. `A=16128` puts a
specific address into A — a safe place to put the code. The FOR loop reads
each DATA value into D and POKEs it to memory. `EXEC A` transfers control to that address — the same
as a JSR instruction to that address in assembly language, except BASIC pushes a return address first
so `RTS` at the end of the machine code brings BASIC back.

A more elegant approach would build the machine code into a string variable
using `CHR$()`, then use `VARPTR` to find where BASIC stored the string data,
and `EXEC` from that address. This way the code lives wherever BASIC decides to
put it, which is precisely what position independent code is designed to handle.

In practice, `CHR$(0)` — the null byte that appears in the machine code — caused
BASIC to terminate the string early, breaking the approach. The direct POKE to
a known address works reliably and is straightforward to understand. But the
string variable technique is not wrong in principle — it demonstrates exactly
why position independent code matters, and that story is worth telling in its
own right.

`VARPTR` returns the address of a variable's internal descriptor. For a string
variable, the descriptor contains the string's length and the address of its
data. Decoding that descriptor by hand — `A=PEEK(V+1)*256+PEEK(V+2)` — is a
window into how BASIC manages memory. The string is not an abstraction. It is
bytes in RAM, and BASIC knows exactly where.
