; ================================================================
; OS-9 Level II Equates
; ================================================================
NUL      EQU    $00      ; null
CurXY    EQU    $02      ; set cursor: row+$20 col+$20 follow
BEL      EQU    $07      ; bell
BS       EQU    $08      ; backspace
LF       EQU    $0A      ; line feed
FF       EQU    $0C      ; form feed / clear screen + home
CR       EQU    $0D      ; carriage return
SUB      EQU    $1A      ; clear screen + home (alternate)
ESC      EQU    $1B      ; escape — windowing command prefix

; OS-9 Windowing (follow ESC)
W.DWSet  EQU    $20
W.Select EQU    $21
W.OWSet  EQU    $22      ; SVS CPX CPY SZX SZY PRN1 PRN2
W.OWEnd  EQU    $23
W.DWEnd  EQU    $24
W.CWArea EQU    $25      ; CPX CPY SZX SZY
W.DefClr EQU    $30
W.FColor EQU    $32      ; palette 0-15
W.Bcolor EQU    $33      ; palette 0-15
W.Border EQU    $34
W.DWProt EQU    $36
W.Font   EQU    $3A
W.BoldSw EQU    $3D
W.CurU   EQU    $41
W.CurD   EQU    $42
W.CurR   EQU    $43
W.CurL   EQU    $44
W.ClrHm  EQU    $45
W.Home   EQU    $48
W.ClrEOS EQU    $4A
W.ClrEOL EQU    $4B
W.InsLn  EQU    $4C
W.DelLn  EQU    $4D
W.DelCh  EQU    $4E
W.InsCh  EQU    $4F
W.ScRgn  EQU    $52
W.ScrlU  EQU    $53
W.ScrlD  EQU    $54
W.CurXY  EQU    $59      ; row+$20 col+$20
W.FgCol  EQU    $70
W.BgCol  EQU    $71
W.RevOn  EQU    $78
W.RevOff EQU    $79
W.UndOn  EQU    $7A
W.UndOff EQU    $7B

; Path numbers
STDIN    EQU    0
STDOUT   EQU    1
STDERR   EQU    2

; I$Open mode flags
O.Read   EQU    $01
O.Write  EQU    $02
O.RdWr   EQU    $03
O.Exec   EQU    $04
O.Dir    EQU    $05

; OS-9 I/O system calls
I$Attach EQU    $80
I$Detach EQU    $81
I$Dup    EQU    $82
I$Create EQU    $83
I$Open   EQU    $84
I$MakDir EQU    $85
I$ChgDir EQU    $86
I$Delete EQU    $87
I$Seek   EQU    $88
I$Read   EQU    $89
I$Write  EQU    $8A
I$ReadLn EQU    $8B
I$WritLn EQU    $8C
I$GetStt EQU    $8D
I$SetStt EQU    $8E
I$Close  EQU    $8F
I$DupS   EQU    $90

; OS-9 F$ system calls
F$Link   EQU    $00
F$Load   EQU    $01
F$UnLink EQU    $02
F$Fork   EQU    $03
F$Wait   EQU    $04
F$Chain  EQU    $05
F$Exit   EQU    $06
F$Mem    EQU    $07
F$Send   EQU    $08
F$Icpt   EQU    $09
F$Sleep  EQU    $0A
F$SSpd   EQU    $0B
F$ID     EQU    $0C
F$SPrior EQU    $0D
F$SSWI   EQU    $0E
F$PErr   EQU    $0F
F$PrsNam EQU    $10
F$CmpNam EQU    $11
F$SchBit EQU    $12
F$AllBit EQU    $13
F$DelBit EQU    $14
F$Time   EQU    $15
F$STime  EQU    $16
F$CRC    EQU    $17
F$GPrDsc EQU    $18
F$GBlkMp EQU    $19
F$GModDr EQU    $1A
F$CpyMem EQU    $1B
F$SUser  EQU    $1C
F$UnLoad EQU    $1D
F$RTE    EQU    $1E
F$GPrDBT EQU    $1F
F$Julian EQU    $20
F$TLink  EQU    $21
F$DFork  EQU    $22
F$DExec  EQU    $23
F$DExit  EQU    $24
F$DaTim  EQU    $25
F$ALARM  EQU    $26
F$SigMask EQU   $27
F$NMLink EQU    $28
; ================================================================

; ==============================================================
; Disassembly:  dir
; Module:       dir
; Type:         program  ($11)
; Size:         $06C0  (1728 bytes)
; Entry:        $0011
; BSS:          $017B  (379 bytes)
; CRC-24:       $ECC8CB
;
; Add notes about this module here.
; ==============================================================

; ----- Module Header -----
ModHeader
         FDB    $87CD             ; OS-9 module sync bytes
         FDB    ModCRC-ModHeader   ; module size (content + 3 CRC bytes)
         FDB    ModName           ; name offset
         FCB    $11               ; type: program
         FCB    $81               ; language
         FCB    $EE               ; attributes/parity
         FDB    Init              ; execution entry
         FDB    $017B             ; BSS size

; ----- Module Name -----
ModName
         FCS    "dir"

; ==============================================================
; Code section  $0011—$06BC  (1708 bytes)
; ==============================================================

$0011  CC 01 50            Init:          LDD #$0150            
$0014  DD 10                              STD <$10              
$0016  86 2E                              LDA #$2E               ; A = '.'
$0018  97 7A                              STA <$7A              
$001A  4F                                 CLRA                   ; A = 0
$001B  5F                                 CLRB                   ; B = 0
$001C  DD 0E                              STD <$0E              
$001E  DD 0C                              STD <$0C              
$0020  97 08                              STA <$08              
$0022  31 8D 04 44                        LEAY Dat_046A,PC       ; Y → Dat_046A
$0026  10 9F 02                           STY <$02              
$0029  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$002B  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$002C  79 A6 84                           ROL $A684             
$002D  A6 84               Loc_002D:      LDA ,X                
$002F  81 0D                              CMPA #$0D              ; compare A with CR
$0031  27 2C                              BEQ Loc_005F          
$0033  81 20                              CMPA #$20              ; compare A with ' '
$0035  27 24                              BEQ Loc_005B          
$0037  34 10                              PSHS X                
$0039  A6 80               Loc_0039:      LDA ,X+               
$003B  81 20                              CMPA #$20              ; compare A with ' '
$003D  27 06                              BEQ Loc_0045          
$003F  81 0D                              CMPA #$0D              ; compare A with CR
$0041  26 F6                              BNE Loc_0039          
$0043  30 1F                              LEAX -1,X             
$0045  9F 04               Loc_0045:      STX <$04              
$0047  35 10                              PULS X                
$0049  A6 84                              LDA ,X                
$004B  81 2D                              CMPA #$2D              ; compare A with '-'
$004D  26 05                              BNE Loc_0054          
$004F  17 01 C2                           LBSR Sub_0214          ; call Sub_0214
$0052  20 03                              BRA Loc_0057          

; --------------------------------------------------------------
$0054  17 02 1D            Loc_0054:      LBSR Sub_0274          ; call Sub_0274
$0057  9E 04               Loc_0057:      LDX <$04              
$0059  20 D2                              BRA Loc_002D          

