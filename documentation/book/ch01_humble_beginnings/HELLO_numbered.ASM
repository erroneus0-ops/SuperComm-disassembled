  1  ; ================================================================
  2  ; HELLO.ASM -- Humble Beginnings
  3  ; Chapter 1: A 6809 Assembly Language Tutorial
  4  ;
  5  ; Demonstrates the six foundational concepts:
  6  ;   1. Data Movement    -- loading and storing values
  7  ;   2. Arithmetic       -- counters and address calculation
  8  ;   3. Logic            -- AND/OR to convert ASCII to VDG codes
  9  ;   4. Compare/Branch   -- loops and conditional flow
 10  ;   5. Stack/Subroutine -- BSR/RTS, saving registers
 11  ;   6. Indexed Addressing -- ,X+  ,Y+  auto-increment through memory
 12  ;
 13  ; Target:  TRS-80 Color Computer 1/2/3, Extended Color BASIC
 14  ; Format:  Position-Independent Code (PIC)
 15  ;          Loaded via BASIC VARPTR string method
 16  ;
 17  ; Screen result:
 18  ;   Row 7:  [HELLO ] WORLD!    (HELLO=inverted, WORLD!=normal)
 19  ;   Row 13: cursor (BASIC "OK" appears here on return)
 20  ;
 21  ; Assemble: lwasm --decb -o HELLO.BIN HELLO.ASM
 22  ; ================================================================
 23  
 24  ; ── ROM Entry Points ─────────────────────────────────────────────
 25  ; These are fixed addresses in the Color BASIC ROM.
 26  ; They are indirect jump vectors — the ROM may change which
 27  ; routine they point to between versions, so we use JSR [addr]
 28  ; (indirect) rather than JSR addr (direct) for portability.
 29  
 30  POLCAT  EQU     $A000           ; poll keyboard: returns char in A, 0=none
 31  CHROUT  EQU     $A002           ; output char in A to screen via ROM
 32  CLRSCR  EQU     $A928           ; clear text screen (direct call, stable)
 33  
 34  ; ── RAM Variables ────────────────────────────────────────────────
 35  CURPOS  EQU     $88             ; cursor position: 16-bit address at $88/$89
 36                                  ; CHROUT reads this to know where to write
 37  
 38  ; ── Screen Layout ────────────────────────────────────────────────
 39  SCREEN  EQU     $0400           ; VDG text screen: 32 cols x 16 rows = 512 bytes
 40  COLS    EQU     32
 41  
 42  ; Screen position formula: SCREEN + (row * COLS) + col
 43  HELLO_POS EQU  SCREEN+(7*COLS)+10   ; row 7, col 10 = $04EA
 44  WORLD_POS EQU  SCREEN+(7*COLS)+16   ; row 7, col 16 = $04F0
 45  EXIT_POS  EQU  SCREEN+(13*COLS)+0   ; row 13, col 0 = $0560
 46  
 47  ; ── VDG Character Encoding ───────────────────────────────────────
 48  ; The VDG chip does NOT use ASCII.
 49  ; Codes $00-$1F = letters (@, A-Z, [, \, ], ^, _)
 50  ; Code $60      = space (blank)
 51  ; Bit 6 set ($40) = inverted video (dark char on light background)
 52  ;
 53  ; To convert uppercase ASCII to VDG:
 54  ;   ANDA #$3F   strips bits 7 and 6, giving the VDG letter code
 55  ;               'H'=$48 -> $48 & $3F = $08 (VDG 'H')
 56  ;   ORA  #$40   sets bit 6 for inverted video
 57  ;               $08 | $40 = $48 (inverted 'H')
 58  ;
 59  ; Space is special: VDG space = $60 (already has bit 6 set)
 60  
 61  ; ================================================================
 62  ; MAIN PROGRAM
 63  ; ================================================================
 64  
 65          ORG     0               ; PIC: assemble at 0, runs anywhere
 66  
 67  ; ─────────────────────────────────────────────────────────────────
 68  ; STEP 1: Clear the screen
 69  ; Concept: Subroutine call (JSR)
 70  ;          The ROM does the work — we just call it.
 71  ; ─────────────────────────────────────────────────────────────────
 72  Start
 73          JSR     CLRSCR          ; clear screen, home cursor
 74  
 75  ; ─────────────────────────────────────────────────────────────────
 76  ; STEP 2: Write "HELLO " inverted to VDG screen memory directly
 77  ; Concepts: Indexed addressing (,X+ ,Y+)
 78  ;           Logic (ANDA, ORA) to convert ASCII to VDG
 79  ;           Compare and branch (loop)
 80  ;           Data movement (LDA, STA)
 81  ;
 82  ; X points into screen memory (destination)
 83  ; Y points into our string data (source)
 84  ; B counts characters remaining
 85  ; ─────────────────────────────────────────────────────────────────
 86          LDX     #HELLO_POS      ; X = screen address for "HELLO "
 87          LEAY    Hello,PCR       ; Y = address of "HELLO " data (PIC)
 88          LDB     #6              ; B = 6 characters to write
 89  
 90  WriteHello
 91          LDA     ,Y+             ; load next ASCII char, advance Y
 92          CMPA    #' '            ; is it a space?
 93          BEQ     WriteSpace      ; spaces need special handling
 94          ANDA    #$3F            ; strip bits 7-6: ASCII -> VDG code
 95          ORA     #$40            ; set bit 6: normal -> inverted video
 96          BRA     StoreChar
 97  
 98  WriteSpace
 99          LDA     #$60            ; VDG space (inverted space = $60)
