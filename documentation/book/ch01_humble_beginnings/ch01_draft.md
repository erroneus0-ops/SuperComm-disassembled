# Chapter 1: Humble Beginnings

## The Listing

Before we explain anything, here is the complete program. Read it through. Don't worry about understanding every line — that is what the rest of this chapter is for. Just let it wash over you.

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

Forty-nine lines. The program is complete — not a fragment, not a skeleton. It runs. It does something. It does something interesting.

---

## Running It First

Type the following BASIC program into your Color Computer. The REM lines are comments — they explain what each section does and display as inverted text on the CoCo screen, which is a satisfying visual reminder that you are communicating with the machine.

```
10 REM HELLO WORLD
20 REM HUMBLE BEGINNINGS
30 REM
40 CLEAR 200
50 A=&H3F00
60 FOR I=0 TO 79
61 READ D:POKE A+I,D
62 NEXT I
70 EXEC A
80 REM DATA
90 DATA 189,169,40,142,4,234,49,141
...
```

*(The complete BASIC listing is in the file HELLO.BAS on the companion disk.)*

Type `RUN` and press Enter.

The screen clears. Centered on row seven, you see:

```
        HELLO WORLD!
```

The word `HELLO ` appears in inverted video — dark letters on a light background. The word `WORLD!` follows in normal green phosphor. The cursor sits patiently at the bottom of the screen. Press any key and BASIC returns with `OK`.

That is assembly language. Forty-nine lines produced something visible, immediate, and satisfying. The BASIC loader was the vehicle — the machine language was the destination.

The rest of this chapter explains exactly how it works.

---

## The Assembly Environment: Lines 1–10

### Naming Things

Lines 1 through 9 do not generate a single byte of machine code. They are `EQU` directives — short for *equate* — which give meaningful names to numbers the program uses.

```
  1  POLCAT    EQU     $A000
  2  CHROUT    EQU     $A002
  3  CLRSCR    EQU     $A928
  4  CURPOS    EQU     $0088
  5  SCREEN    EQU     $0400
  6  COLS      EQU     32
```

When the assembler sees `CLRSCR` later in the program, it substitutes `$A928`. When it sees `COLS`, it substitutes `32`. The names exist only during assembly — they help the human reader, not the machine.

Why use four hex digits for addresses like `$0088`? The address `$88` and `$0088` are identical to the assembler. But to the human eye, four digits signals *this is a memory address*, while two digits might just be a constant. Good assembly style makes the intent visible in the source.

### The Vocabulary

What are these addresses?

`$A000` and `$A002` are in the Color BASIC ROM — firmware burned permanently into the CoCo's chips. `POLCAT` polls the keyboard. `CHROUT` outputs a character to the screen. They have been at these addresses in every CoCo ever made. Our code calls them the same way the BASIC interpreter itself does.

`$A928` is the ROM routine that clears the screen and homes the cursor. Again — permanent, reliable, always there.

`$0088` is different. It is not ROM — it is a location in RAM that BASIC uses as its cursor position register. When BASIC writes a character to the screen, it reads `$0088`/`$0089` to know where to put it. We can write to `$0088` ourselves to position the cursor before calling `CHROUT`. We are reaching into BASIC's own workspace and moving the furniture.

`$0400` is the start of the VDG text screen. The Color Computer displays text by reading 512 bytes of RAM starting at this address — one byte per character cell, 32 columns across, 16 rows. Write a byte here and it appears on screen immediately. No function call, no system call — just a memory write.

### The Screen Layout

Lines 7 through 9 calculate screen positions:

```
  7  HELLO_POS EQU     SCREEN+(7*COLS)+10
  8  WORLD_POS EQU     SCREEN+(7*COLS)+16
  9  EXIT_POS  EQU     SCREEN+(13*COLS)+0
```

`SCREEN+(7*COLS)+10` means: start of screen, plus seven complete rows of 32 columns, plus 10 columns into row seven. The assembler computes this arithmetic at assembly time and bakes the result — `$04EA` — directly into the machine code. The CPU never sees the expression. It only sees the answer.

This is the first example of a fundamental concept in assembly programming: *the assembler is a calculator*. Use it. Let it do the arithmetic so you do not have to.

