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

; ── BSS Variable Equates ─────────────────────────────────────
BSS.DirPath   EQU    $00      ; path number for the directory opened for reading
BSS.CWDPath   EQU    $01      ; path number for CWD (opened when -e flag set)
BSS.NextDir   EQU    $02      ; pointer to current directory path string (CR terminated)
BSS.BufPtr    EQU    $04      ; pointer to end of current token in command line
BSS.PatPtr    EQU    $06      ; pointer to wildcard pattern string (CR terminated)
BSS.DirCount  EQU    $08      ; flag: set by -c option (case-insensitive match)
BSS.MatchFlag EQU    $09      ; Sub_0317 result: 1=match 0=no match
BSS.ColFlag   EQU    $0A      ; set when at least one entry written to current output line
BSS.AnyFlag   EQU    $0B      ; OR of $0D|$0E|$0F — extended|dirs-only|files-only active
BSS.PatFlag   EQU    $0C      ; set when wildcard pattern specified
BSS.ExtFlag   EQU    $0D      ; set by -e or -l: extended listing mode
BSS.DirOnly   EQU    $0E      ; set by -d: show only directory entries
BSS.FileOnly  EQU    $0F      ; set by -f: show only non-directory entries
BSS.ColWidth  EQU    $10      ; 0=single column (-s), 1=multi-column (default)
BSS.LastCol   EQU    $11      ; terminal column width (from SS.ScSiz, default 80=$50)
BSS.ColmPos   EQU    $12      ; remaining columns on current line — resets to LastCol each new line
BSS.DENameLen EQU    $13      ; length of current filename after FCS→CR reformat
BSS.PatTmp    EQU    $15      ; temp char storage during wildcard pattern matching in Sub_0317
BSS.OpenMode  EQU    $17      ; I$Open/I$ChgDir mode byte — built from flags
BSS.PathBuf   EQU    $25      ; output buffer: copy of NextDir path, reformatted for display
BSS.DEName    EQU    $58      ; RBF directory entry buffer (32 bytes from I$Read)
BSS.DENend    EQU    $75      ; byte 28 of dir entry — last char of FCS name OR CR terminator
BSS.wLSN0     EQU    $76      ; working LSN high byte (shifted from $75 before name reformat)
BSS.wLSN1     EQU    $77      ; working LSN middle byte
BSS.wLSN2     EQU    $78      ; working LSN low byte
BSS.$79       EQU    $79      ; purpose unknown — cleared at init, not seen used after
BSS.DotChar   EQU    $7A      ; dot-file filter char (init='.', cleared by -a to show all)

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

; Init — program entry point.
; Initializes BSS, parses command line, opens directory, runs main listing loop.
$0011  CC 01 50            Init:          LDD #$0150            
$0014  DD 10                              STD <BSS.ColWidth      ; ColWidth=1, LastCol=80
$0016  86 2E                              LDA #$2E               ; A = '.' current directory
$0018  97 7A                              STA <BSS.DotChar      
$001A  4F                                 CLRA                   ; A = 0
$001B  5F                                 CLRB                   ; B = 0
$001C  DD 0E                              STD <BSS.DirOnly      
$001E  DD 0C                              STD <BSS.PatFlag      
$0020  97 08                              STA <BSS.DirCount     
$0022  31 8D 04 44                        LEAY cwdChar,PC        ; Y → cwdChar
$0026  10 9F 02                           STY <BSS.NextDir      
$0029  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$002B  0F 79                              CLR <BSS.$79          
; Command line parse loop.
; X points at OS-9 parameter string (does not include program name).
; Dispatches on: CR (done), space (skip), '-' (option), other (path/pattern).
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
$0045  9F 04               Loc_0045:      STX <BSS.BufPtr       
$0047  35 10                              PULS X                
$0049  A6 84                              LDA ,X                
$004B  81 2D                              CMPA #$2D              ; compare A with '-'
$004D  26 05                              BNE Loc_0054          
$004F  17 01 C2                           LBSR Sub_0214          ; call Sub_0214
$0052  20 03                              BRA Loc_0057          

; --------------------------------------------------------------
$0054  17 02 1D            Loc_0054:      LBSR Sub_0274          ; call Sub_0274
$0057  9E 04               Loc_0057:      LDX <BSS.BufPtr       
$0059  20 D2                              BRA Loc_002D          

; --------------------------------------------------------------
$005B  30 01               Loc_005B:      LEAX 1,X              
$005D  20 CE                              BRA Loc_002D          
; End of command line parsing.
; Build BSS.AnyFlag = BSS.ExtFlag | BSS.DirOnly | BSS.FileOnly.
; Then detect terminal width if multi-column mode active.

; --------------------------------------------------------------
$005F  D7 17               Loc_005F:      STB <BSS.OpenMode     
$0061  D6 0D                              LDB <BSS.ExtFlag      
$0063  DA 0E                              ORB <BSS.DirOnly      
$0065  DA 0F                              ORB <BSS.FileOnly     
$0067  D7 0B                              STB <BSS.AnyFlag      
; Terminal width detection via I$GetStt subcode $20 (PD.OPT offset in path descriptor).
; B returned in X after TFR X,D.
; Thresholds: ≥$50(80)=full, ≥$40(64)=64-col, ≥$30(48)=48-col, ≥$20(32)=32-col, <$20=disable columns.
; $D0 error = non-CCIO device, also disables columns.
$0069  0D 10                              TST <BSS.ColWidth     
$006B  27 33                              BEQ Loc_00A0          
$006D  34 12                              PSHS A,X              
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
$008F  0F 10                              CLR <BSS.ColWidth     
$0091  20 07                              BRA Loc_009A          

