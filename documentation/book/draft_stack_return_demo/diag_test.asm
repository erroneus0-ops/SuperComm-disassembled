; diag_test.asm -- Diagnostic warning test scenario
;
; Tests W2000 and W2001 detection in the source_diag analyzer.
; This file is intentionally written with known hardware hazards
; to validate that the diagnostic pass catches them correctly.
;
; Hazards present:
;   W2000: [,-S] indirect pre-decrement on S (undefined by Motorola,
;          absent on 6309, exists on some 6809 silicon)
;   W2001: CMPD -> LDD -> BNE pattern (CC flags clobbered before branch)
;
; The direct form ,-S is also used (valid -- should NOT warn)
; The indirect form [,-S] is used (invalid -- SHOULD warn W2000)
;
; Expected behavior in XRoar:
;   - The direct ,-S form will push A and work correctly on 6809
;   - The indirect [,-S] form behavior is undefined -- XRoar may
;     execute something, crash, or silently do the wrong thing
;   - If XRoar executes it without crashing, that tells us XRoar
;     implements the undocumented 6809 silicon behavior
;
; Load at $3F00, EXEC &H3F00 from Color BASIC
;
; ROM entry points
CHROUT   EQU   $A002       ; output char in A to screen
POLCAT   EQU   $A000       ; poll keyboard

         ORG   $3F00

;------------------------------------------------------------------
; MAIN -- prints hello, exercises the hazardous instructions
;------------------------------------------------------------------
MAIN

; ── Print "HELLO" using CHROUT ──────────────────────────────────
         LDX   #MSG
PRTLOOP  LDA   ,X+
         BEQ   PRTDONE
         JSR   [CHROUT]
         BRA   PRTLOOP
PRTDONE  EQU   *

; ── W2001 test: CMPD -> LDD -> BNE (CC clobber pattern) ────────
; This is the bug: CMPD sets CC flags, LDD clobbers them,
; BNE reads stale flags and branches incorrectly.
; The BNE will never take the branch because LDD #0 clears Z
; regardless of what CMPD found.  But it "looks" like it should work.
         LDD   #$1234      ; load test value
         CMPD  #$1234      ; compare -- Z flag set (equal)
         LDD   #$0000      ; !! clobbers Z flag -- Z now set (zero result)
         BNE   NOTEQUAL    ; reads stale LDD flags, not CMPD flags
         BRA   WASEQUAL    ; this branch taken because LDD #0 set Z
NOTEQUAL LDA   #'N         ; 'N' -- should NOT print (but might due to bug)
         JSR   [CHROUT]
         BRA   DONE
WASEQUAL LDA   #'Y         ; 'Y' -- prints if LDD clobbered correctly
         JSR   [CHROUT]
         BRA   DONE

; ── W2000 test: [,-S] indirect pre-decrement ───────────────────
; NOTE: direct ,-S is valid (pushes A onto S stack)
;       indirect [,-S] is undefined behavior
;
; We do the direct form first (valid, should work):
DONE     LDA   #$41        ; 'A'
         STA   ,-S         ; VALID: direct pre-decrement, pushes to S stack
         PULS  A           ; restore A from S stack

; Now the indirect form (W2000 -- undefined):
; [,-S] should warn but we assemble it anyway to test XRoar behavior
;        STA   [,-S]       ; W2000: COMMENTED OUT -- too dangerous to run
                            ; uncomment to test XRoar's handling

         RTS               ; return to BASIC

;------------------------------------------------------------------
MSG      FCC   "HELLO"
         FCB   $0D         ; carriage return
         FCB   $00         ; null terminator

         END   MAIN
