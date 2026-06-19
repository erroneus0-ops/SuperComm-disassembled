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
; Disassembly:  mdir
; Module:       MDir
; Type:         program  ($11)
; Size:         $02ED  (749 bytes)
; Entry:        $00CE
; BSS:          $11AF  (4527 bytes)
; CRC-24:       $ACECB6
; ==============================================================

; ----- Module Header -----
ModHeader
         FDB    $87CD             ; OS-9 module sync bytes
         FDB    ModCRC-ModHeader   ; module size (content + 3 CRC bytes)
         FDB    ModName           ; name offset
         FCB    $11               ; type: program
         FCB    $81               ; language
         FCB    $C7               ; attributes/parity
         FDB    Init              ; execution entry
         FDB    $11AF             ; BSS size

; ----- Module Name -----
ModName
         FCS    "MDir"

; ==============================================================
; Pre-exec data  (post-name)—$00CD
; Everything here is DATA — no executable code.
; ==============================================================

         FCB    $09               ; HT

Dat_0012
; Referenced by: $0105
         FCS    "   Module Directory at "

Dat_0029
; Referenced by: $013A
         FCS    "Block Offset Size Typ Rev Attr  Use Module Name"

Dat_0058
; Referenced by: $014C
         FCS    "----- ------ ---- --- --- ---- ---- ------------"

Dat_0088
; Referenced by: $0142
         FCS    "Blk Ofst Size Ty Rv At Uc  Name"

Dat_00A7
; Referenced by: $0154
         FCS    "___ ____ ____ __ __ __ __ ______"

Dat_00C7
; Referenced by: $01FF
         FCS    "Lock "

Dat_00CC
; Referenced by: $0207
         FCB    $4C               ; 'L'
         FCB    $EB

; ==============================================================
; Code section  $00CE—$02E9  (540 bytes)
; ==============================================================

$00CE  34 40               Init:          PSHS U                
$00D0  33 C9 10 62                        LEAU 4194,U           
$00D4  6F C2               Loc_00D4:      CLR ,-U               
$00D6  11 A3 E4                           CMPU ,S               
$00D9  22 F9                              BHI Loc_00D4          
$00DB  35 40                              PULS U                
$00DD  0F 02                              CLR <$02              
$00DF  0F 0B                              CLR <$0B              
$00E1  9F 00                              STX <$00              
$00E3  30 4E                              LEAX 14,U             
$00E5  9F 03                              STX <$03              
$00E7  17 01 92                           LBSR Sub_027C          ; call Sub_027C
$00EA  CC 01 26                           LDD #$0126            
$00ED  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$00F0  24 00                              BCC Loc_00F2           ; C=0 (BHS)
$00F2  1F 10               Loc_00F2:      TFR X,D               
$00F4  C1 28                              CMPB #$28              ; compare B with '('
$00F6  2E 05                              BGT Loc_00FD          
$00F8  0C 0B                              INC <$0B              
$00FA  86 0A                              LDA #$0A               ; A = LF
$00FC  8C 86 0C                           CMPX #$860C           
$00FD  86 0C               Loc_00FD:      LDA #$0C               ; A = FF
$00FF  34 02                              PSHS A                
$0101  E0 E0                              SUBB ,S+              
$0103  DD 0C                              STD <$0C              
$0105  31 8D FF 09                        LEAY Dat_0012,PC       ; Y → Dat_0012
$0109  17 01 68                           LBSR Sub_0274          ; call Sub_0274
$010C  30 45                              LEAX 5,U              
$010E  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$0111  30 48                              LEAX 8,U              
$0113  17 01 7B                           LBSR Sub_0291          ; call Sub_0291
$0116  17 01 63                           LBSR Sub_027C          ; call Sub_027C
$0119  30 C8 62                           LEAX 98,U             
$011C  34 40                              PSHS U                
$011E  10 3F 1A                           OS9 F$GModDr           ; buf→X
$0121  10 9F 5E                           STY <$5E              
$0124  DF 60                              STU <$60              
$0126  35 40                              PULS U                
$0128  30 18                              LEAX -8,X             
$012A  10 9E 00                           LDY <$00              
$012D  EC A0                              LDD ,Y+               
$012F  C4 DF                              ANDB #$DF             
$0131  10 83 2D 45                        CMPD #$2D45           
$0135  26 4E                              BNE Loc_0185          
$0137  17 01 42                           LBSR Sub_027C          ; call Sub_027C
$013A  31 8D FE EB                        LEAY Dat_0029,PC       ; Y → Dat_0029
$013E  0D 0B                              TST <$0B              
$0140  27 04                              BEQ Loc_0146          
$0142  31 8D FF 42                        LEAY Dat_0088,PC       ; Y → Dat_0088
$0146  17 01 2B            Loc_0146:      LBSR Sub_0274          ; call Sub_0274
$0149  17 01 30                           LBSR Sub_027C          ; call Sub_027C
$014C  31 8D FF 08                        LEAY Dat_0058,PC       ; Y → Dat_0058
$0150  0D 0B                              TST <$0B              
$0152  27 04                              BEQ Loc_0158          
$0154  31 8D FF 4F                        LEAY Dat_00A7,PC       ; Y → Dat_00A7
$0158  17 01 19            Loc_0158:      LBSR Sub_0274          ; call Sub_0274
$015B  17 01 1E                           LBSR Sub_027C          ; call Sub_027C
$015E  30 C8 62                           LEAX 98,U             
$0161  16 00 C1                           LBRA Loc_0225         

