; ================================================================
; HELLO.ASM -- Humble Beginnings
; Chapter 1: A 6809 Assembly Language Tutorial
;
; Demonstrates the six foundational concepts:
;   1. Data Movement    -- loading and storing values
;   2. Arithmetic       -- counters and address calculation
;   3. Logic            -- AND/OR to convert ASCII to VDG codes
;   4. Compare/Branch   -- loops and conditional flow
;   5. Stack/Subroutine -- BSR/RTS, saving registers
;   6. Indexed Addressing -- ,X+  ,Y+  auto-increment through memory
;
; Target:  TRS-80 Color Computer 1/2/3, Extended Color BASIC
; Format:  Position-Independent Code (PIC)
;          Loaded via BASIC VARPTR string method
;
; Screen result:
;   Row 7:  [HELLO ] WORLD!    (HELLO=inverted, WORLD!=normal)
;   Row 13: cursor (BASIC "OK" appears here on return)
;
; Assemble: lwasm --decb -o HELLO.BIN HELLO.ASM
; ================================================================

; ── ROM Entry Points ─────────────────────────────────────────────
; These are fixed addresses in the Color BASIC ROM.
; They are indirect jump vectors — the ROM may change which
; routine they point to between versions, so we use JSR [addr]
; (indirect) rather than JSR addr (direct) for portability.

POLCAT  EQU     $A000           ; poll keyboard: returns char in A, 0=none
CHROUT  EQU     $A002           ; output char in A to screen via ROM
CLRSCR  EQU     $A928           ; clear text screen (direct call, stable)
BLINKKY EQU     $A1B1           ; blink cursor at CURPOS, wait for key (ROM-version dependent)

; ── RAM Variables ────────────────────────────────────────────────
CURPOS  EQU     $88             ; cursor position: 16-bit address at $88/$89
                                ; CHROUT reads this to know where to write

; ── Screen Layout ────────────────────────────────────────────────
SCREEN  EQU     $0400           ; VDG text screen: 32 cols x 16 rows = 512 bytes
COLS    EQU     32

; Screen position formula: SCREEN + (row * COLS) + col
HELLO_POS EQU  SCREEN+(7*COLS)+10   ; row 7, col 10 = $04EA
WORLD_POS EQU  SCREEN+(7*COLS)+16   ; row 7, col 16 = $04F0
EXIT_POS  EQU  SCREEN+(13*COLS)+0   ; row 13, col 0 = $0560

; ── VDG Character Encoding ───────────────────────────────────────
; The VDG chip does NOT use ASCII. It has two character sets:
;
;   $00-$3F  first set  — on the CoCo: inverted video (green on black)
;   $40-$7F  second set — on the CoCo: normal video  (black on green)
;   $80-$FF  semigraphics block characters
;
; To place an uppercase ASCII letter in normal video:
;   ANDA #$3F   map ASCII to VDG character set (strips bits 7-6)
;               'H'=$48 -> $48 & $3F = $08
;   ORA  #$40   select normal video (black on green)
;               $08 | $40 = $48
;
; Without ORA #$40 the character stays in the first set and appears
; inverted (green on black) — which is what HELLO uses deliberately.
;
; Space: $20 is inverted space (green on black, first set)
;        $60 is normal space  (black on green, second set)
; HELLO uses $20 for its trailing space to match the inverted letters.

; ================================================================
; MAIN PROGRAM
; ================================================================

        ORG     0               ; PIC: assemble at 0, runs anywhere

; ─────────────────────────────────────────────────────────────────
; STEP 1: Clear the screen
; Concept: Subroutine call (JSR)
;          The ROM does the work — we just call it.
; ─────────────────────────────────────────────────────────────────
Start
        JSR     CLRSCR          ; clear screen, home cursor

; ─────────────────────────────────────────────────────────────────
; STEP 2: Write "HELLO " inverted to VDG screen memory directly
; Concepts: Indexed addressing (,X+ ,Y+)
;           Logic (ANDA, ORA) to convert ASCII to VDG
;           Compare and branch (loop)
;           Data movement (LDA, STA)
;
; X points into screen memory (destination)
; Y points into our string data (source)
; B counts characters remaining
; ─────────────────────────────────────────────────────────────────
        LDX     #HELLO_POS      ; X = screen address for "HELLO "
        LEAY    Hello,PCR       ; Y = address of "HELLO " data (PIC)
        LDB     #6              ; B = 6 characters to write