; --------------------------------------------------------------
$005B  30 01               Loc_005B:      LEAX 1,X              
$005D  20 CE                              BRA Loc_002D          

; --------------------------------------------------------------
$005F  D7 17               Loc_005F:      STB <$17              
$0061  D6 0D                              LDB <$0D              
$0063  DA 0E                              ORB <$0E              
$0065  DA 0F                              ORB <$0F              
$0067  D7 0B                              STB <$0B              
$0069  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$006A  10 27 33 34                        LBEQ $33A2            
$006E  12                                 NOP                   
$006F  CC 01 26                           LDD #$0126            
$0072  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0075  25 1C                              BCS Loc_0093           ; C=1 (BLO)
$0077  1F 10                              TFR X,D               
$0079  C1 50                              CMPB #$50              ; compare B with 'P'
$007B  24 1F                              BCC Loc_009C           ; C=0 (BHS)
$007D  86 40                              LDA #$40               ; A = '@'
$007F  C1 40                              CMPB #$40              ; compare B with '@'
$0081  24 17                              BCC Loc_009A           ; C=0 (BHS)
$0083  86 30                              LDA #$30               ; A = '0'
$0085  C1 30                              CMPB #$30              ; compare B with '0'
$0087  24 11                              BCC Loc_009A           ; C=0 (BHS)
$0089  86 20                              LDA #$20               ; A = ' '
$008B  C1 20                              CMPB #$20              ; compare B with ' '
$008D  24 0B                              BCC Loc_009A           ; C=0 (BHS)
$008F  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0090  10 20 07 C1                        LBRA $0855            

; --------------------------------------------------------------
$0093  C1 D0               Loc_0093:      CMPB #$D0             
$0095  27 05                              BEQ Loc_009C          
$0097  16 03 B7                           LBRA Loc_0451         

; --------------------------------------------------------------
$009A  97 11               Loc_009A:      STA <$11              
$009C  1C FE               Loc_009C:      ANDCC #$FE             ; clr CC: C
$009E  35 12                              PULS A,X              
$00A0  96 17                              LDA <$17              
$00A2  8A 80                              ORA #$80              
$00A4  9E 02                              LDX <$02              
$00A6  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$00A9  10 25 03 A4                        LBCS Loc_0451         
$00AD  97 00                              STA <$00              
$00AF  9E 02                              LDX <$02              
$00B1  96 17                              LDA <$17              
$00B3  10 3F 86                           OS9 I$ChgDir           ; mode=B  name→X
$00B6  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$00B7  0B                                 FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
$00B8  27 0F                              BEQ Loc_00C9          
$00BA  96 17                              LDA <$17              
$00BC  30 8D 03 AC                        LEAX Dat_046C,PC       ; X → Dat_046C
$00C0  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$00C3  10 25 03 8A                        LBCS Loc_0451         
$00C7  97 01                              STA <$01              
$00C9  96 11               Loc_00C9:      LDA <$11              
$00CB  97 12                              STA <$12              
$00CD  96 0D                              LDA <$0D              
$00CF  9A 10                              ORA <$10              
$00D1  27 53                              BEQ Loc_0126          
$00D3  30 8D 03 97                        LEAX Dat_046E,PC       ; X → Dat_046E
$00D7  10 8E 00 0F                        LDY #$000F            
$00DB  86 01                              LDA #$01              
$00DD  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$00E0  10 25 03 6D                        LBCS Loc_0451         
$00E4  31 C8 25                           LEAY 37,U             
$00E7  9E 02                              LDX <$02              
$00E9  A6 80               Loc_00E9:      LDA ,X+               
$00EB  A7 A0                              STA ,Y+               
$00ED  81 0D                              CMPA #$0D              ; compare A with CR
$00EF  26 F8                              BNE Loc_00E9          
$00F1  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$00F2  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$00F3  27 13                              BEQ Loc_0108          
$00F5  86 2F                              LDA #$2F               ; A = '/'
$00F7  A7 3F                              STA -1,Y              
$00F9  9E 06                              LDX <$06              
$00FB  A6 80               Loc_00FB:      LDA ,X+               
$00FD  17 02 5F                           LBSR Sub_035F          ; call Sub_035F
$0100  A7 1F                              STA -1,X              
$0102  A7 A0                              STA ,Y+               
$0104  81 0D                              CMPA #$0D              ; compare A with CR
$0106  26 F3                              BNE Loc_00FB          
$0108  30 C8 25            Loc_0108:      LEAX 37,U             
$010B  10 8E 00 FF                        LDY #$00FF            
$010F  86 01                              LDA #$01              
$0111  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$0114  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0115  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0116  27 0E                              BEQ Loc_0126          
$0118  CC 01 02                           LDD #$0102            
$011B  30 8D 03 5E                        LEAX Dat_047D,PC       ; X → Dat_047D
$011F  17 05 85                           LBSR Sub_06A7          ; call Sub_06A7
$0122  10 25 03 2B                        LBCS Loc_0451         
$0126  96 00               Loc_0126:      LDA <$00              
$0128  10 8E 00 20                        LDY #$0020            
$012C  30 C8 58                           LEAX 88,U             
$012F  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$0132  10 25 03 1B                        LBCS Loc_0451         
$0136  DC 76                              LDD <$76              
$0138  DD 77                              STD <$77              
$013A  96 75                              LDA <$75              
$013C  97 76                              STA <$76              
$013E  96 58                              LDA <$58              
$0140  27 E4                              BEQ Loc_0126          
$0142  81 80                              CMPA #$80             
$0144  27 06                              BEQ Loc_014C          
$0146  84 7F                              ANDA #$7F             
$0148  91 7A                              CMPA <$7A             
$014A  27 DA                              BEQ Loc_0126          
$014C  5F                  Loc_014C:      CLRB                   ; B = 0
$014D  30 C8 58                           LEAX 88,U             
$0150  A6 80               Loc_0150:      LDA ,X+               
$0152  5C                                 INCB                  
$0153  81 80                              CMPA #$80             
$0155  25 F9                              BCS Loc_0150           ; C=1 (BLO)
$0157  D7 13                              STB <$13              
$0159  84 7F                              ANDA #$7F             
$015B  A7 1F                              STA -1,X              
$015D  86 0D                              LDA #$0D               ; A = CR
$015F  A7 84                              STA ,X                
$0161  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0162  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0163  27 0D                              BEQ Loc_0172          
$0165  30 C8 58                           LEAX 88,U             
$0168  10 9E 06                           LDY <$06              
$016B  17 01 A9                           LBSR Sub_0317          ; call Sub_0317
$016E  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$016F  09                                 FCB    $09                ; undefined opcode $09 -- not a valid 6809 instruction
$0170  27 B4               Insn_0170:     BEQ Loc_0126          
$0172  0D                  Loc_0172:      EQU    $0172            ; [*1] branch target 2 byte(s) inside Insn_0170 -- see [*1]
$0173  0B                                 FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
$0174  27 2E                              BEQ Loc_01A4          
$0176  34 40                              PSHS U                
$0178  30 C8 18                           LEAX 24,U             
$017B  C6 0D                              LDB #$0D               ; B = CR
$017D  96 76                              LDA <$76              
$017F  1F 02                              TFR D,Y               
$0181  DE 77                              LDU <$77              
$0183  96 01                              LDA <$01              
$0185  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$0187  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$018A  35 40                              PULS U                
$018C  10 25 02 C1                        LBCS Loc_0451         
$0190  96 18                              LDA <$18              
$0192  84 80                              ANDA #$80             
$0194  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0195  0E                                 FCB    $0E                ; undefined opcode $0E -- not a valid 6809 instruction
$0196  27 05                              BEQ Loc_019D          
$0198  4D                                 TSTA                  
$0199  27 8B                              BEQ Loc_0126          
$019B  20 07               Insn_019B:     BRA Loc_01A4          
$019D  0D                  Loc_019D:      EQU    $019D            ; [*2] branch target 2 byte(s) inside Insn_019B -- see [*2]
$019E  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$019F  27 03                              BEQ Loc_01A4          
$01A1  4D                                 TSTA                  
$01A2  26 82               Insn_01A2:     BNE Loc_0126          
$01A4  0D                  Loc_01A4:      EQU    $01A4            ; [*3] branch target 2 byte(s) inside Insn_01A2 -- see [*3]
$01A5  10 27 53 0F                        LBEQ $54B8            
$01A9  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$01AA  D6 13                              LDB <$13              
$01AC  D1 12                              CMPB <$12             
$01AE  2C 2F               Insn_01AE:     BGE Loc_01DF          
$01B0  0C                  Loc_01B0:      EQU    $01B0            ; [*4] branch target 2 byte(s) inside Insn_01AE -- see [*4]
$01B1  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$01B2  4F                                 CLRA                   ; A = 0
$01B3  1F 02                              TFR D,Y               
$01B5  4C                                 INCA                  
$01B6  30 C8 58                           LEAX 88,U             
$01B9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$01BC  10 25 02 91                        LBCS Loc_0451         
$01C0  96 12                              LDA <$12              
$01C2  80 10               Loc_01C2:      SUBA #$10             
$01C4  2F 19                              BLE Loc_01DF          
$01C6  C0 10                              SUBB #$10             
$01C8  2C F8                              BGE Loc_01C2          
$01CA  50                                 NEGB                  
$01CB  97 12                              STA <$12              
$01CD  4F                                 CLRA                   ; A = 0
$01CE  1F 02                              TFR D,Y               
$01D0  4C                                 INCA                  
$01D1  30 8D 03 44                        LEAX Loc_0519,PC       ; X → Loc_0519
$01D5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$01D8  10 25 02 75                        LBCS Loc_0451         
$01DC  16 FF 47                           LBRA Loc_0126         

