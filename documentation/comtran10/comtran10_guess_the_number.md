# GUESS THE NUMBER -- for the COMTRAN TEN

A reconstruction, not a restoration. There is no known emulator for the
Digiac COMTRAN TEN, so nothing below has ever actually run. Everything here
follows directly from `comtran10_instructions.json` and the opcode map --
every instruction used is real, documented, and used the way its
description says to use it. Where the documentation is silent (peripheral
device numbers, exactly how far indexed addressing reaches across pages)
I made a specific, stated choice rather than a silent guess. Treat those
spots as "check this against the actual manual" rather than "trust this."

This targets the 1KB (4 x 256-byte page) configuration. Guesses and the
secret number are both restricted to 1-99 -- not 1-100 -- specifically so
every arithmetic step in this listing stays single-precision (fits in one
8-bit register, no carry propagation between the Accumulator and Quotient
registers to get wrong). Handling "100" as a valid guess is a genuine next
step, left undone on purpose. It needs an extra carry-out step in exactly
the place you'd expect: the point where a two-digit value gets multiplied
by ten and could, just this once, overflow a single byte.

---

## Memory Map

```
PAGE 0 ($000-$0FF)  Variables, constants, main program
PAGE 1 ($100-$1FF)  DECOUT2 subroutine (decimal digit print)
PAGE 2 ($200-$2FF)  Message strings
PAGE 3 ($300-$3FF)  unused
```

### Variables and constants (page 0, $000-$00F)

```
$000  SECRET      the secret number, 1-99
$001  GUESSVAL    the player's current guess, accumulated here
$002  COUNT       number of guesses made so far
$003  RNGCTR      free-running counter, sampled during name entry
$004  CHARBUF     one character read from the terminal
$005  DIGITVAL    one parsed decimal digit (0-9)
$006  VALTEMP     scratch: A -> memory -> Q transfer (no direct A-Q move)
$007  QTEMP       scratch: Q -> memory -> A transfer
$008  UNITSDIG    scratch: units digit during decimal output
$009  TEN         constant byte, value 10
$00A  NINETYNINE  constant byte, value 99
$00B  ASCII0      constant byte, value $30 ('0')
$00C  CRCONST     constant byte, value $0D (carriage return)
$00D  ONECONST    constant byte, value 1
```

`TEN`, `NINETYNINE`, `ASCII0`, `CRCONST`, `ONECONST` are data, not
instructions -- they exist because `ADD`, `SUB`, `MPY`, and `DIV` only take
a memory operand. There is no immediate form of any of them. (`LA1`, `LC1`,
`LX1`, and the shift/logical group are the only instructions with a `,k`
immediate operand -- confirmed directly against the instruction list.)

---

## INIT

```
        OCD   #$11        ; select terminal peripheral, ALPHA mode
                           ; ASSUMPTION: device number and the exact bit
                           ; positions for "this is the teletype" are not
                           ; in the notes I have -- bit 4 (APH/alpha) set,
                           ; bit 3 (HEX) clear, device bits = 1. Adjust to
                           ; match the real manual's device numbering.

        LC1   #BANNERLEN-1
        WDB   BANNER       ; print the title line
```

---

## NAME ENTRY -- also the random number generator

```
NAMELP  LC1   #NAMELEN-1
        WDB   NAMEPROMPT   ; "ENTER YOUR NAME:"

ENTLP   RAO   RNGCTR       ; RNGCTR = RNGCTR + 1  (wraps at 256, harmless)
        SKI   #0           ; skip next instruction if a key is ready
        BUN   ENTLP        ; not yet -- keep spinning, keep counting

        RDI   CHARBUF      ; a key is ready -- read it
        LDA   CHARBUF
        SUB   CRCONST
        BZE   NAMEDONE     ; Enter key ends name entry
        BUN   ENTLP        ; any other key: discard it, keep counting

NAMEDONE
```

