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
find it in the reference appendix, fill in the blanks, then write the
bytes in the left margin of your template. The answers are in the Answer
Key at the end of this document — cover them until you are done.

---

### LDX #SCREEN+512

Load index register X with the immediate value `$0600`.

The assembler evaluates `SCREEN+512` = `$0400 + $0200` = `$0600`.
You provide the result — the assembler is not here.

Find **OpRef.LDX** in the instruction reference appendix. Identify the
opcode byte and determine the following two operand bytes. Note them
to complete the line below.

```
Opcode:   $XX
Operand:  $XX  $XX     (high byte = $06, low byte = $00)
```

Write in your margin:

```
__ __ __            LDX     #SCREEN+512
```

---

### LDA #$60

Load accumulator A with the immediate value `$60`.

`$60` is the space character in the VDG second character set — the same
set used by Color BASIC for normal video. This is the fill character.
You can change it later.

Find **OpRef.LDA** in the instruction reference appendix. Identify the
opcode byte and note it to complete the line below.

```
Opcode:   $XX
Operand:  $60
```

Write in your margin:

```
__ 60               LDA     #$60
```

---

### STA ,-X

Store accumulator A to the address in X, after first decrementing X by one.

This is indexed addressing with pre-decrement. The instruction has two
bytes: the opcode and a postbyte that encodes the addressing mode.

Find **OpRef.STA** in the instruction reference appendix, then
**OpRef.PB** for the postbyte. Complete the OR derivation and note
both bytes below.

```
Opcode:   $XX
Postbyte: $XX
```

OR derivation:

```
Register X field:   1 0 0 x x x x x  =  $XX
Pre-decrement mode: x x x 0 0 0 1 0  =  $XX
OR result:          1 0 0 0 0 0 1 0  =  $XX
```

Write in your margin:

```
__ __               STA     ,-X
```

This is the `Loop` label. Note the address this instruction assembles at:
`$3F05`. You will need it for the branch offset below.

---

### CMPX #SCREEN

Compare X with the immediate value `$0400`.

When X reaches `$0400` — the start of screen memory — the loop is done.
CMPX sets the condition codes without changing X.

Find **OpRef.CMPX**. Note the opcode and two operand bytes below.

```
Opcode:   $XX
Operand:  $XX  $XX     (high byte = $04, low byte = $00)
```

Write in your margin:

```
__ __ __            CMPX    #SCREEN
```

---

### BNE Loop

Branch to `Loop` if X has not yet reached `$0400`.

BNE takes a single signed byte offset. The offset is not the address of
`Loop` — it is the distance from the instruction after BNE to `Loop`.

**Where is the PC when the offset is applied?**

The CPU fetches bytes one at a time, advancing the program counter after
each fetch. BNE is two bytes: opcode and offset. By the time both are
fetched, PC points at the instruction after BNE — not at BNE itself.

```
$3F0A   26          BNE opcode     <- PC advances to $3F0B after this fetch
$3F0B   ??          offset byte    <- PC advances to $3F0C after this fetch
$3F0C   39          RTS            <- PC is here when the offset is applied
```

**Deriving the offset**

`Loop` is at `$3F05`. PC is at `$3F0C`. The branch goes backward.

```
Distance: $3F0C - $3F05 = 7 bytes back
Offset:   -7
```

**Two's complement of 7:**

```
Step 1. Write 7 in binary:    %0000 0111
Step 2. Invert every bit:     %1111 1000
Step 3. Add 1:                %1111 1001
Step 4. Group into hex:       %1111 = $F   %1001 = $9   Result: $XX
```

Verify: `$3F0C + (-7)` = `$3F05`. That is `Loop`. Correct.

Find **OpRef.BNE**. Derive the signed offset byte and note both bytes below.

```
Opcode:   $XX
Operand:  $XX
```

Write in your margin:

```
__ __               BNE     Loop
```

---

### RTS

Return to the caller (BASIC). No operand.

Find **OpRef.RTS**. Note the single opcode byte below.

```
Opcode:   $XX
```