; --------------------------------------------------------------
$0093  C1 D0               Loc_0093:      CMPB #$D0             
$0095  27 05                              BEQ Loc_009C          
$0097  16 03 B7                           LBRA Loc_0451         

; --------------------------------------------------------------
$009A  97 11               Loc_009A:      STA <BSS.LastCol      
$009C  1C FE               Loc_009C:      ANDCC #$FE             ; clr CC: C
$009E  35 12                              PULS A,X              
; Open the directory for reading.
; Mode = BSS.OpenMode | $80 (read + directory bit).
$00A0  96 17               Loc_00A0:      LDA <BSS.OpenMode     
$00A2  8A 80                              ORA #$80              
$00A4  9E 02                              LDX <BSS.NextDir      
$00A6  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$00A9  10 25 03 A4                        LBCS Loc_0451         
$00AD  97 00                              STA <BSS.DirPath      
$00AF  9E 02                              LDX <BSS.NextDir      
$00B1  96 17                              LDA <BSS.OpenMode     
$00B3  10 3F 86                           OS9 I$ChgDir           ; mode=B  name→X
; If AnyFlag set (extended or filter mode), also open CWD separately.
; CWD path is the '@'+CR pair at Dat_046C — OS-9 shorthand for current execution dir.
; Wait — that's execution dir (@), not current data dir (.).
; For -e extended mode, the program needs file descriptor info requiring a second open.
$00B6  0D 0B                              TST <BSS.AnyFlag      
$00B8  27 0F                              BEQ Loc_00C9          
$00BA  96 17                              LDA <BSS.OpenMode     
$00BC  30 8D 03 AC                        LEAX execDir,PC        ; X → execDir
$00C0  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$00C3  10 25 03 8A                        LBCS Loc_0451         
$00C7  97 01                              STA <BSS.CWDPath      
; Initialize column position to terminal width.
; If neither extended nor multi-column: skip header, go straight to read loop.
$00C9  96 11               Loc_00C9:      LDA <BSS.LastCol      
$00CB  97 12                              STA <BSS.ColmPos      
$00CD  96 0D                              LDA <BSS.ExtFlag      
$00CF  9A 10                              ORA <BSS.ColWidth     
$00D1  27 53                              BEQ Loc_0126          
; Write "Directory of " header (15 bytes, no CR — path follows on same line).
$00D3  30 8D 03 97                        LEAX dirMsg01,PC       ; X → dirMsg01
$00D7  10 8E 00 0F                        LDY #$000F            
$00DB  86 01                              LDA #$01              
$00DD  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$00E0  10 25 03 6D                        LBCS Loc_0451         
; Copy BSS.NextDir path string to BSS.PathBuf.
; If pattern flag set (-p), append '/' and pattern after path.
; Then I$WritLn the full path — this is the "Directory of /dd/CMDS" header line.
$00E4  31 C8 25                           LEAY BSS.PathBuf,U    
$00E7  9E 02                              LDX <BSS.NextDir      
$00E9  A6 80               Loc_00E9:      LDA ,X+                ; this is a loop copying the NextDir to BSS.$25
$00EB  A7 A0                              STA ,Y+               
$00ED  81 0D                              CMPA #$0D              ; Looking for a CR terminator
$00EF  26 F8                              BNE Loc_00E9           ; Nope?  Keep looking!
$00F1  0D 0C                              TST <BSS.PatFlag      
$00F3  27 13                              BEQ Loc_0108          
$00F5  86 2F                              LDA #$2F               ; A = '/'
$00F7  A7 3F                              STA -1,Y               ; Replace the $0D(CR) with "/"
$00F9  9E 06                              LDX <BSS.PatPtr       
$00FB  A6 80               Loc_00FB:      LDA ,X+               
$00FD  17 02 5F                           LBSR Sub_035F          ; call Sub_035F
$0100  A7 1F                              STA -1,X              
$0102  A7 A0                              STA ,Y+               
$0104  81 0D                              CMPA #$0D              ; compare A with CR
$0106  26 F3                              BNE Loc_00FB          
$0108  30 C8 25            Loc_0108:      LEAX BSS.PathBuf,U    
$010B  10 8E 00 FF                        LDY #$00FF            
$010F  86 01                              LDA #$01              
$0111  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
; If extended mode: write column headers (dirMsg02) via WritBlines.
; dirMsg02 = "User # Last Modified..." header + separator line.
$0114  0D 0D                              TST <BSS.ExtFlag      
$0116  27 0E                              BEQ Loc_0126          
$0118  CC 01 02                           LDD #$0102             ; LDA=$01 (output path), LDB=$02 (Number of lines)
$011B  30 8D 03 5E                        LEAX dirMsg02,PC       ; X → Address of output lines
$011F  17 05 85                           LBSR WritBlines        ; call write out lines
$0122  10 25 03 2B                        LBCS Loc_0451         
; Main directory read loop.
; Reads one 32-byte RBF directory entry per iteration.
; End-of-directory detected at Loc_0451 via error $D3 from I$Read.
$0126  96 00               Loc_0126:      LDA <BSS.DirPath      
$0128  10 8E 00 20                        LDY #$0020            
$012C  30 C8 58                           LEAX BSS.DEName,U     
$012F  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$0132  10 25 03 1B                        LBCS Loc_0451          ; Run away on error
; Shift LSN bytes one position down in BSS before reformatting filename.
; Reason: FCS→CR reformat may write CR at $75 (BSS.DENend), overwriting LSN0.
; After shift, LSN lives at wLSN0/1/2 ($76/$77/$78) — safe from CR overwrite.
; The 32-byte I$Read call deposits a 33-byte working structure by design.
$0136  DC 76                              LDD <BSS.wLSN0        
$0138  DD 77                              STD <BSS.wLSN1        
$013A  96 75                              LDA <BSS.DENend       
$013C  97 76                              STA <BSS.wLSN0        
; Filter pipeline for directory entries:
;   $00 → deleted/empty slot — skip
;   $80 → null FCS name (degenerate) — skip length count, go to Loc_014C
;   strip bit 7, compare to BSS.DotChar:
;     if match → dot/dotdot entry — skip (unless -a cleared DotChar)
$013E  96 58                              LDA <BSS.DEName       
$0140  27 E4                              BEQ Loc_0126           ; Loop back DEName=$00 DELETED! entry
$0142  81 80                              CMPA #$80             
$0144  27 06                              BEQ Loc_014C          
$0146  84 7F                              ANDA #$7F              ; A & %01111111=stripSignBit()
$0148  91 7A                              CMPA <BSS.DotChar     
$014A  27 DA                              BEQ Loc_0126          
; Count filename length and convert FCS format to CR-terminated string.
; FCS = last character has bit 7 set as end-of-name marker.
; BCS loop continues while char < $80 (bit 7 clear).
; After loop: strip bit 7 from last char, append CR at ,X.
; Store length in BSS.DENameLen.
$014C  5F                  Loc_014C:      CLRB                   ; B = 0
$014D  30 C8 58                           LEAX BSS.DEName,U      ; point to filename start
$0150  A6 80               Loc_0150:      LDA ,X+                ; get the byte, X=X+1
$0152  5C                                 INCB                   ; advance length counter
$0153  81 80                              CMPA #$80              ; this compare...?
$0155  25 F9                              BCS Loc_0150           ; If carry set read another character ; C=1 (BLO)
$0157  D7 13                              STB <BSS.DENameLen     ; else, store filename length in BSS.$13
$0159  84 7F                              ANDA #$7F              ; clear the 7th bit
$015B  A7 1F                              STA -1,X               ; fix the last character of the filename
$015D  86 0D                              LDA #$0D               ; A = CR
$015F  A7 84                              STA ,X                 ; terminate the string
; If pattern flag set: call Sub_0317 to wildcard-match filename against pattern.
; Sub_035F (called inside Sub_0317) optionally uppercases for case-insensitive compare.
; If no match: loop back to $0126 for next entry.
$0161  0D 0C                              TST <BSS.PatFlag      
$0163  27 0D                              BEQ Loc_0172          
$0165  30 C8 58                           LEAX BSS.DEName,U     
$0168  10 9E 06                           LDY <BSS.PatPtr       
$016B  17 01 A9                           LBSR Sub_0317          ; call Sub_0317
$016E  0D 09                              TST <BSS.MatchFlag    
$0170  27 B4                              BEQ Loc_0126          
; If AnyFlag set (extended or filter mode):
;   Call I$GetStt on CWD path to get file attributes.
;   BSS.$18 bit 7 = directory attribute bit.
;   If DirOnly set:  skip non-directory entries.
;   If FileOnly set: skip directory entries.
$0172  0D 0B               Loc_0172:      TST <BSS.AnyFlag      
$0174  27 2E                              BEQ Loc_01A4          
$0176  34 40                              PSHS U                
$0178  30 C8 18                           LEAX 24,U	; $18       
$017B  C6 0D                              LDB #$0D               ; B = CR
$017D  96 76                              LDA <BSS.wLSN0        
$017F  1F 02                              TFR D,Y               
$0181  DE 77                              LDU <BSS.wLSN1        
$0183  96 01                              LDA <BSS.CWDPath      
$0185  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$0187  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$018A  35 40                              PULS U                
$018C  10 25 02 C1                        LBCS Loc_0451         
$0190  96 18                              LDA <$18              
$0192  84 80                              ANDA #$80             
$0194  0D 0E                              TST <BSS.DirOnly      
$0196  27 05                              BEQ Loc_019D          
$0198  4D                                 TSTA                  
$0199  27 8B                              BEQ Loc_0126          
$019B  20 07                              BRA Loc_01A4          

