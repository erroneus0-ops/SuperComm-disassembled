;***************************************************************
;* HELLO_BEEP.ASM -- Stack Frame Return Value Demonstration    *
;*                                                             *
;* Demonstrates:                                               *
;*   1. Subroutine entry: PSHS registers at entry             *
;*   2. Stack frame as return value channel (STD n,S)         *
;*   3. Combined register restore + return: PULS D,X,Y,PC    *
;*   4. The "accidentally infinite" loop experiment           *
;*                                                             *
;* ROM entry points (Color BASIC / Extended Color BASIC):     *
;*   CHROUT  $A002 -- output character in A to screen         *
;*   LDELAY  $A7D1 -- ~1/2 second delay (counts X from 0)    *
;*   SNDENAB $A976 -- enable analog sound mux                 *
;*   SNDDISAB $A974 -- disable analog sound mux              *
;*   SNDLOOP $A964 -- sound generation loop entry             *
;*                                                             *
;* RAM locations:                                             *
;*   SNDTON  $008C -- tone frequency (1 byte)                 *
;*   SNDDUR  $008D -- tone duration (2 bytes)                 *
;*                                                             *
;* Load at $3F00, EXEC &H3F00 from Color BASIC               *
;***************************************************************

;-- ROM entry points -------------------------------------------
CHROUT   EQU   $A002       ; output char in A to screen
LDELAY   EQU   $A7D1       ; ~1/2 second delay (X counts from 0)
SNDENAB  EQU   $A976       ; enable analog sound mux (bit 3 of $FF23)
SNDDISAB EQU   $A974       ; disable analog sound mux
SNDLOOP  EQU   $A964       ; sound loop -- bypasses BASIC expr eval

;-- RAM sound parameters ---------------------------------------
SNDTON   EQU   $008C       ; tone frequency storage (1 byte)
SNDDUR   EQU   $008D       ; tone duration storage (2 bytes)

;-- Program origin ---------------------------------------------
         ORG   $3F00

;***************************************************************
;* MAIN -- calls ANNOUNCE, loops forever (intentionally)      *
;*                                                             *
;* In the "accident" experiment, ANNOUNCE corrupts its own    *
;* return address by decrementing the PC slot on the stack    *
;* by 2, causing the BSR to be re-executed forever.           *
;***************************************************************

MAIN     BSR   ANNOUNCE    ; call the demonstration routine
         BRA   MAIN        ; (never reached in the accident)
         RTS               ; (never reached in normal flow)

;***************************************************************
;* ANNOUNCE -- delay, print, beep, return with results        *
;*                                                             *
;* Entry:  (nothing required)                                 *
;* Exit:   D = row/col of cursor after print (A=row, B=col)  *
;*         X = unchanged                                      *
;*         Y = number of characters actually written          *
;*                                                             *
;* Stack frame after PSHS D,X,Y:                             *
;*   0,S  = D  (A at 0,S -- B at 1,S)                       *
;*   2,S  = X  (high byte at 2,S -- low byte at 3,S)        *
;*   4,S  = Y  (high byte at 4,S -- low byte at 5,S)        *
;*   6,S  = PC (return address, pushed by BSR)               *
;*                                                             *
;* PSHS push order (fixed by hardware, bit 6 down to bit 1): *
;*   Y pushed first (deepest), then X, then D (shallowest)   *
;*   BSR already pushed PC before we push anything           *
;*                                                             *
;* PULS pull order (fixed by hardware, bit 1 up to bit 7):  *
;*   D pulled first (shallowest), then X, then Y, then PC   *
;*   Each register lands exactly where it belongs            *
;***************************************************************

ANNOUNCE PSHS  D,X,Y       ; save caller's registers at entry
                            ; BSR's PC is already at 6,S

;-- 1. Delay approximately 1 second (two half-second delays) --
         JSR   LDELAY       ; ~1/2 second
         JSR   LDELAY       ; ~1/2 second

;-- 2. Print the message to screen ----------------------------
         LDX   #MSG         ; point X to message
         LDY   #0           ; Y = character count
PRTLOOP  LDA   ,X+          ; get next character
         BEQ   PRTDONE      ; zero terminator = end of string
         JSR   [CHROUT]     ; output character to screen
         LEAY  1,Y          ; increment character count
         BRA   PRTLOOP

PRTDONE  EQU   *

;-- 3. Short pause before beep --------------------------------
         JSR   LDELAY       ; half second pause

;-- 4. Beep ---------------------------------------------------
         LDA   #$80         ; midrange tone frequency
         STA   SNDTON       ; store tone value
         LDD   #$0040       ; short duration
         STD   SNDDUR       ; store duration value
         JSR   SNDENAB      ; enable analog sound mux
         JSR   SNDLOOP      ; generate the tone
         JSR   SNDDISAB     ; disable analog sound mux

;-- 5. Write return values into the stack frame ---------------
;       D slot (0,S) = new cursor position (A=row, B=col)
;       Y slot (4,S) = character count
;       X slot (2,S) = unchanged, nothing to report
;
;       The cursor position would normally be read from the
;       VDG cursor registers here. For this demonstration a
;       recognizable sentinel value is used for clarity.
         LDD   #$0102       ; row 1, col 2 (demonstration value)
         STD   0,S          ; update D's stack frame slot
         STY   4,S          ; update Y's stack frame slot (count)

;-- 6. Return -- one instruction restores registers AND returns
         PULS  D,X,Y,PC     ; D = new cursor pos
                            ; X = unchanged
                            ; Y = chars written
                            ; PC = return address = return

;***************************************************************
;* MSG -- null-terminated string to print                     *
;***************************************************************

MSG      FCC   "HELLO"
         FCB   $0D          ; carriage return
         FCB   $00          ; null terminator

         END   MAIN