; --------------------------------------------------------------
$0164  17 01 71            Loc_0164:      LBSR Sub_02D8          ; call Sub_02D8
$0167  27 1C                              BEQ Loc_0185          
$0169  17 01 42                           LBSR Sub_02AE          ; call Sub_02AE
$016C  17 01 05                           LBSR Sub_0274          ; call Sub_0274
$016F  17 00 F4            Loc_016F:      LBSR Sub_0266          ; call Sub_0266
$0172  D6 04                              LDB <$04              
$0174  C0 0E                              SUBB #$0E             
$0176  D1 0D                              CMPB <$0D             
$0178  22 08                              BHI Loc_0182          
$017A  D0 0C               Loc_017A:      SUBB <$0C             
$017C  22 FC                              BHI Loc_017A          
$017E  26 EF                              BNE Loc_016F          
$0180  20 03                              BRA Loc_0185          

; --------------------------------------------------------------
$0182  17 00 F7            Loc_0182:      LBSR Sub_027C          ; call Sub_027C
$0185  30 08               Loc_0185:      LEAX 8,X              
$0187  9C 5E                              CMPX <$5E             
$0189  25 D9                              BCS Loc_0164           ; C=1 (BLO)
$018B  17 00 EE                           LBSR Sub_027C          ; call Sub_027C
$018E  16 00 9A                           LBRA Loc_022B         

; --------------------------------------------------------------
$0191  17 01 44            Loc_0191:      LBSR Sub_02D8          ; call Sub_02D8
$0194  10 27 00 8B                        LBEQ Loc_0223         
$0198  1F 02                              TFR D,Y               
$019A  EC A4                              LDD ,Y                
$019C  0D 0B                              TST <$0B              
$019E  27 08                              BEQ Loc_01A8          
$01A0  17 00 C3                           LBSR Sub_0266          ; call Sub_0266
$01A3  17 00 91                           LBSR Sub_0237          ; call Sub_0237
$01A6  20 09                              BRA Loc_01B1          

