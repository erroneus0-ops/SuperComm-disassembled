# The Stack Knows Where You've Been

## A subroutine that answers back

Most subroutines in assembly language work one way — you call them, they do something, they return. If you want a result you usually have to arrange for it to land in a specific register before the routine returns. The caller knows to look there. It works, but it requires coordination — the routine and the caller have to agree on which register carries the answer.

The 6809 offers something more elegant. Because PSHS and PULS operate on the same stack that BSR uses for the return address, a subroutine can pass multiple return values back to its caller using the stack frame it creates on entry. The caller gets the results loaded into registers automatically, as part of the return instruction itself. No extra loads. No extra stores. One instruction does everything.

To understand how, we need to look carefully at what PSHS and PULS actually do.

---

## The push/pull contract

The 6809's PSHS instruction takes a postbyte — a bitmask where each bit corresponds to a register. The hardware pushes registers in a fixed order regardless of how you write the register list in your source code. From highest bit position to lowest:

```
PSHS pushes in this order:   PC, U, Y, X, DP, B, A, CC
                              (highest bit first = deepest on stack)

PULS pulls in reverse order: CC, A, B, DP, X, Y, U, PC
                              (lowest bit first = shallowest first)
```

This symmetry is the key. If PSHS and PULS list the same registers, each register comes back to exactly where it started. The assembler syntax doesn't matter — `PSHS A,X,Y` and `PSHS Y,X,A` produce identical machine code and identical stack behavior. The hardware determines the order.

When BSR executes, it pushes the return address (PC) onto the stack before control reaches the subroutine. That means PC is always the deepest register in any frame the subroutine then creates. And since PULS pulls PC last — being the highest bit — it always reaches exactly that saved return address, no matter what other registers are stacked on top of it.

The routine pushes its registers on entry. BSR's PC sits waiting beneath them. PULS at exit unwinds everything in one instruction, landing each register correctly, returning to the caller as its final act.

---

## The stack frame as a message

Here is ANNOUNCE — a subroutine that delays, prints a message, sounds a beep, and returns results to its caller.

On entry, ANNOUNCE saves D, X, and Y:

```
ANNOUNCE PSHS  D,X,Y
```

After this instruction, the stack looks like this:

```
        low address (top of stack, S points here)
        ┌──────────────────────────────┐
  0,S   │  A  (high byte of D)        │
  1,S   │  B  (low byte of D)         │
  2,S   │  X high byte                │
  3,S   │  X low byte                 │
  4,S   │  Y high byte                │
  5,S   │  Y low byte                 │
  6,S   │  PC high byte  ← BSR saved  │
  7,S   │  PC low byte   ← BSR saved  │
        └──────────────────────────────┘
        high address (deeper on stack)
```

The frame is a structured area of memory. Every slot has a known offset from S. The routine can read from it, write to it, and the values will be there when PULS fires.

The routine does its work — delays for one second using two calls to the ROM's half-second delay routine at `$A7D1`, prints the message character by character using CHROUT, pauses again, and makes a sound through the Extended Color BASIC sound routines.

Then, instead of simply restoring what was saved, it writes its results directly into the frame:

```
        LDD   #$0102       ; new cursor position: row 1, col 2
        STD   0,S          ; overwrite D's slot

        STY   4,S          ; Y already holds the character count
```

The X slot at `2,S` is left alone — the caller asked nothing of X and ANNOUNCE has nothing to report there.

Finally:

```
        PULS  D,X,Y,PC
```

One instruction. D comes back loaded with the new cursor position. X comes back unchanged. Y comes back with the count of characters written. PC comes back with the return address, executing it in the same breath.

The caller receives three pieces of information without any additional code. The stack frame was the channel.

---

## The shape of the full program

```asm
MAIN     BSR   ANNOUNCE    ; call the routine
         BRA   MAIN        ; loop (in normal operation)

ANNOUNCE PSHS  D,X,Y       ; save registers, frame BSR's PC below

         JSR   LDELAY       ; half second
         JSR   LDELAY       ; half second (total: ~1 second delay)

         LDX   #MSG         ; point to message
         LDY   #0           ; character count starts at zero
PRTLOOP  LDA   ,X+          ; get character
         BEQ   PRTDONE      ; zero = end of string
         JSR   [CHROUT]     ; print it
         LEAY  1,Y          ; count it
         BRA   PRTLOOP

PRTDONE  JSR   LDELAY       ; half second pause before beep

         LDA   #$80         ; tone frequency
         STA   SNDTON       ; store for ROM sound routine
         LDD   #$0040       ; duration
         STD   SNDDUR
         JSR   SNDENAB      ; enable sound hardware
         JSR   SNDLOOP      ; generate tone
         JSR   SNDDISAB     ; disable sound hardware

         LDD   #$0102       ; return value: cursor position
         STD   0,S          ; write into D slot of frame
         STY   4,S          ; write char count into Y slot

         PULS  D,X,Y,PC     ; restore all, return

MSG      FCC   "HELLO"
         FCB   $0D,$00
```