### Position Independent Code

Line 10 sets the origin:

```
 10            ORG     0
```

This tells the assembler to generate code as if it starts at address zero. But our BASIC loader puts the code at `$3F00` — why does it work?

Because the program is *position independent* (PIC). Every address reference inside the program is either a fixed external address (the ROM routines, the screen memory) or a relative offset from the program's own position. The program does not assume it knows where it lives — it finds its own data by looking forward and backward from where it currently is.

The `ORG 0` is a hint to the assembler about how to calculate relative offsets. When the code runs at `$3F00`, those offsets are still correct — the relative distances do not change just because the code moved.

---

## Clearing the Screen: Line 12

```
 12            JSR     CLRSCR
```

`JSR` stands for *Jump to SubRoutine*. It is three bytes of machine code that do something remarkable: they push the address of the next instruction onto the hardware stack, then jump to `CLRSCR` (`$A928`). When the ROM routine finishes, it executes `RTS` — *Return from SubRoutine* — which pops that saved address back off the stack and jumps to it. Execution returns here, to line 13, as if nothing happened in between except the screen got cleared.

The ROM routine itself is dozens of instructions. We do not write them. We do not need to understand them. We call them, they run, they return. This is the essential bargain of the subroutine: *you handle the details, I'll handle the call*.

> **The Stack**
>
> The 6809 maintains a hardware stack — a region of memory used to save and restore information automatically. When `JSR` executes, it pushes a 2-byte return address. When `RTS` executes, it pops that address and jumps to it. The stack grows downward in memory. It is the CPU's own bookkeeping system, and it enables subroutines to call other subroutines — which call other subroutines — and still find their way home.

---

## Writing HELLO in Inverted Video: Lines 13–28

This is the richest section of the program. Five of our six foundational concepts appear here, working together to write six characters to screen memory.

### Setting Up: Lines 13–15

```
 13            LDX     #HELLO_POS
 14            LEAY    Hello,PCR
 15            LDB     #6
```

Three registers, three roles.

`LDX #HELLO_POS` loads the address `$04EA` into the X register. X will walk through screen memory as we write characters. The `#` prefix means *immediate* — the value `$04EA` is encoded directly in the instruction, not fetched from memory.

`LEAY Hello,PCR` loads the address of our string data into the Y register. `PCR` stands for *Program Counter Relative* — the address is calculated as an offset from the current program counter. This is position independent addressing for data: wherever the program lives in memory, Y will correctly point to the `Hello` data that lives within it.

`LDB #6` loads the number 6 into the B register. B is our loop counter — six characters to write.

### The Loop: Lines 16–28

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

`WriteHello` is a label — a name for this address. It is the top of the loop.

**Line 17: `LDA ,Y+`** — this single instruction does two things. It loads the byte that Y currently points to into the A register, then advances Y to the next byte. The `,Y+` notation is called *post-increment indexed addressing*: use Y, then increment it. Each time through the loop, Y moves one character forward in the `Hello` string.

**Lines 18–19: `CMPA #' '` / `BEQ WriteSpace`** — compare A with the ASCII space character (`$20`). `CMPA` sets the condition codes without storing a result. `BEQ` — *Branch if Equal* — jumps to `WriteSpace` if the comparison found equality. If the character is not a space, execution falls through to line 20.

The space character needs special handling. We will come back to why.

**Lines 20–21: `ANDA #$3F` / `ORA #$40`** — here is the logic. Two instructions transform an ASCII character code into a VDG screen code with inverted video.

The Color Computer's Video Display Generator chip does not use ASCII. It has its own character encoding. The uppercase letters start at `$01` for 'A', `$02` for 'B', and so on. ASCII uppercase letters start at `$41` for 'A', `$42` for 'B'. The relationship:

```
ASCII 'H' = $48 = %01001000
VDG  'H'  = $08 = %00001000
```

Stripping the two high bits of the ASCII code gives the VDG code. `ANDA #$3F` does exactly that — `$3F` is `%00111111`, which masks off bits 7 and 6, leaving bits 5 through 0 intact.

```
$48 AND $3F = $08
```

