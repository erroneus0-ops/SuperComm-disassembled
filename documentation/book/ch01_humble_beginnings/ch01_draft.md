# Chapter 1: Humble Beginnings

This is a type-in program. If you were reading a computer magazine in 1982, you
know what that means. You found a listing, you sat down at the keyboard, and you
typed. If you made a mistake you found it, fixed it, and tried again. Eventually
it worked. Good times.

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
memory starting at address 16128, and then handed control to them. The machine
code ran, did its work, and handed control back to BASIC. That specific address
is not arbitrary — there is a reason for it — but for now, accept it as a safe
place to put the code.

That is what this book is about: what those 80 bytes do, why they do it, and how
to write your own.

---

## What BASIC Did

You do not need to understand the BASIC program to get started. Here is what it
did in plain terms.

`CLEAR 200` reserves some memory and resets all variables. `A=16128` puts the
destination address into a variable. The FOR loop reads each number from the
DATA statements and POKEs it into memory one byte at a time, starting at that
address. `EXEC A` tells BASIC to jump to that address and run whatever is there.

BASIC is the delivery vehicle. The machine code is the program.

---

## Assembly Language

Machine code is bytes. Programmers do not write bytes directly — not because it
cannot be done, but because code written as raw numbers is unreadable. You
cannot tell what it does from looking at it, and you cannot find your mistakes.

Instead, programmers write assembly language: a notation where each instruction
has a name, and each address can have a label. An assembler translates that
notation into bytes. The name for an instruction is its *mnemonic* — a short
word that hints at what the instruction does. `LDA` loads a value. `STA` stores
one. `JSR` jumps to a subroutine. `RTS` returns from one.

The mnemonics Motorola chose work well enough. `LDA` hints at loading.
`STA` hints at storing. Some are less obvious — `LEAX` takes a moment. If you
have ever wondered whether a Spanish-speaking programmer sees `CARGA` where you
see `LDA`, the answer is probably not — assembly language mnemonics have always
been English-derived regardless of where the programmer lives. The machine does
not care either way.

You could invent your own. `LoadA` is unambiguous. `StoreA` leaves nothing to
the imagination. Nothing stops you. But the Motorola mnemonics are what you will
find in every manual, every listing, every tool. They are the shared language of
anyone who has worked with this processor. Using them means your code is readable
to anyone else who has.

Different assemblers may offer their own extensions and expressions beyond the
Motorola standard, though all should implement the standard itself. We will cover
more on this in a more advanced discussion.

---

## The Shape of the Program

Before looking at a single instruction, here is what the program does, expressed
in plain language. This is the outline. The ~~chapters~~ sections that follow fill it in.

```
; --- Names for fixed addresses and constants ---

Start:
    Clear the screen

    Set up to write "HELLO " to screen memory:
        Point X at the screen position
        Point Y at the string data
        Set B as a counter (6 characters)

    WriteHello:
        Load the next character from the string, advance Y
        Convert from ASCII to VDG screen code
        Write the character to screen memory, advance X
        Decrement the counter
        Loop back if not done

    Position the cursor for "WORLD!"
    Call PrintStr to write "WORLD!" through the ROM

    Position the cursor for a clean return to BASIC

    WaitKey:
        Poll the keyboard
        Loop back if no key pressed

    Return to BASIC

PrintStr:
    Load the next character, advance X
    If it is zero (end of string), return
    Send the character to the screen through the ROM
    Loop back

; --- String data ---
Hello:  "HELLO "
World:  "WORLD!"
        (null terminator)
```

Three things are worth noting before we go further.

First, the program has two distinct ways of putting characters on screen. `HELLO`
is written by the program directly — one byte at a time into screen memory.
`WORLD!` is written by calling a ROM routine that handles the details. Both
approaches appear in almost every real program. You will see why the difference
matters.

Second, `PrintStr` is a *subroutine* — a reusable block of code with a defined
entry point and a return. It does not know it is being called to print `WORLD!`.
Pass it any string and it works the same way. That generality is the point.

Third, everything above the `Start` label produces no machine code at all. It
is bookkeeping — names for numbers that the assembler substitutes throughout the
program. The CPU never sees them.

---

## What Comes Next

Each of the following ~~chapters~~ sections develops one concept from this program. In each
chapter, the relevant lines of assembly source are revealed and explained. By
the end, the complete annotated listing will have emerged one section at a time.

The six concepts, in order:

1. **Data Movement** — loading values into registers, storing them to memory,
   the addressing modes that determine where data comes from and goes.

2. **Arithmetic** — the assembler as a calculator, and the runtime counter
   that drives the loop.

3. **Logic** — the two instructions that convert ASCII to VDG screen codes
   and control the display mode. The result is visible on screen.

4. **Compare and Branch** — the only way a sequential machine makes decisions.
   The loop and the keyboard wait.

5. **Stack and Subroutines** — how the CPU remembers where it came from, and
   how subroutines use that mechanism.

6. **Indexed Addressing** — moving through strings and memory blocks one
   element at a time, and how the program finds its own data regardless of
   where it is loaded.

When all six are covered, the complete program will be assembled in full —
with comments, assembler directives, and a few techniques that will make more
sense ~~then~~ than they would now.

---

## Before the Next Chapter

This program puts characters on screen two different ways. `HELLO ` is written
directly into screen memory, one byte at a time. `WORLD!` is handed to a ROM
routine that handles the details. Both produce the same result — so why write
the code yourself when the ROM will do it for you?

The answer is in chapter 2.
