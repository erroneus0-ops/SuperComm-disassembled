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
         BSR   TESTW2000    ; W2000 test -- [,-S] with PRINTRET as witness
         BSR   TESTCPU      ; CPU detection -- 6809 vs 6309 via TFR 0,D
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
; W2000 test -- [,-S] with engineered known state
;
; Setup: LDS #$A003 points S just past the CHROUT dispatch entry.
;   [,-S] will decrement S to $A002, read the 2-byte pointer there
;   ($A282 = address of PUTCHR), then load A with the byte AT $A282.
;
; From bas13.rom inspection:
;   $A002-$A003 = $A282  (CHROUT dispatch pointer -> PUTCHR)
;   $A282       = $BD    (first byte of PUTCHR = JSR extended opcode)
;
; EXPECTED: A = $BD after LDA [,-S]
; If XRoar implements undocumented 6809 silicon behavior correctly,
; A will contain $BD. We compare and print Y (yes) or N (no).
;
; W2000 WARNING: this instruction is undefined by Motorola,
; absent on 6309. Diagnostic fires here.
;------------------------------------------------------------------
TESTW2000
         BSR   PRINTRET     ; print our return address as witness

; Set S to known value -- just past CHROUT dispatch entry
; Save and restore real S afterward
         PSHS  U            ; save U (we'll use U to preserve real S)
         TFR   S,U          ; save real S in U
         LDS   #$A003       ; point S just past $A002 (CHROUT dispatch)

         LDA   [,-S]        ; W2000: S decrements to $A002,
                             ; reads pointer $A282 (PUTCHR addr),
                             ; loads A with byte at $A282 = $BD (expected)

         TFR   U,S          ; restore real S from U
         PULS  U            ; restore U

; Compare result -- print 'Y' if A=$BD, 'N' if not
         CMPA  #$BD
         BNE   W2000_FAIL
         LDA   #'Y          ; correct -- XRoar implements silicon behavior
         BRA   W2000_DONE
W2000_FAIL
         LDA   #'N          ; incorrect -- XRoar doesn't match silicon
W2000_DONE
         JSR   [CHROUT]
         LDA   #$0D
         JSR   [CHROUT]
         RTS

;------------------------------------------------------------------
; PRINTSTR -- print null-terminated string pointed to by X
; Entry: X = address of string
; Exit:  X points past null terminator
;------------------------------------------------------------------
PRINTSTR LDA   ,X+
         BEQ   PSTREND
         JSR   [CHROUT]
         BRA   PRINTSTR
PSTREND  RTS

;------------------------------------------------------------------
; TESTCPU -- detect 6809 vs 6309 using TFR D,D (postbyte $00)
;
; William Astle's detection idiom:
;   6809: TFR D,D is no-op -- D stays $FFFF
;   6309: register code 0 = zero source -- D becomes $0000
;------------------------------------------------------------------
TESTCPU
         BSR   PRINTRET     ; print our return address as witness

         LDD   #$FFFF       ; pre-load D with known non-zero value
         TFR   0,D          ; 6309: postbyte $C0 -- zero register -> D = $0000
                             ; 6809: postbyte $00 -- D->D no-op, D stays $FFFF
                             ; NOTE: requires -3 (6309 mode) to assemble correctly
                             ; TFR D,D produces same postbyte $00 on both -- does NOT detect

         CMPD  #$0000
         BNE   IS6809
         LDX   #STR6309
         BRA   CPUPRINT
IS6809   LDX   #STR6809
CPUPRINT BSR   PRINTSTR
         LDA   #$0D
         JSR   [CHROUT]
         RTS

STR6809  FCC   "CPU:6809"
         FCB   $00
STR6309  FCC   "CPU:6309"
         FCB   $00

         END   MAIN