; --------------------------------------------------------------
$01A8  17 00 84            Loc_01A8:      LBSR Sub_022F          ; call Sub_022F
$01AB  17 00 B8                           LBSR Sub_0266          ; call Sub_0266
$01AE  17 00 B5                           LBSR Sub_0266          ; call Sub_0266
$01B1  EC 04               Loc_01B1:      LDD 4,X               
$01B3  8D 7A                              BSR Sub_022F           ; call Sub_022F
$01B5  0D 0B                              TST <$0B              
$01B7  26 03                              BNE Loc_01BC          
$01B9  17 00 AA                           LBSR Sub_0266          ; call Sub_0266
$01BC  17 00 EF            Loc_01BC:      LBSR Sub_02AE          ; call Sub_02AE
$01BF  31 C9 10 A2                        LEAY 4258,U           
$01C3  EC 22                              LDD 2,Y               
$01C5  8D 68                              BSR Sub_022F           ; call Sub_022F
$01C7  0D 0B                              TST <$0B              
$01C9  26 03                              BNE Loc_01CE          
$01CB  17 00 98                           LBSR Sub_0266          ; call Sub_0266
$01CE  A6 26               Loc_01CE:      LDA 6,Y               
$01D0  8D 67                              BSR Sub_0239           ; call Sub_0239
$01D2  0D 0B                              TST <$0B              
$01D4  26 03                              BNE Loc_01D9          
$01D6  17 00 8D                           LBSR Sub_0266          ; call Sub_0266
$01D9  A6 27               Loc_01D9:      LDA 7,Y               
$01DB  84 0F                              ANDA #$0F             
$01DD  8D 5A                              BSR Sub_0239           ; call Sub_0239
$01DF  E6 27                              LDB 7,Y               
$01E1  86 72                              LDA #$72               ; A = 'r'
$01E3  8D 78                              BSR Sub_025D           ; call Sub_025D
$01E5  0D 0B                              TST <$0B              
$01E7  26 0C                              BNE Loc_01F5          
$01E9  86 77                              LDA #$77               ; A = 'w'
$01EB  8D 70                              BSR Sub_025D           ; call Sub_025D
$01ED  86 33                              LDA #$33               ; A = '3'
$01EF  8D 6C                              BSR Sub_025D           ; call Sub_025D
$01F1  86 3F                              LDA #$3F               ; A = '?'
$01F3  8D 68                              BSR Sub_025D           ; call Sub_025D
$01F5  8D 6F               Loc_01F5:      BSR Sub_0266           ; call Sub_0266
$01F7  EC 06                              LDD 6,X               
$01F9  10 83 FF FF                        CMPD #$FFFF           
$01FD  26 10                              BNE Loc_020F          
$01FF  31 8D FE C4                        LEAY Dat_00C7,PC       ; Y → Dat_00C7
$0203  0D 0B                              TST <$0B              
$0205  26 04                              BNE Loc_020B          
$0207  31 8D FE C1                        LEAY Dat_00CC,PC       ; Y → Dat_00CC
$020B  8D 67               Loc_020B:      BSR Sub_0274           ; call Sub_0274
$020D  20 0C                              BRA Loc_021B          

; --------------------------------------------------------------
$020F  0D 0B               Loc_020F:      TST <$0B              
$0211  27 06                              BEQ Loc_0219          
$0213  8D 51                              BSR Sub_0266           ; call Sub_0266
$0215  8D 20                              BSR Sub_0237           ; call Sub_0237
$0217  20 02                              BRA Loc_021B          

; --------------------------------------------------------------
$0219  8D 14               Loc_0219:      BSR Sub_022F           ; call Sub_022F
$021B  31 C9 10 62         Loc_021B:      LEAY 4194,U           
$021F  8D 53                              BSR Sub_0274           ; call Sub_0274
$0221  8D 59                              BSR Sub_027C           ; call Sub_027C
$0223  30 08               Loc_0223:      LEAX 8,X              
$0225  9C 5E               Loc_0225:      CMPX <$5E             
$0227  10 25 FF 66                        LBCS Loc_0191         
$022B  5F                  Loc_022B:      CLRB                   ; B = 0
$022C  10 3F 06                           OS9 F$Exit             ; status=B
$022F  0C 02               Sub_022F:      INC <$02              
$0231  0C 02                              INC <$02              
$0233  8D 08                              BSR Sub_023D           ; call Sub_023D
$0235  0A 02                              DEC <$02              
$0237  1F 98               Sub_0237:      TFR B,A               
$0239  8D 02               Sub_0239:      BSR Sub_023D           ; call Sub_023D
$023B  20 29                              BRA Sub_0266          

; --------------------------------------------------------------
$023D  0C 02               Sub_023D:      INC <$02              
$023F  34 02                              PSHS A                
$0241  44                                 LSRA                  
$0242  44                                 LSRA                  
$0243  44                                 LSRA                  
$0244  44                                 LSRA                  
$0245  8D 04                              BSR Sub_024B           ; call Sub_024B
$0247  35 02                              PULS A                
$0249  84 0F                              ANDA #$0F             
$024B  26 04               Sub_024B:      BNE Loc_0251          
$024D  0D 02                              TST <$02              
$024F  2E 13                              BGT Loc_0264          
$0251  0F 02               Loc_0251:      CLR <$02              
$0253  8B 30                              ADDA #$30             
$0255  81 39                              CMPA #$39              ; compare A with '9'
$0257  23 0F                              BLS Sub_0268          
$0259  8B 07                              ADDA #$07             
$025B  20 0B                              BRA Sub_0268          