WriteHello
        LDA     ,Y+             ; load next ASCII char, advance Y
        CMPA    #' '            ; is it a space?
        BEQ     WriteSpace      ; load space directly: ANDA+ORA gives $60 either way,
	        		                ; but intent is clearer with an explicit load
        ANDA    #$3F            ; map ASCII to VDG character set
        ORA     #$40            ; select normal video (black on green)
        BRA     StoreChar

WriteSpace
        LDA     #$60            ; CoCo BASIC space character (Black printing, Green background)

StoreChar
        STA     ,X+             ; write VDG code to screen, advance X
        DECB                    ; one fewer character to write
        BNE     WriteHello      ; loop until B = 0

; ─────────────────────────────────────────────────────────────────
; STEP 3: Position cursor for CHROUT
; Concept: Data movement (LDD, STD)
;          Arithmetic (screen address calculation, done at assemble time)
;
; CHROUT writes to the screen address stored at $88/$89.
; We set it to row 7, col 16 so "WORLD!" follows "HELLO ".
; ─────────────────────────────────────────────────────────────────
        LDD     #WORLD_POS      ; D = screen address for "WORLD!"
        STD     <CURPOS         ; store to cursor position register

; ─────────────────────────────────────────────────────────────────
; STEP 4: Write "WORLD!" via ROM CHROUT
; Concept: BSR (Branch to SubRoutine) — our own subroutine
;          The stack: BSR pushes the return address automatically
; ─────────────────────────────────────────────────────────────────
        LEAX    World,PCR       ; X = address of "WORLD!" data (PIC)
        BSR     PrintStr        ; call our subroutine — stack saves return

; ─────────────────────────────────────────────────────────────────
; STEP 5: Position cursor for clean BASIC return
; When we RTS back to BASIC, it prints "OK" at the cursor position.
; We place it at row 13, col 0.
; ─────────────────────────────────────────────────────────────────
        LDD     #EXIT_POS       ; D = row 13, col 0
        STD     <CURPOS         ; position cursor for BASIC return

; ─────────────────────────────────────────────────────────────────
; STEP 6: Wait for keypress with blinking cursor
; Concept: Compare and branch (polling loop)
;          JSR [indirect]: calls via ROM jump vector
;
; BLINKKY ($A1B1) blinks the cursor at the current CURPOS and
; waits for a keypress, returning the key in A.
; NOTE: address is ROM-version dependent — verify before shipping.
; ─────────────────────────────────────────────────────────────────
WaitKey
        JSR     BLINKKY         ; blink cursor, wait for key — returns char in A

; ─────────────────────────────────────────────────────────────────
; STEP 7: Return to BASIC
; RTS pops the return address from the stack and jumps there.
; BASIC called us via EXEC, so we return to BASIC cleanly.
; BASIC will print "OK" at the cursor position we set in Step 5.
; ─────────────────────────────────────────────────────────────────
        RTS

; ================================================================
; SUBROUTINE: PrintStr
; Print a null-terminated ASCII string via the CHROUT ROM routine.
;
; Entry:  X = pointer to string (null-terminated)
; Uses:   A (destroyed), X (advanced to end of string)
; Stack:  BSR pushed return address; RTS pops it
;
; Concept: Subroutine structure (entry, work, RTS)
;          Indexed addressing (,X+ auto-increment)
;          Compare and branch (null terminator check)
; ================================================================
PrintStr
        LDA     ,X+             ; load next char, advance X
        BEQ     PrintDone       ; null ($00) = end of string
        JSR     [CHROUT]        ; output character in A via ROM
        BRA     PrintStr        ; loop for next character
PrintDone
        RTS                     ; return to caller (BSR saved address on stack)

; ================================================================
; STRING DATA
; ================================================================
Hello   FCC     "HELLO "        ; 6 bytes — converted to VDG in WriteHello
World   FCC     "WORLD!"        ; printed via CHROUT (ASCII, ROM converts)
        FCB     0               ; null terminator for PrintStr

        END     Start
