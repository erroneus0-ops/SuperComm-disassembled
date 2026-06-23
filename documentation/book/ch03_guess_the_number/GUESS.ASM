; ================================================================
; GUESS.ASM -- Guess the Number
; Chapter 3: Building on the Foundation
;
; The machine code handles comparison and result display.
; BASIC handles random number generation, player input, and the
; game loop. The two communicate through three bytes at the end
; of the code:
;
;   Secret  -- BASIC POKEs the secret number here before starting
;   Guess   -- BASIC POKEs each guess here before calling EXEC
;   Result  -- machine code writes 0 (keep playing) or 1 (won)
;
; BASIC program flow:
;   1. Load machine code via DATA/POKE loop
;   2. Pick secret number with RND(100), POKE into Secret
;   3. Loop: INPUT guess, POKE into Guess, EXEC
;   4. Read Result -- if 1, display win message and end
;
; ================================================================

; ── ROM Entry Points ─────────────────────────────────────────────
CHROUT    EQU     $A002           ; character output (indirect vector)

; ── RAM Variables ────────────────────────────────────────────────
CURPOS    EQU     $0088           ; BASIC cursor position register

; ── Screen Layout ────────────────────────────────────────────────
SCREEN    EQU     $0400
COLS      EQU     32
RESULT_ROW EQU    10              ; row where TOO HIGH/TOO LOW appears

; ── Load Address ─────────────────────────────────────────────────
; BASIC loads this code at 16128 ($3F00)
; Secret, Guess, Result are at known offsets from that address

          ORG     0               ; PIC -- assembled at 0

; ================================================================
; Main Entry Point
; Called by BASIC via EXEC after POKEing Guess
; Compares Guess to Secret, displays result, sets Result byte
; ================================================================

Start
; Load the player's guess into B
          LDB     Guess,PCR       ; B = player's guess

; Compare B (guess) to Secret
          CMPB    Secret,PCR      ; compare guess to secret number
                                  ; Z=1: equal (correct guess)
                                  ; C=1: B < secret (guess too low)
                                  ; C=0,Z=0: B > secret (guess too high)

          BEQ     Correct         ; equal -- player wins
          BCS     TooLow          ; guess < secret -- too low

; ── Too High ─────────────────────────────────────────────────────
TooHigh
          LDD     #SCREEN+(RESULT_ROW*COLS)
          STD     <CURPOS         ; position cursor for result message
          LEAX    TooHighMsg,PCR
          BSR     PrintStr
          CLR     Result,PCR      ; Result = 0 (keep playing)
          RTS

; ── Too Low ──────────────────────────────────────────────────────
TooLow
          LDD     #SCREEN+(RESULT_ROW*COLS)
          STD     <CURPOS
          LEAX    TooLowMsg,PCR
          BSR     PrintStr
          CLR     Result,PCR      ; Result = 0 (keep playing)
          RTS

; ── Correct ──────────────────────────────────────────────────────
Correct
          LDD     #SCREEN+(RESULT_ROW*COLS)
          STD     <CURPOS
          LEAX    CorrectMsg,PCR
          BSR     PrintStr
          LDA     #1
          STA     Result,PCR      ; Result = 1 (player won)
          RTS

; ================================================================
; Subroutine: PrintStr
; Print null-terminated string via CHROUT ROM routine
; Entry: X --> string
; ================================================================
PrintStr
          LDA     ,X+             ; load char, advance X
          BEQ     PrintDone       ; null terminator -- done
          JSR     [CHROUT]        ; output character via ROM vector
          BRA     PrintStr
PrintDone
          RTS

; ================================================================
; String Data
; ================================================================
TooHighMsg
          FCC     "TOO HIGH!       "
          FCB     0

TooLowMsg
          FCC     "TOO LOW!        "
          FCB     0

CorrectMsg
          FCC     "YOU GOT IT!!    "
          FCB     0

; ================================================================
; Communication Bytes
; BASIC reads/writes these by offset from load address (16128)
; ================================================================
Secret    FCB     0               ; secret number (BASIC POKEs before game)
Guess     FCB     0               ; current guess (BASIC POKEs before each EXEC)
Result    FCB     0               ; 0=keep playing, 1=correct guess

          END     Start