; --------------------------------------------------------------
$025D  59                  Sub_025D:      ROLB                  
$025E  25 08                              BCS Sub_0268           ; C=1 (BLO)
$0260  86 2E                              LDA #$2E               ; A = '.'
$0262  20 04                              BRA Sub_0268          

; --------------------------------------------------------------
$0264  0A 02               Loc_0264:      DEC <$02              
$0266  86 20               Sub_0266:      LDA #$20               ; A = ' '
$0268  34 10               Sub_0268:      PSHS X                
$026A  9E 03                              LDX <$03              
$026C  A7 80                              STA ,X+               
$026E  9F 03                              STX <$03              
$0270  35 90                              PULS X,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$0272  8D F4               Loc_0272:      BSR Sub_0268           ; call Sub_0268
$0274  A6 A0               Sub_0274:      LDA ,Y+               
$0276  2A FA                              BPL Loc_0272          
$0278  84 7F                              ANDA #$7F             
$027A  20 EC                              BRA Sub_0268          

; --------------------------------------------------------------
$027C  34 32               Sub_027C:      PSHS A,X,Y            
$027E  86 0D                              LDA #$0D               ; A = CR
$0280  8D E6                              BSR Sub_0268           ; call Sub_0268
$0282  30 4E                              LEAX 14,U             
$0284  9F 03                              STX <$03              
$0286  10 8E 00 50                        LDY #$0050            
$028A  86 01                              LDA #$01              
$028C  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$028F  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$0291  8D 06               Sub_0291:      BSR Sub_0299           ; call Sub_0299
$0293  8D 00                              BSR Sub_0295           ; call Sub_0295
$0295  86 3A               Sub_0295:      LDA #$3A               ; A = ':'
$0297  8D CF                              BSR Sub_0268           ; call Sub_0268
$0299  E6 80               Sub_0299:      LDB ,X+               
$029B  C0 64               Loc_029B:      SUBB #$64             
$029D  24 FC                              BCC Loc_029B           ; C=0 (BHS)
$029F  86 3A                              LDA #$3A               ; A = ':'
$02A1  4A                  Loc_02A1:      DECA                  
$02A2  CB 0A                              ADDB #$0A             
$02A4  24 FB                              BCC Loc_02A1           ; C=0 (BHS)
$02A6  8D C0                              BSR Sub_0268           ; call Sub_0268
$02A8  1F 98                              TFR B,A               
$02AA  8B 30                              ADDA #$30             
$02AC  20 BA                              BRA Sub_0268          

; --------------------------------------------------------------
$02AE  34 50               Sub_02AE:      PSHS X,U              
$02B0  8D 26                              BSR Sub_02D8           ; call Sub_02D8
$02B2  AE 04                              LDX 4,X               
$02B4  10 8E 00 0D                        LDY #$000D            
$02B8  33 C9 10 A2                        LEAU 4258,U           
$02BC  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$02BF  34 06                              PSHS A,B              
$02C1  EC 44                              LDD 4,U               
$02C3  30 8B                              LEAX D,X              
$02C5  35 06                              PULS A,B              
$02C7  EE 62                              LDU 2,S               
$02C9  33 C9 10 62                        LEAU 4194,U           
$02CD  10 8E 00 40                        LDY #$0040            
$02D1  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$02D4  1F 32                              TFR U,Y               
$02D6  35 D0                              PULS X,U,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$02D8  EC 84               Sub_02D8:      LDD ,X                
$02DA  27 0D                              BEQ Loc_02E9          
$02DC  34 20                              PSHS Y                
$02DE  31 C8 62                           LEAY 98,U             
$02E1  34 20                              PSHS Y                
$02E3  93 60                              SUBD <$60             
$02E5  E3 E1                              ADDD ,S++             
$02E7  35 20                              PULS Y                
$02E9  39                  Loc_02E9:      RTS                   

; ==============================================================
; ModEnd — CRC-24 appended by fixmod (not in source)
; ==============================================================
ModEnd
; CRC-24 (3 bytes) appended here by fixmod
         FCB    $00,$00,$00        ; CRC placeholder — overwritten by fixmod
ModCRC
ModSize  EQU    ModCRC-ModHeader   ; module size including 3 CRC bytes