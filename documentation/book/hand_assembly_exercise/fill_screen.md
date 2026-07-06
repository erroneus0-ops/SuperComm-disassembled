# Hand Assembly Exercise: Fill Screen

This exercise has two parts. In the first, you will encode a short machine
language routine by hand — deriving each byte from an instruction reference
and a postbyte table — and load it into the CoCo using BASIC. In the second,
you will load the same bytes at a different address and watch what happens.

---

## Before You Begin

You will need:

- A text editor with a monospaced font (Notepad, Notepad++, vi, or similar)
- The 6809 instruction reference for the instructions used here
- The indexed addressing postbyte reference

Open your text editor and copy the template below. Leave the left margin
blank — that is where you will write the bytes you derive.

```
                    SCREEN  EQU     $0400

                            ORG     $3F00

         Start      LDX     #SCREEN+512
                    LDA     #$60
         Loop       STA     ,-X
                    CMPX    #SCREEN
                    BNE     Loop
                            RTS
```

The routine fills the CoCo text screen with a single character, working
backward from the last screen position to the first. It then returns to
BASIC.

`SCREEN` is the address of the first byte of text screen memory: `$0400`.
The screen is 512 bytes long, so `SCREEN+512` = `$0600` — one byte past
the end.

---

## Step 1: Encode Each Instruction

Work through the routine one instruction at a time. For each instruction,
look it up in the reference and write the bytes in the left margin next to
the source line.

### LDX #SCREEN+512

Load index register X with the immediate value `$0600`.

The assembler evaluates `SCREEN+512` = `$0400 + $0200` = `$0600`.
You provide the result.

Look up `LDX` in the reference, immediate mode.

```
Opcode:   $8E
Operand:  $06  $00     (high byte first, then low byte)
```

Write in your margin:

```
8E 06 00            LDX     #SCREEN+512
```

### LDA #$60

Load accumulator A with the immediate value `$60`.

`$60` is the space character in the VDG second character set — the same
set used by Color BASIC for normal video. This is the fill character.
You can change it later.

Look up `LDA` in the reference, immediate mode.

```
Opcode:   $86
Operand:  $60
```

Write in your margin:

```
86 60               LDA     #$60
```

### STA ,-X

Store accumulator A to the address in X, after first decrementing X by one.

This is indexed addressing with pre-decrement. The instruction opcode is
`$A7` (STA indexed). The addressing mode is encoded in a second byte called
the postbyte.

Open the postbyte reference. Find the row for pre-decrement by 1 (`,-R`).
Find the column for register X. The postbyte value is `$82`.

Verify by OR: register X uses bits 6-5 = `00`, giving `%10000000` = `$80`.
Pre-decrement by 1 uses mode bits `0 0 0 1 0`, giving `$02`.
OR them together: `$80 | $02` = `$82`. Confirmed.

```
Opcode:   $A7
Postbyte: $82
```

Write in your margin:

```
A7 82               STA     ,-X
```

This is the `Loop` label. Note the address this instruction assembles at:
`$3F05`. You will need it for the branch offset below.

### CMPX #SCREEN

Compare X with the immediate value `$0400`.

When X reaches `$0400` — the start of screen memory — the loop is done.
CMPX sets the condition codes without changing X.

Look up `CMPX` in the reference, immediate mode.

```
Opcode:   $8C
Operand:  $04  $00
```

Write in your margin:

```
8C 04 00            CMPX    #SCREEN
```

### BNE Loop

Branch to `Loop` if the result of the previous comparison was not equal
(X has not yet reached `$0400`).

BNE takes a single signed byte offset. The offset is calculated from the
address of the instruction immediately following the branch — the byte
after the offset byte.

**Where is the PC when the offset is applied?**

The CPU fetches bytes one at a time. Each fetch advances the program
counter by one before the byte is used. BNE is a two-byte instruction:
the opcode byte and the offset byte. By the time the CPU has fetched
both, the PC has advanced twice — past the opcode, past the offset,
landing on the first byte of the next instruction.

```
$3F0A   26          BNE opcode     <- PC advances to $3F0B after this fetch
$3F0B   F9          offset byte    <- PC advances to $3F0C after this fetch
$3F0C   39          RTS            <- PC is here when the offset is applied
```

The offset is added to `$3F0C`. Not to `$3F0A` where BNE begins. Not to
`$3F0B` where the offset byte lives. To `$3F0C` — the instruction after.

**Deriving the offset**

The branch target is `Loop` at `$3F05`. That is before `$3F0C`, so the
offset is negative. How far back?

