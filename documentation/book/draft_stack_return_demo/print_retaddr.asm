; print_retaddr.asm -- Self-inspecting subroutine demonstration
;
; PRINTRET is a subroutine that:
;   1. Reads its own return address from the S stack (0,S and 1,S)
;   2. Converts the 16-bit address to printable hex characters
;   3. Prints "$XXXX" to the screen via CHROUT
;   4. Prints a carriage return
;   5. Returns normally via RTS (stack untouched)
;
; The caller BSRs to PRINTRET. BSR pushes the return address (address
; of the instruction after the BSR) onto S before entering PRINTRET.
; PRINTRET reads that address, prints it, and returns to it.
;
; This demonstrates:
;   - Reading the S stack without disturbing it (LDD 0,S)
;   - The stack frame layout after BSR
;   - Self-referential code -- the routine knows where it was called from
;
; Also exercises the diagnostic pass:
;   - [,-S] variant included (W2000) to test XRoar behavior
;   - Stack remains valid throughout so crash risk is minimized
;
; ROM entry points
CHROUT   EQU   $A002
;
; Load at $3F00, EXEC &H3F00
         ORG   $3F00

;------------------------------------------------------------------
; MAIN
;------------------------------------------------------------------
MAIN
         BSR   PRINTRET     ; return address pushed = address of next line
         BSR   PRINTRET     ; called twice -- each prints its own caller
         RTS

;------------------------------------------------------------------
; PRINTRET -- print return address as hex, return normally
;
; Entry: return address is at 0,S (high) and 1,S (low)
; Exit:  return address unchanged, returns to caller
; Uses:  A, B, X (all restored via PSHS/PULS)
;------------------------------------------------------------------
PRINTRET PSHS  A,B,X        ; save registers -- return addr now at 6,S
                             ; frame: A@0,S  B@1,S  X@2,S  PC@4,S

; Read the return address from the stack
; After PSHS A,B,X: PC is at 4,S (2 bytes for X, 1 for B, 1 for A = 4)
         LDD   4,S          ; D = return address (high byte in A, low in B)

; Print "$" prefix
         PSHS  D            ; save return address on stack
         LDA   #'$
         JSR   [CHROUT]
         PULS  D            ; restore return address

; Print high byte (A register) as two hex digits
         PSHS  B            ; save low byte
         BSR   PRINTHEX     ; print A as two hex chars
         PULS  B            ; restore low byte

; Print low byte (B register) as two hex digits
         TFR   B,A          ; move low byte to A for PRINTHEX
         BSR   PRINTHEX

; Print carriage return
         LDA   #$0D
         JSR   [CHROUT]

; Restore registers and return
         PULS  A,B,X,PC     ; restore + return in one instruction

;------------------------------------------------------------------
; PRINTHEX -- print A as two hex digits
; Entry: A = byte to print
; Exit:  A destroyed, other registers unchanged
;------------------------------------------------------------------
PRINTHEX PSHS  A            ; save original byte
         LSRA               ; shift high nibble to low
         LSRA
         LSRA
         LSRA
         BSR   NIBBLE       ; print high nibble
         PULS  A            ; restore original byte
         ANDA  #$0F         ; mask to low nibble
         BSR   NIBBLE       ; print low nibble
         RTS

;------------------------------------------------------------------
; NIBBLE -- print low nibble of A as hex character
; Entry: A = nibble value (0-15 in low 4 bits)
;------------------------------------------------------------------
NIBBLE   CMPA  #9
         BLE   ISDIGIT
         ADDA  #7           ; A-F: add 7 to get ASCII 'A'-'F'
ISDIGIT  ADDA  #'0          ; add ASCII '0'
         JSR   [CHROUT]
         RTS

;------------------------------------------------------------------
; W2000 test -- [,-S] with stack in known state
; The return address is the only thing on S at this point.
; [,-S] will decrement S, then use the new top-of-stack value
; as a pointer to jump through. Behavior is undefined.
; Uncomment to test XRoar's handling:
;------------------------------------------------------------------
; TESTW2000
;        LDA   #$41         ; 'A'
;        STA   [,-S]        ; W2000: indirect pre-decrement on S
;        RTS

         END   MAIN