Now for inverted video. The VDG interprets bit 6 of a character byte as a display mode flag. When bit 6 is clear, the character appears normally — a green phosphor letter on a black background. When bit 6 is set, the character appears inverted — a dark letter on a green background.

`ORA #$40` sets bit 6. `$40` is `%01000000`.

```
$08 OR $40 = $48
```

The transformed value `$48` written to screen memory produces an inverted 'H'. The reader can see this working — the `HELLO ` on screen is visually distinct from `WORLD!` because of these two instructions.

> **Bit 6 Already Set**
>
> The space character is `$20` in ASCII. Stripping the high bits gives `$00` — but VDG `$00` is the `@` character, not a space. The VDG space is `$60`, which has bit 6 already set. That is why the space needs special handling: the ASCII-to-VDG conversion does not work for it. Line 24 loads `$60` directly, bypassing the conversion.

**Line 22: `BRA StoreChar`** — *Branch Always*. An unconditional jump over the `WriteSpace` path to the `StoreChar` label.

**Lines 23–24: `WriteSpace` / `LDA #$60`** — the special case. Load the VDG space code directly.

**Line 25–26: `StoreChar` / `STA ,X+`** — store the VDG code to screen memory at X, then advance X. The character appears on screen at the moment this instruction executes.

**Lines 27–28: `DECB` / `BNE WriteHello`** — decrement B. If B is not yet zero, branch back to `WriteHello` for the next character. When B reaches zero, `BNE` does not branch and execution continues past line 28. This is the counted loop pattern: load a count, do work, decrement, branch if not done.

---

## Positioning the Cursor: Lines 29–30

```
 29            LDD     #WORLD_POS
 30            STD     <CURPOS
```

The D register is A and B combined into a 16-bit register — A is the high byte, B is the low byte. `LDD #WORLD_POS` loads the 16-bit address `$04F0` into D in a single instruction.

`STD <CURPOS` stores both bytes to memory at `$0088` and `$0089`. The `<` prefix is significant: it means *direct page addressing*. The 6809 can address the first 256 bytes of memory with a shorter, faster instruction form — one address byte instead of two. `<CURPOS` tells the assembler to use this form. The result is the same memory location, reached more efficiently.

After this instruction, the BASIC ROM's cursor position register holds `$04F0` — row 7, column 16. The next character written via `CHROUT` will appear right after `HELLO `.

---

## Writing WORLD! via the ROM: Lines 31–32

```
 31            LEAX    World,PCR
 32            BSR     PrintStr
```

`LEAX World,PCR` loads the address of the `World` string data into X, using PC-relative addressing just as we did for Y on line 14.

`BSR PrintStr` — *Branch to SubRoutine*. Like `JSR`, this pushes a return address and jumps. Unlike `JSR`, it uses a signed 8-bit offset from the current program counter rather than an absolute address. It is one byte shorter than `JSR` and enforces position independence — the offset is relative, not absolute. When `PrintStr` finishes, execution returns here and continues at line 33.

---

## Positioning the Cursor for Exit: Lines 33–34

```
 33            LDD     #EXIT_POS
 34            STD     <CURPOS
```

The same pattern as lines 29–30. This time the cursor moves to row 13, column 0 — below the displayed text and clear of it. When the program returns to BASIC, BASIC prints `OK` at the cursor position. Placing the cursor here means BASIC's output does not overwrite or crowd our display.

---

## Waiting for a Keypress: Lines 35–37

```
 35  WaitKey
 36            JSR     [POLCAT]
 37            BEQ     WaitKey
```

`JSR [POLCAT]` — note the square brackets. This is *indirect addressing*. The instruction does not jump to `$A000`. It reads the 2-byte address stored at `$A000` and jumps *there*. The brackets mean "the address of the destination is at this location, not the destination itself."

Why indirect? The ROM keyboard routine address stored at `$A000` can be changed — other software can redirect it. Using the indirect form means our code respects any such redirection, just as the BASIC ROM itself does.

`POLCAT` returns the ASCII code of any key currently pressed in the A register. If no key is pressed, A is zero. `BEQ WaitKey` branches back if A is zero — the polling loop. When a key is pressed, A is non-zero, `BEQ` does not branch, and execution falls through to line 38.

