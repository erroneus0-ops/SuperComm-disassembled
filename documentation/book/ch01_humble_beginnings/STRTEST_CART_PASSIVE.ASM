; ================================================================
; STRTEST_CART_PASSIVE.ASM -- $C000 cartridge ROM, passive variant
;
; Pairs with XRoar's -cart-autorun no -- the CART* signal never
; asserts, so no FIRQ ever fires and BASIC boots completely
; normally. This is the software equivalent of taping over pin 8
; on a real cartridge edge connector.
;
; Entry is via a manual call from BASIC:
;
;   EXEC &HC000
;
; EXEC pushes a normal return address the same way any subroutine
; call does, so this routine correctly ends in RTS -- NOT RTI.
; (Contrast with STRTEST_CART.ASM, which is entered via the
; hardware FIRQ autostart path and must end in RTI instead.)
;
; Screen result:
;   Row 7, col 10: HELLO
;
; Assemble:
;   python3 cocotools.py asm STRTEST_CART_PASSIVE.ASM \
;       -o STRTEST_CART_PASSIVE.RAW --format raw
;   python3 cocotools.py makerom STRTEST_CART_PASSIVE.RAW \
;       STRTEST_CART_PASSIVE.ROM
;
; XRoar arguments (passive load, manual EXEC required):
;   -cart-type rom -cart-rom STRTEST_CART_PASSIVE.ROM -cart-autorun no
;
; Then from the BASIC prompt:
;   EXEC &HC000
; ================================================================

; -- ROM Entry Points ---------------------------------------------
STRINOUT EQU    $B99C           ; print string: X = ptr to length byte + chars
CLRSCR  EQU     $A928           ; clear text screen

; -- RAM Variables ------------------------------------------------
CURPOS  EQU     $88             ; cursor position: 16-bit address

; -- Screen Layout ------------------------------------------------
SCREEN  EQU     $0400
COLS    EQU     32

HELLO_POS EQU  SCREEN+(7*COLS)+10   ; row 7, col 10

; ================================================================
; MAIN -- entry point for manual EXEC &HC000 (no autostart)
; ================================================================

        ORG     $C000

Start
        JSR     CLRSCR          ; clear screen

        LDD     #HELLO_POS      ; position cursor at row 7, col 10
        STD     <CURPOS

        LDX     #HelloStr       ; X = pointer to length byte
        JSR     >STRINOUT       ; print it

        RTS                     ; EXEC pushed a normal return address --
                                ; RTS is correct here, unlike the FIRQ-
                                ; entered autostart variant

; ================================================================
; STRING DATA
; length byte + characters + null terminator ($00)
; STRINOUT scans to $00, not the length byte
; ================================================================
HelloStr FCB    5               ; length = 5
         FCC    "HELLO"         ; characters
         FCB    0               ; null terminator

        END     Start