The name itself is never stored anywhere. It never needs to be -- its only
job is to make a human sit at the keyboard for a few unpredictable seconds
while `RNGCTR` free-runs underneath them. `SKI` (Skip on Interrupt) is
doing the polling; `RAO` is doing the counting. Neither instruction knows
it's being used to generate randomness. That's the whole trick.

```
        LDQ   RNGCTR       ; Q = RNGCTR
        LA1   #0           ; A = 0  (AQ is now a 16-bit dividend, high byte 0)
        DIV   NINETYNINE   ; A = RNGCTR mod 99   (remainder lands in A)
        ADD   ONECONST     ; A = (RNGCTR mod 99) + 1  -->  range 1-99
        STA   SECRET
```

---

## THE GUESS LOOP

```
GUESSLP LC1   #PROMPTLEN-1
        WDB   GUESSPROMPT  ; "YOUR GUESS?"

        RDI   CHARBUF      ; first digit
        LDA   CHARBUF
        SUB   ASCII0
        STA   GUESSVAL     ; GUESSVAL = first digit, as-is (no *10 yet)

        RDI   CHARBUF      ; next character: second digit, or Enter
        LDA   CHARBUF
        SUB   CRCONST
        BZE   GOTGUESS     ; Enter -- it was a one-digit guess, done

        LDA   CHARBUF      ; it was a second digit
        SUB   ASCII0
        STA   DIGITVAL

        LDA   GUESSVAL
        MPY   TEN          ; AQ = GUESSVAL * 10
                           ; safe: GUESSVAL is 0-9 here, so the product
                           ; is 0-90 -- fits entirely in Q, A stays 0.
                           ; This is the exact spot that breaks if you
                           ; extend the range to include 100.
        STQ   GUESSVAL     ; GUESSVAL = tens digit * 10

        LDA   GUESSVAL
        ADD   DIGITVAL
        STA   GUESSVAL     ; GUESSVAL = full two-digit guess

        RDI   CHARBUF      ; consume the Enter that follows the 2nd digit

GOTGUESS
        RAO   COUNT        ; one more guess, on the books

        LDA   SECRET
        SUB   GUESSVAL     ; A = SECRET - GUESSVAL
        BZE   WINGAME      ; exactly equal -- got it
        BNG   SAYHIGH      ; negative means GUESSVAL > SECRET
        BUN   SAYLOW       ; anything left over is positive: GUESSVAL < SECRET

SAYHIGH LC1   #HIGHLEN-1
        WDB   HIGHMSG      ; "TOO HIGH"
        BUN   GUESSLP

SAYLOW  LC1   #LOWLEN-1
        WDB   LOWMSG       ; "TOO LOW"
        BUN   GUESSLP
```

No `CMP` instruction exists on this machine -- there doesn't need to be
one. `SUB` already leaves the condition code set from the subtraction;
`BZE`/`BNG`/`BPS` read it same as they'd read the result of anything else.
Compare-and-branch is two independent steps here exactly the same way it
is on the 6809 -- the relationship between them exists only because I
placed them next to each other and know what each one leaves behind.

---

## WINGAME -- and the one subroutine in this program

```
WINGAME LC1   #WINLEN-1
        WDB   WINMSG       ; "YOU GOT IT.  GUESSES:"

        LDA   COUNT
        BSB   DECOUT2      ; print the guess count, then fall through here

END     BST   END          ; branch to self and stop -- there's no HALT
                           ; opcode, so a branch-to-self is the idiom
```

### DECOUT2 (page 1) -- print a 0-99 value in A as two ASCII digits + CR

