# Chapter 2: Data Movement

The question left hanging at the end of Chapter 1: Why does `HELLO` use special
handling to appear on screen, while `WORLD!` can simply be passed to a ROM
routine?

The answer is the screen itself.

---

## The CoCo Screen Is Not a Terminal

When you PRINT something in BASIC, the ROM does the work. You hand it a character
and it figures out where to put it. It maintains a cursor position, converts the
character to the right byte value, places that byte in screen memory, and advances
the cursor. The result acts like a terminal — characters appear, the cursor moves
— but BASIC is building that behavior on top of something much simpler.

The CoCo's display hardware — the MC6847 Video Display Generator, VDG for short
— reads memory. The screen is a block of 512 bytes of RAM starting at address
`$0400`. Each byte corresponds to one character cell: 32 columns across, 16 rows
down. Write a byte to one of those addresses and the VDG displays the
corresponding character in the corresponding cell. The ROM is a layer on top of
that. The screen is just memory.

Try it yourself. Type `POKE 1056,30` and press Enter. Address 1056 (`$0420`) is
the first cell of the second row on screen. The value 30 (`$1E`) is an up-arrow
glyph in the VDG's first character set. You should see it replace whatever
character was there — light on dark, standing out from the surrounding text. One
byte written to one memory location, displayed immediately. No ROM involved.

---

## A Note on Numbers

Before going further, a word about the notation you will see throughout this book.

Computers work in binary — base 2, where every value is a pattern of ones and
zeros. A single binary digit is a *bit*. Eight bits make a *byte*, and a byte can
hold any value from 0 to 255. In binary those look like this:

```
 3 = %00000011
 7 = %00000111
15 = %00001111
31 = %00011111
```

The `%` prefix signals binary notation. Binary is precise but tedious to read and
write. Hexadecimal — base 16 — solves that. Where decimal runs out of single
digits at 9, hexadecimal continues: A (10), B (11), C (12), D (13), E (14),
F (15). The same values in hex:

```
 3 = $03
 7 = $07
15 = $0F
31 = $1F
```

The `$` prefix signals hexadecimal. The reason machine coders prefer hex over
decimal is not arbitrary: one hex digit maps exactly to four binary bits, always.
Two hex digits is one byte, always. `$1F` is `%00011111` — the `1` in hex is
`0001` in binary, the `F` is `1111`. Once that clicks, hex stops feeling like a
foreign language and starts feeling like a compressed view of the actual bits.
With practice, you see `$1E` and think `%00011110` — the up-arrow you just POKEd
to the screen.

You will also see `0x` for hex and `0b` for binary in other contexts — these mean
the same thing as `$` and `%`. In CoCo BASIC, `&H` precedes a hexadecimal value.
Decimal numbers carry no prefix; a number without one is just a number.

It comes with practice. Take your time. It will come to you as we go along.

---

## The VDG Character Set

The VDG has its own character encoding. A byte written to screen memory can be
any value from 0 to 255, and each value produces a specific result. The 256
values divide into three groups:

- `$00`–`$3F` (0–63): the **first character set** — on the CoCo, light on dark:
  green glyphs on a black background
- `$40`–`$7F` (64–127): the **second character set** — on the CoCo, dark on light:
  black glyphs on a bright green background
- `$80`–`$FF` (128–255): semigraphics — colored block patterns, not text

Both character sets contain the same 64 glyphs. The low 32 of each group
(`$00`–`$1F` and `$40`–`$5F`) are: `@`, then `A` through `Z`, then a handful of
symbols. The high 32 of each group (`$20`–`$3F` and `$60`–`$7F`) are more
symbols and the digits zero through nine.

CoCo BASIC uses the second set for uppercase and the first for lowercase — since
the original VDG has no actual lowercase glyphs, BASIC uses the first set as a
stand-in. Lowercase `a` appears on screen as an inverted `A`: light on dark.