> **Enabling Interrupts**
>
> The keyboard scan on the CoCo is interrupt-driven. A timer interrupt periodically scans the keyboard matrix and stores the result. `POLCAT` reads that stored result. For this to work, the interrupt request line must be enabled. The full source includes `ANDCC #$EF` before the polling loop to ensure interrupts are enabled — clearing bit 4 of the condition code register, the IRQ mask. Without it, POLCAT may never see a keypress.

---

## Returning to BASIC: Line 38

```
 38            RTS
```

The BASIC `EXEC` statement pushed a return address onto the stack before jumping to our code. `RTS` pops it and jumps there — back into BASIC, which prints `OK` at the cursor position we set on line 34.

The program is complete. Everything that follows is the subroutine it called.

---

## The PrintStr Subroutine: Lines 39–45

```
 39  PrintStr
 40            LDA     ,X+
 41            BEQ     PrintDone
 42            JSR     [CHROUT]
 43            BRA     PrintStr
 44  PrintDone
 45            RTS
```

`PrintStr` is a complete subroutine: it has an entry point, it does its work, and it exits via `RTS`. It takes one input — the X register must point to a null-terminated string when it is called. It uses A as a working register and advances X through the string. It returns no value.

**Line 40: `LDA ,X+`** — load the byte at X into A, advance X. The same post-increment pattern we used in `WriteHello`.

**Line 41: `BEQ PrintDone`** — if A is zero, the null terminator has been reached. Branch to `PrintDone` and return.

**Line 42: `JSR [CHROUT]`** — call the ROM character output routine via indirect addressing. `CHROUT` reads the cursor position from `$0088`/`$0089`, writes the character in A to that screen location, and advances the cursor. One character appears on screen.

**Line 43: `BRA PrintStr`** — unconditional branch back to the top of the loop for the next character.

**Line 45: `RTS`** — return to the caller. The return address was pushed by the `BSR` on line 32.

This subroutine will print any null-terminated string. It does not know or care that it was called to print `WORLD!` — it would print anything pointed to by X with equal indifference. That generality is the value of a subroutine.

---

## The String Data: Lines 46–48

```
 46  Hello     FCC     "HELLO "
 47  World     FCC     "WORLD!"
 48            FCB     0
```

`FCC` — *Form Constant Characters* — instructs the assembler to place the ASCII codes of the string characters directly into the output binary. `FCB` — *Form Constant Byte* — places a single byte. The `0` on line 48 is the null terminator that `PrintStr` uses to detect the end of the `World` string.

The `Hello` and `World` labels name these locations. `LEAY Hello,PCR` on line 14 and `LEAX World,PCR` on line 31 reference them by name. The assembler calculates the correct PC-relative offsets at assembly time.

Note that `Hello` and `World` are adjacent in memory. The `Hello` string is six bytes, ending just before `World` begins. `PrintStr` is never called to print `Hello` — that string is written character by character through the VDG conversion loop. Only `World` needs a null terminator, because only `World` is passed to `PrintStr`. Line 48's `FCB 0` terminates `World` and also happens to sit immediately after it.

---

## What We Learned

Forty-nine lines demonstrated six foundational concepts:

**Data Movement** — `EQU` gives names to constants and addresses. `LDA`, `LDB`, `LDD` load values into registers. `STA`, `STD` store them to memory. The `#` prefix means immediate — the value is in the instruction itself. The `<` prefix means direct page — use the shorter, faster addressing form.

**Arithmetic** — the assembler calculated `SCREEN+(7*COLS)+10` before generating a single byte of code. `DECB` decrements a counter. The counted loop — load, work, decrement, branch — is one of the most common patterns in any assembly program.

**Logic** — `ANDA #$3F` strips bits. `ORA #$40` sets a bit. Two instructions transformed ASCII into VDG codes with inverted video. The result was immediately visible on screen — the best possible confirmation that logic operations are working correctly.

**Compare and Branch** — `CMPA` sets condition codes without storing a result. `BEQ` and `BNE` branch on those codes. `BRA` branches unconditionally. These are the building blocks of all control flow — the only way a sequential machine can make decisions.

**Stack and Subroutines** — `JSR` and `BSR` push a return address and jump. `RTS` pops it and returns. The hardware stack makes subroutines possible. `BSR` is the position-independent form. Both work on the same stack, and both must be paired with a corresponding `RTS`.