Write in your margin:

```
__                  RTS
```

---

## Step 2: Verify Your Bytes

Your completed margin should show thirteen bytes. Count them before
checking the answer key.

```
__ __ __            LDX     #SCREEN+512
__ __               LDA     #$60
__ __               STA     ,-X
__ __ __            CMPX    #SCREEN
__ __               BNE     Loop
__                  RTS
```

If you have thirteen bytes, check your work against the Answer Key at
the end of this document.

---

## Step 3: Load and Run

Type the following BASIC program. The DATA statements contain your
hand-assembled bytes — hex strings matching what you wrote in your
margin, with the fill character on its own line.

```basic
10 A=&H3F00
20 FOR I=0 TO 12:READ H$
30 POKE A+I,VAL("&H"+H$)
40 NEXT I
50 EXEC A
60 PRINT @0,;
70 A$=INKEY$:IF A$="" THEN 70
80 DATA "8E","06","00","86"
90 DATA "60"
100 DATA "A7","82","8C","04","00"
110 DATA "26","F9","39"
```

Type `RUN` and press Enter. The screen fills from bottom-right to
top-left. BASIC prints `OK` when the routine returns.

The DATA statements map directly to your hand-assembled bytes:

- Line 80: `LDX #$0600` opcode and operand, then `LDA` opcode
- Line 90: `LDA` operand — the fill character, isolated for easy editing
- Line 100: `STA ,-X` opcode and postbyte, then `CMPX #$0400` opcode and operand
- Line 110: `BNE` opcode and offset, then `RTS`

Once it works, try these additions:

```basic
50 PRINT @0,;
60 A$=INKEY$:IF A$="" THEN 60
```

Line 50 positions the cursor without clearing the screen. Line 60
waits for a keypress before returning to BASIC — useful when the
fill happens faster than you can see it.

---

## Step 4: Change the Fill Character

Change line 90 to use a different fill character value. Try `"86"` — that
is `$86`, a graphics block character:

```basic
90 DATA "86"
```

Type `RUN`. The screen fills with a checkerboard pattern of alternating
green and black blocks. The routine is unchanged — only the fill character
is different.

Values between 64 (`$40`) and 127 (`$7F`) produce visible text characters
in normal video. Values between 128 (`$80`) and 191 (`$BF`) produce
graphics block characters. Experiment with different values and observe
the results.

Or let the CoCo choose:

```basic
41 POKE A+4,RND(256)-1
```

Add that line and run the program repeatedly. `RND(256)-1` produces a
random value from 0 to 255 — the full byte range. Every run is different.

---

## Part Two: The Chaos Experiment

The routine works correctly when loaded at `$3F00`. Now load it at `$0400`
— the start of screen memory — and see what happens.

Saving before running is advised. Unpredictable results may follow.

```basic
SAVE "FILLSCR"
```

Change line 10 of your BASIC program:

```basic
10 A=&H400
```

Everything else stays the same — the POKE and EXEC both use `A`.

This experiment is only possible because the routine is
position-independent. It contains no references to its own location
in memory — only references to the fixed hardware address `$0400`,
which is always `$0400` regardless of where the code lives. The same
thirteen bytes run identically at `$3F00` or `$0400` or anywhere else.

More on position-independent code later.

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

By loading the code into screen memory we introduced a bug. As the
routine fills backward toward `$0400`, it overwrites its own instructions
with fill character bytes. The crash pattern depends on the fill character.

If the fill character happens to be `$39` — the RTS opcode — the routine
runs normally until it replaces the BNE instruction's offset byte. At that
point the branch goes somewhere unexpected and the crash follows.

Any other fill character produces less predictable results. The processor
executes whatever opcode the fill byte represents, with whatever follows
in memory as its operand. Where it goes from there is anyone's guess.

---

## What You Just Did

You derived machine code bytes from an instruction reference and a postbyte
table. You loaded those bytes into memory. You executed them. The machine
did what you told it, exactly as you told it.