```
$3F0C - $3F05 = 7 bytes
```

The offset must be -7.

**Two's complement: expressing a negative number as a byte**

A signed byte can hold values from -128 to +127. Negative numbers are
stored in two's complement form. To find the two's complement of 7:

Step 1. Write 7 in binary:

```
%0000 0111
```

Step 2. Invert every bit:

```
%1111 1000
```

Step 3. Add 1:

```
%1111 1001
```

Step 4. Convert to hex — group the bits four at a time:

```
%1111 = $F
%1001 = $9
Result: $F9
```

The last step uses what you already know: hex is shorthand for groups of
four binary digits.

**Verify:** `$3F0C + (-7)` = `$3F0C - 7` = `$3F05`. That is `Loop`. Correct.

Look up `BNE` in the reference.

```
Opcode:   $26
Operand:  $F9
```

Write in your margin:

```
26 F9               BNE     Loop
```

### RTS

Return to the caller (BASIC).

```
Opcode:   $39
```

Write in your margin:

```
39                  RTS
```

---

## Step 2: Verify Your Bytes

Your completed margin should read:

```
8E 06 00            LDX     #SCREEN+512
86 60               LDA     #$60
A7 82               STA     ,-X
8C 04 00            CMPX    #SCREEN
26 F9               BNE     Loop
39                  RTS
```

Nine bytes total:

```
8E 06 00 86 60 A7 82 8C 04 00 26 F9 39
```

Count your bytes. If you have nine, proceed.

---

## Step 3: Load and Run

Type the following BASIC program. The DATA statement contains your nine
bytes in decimal. The program pokes them into memory starting at `$3F00`
and runs them.

```basic
10 FOR I=0 TO 8
20 READ B
30 POKE &H3F00+I,B
40 NEXT I
50 EXEC &H3F00
60 DATA 142,6,0,134,96,167,130,140,4,0,38,249,57
```

Type `RUN` and press Enter.

The screen will fill with spaces in normal video, working from the bottom
right to the top left. BASIC will print `OK` when the program returns.

If nothing happens or BASIC crashes, check your DATA values against the
decimal equivalents below:

```
$8E = 142    $06 = 6      $00 = 0
$86 = 134    $60 = 96
$A7 = 167    $82 = 130
$8C = 140    $04 = 4      $00 = 0
$26 = 38     $F9 = 249
$39 = 57
```

---

## Step 4: Change the Fill Character

The fill character is the value `$60` (decimal 96) poked at address `$3F04`
— the second byte of the `LDA #$60` instruction. You can change it without
retyping the whole program:

```basic
POKE &H3F04,42 : EXEC &H3F00
```

`42` is `*` in the VDG character set. Try other values and observe the
results. Values between `$40` and `$7F` produce visible characters in
normal video.

To hold the screen after the fill so you can see the result before BASIC
prints `OK`, add this line to your BASIC program:

```basic
45 PRINT @32,""
```

`PRINT @32` positions the cursor at screen position 32 — the second line —
so BASIC's `OK` appears there rather than overwriting the filled screen.

---

## Part Two: The Chaos Experiment

The routine works correctly when loaded at `$3F00`. Now load it at `$0400`
— the start of screen memory — and see what happens.

Change line 30 of your BASIC program:

```basic
30 POKE &H0400+I,B
```

And change line 50:

```basic
50 EXEC &H400
```

Type `RUN`.

The routine begins filling the screen from `$05FF` toward `$0400`. As it
works backward it will eventually reach the addresses where its own
instructions live. At that point it overwrites its own code with character
data. The processor continues fetching and executing whatever bytes happen
to be at the program counter — which are now fill characters, not
instructions.

What happens next depends on which character value you chose. Each character
byte will be interpreted as a 6809 opcode. Some may be harmless. Some may
cause a jump to a random address. The CoCo may freeze, crash to BASIC, or
produce unexpected screen patterns before stopping.

This is not a bug in the program. It is the program doing exactly what it
was told, in exactly the memory you told it to use. The processor has no
concept of the difference between code and data. Memory is memory.

This is why the assembler matters. Loading nine bytes at the right address
and running them is the entire job — but the right address is everything.

---

## What You Just Did

You derived machine code bytes from an instruction reference and a postbyte
table. You loaded those bytes into memory. You executed them. The machine
did what you told it, exactly as you told it.

This is what the assembler does on your behalf for every instruction in
every program. For nine bytes it is a reasonable exercise. For nine hundred
it is not. For nine thousand it is not possible.

The assembler is not magic. It is arithmetic, applied consistently, without
mistakes, faster than you can.