Every second the user hears a beep and sees HELLO printed. The routine is working correctly. The results are flowing back through the stack. Everything is as designed.

Or almost everything.

---

## The accident

Change one line. In the section where results are written into the frame, change the offset for D:

```
         LDD   #$0102
         STD   6,S          ; wrong -- this is the PC slot
```

`6,S` is not the D slot. `6,S` is where BSR saved the return address.

The routine continues normally, runs PULS D,X,Y,PC, and returns — to address `$0102`. Which is somewhere in the zero page. Which is almost certainly not an instruction boundary. The machine executes whatever bytes happen to be there. Something bad happens.

That is one kind of accident.

Here is a more interesting one. Instead of corrupting with an arbitrary value, the routine decrements the saved PC by 2:

```
         LDD   6,S          ; load the return address
         SUBD  #2           ; subtract 2
         STD   6,S          ; write it back
```

BSR is a 2-byte instruction — opcode plus offset. The return address pushed by BSR is the address of the instruction immediately following BSR. Subtracting 2 gives the address of BSR itself.

PULS PC loads that address. The CPU jumps to BSR. BSR executes again. It pushes a new return address. ANNOUNCE runs again. Delays one second. Prints HELLO. Beeps. Decrements the return address by 2. PULS PC. BSR again.

The stack is perfectly balanced — PULS unwinds exactly what PSHS pushed, every time. There is no stack overflow. The routine returns to a valid instruction. Everything is locally correct.

The program runs forever.

The user hears a beep. Sees HELLO. Waits one second. Hears a beep. Sees HELLO. Waits one second.

Nobody crashes. Nothing burns. The machine is doing exactly what its instructions say, faithfully executing a program that was never intended to loop. The loop lives in the relationship between the off-by-two store and the return mechanism — invisible to any single instruction, invisible to the CPU, visible only to whoever reads the whole program and traces what `6,S` contains when PULS fires.

---

## What this teaches

**One: the stack frame is memory.** It has addresses. You can read from it, write to it, corrupt it accidentally. The hardware does not protect it. The assembler does not protect it. Only careful arithmetic protects it.

**Two: the push/pull order is hardware, not notation.** Writing `PSHS D,X,Y` or `PSHS Y,X,D` produces the same code. The register list is documentation for the programmer. The hardware decides the order.

**Three: PC is always last in PULS.** Bit 7, deepest on the stack, pulled last. This is why `PULS D,X,Y,PC` works as a combined restore-and-return — PC waits at the bottom of the frame, undisturbed, until PULS reaches it.

**Four: the offset arithmetic is the contract.** The frame layout is determined the moment PSHS executes. Every offset from S to every register slot is fixed. Getting one offset wrong corrupts something. Corrupting `6,S` corrupts the return address. The consequences are non-local — the bug is in ANNOUNCE, the broken behavior is in MAIN, and the connection between them is the stack frame.

**Five: local correctness does not guarantee global correctness.** Every instruction in the accident version does exactly what it was designed to do. The CPU executes them faithfully. The result is wrong anyway, because the instructions cooperate to produce a state that was never intended. Assembly language requires holding the whole machine in mind, not just the instruction in front of you.

---

## A note on the ROM entry points

The delay, print, and sound functions used here are from the Color Computer's ROM, documented in the Spectral Associates Unravelled series:

| Label    | Address | Function |
|----------|---------|---------|
| CHROUT   | `$A002` | Output character in A to screen |
| LDELAY   | `$A7D1` | Approximately 1/2 second delay |
| SNDENAB  | `$A976` | Enable analog sound multiplexer |
| SNDDISAB | `$A974` | Disable analog sound multiplexer |
| SNDLOOP  | `$A964` | Sound generation loop (bypasses BASIC expression evaluation) |

The sound routine at `$A964` requires two values pre-loaded in RAM:

| Label  | Address | Contents |
|--------|---------|---------|
| SNDTON | `$008C` | Tone frequency (1 byte, 1–255) |
| SNDDUR | `$008D` | Duration (2 bytes) |

The sound hardware on the CoCo uses a Digital to Analog Converter at `$FF20` (PIA1 Data Register A), not a simple on/off bit. The ROM routine alternates between voltage levels to produce a square wave tone. The sound multiplexer must be enabled before and disabled after the tone, which is why SNDENAB and SNDDISAB bracket the SNDLOOP call.