; --------------------------------------------------------------
$01DF  86 01               Loc_01DF:      LDA #$01              
$01E1  10 8E 00 01                        LDY #$0001            
$01E5  30 8D 02 82                        LEAX Dat_046B,PC       ; X → Dat_046B
$01E9  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$01EC  10 25 02 61                        LBCS Loc_0451         
$01F0  96 11                              LDA <$11              
$01F2  97 12                              STA <$12              
$01F4  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$01F5  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$01F6  27 B8                              BEQ Loc_01B0          
$01F8  16 FF 2B                           LBRA Loc_0126         

$01FB  0D                                         ??? 
$01FC  0D                                         ??? 
$01FD  10 26 01 6D                                LBNE $036E
$0201  86 01                                      LDA #$01
$0203  30 C8 58                                   LEAX 88,U
$0206  10 8E 00 1E                                LDY #$001E
$020A  10 3F 8C                                   OS9 I$WritLn   ; path=A  buf→X
$020D  10 25 02 40                                LBCS Loc_0451
$0211  16 FF 12                                   LBRA Loc_0126
$0214  30 01               Sub_0214:      LEAX 1,X              
$0216  A6 84                              LDA ,X                
$0218  81 20                              CMPA #$20              ; compare A with ' '
$021A  27 28                              BEQ Loc_0244          
$021C  81 0D                              CMPA #$0D              ; compare A with CR
$021E  27 24                              BEQ Loc_0244          
$0220  84 DF                              ANDA #$DF             
$0222  81 45                              CMPA #$45              ; compare A with 'E'
$0224  27 38                              BEQ Loc_025E          
$0226  81 53                              CMPA #$53              ; compare A with 'S'
$0228  27 30                              BEQ Loc_025A          
$022A  81 44                              CMPA #$44              ; compare A with 'D'
$022C  27 36                              BEQ Loc_0264          
$022E  81 46                              CMPA #$46              ; compare A with 'F'
$0230  27 38                              BEQ Loc_026A          
$0232  81 58                              CMPA #$58              ; compare A with 'X'
$0234  27 20                              BEQ Loc_0256          
$0236  81 43                              CMPA #$43              ; compare A with 'C'
$0238  27 0B                              BEQ Loc_0245          
$023A  81 4C                              CMPA #$4C              ; compare A with 'L'
$023C  27 20                              BEQ Loc_025E          
$023E  81 41                              CMPA #$41              ; compare A with 'A'
$0240  27 2E                              BEQ Loc_0270          
$0242  20 05                              BRA Loc_0249          

; --------------------------------------------------------------
$0244  39                  Loc_0244:      RTS                    ; return from subroutine
$0245  0C                  Loc_0245:      EQU    $0245            ; [*5] branch target 1 byte(s) inside Loc_0244 -- see [*5]
$0246  08                                 FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
$0247  20 CB                              BRA Sub_0214          

; --------------------------------------------------------------
$0249  CC 01 0C            Loc_0249:      LDD #$010C            
$024C  30 8D 02 DC                        LEAX Dat_052C,PC       ; X → Dat_052C
$0250  17 04 54                           LBSR Sub_06A7          ; call Sub_06A7
$0253  16 01 FB                           LBRA Loc_0451         