; --------------------------------------------------------------
$019D  0D 0F               Loc_019D:      TST <BSS.FileOnly     
$019F  27 03                              BEQ Loc_01A4          
$01A1  4D                                 TSTA                  
$01A2  26 82                              BNE Loc_0126          
; Column layout decision:
;   ColWidth=0 → single column mode → branch to $01FB
;   ColWidth=1 → multi-column mode → continue here
;   Compare filename length against remaining column space.
;   If fits: write filename, pad spaces, update ColmPos.
;   If doesn't fit: emit CR, reset ColmPos, write filename on new line.
$01A4  0D 10               Loc_01A4:      TST <BSS.ColWidth     
$01A6  27 53                              BEQ Loc_01FB          
$01A8  0F 0A                              CLR <BSS.ColFlag      
$01AA  D6 13                              LDB <BSS.DENameLen    
$01AC  D1 12                              CMPB <BSS.ColmPos     
$01AE  2C 2F                              BGE Loc_01DF          
; Filename fits on current line.
; I$Write the filename (not WritLn — no CR yet, more entries may follow).
; Compute padding: subtract filename len from ColmPos in steps of 16.
; Write padding spaces from Dat_0519 (19-space pad string).
; Loop back to $0126.
$01B0  0C 0A               Loc_01B0:      INC <BSS.ColFlag      
$01B2  4F                                 CLRA                   ; A = 0
$01B3  1F 02                              TFR D,Y               
$01B5  4C                                 INCA                  
$01B6  30 C8 58                           LEAX BSS.DEName,U     
$01B9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$01BC  10 25 02 91                        LBCS Loc_0451         
$01C0  96 12                              LDA <BSS.ColmPos      
$01C2  80 10               Loc_01C2:      SUBA #$10             
$01C4  2F 19                              BLE Loc_01DF          
$01C6  C0 10                              SUBB #$10             
$01C8  2C F8                              BGE Loc_01C2          
$01CA  50                                 NEGB                  
$01CB  97 12                              STA <BSS.ColmPos      
$01CD  4F                                 CLRA                   ; A = 0
$01CE  1F 02                              TFR D,Y               
$01D0  4C                                 INCA                  
$01D1  30 8D 03 44                        LEAX Dat_0519,PC       ; X → Dat_0519
$01D5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$01D8  10 25 02 75                        LBCS Loc_0451         
$01DC  16 FF 47                           LBRA Loc_0126         
; Filename didn't fit — start new line.
; I$WritLn cwdAndCR (just a CR byte) to terminate current line.
; Reset ColmPos to LastCol (full width again).
; If BSS.ColFlag set (something was on this line before): loop to pad logic.
; Otherwise loop to $0126.

