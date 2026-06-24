# Chapter 2: Data Movement

The question left hanging at the end of Chapter 1: why does `HELLO` need special
handling to appear on screen, while `WORLD!` can simply be passed to a ROM
routine?

The answer is the screen itself.

---

## The CoCo Screen Is Not a Terminal

When you PRINT something in BASIC, the ROM handles the translation. You hand it
a character, it decides where to put it and what byte to write. The screen looks
like a terminal because the ROM makes it look that way.

The CoCo's display hardware — the MC6847 Video Display Generator, VDG for short
— does not think in ASCII. It has its own encoding. The screen is a block of 512
bytes of RAM starting at address `$0400`. Each byte corresponds to one character
cell: 32 columns across, 16 rows down. Write a byte to one of those addresses and
the VDG displays the corresponding character in the corresponding cell,
immediately, no ROM involved.

The VDG character set has uppercase letters, digits, and a handful of symbols.
Its codes do not match ASCII. The letter `A` in ASCII is `$41`. In VDG codes it
is `$01`. The letter `H` is `$48` in ASCII and `$08` in VDG. The pattern holds
for the whole alphabet: strip the high two bits and you get the VDG code.

Space is the odd one out. VDG space is `$60`, which has bit 6 set. In normal
video the character appears as a blank green cell. With bit 6 set throughout,
the display shifts to dark characters on a light background — inverted video.

That is why `HELLO` needs special handling: the program writes to screen memory
directly, using VDG codes, bypassing the ROM entirely. `WORLD!` goes through
`CHROUT`, which is a ROM routine that handles the ASCII-to-VDG conversion
internally. Both end up on screen. They just take different routes.

---

## Registers

Before looking at the instructions, a word about registers.

A register is a small, fast storage location inside the processor itself. The
6809 has a handful of them. The ones that matter for this chapter:

**A** and **B** are eight-bit accumulators — single bytes. Most arithmetic and
logic work happens in A or B. `LDA` loads a value into A. `LDB` loads a value
into B. `STA` stores A to memory. `STB` stores B.

**D** is the sixteen-bit accumulator. It is not separate hardware — D is simply
A and B treated as one sixteen-bit register, with A holding the high byte and B
the low byte. `LDD` loads sixteen bits. `STD` stores sixteen bits.

**X** and **Y** are sixteen-bit index registers. They hold addresses. You can
point X at a location in memory and then use indexed addressing to read or write
through it — and optionally advance the pointer automatically as you go.

There are others. They will appear when they are needed.

---

## Names for Numbers

Here are the first lines of the program source:

```asm
POLCAT  EQU     $A000           ; poll keyboard: returns char in A, 0=none
CHROUT  EQU     $A002           ; output char in A to screen via ROM
CLRSCR  EQU     $A928           ; clear text screen (direct call, stable)

CURPOS  EQU     $88             ; cursor position: 16-bit address at $88/$89
                                ; CHROUT reads this to know where to write

SCREEN  EQU     $0400           ; VDG text screen: 32 cols x 16 rows = 512 bytes
COLS    EQU     32
```

`EQU` stands for equate. It is not an instruction — it produces no machine code.
It tells the assembler: whenever you see `POLCAT`, substitute `$A000`. Whenever
you see `SCREEN`, substitute `$0400`. The CPU never sees the names. By the time
the program becomes bytes, every name has been replaced by its value.

This matters because `$A000` says nothing about what lives there. `POLCAT` says
exactly what it is. Code that reads `JSR [POLCAT]` communicates its intent to
anyone reading it. Code that reads `JSR [$A000]` requires the reader to look up
the address.

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

`JSR` is Jump to SubRoutine. It calls `CLRSCR` — which the assembler replaces
with `$A928` — and the ROM routine clears the text screen and moves the cursor to
row 0, column 0. When the ROM routine finishes, control returns here and
execution continues with the next instruction.

Next, the program sets up to write `HELLO ` to screen memory:

```asm
        LDX     #HELLO_POS      ; X = screen address for "HELLO "
        LDB     #6              ; B = 6 characters to write
```

`LDX` loads a sixteen-bit value into the index register X. `LDB` loads an
eight-bit value into accumulator B. Both use *immediate addressing*, signalled by
the `#` prefix. Immediate means the value is right there in the instruction — not
the contents of some memory address, but the number itself. `LDX #HELLO_POS`
loads the value of `HELLO_POS` directly into X. `LDB #6` loads the number six
directly into B.

