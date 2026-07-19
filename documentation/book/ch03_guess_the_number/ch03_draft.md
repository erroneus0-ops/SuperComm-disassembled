# Chapter 3: The Assembler as a Calculator

Chapter 2 left three names undefined:

```asm
HELLO_POS   ; screen address for "HELLO "
WORLD_POS   ; screen address for "WORLD!"
EXIT_POS    ; screen address for the cursor on return
```

The program used them but never showed where they came from. Here they are:

```asm
SCREEN    EQU   $0400
COLS      EQU   32

HELLO_POS EQU   SCREEN + (7 * COLS) + 10   ; assembler computes $04EA
WORLD_POS EQU   SCREEN + (7 * COLS) + 16   ; assembler computes $04F0
EXIT_POS  EQU   SCREEN + (13 * COLS) + 0   ; assembler computes $0560
```

The assembler evaluated those expressions before producing a single byte of
output. `SCREEN + (7 * COLS) + 10` is row 7, column 10 of the text screen.
The screen starts at `$0400`. Each row is 32 bytes wide. Row 7 starts at
`$0400 + (7 * 32)` = `$0400 + $E0` = `$04E0`. Column 10 adds `$0A`. Result:
`$04EA`. That is what the assembler put everywhere `HELLO_POS` appears in the
code. The CPU never saw the expression — only the answer.

This is the assembler's first job: arithmetic. Not just substituting names for
values as `EQU` does, but computing values the programmer expresses as
relationships. Row times columns plus offset. End of string minus start of
string. Total program size. The assembler resolves all of it at assembly time,
so the CPU only ever executes with concrete numbers.

There is also one more directive that hasn't appeared yet:

```asm
        ORG     0
```

`ORG` sets the *origin* — the address the assembler assumes the code will be
loaded at. `ORG 0` tells the assembler to count addresses from zero. This program
is position-independent: it is designed to run wherever BASIC puts it, not at any
fixed address. `ORG 0` makes all the internal address arithmetic consistent
without tying the program to a specific location in memory. How that works is
covered in the indexed addressing chapter. For now: `ORG 0` is there, and the
program works without knowing in advance where it will land.

The partial listing, with these lines filled in:

```asm
POLCAT  EQU     $A000           ; *
CHROUT  EQU     $A002           ; *
CLRSCR  EQU     $A928           ; *
CURPOS  EQU     $88             ; *
SCREEN  EQU     $0400           ; *
COLS    EQU     32              ; *

HELLO_POS EQU   SCREEN+(7*COLS)+10   ; *  ($04EA)
WORLD_POS EQU   SCREEN+(7*COLS)+16   ; *  ($04F0)
EXIT_POS  EQU   SCREEN+(13*COLS)+0   ; *  ($0560)

        ORG     0               ; *

Start
        JSR     CLRSCR          ; *

        LDX     #HELLO_POS      ; *
        ; point to Hello string in memory  (indexed addressing)
        LDB     #6              ; *

WriteHello
        ; read next character from string  (indexed addressing)
        ; map ASCII to VDG character set   (logic and bit manipulation)
        ; select normal video              (logic and bit manipulation)
        STA     ,X+             ; *
        ; one fewer character to write     (arithmetic)
        ; loop back if not done            (conditionals)

        LDD     #WORLD_POS      ; *
        STD     <CURPOS         ; *
        ; point to World! string           (indexed addressing)
        ; print the string via ROM         (subroutines)

        LDD     #EXIT_POS       ; *
        STD     <CURPOS         ; *

WaitKey
        ; any key pressed?                 (conditionals)
        ; if not, keep waiting             (conditionals)

        ; return to BASIC                  (subroutines)
```

The gaps are fewer now. What remains are the parts that move data through logic,
through decisions, and through subroutine calls. Those are the next four chapters.

---

## Before Going Further

Before this book existed, before any of these tools existed for me, there was a
machine called the COMTRAN TEN. The Navy used it to teach digital electronics —
not programming, but the relationship between code and hardware: what each
instruction does to the signals, what the clock coordinates, what you should see
at each test point when things are working and when they are not. The instruction
set was the vocabulary of the machine, not a creative tool.

At some point, within the manual I had the instruction repertoire in front of me
and a serial terminal connected to the machine. I wrote a guessing game. Not
because anyone asked me to — because I could see that I could.

I had no assembler. I wrote it out with labels and symbolic names, the way you
would in assembly language, then resolved the addresses by hand and translated
everything to hex. One pass to write it, one pass to get the addresses right, one
pass to produce the bytes. It worked.

That process — writing symbolic code first, then becoming your own assembler — is
exactly what an assembler program does for you now. The difference is speed and
the absence of arithmetic errors. The process is the same.

---

## A New Program

Hello World is complete enough to set aside. Everything that remains in it —
the logic, the branching, the subroutines, the indexed addressing — will be
covered in the chapters that follow. But those chapters will use a new program
to introduce those concepts, because a new program asks new questions.

The guessing game:

```
The computer picks a number from 1 to 100.
You guess.
It tells you: too high, too low, or you got it.
You keep guessing until you win.
```

That is the whole game. It is simple enough to hold in your head and complex
enough to need most of what the language offers. By the time the guessing game
is complete, so is the book.

