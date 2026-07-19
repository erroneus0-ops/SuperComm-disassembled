; ================================================================
; GUESS.ASM -- Guess the Number
; Chapter 3: Building on the Foundation
;
; Machine code handles ONLY the comparison.
; BASIC handles all display, input, and game loop.
;
; Communication bytes at end of code:
;   Secret  -- BASIC POKEs secret number here before game starts
;   Guess   -- BASIC POKEs each guess here before EXEC
;   Result  -- machine code writes result here:
;              0 = too high
;              1 = too low
;              2 = correct
;
; ================================================================

          ORG     0               ; PIC

Start
          LDB     Guess,PCR       ; B = player's guess
          CMPB    Secret,PCR      ; compare guess to secret
                                  ; C=1: B < secret (too low)
                                  ; Z=1: B = secret (correct)
                                  ; else: B > secret (too high)

          BEQ     IsCorrect
          BCS     IsLow

IsHigh
          LDA     #0              ; result = 0 (too high)
          BRA     Done

IsLow
          LDA     #1              ; result = 1 (too low)
          BRA     Done

IsCorrect
          LDA     #2              ; result = 2 (correct)

Done
          STA     Result,PCR
          RTS

; ================================================================
; Communication bytes
; ================================================================
Secret    FCB     0
Guess     FCB     0
Result    FCB     0

          END     Start