That is why this program writes `HELLO ` directly to screen memory rather than
passing it through the ROM. When you write directly, you decide what goes where
and what it looks like. The program reads text from its own memory, converts it
to match Color BASIC's display scheme, and places each byte at a specific screen
address. `WORLD!` takes the other path — it goes through `CHROUT`, which handles
the conversion and placement internally. Both end up looking the same on screen,
which is the point: the ROM produces acceptable results with less effort, but
direct writes give you control the ROM does not. You choose based on what you
need.

---

## Registers

A register is a small, fast storage location inside the processor itself. The
6809 has a handful of them. The ones that matter for this chapter:

**A** and **B** are eight-bit accumulators — single bytes. Most arithmetic and
logic work happens in A or B. `LDA` loads a value into A. `LDB` loads a value
into B. `STA` stores A to memory. `STB` stores B.

**D** is the sixteen-bit accumulator. A and B treated as one register, with A
holding the high byte and B the low byte — so if A contains `$AA` and B contains
`$BB`, D holds `$AABB`. `LDD` loads sixteen bits at once. `STD` stores sixteen
bits at once.

**X** and **Y** are sixteen-bit index registers. They hold addresses. You can
point X at a location in memory and then use indexed addressing to read or write
through it — and optionally advance the pointer automatically as you go.

There are others. They will be discussed as we continue.

---

## Names for Numbers

Here are the first lines of the program source:

```asm
POLCAT  EQU     $A000           ; poll keyboard: returns char in A, 0=none
CHROUT  EQU     $A002           ; output char in A to screen via ROM and move CURPOS
CLRSCR  EQU     $A928           ; clear text screen (direct call, stable)

CURPOS  EQU     $88             ; cursor position: 16-bit address at $88/$89
                                ; CHROUT reads this to know where to write

SCREEN  EQU     $0400           ; VDG text screen: 32 cols x 16 rows = 512 bytes
COLS    EQU     32
```

`EQU` is an assembler directive — equate. It tells the assembler: "whenever you
see `POLCAT`, substitute `$A000`. Whenever you see `SCREEN`, substitute `$0400`."
The CPU never sees the names. By the time the program becomes bytes, every name
has been replaced by its value.

This matters because `$A000` says nothing about what lives there. `POLCAT` says
exactly what it is. Code that reads `JSR [POLCAT]` communicates its intent to
anyone reading it. Code that reads `JSR [$A000]` requires the reader to look up
the address. The bracket notation is a specific addressing mode; it will be
covered in its own section.

The addresses themselves are fixed in the Color BASIC ROM. Tandy published them.
They have not changed across CoCo generations. Programs that use these addresses
will work on any CoCo with Color BASIC, which is all of them.

---

## Loading Values into Registers

The program begins by calling the ROM to clear the screen:

```asm
Start
        JSR     CLRSCR          ; clear screen, home cursor
```

`Start` is a label — a name the assembler assigns to this address in memory. When
the program is loaded and run, execution begins here. `JSR` is Jump to
SubRoutine. It calls `CLRSCR` — which the assembler replaces with `$A928` — and
the ROM routine clears the text screen and moves the cursor to row 0, column 0.
When the routine finishes, control returns to the next instruction.

Next, the program sets up to write `HELLO ` to screen memory:

```asm
        LDX     #HELLO_POS      ; X = screen address for "HELLO "
        LDB     #6              ; B = 6 characters to write
```

`LDX` loads a sixteen-bit value into X. `LDB` loads an eight-bit value into B.
Both use *immediate addressing*, signalled by the `#` prefix. The value is right
there in the instruction — not the contents of some memory address, but the
number itself. `LDX #HELLO_POS` loads the address `HELLO_POS` directly into X.
`LDB #6` loads the number six directly into B.

The distinction matters. `LDB $06` would load whatever byte is stored at address
`$0006` — somewhere in RAM, could be anything. `LDB #6` loads the number six,
always, unconditionally. The `#` is the signal.

A few lines later, the space character gets the same treatment:

```asm
WriteSpace
        LDA     #$20            ; VDG inverted space (first character set)
```

`LDA #$20` loads `$20` directly into A. The value is embedded in the instruction.

For setting up the cursor, the program uses the sixteen-bit accumulator:

```asm
        LDD     #WORLD_POS      ; D = screen address for "WORLD!"
```

`LDD #WORLD_POS` loads a sixteen-bit address directly into D — both A and B at
once. You could achieve the same result with separate `LDA` and `LDB`
instructions, but `LDD` does it in one.

---

## Storing Values to Memory

Loading fills a register. Storing writes its content to a memory address.

```asm
        STA     ,X+             ; write VDG code to screen, advance X
```

This is *indexed addressing*. `,X+` means: store A at the address in X, then
increment X by one. Each time this instruction executes, the character goes to the
next screen cell and X moves forward. X is a pointer walking through screen
memory, one cell at a time. The full mechanics of indexed addressing have their
own section later in the book.

The cursor register uses a different addressing mode:

```asm
        STD     <CURPOS         ; store to cursor position register
```

The `<` signals *direct page addressing*. The direct page lives at addresses `$00`
through `$FF`. `CURPOS` is `$88`, which is in that range. Direct page addressing
uses a one-byte address instead of two — one byte shorter, one cycle faster. The
`<` tells the assembler to use the short form explicitly.

The program stores to `CURPOS` twice:

```asm
        LDD     #WORLD_POS
        STD     <CURPOS         ; cursor to row 7, col 16 — for "WORLD!"

        ; ... WORLD! is printed here ...

        LDD     #EXIT_POS
        STD     <CURPOS         ; cursor to row 13, col 0 — for BASIC return
```

`CHROUT` reads the cursor position from `$88`/`$89` and writes each character
there, advancing automatically. Setting `CURPOS` before calling `CHROUT` puts the
output wherever the program wants it. Setting it again afterward positions the
cursor where BASIC's `OK` prompt will appear.

---

## What This Chapter Revealed

Six lines of equates, a JSR, two LDX/LDB loads, a space-character load, a store
through an indexed pointer, and two LDD/STD pairs moving sixteen-bit addresses
around. That is the data movement layer of this program.

Three of the 6809's four addressing modes appeared here: immediate, direct page,
and indexed. The fourth — extended — is already present but unannounced: `JSR
CLRSCR` uses a full two-byte address. The complete picture of addressing modes,
including the full depth of indexed, has its own section later.

Here is the program as it stands after this chapter. Newly revealed lines are
marked:

```asm
POLCAT  EQU     $A000           ; *
CHROUT  EQU     $A002           ; *
CLRSCR  EQU     $A928           ; *
CURPOS  EQU     $88             ; *
SCREEN  EQU     $0400           ; *
COLS    EQU     32              ; *

        ; (ORG and HELLO_POS, WORLD_POS, EXIT_POS — Chapter 3)

Start
        JSR     CLRSCR          ; *

        LDX     #HELLO_POS      ; *
        ; point to Hello string in memory  (indexed addressing)
        LDB     #6              ; *

WriteHello
        ; read next character from string  (indexed addressing)
        ; is it a space?                   (conditionals)
        ; if so, skip the conversion       (conditionals)
        ; map ASCII to VDG character set   (logic and bit manipulation)
        ; select normal video              (logic and bit manipulation)
        ; go store the character           (conditionals)

WriteSpace
        LDA     #$20            ; *

StoreChar
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

Gaps remain. They will be filled, one section at a time.

---

## Before the Next Chapter

The program knows six screen positions: `HELLO_POS`, `WORLD_POS`, `EXIT_POS`,
`SCREEN`, `COLS`, and the load address `ORG`. Only `SCREEN` and `COLS` have
appeared so far. The others are expressed as arithmetic: row times columns plus
an offset. The program never calculates these at runtime. The assembler computed
them before producing a single byte of output.

That is the next chapter: the assembler as a calculator.