The distinction matters. `LDB $06` would load whatever byte is stored at address
`$0006` — which is somewhere in RAM and could be anything. `LDB #6` loads the
number six, always, unconditionally. The `#` is the signal.

A few lines later, the space character gets the same treatment:

```asm
WriteSpace
        LDA     #$60            ; VDG space (inverted space = $60)
```

`LDA #$60` loads the byte `$60` directly into A. No memory access, no lookup —
the value is embedded in the instruction.

For setting up the cursor, the program uses the sixteen-bit accumulator:

```asm
        LDD     #WORLD_POS      ; D = screen address for "WORLD!"
```

`LDD #WORLD_POS` loads the address `WORLD_POS` as a sixteen-bit immediate value.
D is two bytes wide, so this one instruction sets both A (the high byte of the
address) and B (the low byte). You could achieve the same result with separate
`LDA` and `LDB` instructions, but `LDD` does it in one.

---

## Storing Values to Memory

Loading fills a register. Storing empties it — writes the register's content to
a memory address.

```asm
        STA     ,X+             ; write VDG code to screen, advance X
```

This is *indexed addressing*. `,X+` means: store A at the address currently in
X, then increment X by one. Each time this instruction executes, the character
goes to the next screen cell and X advances to point at the cell after that. The
full mechanics of indexed addressing are the subject of a later chapter. For now,
the picture is: X is a pointer moving through screen memory, one cell at a time.

The cursor register uses a different addressing mode:

```asm
        STD     <CURPOS         ; store to cursor position register
```

The `<` signals *direct page addressing*. The Color BASIC direct page — the
processor's page zero — lives at addresses `$00` through `$FF`. `CURPOS` is
`$88`, which is in that range. Direct page addressing uses a one-byte address
instead of two, making the instruction one byte shorter and one cycle faster. The
`<` tells the assembler to use the short form explicitly, rather than the
two-byte extended form it might otherwise choose.

The program stores to `CURPOS` twice:

```asm
        LDD     #WORLD_POS
        STD     <CURPOS         ; cursor to row 7, col 16 — for "WORLD!"

        ; ... WORLD! is printed here ...

        LDD     #EXIT_POS
        STD     <CURPOS         ; cursor to row 13, col 0 — for BASIC return
```

`CHROUT` reads the cursor position from `$88`/`$89` and writes each character
there, advancing the cursor automatically. Setting `CURPOS` before calling
`CHROUT` puts the output wherever the program wants it. Setting it again
afterward positions the cursor where `OK` will appear when BASIC resumes.

---

## What This Chapter Revealed

Six lines of equates, a JSR, two LDX/LDB loads, a space-character load, a store
through an indexed pointer, and two LDD/STD pairs moving sixteen-bit addresses
around. That is the data movement layer of this program.

The addressing modes introduced here — immediate, direct page, indexed — are
three of the four the 6809 supports. Extended (full two-byte address) is the
fourth. You have already seen it implicitly: `JSR CLRSCR` uses an extended
address. The complete picture of addressing modes, including the full power of
indexed, is Chapter 7's territory.

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
        ; LEAY Hello,PCR        — Chapter 7
        LDB     #6              ; *

WriteHello
        ; LDA ,Y+               — Chapter 7
        ; CMPA #' '             — Chapter 5
        ; BEQ  WriteSpace       — Chapter 5
        ; ANDA #$3F             — Chapter 4
        ; ORA  #$40             — Chapter 4
        ; BRA  StoreChar        — Chapter 5

WriteSpace
        LDA     #$60            ; *

StoreChar
        STA     ,X+             ; *
        ; DECB                  — Chapter 3
        ; BNE  WriteHello       — Chapter 5

        LDD     #WORLD_POS      ; *
        STD     <CURPOS         ; *
        ; LEAX World,PCR        — Chapter 7
        ; BSR  PrintStr         — Chapter 6

        LDD     #EXIT_POS       ; *
        STD     <CURPOS         ; *

WaitKey
        ; JSR [POLCAT]          — Chapter 5
        ; BEQ  WaitKey          — Chapter 5

        ; RTS                   — Chapter 6
```

Gaps remain. They will be filled, one concept at a time.

---

## Before the Next Chapter

The program knows six screen positions: `HELLO_POS`, `WORLD_POS`, `EXIT_POS`,
`SCREEN`, `COLS`, and the load address `ORG`. Only `SCREEN` and `COLS` have
appeared so far. The others are expressed as arithmetic: row seven times
thirty-two columns plus an offset. The program never calculates these values at
runtime. The assembler computed them before producing a single byte of output.

That is the next chapter: the assembler as a calculator.
