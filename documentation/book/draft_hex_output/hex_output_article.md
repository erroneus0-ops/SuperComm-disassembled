# Printing Hex Values

## A routine worth keeping

At some point every assembly language programmer needs to print a number
in hexadecimal. BASIC's `PRINT HEX$(X)` does it in one step. In assembly
language you build it yourself — and once you have it, you keep it forever.

The routine shown here is small enough to understand completely and useful
enough to reach for constantly. It converts any byte in the A register to
two printable hexadecimal characters and sends them to the screen via
CHROUT. No lookup table. No division. Four instructions to isolate a
nibble, one branch to handle the A-F range, one addition.

---

## The building blocks

Hexadecimal has sixteen digits: 0 through 9, then A through F. A byte
contains two hex digits — the high nibble (upper four bits) and the low
nibble (lower four bits). To print a byte as hex, print the high nibble
first, then the low nibble.

The CoCo's character output ROM entry point is at `$A002`:

```asm
CHROUT   EQU   $A002       ; dispatch table entry -> PUTCHR
```

`JSR [CHROUT]` reads the two-byte pointer at `$A002`, calls PUTCHR, which
outputs the character in A to the screen at the current cursor position.

---

## The nibble printer

```asm
;------------------------------------------------------------------
; NIBBLE -- print low nibble of A as a single hex character
; Entry: A = value, only bits 3-0 are used
; Exit:  A = ASCII character printed (0-9 or A-F)
;        CC modified
;        All other registers unchanged
;------------------------------------------------------------------
NIBBLE   CMPA  #9
         BLE   ISDIGIT     ; 0-9: just add '0'
         ADDA  #7          ; A-F: skip the punctuation between '9' and 'A'
ISDIGIT  ADDA  #'0         ; convert to ASCII ('0' = $30)
         JSR   [CHROUT]    ; print it
         RTS
```

The ASCII character set places '0' through '9' at $30-$39, then several
punctuation characters at $3A-$40, then 'A' through 'F' at $41-$46. So:
- Nibble values 0-9 need only `+ $30` to become '0'-'9'
- Nibble values 10-15 need `+ $37` (which is $30 + 7, skipping the gap)

The `CMPA #9 / BLE ISDIGIT` branch handles the split. If the value is 9
or less, branch over the extra addition. If 10-15, add 7 first, then add
`$30`. The result lands on 'A'-'F'.

---

## The byte printer

```asm
;------------------------------------------------------------------
; PRINTHEX -- print A as two hex characters (high nibble first)
; Entry: A = byte to print
; Exit:  A destroyed
;        All other registers unchanged
;------------------------------------------------------------------
PRINTHEX PSHS  A           ; save the original byte
         LSRA              ; shift high nibble into low position
         LSRA
         LSRA
         LSRA
         BSR   NIBBLE      ; print high nibble
         PULS  A           ; restore original byte
         ANDA  #$0F        ; mask to low nibble only
         BSR   NIBBLE      ; print low nibble
         RTS
```

`LSRA` shifts A right by one bit, bringing a zero in from the left. Four
`LSRA` instructions move bits 7-4 into positions 3-0 — the high nibble
is now in the low nibble position, ready for NIBBLE. The original byte is
restored from the stack, masked to its lower four bits, and NIBBLE handles
it the same way.

---

## Printing a 16-bit value

A 16-bit address or register value is two bytes. Print the high byte
first (the A register after `LDD`), then the low byte (the B register):

```asm
;------------------------------------------------------------------
; PRINT16 -- print D as four hex characters
; Entry: D = 16-bit value to print
; Exit:  D destroyed
;        All other registers unchanged
;------------------------------------------------------------------
PRINT16  PSHS  B           ; save low byte
         BSR   PRINTHEX    ; print high byte (A)
         PULS  A           ; restore low byte into A
         BSR   PRINTHEX    ; print low byte
         RTS
```

A `$` prefix makes the output immediately recognizable as hexadecimal:

```asm
         LDA   #'$
         JSR   [CHROUT]    ; print prefix
         LDD   SOMEADDR    ; load 16-bit value
         BSR   PRINT16     ; print it
```

Output: `$3F02`

---

## Where this came from

This routine was written as part of a self-inspecting subroutine
demonstration. A subroutine called PRINTRET reads its own return address
directly from the hardware stack, converts it to hexadecimal, and prints
it to the screen — before returning normally to the caller.

The caller uses `BSR PRINTRET`. When BSR executes, it pushes the return
address (the address of the instruction immediately after the BSR) onto
the S stack. PRINTRET then saves A, B, and X with `PSHS D,X`, which
places the return address at offset `4,S`. `LDD 4,S` reads it without
disturbing the stack. PRINTHEX converts it. `PULS D,X,PC` restores
everything and returns.

```asm
PRINTRET PSHS  D,X         ; save registers; return addr now at 4,S
         LDA   #'$
         JSR   [CHROUT]    ; print '$' prefix
         LDD   4,S         ; read return address from stack frame
         BSR   PRINT16     ; print as four hex digits
         LDA   #$0D
         JSR   [CHROUT]    ; carriage return
         PULS  D,X,PC      ; restore and return
```

Called twice from the same program, it prints two different addresses —
each call reports exactly where in the program it was called from.

---

## Why this is useful

Any time a value needs to be inspected while a program runs, PRINTHEX
and PRINT16 provide immediate readable output with no setup beyond
loading the value into A or D. No special hardware. No debugger. The
program tells you what it knows.

The technique scales: print register contents after a calculation, print
memory addresses to verify pointer arithmetic, print loop counters to
watch progress. The output appears on the CoCo screen exactly where the
cursor sits, interleaved with whatever else the program displays.

---

## ROM entry points used

| Label  | Address | Function |
|--------|---------|---------|
| CHROUT | `$A002` | Dispatch table entry — calls PUTCHR at `$A282` |

The `JSR [CHROUT]` form uses indirect extended addressing — it reads the
two-byte pointer stored at `$A002` and calls the address found there.
This is the correct calling convention for CoCo ROM dispatch table entries.

---

## Complete listing

```asm
CHROUT   EQU   $A002

;------------------------------------------------------------------
NIBBLE   CMPA  #9
         BLE   ISDIGIT
         ADDA  #7
ISDIGIT  ADDA  #'0
         JSR   [CHROUT]
         RTS

;------------------------------------------------------------------
PRINTHEX PSHS  A
         LSRA
         LSRA
         LSRA
         LSRA
         BSR   NIBBLE
         PULS  A
         ANDA  #$0F
         BSR   NIBBLE
         RTS

;------------------------------------------------------------------
PRINT16  PSHS  B
         BSR   PRINTHEX
         PULS  A
         BSR   PRINTHEX
         RTS
```

Forty-two bytes. Reusable anywhere. Worth the space.