; --------------------------------------------------------------
$0256  CB 04               Loc_0256:      ADDB #$04             
$0258  20 BA               Insn_0258:     BRA Sub_0214          
$025A  0F                  Loc_025A:      EQU    $025A            ; [*6] branch target 2 byte(s) inside Insn_0258 -- see [*6]
$025B  10 20 B6 0C         Insn_025B:     LBRA $B86B            
$025E  0C                  Loc_025E:      EQU    $025E            ; [*7] branch target 3 byte(s) inside Insn_025B -- see [*7]
$025F  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0260  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0261  10 20 B0 0C         Insn_0261:     LBRA $B271            
$0264  0C                  Loc_0264:      EQU    $0264            ; [*8] branch target 3 byte(s) inside Insn_0261 -- see [*8]
$0265  0E                                 FCB    $0E                ; undefined opcode $0E -- not a valid 6809 instruction
$0266  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0267  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0268  20 AA               Insn_0268:     BRA Sub_0214          
$026A  0C                  Loc_026A:      EQU    $026A            ; [*9] branch target 2 byte(s) inside Insn_0268 -- see [*9]
$026B  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$026C  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$026D  0E                                 FCB    $0E                ; undefined opcode $0E -- not a valid 6809 instruction
$026E  20 A4               Insn_026E:     BRA Sub_0214          
$0270  0F                  Loc_0270:      EQU    $0270            ; [*10] branch target 2 byte(s) inside Insn_026E -- see [*10]
$0271  7A 20 A0                           DEC $20A0             
$0274  9F 02               Sub_0274:      STX <$02              
$0276  A6 80               Loc_0276:      LDA ,X+               
$0278  81 5F                              CMPA #$5F              ; compare A with '_'
$027A  27 FA                              BEQ Loc_0276          
$027C  81 2D                              CMPA #$2D              ; compare A with '-'
$027E  27 F6                              BEQ Loc_0276          
$0280  81 2E                              CMPA #$2E              ; compare A with '.'
$0282  25 14                              BCS Loc_0298           ; C=1 (BLO)
$0284  81 39                              CMPA #$39              ; compare A with '9'
$0286  23 EE                              BLS Loc_0276          
$0288  81 41                              CMPA #$41              ; compare A with 'A'
$028A  25 0C                              BCS Loc_0298           ; C=1 (BLO)
$028C  81 5A                              CMPA #$5A              ; compare A with 'Z'
$028E  23 E6                              BLS Loc_0276          
$0290  81 61                              CMPA #$61              ; compare A with 'a'
$0292  25 04                              BCS Loc_0298           ; C=1 (BLO)
$0294  81 7A                              CMPA #$7A              ; compare A with 'z'
$0296  23 DE                              BLS Loc_0276          
$0298  81 0D               Loc_0298:      CMPA #$0D              ; compare A with CR
$029A  27 08                              BEQ Loc_02A4          
$029C  81 20                              CMPA #$20              ; compare A with ' '
$029E  26 05                              BNE Loc_02A5          
$02A0  86 0D                              LDA #$0D               ; A = CR
$02A2  A7 82                              STA ,-X               
$02A4  39                  Loc_02A4:      RTS                    ; return from subroutine
$02A5  81 2A               Loc_02A5:      CMPA #$2A              ; compare A with '*'
$02A7  27 0B                              BEQ Loc_02B4          
$02A9  81 3F                              CMPA #$3F              ; compare A with '?'
$02AB  27 07                              BEQ Loc_02B4          
$02AD  C6 EB                              LDB #$EB              
$02AF  1A 01                              ORCC #$01              ; set CC: C
$02B1  16 01 9D                           LBRA Loc_0451         

; --------------------------------------------------------------
$02B4  9F 06               Loc_02B4:      STX <$06              
$02B6  A6 80               Loc_02B6:      LDA ,X+               
$02B8  81 0D                              CMPA #$0D              ; compare A with CR
$02BA  27 08                              BEQ Loc_02C4          
$02BC  81 20                              CMPA #$20              ; compare A with ' '
$02BE  26 F6                              BNE Loc_02B6          
$02C0  86 0D                              LDA #$0D               ; A = CR
$02C2  A7 82                              STA ,-X               
$02C4  9E 06               Loc_02C4:      LDX <$06              
$02C6  A6 82               Loc_02C6:      LDA ,-X               
$02C8  9C 02                              CMPX <$02             
$02CA  26 0A                              BNE Loc_02D6          
$02CC  9F 06                              STX <$06              
$02CE  30 8D 01 98                        LEAX Dat_046A,PC       ; X → Dat_046A
$02D2  9F 02                              STX <$02              
$02D4  20 0A                              BRA Loc_02E0          

; --------------------------------------------------------------
$02D6  81 2F               Loc_02D6:      CMPA #$2F              ; compare A with '/'
$02D8  26 EC                              BNE Loc_02C6          
$02DA  86 0D                              LDA #$0D               ; A = CR
$02DC  A7 80                              STA ,X+               
$02DE  9F 06               Insn_02DE:     STX <$06              
$02E0  0C                  Loc_02E0:      EQU    $02E0            ; [*11] branch target 2 byte(s) inside Insn_02DE -- see [*11]
$02E1  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$02E2  9E 06                              LDX <$06              
$02E4  86 0D               Loc_02E4:      LDA #$0D               ; A = CR
$02E6  A1 84                              CMPA ,X               
$02E8  27 2C                              BEQ Loc_0316          
$02EA  86 2A                              LDA #$2A               ; A = '*'
$02EC  A1 84                              CMPA ,X               
$02EE  27 04                              BEQ Loc_02F4          
$02F0  30 01                              LEAX 1,X              
$02F2  20 F0                              BRA Loc_02E4          

; --------------------------------------------------------------
$02F4  31 01               Loc_02F4:      LEAY 1,X              
$02F6  A1 A4                              CMPA ,Y               
$02F8  27 0A                              BEQ Loc_0304          
$02FA  86 3F                              LDA #$3F               ; A = '?'
$02FC  A1 A4                              CMPA ,Y               
$02FE  27 0E                              BEQ Loc_030E          
$0300  30 01                              LEAX 1,X              
$0302  20 E0                              BRA Loc_02E4          

; --------------------------------------------------------------
$0304  A6 A0               Loc_0304:      LDA ,Y+               
$0306  A7 3E                              STA -2,Y              
$0308  81 0D                              CMPA #$0D              ; compare A with CR
$030A  26 F8                              BNE Loc_0304          
$030C  20 D6                              BRA Loc_02E4          

; --------------------------------------------------------------
$030E  A7 80               Loc_030E:      STA ,X+               
$0310  86 2A                              LDA #$2A               ; A = '*'
$0312  A7 84                              STA ,X                
$0314  20 CE                              BRA Loc_02E4          

; --------------------------------------------------------------
$0316  39                  Loc_0316:      RTS                    ; return from subroutine
$0317  A6 84               Sub_0317:      LDA ,X                
$0319  8D 44                              BSR Sub_035F           ; call Sub_035F
$031B  E6 A4                              LDB ,Y                
$031D  DD 15                              STD <$15              
$031F  C1 0D                              CMPB #$0D              ; compare B with CR
$0321  26 06                              BNE Loc_0329          
$0323  81 0D                              CMPA #$0D              ; compare A with CR
$0325  27 30                              BEQ Loc_0357          
$0327  20 33                              BRA Loc_035C          

; --------------------------------------------------------------
$0329  C1 2A               Loc_0329:      CMPB #$2A              ; compare B with '*'
$032B  27 12                              BEQ Loc_033F          
$032D  81 0D                              CMPA #$0D              ; compare A with CR
$032F  27 2B                              BEQ Loc_035C          
$0331  C1 3F                              CMPB #$3F              ; compare B with '?'
$0333  27 04                              BEQ Loc_0339          
$0335  D1 15                              CMPB <$15             
$0337  26 23                              BNE Loc_035C          
$0339  30 01               Loc_0339:      LEAX 1,X              
$033B  31 21                              LEAY 1,Y              
$033D  20 D8                              BRA Sub_0317          

; --------------------------------------------------------------
$033F  31 21               Loc_033F:      LEAY 1,Y              
$0341  E6 A4                              LDB ,Y                
$0343  C1 0D                              CMPB #$0D              ; compare B with CR
$0345  27 10                              BEQ Loc_0357          
$0347  D1 15               Loc_0347:      CMPB <$15             
$0349  27 EE                              BEQ Loc_0339          
$034B  30 01                              LEAX 1,X              
$034D  A6 84                              LDA ,X                
$034F  81 0D                              CMPA #$0D              ; compare A with CR
$0351  27 09                              BEQ Loc_035C          
$0353  97 15                              STA <$15              
$0355  20 F0                              BRA Loc_0347          