```
DECOUT2 <reserved>         ; BSB overwrites these first two bytes with
        <reserved>         ; "BUN <return address>" on every call --
                           ; whatever is here at assembly time doesn't
                           ; matter, it never runs as originally written.

        STA   VALTEMP      ; the real subroutine body starts here, at
        LDQ   VALTEMP      ; DECOUT2+2 -- per BSB's own documented
        LA1   #0           ; behavior: "branch to location m+2."
        DIV   TEN          ; Q = tens digit, A = units digit (remainder)
        STA   UNITSDIG
        STQ   QTEMP
        LDA   QTEMP
        ADD   ASCII0
        STA   OUTBUF       ; tens digit, as ASCII
        LDA   UNITSDIG
        ADD   ASCII0
        STA   OUTBUF+1     ; units digit, as ASCII
                           ; OUTBUF+2 already holds CRCONST's value --
                           ; set once, at assembly time, never touched
                           ; again -- so it doesn't need setting here.
        LC1   #2           ; 3 bytes: tens, units, CR
        WDB   OUTBUF
        BUN   DECOUT2      ; return -- jumps through the return address
                           ; BSB wrote into DECOUT2's first two bytes
```

`BSB`'s documented behavior is: store a `BUN` opcode at `m`, store the
return address at `m+1`, branch to `m+2`. So the subroutine's real body
has to start two bytes after its own entry label, and "returning" is
nothing but executing `BUN <entry label>` -- which, by the time you get
there, has been quietly rewritten into `BUN <wherever you called from>`.
No stack, no link register, no dedicated return mechanism at all: the
call instruction edits the subroutine's own first instruction, in place,
every time it's called. It works precisely once per call and is overwritten
before the next one. There's a real elegance to it and a real trap in it
at the same time -- call this subroutine from two places "simultaneously"
(interrupt-driven re-entry, for instance) and the second call's return
address clobbers the first's before the first ever gets to use it. This
machine has no way to stop you from doing that.

---

## Message data (page 2)

```
BANNER      FCC "GUESS A NUMBER FROM 1 TO 99"
            FCB $0D
BANNERLEN   EQU *-BANNER

NAMEPROMPT  FCC "ENTER YOUR NAME:"
NAMELEN     EQU *-NAMEPROMPT

GUESSPROMPT FCC "YOUR GUESS?"
PROMPTLEN   EQU *-GUESSPROMPT

HIGHMSG     FCC "TOO HIGH"
            FCB $0D
HIGHLEN     EQU *-HIGHMSG

LOWMSG      FCC "TOO LOW"
            FCB $0D
LOWLEN      EQU *-LOWMSG

WINMSG      FCC "YOU GOT IT.  GUESSES:"
WINLEN      EQU *-WINMSG

OUTBUF      FCB $00,$00,$0D      ; tens digit, units digit, CR
                                  ; (first two bytes overwritten by
                                  ; DECOUT2 on every call)
```

(`FCC`/`FCB`/`EQU`/`*` here are borrowed shorthand from the CoCo side of
this project purely for readability -- the COMTRAN TEN never had an
assembler at all, so there's no real syntax to be faithful *to*. If this
were actually going in, these strings would be laid down as raw ASCII
bytes by hand, exactly the way the guessing game on the real machine was.)

---

## What I'm least sure of

In order of how much I'd want you to check them against the actual manual
before trusting this beyond a thought experiment:

1. **`OCD #$11`** -- I invented the device number and the exact meaning of
   bits 2-0. The notes tell me bit 3 is HEX mode and bit 4 is APH mode and
   that's all they tell me.
2. **`SKI`'s exact polling semantics.** I'm assuming it's a simple
   "an interrupt is currently pending" test with no side effect of its own
   -- true on a lot of machines of this vintage, not verified for this one.
3. **Indexed addressing across page boundaries.** I sidestepped this
   entirely by not using the Index register for addressing at all in this
   program -- every `WDB`/message address is a fixed, page-resolved label.
   `LX1,k`'s note that `k` is limited to `$FF` suggests the Index register
   itself may not be able to hold a full 10-bit address anyway, which is
   part of why I avoided leaning on it here.
4. **Whether a lone `RDI` really reads exactly one character per call**, or
   whether it can keep consuming characters across multiple keystrokes
   before its own internal "until interrupt" condition is satisfied. Your
   account of "reading one byte is sufficient" is the actual evidence I'm
   trusting here over my own reading of the terse note.

If any of these are wrong, the fix is local to one instruction or one
constant, not a rewrite -- which is exactly the property this whole
project has spent all day insisting matters.