; --------------------------------------------------------------
$01DF  86 01               Loc_01DF:      LDA #$01              
$01E1  10 8E 00 01                        LDY #$0001            
$01E5  30 8D 02 82                        LEAX cwdAndCR,PC       ; X → cwdAndCR
$01E9  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$01EC  10 25 02 61                        LBCS Loc_0451         
$01F0  96 11                              LDA <BSS.LastCol      
$01F2  97 12                              STA <BSS.ColmPos      
$01F4  0D 0A                              TST <BSS.ColFlag      
$01F6  27 B8                              BEQ Loc_01B0          
$01F8  16 FF 2B                           LBRA Loc_0126         
; Single-column narrow mode entry point.
; Reached when ColWidth=0 (set by -s, or forced by narrow terminal).
; If ExtFlag set → format full extended line via Loc_036E.
; If ExtFlag clear → simple I$WritLn of filename (30 bytes).

; --------------------------------------------------------------
$01FB  0D 0D               Loc_01FB:      TST <BSS.ExtFlag      
$01FD  10 26 01 6D                        LBNE Loc_036E         
$0201  86 01                              LDA #$01              
$0203  30 C8 58                           LEAX BSS.DEName,U     
$0206  10 8E 00 1E                        LDY #$001E            
$020A  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$020D  10 25 02 40                        LBCS Loc_0451         
$0211  16 FF 12                           LBRA Loc_0126         
; Option parser — advances past '-', reads letter, uppercases, dispatches.

; --------------------------------------------------------------
$0214  30 01               Sub_0214:      LEAX 1,X               ; X=X+1
$0216  A6 84                              LDA ,X                 ; get the next byte
$0218  81 20                              CMPA #$20              ; is it a space?
$021A  27 28                              BEQ OptRTS             ; ...go RTS
$021C  81 0D                              CMPA #$0D              ; At the end of the cmdlin?
$021E  27 24                              BEQ OptRTS             ; yeah, prolly ...go RTS
$0220  84 DF                              ANDA #$DF              ; A & %11011111 == toUpper()
$0222  81 45                              CMPA #$45              ; compare A with 'E'
$0224  27 38                              BEQ OptEL             
$0226  81 53                              CMPA #$53              ; compare A with 'S'
$0228  27 30                              BEQ OptS              
$022A  81 44                              CMPA #$44              ; compare A with 'D'
$022C  27 36                              BEQ OptD              
$022E  81 46                              CMPA #$46              ; compare A with 'F'
$0230  27 38                              BEQ OptF              
$0232  81 58                              CMPA #$58              ; compare A with 'X'
$0234  27 20                              BEQ OptX              
$0236  81 43                              CMPA #$43              ; compare A with 'C'
$0238  27 0B                              BEQ OptC              
$023A  81 4C                              CMPA #$4C              ; compare A with 'L'
$023C  27 20                              BEQ OptEL             
$023E  81 41                              CMPA #$41              ; compare A with 'A'
$0240  27 2E                              BEQ OptA              
$0242  20 05                              BRA OptUnknown        

; --------------------------------------------------------------
$0244  39                  OptRTS:        RTS                   
$0245  0C 08               OptC:          INC <BSS.DirCount     
$0247  20 CB                              BRA Sub_0214          

; --------------------------------------------------------------
$0249  CC 01 0C            OptUnknown:    LDD #$010C            
$024C  30 8D 02 DC                        LEAX helpMsg,PC        ; X → helpMsg
$0250  17 04 54                           LBSR WritBlines        ; call WritBlines
$0253  16 01 FB                           LBRA Loc_0451         

; --------------------------------------------------------------
$0256  CB 04               OptX:          ADDB #$04             
$0258  20 BA                              BRA Sub_0214          