; --------------------------------------------------------------
$0357  86 01               Loc_0357:      LDA #$01              
$0359  97 09                              STA <$09              
$035B  39                  Insn_035B:     RTS                    ; return from subroutine
$035C  0F                  Loc_035C:      EQU    $035C            ; [*12] branch target 1 byte(s) inside Insn_035B -- see [*12]
$035D  09                                 FCB    $09                ; undefined opcode $09 -- not a valid 6809 instruction
$035E  39                  Insn_035E:     RTS                    ; return from subroutine
$035F  0D                  Sub_035F:      EQU    $035F            ; [*13] branch target 1 byte(s) inside Insn_035E -- see [*13]
$0360  08                                 FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
$0361  26 0A                              BNE Loc_036D          
$0363  81 61                              CMPA #$61              ; compare A with 'a'
$0365  25 06                              BCS Loc_036D           ; C=1 (BLO)
$0367  81 7A                              CMPA #$7A              ; compare A with 'z'
$0369  22 02                              BHI Loc_036D          
$036B  84 DF                              ANDA #$DF             
$036D  39                  Loc_036D:      RTS                    ; return from subroutine

$036E  30 8D 01 87                                LEAX +391,PC
$0372  31 C8 25                                   LEAY 37,U
$0375  A6 80                                      LDA ,X+
$0377  81 0A                                      CMPA #$0A   ; compare A with LF
$0379  27 04                                      BEQ $037F
$037B  A7 A0                                      STA ,Y+
$037D  20 F6                                      BRA $0375
$037F  31 C8 26                                   LEAY 38,U
$0382  30 C8 19                                   LEAX 25,U
$0385  C6 02                                      LDB #$02   ; B = SS.Size  (GetStt/SetStt subcode)
$0387  A6 80                                      LDA ,X+
$0389  17 00 9F                                   LBSR $042B
$038C  5A                                         DECB 
$038D  26 F8                                      BNE $0387
$038F  30 C8 26                                   LEAX 38,U
$0392  17 00 AD                                   LBSR $0442
$0395  31 C8 2C                                   LEAY 44,U
$0398  30 C8 1B                                   LEAX 27,U
$039B  E6 84                                      LDB ,X
$039D  4F                                         CLRA    ; A = 0
$039E  C1 64                                      CMPB #$64   ; compare B with 'd'
$03A0  25 05                                      BCS $03A7   ; C=1 (BLO)
$03A2  4C                                         INCA 
$03A3  C0 64                                      SUBB #$64
$03A5  20 F7                                      BRA $039E
$03A7  1F 89                                      TFR A,B
$03A9  8B 13                                      ADDA #$13
$03AB  8D 6D                                      BSR $041A
$03AD  86 64                                      LDA #$64   ; A = 'd'
$03AF  3D                                         MUL    ; D = A×B unsigned
$03B0  34 04                                      PSHS B
$03B2  A6 80                                      LDA ,X+
$03B4  A0 E0                                      SUBA ,S+
$03B6  8D 62                                      BSR $041A
$03B8  31 21                                      LEAY 1,Y
$03BA  C6 02                                      LDB #$02   ; B = SS.Size  (GetStt/SetStt subcode)
$03BC  A6 80                                      LDA ,X+
$03BE  8D 5A                                      BSR $041A
$03C0  31 21                                      LEAY 1,Y
$03C2  5A                                         DECB 
$03C3  26 F7                                      BNE $03BC
$03C5  A6 80                                      LDA ,X+
$03C7  8D 51                                      BSR $041A
$03C9  A6 84                                      LDA ,X
$03CB  8D 4D                                      BSR $041A
$03CD  31 C8 3D                                   LEAY 61,U
$03D0  30 C8 18                                   LEAX 24,U
$03D3  CC 2D 08                                   LDD #$2D08
$03D6  68 84                                      LSL ,X
$03D8  25 02                                      BCS $03DC   ; C=1 (BLO)
$03DA  A7 A4                                      STA ,Y
$03DC  31 21                                      LEAY 1,Y
$03DE  5A                                         DECB 
$03DF  26 F5                                      BNE $03D6
$03E1  31 C8 47                                   LEAY 71,U
$03E4  30 C8 76                                   LEAX 118,U
$03E7  C6 03                                      LDB #$03   ; B = SS.Reset  (GetStt/SetStt subcode)
$03E9  A6 80                                      LDA ,X+
$03EB  8D 3E                                      BSR $042B
$03ED  5A                                         DECB 
$03EE  26 F9                                      BNE $03E9
$03F0  30 C8 47                                   LEAX 71,U
$03F3  8D 4D                                      BSR $0442
$03F5  31 C8 4F                                   LEAY 79,U
$03F8  30 C8 21                                   LEAX 33,U
$03FB  C6 04                                      LDB #$04
$03FD  A6 80                                      LDA ,X+
$03FF  8D 2A                                      BSR $042B
$0401  5A                                         DECB 
$0402  26 F9                                      BNE $03FD
$0404  30 C8 4F                                   LEAX 79,U
$0407  8D 39                                      BSR $0442
$0409  30 C8 25                                   LEAX 37,U
$040C  10 8E 00 50                                LDY #$0050
$0410  86 01                                      LDA #$01
$0412  10 3F 8C                                   OS9 I$WritLn   ; path=A  buf→X
$0415  25 3A                                      BCS Loc_0451   ; C=1 (BLO)
$0417  16 FD 0C                                   LBRA Loc_0126
$041A  81 0A                                      CMPA #$0A   ; compare A with LF
$041C  25 06                                      BCS $0424   ; C=1 (BLO)
$041E  6C A4                                      INC ,Y
$0420  80 0A                                      SUBA #$0A
$0422  20 F6                                      BRA $041A
$0424  31 21                                      LEAY 1,Y
$0426  8B 30                                      ADDA #$30
$0428  A7 A0                                      STA ,Y+
$042A  39                                         RTS    ; return from subroutine
$042B  34 02                                      PSHS A
$042D  44                                         LSRA 
$042E  44                                         LSRA 
$042F  44                                         LSRA 
$0430  44                                         LSRA 
$0431  8D 04                                      BSR $0437
$0433  35 02                                      PULS A
$0435  84 0F                                      ANDA #$0F
$0437  8B 30                                      ADDA #$30
$0439  81 39                                      CMPA #$39   ; compare A with '9'
$043B  23 02                                      BLS $043F
$043D  8B 07                                      ADDA #$07
$043F  A7 A0                                      STA ,Y+
$0441  39                                         RTS    ; return from subroutine
$0442  CC 30 20                                   LDD #$3020
$0445  A1 84                                      CMPA ,X
$0447  26 F8                                      BNE $0441
$0449  E1 01                                      CMPB 1,X
$044B  27 F4                                      BEQ $0441
$044D  E7 80                                      STB ,X+
$044F  20 F4                                      BRA $0445
$0451  C1 D3               Loc_0451:      CMPB #$D3             
$0453  26 01                              BNE Loc_0456          
$0455  5F                  Insn_0455:     CLRB                   ; B = 0
$0456  0D                  Loc_0456:      EQU    $0456            ; [*14] branch target 1 byte(s) inside Insn_0455 -- see [*14]
$0457  10 27 0D 30                        LBEQ $118B            
$045B  8D 00               Insn_045B:     BSR Sub_045D           ; call Sub_045D
$045D  0D                  Sub_045D:      EQU    $045D            ; [*15] branch target 2 byte(s) inside Insn_045B -- see [*15]
$045E  86 01                              LDA #$01              
$0460  10 8E 00 01                        LDY #$0001            
$0464  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$0467  10 3F 06                           OS9 F$Exit             ; status=B