**Indexed Addressing** — `,Y+` and `,X+` load or store through a register and advance it. This is how you walk through strings, arrays, and screen memory — one element at a time, with the pointer managing itself. `PCR` addressing finds data relative to the current program counter, making the code position independent.

These six concepts are not unique to the 6809. They appear in every processor architecture, every compiled language, every operating system. The 6809 expresses them clearly and elegantly — which is why it remains a fine vehicle for learning how computers work at the level where software meets hardware.

The chapters that follow develop each concept in depth.

---

## Sidebar: The BASIC Loader

The BASIC program that loaded our machine code used several techniques worth understanding.

`CLEAR 200` reserves 200 bytes at the top of string space to protect against BASIC's garbage collector moving variables. It also resets all variable values — which is why the next line reassigns `A` rather than relying on any previous value.

`A=&H3F00` sets A to the hexadecimal address `$3F00` using BASIC's `&H` prefix for hex literals. This address is in the upper RAM area, below BASIC's program space, and safe for machine language use.

```
60 FOR I=0 TO 79
61 READ D:POKE A+I,D
62 NEXT I
```

The loop reads each DATA value into D and POKEs it to the correct memory location. `POKE` writes a byte to an arbitrary address — the same operation as `STA` in assembly language, just expressed in BASIC. After 80 POKEs, our machine code sits at `$3F00` through `$3F4F`.

`EXEC A` transfers control to address A — the same as `JSR $3F00` in assembly language. BASIC pushes a return address, jumps to our code, and waits. When our `RTS` executes, BASIC regains control and prints `OK`.

The DATA statements contain the machine code bytes as decimal numbers. `189,169,40` is `$BD $A9 $28` — the three bytes of `JSR $A928` (CLRSCR). Every instruction in the program is represented here, in order, one decimal number per byte.

---

## Sidebar: The VDG Character Set

The MC6847 Video Display Generator chip predates the widespread adoption of ASCII on personal computers. Its character encoding is its own:

- `$00` = @ (at sign)
- `$01–$1A` = A through Z
- `$1B–$1F` = [ \ ] ^ _
- `$20–$3F` = the same characters with inverted video... actually, no.

The encoding is simpler than that. Bits 5–0 select the character. Bit 6 selects normal (0) or inverted (1) video. Bit 7 is used for semigraphics on some display modes.

The uppercase letters A–Z occupy positions `$01–$1A`. Since ASCII uppercase A–Z are `$41–$5A`, the relationship is: strip bits 7 and 6 from the ASCII code. `$41 & $3F = $01`. `$5A & $3F = $1A`. The `ANDA #$3F` instruction on line 20 performs this conversion for every letter.

Space is the exception. VDG has no space at position `$00` (that is `@`). The VDG space — a blank character cell — is at position `$60`. That value already has bit 6 set, which means VDG space and inverted VDG space are the same thing. Line 24 handles this special case directly.

---

## Sidebar: Position Independent Code

Our program uses `ORG 0` but runs at `$3F00`. How?

Every address reference inside the program falls into one of two categories:

**External fixed addresses** — the ROM routines at `$A000`, `$A002`, `$A928`, and the screen memory at `$0400`. These addresses are fixed by the hardware. They do not depend on where our program lives. `JSR CLRSCR` generates `$BD $A9 $28` regardless of where in RAM the `JSR` instruction itself sits.

**Internal relative references** — `LEAY Hello,PCR`, `LEAX World,PCR`, `BSR PrintStr`, and all the conditional branches. These are offsets from the current program counter, not absolute addresses. `LEAY Hello,PCR` says "Y equals the program counter plus this offset." The offset is constant. Whether the instruction is at `$3F14` or `$4F14`, the offset to `Hello` is the same, because `Hello` moves with the program.

The `ORG 0` tells the assembler to calculate all internal offsets as if the program starts at zero. The resulting offsets are correct at any load address, because offsets are relative — they measure distance, not position.

This is why machine language programs of the era were distributed as DATA statements rather than absolute load addresses. The same bytes work at `$3F00`, at `$6000`, inside a BASIC string variable, or anywhere else that happened to be available.