; --------------------------------------------------------------
$025A  0F 10               OptS:          CLR <BSS.ColWidth     
$025C  20 B6                              BRA Sub_0214          

; --------------------------------------------------------------
$025E  0C 0D               OptEL:         INC <BSS.ExtFlag      
$0260  0F 10                              CLR <BSS.ColWidth     
$0262  20 B0                              BRA Sub_0214          

; --------------------------------------------------------------
$0264  0C 0E               OptD:          INC <BSS.DirOnly      
$0266  0F 0F                              CLR <BSS.FileOnly     
$0268  20 AA                              BRA Sub_0214          

; --------------------------------------------------------------
$026A  0C 0F               OptF:          INC <BSS.FileOnly     
$026C  0F 0E                              CLR <BSS.DirOnly      
$026E  20 A4                              BRA Sub_0214          

; --------------------------------------------------------------
$0270  0F 7A               OptA:          CLR <BSS.DotChar      
$0272  20 A0                              BRA Sub_0214          

; --------------------------------------------------------------
$0274  9F 02               Sub_0274:      STX <BSS.NextDir      
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
$02A4  39                  Loc_02A4:      RTS                   
$02A5  81 2A               Loc_02A5:      CMPA #$2A              ; compare A with '*'
$02A7  27 0B                              BEQ Loc_02B4          
$02A9  81 3F                              CMPA #$3F              ; compare A with '?'
$02AB  27 07                              BEQ Loc_02B4          
$02AD  C6 EB                              LDB #$EB              
$02AF  1A 01                              ORCC #$01              ; set CC: C
$02B1  16 01 9D                           LBRA Loc_0451         

; --------------------------------------------------------------
$02B4  9F 06               Loc_02B4:      STX <BSS.PatPtr       
$02B6  A6 80               Loc_02B6:      LDA ,X+               
$02B8  81 0D                              CMPA #$0D              ; compare A with CR
$02BA  27 08                              BEQ Loc_02C4          
$02BC  81 20                              CMPA #$20              ; compare A with ' '
$02BE  26 F6                              BNE Loc_02B6          
$02C0  86 0D                              LDA #$0D               ; A = CR
$02C2  A7 82                              STA ,-X               
$02C4  9E 06               Loc_02C4:      LDX <BSS.PatPtr       
$02C6  A6 82               Loc_02C6:      LDA ,-X               
$02C8  9C 02                              CMPX <BSS.NextDir     
$02CA  26 0A                              BNE Loc_02D6          
$02CC  9F 06                              STX <BSS.PatPtr       
$02CE  30 8D 01 98                        LEAX cwdChar,PC        ; X → cwdChar
$02D2  9F 02                              STX <BSS.NextDir      
$02D4  20 0A                              BRA Loc_02E0          

; --------------------------------------------------------------
$02D6  81 2F               Loc_02D6:      CMPA #$2F              ; compare A with '/'
$02D8  26 EC                              BNE Loc_02C6          
$02DA  86 0D                              LDA #$0D               ; A = CR
$02DC  A7 80                              STA ,X+               
$02DE  9F 06                              STX <BSS.PatPtr       
$02E0  0C 0C               Loc_02E0:      INC <BSS.PatFlag      
$02E2  9E 06                              LDX <BSS.PatPtr       
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
$0316  39                  Loc_0316:      RTS                   
$0317  A6 84               Sub_0317:      LDA ,X                
$0319  8D 44                              BSR Sub_035F           ; call Sub_035F
$031B  E6 A4                              LDB ,Y                
$031D  DD 15                              STD <BSS.PatTmp       
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
$0335  D1 15                              CMPB <BSS.PatTmp      
$0337  26 23                              BNE Loc_035C          
$0339  30 01               Loc_0339:      LEAX 1,X              
$033B  31 21                              LEAY 1,Y              
$033D  20 D8                              BRA Sub_0317          

; --------------------------------------------------------------
$033F  31 21               Loc_033F:      LEAY 1,Y              
$0341  E6 A4                              LDB ,Y                
$0343  C1 0D                              CMPB #$0D              ; compare B with CR
$0345  27 10                              BEQ Loc_0357          
$0347  D1 15               Loc_0347:      CMPB <BSS.PatTmp      
$0349  27 EE                              BEQ Loc_0339          
$034B  30 01                              LEAX 1,X              
$034D  A6 84                              LDA ,X                
$034F  81 0D                              CMPA #$0D              ; compare A with CR
$0351  27 09                              BEQ Loc_035C          
$0353  97 15                              STA <BSS.PatTmp       
$0355  20 F0                              BRA Loc_0347          

; --------------------------------------------------------------
$0357  86 01               Loc_0357:      LDA #$01              
$0359  97 09                              STA <BSS.MatchFlag    
$035B  39                                 RTS                   

; --------------------------------------------------------------
$035C  0F 09               Loc_035C:      CLR <BSS.MatchFlag    
$035E  39                                 RTS                   