Dat_046A
; Referenced by: $0022, $02CE
; ── 1 bytes  ($046A—$046A) ──
         FCB    $2E               ; '.'

Dat_046B
; Referenced by: $01E5, $045A
; ── 1 bytes  ($046B—$046B) ──
         FCB    $0D               ; CR

Dat_046C
; Referenced by: $00BC
; ── 1 bytes  ($046C—$046C) ──
         FCB    $40               ; '@'
$046D  0D                  Insn_046D:     EQU    $046D            ; [*16] branch target 1 byte(s) inside Dat_046C -- see [*16]

Dat_046E
; Referenced by: $00D3
; ── 11 bytes  ($046E—$0478) ──
         FCB    $0A               ; LF
         FCC    " Directory"
$0479  20 6F               Loc_0479:      BRA Loc_04EA          

$047B  66 20                                      ROR 0,Y

Dat_047D
; Referenced by: $011B
; ── 56 bytes  ($047D—$04B4) ──
         FCB    $0A               ; LF
         FCC    "User # Last Modified   Attributes Sector File Size File"
$04B5  20 4E               Loc_04B5:      BRA Loc_0505          

$04B7  61                                         ??? 
$04B8  6D 65                                      TST 5,S
$04BA  0D                                         ??? 
$04BB  2D 2D                                      BLT Loc_04EA
$04BD  2D 2D                                      BLT $04EC
$04BF  2D 2D                                      BLT $04EE
$04C1  20 2D                                      BRA $04F0
$04C3  2D 2D                                      BLT $04F2
$04C5  2D 2D                                      BLT $04F4
$04C7  2D 2D                                      BLT $04F6
$04C9  2D 2D                                      BLT $04F8
$04CB  2D 2D                                      BLT $04FA
$04CD  2D 2D                                      BLT $04FC
$04CF  2D 2D                                      BLT $04FE
$04D1  20 2D                                      BRA $0500
$04D3  2D 2D                                      BLT $0502
$04D5  2D 2D                                      BLT $0504
$04D7  2D 2D                                      BLT $0506
$04D9  2D 2D                                      BLT $0508
$04DB  2D 20                                      BLT $04FD
$04DD  2D 2D                                      BLT $050C
$04DF  2D 2D                                      BLT Loc_050E
$04E1  2D 2D                                      BLT $0510
$04E3  20 2D                                      BRA $0512
$04E5  2D 2D                                      BLT $0514
$04E7  2D 2D                                      BLT $0516
$04E9  2D 2D                                      BLT $0518
$04EA  2D 2D               Loc_04EA:      BLT Loc_0519          
$04EC  2D 20                              BLT Loc_050E          
$04EE  2D 2D                              BLT Loc_051D          
$04F0  2D 2D                              BLT Loc_051F          
$04F2  2D 2D                              BLT Loc_0521          
$04F4  2D 2D                              BLT Loc_0523          
$04F6  2D 2D                              BLT Loc_0525          
$04F8  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$04F9  20 20                              BRA Loc_051B          

$04FB  20 20                                      BRA Loc_051D
$04FD  20 20                                      BRA Loc_051F
$04FF  20 30                                      BRA Loc_0531
$0501  30 30                                      LEAX -16,Y
$0503  30 2F                                      LEAX 15,Y
$0505  30 30               Loc_0505:      LEAX -16,Y            
$0507  2F 30                              BLE Loc_0539          
$0509  30 20                              LEAX 0,Y              
$050B  30 30                              LEAX -16,Y            
$050D  30 30                              LEAX -16,Y            
$050E  30 20               Loc_050E:      LEAX 0,Y              
$0510  20 64                              BRA Loc_0576          

$0512  73 65 77                                   COM $6577
$0515  72                                         ??? 
$0516  65                                         ??? 
$0517  77 72 20                                   ASR $7220
$0519  20 20               Loc_0519:      BRA Loc_053B          
$051B  20 20               Loc_051B:      BRA Loc_053D          
$051D  20 20               Loc_051D:      BRA Loc_053F          
$051F  20 20               Loc_051F:      BRA Loc_0541          
$0521  20 20               Loc_0521:      BRA Loc_0543          
$0523  20 20               Loc_0523:      BRA Loc_0545          
$0525  20 20               Loc_0525:      BRA Loc_0547          

$0527  20 20                                      BRA $0549
$0529  20 20                                      BRA $054B
$052B  20 0A                                      BRA $0537

Dat_052C
; Referenced by: $024C
; ── 5 bytes  ($052C—$0530) ──
         FCB    $0A               ; LF
         FCC    "dir "
$0531  5B                  Loc_0531:      EQU    $0531            ; [*17] undefined opcode at $0531 — see [*17]
$0532  2D 6F                              BLT Loc_05A3          
$0534  70 74 73                           NEG $7473             
$0537  5D                                 TSTB                  
$0538  20 5B               Insn_0538:     BRA Loc_0595          
$0539  5B                  Loc_0539:      EQU    $0539            ; [*18] branch target 1 byte(s) inside Insn_0538 -- see [*18]
$053A  70 61 74            Insn_053A:     NEG $6174             
$053B  61                  Loc_053B:      EQU    $053B            ; [*19] branch target 1 byte(s) inside Insn_053A -- see [*19]
$053C  74 68 2F                           LSR $682F             
$053D  68 2F               Loc_053D:      LSL 15,Y              
$053F  70 61 74            Loc_053F:      NEG $6174             
$0541  74 74 5D            Loc_0541:      LSR $745D             
$0542  74 5D 20            Insn_0542:     LSR $5D20             
$0543  5D                  Loc_0543:      TSTB                  
$0544  20 5B                              BRA Loc_05A1          

; --------------------------------------------------------------
$0545  5B                  Loc_0545:      EQU    $0545            ; [*20] branch target 1 byte(s) inside Insn_0544 -- see [*20]
$0546  2D 6F                              BLT Loc_05B7          
$0547  6F 70               Loc_0547:      CLR -16,S             
$0549  74 73 5D                           LSR $735D             
$054C  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$054D  6F 70                              CLR -16,S             
$054F  74 73 3A                           LSR $733A             
$0552  20 78                              BRA Loc_05CC          

$0554  20 2D                                      BRA $0583
$0556  20 75                                      BRA $05CD
$0558  73 65 20                                   COM $6520
$055B  63 75                                      COM -11,S
$055D  72                                         ??? 
$055E  72                                         ??? 
$055F  65                                         ??? 
$0560  6E 74                                      JMP -12,S
$0562  20 65                                      BRA $05C9
$0564  78 65 63                                   LSL $6563
$0567  20 64                                      BRA $05CD
$0569  69 72                                      ROL -14,S
$056B  0D                                         ??? 
$056C  20 20                                      BRA $058E
$056E  20 20                                      BRA $0590
$0570  20 20                                      BRA $0592
$0572  73 20 2D                                   COM $202D
$0575  20 6F                                      BRA $05E6
$0576  6F 6E               Loc_0576:      CLR 14,S              
$0578  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$0579  20 65                              BRA Loc_05E0          