This is what the assembler does on your behalf for every instruction in
every program. For thirteen bytes it is a reasonable exercise. For nine
hundred it is not. For nine thousand it is not possible.

The assembler is not magic. It is arithmetic, applied consistently, without
mistakes, faster than you can.

---

## Answer Key

Check your work here after completing Step 2.

```
8E 06 00            LDX     #SCREEN+512
86 60               LDA     #$60
A7 82               STA     ,-X
8C 04 00            CMPX    #SCREEN
26 F9               BNE     Loop
39                  RTS
```

Thirteen bytes in sequence:

```
8E 06 00 86 60 A7 82 8C 04 00 26 F9 39
```

**STA postbyte derivation:**

```
Register X field:   1 0 0 x x x x x  =  $80
Pre-decrement mode: x x x 0 0 0 1 0  =  $02
OR result:          1 0 0 0 0 0 1 0  =  $82
```

**BNE offset derivation:**

```
PC after BNE fetch: $3F0C
Loop address:       $3F05
Distance:           7 bytes back
Two's complement:   %0000 0111 -> %1111 1000 -> %1111 1001 = $F9
```

---


The following references were used in this exercise. Specific page numbers
and chapter locations will be filled in when this document is placed in the
final book structure.

**6809 Instruction Reference — Load group**
LDX immediate, LDA immediate.

**6809 Instruction Reference — Store group**
STA indexed.

**6809 Instruction Reference — Compare group**
CMPX immediate.

**6809 Instruction Reference — Branch group**
BNE relative.

**6809 Instruction Reference — Miscellaneous group**
RTS inherent.

**Indexed Addressing Postbyte Reference**
Pre-decrement by 1 (`,-X`), postbyte derivation by OR of register
and mode fields.

---

## Appendix: Instruction Reference

This appendix contains the reference data needed to complete this exercise.
The condition code column uses these symbols: `↕` changes, `-` unchanged,
`0` always cleared.

---

### How to Read an Entry

Each instruction entry shows:

- **Operation** — what the instruction does in register-transfer notation
- **Mode** — the addressing mode used
- **Opcode** — the hex byte that identifies this instruction
- **Bytes** — total bytes including opcode and any operands
- **Cycles** — clock cycles to execute
- **CC** — effect on condition codes: H N Z V C

---

### OpRef.LDX — LDX — Load Index Register X

**Operation:** X ← M:M+1

| Mode      | Opcode | Bytes | Cycles | Syntax   |
|-----------|--------|-------|--------|----------|
| Immediate | $8E    | 3     | 3      | LDX #nn  |

The operand is a 16-bit value — two bytes, high byte first.

| CC |  H  |  N  |  Z  |  V  |  C  |
|----|-----|-----|-----|-----|-----|
|    |  -  |  ↕  |  ↕  |  0  |  -  |

---

### OpRef.LDA — LDA — Load Accumulator A

**Operation:** A ← M

| Mode      | Opcode | Bytes | Cycles | Syntax  |
|-----------|--------|-------|--------|---------|
| Immediate | $86    | 2     | 2      | LDA #n  |

The operand is an 8-bit value — one byte.

| CC |  H  |  N  |  Z  |  V  |  C  |
|----|-----|-----|-----|-----|-----|
|    |  -  |  ↕  |  ↕  |  0  |  -  |

---

### OpRef.STA — STA — Store Accumulator A

**Operation:** M ← A

| Mode    | Opcode | Bytes | Cycles | Syntax      |
|---------|--------|-------|--------|-------------|
| Indexed | $A7    | 2+    | 4+     | STA addr,R  |

Indexed mode requires a postbyte after the opcode. See **OpRef.PB**
below. Bytes and cycles shown are minimums — the postbyte may add more.

| CC |  H  |  N  |  Z  |  V  |  C  |
|----|-----|-----|-----|-----|-----|
|    |  -  |  ↕  |  ↕  |  0  |  -  |

---

### OpRef.CMPX — CMPX — Compare Index Register X

**Operation:** X − M:M+1 (result discarded, condition codes set)