; --------------------------------------------------------------
$035F  0D 08               Sub_035F:      TST <BSS.DirCount     
$0361  26 0A                              BNE Loc_036D          
$0363  81 61                              CMPA #$61              ; compare A with 'a'
$0365  25 06                              BCS Loc_036D           ; C=1 (BLO)
$0367  81 7A                              CMPA #$7A              ; compare A with 'z'
$0369  22 02                              BHI Loc_036D          
$036B  84 DF                              ANDA #$DF             
$036D  39                  Loc_036D:      RTS                   
; Extended listing formatter.
; Reached when -e/-l AND single-column mode.
; Copies filename portion from dirMsg03 format template to BSS.PathBuf.
; Then fills in metadata fields by reading from file descriptor sector.
; Uses wLSN0/1/2 to locate the file descriptor sector.
; Field order in output: user#, date, time, attributes, sector, size, filename.
; Sub_041A: converts byte to 2 decimal ASCII digits in output buffer.
; Sub_042B: converts byte to 2 hex ASCII digits.
; Sub_0442: strips leading "space+zero" for cleaner numeric fields.
$036E  30 8D 01 87         Loc_036E:      LEAX dirMsg03,PC       ; X → dirMsg03
$0372  31 C8 25                           LEAY BSS.PathBuf,U    
$0375  A6 80               Loc_0375:      LDA ,X+               
$0377  81 0A                              CMPA #$0A              ; Did we reach the next msgBlock?
$0379  27 04                              BEQ Loc_037F           ; If yes, break from loop
$037B  A7 A0                              STA ,Y+                ; Otherwise copy that char to Y+
$037D  20 F6                              BRA Loc_0375           ; Keep looping

; --------------------------------------------------------------
$037F  31 C8 26            Loc_037F:      LEAY 38,U	; $26       
$0382  30 C8 19                           LEAX 25,U	; $19       
$0385  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$0387  A6 80               Loc_0387:      LDA ,X+               
$0389  17 00 9F                           LBSR Sub_042B          ; call Sub_042B
$038C  5A                                 DECB                  
$038D  26 F8                              BNE Loc_0387          
$038F  30 C8 26                           LEAX 38,U	; $26       
$0392  17 00 AD                           LBSR Sub_0442          ; call Sub_0442
$0395  31 C8 2C                           LEAY 44,U	; $2C       
$0398  30 C8 1B                           LEAX 27,U	; $1B       
$039B  E6 84                              LDB ,X                
$039D  4F                                 CLRA                   ; A = 0
$039E  C1 64               Loc_039E:      CMPB #$64              ; compare B with 'd'
$03A0  25 05                              BCS Loc_03A7           ; C=1 (BLO)
$03A2  4C                                 INCA                  
$03A3  C0 64                              SUBB #$64             
$03A5  20 F7                              BRA Loc_039E          

; --------------------------------------------------------------
$03A7  1F 89               Loc_03A7:      TFR A,B               
$03A9  8B 13                              ADDA #$13             
$03AB  8D 6D                              BSR Sub_041A           ; call Sub_041A
$03AD  86 64                              LDA #$64               ; A = 'd'
$03AF  3D                                 MUL                    ; D = A×B unsigned
$03B0  34 04                              PSHS B                
$03B2  A6 80                              LDA ,X+               
$03B4  A0 E0                              SUBA ,S+              
$03B6  8D 62                              BSR Sub_041A           ; call Sub_041A
$03B8  31 21                              LEAY 1,Y              
$03BA  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$03BC  A6 80               Loc_03BC:      LDA ,X+               
$03BE  8D 5A                              BSR Sub_041A           ; call Sub_041A
$03C0  31 21                              LEAY 1,Y              
$03C2  5A                                 DECB                  
$03C3  26 F7                              BNE Loc_03BC          
$03C5  A6 80                              LDA ,X+               
$03C7  8D 51                              BSR Sub_041A           ; call Sub_041A
$03C9  A6 84                              LDA ,X                
$03CB  8D 4D                              BSR Sub_041A           ; call Sub_041A
$03CD  31 C8 3D                           LEAY 61,U	; $3D       
$03D0  30 C8 18                           LEAX 24,U	; $18       
$03D3  CC 2D 08                           LDD #$2D08            
$03D6  68 84               Loc_03D6:      LSL ,X                
$03D8  25 02                              BCS Loc_03DC           ; C=1 (BLO)
$03DA  A7 A4                              STA ,Y                
$03DC  31 21               Loc_03DC:      LEAY 1,Y              
$03DE  5A                                 DECB                  
$03DF  26 F5                              BNE Loc_03D6          
$03E1  31 C8 47                           LEAY 71,U	; $47       
$03E4  30 C8 76                           LEAX BSS.wLSN0,U      
$03E7  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$03E9  A6 80               Loc_03E9:      LDA ,X+               
$03EB  8D 3E                              BSR Sub_042B           ; call Sub_042B
$03ED  5A                                 DECB                  
$03EE  26 F9                              BNE Loc_03E9          
$03F0  30 C8 47                           LEAX 71,U	; $47       
$03F3  8D 4D                              BSR Sub_0442           ; call Sub_0442
$03F5  31 C8 4F                           LEAY 79,U	; $4F       
$03F8  30 C8 21                           LEAX 33,U	; $21       
$03FB  C6 04                              LDB #$04              
$03FD  A6 80               Loc_03FD:      LDA ,X+               
$03FF  8D 2A                              BSR Sub_042B           ; call Sub_042B
$0401  5A                                 DECB                  
$0402  26 F9                              BNE Loc_03FD          
$0404  30 C8 4F                           LEAX 79,U	; $4F       
$0407  8D 39                              BSR Sub_0442           ; call Sub_0442
$0409  30 C8 25                           LEAX BSS.PathBuf,U    
$040C  10 8E 00 50                        LDY #$0050            
$0410  86 01                              LDA #$01              
$0412  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$0415  25 3A                              BCS Loc_0451           ; C=1 (BLO)
$0417  16 FD 0C                           LBRA Loc_0126         