$057B  6E 74                                      JMP -12,S
$057D  72                                         ??? 
$057E  79 2F 6C                                   ROL $2F6C
$0581  69 6E                                      ROL 14,S
$0583  65                                         ??? 
$0584  0D                                         ??? 
$0585  20 20                                      BRA $05A7
$0587  20 20                                      BRA $05A9
$0589  65                                         ??? 
$058A  2F 6C                                      BLE $05F8
$058C  20 2D                                      BRA $05BB
$058E  20 65                                      BRA $05F5
$0590  78 74 65                                   LSL $7465
$0593  6E 64                                      JMP 4,S
$0595  65                  Loc_0595:      EQU    $0595            ; [*21] undefined opcode at $0595 — see [*21]
$0596  64 20                              LSR 0,Y               
$0598  64 69                              LSR 9,S               
$059A  72                                 FCB    $72                ; undefined opcode $72 -- not a valid 6809 instruction
$059B  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$059C  63 74                              COM -12,S             
$059E  6F 72                              CLR -14,S             
$05A0  79 0D 20            Insn_05A0:     ROL $0D20             
$05A1  0D                  Loc_05A1:      EQU    $05A1            ; [*22] branch target 1 byte(s) inside Insn_05A0 -- see [*22]
$05A2  20 20                              BRA Loc_05C4          

; --------------------------------------------------------------
$05A3  20 20               Loc_05A3:      BRA Loc_05C5          

$05A5  20 20                                      BRA $05C7
$05A7  20 61                                      BRA $060A
$05A9  20 2D                                      BRA $05D8
$05AB  20 73                                      BRA $0620
$05AD  68 6F                                      LSL 15,S
$05AF  77 20 27                                   ASR $2027
$05B2  2E 66                                      BGT $061A
$05B4  69 6C                                      ROL 12,S
$05B6  65                                         ??? 
$05B7  73 27 2C            Loc_05B7:      COM $272C             
$05BA  20 74                              BRA Loc_0630          

$05BC  6F 6F                                      CLR 15,S
$05BE  0D                                         ??? 
$05BF  20 20                                      BRA $05E1
$05C1  20 20                                      BRA $05E3
$05C3  20 20                                      BRA $05E5
$05C4  20 64               Loc_05C4:      BRA Loc_062A          
$05C5  64 20               Loc_05C5:      LSR 0,Y               
$05C7  2D 20                              BLT Loc_05E9          
$05C9  6F 6E                              CLR 14,S              
$05CB  6C 79                              INC -7,S              
$05CC  79 20 64            Loc_05CC:      ROL $2064             
$05CF  69 72                              ROL -14,S             
$05D1  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$05D2  63 74                              COM -12,S             
$05D4  6F 72                              CLR -14,S             
$05D6  79 20 66                           ROL $2066             
$05D9  69 6C                              ROL 12,S              
$05DB  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$05DC  73 0D 20                           COM $0D20             
$05DF  20 20                              BRA Loc_0601          

; --------------------------------------------------------------
$05E0  20 20               Loc_05E0:      BRA Loc_0602          

$05E2  20 20                                      BRA $0604
$05E4  66 20                                      ROR 0,Y
$05E6  2D 20                                      BLT $0608
$05E8  6F 6E                                      CLR 14,S
$05E9  6E 6C               Loc_05E9:      JMP 12,S              
$05EB  79 20 6E                           ROL $206E             
$05EE  6F 6E                              CLR 14,S              
$05F0  2D 64                              BLT $0656             
$05F2  69 72                              ROL -14,S             
$05F4  20 66                              BRA $065C             

$05F6  69 6C                                      ROL 12,S
$05F8  65                                         ??? 
$05F9  73 0D 20                                   COM $0D20
$05FC  20 20                                      BRA $061E
$05FE  20 20                                      BRA $0620
$0600  20 63                                      BRA $0665
$0601  63 20               Loc_0601:      COM 0,Y               
$0602  20 2D               Loc_0602:      BRA Loc_0631          

$0604  20 63                                      BRA Loc_0669
$0606  61                                         ??? 
$0607  73 65 20                                   COM $6520
$060A  69 6E                                      ROL 14,S
$060C  73 65 6E                                   COM $656E
$060F  73 69 74                                   COM $6974
$0612  69 76                                      ROL -10,S
$0614  65                                         ??? 
$0615  20 66                                      BRA Loc_067D
$0617  69 6C                                      ROL 12,S
$0619  65                                         ??? 
$061A  6E 61                                      JMP 1,S
$061C  6D 65                                      TST 5,S
$061E  20 6D                                      BRA $068D
$0620  61                                         ??? 
$0621  74 63 68                                   LSR $6368
$0624  20 28                                      BRA $064E
$0625  28 42               Loc_0625:      BVC Loc_0669          
$0627  55                                 FCB    $55                ; undefined opcode $55 -- not a valid 6809 instruction
$0628  54                                 LSRB                  
$0629  20 4E               Insn_0629:     BRA Loc_0679          
$062A  4E                  Loc_062A:      EQU    $062A            ; [*23] branch target 1 byte(s) inside Insn_0629 -- see [*23]
$062B  4F                                 CLRA                   ; A = 0
$062C  54                                 LSRB                  
$062D  20 44                              BRA Loc_0673          

$062F  49                                         ROLA 
$0630  52                  Loc_0630:      EQU    $0630            ; [*24] undefined opcode at $0630 — see [*24]
$0631  20 4E               Loc_0631:      BRA Loc_0681          
$0633  41                  Loc_0633:      EQU    $0633            ; [*25] branch target 2 byte(s) inside Loc_0631 -- see [*25]
$0634  4D                                 TSTA                  
$0635  45                                 FCB    $45                ; undefined opcode $45 -- not a valid 6809 instruction
$0636  29 0D                              BVS Loc_0645          
$0638  20 20                              BRA Loc_065A          

$063A  20 20                                      BRA $065C
$063C  20 20                                      BRA $065E
$063E  3F                                         SWI 
$063F  20 2D                                      BRA $066E
$0641  20 68                                      BRA $06AB
$0643  65                                         ??? 
$0644  6C 70                                      INC -16,S
$0645  70 20 6D            Loc_0645:      NEG $206D             
$0648  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$0649  73 73 61                           COM $7361             
$064C  67 65                              ASR 5,S               
$064E  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$064F  70 61 74                           NEG $6174             
$0652  74 65 72                           LSR $6572             
$0655  6E 3A                              JMP -6,Y              
$0657  20 6D                              BRA $06C6             

$0659  61                                         ??? 
$065A  79 20 69            Loc_065A:      ROL $2069             
$065D  6E 63                              JMP 3,S               
$065F  6C 75                              INC -11,S             
$0661  64 65                              LSR 5,S               
$0663  20 77                              BRA $06DC             