100  
101  StoreChar
102          STA     ,X+             ; write VDG code to screen, advance X
103          DECB                    ; one fewer character to write
104          BNE     WriteHello      ; loop until B = 0
105  
106  ; ─────────────────────────────────────────────────────────────────
107  ; STEP 3: Position cursor for CHROUT
108  ; Concept: Data movement (LDD, STD)
109  ;          Arithmetic (screen address calculation, done at assemble time)
110  ;
111  ; CHROUT writes to the screen address stored at $88/$89.
112  ; We set it to row 7, col 16 so "WORLD!" follows "HELLO ".
113  ; ─────────────────────────────────────────────────────────────────
114          LDD     #WORLD_POS      ; D = screen address for "WORLD!"
115          STD     <CURPOS         ; store to cursor position register
116  
117  ; ─────────────────────────────────────────────────────────────────
118  ; STEP 4: Write "WORLD!" via ROM CHROUT
119  ; Concept: BSR (Branch to SubRoutine) — our own subroutine
120  ;          The stack: BSR pushes the return address automatically
121  ; ─────────────────────────────────────────────────────────────────
122          LEAX    World,PCR       ; X = address of "WORLD!" data (PIC)
123          BSR     PrintStr        ; call our subroutine — stack saves return
124  
125  ; ─────────────────────────────────────────────────────────────────
126  ; STEP 5: Position cursor for clean BASIC return
127  ; When we RTS back to BASIC, it prints "OK" at the cursor position.
128  ; We place it at row 13, col 0.
129  ; ─────────────────────────────────────────────────────────────────
130          LDD     #EXIT_POS       ; D = row 13, col 0
131          STD     <CURPOS         ; position cursor for BASIC return
132  
133  ; ─────────────────────────────────────────────────────────────────
134  ; STEP 6: Wait for keypress
135  ; Concept: Compare and branch (polling loop)
136  ;          JSR [indirect]: calls via ROM jump vector
137  ;
138  ; POLCAT returns the key pressed in A, or 0 if no key.
139  ; We loop until A is non-zero.
140  ; ─────────────────────────────────────────────────────────────────
141  WaitKey
142          JSR     [POLCAT]        ; poll keyboard via ROM indirect vector
143          BEQ     WaitKey         ; A=0 means no key — keep waiting
144  
145  ; ─────────────────────────────────────────────────────────────────
146  ; STEP 7: Return to BASIC
147  ; RTS pops the return address from the stack and jumps there.
148  ; BASIC called us via EXEC, so we return to BASIC cleanly.
149  ; BASIC will print "OK" at the cursor position we set in Step 5.
150  ; ─────────────────────────────────────────────────────────────────
151          RTS
152  
153  ; ================================================================
154  ; SUBROUTINE: PrintStr
155  ; Print a null-terminated ASCII string via the CHROUT ROM routine.
156  ;
157  ; Entry:  X = pointer to string (null-terminated)
158  ; Uses:   A (destroyed), X (advanced to end of string)
159  ; Stack:  BSR pushed return address; RTS pops it
160  ;
161  ; Concept: Subroutine structure (entry, work, RTS)
162  ;          Indexed addressing (,X+ auto-increment)
163  ;          Compare and branch (null terminator check)
164  ; ================================================================
165  PrintStr
166          LDA     ,X+             ; load next char, advance X
167          BEQ     PrintDone       ; null ($00) = end of string
168          JSR     [CHROUT]        ; output character in A via ROM
169          BRA     PrintStr        ; loop for next character
170  PrintDone
171          RTS                     ; return to caller (BSR saved address on stack)
172  
173  ; ================================================================
174  ; STRING DATA
175  ; ================================================================
176  Hello   FCC     "HELLO "        ; 6 bytes — converted to VDG in WriteHello
177  World   FCC     "WORLD!"        ; printed via CHROUT (ASCII, ROM converts)
178          FCB     0               ; null terminator for PrintStr
179  
180          END     Start