; --------------------------------------------------------------
$041A  81 0A               Sub_041A:      CMPA #$0A              ; compare A with LF
$041C  25 06                              BCS Loc_0424           ; C=1 (BLO)
$041E  6C A4                              INC ,Y                
$0420  80 0A                              SUBA #$0A             
$0422  20 F6                              BRA Sub_041A          

; --------------------------------------------------------------
$0424  31 21               Loc_0424:      LEAY 1,Y              
$0426  8B 30                              ADDA #$30             
$0428  A7 A0                              STA ,Y+               
$042A  39                                 RTS                   

; --------------------------------------------------------------
$042B  34 02               Sub_042B:      PSHS A                
$042D  44                                 LSRA                  
$042E  44                                 LSRA                  
$042F  44                                 LSRA                  
$0430  44                                 LSRA                  
$0431  8D 04                              BSR Sub_0437           ; call Sub_0437
$0433  35 02                              PULS A                
$0435  84 0F                              ANDA #$0F             
$0437  8B 30               Sub_0437:      ADDA #$30             
$0439  81 39                              CMPA #$39              ; compare A with '9'
$043B  23 02                              BLS Loc_043F          
$043D  8B 07                              ADDA #$07             
$043F  A7 A0               Loc_043F:      STA ,Y+               
$0441  39                  Loc_0441:      RTS                   
$0442  CC 30 20            Sub_0442:      LDD #$3020            
$0445  A1 84               Loc_0445:      CMPA ,X               
$0447  26 F8                              BNE Loc_0441          
$0449  E1 01                              CMPB 1,X              
$044B  27 F4                              BEQ Loc_0441          
$044D  E7 80                              STB ,X+               
$044F  20 F4                              BRA Loc_0445          
; Error/exit handler.
; Error $D3 = end-of-directory (I$Read past last entry) = normal termination.
; If multi-column and ColWidth still set: emit final CR to terminate last line.
; F$Exit with B = 0 (normal) or error code.

; --------------------------------------------------------------
$0451  C1 D3               Loc_0451:      CMPB #$D3              ; %11010011 ?
$0453  26 01                              BNE Loc_0456          
$0455  5F                                 CLRB                   ; B = 0
$0456  0D 10               Loc_0456:      TST <BSS.ColWidth      ; That variable
$0458  27 0D                              BEQ Loc_0467           ; Don't like TST=0? Fine! Quit!
$045A  30 8D 00 0D                        LEAX cwdAndCR,PC       ; X → cwdAndCR
$045E  86 01                              LDA #$01              
$0460  10 8E 00 01                        LDY #$0001            
$0464  10 3F 8C                           OS9 I$WritLn           ; Why WritLn not Write?
$0467  10 3F 06            Loc_0467:      OS9 F$Exit             ; status=B

cwdChar
; Referenced by: $0022, $02CE
; ── 1 ($0001) bytes  ($046A—$046A) ──
         FCB    $2E               ; '.'
cwdCharend

cwdAndCR
; Referenced by: $01E5, $045A
; ── 1 ($0001) bytes  ($046B—$046B) ──
         FCB    $0D               ; CR
cwdAndCRend

execDir
; Referenced by: $00BC
; ── 2 ($0002) bytes  ($046C—$046D) ──
         FCB    $40               ; '@'
         FCB    $0D               ; CR

dirMsg01
; Referenced by: $00D3
; ── 15 ($000F) bytes  ($046E—$047C) ──
         FCB    $0A               ; LF
         FCC    " Directory of "
dirMsg01end

dirMsg02
; Referenced by: $011B
; ── 124 ($007C) bytes  ($047D—$04F8) ──
         FCB    $0A               ; LF
         FCC    "User # Last Modified   Attributes Sector File Size File Name"
         FCB    $0D               ; CR
         FCC    "------ --------------- ---------- ------ --------- ----------"
         FCB    $0D               ; CR
dirMsg02end

dirMsg03
; Referenced by: Loc_036E
; ── 32 ($0020) bytes  ($04F9—$0518) ──
         FCC    "       0000/00/00 0000  dsewrewr"
dirMsg03end
; The last line is a format template — fields updated in place.

Dat_0519
; Referenced by: $01D1
; ── 19 ($0013) bytes  ($0519—$052B) ──
         FCC    "                   "

helpMsg
; Referenced by: $024C
; ── 379 ($017B) bytes  ($052C—$06A6) ──
         FCB    $0A               ; LF
         FCC    "dir [-opts] [path/patt] [-opts]"
         FCB    $0D               ; CR
         FCC    "opts: x - use current exec dir"
         FCB    $0D               ; CR
         FCC    "      s - one entry/line"
         FCB    $0D               ; CR
         FCC    "    e/l - extended directory"
         FCB    $0D               ; CR
         FCC    "      a - show '.files', too"
         FCB    $0D               ; CR
         FCC    "      d - only directory files"
         FCB    $0D               ; CR
         FCC    "      f - only non-dir files"
         FCB    $0D               ; CR
         FCC    "      c - case insensitive filename match (BUT NOT DIR NAME)"
         FCB    $0D               ; CR
         FCC    "      ? - help message"
         FCB    $0D               ; CR
         FCC    "pattern: may include wild cards"
         FCB    $0D               ; CR
         FCC    "      * - multiple character"
         FCB    $0D               ; CR
         FCC    "      ? - single character"
         FCB    $0D               ; CR