$0665  69 6C                                      ROL 12,S
$0667  64 20                                      LSR 0,Y
$0669  63 61               Loc_0669:      COM 1,S               
$066B  72                                 FCB    $72                ; undefined opcode $72 -- not a valid 6809 instruction
$066C  64 73                              LSR -13,S             
$066E  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$066F  20 20                              BRA Loc_0691          

$0671  20 20                                      BRA $0693
$0673  20 20               Loc_0673:      BRA Loc_0695          

$0675  2A 20                                      BPL $0697
$0677  2D 20                                      BLT $0699
$0679  6D 75               Loc_0679:      TST -11,S             
$067B  6C 74                              INC -12,S             
$067D  69 70               Loc_067D:      ROL -16,S             
$067F  6C 65                              INC 5,S               
$0681  20 63               Loc_0681:      BRA $06E6             

$0683  68 61                                      LSL 1,S
$0685  72                                         ??? 
$0686  61                                         ??? 
$0687  63 74                                      COM -12,S
$0689  65                                         ??? 
$068A  72                                         ??? 
$068B  0D                                         ??? 
$068C  20 20                                      BRA $06AE
$068E  20 20                                      BRA $06B0
$0690  20 20                                      BRA $06B2
$0691  20 3F               Loc_0691:      BRA $06D2             

$0693  20 2D                                      BRA $06C2
$0695  20 73               Loc_0695:      BRA $070A             

$0697  69 6E                                      ROL 14,S
$0699  67 6C                                      ASR 12,S
$069B  65                                         ??? 
$069C  20 63                                      BRA $0701
$069E  68 61                                      LSL 1,S
$06A0  72                                         ??? 
$06A1  61                                         ??? 
$06A2  63 74                                      COM -12,S
$06A4  65                                         ??? 
$06A5  72                                         ??? 
$06A6  0D                                         ??? 
$06A7  5A                  Sub_06A7:      DECB                  
$06A8  10 8E 00 50                        LDY #$0050            
$06AC  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$06AF  25 0B                              BCS Loc_06BC           ; C=1 (BLO)
$06B1  34 06                              PSHS A,B              
$06B3  1F 20                              TFR Y,D               
$06B5  30 8B                              LEAX D,X              
$06B7  35 06                              PULS A,B              
$06B9  5D                                 TSTB                  
$06BA  26 EB                              BNE Sub_06A7          
$06BC  39                  Loc_06BC:      RTS                    ; return from subroutine

; ==============================================================
; ModEnd — CRC-24 appended by fixmod (not in source)
; ==============================================================
ModEnd
; CRC-24 (3 bytes) appended here by fixmod
         FCB    $00,$00,$00        ; CRC placeholder — overwritten by fixmod
ModCRC
ModSize  EQU    ModCRC-ModHeader   ; module size including 3 CRC bytes

; ══════════════════════════════════════════════════════════════
; ANALYST NOTES
; ══════════════════════════════════════════════════════════════

; [*1] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0172 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0170).
;      Byte $0D at $0172 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0172 EQU Insn_0170+2' resolves
;      to $0172 at assembly time. Branches to Loc_0172
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*2] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $019D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_019B).
;      Byte $0D at $019D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_019D EQU Insn_019B+2' resolves
;      to $019D at assembly time. Branches to Loc_019D
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*3] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $01A4 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_01A2).
;      Byte $0D at $01A4 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_01A4 EQU Insn_01A2+2' resolves
;      to $01A4 at assembly time. Branches to Loc_01A4
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*4] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $01B0 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_01AE).
;      Byte $0C at $01B0 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_01B0 EQU Insn_01AE+2' resolves
;      to $01B0 at assembly time. Branches to Loc_01B0
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*5] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0245 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Loc_0244).
;      Byte $0C at $0245 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0245 EQU Loc_0244+1' resolves
;      to $0245 at assembly time. Branches to Loc_0245
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*6] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $025A is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0258).
;      Byte $0F at $025A is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_025A EQU Insn_0258+2' resolves
;      to $025A at assembly time. Branches to Loc_025A
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*7] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $025E is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_025B).
;      Byte $0C at $025E is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_025E EQU Insn_025B+3' resolves
;      to $025E at assembly time. Branches to Loc_025E
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*8] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0264 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0261).
;      Byte $0C at $0264 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0264 EQU Insn_0261+3' resolves
;      to $0264 at assembly time. Branches to Loc_0264
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*9] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $026A is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0268).
;      Byte $0C at $026A is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_026A EQU Insn_0268+2' resolves
;      to $026A at assembly time. Branches to Loc_026A
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*10] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0270 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_026E).
;      Byte $0F at $0270 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0270 EQU Insn_026E+2' resolves
;      to $0270 at assembly time. Branches to Loc_0270
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*11] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $02E0 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_02DE).
;      Byte $0C at $02E0 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_02E0 EQU Insn_02DE+2' resolves
;      to $02E0 at assembly time. Branches to Loc_02E0
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*12] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $035C is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_035B).
;      Byte $0F at $035C is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_035C EQU Insn_035B+1' resolves
;      to $035C at assembly time. Branches to Loc_035C
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*13] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $035F is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_035E).
;      Byte $0D at $035F is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_035F EQU Insn_035E+1' resolves
;      to $035F at assembly time. Branches to Sub_035F
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*14] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0456 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0455).
;      Byte $0D at $0456 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0456 EQU Insn_0455+1' resolves
;      to $0456 at assembly time. Branches to Loc_0456
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*15] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $045D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_045B).
;      Byte $0D at $045D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_045D EQU Insn_045B+2' resolves
;      to $045D at assembly time. Branches to Sub_045D
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*16] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $046D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Dat_046C).
;      Byte $0D at $046D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Insn_046D EQU Dat_046C+1' resolves
;      to $046D at assembly time. Branches to Insn_046D
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*17] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0531 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $5B at $0531 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $5B is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $5B may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*18] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0539 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0538).
;      Byte $5B at $0539 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $5B is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $5B may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0539 EQU Insn_0538+1' resolves
;      to $0539 at assembly time. Branches to Loc_0539
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*19] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $053B is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_053A).
;      Byte $61 at $053B is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $61 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $61 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_053B EQU Insn_053A+1' resolves
;      to $053B at assembly time. Branches to Loc_053B
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*20] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0545 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0544).
;      Byte $5B at $0545 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $5B is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $5B may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0545 EQU Insn_0544+1' resolves
;      to $0545 at assembly time. Branches to Loc_0545
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*21] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0595 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $65 at $0595 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $65 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $65 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*22] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $05A1 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_05A0).
;      Byte $0D at $05A1 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_05A1 EQU Insn_05A0+1' resolves
;      to $05A1 at assembly time. Branches to Loc_05A1
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*23] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $062A is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0629).
;      Byte $4E at $062A is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $4E is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $4E may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_062A EQU Insn_0629+1' resolves
;      to $062A at assembly time. Branches to Loc_062A
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*24] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0630 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $52 at $0630 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $52 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $52 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*25] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0633 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Loc_0631).
;      Byte $41 at $0633 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $41 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $41 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Loc_0633 EQU Loc_0631+2' resolves
;      to $0633 at assembly time. Branches to Loc_0633
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; ══════════════════════════════════════════════════════════════