; ================================================================
; STRTEST.ASM -- Test STRINOUT calling convention
;
; Tests calling Color BASIC's internal STRINOUT routine at $B99C
; with X pointing to a length-prefixed string.
;
; Screen result:
;   Row 7, col 10: HELLO
;
; Assemble: lwasm --decb -o STRTEST.BIN STRTEST.ASM
;
; BASIC loader:
;   10 CLEAR 200,&H3F00
;   20 LOADM "STRTEST.BIN"
;   30 EXEC &H3F00
; ================================================================

; -- ROM Entry Points ---------------------------------------------
STRINOUT EQU    $B99C           ; print string: X = ptr to length byte + chars
                                ; calling convention: LDX #label-1 or LDX #length_byte
CLRSCR  EQU     $A928           ; clear text screen

; -- RAM Variables ------------------------------------------------
CURPOS  EQU     $88             ; cursor position: 16-bit address

; -- Screen Layout ------------------------------------------------
SCREEN  EQU     $0400
COLS    EQU     32

HELLO_POS EQU  SCREEN+(7*COLS)+10   ; row 7, col 10

; ================================================================
; MAIN
; ================================================================

        ORG     $3F00           ; fixed address for easy BASIC testing

Start
        JSR     CLRSCR          ; clear screen

        LDD     #HELLO_POS      ; position cursor at row 7, col 10
        STD     <CURPOS

        LDX     #HelloStr       ; X = pointer to length byte
        JSR     >STRINOUT       ; print it

        RTS                     ; return to BASIC

; ================================================================
; STRING DATA
; length byte + characters + null terminator ($00)
; STRINOUT scans to $00, not the length byte
; ================================================================
HelloStr FCB    21              ; length = 21
         FCC    "HELLO WORLD! --CLAUDE" ; characters
         FCB    0,0,0           ; null padding -- confirm where STRINOUT stops

        END     Start