helpMsgend
$06A7  5A                  WritBlines:    DECB                   ; B=# of lines, X=location of stuff to print.
$06A8  10 8E 00 50                        LDY #$0050             ; Max length = 80 columns
$06AC  10 3F 8C                           OS9 I$WritLn           ; path=A=$01  buf→X
$06AF  25 0B                              BCS endWritBlines      ; Error detected. Break out of loop.
$06B1  34 06                              PSHS A,B               ; Save the path and line count
$06B3  1F 20                              TFR Y,D                ; Y now contains # chars printed and so does D
$06B5  30 8B                              LEAX D,X               ; Move X pointet to next line
$06B7  35 06                              PULS A,B               ; Bring A and B back.
$06B9  5D                                 TSTB                   ; Is B zero? (last line)
$06BA  26 EB                              BNE WritBlines         ; If not loop back where it decrements B for the next line
$06BC  39                  endWritBlines: RTS                   

; ==============================================================
; ModEnd — CRC-24 appended by fixmod (not in source)
; ==============================================================
ModEnd
; CRC-24 (3 bytes) appended here by fixmod
         FCB    $00,$00,$00        ; CRC placeholder — overwritten by fixmod
ModCRC
ModSize  EQU    ModCRC-ModHeader   ; module size including 3 CRC bytes
; ══════════════════════════════════════════════════════════════
; MARKUP QUICK REFERENCE  (markup.py directives)
; ══════════════════════════════════════════════════════════════
;
; Run:  python markup.py proj.asm [proj.json]
; Then: python dis6809_os9_engine.py --source bin --proj proj.json -n
;
; ── Labeling ──────────────────────────────────────────────────
;
; /label/ Name
;     Name the next $XXXX address in the listing.
;     Example:
;         /label/ Sub_ReadDir
;         $0126  96 00    LDA <$00
;
; /label/ $addr Name
;     Name a specific address directly — works for data labels too.
;     Example:
;         /label/ $046A cwdChar
;         /label/ $046B cwdAndCR
;
; /rename-label/ OldName NewName
;     Rename an existing label by its current name.
;     Works for both code and data labels — no address scanning needed.
;     Example:
;         /rename-label/ Dat_046A cwdChar
;         /rename-label/ Dat_046B cwdAndCR
;
; /bss/ $XX Name
;     Declare a BSS variable at direct page or U-relative offset $XX.
;     Optional quoted comment appended to the EQU line.
;     Example:
;         /bss/ $00 BSS.DirPath
;         /bss/ $58 BSS.DEntName "29-byte filename field of RBF directory entry"
;
; ── Data regions ──────────────────────────────────────────────
;
; /region/ $start $end [format] [label] [endlabel]
; /dlabel/ $start $end [format] [label] [endlabel]
;     Declare a data region. /dlabel/ is an alias for /region/ with a name
;     that signals "this is a named data label".
;     Format: auto text fdb hexdump raw writeblock
;     +endlabel — emit a NameEnd label at the region boundary.
;     Example:
;         /dlabel/ $046A $046B auto cwdChar
;         /dlabel/ $046B $046C auto cwdAndCR
;         /region/ $052C $06A7 text +endlabel
;
; /format/ fmt
;     Set format for the preceding data label's region.
;     Example:
;         Dat_046E
;         /format/ text
;
; /end-label/
;     Mark end of a data region at the next address.
;     Example:
;         /end-label/
;         $06A7  5A    Sub_06A7: DECB
;
; ── Comments ──────────────────────────────────────────────────
;
; /; comment text/
;     Inline comment appended to the instruction on this line.
;     Example:
;         $00E9  A6 80    LDA ,X+    /; loop copying path to buffer/
;
; /; /
;     Empty inline comment — inhibits any auto-generated comment for
;     this address permanently (stores "" in JSON as a suppressor).
;     The inhibitor persists across disassembler runs.
;     Use /remove-line-comment/ $addr to lift the inhibition.
;
; /comment/ [$addr]
; comment line 1
; comment line 2
; /end-comment/
;     Block comment inserted before the target address.
;     Optional $addr targets a specific address directly.
;     Without $addr, targets the next $XXXX line.
;     Example:
;         /comment/ $0519
;         This FCC line is a format template updated in place.
;         /end-comment/
;
; /remove-comment/
; comment line to remove
; /end-remove-comment/
;     Remove a block comment matching the given content from the JSON.
;     Prefix '; ' on each line is stripped before matching.
;     Example:
;         /remove-comment/
;         ; This comment is no longer needed.
;         /end-remove-comment/
;
; /remove-line-comment/ $addr
;     Remove a line comment or inhibitor from the JSON at the given address.
;     Auto-generated comments will return on the next disassembler run.
;     Example:
;         /remove-line-comment/ $06BC
;
; ── Substitutions ─────────────────────────────────────────────
;
; /replace/
; <original disassembler lines>
; /with/
; <replacement source lines>
; /end-replace/
;     Replace disassembler output with analyst-supplied source.
;     WARNING: byte counts must match. Instruction substitutions
;     trigger a confirmation prompt — mismatch breaks byte-perfect.
;     Example:
;         /replace/
;                  FCB    $0A               ; LF
;                  FCC    "Dir"
;         /with/
;                  FCB    C$LF
;                  FCS    /Dir/
;         /end-replace/
;
; ── Routines ──────────────────────────────────────────────────
;
; /routine/ Name
; ...code...
; /end-routine/ Name
;     Mark a routine boundary for structural annotation.
;
; ══════════════════════════════════════════════════════════════