| Mode      | Opcode | Bytes | Cycles | Syntax    |
|-----------|--------|-------|--------|-----------|
| Immediate | $8C    | 3     | 4      | CMPX #nn  |

The operand is a 16-bit value — two bytes, high byte first. X is not
changed. Only the condition codes reflect the result.

| CC |  H  |  N  |  Z  |  V  |  C  |
|----|-----|-----|-----|-----|-----|
|    |  -  |  ↕  |  ↕  |  ↕  |  ↕  |

---

### OpRef.BNE — BNE — Branch if Not Equal (Z=0)

**Operation:** PC ← PC + offset if Z=0

| Mode     | Opcode | Bytes | Cycles | Syntax     |
|----------|--------|-------|--------|------------|
| Relative | $26    | 2     | 3/3    | BNE label  |

The operand is a signed 8-bit offset. The offset is added to the PC
after both bytes of the instruction have been fetched. See the branch
offset derivation in Step 1.

| CC |  H  |  N  |  Z  |  V  |  C  |
|----|-----|-----|-----|-----|-----|
|    |  -  |  -  |  -  |  -  |  -  |

---

### OpRef.RTS — RTS — Return from Subroutine

**Operation:** PC ← M[SP]; SP ← SP+2

| Mode     | Opcode | Bytes | Cycles | Syntax  |
|----------|--------|-------|--------|---------|
| Inherent | $39    | 1     | 5      | RTS     |

No operand. Pulls the return address from the stack.

| CC |  H  |  N  |  Z  |  V  |  C  |
|----|-----|-----|-----|-----|-----|
|    |  -  |  -  |  -  |  -  |  -  |

---

## OpRef.PB — Appendix: Indexed Addressing Postbyte

Every instruction using indexed addressing requires a postbyte immediately
after the opcode. The postbyte encodes the pointer register and the
addressing mode.

The postbyte is derived by OR-ing the register field and the mode field.
The fields occupy non-overlapping bit positions.

**Bit map:**

| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|---|---|---|---|---|---|---|---|
| r | R | R | i | m | m | m | m |

```
r    = 1 for standard indexed mode
RR   = register select (00=X  01=Y  10=U  11=S)
i    = 1 for indirect mode
mmmm = mode select (see table below)
```


**Register field (bits 6-5 when bit 7=1):**

| Register | Bits 6-5 | Bit pattern     | Hex  |
|----------|----------|-----------------|------|
| X        | 00       | 1 0 0 x x x x x | $80  |
| Y        | 01       | 1 0 1 x x x x x | $A0  |
| U        | 10       | 1 1 0 x x x x x | $C0  |
| S        | 11       | 1 1 1 x x x x x | $E0  |

**Mode field (bits 3-0, bit 4=0 for non-indirect):**

| Syntax  | Bit pattern     | Hex  | +bytes | +Cycles |
|---------|-----------------|------|--------|---------|
| ,R+     | x x x 0 0 0 0 0 | $00  | 0      | +2      |
| ,R++    | x x x 0 0 0 0 1 | $01  | 0      | +3      |
| ,-R     | x x x 0 0 0 1 0 | $02  | 0      | +2      |
| ,--R    | x x x 0 0 0 1 1 | $03  | 0      | +3      |
| ,R      | x x x 0 0 1 0 0 | $04  | 0      |  0      |
| B,R     | x x x 0 0 1 0 1 | $05  | 0      | +1      |
| A,R     | x x x 0 0 1 1 0 | $06  | 0      | +1      |
| n8,R    | x x x 0 1 0 0 0 | $08  | 1      | +1      |
| n16,R   | x x x 0 1 0 0 1 | $09  | 2      | +4      |
| D,R     | x x x 0 1 0 1 1 | $0B  | 0      | +4      |

**Worked example: STA ,-X**

```
Register X:    1 0 0 x x x x x  =  $80
Mode ,-R:      x x x 0 0 0 1 0  =  $02
OR result:     1 0 0 0 0 0 1 0  =  $82
```

Opcode `$A7`, postbyte `$82` — two bytes total.
