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
BSS.ParamStr  EQU    2        ; BSS offset $0002
BSS.ParamBase EQU    4        ; BSS offset $0004
BSS.RxBufPtr  EQU    6        ; BSS offset $0006
BSS.TxBufPtr  EQU    8        ; BSS offset $0008
BSS.Var000B   EQU    11       ; BSS offset $000B
BSS.CurrChar  EQU    30       ; BSS offset $001E
BSS.PrevChar  EQU    31       ; BSS offset $001F
BSS.StateFlag EQU    32       ; BSS offset $0020
BSS.Counter1  EQU    45       ; BSS offset $002D
BSS.TermMode  EQU    51       ; BSS offset $0033
BSS.EchoFlag  EQU    70       ; BSS offset $0046
BSS.FlowCtrl  EQU    74       ; BSS offset $004A
BSS.Counter2  EQU    77       ; BSS offset $004D
BSS.Counter3  EQU    78       ; BSS offset $004E
BSS.ConnState EQU    90       ; BSS offset $005A
BSS.ConnWord  EQU    91       ; BSS offset $005B
BSS.BufPtr1   EQU    93       ; BSS offset $005D
BSS.BufCount  EQU    95       ; BSS offset $005F
BSS.BufPtr2   EQU    99       ; BSS offset $0063
BSS.BufPtr3   EQU    101      ; BSS offset $0065
BSS.Counter4  EQU    103      ; BSS offset $0067
BSS.CommPtr   EQU    3660     ; BSS offset $0E4C
BSS.CommState EQU    3665     ; BSS offset $0E51
BSS.CommSz1   EQU    3671     ; BSS offset $0E57
BSS.CommSz2   EQU    3673     ; BSS offset $0E59
BSS.CommOff   EQU    3676     ; BSS offset $0E5C
BSS.CommFlag  EQU    3693     ; BSS offset $0E6D
BSS.BaudState EQU    3699     ; BSS offset $0E73
BSS.FlowState EQU    3703     ; BSS offset $0E77
BSS.IoBuf     EQU    6613     ; BSS offset $19D5

; ==============================================================
; Disassembly:  /home/claude/SuperComm/supercomm22
; Module:       SuperComm
; Type:         program  ($11)
; Size:         $45C5  (17861 bytes)
; Entry:        $0A71
; BSS:          $2000  (8192 bytes)
; CRC-24:       $F5ADE1
;
; SuperComm v2.2 — OS-9 Level II terminal / communications program
; Author: Dave Philipsen  Copyright (c) 1988, 1989
; v2.2 updates (1992) by Randy K. Wilson
; 
; New in v2.2 vs v2.1:
;   + CRC-16/CCITT lookup table (L3C0F / CrcTable) for file transfer
;   + ZModem support (External ZModem Send/Receive, Auto Zmodem)
;   + 16550 UART support variant (supercomm23_16550)
;   + Module is 3693 bytes larger than v2.1
; 
; Same config-patch-and-reseal design as v2.1.
; ==============================================================

; ----- Module Header -----
ModHeader
         FDB    $87CD             ; OS-9 module sync bytes
         FDB    ModCRC-ModHeader   ; module size (content + 3 CRC bytes)
         FDB    ModName           ; name offset
         FCB    $11               ; type: program
         FCB    $81               ; language
         FCB    $A8               ; attributes/parity
         FDB    Init              ; execution entry
         FDB    $2000             ; BSS size

; ----- Module Name -----
ModName
         FCS    "SuperComm"

; ==============================================================
; Pre-exec data  (post-name)—$0A70
; Everything here is DATA — no executable code.
; ==============================================================

         FCB    $01               ; SOH
         FCC    "Program by Dave Philipsen Copyright (c) 1988, 1989,1992 ('92 updates by "
         FCC    "Randy K. Wilson)"

Dat_006F
; Referenced by: $0BCC
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.2"
         FCB    CurXY,$24,$23     ; CurXY(row=4,col=3)
         FCC    "Copyright (c)"
         FCB    CurXY,$23,$24     ; CurXY(row=3,col=4)
         FCC    "1988, 1989, 1992"
         FCB    CurXY,$26,$26     ; CurXY(row=6,col=6)
         FCC    "written by"
         FCB    CurXY,$24,$27     ; CurXY(row=4,col=7)
         FCC    "Dave Philipsen"

Dat_00C6
; Referenced by: $0BED
         FCB    $00               ; NUL
         FCB    $23               ; '#'
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$22,$21     ; CurXY(row=2,col=1)
         FCC    "with updates by"
         FCB    CurXY,$22,$22     ; CurXY(row=2,col=2)
         FCC    " Randy Wilson"

Dat_00EB
; Referenced by: Sub_2BC0
         FCB    $00               ; NUL
         FCB    $1C               ; $1C
         FCB    CurXY,$40,$20     ; CurXY(row=32,col=0)
         FCB    ESC,W.FColor,$04         ; Foreground Color palette[4]
         FCC    "SuperComm v2.2 "
         FCB    ESC,W.FColor,$03         ; Foreground Color palette[3]
         FCB    CurXY,$58,$20     ; CurXY(row=56,col=0)
         FCB    $3D               ; '='

Dat_0109
; Referenced by: $111E
         FCB    $01               ; SOH
         FCB    $C6
         FCC    "   Use <ALT> key with the following keys:"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCC    " A - Auto Dialer           Q - Quit"
         FDB    $0D0A             ; CRLF
         FCC    " B - Baud Rates            R - Reset Palettes"
         FDB    $0D0A             ; CRLF
         FCC    " C - Clear Screen          S - OS9 Shell Access"
         FDB    $0D0A             ; CRLF
         FCC    " D - Change Directory      T - Terminal Type"
         FDB    $0D0A             ; CRLF
         FCC    " H - Hang Up               U - Update SuperComm"
         FDB    $0D0A             ; CRLF
         FCC    " I - Timer on/off          Z - Conference Mode"
         FDB    $0D0A             ; CRLF
         FCC    " M - Open/Close Buffer   <Up>- Upload file"
         FDB    $0D0A             ; CRLF
         FCC    " O - Change Options      <Dn>- Download File"
         FCB    $0A               ; LF
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    "     Select function or <Space> to continue"

Dat_02D1
; Referenced by: $2DF5
         FCS    "CONNECT"

Dat_02D8
; Referenced by: $2E28
         FCS    "BUSY"

Dat_02DC
; Referenced by: $1A01, Sub_3446
         FCC    "ATH"
         FCB    $0D               ; CR

Dat_02E0
; Referenced by: $171C
         FCC    "Shell"

Dat_02E5
; Referenced by: $1718
         FCB    $0D               ; CR

Dat_02E6
; Referenced by: $17E3
         FCC    "rz"
         FCB    $0D               ; CR

Dat_02E9
; Referenced by: $17DF
         FCC    "-vv   "
         FCB    $0D               ; CR

Dat_02F0
; Referenced by: $17A4
         FCB    $00               ; NUL
         FCB    $28               ; '('
         FCB    CurXY,$34,$20     ; CurXY(row=20,col=0)
         FCC    "External ZModem File Receive"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCB    ESC,W.CWArea,$00,$03,$40,$07  ; CPX=0 CPY=3 SZX=64 SZY=7

Dat_031A
; Referenced by: $0C49, Sub_1090, $10B7
         FCB    $2A               ; '*'
         FCB    $18               ; CAN erase-BOL
         FCC    "B0"
         FCB    $00               ; NUL

Dat_031F
; Referenced by: $1909
         FCC    "sz"
         FCB    $0D               ; CR

Dat_0322
; Referenced by: $186A
         FCB    $00               ; NUL
         FCB    $25               ; '%'
         FCB    CurXY,$36,$20     ; CurXY(row=22,col=0)
         FCC    "External ZModem File Send"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCB    ESC,W.CWArea,$00,$03,$40,$07  ; CPX=0 CPY=3 SZX=64 SZY=7

Dat_0349
; Referenced by: $19A6
         FCB    $00               ; NUL
         FCB    $0F               ; SI cursor-left
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    " Hanging Up!!"

Dat_035A
; Referenced by: Sub_0AB6
         FCC    "/t2"
         FCB    $0D               ; CR
         FCB    $00               ; NUL
         FCB    $00               ; NUL

Dat_0360
; Referenced by: $0B4F
         FCC    "/nil"
         FCB    $0D               ; CR
         FCB    $00               ; NUL

Dat_0366
; Referenced by: $0B11, $1772, $2EC9
         FCB    CurXY,$2B,$20     ; CurXY(row=11,col=0)
         FCC    "00:00:00"

Dat_0371
; Referenced by: $1BE6
         FCB    $00               ; NUL
         FCB    $20               ; ' '
         FCB    $00               ; NUL
         FCB    $3F               ; '?'
         FCB    $10               ; $10
         FCC    " ??"
         FCB    $00               ; NUL
         FCB    $20               ; ' '
         FCB    $00               ; NUL
         FCB    $3F               ; '?'
         FCB    $10               ; $10
         FCC    " ??"

Dat_0381
; Referenced by: Sub_1C12
         FCB    $00               ; NUL
         FCB    $24               ; '$'
         FCB    $12               ; $12
         FCB    $37               ; '7'
         FCB    $09               ; HT
         FCB    $28               ; '('
         FCB    $1F               ; $1F
         FCB    $3F               ; '?'
         FCB    $00               ; NUL
         FCB    $24               ; '$'
         FCB    $12               ; $12
         FCB    $37               ; '7'
         FCB    $09               ; HT
         FCB    $28               ; '('
         FCB    $1F               ; $1F
         FCB    $3F               ; '?'

Dat_0391
; Referenced by: $1BF2
         FCB    $3F               ; '?'
         FCB    $09               ; HT
         FCB    $00               ; NUL
         FCB    $12               ; $12
         FCC    "$7("
         FCB    $1F               ; $1F
         FCB    $3F               ; '?'
         FCB    $09               ; HT
         FCB    $00               ; NUL
         FCB    $12               ; $12
         FCC    "$7("
         FCB    $1F               ; $1F

Dat_03A1
; Referenced by: Sub_1C6C
         FCB    $07               ; BEL
         FCB    $00               ; NUL
         FCB    $00               ; NUL

Dat_03A4
; Referenced by: $1C66
         FCB    $00               ; NUL
         FCB    $02               ; CurXY
         FCB    $02               ; CurXY

Dat_03A7
; Referenced by: Sub_13BA
         FCB    $00               ; NUL
         FCB    $07               ; BEL
         FCB    $1F               ; $1F
         FCB    $21               ; '!'
         FCB    $1F               ; $1F
         FCB    $23               ; '#'
         FCB    $1F               ; $1F
         FCB    $25               ; '%'
         FCB    $0C               ; FF clear+home
         FCB    $00               ; NUL
         FCB    $12               ; $12

Dat_03B2
; Referenced by: $16E3
         FCB    ESC,W.OWSet      ; Overlay Window Set
         FCB    $01               ; SVS=save+restore
         FCB    $00,$00,$50,$17  ; CPX=0 CPY=0 SZX=80 SZY=23
         FCB    $01,$01          ; PRN1=1 PRN2=1
         FCB    ESC,W.OWSet      ; Overlay Window Set
         FCB    $01               ; SVS=save+restore
         FCB    $02,$01,$4C,$15  ; CPX=2 CPY=1 SZX=76 SZY=21
         FCB    $06,$00          ; PRN1=6 PRN2=0

Dat_03C4
; Referenced by: $1158, Sub_116B
         FCB    $00               ; NUL
         FCB    $04               ; EOT

Dat_03C6
; Referenced by: $173F
         FCB    ESC,W.OWEnd      ; Overlay Window End
         FCB    ESC,W.OWEnd      ; Overlay Window End

Dat_03CA
; Referenced by: $1D5A, $1E79
         FCB    BS,BS,BS,BS,BS,BS  ; BS×6
         FCB    BS,BS,BS,BS,BS,BS  ; BS×6

Dat_03D6
; Referenced by: $0EDF, $16CD
         FCB    $00               ; NUL
         FCB    $0E               ; SO cursor-right
         FCB    $1F               ; $1F
         FCB    $21               ; '!'
         FCB    $1F               ; $1F
         FCB    $23               ; '#'
         FCB    $1F               ; $1F
         FCB    $25               ; '%'
         FCB    ESC,W.FColor,$07         ; Foreground Color palette[7]
         FCB    ESC,W.Bcolor,$00         ; Background Color palette[0]
         FCB    $05               ; $05
         FCB    $21               ; '!'

Dat_03E6
; Referenced by: $0EAD
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    CurXY,$1F,$22     ; CurXY(row=-1,col=2)
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    CurXY,$1F,$24     ; CurXY(row=-1,col=4)
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    NUL  ; NUL×1
         FCB    CurXY,$1F,$20     ; CurXY(row=-1,col=0)
         FCB    $00               ; NUL

Dat_040E
; Referenced by: $0EC2
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$00         ; Foreground Color palette[0]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$01         ; Foreground Color palette[1]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$02         ; Foreground Color palette[2]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$03         ; Foreground Color palette[3]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$04         ; Foreground Color palette[4]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$05         ; Foreground Color palette[5]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$06         ; Foreground Color palette[6]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.FColor,$07         ; Foreground Color palette[7]

Dat_0436
; Referenced by: $0ED7
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$00         ; Background Color palette[0]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$01         ; Background Color palette[1]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$02         ; Background Color palette[2]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$03         ; Background Color palette[3]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$04         ; Background Color palette[4]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$05         ; Background Color palette[5]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$06         ; Background Color palette[6]
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    ESC,W.Bcolor,$07         ; Background Color palette[7]

Dat_045E
; Referenced by: $0BAD, $0C27, Sub_10F7, $374E
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $0C               ; FF clear+home

Dat_0461
; Referenced by: $1104
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $04               ; EOT

Dat_0464
; Referenced by: $10EE
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $0B               ; VT cursor-up

Dat_0467
; Referenced by: Sub_1AE8, $2657
         FCB    $2F               ; '/'
         FCB    $D7

Dat_0469
; Referenced by: $135E, $1AA0, Sub_2620
         FCB    ESC,W.DWEnd      ; Device Window End
         FCB    ESC,W.DWSet,$02,$00,$01,$50,$17,$07,$02,$02   ; Device Window Set

Dat_0475
; Referenced by: $26F1
         FCB    ESC,W.DWEnd      ; Device Window End

Dat_0477
; Referenced by: $1AF4
         FCB    ESC,W.DWSet,$00,$00,$00,$50,$01,$03,$04,$0C   ; Device Window Set

Dat_0481
; Referenced by: Sub_2B86, $2C3F
         FCB    ESC,W.FColor,$00         ; Foreground Color palette[0]
         FCB    ESC,W.Bcolor,$00         ; Background Color palette[0]
         FCB    $0C               ; FF clear+home
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $20               ; ' '

Dat_048B
; Referenced by: $0C11, $115F, $1175, $1849, $196E, $1A0F, $1B41, $1DAF, Sub_1ED3, $20D2, $2332, $2A54, $2EB3, $2F85, Sub_30ED, $35B2, $3611, $3989, $4261, $435A, $4453
         FCB    $00               ; NUL
         FCB    CurXY,$05,$21     ; CurXY(row=-27,col=1)

Dat_048F
; Referenced by: $0BB4, $1125, $17AB, $18CD, $199F, $1B36, $1D31, $1E52, $1F1F, $2320, $2915, Sub_2A78, $2EA3, $2F6F, $303A, Sub_3580, Sub_35DF, $3716, $37B0, $3977, $3F2E, $4244, $4348
         FCB    $00               ; NUL
         FCB    CurXY,$05,$20     ; CurXY(row=-27,col=0)

Dat_0493
; Referenced by: $2851
         FCB    $1F               ; $1F
         FCC    "  "
         FCB    $1F               ; $1F
         FCB    $21               ; '!'
         FCB    $08               ; BS

Dat_0499
; Referenced by: $1B30
         FCB    $00               ; NUL
         FCB    $16               ; SYN insert-line
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    " Are you sure? (y/N)"

Dat_04B1
; Referenced by: $3401
         FCB    $00               ; NUL
         FCB    $28               ; '('
         FCB    CurXY,$2E,$23     ; CurXY(row=14,col=3)
         FCC    "Count  "
         FCB    CurXY,$2E,$25     ; CurXY(row=14,col=5)
         FCC    "Seconds "
         FCB    CurXY,$2D,$27     ; CurXY(row=13,col=7)
         FCC    "<Space> aborts"
         FCB    $05               ; $05
         FCB    $20               ; ' '

Dat_04DB
; Referenced by: $340B
         FCB    $00               ; NUL
         FCB    $08               ; BS
         FCC    "Dialing "

Dat_04E5
; Referenced by: $3415, $34E0
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    CurXY,$37,$23     ; CurXY(row=23,col=3)

Dat_04EA
; Referenced by: $34C9
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    CurXY,$37,$25     ; CurXY(row=23,col=5)

Dat_04EF
; Referenced by: $36F7, $3755
         FCB    $00               ; NUL
         FCC    "      Xmodem file transfer system"

Dat_0511
; Referenced by: $3703, $3761
         FCB    $00               ; NUL
         FCB    $09               ; HT
         FCB    CurXY,$20,$20     ; CurXY(row=0,col=0)
         FCC    "     Y"

Dat_051C
; Referenced by: $22C4, $425A
         FCB    $00               ; NUL
         FCB    $11               ; DC1/XON
         FCB    CurXY,$2B,$26     ; CurXY(row=11,col=6)
         FCC    "<Break> aborts"

Dat_052F
; Referenced by: Sub_370A, $37DB, $3F78
         FCB    $00               ; NUL
         FCB    $11               ; DC1/XON
         FCB    CurXY,$2A,$28     ; CurXY(row=10,col=8)
         FCC    "<Break> aborts"
         FCB    $00               ; NUL
         FCB    $1B               ; ESC windowing cmd
         FCB    CurXY,$25,$22     ; CurXY(row=5,col=2)
         FCC    "ASCII Processing? (Y/N) "

Dat_055F
; Referenced by: Sub_1887, $2A88, Sub_371F, $42C3, $445A
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCC    "File: "
         FCB    $04               ; EOT

Dat_056B
; Referenced by: $28F9, $379C
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$21,$22     ; CurXY(row=1,col=2)
         FCC    "Recv: "
         FCB    $04               ; EOT

Dat_0577
; Referenced by: Sub_2944, $2CB9
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$21,$23     ; CurXY(row=1,col=3)
         FCC    "Size: "
         FCB    $04               ; EOT

Dat_0583
; Referenced by: Sub_3F1A
         FCB    $00               ; NUL
         FCB    $0E               ; SO cursor-right
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCB    $04               ; EOT
         FCB    CurXY,$21,$22     ; CurXY(row=1,col=2)
         FCC    "Send: "
         FCB    $04               ; EOT

Dat_0593
; Referenced by: $37CD, Sub_3F71
         FCB    $00               ; NUL
         FCB    $22               ; '"'
         FCB    CurXY,$21,$25     ; CurXY(row=1,col=5)
         FCC    "Block #                 Error #"

Dat_05B7
; Referenced by: $37D4
         FCB    $00               ; NUL
         FCB    $0E               ; SO cursor-right
         FCB    CurXY,$21,$27     ; CurXY(row=1,col=7)
         FCC    "Last Error:"

Dat_05C7
; Referenced by: $380E, $3B9A
         FCC    "                    Transfer Aborted    Wrong Block Number  Block Check "
         FCC    "Failed  Time Out            "

Dat_062B
; Referenced by: $3E85
         FCB    $00               ; NUL
         FCB    $07               ; BEL
         FCB    CurXY,$28,$25     ; CurXY(row=8,col=5)
         FCC    "0000"

Dat_0634
; Referenced by: $3E9D
         FCB    $00               ; NUL
         FCB    $07               ; BEL
         FCB    CurXY,$40,$25     ; CurXY(row=32,col=5)
         FCC    "0000"

Dat_063D
; Referenced by: $1D49
         FCB    $00               ; NUL
         FCB    $13               ; DC3/XOFF
         FCB    $0A               ; LF
         FCB    $0D               ; CR
         FCC    " Baud Rate:      "

Dat_0652
; Referenced by: $11FF, $1D67, $2DAE
         FCC    "110  300  600  1200 2400 4800 9600 19200"
         FCB    $00               ; NUL
         FCB    $06               ; $06
         FCB    ESC,W.CWArea,$01,$02,$04,$09  ; CPX=1 CPY=2 SZX=4 SZY=9

Dat_0682
; Referenced by: $310B
         FCB    BS,BS,BS  ; BS×3
         FCC    "   "

Dat_0688
; Referenced by: $1DEA
         FCB    $0C               ; FF clear+home
         FCB    LF,LF,LF,LF,LF,LF  ; LF×6
         FCB    LF,LF,LF,LF  ; LF×4

Dat_0693
; Referenced by: $1DF3, $3085
         FCC    "==>"

Dat_0696
; Referenced by: $1E6A
         FCB    $00               ; NUL
         FCB    $18               ; CAN erase-BOL
         FCB    $0A               ; LF
         FCB    $0D               ; CR
         FCC    " Terminal Type :      "

Dat_06B0
; Referenced by: $1E86
         FCC    "OS9  ASCIIANSI "

Dat_06BF
; Referenced by: $3B59, $3F9D
         FCB    CurXY,$30,$21     ; CurXY(row=16,col=1)
         FCC    "ASCII"

Dat_06C7
; Referenced by: $3801, $3F35
         FCB    $00               ; NUL
         FCB    $08               ; BS
         FCB    CurXY,$30,$21     ; CurXY(row=16,col=1)
         FCC    "     "

Dat_06D1
; Referenced by: $31D7
         FCS    "ADS"
         FCS    "BPS"
         FCS    "ECH"
         FCS    "HEK"
         FCS    "TRM"
         FCS    "LNF"
         FCS    "XON"
         FCS    "XOF"
         FCS    "RTR"
         FCS    "RPS"
         FCS    "PAR"
         FCS    "CLK"
         FCS    "WRD"
         FCS    "STP"
         FCS    "KM1"
         FCS    "KM2"
         FCS    "KM3"
         FCS    "KM4"
         FCS    "KM5"
         FCS    "KM6"
         FCS    "KM7"
         FCS    "KM8"
         FCS    "CNS"
         FCS    "SS1"
         FCS    "SS2"
         FCS    "SS3"
         FCS    "SS4"
         FCS    "RS1"
         FCS    "RS2"
         FCS    "RS3"
         FCS    "RS4"
         FCS    "RLF"
         FCS    "TLF"

Dat_0734
; Referenced by: $359C
         FCB    $00               ; NUL
         FCC    "o SuperComm File Receive"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCC    "     ASCII R"

Dat_075C
         FCC    "eceive"
         FDB    $0D0A             ; CRLF
         FCC    "     XModem (and X-1k)"
         FDB    $0D0A             ; CRLF
         FCC    "     YModem Batch"
         FDB    $0D0A             ; CRLF
         FCC    "     ZModem (external)"

Dat_07A5
; Referenced by: $35FB
         FCB    $00               ; NUL
         FCC    "{   SuperComm File Send"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCC    "     ASCII Send"
         FDB    $0D0A             ; CRLF
         FCC    "     XModem (and CRC)"
         FDB    $0D0A             ; CRLF
         FCC    "     Xmodem 1K"
         FDB    $0D0A             ; CRLF
         FCC    "     YModem Batch"
         FDB    $0D0A             ; CRLF
         FCC    "     ZModem (external)"

Dat_0821
; Referenced by: $1F37
         FCB    $00               ; NUL
         FCB    $93
         FCC    "  SuperComm Options"
         FCB    ESC,W.CWArea,$05,$02,$0E,$0C  ; CPX=5 CPY=2 SZX=14 SZY=12
         FCC    "Echo"
         FDB    $0D0A             ; CRLF
         FCC    "L-Feeds Rx"
         FDB    $0D0A             ; CRLF
         FCC    "L-Feeds Tx"
         FDB    $0D0A             ; CRLF
         FCC    "Click"
         FDB    $0D0A             ; CRLF
         FCC    "Word Length"
         FDB    $0D0A             ; CRLF
         FCC    "Parity"
         FDB    $0D0A             ; CRLF
         FCC    "Stop Bits"
         FDB    $0D0A             ; CRLF
         FCC    "Echo (host)"
         FDB    $0D0A             ; CRLF
         FCC    "Hang Up"
         FDB    $0D0A             ; CRLF
         FCC    "Auto Zmodem"
         FDB    $0D0A             ; CRLF
         FCC    "Auto Ascii"
         FDB    $0D0A             ; CRLF
         FCB    ESC,W.CWArea,$00,$00,$16,$0E  ; CPX=0 CPY=0 SZX=22 SZY=14

Dat_08B6
; Referenced by: $2EAA
         FCB    $00               ; NUL
         FCB    $17               ; ETB delete-line
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    " Saving  SuperComm..."

Dat_08CF
; Referenced by: $4253
         FCB    $00               ; NUL
         FCB    $17               ; ETB delete-line
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$29,$20     ; CurXY(row=9,col=0)
         FCC    "File Capture System"

Dat_08E8
; Referenced by: $4283
         FCB    $00               ; NUL


; & and quote chars — emitted as FCB to avoid FCC string embedding issues
         FCB    $26
         FCB    $22
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCC    "is already open.  Close it? (Y/n) "

Dat_0910
; Referenced by: Sub_444C
         FCB    $00               ; NUL
         FCB    $13               ; DC3/XOFF
         FCB    CurXY,$2B,$22     ; CurXY(row=11,col=2)
         FCB    $03               ; ETX
         FCC    "Send ASCII file"

Dat_0925
; Referenced by: $426D
         FCB    $00               ; NUL
         FCB    $04               ; EOT
         FCB    CurXY,$21,$22     ; CurXY(row=1,col=2)
         FCB    $22               ; '"'

Dat_092B
; Referenced by: $42FE
         FCB    $00               ; NUL
         FCB    $33               ; '3'
         FCB    CurXY,$29,$20     ; CurXY(row=9,col=0)
         FCC    "File already exists!"
         FCB    CurXY,$26,$22     ; CurXY(row=6,col=2)
         FCC    "<A>ppend or <O>verwrite? "

Dat_0960
; Referenced by: Sub_23AA
         FCB    $00               ; NUL
         FCB    $0B               ; VT cursor-up
         FCB    CurXY,$6E,$20     ; CurXY(row=78,col=0)
         FCB    $1F               ; $1F
         FCB    $24               ; '$'
         FCB    ESC,W.FColor,$03         ; Foreground Color palette[3]
         FCB    $42               ; 'B'
         FCB    $1F               ; $1F
         FCB    $25               ; '%'

Dat_096D
; Referenced by: $2385
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$6E,$20     ; CurXY(row=78,col=0)
         FCB    ESC,W.FColor,$00         ; Foreground Color palette[0]
         FCB    $42               ; 'B'
         FCB    ESC,W.FColor,$03         ; Foreground Color palette[3]

Dat_0979
; Referenced by: $2166
         FCB    $00               ; NUL
         FCB    $04               ; EOT
         FCC    "DTR"
         FCB    $04               ; EOT

Dat_097F
; Referenced by: Sub_216D
         FCB    $00               ; NUL
         FCB    $04               ; EOT

Dat_0981
; Referenced by: Sub_19E7
         FCC    "+++"
         FCB    $04               ; EOT

Dat_0985
; Referenced by: Sub_20E9
         FCB    $00               ; NUL
         FCB    $04               ; EOT
         FCC    "Off"
         FCB    $04               ; EOT

Dat_098B
; Referenced by: Sub_20F2
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCC    "On"
         FCB    $04               ; EOT

Dat_0990
; Referenced by: $2186
         FCB    $20               ; ' '

Dat_0991
; Referenced by: $1257
         FCC    "Mark"

Dat_0995
; Referenced by: $1261, $2190
         FCC    "Space"

Dat_099A
; Referenced by: $219A
         FCB    $20               ; ' '

Dat_099B
; Referenced by: $126B
         FCC    "Even"

Dat_099F
; Referenced by: $21A4
         FCB    $20               ; ' '

Dat_09A0
; Referenced by: $1275
         FCC    "Odd "

Dat_09A4
; Referenced by: Sub_21AA
         FCB    $20               ; ' '

Dat_09A5
; Referenced by: Sub_127B
         FCC    "None"

Dat_09A9
; Referenced by: $22DF
         FCB    $00               ; NUL
         FCB    $36               ; '6'
         FCB    CurXY,$28,$20     ; CurXY(row=8,col=0)
         FCC    "Change Data Directory"
         FCB    CurXY,$29,$25     ; CurXY(row=9,col=5)
         FCC    "(use full pathname)"
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCC    "Path:"

Dat_09E1
; Referenced by: $272D
         FCB    CurXY,$20,$20     ; CurXY(row=0,col=0)
         FCC    "    "

Dat_09E8
; Referenced by: $26DE, $2BB5
         FCB    CurXY,$20,$20     ; CurXY(row=0,col=0)
         FCC    "Conf"

Dat_09EF
; Referenced by: $26D0, $2C1D, $2C66
         FCB    ESC,W.CWArea,$00,$01,$50,$02  ; CPX=0 CPY=1 SZX=80 SZY=2

Dat_09F5
; Referenced by: $29A3, $2C9A
         FCB    $00               ; NUL
         FCB    $0F               ; SI cursor-left
         FCC    "B@"
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $86
         FCB    $A0
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    $27               ; '''
         FCB    $10               ; $10
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    $03               ; ETX

Dat_0A04
         FCB    $E8
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $64               ; 'd'
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $0A               ; LF
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $01               ; SOH
         FCB    NUL,NUL,NUL,NUL  ; NUL×4

Dat_0A15
         FCB    $0E               ; SO cursor-right

Dat_0A16
; Referenced by: $1147
         FCC    "ABCDHIMOQRSTUZ"

Dat_0A24
; Referenced by: $0AFB, $2E85
         FCB    $04               ; EOT
         FCB    $01               ; SOH
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    NUL  ; NUL×1
         FCB    $01               ; SOH
         FCB    $11               ; DC1/XON
         FCB    $13               ; DC3/XOFF
         FCB    $00               ; NUL

Dat_0A31
; Referenced by: $2F09, $3165
         FCS    "/dd/sys/dial"
         FCC    "                    "

Dat_0A51
; Referenced by: $0B0A
         FCC    "/dd"
         FCB    $0D               ; CR
         FCC    "                            "

; ==============================================================
; Code section  $0A71—$45C1  (15185 bytes)
; ==============================================================

$0A71  AF C4               Init:          STX ,U                
$0A73  30 88 C0                           LEAX -64,X            
$0A76  AF 42                              STX BSS.ParamStr,U    
$0A78  32 7F                              LEAS -1,S             
$0A7A  30 C9 16 B9                        LEAX 5817,U           
$0A7E  AF 44                              STX BSS.ParamBase,U   
$0A80  AF 46                              STX BSS.RxBufPtr,U    
$0A82  30 1F                              LEAX -1,X             
$0A84  AF 4B                              STX BSS.Var000B,U     
$0A86  30 C9 14 B9                        LEAX 5305,U           
$0A8A  AF 4D                              STX 13,U              
$0A8C  AF 4F                              STX 15,U              
$0A8E  CC 00 00                           LDD #$0000            
$0A91  ED 49                              STD 9,U               
$0A93  30 C8 19                           LEAX 25,U             
$0A96  6F 80               Sub_0A96:      CLR ,X+               
$0A98  AC 42                              CMPX BSS.ParamStr,U   
$0A9A  25 FA                              BCS Sub_0A96           ; C=1 (BLO)
$0A9C  AE C4                              LDX ,U                
$0A9E  86 20                              LDA #$20               ; A = ' '
$0AA0  A7 1F                              STA -1,X              
$0AA2  A6 80               Sub_0AA2:      LDA ,X+               
$0AA4  81 0D                              CMPA #$0D              ; compare A with CR
$0AA6  27 0E                              BEQ Sub_0AB6          
$0AA8  81 2F                              CMPA #$2F              ; compare A with '/'
$0AAA  26 F6                              BNE Sub_0AA2          
$0AAC  A6 1E                              LDA -2,X              
$0AAE  81 20                              CMPA #$20              ; compare A with ' '
$0AB0  26 F0                              BNE Sub_0AA2          
$0AB2  30 1F                              LEAX -1,X             
$0AB4  20 04                              BRA Sub_0ABA          

; --------------------------------------------------------------
$0AB6  30 8D F8 A0         Sub_0AB6:      LEAX Dat_035A,PC       ; X → Dat_035A
$0ABA  31 C8 2D            Sub_0ABA:      LEAY BSS.Counter1,U   
$0ABD  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$0ABF  A6 80               Sub_0ABF:      LDA ,X+               
$0AC1  81 0D                              CMPA #$0D              ; compare A with CR
$0AC3  27 05                              BEQ Sub_0ACA          
$0AC5  A7 A0                              STA ,Y+               
$0AC7  5A                                 DECB                  
$0AC8  26 F5                              BNE Sub_0ABF          
$0ACA  A7 A0               Sub_0ACA:      STA ,Y+               
$0ACC  17 08 26                           LBSR Sub_12F5          ; call Sub_12F5
$0ACF  10 25 04 42                        LBCS Sub_0F15         
$0AD3  17 0F B4                           LBSR Sub_1A8A          ; call Sub_1A8A
$0AD6  10 25 04 3B                        LBCS Sub_0F15         
$0ADA  86 01                              LDA #$01              
$0ADC  A7 C8 65                           STA BSS.BufPtr3,U     
$0ADF  8E 00 01                           LDX #$0001            
$0AE2  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$0AE5  86 01                              LDA #$01              
$0AE7  C6 92                              LDB #$92              
$0AE9  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0AEC  25 2F                              BCS Sub_0B1D           ; C=1 (BLO)
$0AEE  1F 10                              TFR X,D               
$0AF0  E7 C9 0C 84                        STB 3204,U            
$0AF4  AA C9 0C 84                        ORA 3204,U            
$0AF8  A7 C8 65                           STA BSS.BufPtr3,U     
$0AFB  30 8D FF 25                        LEAX Dat_0A24,PC       ; X → Dat_0A24
$0AFF  31 C9 0C A5                        LEAY 3237,U           
$0B03  C6 4D                              LDB #$4D               ; B = 'M'
$0B05  17 22 16                           LBSR Sub_2D1E          ; call Sub_2D1E
$0B08  86 03                              LDA #$03              
$0B0A  30 8D FF 43                        LEAX Dat_0A51,PC       ; X → Dat_0A51
$0B0E  10 3F 86                           OS9 I$ChgDir           ; mode=B  name→X
$0B11  30 8D F8 51                        LEAX Dat_0366,PC       ; X → Dat_0366
$0B15  31 C8 77                           LEAY 119,U            
$0B18  C6 0B                              LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
$0B1A  17 22 01                           LBSR Sub_2D1E          ; call Sub_2D1E
$0B1D  17 10 BF            Sub_0B1D:      LBSR Sub_1BDF          ; call Sub_1BDF
$0B20  17 11 34                           LBSR Sub_1C57          ; call Sub_1C57
$0B23  17 10 A1                           LBSR Sub_1BC7          ; call Sub_1BC7
$0B26  30 8D 03 EE                        LEAX Dat_0F18,PC       ; X → Dat_0F18
$0B2A  10 3F 09                           OS9 F$Icpt             ; handler→X  data→U
$0B2D  30 C9 00 DF                        LEAX 223,U            
$0B31  CC 00 00                           LDD #$0000            
$0B34  ED 84                              STD ,X                
$0B36  ED 02                              STD 2,X               
$0B38  ED 04                              STD 4,X               
$0B3A  E7 06                              STB 6,X               
$0B3C  1F 10                              TFR X,D               
$0B3E  8E 00 7C                           LDX #$007C            
$0B41  10 8E 00 01                        LDY #$0001            
$0B45  34 40                              PSHS U                
$0B47  33 C8 19                           LEAU 25,U             
$0B4A  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$0B4D  35 40                              PULS U                
$0B4F  30 8D F8 0D                        LEAX Dat_0360,PC       ; X → Dat_0360
$0B53  86 03                              LDA #$03              
$0B55  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$0B58  25 38                              BCS Sub_0B92           ; C=1 (BLO)
$0B5A  A7 C8 72                           STA 114,U             
$0B5D  C6 81                              LDB #$81              
$0B5F  10 8E 00 01                        LDY #$0001            
$0B63  8E 00 3C                           LDX #$003C            
$0B66  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$0B69  25 1E                              BCS Sub_0B89           ; C=1 (BLO)
$0B6B  A6 C8 72                           LDA 114,U             
$0B6E  10 8E 08 00                        LDY #$0800            
$0B72  8E 08 00                           LDX #$0800            
$0B75  C6 80                              LDB #$80              
$0B77  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0B7A  25 0D                              BCS Sub_0B89           ; C=1 (BLO)
$0B7C  8C 08 00                           CMPX #$0800           
$0B7F  24 08                              BCC Sub_0B89           ; C=0 (BHS)
$0B81  10 8C 08 00                        CMPY #$0800           
$0B85  24 02                              BCC Sub_0B89           ; C=0 (BHS)
$0B87  20 09                              BRA Sub_0B92          

; --------------------------------------------------------------
$0B89  A6 C8 72            Sub_0B89:      LDA 114,U             
$0B8C  10 3F 8F            Insn_0B8C:     OS9 I$Close            ; path=A
$0B8D  3F                  Sub_0B8D:      EQU    $0B8D            ; mid-instruction overlap: Insn_0B8C+1 -- mid-instruction entry point -- byte 2 of OS9 I$Close ($10 3F 8F) at $0B8C
$0B8F  6F C8 72                           CLR 114,U             
$0B92  30 C9 05 0F         Sub_0B92:      LEAX 1295,U           
$0B96  AF C8 66                           STX 102,U             
$0B99  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$0B9B  E7 C9 0D 19                        STB 3353,U            
$0B9F  4F                                 CLRA                   ; A = 0
$0BA0  C6 14                              LDB #$14              
$0BA2  A7 C9 0D 1A                        STA 3354,U            
$0BA6  CC 1B 32                           LDD #$1B32             ; D=ESC+'2'  → W.FColor: Foreground Color
$0BA9  ED C9 00 9C                        STD 156,U             
$0BAD  30 8D F8 AD                        LEAX Dat_045E,PC       ; X → Dat_045E
$0BB1  17 0F 4F                           LBSR WriteBlock        ; call WriteBlock
$0BB4  30 8D F8 D7                        LEAX Dat_048F,PC       ; X → Dat_048F
$0BB8  17 0F 48                           LBSR WriteBlock        ; call WriteBlock
$0BBB  CC 1A 04                           LDD #$1A04            
$0BBE  ED C9 0C 8F                        STD 3215,U            
$0BC2  CC 16 09                           LDD #$1609            
$0BC5  ED C9 0C 91                        STD 3217,U            
$0BC9  17 10 B5                           LBSR Sub_1C81          ; call Sub_1C81
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                           LBSR WriteBlock        ; call WriteBlock
$0BD3  17 0F 12                           LBSR Sub_1AE8          ; call Sub_1AE8
$0BD6  8E 00 1C                           LDX #$001C            
$0BD9  17 03 7A                           LBSR Sub_0F56          ; call Sub_0F56
$0BDC  CC 32 10                           LDD #$3210            
$0BDF  ED C9 0C 8F                        STD 3215,U            
$0BE3  CC 13 04                           LDD #$1304            
$0BE6  ED C9 0C 91                        STD 3217,U            
$0BEA  17 10 94                           LBSR Sub_1C81          ; call Sub_1C81
$0BED  30 8D F4 D5                        LEAX Dat_00C6,PC       ; X → Dat_00C6
$0BF1  17 0F 0F                           LBSR WriteBlock        ; call WriteBlock
$0BF4  17 2F C5                           LBSR Sub_3BBC          ; call Sub_3BBC
$0BF7  4F                  Sub_0BF7:      CLRA                   ; A = 0
$0BF8  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$0BFA  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0BFD  24 09                              BCC Sub_0C08           ; C=0 (BHS)
$0BFF  17 2F D8                           LBSR Sub_3BDA          ; call Sub_3BDA
$0C02  81 0A                              CMPA #$0A              ; compare A with LF
$0C04  25 F1                              BCS Sub_0BF7           ; C=1 (BLO)
$0C06  20 03                              BRA Sub_0C0B          

; --------------------------------------------------------------
$0C08  17 1E BA            Sub_0C08:      LBSR Sub_2AC5          ; call Sub_2AC5
$0C0B  17 10 D0            Sub_0C0B:      LBSR Sub_1CDE          ; call Sub_1CDE
$0C0E  17 10 CD                           LBSR Sub_1CDE          ; call Sub_1CDE
$0C11  30 8D F8 76                        LEAX Dat_048B,PC       ; X → Dat_048B
$0C15  17 0E EB                           LBSR WriteBlock        ; call WriteBlock
$0C18  86 03                              LDA #$03              
$0C1A  30 C8 2D                           LEAX BSS.Counter1,U   
$0C1D  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$0C20  10 25 02 F1                        LBCS Sub_0F15         
$0C24  A7 C8 2B                           STA 43,U              
$0C27  30 8D F8 33                        LEAX Dat_045E,PC       ; X → Dat_045E
$0C2B  17 0E D5                           LBSR WriteBlock        ; call WriteBlock
$0C2E  17 05 4E                           LBSR Sub_117F          ; call Sub_117F
$0C31  17 1F 52                           LBSR Sub_2B86          ; call Sub_2B86
$0C34  17 37 CC                           LBSR Sub_4403          ; call Sub_4403
$0C37  CC 01 03                           LDD #$0103            
$0C3A  ED C9 0C 94                        STD 3220,U            
$0C3E  17 1E B4                           LBSR Sub_2AF5          ; call Sub_2AF5
$0C41  17 07 09                           LBSR Sub_134D          ; call Sub_134D
$0C44  17 06 6E                           LBSR Sub_12B5          ; call Sub_12B5
$0C47  86 00                              LDA #$00               ; A = NUL
$0C49  30 8D F6 CD                        LEAX Dat_031A,PC       ; X → Dat_031A
$0C4D  AF C8 6C                           STX 108,U             
$0C50  30 C9 06 0E                        LEAX 1550,U           
$0C54  10 8E 00 01                        LDY #$0001            
$0C58  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$0C5B  16 09 1D                           LBRA Sub_157B         

; --------------------------------------------------------------
$0C5E  17 07 65            Sub_0C5E:      LBSR Sub_13C6          ; call Sub_13C6
$0C61  10 24 03 53                        LBCC Sub_0FB8         
$0C65  6D C8 23                           TST 35,U              
$0C68  10 26 38 4A                        LBNE Sub_44B6         
$0C6C  8E 00 03                           LDX #$0003            
$0C6F  17 02 E4                           LBSR Sub_0F56          ; call Sub_0F56
$0C72  17 07 4D            Sub_0C72:      LBSR Sub_13C2          ; call Sub_13C2
$0C75  25 E7                              BCS Sub_0C5E           ; C=1 (BLO)
$0C77  6D C8 40                           TST 64,U              
$0C7A  10 26 1A BF                        LBNE Sub_273D         
$0C7E  16 08 ED                           LBRA Sub_156E         

; --------------------------------------------------------------
$0C81  30 C9 00 DF         Sub_0C81:      LEAX 223,U            
$0C85  31 C9 07 0D                        LEAY 1805,U           
$0C89  E6 C9 0C 89                        LDB 3209,U            
$0C8D  A6 80               Sub_0C8D:      LDA ,X+               
$0C8F  84 7F                              ANDA #$7F             
$0C91  81 20                              CMPA #$20              ; compare A with ' '
$0C93  25 0D                              BCS Sub_0CA2           ; C=1 (BLO)
$0C95  81 7F                              CMPA #$7F             
$0C97  22 09                              BHI Sub_0CA2          
$0C99  17 07 33                           LBSR Sub_13CF          ; call Sub_13CF
$0C9C  A7 A0               Sub_0C9C:      STA ,Y+               
$0C9E  5A                  Sub_0C9E:      DECB                  
$0C9F  26 EC                              BNE Sub_0C8D          
$0CA1  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0CA2  81 08               Sub_0CA2:      CMPA #$08              ; compare A with BS
$0CA4  26 05                              BNE Sub_0CAB          
$0CA6  17 07 43                           LBSR Sub_13EC          ; call Sub_13EC
$0CA9  20 F1                              BRA Sub_0C9C          

; --------------------------------------------------------------
$0CAB  81 0D               Sub_0CAB:      CMPA #$0D              ; compare A with CR
$0CAD  26 16                              BNE Sub_0CC5          
$0CAF  17 07 53                           LBSR Sub_1405          ; call Sub_1405
$0CB2  6D C9 0C A8                        TST 3240,U            
$0CB6  27 E4                              BEQ Sub_0C9C          
$0CB8  17 07 53                           LBSR Sub_140E          ; call Sub_140E
$0CBB  6C C9 0C 89                        INC 3209,U            
$0CBF  A7 A0                              STA ,Y+               
$0CC1  86 0A                              LDA #$0A               ; A = LF
$0CC3  20 D7                              BRA Sub_0C9C          

; --------------------------------------------------------------
$0CC5  81 0C               Sub_0CC5:      CMPA #$0C              ; compare A with FF
$0CC7  26 05                              BNE Sub_0CCE          
$0CC9  17 07 56                           LBSR Sub_1422          ; call Sub_1422
$0CCC  20 CE                              BRA Sub_0C9C          

; --------------------------------------------------------------
$0CCE  81 07               Sub_0CCE:      CMPA #$07             
$0CD0  27 CA                              BEQ Sub_0C9C          
$0CD2  81 0A                              CMPA #$0A              ; compare A with LF
$0CD4  26 05                              BNE Sub_0CDB          
$0CD6  17 07 35                           LBSR Sub_140E          ; call Sub_140E
$0CD9  20 C1                              BRA Sub_0C9C          

; --------------------------------------------------------------
$0CDB  81 09               Sub_0CDB:      CMPA #$09             
$0CDD  26 05                              BNE Sub_0CE4          
$0CDF  17 0E FC                           LBSR Sub_1BDE          ; call Sub_1BDE
$0CE2  20 BA                              BRA Sub_0C9E          

; --------------------------------------------------------------
$0CE4  6A C9 0C 89         Sub_0CE4:      DEC 3209,U            
$0CE8  20 B4                              BRA Sub_0C9E          

; --------------------------------------------------------------
$0CEA  30 C9 00 DF         Sub_0CEA:      LEAX 223,U            
$0CEE  31 C9 07 0D                        LEAY 1805,U           
$0CF2  E6 C9 0C 89                        LDB 3209,U            
$0CF6  6D C9 0C 8A         Sub_0CF6:      TST 3210,U            
$0CFA  10 26 00 A1                        LBNE Sub_0D9F         
$0CFE  A6 80                              LDA ,X+               
$0D00  81 20                              CMPA #$20              ; compare A with ' '
$0D02  25 0F                              BCS Sub_0D13           ; C=1 (BLO)
$0D04  81 80                              CMPA #$80             
$0D06  25 02                              BCS Sub_0D0A           ; C=1 (BLO)
$0D08  86 2A                              LDA #$2A               ; A = '*'
$0D0A  17 06 C2            Sub_0D0A:      LBSR Sub_13CF          ; call Sub_13CF
$0D0D  A7 A0               Sub_0D0D:      STA ,Y+               
$0D0F  5A                  Sub_0D0F:      DECB                  
$0D10  26 E4                              BNE Sub_0CF6          
$0D12  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0D13  81 08               Sub_0D13:      CMPA #$08              ; compare A with BS
$0D15  27 1A                              BEQ Sub_0D31          
$0D17  81 0D                              CMPA #$0D              ; compare A with CR
$0D19  27 27                              BEQ Sub_0D42          
$0D1B  81 0A                              CMPA #$0A              ; compare A with LF
$0D1D  27 39                              BEQ Sub_0D58          
$0D1F  81 0C                              CMPA #$0C              ; compare A with FF
$0D21  27 3A                              BEQ Sub_0D5D          
$0D23  81 07                              CMPA #$07             
$0D25  27 E3                              BEQ Sub_0D0A          
$0D27  81 1B                              CMPA #$1B              ; compare A with ESC
$0D29  27 37                              BEQ Sub_0D62          
$0D2B  6A C9 0C 89         Sub_0D2B:      DEC 3209,U            
$0D2F  20 DE                              BRA Sub_0D0F          

; --------------------------------------------------------------
$0D31  34 02               Sub_0D31:      PSHS A                
$0D33  A6 C9 0C 94                        LDA 3220,U            
$0D37  81 01                              CMPA #$01             
$0D39  35 02                              PULS A                
$0D3B  27 EE                              BEQ Sub_0D2B          
$0D3D  17 06 AC                           LBSR Sub_13EC          ; call Sub_13EC
$0D40  20 CB                              BRA Sub_0D0D          

; --------------------------------------------------------------
$0D42  17 06 C0            Sub_0D42:      LBSR Sub_1405          ; call Sub_1405
$0D45  6D C9 0C A8                        TST 3240,U            
$0D49  27 C2                              BEQ Sub_0D0D          
$0D4B  17 06 C0                           LBSR Sub_140E          ; call Sub_140E
$0D4E  6C C9 0C 89                        INC 3209,U            
$0D52  A7 A0                              STA ,Y+               
$0D54  86 0A                              LDA #$0A               ; A = LF
$0D56  20 B5                              BRA Sub_0D0D          

; --------------------------------------------------------------
$0D58  17 06 B3            Sub_0D58:      LBSR Sub_140E          ; call Sub_140E
$0D5B  20 B0                              BRA Sub_0D0D          

; --------------------------------------------------------------
$0D5D  17 06 C2            Sub_0D5D:      LBSR Sub_1422          ; call Sub_1422
$0D60  20 AB                              BRA Sub_0D0D          

; --------------------------------------------------------------
$0D62  6C C9 0C 8A         Sub_0D62:      INC 3210,U            
$0D66  6F C9 0C 8B                        CLR 3211,U            
$0D6A  86 FF                              LDA #$FF              
$0D6C  A7 C9 0C 60                        STA 3168,U            
$0D70  34 20                              PSHS Y                
$0D72  31 C9 0C 60                        LEAY 3168,U           
$0D76  10 AF C9 0C 80                     STY 3200,U            
$0D7B  6F C9 0C 60                        CLR 3168,U            
$0D7F  6F C9 0C 61                        CLR 3169,U            
$0D83  A7 C9 0C 62                        STA 3170,U            
$0D87  35 20                              PULS Y                
$0D89  8D 07                              BSR Sub_0D92           ; call Sub_0D92
$0D8B  6A C9 0C 89                        DEC 3209,U            
$0D8F  16 FF 7D                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$0D92  34 20               Sub_0D92:      PSHS Y                
$0D94  31 C9 0B 0D                        LEAY 2829,U           
$0D98  10 AF C9 0C 8D                     STY 3213,U            
$0D9D  35 A0                              PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$0D9F  34 20               Sub_0D9F:      PSHS Y                
$0DA1  10 AE C9 0C 8D                     LDY 3213,U            
$0DA6  A6 80                              LDA ,X+               
$0DA8  A7 A0                              STA ,Y+               
$0DAA  10 AF C9 0C 8D                     STY 3213,U            
$0DAF  35 20                              PULS Y                
$0DB1  81 5B                              CMPA #$5B              ; compare A with '['
$0DB3  27 04                              BEQ Sub_0DB9          
$0DB5  81 40                              CMPA #$40              ; compare A with '@'
$0DB7  22 07                              BHI Sub_0DC0          
$0DB9  6A C9 0C 89         Sub_0DB9:      DEC 3209,U            
$0DBD  16 FF 4F                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$0DC0  6F C9 0C 8A         Sub_0DC0:      CLR 3210,U            
$0DC4  A7 C9 0C 8C                        STA 3212,U            
$0DC8  6A C9 0C 89                        DEC 3209,U            
$0DCC  8D C4                              BSR Sub_0D92           ; call Sub_0D92
$0DCE  34 24                              PSHS B,Y              
$0DD0  10 AE C9 0C 80                     LDY 3200,U            
$0DD5  86 FF                              LDA #$FF              
$0DD7  A7 A4                              STA ,Y                
$0DD9  31 C9 0C 60                        LEAY 3168,U           
$0DDD  10 AF C9 0C 80                     STY 3200,U            
$0DE2  10 AE C9 0C 8D                     LDY 3213,U            
$0DE7  31 21                              LEAY 1,Y              
$0DE9  10 AF C9 0C 8D                     STY 3213,U            
$0DEE  A6 A0               Sub_0DEE:      LDA ,Y+               
$0DF0  81 40                              CMPA #$40              ; compare A with '@'
$0DF2  22 47                              BHI Sub_0E3B          
$0DF4  81 3A                              CMPA #$3A              ; compare A with ':'
$0DF6  25 04                              BCS Sub_0DFC           ; C=1 (BLO)
$0DF8  C6 FE                              LDB #$FE              
$0DFA  20 1D                              BRA Sub_0E19          

; --------------------------------------------------------------
$0DFC  80 30               Sub_0DFC:      SUBA #$30             
$0DFE  A7 C9 0C 84                        STA 3204,U            
$0E02  A6 A0                              LDA ,Y+               
$0E04  81 39                              CMPA #$39              ; compare A with '9'
$0E06  22 2B                              BHI Sub_0E33          
$0E08  80 30                              SUBA #$30             
$0E0A  A7 C9 0C 85                        STA 3205,U            
$0E0E  A6 C9 0C 84                        LDA 3204,U            
$0E12  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$0E14  3D                                 MUL                    ; D = A×B unsigned
$0E15  EB 3F                              ADDB -1,Y             
$0E17  C0 30                              SUBB #$30             
$0E19  34 20               Sub_0E19:      PSHS Y                
$0E1B  10 AE C9 0C 80                     LDY 3200,U            
$0E20  E7 A0                              STB ,Y+               
$0E22  C6 FF                              LDB #$FF              
$0E24  E7 A4                              STB ,Y                
$0E26  E7 21                              STB 1,Y               
$0E28  E7 22                              STB 2,Y               
$0E2A  10 AF C9 0C 80                     STY 3200,U            
$0E2F  35 20                              PULS Y                
$0E31  20 BB                              BRA Sub_0DEE          

; --------------------------------------------------------------
$0E33  31 3F               Sub_0E33:      LEAY -1,Y             
$0E35  E6 C9 0C 84                        LDB 3204,U            
$0E39  20 DE                              BRA Sub_0E19          

; --------------------------------------------------------------
$0E3B  35 24               Sub_0E3B:      PULS B,Y              
$0E3D  A6 C9 0C 8C                        LDA 3212,U            
$0E41  81 6D                              CMPA #$6D              ; compare A with 'm'
$0E43  27 3F                              BEQ Sub_0E84          
$0E45  81 4A                              CMPA #$4A              ; compare A with 'J'
$0E47  10 27 02 97                        LBEQ Sub_10E2         
$0E4B  81 66                              CMPA #$66              ; compare A with 'f'
$0E4D  10 27 06 16                        LBEQ Sub_1467         
$0E51  81 48                              CMPA #$48              ; compare A with 'H'
$0E53  10 27 06 10                        LBEQ Sub_1467         
$0E57  81 43                              CMPA #$43              ; compare A with 'C'
$0E59  10 27 06 53                        LBEQ Sub_14B0         
$0E5D  81 44                              CMPA #$44              ; compare A with 'D'
$0E5F  10 27 06 91                        LBEQ Sub_14F4         
$0E63  81 41                              CMPA #$41              ; compare A with 'A'
$0E65  10 27 06 B4                        LBEQ Sub_151D         
$0E69  81 42                              CMPA #$42              ; compare A with 'B'
$0E6B  10 27 06 D7                        LBEQ Sub_1546         
$0E6F  81 73                              CMPA #$73              ; compare A with 's'
$0E71  10 27 05 BE                        LBEQ Sub_1433         
$0E75  81 75                              CMPA #$75              ; compare A with 'u'
$0E77  10 27 05 C7                        LBEQ Sub_1442         
$0E7B  81 4B                              CMPA #$4B              ; compare A with 'K'
$0E7D  10 27 02 81                        LBEQ Sub_1102         
$0E81  16 FE 8B                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$0E84  34 16               Sub_0E84:      PSHS A,B,X            
$0E86  30 C9 0C 60                        LEAX 3168,U           
$0E8A  A6 80               Sub_0E8A:      LDA ,X+               
$0E8C  81 FF                              CMPA #$FF             
$0E8E  27 16                              BEQ Sub_0EA6          
$0E90  81 00                              CMPA #$00              ; compare A with NUL
$0E92  27 49                              BEQ Sub_0EDD          
$0E94  81 01                              CMPA #$01             
$0E96  27 F2                              BEQ Sub_0E8A          
$0E98  81 08                              CMPA #$08              ; compare A with BS
$0E9A  25 0F                              BCS Sub_0EAB           ; C=1 (BLO)
$0E9C  81 26                              CMPA #$26              ; compare A with '&'
$0E9E  25 13                              BCS Sub_0EB3           ; C=1 (BLO)
$0EA0  81 30                              CMPA #$30              ; compare A with '0'
$0EA2  25 24                              BCS Sub_0EC8           ; C=1 (BLO)
$0EA4  20 E4                              BRA Sub_0E8A          

; --------------------------------------------------------------
$0EA6  35 16               Sub_0EA6:      PULS A,B,X            
$0EA8  16 FE 64                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$0EAB  34 10               Sub_0EAB:      PSHS X                
$0EAD  30 8D F5 35                        LEAX Dat_03E6,PC       ; X → Dat_03E6
$0EB1  20 30                              BRA Sub_0EE3          

; --------------------------------------------------------------
$0EB3  E6 C8 65            Sub_0EB3:      LDB BSS.BufPtr3,U     
$0EB6  C1 02                              CMPB #$02              ; compare B with CurXY
$0EB8  27 D0                              BEQ Sub_0E8A          
$0EBA  81 1E                              CMPA #$1E             
$0EBC  25 CC                              BCS Sub_0E8A           ; C=1 (BLO)
$0EBE  80 1E                              SUBA #$1E             
$0EC0  34 10                              PSHS X                
$0EC2  30 8D F5 48                        LEAX Dat_040E,PC       ; X → Dat_040E
$0EC6  20 1B                              BRA Sub_0EE3          

; --------------------------------------------------------------
$0EC8  E6 C8 65            Sub_0EC8:      LDB BSS.BufPtr3,U     
$0ECB  C1 02                              CMPB #$02              ; compare B with CurXY
$0ECD  27 BB                              BEQ Sub_0E8A          
$0ECF  81 28                              CMPA #$28              ; compare A with '('
$0ED1  25 B7                              BCS Sub_0E8A           ; C=1 (BLO)
$0ED3  80 28                              SUBA #$28             
$0ED5  34 10                              PSHS X                
$0ED7  30 8D F5 5B                        LEAX Dat_0436,PC       ; X → Dat_0436
$0EDB  20 06                              BRA Sub_0EE3          

; --------------------------------------------------------------
$0EDD  34 10               Sub_0EDD:      PSHS X                
$0EDF  30 8D F4 F3                        LEAX Dat_03D6,PC       ; X → Dat_03D6
$0EE3  C6 05               Sub_0EE3:      LDB #$05               ; B = SS.Pos  (GetStt/SetStt subcode)
$0EE5  3D                                 MUL                    ; D = A×B unsigned
$0EE6  30 85                              LEAX B,X              
$0EE8  17 01 E7                           LBSR Sub_10D2          ; call Sub_10D2
$0EEB  35 10                              PULS X                
$0EED  20 9B                              BRA Sub_0E8A          

; --------------------------------------------------------------
$0EEF  A6 C8 3E            Sub_0EEF:      LDA 62,U              
$0EF2  10 3F 8F                           OS9 I$Close            ; path=A
$0EF5  17 04 55                           LBSR Sub_134D          ; call Sub_134D
$0EF8  17 04 61                           LBSR Sub_135C          ; call Sub_135C
$0EFB  17 04 BC                           LBSR Sub_13BA          ; call Sub_13BA
$0EFE  A6 C8 72                           LDA 114,U             
$0F01  27 03                              BEQ Sub_0F06          
$0F03  10 3F 8F                           OS9 I$Close            ; path=A
$0F06  6D C8 25            Sub_0F06:      TST 37,U              
$0F09  27 09                              BEQ Sub_0F14          
$0F0B  17 34 BC                           LBSR Sub_43CA          ; call Sub_43CA
$0F0E  A6 C8 2A                           LDA 42,U              
$0F11  10 3F 8F                           OS9 I$Close            ; path=A
$0F14  5F                  Sub_0F14:      CLRB                   ; B = 0
$0F15  10 3F 06            Sub_0F15:      OS9 F$Exit             ; status=B

Dat_0F18
; Referenced by: $0B26
; 7-byte data block referenced by LEAX at $0B26 — appears after OS9 F$Exit
; ── 7 bytes  ($0F18—$0F1E) ──
         FCB    $C1
         FCB    $80
         FCB    $26
         FCB    $03
         FCB    $6C
         FCB    $C8
         FCB    $73
$0F1F  3B                  Sub_0F1F:      RTI                    ; return from interrupt
$0F20  34 32               Sub_0F20:      PSHS A,X,Y            
$0F22  30 C9 00 9C                        LEAX 156,U            
$0F26  A6 C9 00 88                        LDA 136,U             
$0F2A  A7 02                              STA 2,X               
$0F2C  A6 C8 3E                           LDA 62,U              
$0F2F  10 8E 00 03                        LDY #$0003            
$0F33  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$0F36  30 C8 77                           LEAX 119,U            
$0F39  10 8E 00 0B                        LDY #$000B            
$0F3D  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$0F40  30 C9 00 9C                        LEAX 156,U            
$0F44  A6 C9 00 87                        LDA 135,U             
$0F48  A7 02                              STA 2,X               
$0F4A  A6 C8 3E                           LDA 62,U              
$0F4D  10 8E 00 03                        LDY #$0003            
$0F51  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$0F54  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$0F56  34 02               Sub_0F56:      PSHS A                
$0F58  6D C8 75                           TST 117,U             
$0F5B  27 10                              BEQ Sub_0F6D          
$0F5D  A6 C8 74                           LDA 116,U             
$0F60  A1 C8 73            Sub_0F60:      CMPA 115,U            
$0F63  27 08                              BEQ Sub_0F6D          
$0F65  8D 11                              BSR Sub_0F78           ; call Sub_0F78
$0F67  4C                                 INCA                  
$0F68  A7 C8 74                           STA 116,U             
$0F6B  20 F3                              BRA Sub_0F60          

; --------------------------------------------------------------
$0F6D  35 02               Sub_0F6D:      PULS A                
$0F6F  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$0F72  8C 00 00                           CMPX #$0000           
$0F75  26 DF                              BNE Sub_0F56          
$0F77  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0F78  34 36               Sub_0F78:      PSHS A,B,X,Y          
$0F7A  30 C8 77                           LEAX 119,U            
$0F7D  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$0F7F  8D 0B               Sub_0F7F:      BSR Sub_0F8C           ; call Sub_0F8C
$0F81  4D                                 TSTA                  
$0F82  2A 28                              BPL Sub_0FAC          
$0F84  5A                                 DECB                  
$0F85  5A                                 DECB                  
$0F86  C1 04                              CMPB #$04             
$0F88  25 22                              BCS Sub_0FAC           ; C=1 (BLO)
$0F8A  20 F3                              BRA Sub_0F7F          

; --------------------------------------------------------------
$0F8C  A6 85               Sub_0F8C:      LDA B,X               
$0F8E  81 39                              CMPA #$39              ; compare A with '9'
$0F90  27 04                              BEQ Sub_0F96          
$0F92  4C                                 INCA                  
$0F93  A7 85                              STA B,X               
$0F95  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0F96  86 30               Sub_0F96:      LDA #$30               ; A = '0'
$0F98  A7 85                              STA B,X               
$0F9A  5A                                 DECB                  
$0F9B  A6 85                              LDA B,X               
$0F9D  81 35                              CMPA #$35              ; compare A with '5'
$0F9F  27 04                              BEQ Sub_0FA5          
$0FA1  4C                                 INCA                  
$0FA2  A7 85                              STA B,X               
$0FA4  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0FA5  86 30               Sub_0FA5:      LDA #$30               ; A = '0'
$0FA7  A7 85                              STA B,X               
$0FA9  86 FF                              LDA #$FF              
$0FAB  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0FAC  A6 C8 3E            Sub_0FAC:      LDA 62,U              
$0FAF  10 8E 00 0B                        LDY #$000B            
$0FB3  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$0FB6  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$0FB8  4F                  Sub_0FB8:      CLRA                   ; A = 0
$0FB9  C1 C0                              CMPB #$C0             
$0FBB  25 02                              BCS Sub_0FBF           ; C=1 (BLO)
$0FBD  C6 C0                              LDB #$C0              
$0FBF  1F 02               Sub_0FBF:      TFR D,Y               
$0FC1  A6 C8 2B                           LDA 43,U              
$0FC4  30 C9 00 DF                        LEAX 223,U            
$0FC8  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$0FCB  25 56                              BCS Sub_1023           ; C=1 (BLO)
$0FCD  10 AF C9 0C 88                     STY 3208,U            
$0FD2  10 8C 00 00         Sub_0FD2:      CMPY #$0000           
$0FD6  27 3F                              BEQ Sub_1017          
$0FD8  6D C9 0C AE                        TST 3246,U            
$0FDC  26 03                              BNE Sub_0FE1          
$0FDE  17 00 81                           LBSR Sub_1062          ; call Sub_1062
$0FE1  A6 C9 0C 82         Sub_0FE1:      LDA 3202,U            
$0FE5  27 0D                              BEQ Sub_0FF4          
$0FE7  81 05                              CMPA #$05             
$0FE9  26 06                              BNE Sub_0FF1          
$0FEB  4F                                 CLRA                   ; A = 0
$0FEC  B7 0C 82                           STA $0C82             
$0FEF  20 03                              BRA Sub_0FF4          

; --------------------------------------------------------------
$0FF1  17 15 56            Sub_0FF1:      LBSR Sub_254A          ; call Sub_254A
$0FF4  8D 4A               Sub_0FF4:      BSR Sub_1040           ; call Sub_1040
$0FF6  86 01                              LDA #$01              
$0FF8  30 C9 07 0D                        LEAX 1805,U           
$0FFC  10 AE C9 0C 88                     LDY 3208,U            
$1001  10 8C 00 00                        CMPY #$0000           
$1005  27 10                              BEQ Sub_1017          
$1007  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$100A  6D C8 25                           TST 37,U              
$100D  27 08                              BEQ Sub_1017          
$100F  6D C8 26                           TST 38,U              
$1012  27 03                              BEQ Sub_1017          
$1014  17 33 7D                           LBSR Sub_4394          ; call Sub_4394
$1017  17 35 21            Sub_1017:      LBSR Sub_453B          ; call Sub_453B
$101A  6D C9 0C 83                        TST 3203,U            
$101E  27 03                              BEQ Sub_1023          
$1020  17 15 8E                           LBSR Sub_25B1          ; call Sub_25B1
$1023  6D C8 6B            Sub_1023:      TST 107,U             
$1026  2A 0E                              BPL Sub_1036          
$1028  6F C8 6B                           CLR 107,U             
$102B  6D C9 0C A0                        TST 3232,U            
$102F  10 27 08 26                        LBEQ Sub_1859         
$1033  16 07 5D                           LBRA Sub_1793         

; --------------------------------------------------------------
$1036  6D C8 23            Sub_1036:      TST 35,U              
$1039  10 27 FC 35                        LBEQ Sub_0C72         
$103D  16 FC 1E                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$1040  A6 C9 0C A6         Sub_1040:      LDA 3238,U            
$1044  27 0C                              BEQ Sub_1052          
$1046  81 01                              CMPA #$01             
$1048  10 27 FC 35                        LBEQ Sub_0C81         
$104C  81 02                              CMPA #$02              ; compare A with CurXY
$104E  10 27 FC 98                        LBEQ Sub_0CEA         
$1052  30 C9 00 DF         Sub_1052:      LEAX 223,U            
$1056  31 C9 07 0D                        LEAY 1805,U           
$105A  E6 C9 0C 89                        LDB 3209,U            
$105E  17 1C BD                           LBSR Sub_2D1E          ; call Sub_2D1E
$1061  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1062  34 36               Sub_1062:      PSHS A,B,X,Y          
$1064  E6 C9 0C 89                        LDB 3209,U            
$1068  10 AE C8 6C                        LDY 108,U             
$106C  30 C9 00 DF                        LEAX 223,U            
$1070  5D                  Sub_1070:      TSTB                  
$1071  27 35                              BEQ Sub_10A8          
$1073  6D C8 6B                           TST 107,U             
$1076  27 0C                              BEQ Sub_1084          
$1078  A6 84                              LDA ,X                
$107A  81 30                              CMPA #$30              ; compare A with '0'
$107C  27 43                              BEQ Sub_10C1          
$107E  81 31                              CMPA #$31              ; compare A with '1'
$1080  27 45                              BEQ Sub_10C7          
$1082  20 0C                              BRA Sub_1090          

; --------------------------------------------------------------
$1084  A6 80               Sub_1084:      LDA ,X+               
$1086  84 7F                              ANDA #$7F             
$1088  5A                                 DECB                  
$1089  6F C8 71                           CLR 113,U             
$108C  A1 A4               Sub_108C:      CMPA ,Y               
$108E  27 1A                              BEQ Sub_10AA          
$1090  31 8D F2 86         Sub_1090:      LEAY Dat_031A,PC       ; Y → Dat_031A
$1094  10 AF C8 6C                        STY 108,U             
$1098  6D C8 71                           TST 113,U             
$109B  26 05                              BNE Sub_10A2          
$109D  6C C8 71                           INC 113,U             
$10A0  20 EA                              BRA Sub_108C          

; --------------------------------------------------------------
$10A2  6F C8 71            Sub_10A2:      CLR 113,U             
$10A5  5D                                 TSTB                  
$10A6  26 DC                              BNE Sub_1084          
$10A8  35 B6               Sub_10A8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$10AA  31 21               Sub_10AA:      LEAY 1,Y              
$10AC  10 AF C8 6C                        STY 108,U             
$10B0  6D A4                              TST ,Y                
$10B2  26 EE                              BNE Sub_10A2          
$10B4  6C C8 6B                           INC 107,U             
$10B7  31 8D F2 5F                        LEAY Dat_031A,PC       ; Y → Dat_031A
$10BB  10 AF C8 6C                        STY 108,U             
$10BF  20 AF                              BRA Sub_1070          

; --------------------------------------------------------------
$10C1  6C C9 0C A0         Sub_10C1:      INC 3232,U            
$10C5  20 04                              BRA Sub_10CB          

; --------------------------------------------------------------
$10C7  6F C9 0C A0         Sub_10C7:      CLR 3232,U            
$10CB  86 FF               Sub_10CB:      LDA #$FF              
$10CD  A7 C8 6B                           STA 107,U             
$10D0  20 D6                              BRA Sub_10A8          

; --------------------------------------------------------------
$10D2  E6 01               Sub_10D2:      LDB 1,X               
$10D4  30 02                              LEAX 2,X              
$10D6  A6 80               Sub_10D6:      LDA ,X+               
$10D8  A7 A0                              STA ,Y+               
$10DA  6C C9 0C 89                        INC 3209,U            
$10DE  5A                                 DECB                  
$10DF  26 F5                              BNE Sub_10D6          
$10E1  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$10E2  34 16               Sub_10E2:      PSHS A,B,X            
$10E4  30 C9 0C 60                        LEAX 3168,U           
$10E8  A6 84                              LDA ,X                
$10EA  81 02                              CMPA #$02              ; compare A with CurXY
$10EC  27 09                              BEQ Sub_10F7          
$10EE  30 8D F3 72                        LEAX Dat_0464,PC       ; X → Dat_0464
$10F2  8D DE                              BSR Sub_10D2           ; call Sub_10D2
$10F4  16 FD AF            Sub_10F4:      LBRA Sub_0EA6         
$10F7  30 8D F3 63         Sub_10F7:      LEAX Dat_045E,PC       ; X → Dat_045E
$10FB  8D D5                              BSR Sub_10D2           ; call Sub_10D2
$10FD  17 03 22                           LBSR Sub_1422          ; call Sub_1422
$1100  20 F2                              BRA Sub_10F4          

; --------------------------------------------------------------
$1102  34 16               Sub_1102:      PSHS A,B,X            
$1104  30 8D F3 59                        LEAX Dat_0461,PC       ; X → Dat_0461
$1108  8D C8                              BSR Sub_10D2           ; call Sub_10D2
$110A  16 FD 99                           LBRA Sub_0EA6         

; --------------------------------------------------------------
$110D  CC 1A 01            Sub_110D:      LDD #$1A01            
$1110  ED C9 0C 8F                        STD 3215,U            
$1114  CC 34 0D                           LDD #$340D            
$1117  ED C9 0C 91                        STD 3217,U            
$111B  17 0B 63                           LBSR Sub_1C81          ; call Sub_1C81
$111E  30 8D EF E7                        LEAX Dat_0109,PC       ; X → Dat_0109
$1122  17 09 DE                           LBSR WriteBlock        ; call WriteBlock
$1125  30 8D F3 66                        LEAX Dat_048F,PC       ; X → Dat_048F
$1129  17 09 D7                           LBSR WriteBlock        ; call WriteBlock
$112C  17 19 96            Sub_112C:      LBSR Sub_2AC5          ; call Sub_2AC5
$112F  81 20                              CMPA #$20              ; compare A with ' '
$1131  27 38                              BEQ Sub_116B          
$1133  81 05                              CMPA #$05             
$1135  27 34                              BEQ Sub_116B          
$1137  81 0C                              CMPA #$0C              ; compare A with FF
$1139  26 04                              BNE Sub_113F          
$113B  8B 80               Sub_113B:      ADDA #$80             
$113D  20 17                              BRA Sub_1156          

; --------------------------------------------------------------
$113F  81 0A               Sub_113F:      CMPA #$0A              ; compare A with LF
$1141  27 F8                              BEQ Sub_113B          
$1143  E6 8D F8 CE                        LDB Dat_0A15,PC       
$1147  30 8D F8 CB                        LEAX Dat_0A16,PC       ; X → Dat_0A16
$114B  A1 80               Sub_114B:      CMPA ,X+              
$114D  27 05                              BEQ Sub_1154          
$114F  5A                                 DECB                  
$1150  26 F9                              BNE Sub_114B          
$1152  20 D8                              BRA Sub_112C          

; --------------------------------------------------------------
$1154  8B A0               Sub_1154:      ADDA #$A0             
$1156  34 02               Sub_1156:      PSHS A                
$1158  30 8D F2 68                        LEAX Dat_03C4,PC       ; X → Dat_03C4
$115C  17 09 A4                           LBSR WriteBlock        ; call WriteBlock
$115F  30 8D F3 28                        LEAX Dat_048B,PC       ; X → Dat_048B
$1163  17 09 9D                           LBSR WriteBlock        ; call WriteBlock
$1166  35 02                              PULS A                
$1168  16 04 2C                           LBRA Sub_1597         

; --------------------------------------------------------------
$116B  30 8D F2 55         Sub_116B:      LEAX Dat_03C4,PC       ; X → Dat_03C4
$116F  17 09 91                           LBSR WriteBlock        ; call WriteBlock
$1172  17 0A 38                           LBSR Sub_1BAD          ; call Sub_1BAD
$1175  30 8D F3 12                        LEAX Dat_048B,PC       ; X → Dat_048B
$1179  17 09 87                           LBSR WriteBlock        ; call WriteBlock
$117C  16 FA DF                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$117F  34 36               Sub_117F:      PSHS A,B,X,Y          
$1181  A6 C8 2B                           LDA 43,U              
$1184  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$1186  30 C9 0C 2E                        LEAX 3118,U           
$118A  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$118D  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$118F  34 36               Sub_118F:      PSHS A,B,X,Y          
$1191  30 C9 0C 2E                        LEAX 3118,U           
$1195  E6 C9 0C A5                        LDB 3237,U            
$1199  E7 88 15                           STB 21,X              
$119C  E6 88 14                           LDB 20,X              
$119F  C4 0F                              ANDB #$0F             
$11A1  EA C9 0C AC                        ORB 3244,U            
$11A5  E7 88 14                           STB 20,X              
$11A8  E6 C9 0C AF                        LDB 3247,U            
$11AC  E7 88 18                           STB 24,X              
$11AF  E6 C9 0C B0                        LDB 3248,U            
$11B3  E7 88 19                           STB 25,X              
$11B6  E6 C9 0C B1                        LDB 3249,U            
$11BA  E7 04                              STB 4,X               
$11BC  E6 C9 0C A9                        LDB 3241,U            
$11C0  E7 05                              STB 5,X               
$11C2  6F 07                              CLR 7,X               
$11C4  30 09                              LEAX 9,X              
$11C6  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$11C8  6F 80               Sub_11C8:      CLR ,X+               
$11CA  5A                                 DECB                  
$11CB  26 FB                              BNE Sub_11C8          
$11CD  A6 C8 2B                           LDA 43,U              
$11D0  81 03                              CMPA #$03             
$11D2  10 23 00 DD                        LBLS Sub_12B3         
$11D6  30 C9 0C 2E                        LEAX 3118,U           
$11DA  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$11DC  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$11DF  30 C9 00 95                        LEAX 149,U            
$11E3  CC 02 5A                           LDD #$025A            
$11E6  ED 84                              STD ,X                
$11E8  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$11EA  E7 02                              STB 2,X               
$11EC  10 8E 00 03                        LDY #$0003            
$11F0  A6 C8 3E                           LDA 62,U              
$11F3  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$11F6  A6 C9 0C A5                        LDA 3237,U            
$11FA  84 07                              ANDA #$07             
$11FC  C6 05                              LDB #$05               ; B = SS.Pos  (GetStt/SetStt subcode)
$11FE  3D                                 MUL                    ; D = A×B unsigned
$11FF  30 8D F4 4F                        LEAX Dat_0652,PC       ; X → Dat_0652
$1203  30 85                              LEAX B,X              
$1205  10 8E 00 05                        LDY #$0005            
$1209  A6 C8 3E                           LDA 62,U              
$120C  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$120F  C6 61                              LDB #$61               ; B = 'a'
$1211  30 C9 00 95                        LEAX 149,U            
$1215  E7 01                              STB 1,X               
$1217  A6 C8 3E                           LDA 62,U              
$121A  10 8E 00 03                        LDY #$0003            
$121E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1221  E6 C9 0C A5                        LDB 3237,U            
$1225  C5 20                              BITB #$20             
$1227  26 04                              BNE Sub_122D          
$1229  C6 38                              LDB #$38               ; B = '8'
$122B  20 02                              BRA Sub_122F          

; --------------------------------------------------------------
$122D  C6 37               Sub_122D:      LDB #$37               ; B = '7'
$122F  30 C8 44            Sub_122F:      LEAX 68,U             
$1232  E7 84                              STB ,X                
$1234  10 8E 00 01                        LDY #$0001            
$1238  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$123B  C6 63                              LDB #$63               ; B = 'c'
$123D  30 C9 00 95                        LEAX 149,U            
$1241  E7 01                              STB 1,X               
$1243  10 8E 00 03                        LDY #$0003            
$1247  A6 C8 3E                           LDA 62,U              
$124A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$124D  A6 C9 0C AC                        LDA 3244,U            
$1251  84 E0                              ANDA #$E0             
$1253  81 A0                              CMPA #$A0             
$1255  26 06                              BNE Sub_125D          
$1257  30 8D F7 36                        LEAX Dat_0991,PC       ; X → Dat_0991
$125B  20 22                              BRA Sub_127F          

; --------------------------------------------------------------
$125D  81 E0               Sub_125D:      CMPA #$E0             
$125F  26 06                              BNE Sub_1267          
$1261  30 8D F7 30                        LEAX Dat_0995,PC       ; X → Dat_0995
$1265  20 18                              BRA Sub_127F          

; --------------------------------------------------------------
$1267  81 60               Sub_1267:      CMPA #$60              ; compare A with '`'
$1269  26 06                              BNE Sub_1271          
$126B  30 8D F7 2C                        LEAX Dat_099B,PC       ; X → Dat_099B
$126F  20 0E                              BRA Sub_127F          

; --------------------------------------------------------------
$1271  81 20               Sub_1271:      CMPA #$20              ; compare A with ' '
$1273  26 06                              BNE Sub_127B          
$1275  30 8D F7 27                        LEAX Dat_09A0,PC       ; X → Dat_09A0
$1279  20 04                              BRA Sub_127F          

; --------------------------------------------------------------
$127B  30 8D F7 26         Sub_127B:      LEAX Dat_09A5,PC       ; X → Dat_09A5
$127F  A6 C8 3E            Sub_127F:      LDA 62,U              
$1282  10 8E 00 01                        LDY #$0001            
$1286  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1289  C6 65                              LDB #$65               ; B = 'e'
$128B  30 C9 00 95                        LEAX 149,U            
$128F  E7 01                              STB 1,X               
$1291  A6 C8 3E                           LDA 62,U              
$1294  10 8E 00 03                        LDY #$0003            
$1298  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$129B  E6 C9 0C A5                        LDB 3237,U            
$129F  2A 04                              BPL Sub_12A5          
$12A1  C6 32                              LDB #$32               ; B = '2'
$12A3  20 02                              BRA Sub_12A7          

; --------------------------------------------------------------
$12A5  C6 31               Sub_12A5:      LDB #$31               ; B = '1'
$12A7  30 C8 44            Sub_12A7:      LEAX 68,U             
$12AA  E7 84                              STB ,X                
$12AC  10 8E 00 01                        LDY #$0001            
$12B0  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$12B3  35 B6               Sub_12B3:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$12B5  34 36               Sub_12B5:      PSHS A,B,X,Y          
$12B7  30 C9 13 A9                        LEAX 5033,U           
$12BB  31 C9 0C 0C                        LEAY 3084,U           
$12BF  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$12C1  17 1A 62                           LBSR Sub_2D26          ; call Sub_2D26
$12C4  30 C9 13 A9                        LEAX 5033,U           
$12C8  6F 04                              CLR 4,X               
$12CA  A6 C9 0C A8                        LDA 3240,U            
$12CE  A7 05                              STA 5,X               
$12D0  6F 07                              CLR 7,X               
$12D2  A6 C9 13 A3                        LDA 5027,U            
$12D6  A7 0C                              STA 12,X              
$12D8  A6 C9 13 A6                        LDA 5030,U            
$12DC  A7 0F                              STA 15,X              
$12DE  A6 C9 13 A4                        LDA 5028,U            
$12E2  A7 88 10                           STA 16,X              
$12E5  A6 C9 13 A5                        LDA 5029,U            
$12E9  A7 88 11                           STA 17,X              
$12EC  86 01                              LDA #$01              
$12EE  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$12F0  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$12F3  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$12F5  34 16               Sub_12F5:      PSHS A,B,X            
$12F7  86 00                              LDA #$00               ; A = NUL
$12F9  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$12FB  30 C9 0C 0C                        LEAX 3084,U           
$12FF  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1302  A6 88 14                           LDA 20,X              
$1305  2A 41                              BPL Sub_1348          
$1307  86 01                              LDA #$01              
$1309  C6 96                              LDB #$96              
$130B  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$130E  A7 C9 00 8D                        STA 141,U             
$1312  E7 C9 00 8E                        STB 142,U             
$1316  1F 10                              TFR X,D               
$1318  E7 C9 00 8F                        STB 143,U             
$131C  30 C9 0C 50                        LEAX 3152,U           
$1320  86 01                              LDA #$01              
$1322  C6 91                              LDB #$91              
$1324  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1327  86 01                              LDA #$01              
$1329  C6 26                              LDB #$26               ; B = SS.FSig  (GetStt/SetStt subcode)
$132B  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$132E  1F 10                              TFR X,D               
$1330  E7 C9 00 82                        STB 130,U             
$1334  1F 20                              TFR Y,D               
$1336  E7 C9 00 83                        STB 131,U             
$133A  86 01                              LDA #$01              
$133C  C6 93                              LDB #$93              
$133E  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1341  A7 C9 00 84                        STA 132,U             
$1345  5F                                 CLRB                   ; B = 0
$1346  35 96               Sub_1346:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$1348  53                  Sub_1348:      COMB                  
$1349  C6 B7                              LDB #$B7              
$134B  20 F9                              BRA Sub_1346          

; --------------------------------------------------------------
$134D  34 16               Sub_134D:      PSHS A,B,X            
$134F  86 00                              LDA #$00               ; A = NUL
$1351  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$1353  30 C9 0C 0C                        LEAX 3084,U           
$1357  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$135A  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$135C  34 36               Sub_135C:      PSHS A,B,X,Y          
$135E  31 8D F1 07                        LEAY Dat_0469,PC       ; Y → Dat_0469
$1362  C6 10                              LDB #$10              
$1364  30 C9 13 A9                        LEAX 5033,U           
$1368  17 19 BB                           LBSR Sub_2D26          ; call Sub_2D26
$136B  30 C9 13 A9                        LEAX 5033,U           
$136F  A6 C9 00 84                        LDA 132,U             
$1373  A7 04                              STA 4,X               
$1375  4F                                 CLRA                   ; A = 0
$1376  A7 06                              STA 6,X               
$1378  A6 C9 00 82                        LDA 130,U             
$137C  A7 07                              STA 7,X               
$137E  A6 C9 00 83                        LDA 131,U             
$1382  A7 08                              STA 8,X               
$1384  A6 C9 00 8D                        LDA 141,U             
$1388  A7 09                              STA 9,X               
$138A  A6 C9 00 8E                        LDA 142,U             
$138E  A7 0A                              STA 10,X              
$1390  A6 C9 00 8F                        LDA 143,U             
$1394  A7 0B                              STA 11,X              
$1396  10 8E 00 0C                        LDY #$000C            
$139A  86 01                              LDA #$01              
$139C  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$139F  30 C9 0C 50                        LEAX 3152,U           
$13A3  86 01                              LDA #$01              
$13A5  C6 91                              LDB #$91              
$13A7  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$13AA  CC 1B 21                           LDD #$1B21             ; D=ESC+'!'  → W.Select: Select window
$13AD  ED 84                              STD ,X                
$13AF  86 01                              LDA #$01              
$13B1  10 8E 00 02                        LDY #$0002            
$13B5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$13B8  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$13BA  30 8D EF E9         Sub_13BA:      LEAX Dat_03A7,PC       ; X → Dat_03A7
$13BE  17 07 42                           LBSR WriteBlock        ; call WriteBlock
$13C1  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$13C2  86 00               Sub_13C2:      LDA #$00               ; A = NUL
$13C4  20 03                              BRA Sub_13C9          

; --------------------------------------------------------------
$13C6  A6 C8 2B            Sub_13C6:      LDA 43,U              
$13C9  C6 01               Sub_13C9:      LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$13CB  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$13CE  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$13CF  34 06               Sub_13CF:      PSHS A,B              
$13D1  EC C9 0C 94                        LDD 3220,U            
$13D5  4C                                 INCA                  
$13D6  A1 C9 00 90                        CMPA 144,U            
$13DA  23 0A                              BLS Sub_13E6          
$13DC  86 01                              LDA #$01              
$13DE  5C                                 INCB                  
$13DF  E1 C9 00 91                        CMPB 145,U            
$13E3  23 01                              BLS Sub_13E6          
$13E5  5A                                 DECB                  
$13E6  ED C9 0C 94         Sub_13E6:      STD 3220,U            
$13EA  35 86                              PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$13EC  34 06               Sub_13EC:      PSHS A,B              
$13EE  EC C9 0C 94                        LDD 3220,U            
$13F2  4A                                 DECA                  
$13F3  26 0A                              BNE Sub_13FF          
$13F5  A6 C9 00 90                        LDA 144,U             
$13F9  5A                                 DECB                  
$13FA  26 03                              BNE Sub_13FF          
$13FC  CC 01 01                           LDD #$0101            
$13FF  ED C9 0C 94         Sub_13FF:      STD 3220,U            
$1403  35 86                              PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1405  6F C9 0C 94         Sub_1405:      CLR 3220,U            
$1409  6C C9 0C 94                        INC 3220,U            
$140D  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$140E  34 06               Sub_140E:      PSHS A,B              
$1410  EC C9 0C 94                        LDD 3220,U            
$1414  5C                                 INCB                  
$1415  E1 C9 00 91                        CMPB 145,U            
$1419  23 01                              BLS Sub_141C          
$141B  5A                                 DECB                  
$141C  ED C9 0C 94         Sub_141C:      STD 3220,U            
$1420  35 86                              PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1422  6F C9 0C 94         Sub_1422:      CLR 3220,U            
$1426  6F C9 0C 95                        CLR 3221,U            
$142A  6C C9 0C 94                        INC 3220,U            
$142E  6C C9 0C 95                        INC 3221,U            
$1432  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1433  34 06               Sub_1433:      PSHS A,B              
$1435  EC C9 0C 94                        LDD 3220,U            
$1439  ED C9 0C 96                        STD 3222,U            
$143D  35 06                              PULS A,B              
$143F  16 F8 CD                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$1442  34 06               Sub_1442:      PSHS A,B              
$1444  86 02                              LDA #$02               ; A = CurXY
$1446  A7 A0                              STA ,Y+               
$1448  EC C9 0C 96                        LDD 3222,U            
$144C  ED C9 0C 94                        STD 3220,U            
$1450  8B 1F                              ADDA #$1F             
$1452  CB 1F                              ADDB #$1F             
$1454  A7 A0                              STA ,Y+               
$1456  E7 A0                              STB ,Y+               
$1458  E6 C9 0C 89                        LDB 3209,U            
$145C  CB 03                              ADDB #$03             
$145E  E7 C9 0C 89                        STB 3209,U            
$1462  35 06                              PULS A,B              
$1464  16 F8 A8                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$1467  34 16               Sub_1467:      PSHS A,B,X            
$1469  30 C9 0C 60                        LEAX 3168,U           
$146D  86 02                              LDA #$02               ; A = CurXY
$146F  A7 A0                              STA ,Y+               
$1471  A6 01                              LDA 1,X               
$1473  27 0E                              BEQ Sub_1483          
$1475  81 FE                              CMPA #$FE             
$1477  26 04                              BNE Sub_147D          
$1479  A6 02                              LDA 2,X               
$147B  27 06                              BEQ Sub_1483          
$147D  A1 C9 00 90         Sub_147D:      CMPA 144,U            
$1481  23 02                              BLS Sub_1485          
$1483  86 01               Sub_1483:      LDA #$01              
$1485  A7 C9 0C 94         Sub_1485:      STA 3220,U            
$1489  8B 1F                              ADDA #$1F             
$148B  A7 A0                              STA ,Y+               
$148D  A6 84                              LDA ,X                
$148F  27 06                              BEQ Sub_1497          
$1491  A1 C9 00 91                        CMPA 145,U            
$1495  23 02                              BLS Sub_1499          
$1497  86 01               Sub_1497:      LDA #$01              
$1499  A7 C9 0C 95         Sub_1499:      STA 3221,U            
$149D  8B 1F                              ADDA #$1F             
$149F  A7 A0                              STA ,Y+               
$14A1  E6 C9 0C 89                        LDB 3209,U            
$14A5  CB 03                              ADDB #$03             
$14A7  E7 C9 0C 89                        STB 3209,U            
$14AB  35 16                              PULS A,B,X            
$14AD  16 F8 5F                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$14B0  34 16               Sub_14B0:      PSHS A,B,X            
$14B2  30 C9 0C 60                        LEAX 3168,U           
$14B6  A6 84                              LDA ,X                
$14B8  A1 C9 00 90                        CMPA 144,U            
$14BC  24 03                              BCC Sub_14C1           ; C=0 (BHS)
$14BE  4D                                 TSTA                  
$14BF  26 02                              BNE Sub_14C3          
$14C1  86 01               Sub_14C1:      LDA #$01              
$14C3  AB C9 0C 94         Sub_14C3:      ADDA 3220,U           
$14C7  A1 C9 00 90                        CMPA 144,U            
$14CB  23 04                              BLS Sub_14D1          
$14CD  A6 C9 00 90                        LDA 144,U             
$14D1  A7 C9 0C 94         Sub_14D1:      STA 3220,U            
$14D5  C6 02               Sub_14D5:      LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$14D7  E7 A0                              STB ,Y+               
$14D9  EC C9 0C 94                        LDD 3220,U            
$14DD  8B 1F                              ADDA #$1F             
$14DF  CB 1F                              ADDB #$1F             
$14E1  A7 A0                              STA ,Y+               
$14E3  E7 A0                              STB ,Y+               
$14E5  E6 C9 0C 89                        LDB 3209,U            
$14E9  CB 03                              ADDB #$03             
$14EB  E7 C9 0C 89                        STB 3209,U            
$14EF  35 16                              PULS A,B,X            
$14F1  16 F8 1B                           LBRA Sub_0D0F         

; --------------------------------------------------------------
$14F4  34 16               Sub_14F4:      PSHS A,B,X            
$14F6  30 C9 0C 60                        LEAX 3168,U           
$14FA  A6 84                              LDA ,X                
$14FC  A1 C9 00 90                        CMPA 144,U            
$1500  24 03                              BCC Sub_1505           ; C=0 (BHS)
$1502  4D                                 TSTA                  
$1503  26 02                              BNE Sub_1507          
$1505  86 01               Sub_1505:      LDA #$01              
$1507  A7 C9 0C 84         Sub_1507:      STA 3204,U            
$150B  A6 C9 0C 94                        LDA 3220,U            
$150F  A0 C9 0C 84                        SUBA 3204,U           
$1513  2E 02                              BGT Sub_1517          
$1515  86 01                              LDA #$01              
$1517  A7 C9 0C 94         Sub_1517:      STA 3220,U            
$151B  20 B8                              BRA Sub_14D5          

; --------------------------------------------------------------
$151D  34 16               Sub_151D:      PSHS A,B,X            
$151F  30 C9 0C 60                        LEAX 3168,U           
$1523  A6 84                              LDA ,X                
$1525  A1 C9 00 91                        CMPA 145,U            
$1529  24 03                              BCC Sub_152E           ; C=0 (BHS)
$152B  4D                                 TSTA                  
$152C  26 02                              BNE Sub_1530          
$152E  86 01               Sub_152E:      LDA #$01              
$1530  A7 C9 0C 84         Sub_1530:      STA 3204,U            
$1534  A6 C9 0C 95                        LDA 3221,U            
$1538  A0 C9 0C 84                        SUBA 3204,U           
$153C  2E 02                              BGT Sub_1540          
$153E  86 01                              LDA #$01              
$1540  A7 C9 0C 95         Sub_1540:      STA 3221,U            
$1544  20 8F                              BRA Sub_14D5          

; --------------------------------------------------------------
$1546  34 16               Sub_1546:      PSHS A,B,X            
$1548  30 C9 0C 60                        LEAX 3168,U           
$154C  A6 84                              LDA ,X                
$154E  A1 C9 00 91                        CMPA 145,U            
$1552  24 03                              BCC Sub_1557           ; C=0 (BHS)
$1554  4D                                 TSTA                  
$1555  26 02                              BNE Sub_1559          
$1557  86 01               Sub_1557:      LDA #$01              
$1559  AB C9 0C 95         Sub_1559:      ADDA 3221,U           
$155D  A1 C9 00 91                        CMPA 145,U            
$1561  23 04                              BLS Sub_1567          
$1563  A6 C9 00 91                        LDA 145,U             
$1567  A7 C9 0C 95         Sub_1567:      STA 3221,U            
$156B  16 FF 67                           LBRA Sub_14D5         

; --------------------------------------------------------------
$156E  86 00               Sub_156E:      LDA #$00               ; A = NUL
$1570  10 8E 00 01                        LDY #$0001            
$1574  30 C9 06 0E                        LEAX 1550,U           
$1578  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$157B  86 00               Sub_157B:      LDA #$00               ; A = NUL
$157D  C6 27                              LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
$157F  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1582  A7 C8 41                           STA 65,U              
$1585  A6 C9 06 0E                        LDA 1550,U            
$1589  6F C9 06 0E                        CLR 1550,U            
$158D  E6 C9 0C A6                        LDB 3238,U            
$1591  C1 02                              CMPB #$02              ; compare B with CurXY
$1593  10 27 0C 59                        LBEQ Sub_21F0         
$1597  81 1A               Sub_1597:      CMPA #$1A              ; compare A with SUB
$1599  26 0A                              BNE Sub_15A5          
$159B  E6 C8 41                           LDB 65,U              
$159E  C4 10                              ANDB #$10             
$15A0  27 03                              BEQ Sub_15A5          
$15A2  16 1F DB                           LBRA Sub_3580         

; --------------------------------------------------------------
$15A5  81 1C               Sub_15A5:      CMPA #$1C             
$15A7  26 0A                              BNE Sub_15B3          
$15A9  E6 C8 41                           LDB 65,U              
$15AC  C4 08                              ANDB #$08             
$15AE  27 03                              BEQ Sub_15B3          
$15B0  16 20 2C                           LBRA Sub_35DF         

; --------------------------------------------------------------
$15B3  81 F1               Sub_15B3:      CMPA #$F1             
$15B5  10 27 05 53                        LBEQ Sub_1B0C         
$15B9  81 E8                              CMPA #$E8             
$15BB  10 27 03 C4                        LBEQ Sub_1983         
$15BF  81 AF                              CMPA #$AF             
$15C1  10 27 FB 48                        LBEQ Sub_110D         
$15C5  81 E1                              CMPA #$E1             
$15C7  10 27 18 F4                        LBEQ Sub_2EBF         
$15CB  81 E2                              CMPA #$E2             
$15CD  26 03                              BNE Sub_15D2          
$15CF  17 07 5D                           LBSR Sub_1D2F          ; call Sub_1D2F
$15D2  81 E9               Sub_15D2:      CMPA #$E9             
$15D4  26 03                              BNE Sub_15D9          
$15D6  16 01 83                           LBRA Sub_175C         

; --------------------------------------------------------------
$15D9  81 F4               Sub_15D9:      CMPA #$F4             
$15DB  26 03                              BNE Sub_15E0          
$15DD  17 08 70                           LBSR Sub_1E50          ; call Sub_1E50
$15E0  81 F5               Sub_15E0:      CMPA #$F5             
$15E2  26 03                              BNE Sub_15E7          
$15E4  17 18 9C                           LBSR Sub_2E83          ; call Sub_2E83
$15E7  81 E3               Sub_15E7:      CMPA #$E3             
$15E9  26 03                              BNE Sub_15EE          
$15EB  17 08 EE                           LBSR Sub_1EDC          ; call Sub_1EDC
$15EE  81 85               Sub_15EE:      CMPA #$85             
$15F0  26 03                              BNE Sub_15F5          
$15F2  17 07 1F                           LBSR Sub_1D14          ; call Sub_1D14
$15F5  81 18               Sub_15F5:      CMPA #$18             
$15F7  26 04                              BNE Sub_15FD          
$15F9  86 7F                              LDA #$7F              
$15FB  20 5C                              BRA Sub_1659          

; --------------------------------------------------------------
$15FD  81 F2               Sub_15FD:      CMPA #$F2             
$15FF  10 27 00 C8                        LBEQ Sub_16CB         
$1603  81 F3                              CMPA #$F3             
$1605  10 27 00 D3                        LBEQ Sub_16DC         
$1609  81 8A                              CMPA #$8A             
$160B  10 27 1F 71                        LBEQ Sub_3580         
$160F  81 8C                              CMPA #$8C             
$1611  10 27 1F CA                        LBEQ Sub_35DF         
$1615  81 EF                              CMPA #$EF             
$1617  26 03                              BNE Sub_161C          
$1619  17 09 01                           LBSR Sub_1F1D          ; call Sub_1F1D
$161C  81 ED               Sub_161C:      CMPA #$ED             
$161E  26 03                              BNE Sub_1623          
$1620  17 0D 41                           LBSR Sub_2364          ; call Sub_2364
$1623  81 E4               Sub_1623:      CMPA #$E4             
$1625  26 03                              BNE Sub_162A          
$1627  17 0C 87                           LBSR Sub_22B1          ; call Sub_22B1
$162A  81 FA               Sub_162A:      CMPA #$FA             
$162C  26 03                              BNE Sub_1631          
$162E  17 0F DF                           LBSR Sub_2610          ; call Sub_2610
$1631  E6 C8 41            Sub_1631:      LDB 65,U              
$1634  C4 04                              ANDB #$04             
$1636  27 0E                              BEQ Sub_1646          
$1638  81 B1                              CMPA #$B1             
$163A  25 1D                              BCS Sub_1659           ; C=1 (BLO)
$163C  81 B8                              CMPA #$B8             
$163E  22 19                              BHI Sub_1659          
$1640  17 03 DE                           LBSR Sub_1A21          ; call Sub_1A21
$1643  16 F6 18                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$1646  81 B1               Sub_1646:      CMPA #$B1             
$1648  10 27 FA C1                        LBEQ Sub_110D         
$164C  81 18                              CMPA #$18             
$164E  26 09                              BNE Sub_1659          
$1650  E6 C8 41                           LDB 65,U              
$1653  C4 20                              ANDB #$20             
$1655  27 02                              BEQ Sub_1659          
$1657  86 7F                              LDA #$7F              
$1659  81 AF               Sub_1659:      CMPA #$AF             
$165B  22 6B                              BHI Sub_16C8          
$165D  A7 C9 04 EF                        STA 1263,U            
$1661  6D C9 0C AA                        TST 3242,U            
$1665  27 0E                              BEQ Sub_1675          
$1667  86 01                              LDA #$01              
$1669  C6 98                              LDB #$98              
$166B  8E 28 01                           LDX #$2801            
$166E  10 8E 09 00                        LDY #$0900            
$1672  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1675  10 8E 00 01         Sub_1675:      LDY #$0001            
$1679  30 C9 04 EF                        LEAX 1263,U           
$167D  A6 84                              LDA ,X                
$167F  81 0D                              CMPA #$0D              ; compare A with CR
$1681  26 0C                              BNE Sub_168F          
$1683  6D C9 0C A9                        TST 3241,U            
$1687  27 06                              BEQ Sub_168F          
$1689  86 0A                              LDA #$0A               ; A = LF
$168B  A7 01                              STA 1,X               
$168D  31 21                              LEAY 1,Y              
$168F  A6 C8 2B            Sub_168F:      LDA 43,U              
$1692  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1695  6D C9 04 EF                        TST 1263,U            
$1699  2B 2D                              BMI Sub_16C8          
$169B  A6 C9 0C A7                        LDA 3239,U            
$169F  27 27                              BEQ Sub_16C8          
$16A1  6D C9 0C A8                        TST 3240,U            
$16A5  27 14                              BEQ Sub_16BB          
$16A7  A6 C9 04 EF                        LDA 1263,U            
$16AB  81 0D                              CMPA #$0D              ; compare A with CR
$16AD  26 0C                              BNE Sub_16BB          
$16AF  86 0A                              LDA #$0A               ; A = LF
$16B1  A7 C9 04 F0                        STA 1264,U            
$16B5  10 8E 00 02                        LDY #$0002            
$16B9  20 04                              BRA Sub_16BF          

; --------------------------------------------------------------
$16BB  10 8E 00 01         Sub_16BB:      LDY #$0001            
$16BF  30 C9 04 EF         Sub_16BF:      LEAX 1263,U           
$16C3  86 01                              LDA #$01              
$16C5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$16C8  16 F5 93            Sub_16C8:      LBRA Sub_0C5E         
$16CB  34 32               Sub_16CB:      PSHS A,X,Y            
$16CD  30 8D ED 05                        LEAX Dat_03D6,PC       ; X → Dat_03D6
$16D1  17 04 2F                           LBSR WriteBlock        ; call WriteBlock
$16D4  17 05 80                           LBSR Sub_1C57          ; call Sub_1C57
$16D7  35 32                              PULS A,X,Y            
$16D9  16 F5 82                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$16DC  34 40               Sub_16DC:      PSHS U                
$16DE  17 FC 6C                           LBSR Sub_134D          ; call Sub_134D
$16E1  C6 13                              LDB #$13               ; B = XOFF
$16E3  31 8D EC CB                        LEAY Dat_03B2,PC       ; Y → Dat_03B2
$16E7  30 C9 13 A9                        LEAX 5033,U           
$16EB  17 16 38                           LBSR Sub_2D26          ; call Sub_2D26
$16EE  30 C9 13 A9                        LEAX 5033,U           
$16F2  A6 C9 00 90                        LDA 144,U             
$16F6  A7 05                              STA 5,X               
$16F8  A6 C9 00 91                        LDA 145,U             
$16FC  6D C8 40                           TST 64,U              
$16FF  27 02                              BEQ Sub_1703          
$1701  80 03                              SUBA #$03             
$1703  A7 06               Sub_1703:      STA 6,X               
$1705  A6 C9 00 89                        LDA 137,U             
$1709  E6 C9 00 88                        LDB 136,U             
$170D  ED 07                              STD 7,X               
$170F  86 01                              LDA #$01              
$1711  10 8E 00 09                        LDY #$0009            
$1715  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1718  33 8D EB C9                        LEAU Dat_02E5,PC       ; U → Dat_02E5
$171C  30 8D EB C0                        LEAX Dat_02E0,PC       ; X → Dat_02E0
$1720  5F                                 CLRB                   ; B = 0
$1721  86 11                              LDA #$11               ; A = XON
$1723  10 3F 03                           OS9 F$Fork             ; module→D:X  args→Y  size=D
$1726  35 40                              PULS U                
$1728  25 13                              BCS Sub_173D           ; C=1 (BLO)
$172A  A7 C8 76                           STA 118,U             
$172D  8E 00 01            Sub_172D:      LDX #$0001            
$1730  17 F8 23                           LBSR Sub_0F56          ; call Sub_0F56
$1733  10 3F 04                           OS9 F$Wait             ; → wait for child; status→D
$1736  25 05                              BCS Sub_173D           ; C=1 (BLO)
$1738  A1 C8 76                           CMPA 118,U            
$173B  26 F0                              BNE Sub_172D          
$173D  86 01               Sub_173D:      LDA #$01              
$173F  30 8D EC 83                        LEAX Dat_03C6,PC       ; X → Dat_03C6
$1743  10 8E 00 02                        LDY #$0002            
$1747  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$174A  17 FB 68                           LBSR Sub_12B5          ; call Sub_12B5
$174D  16 F5 0E                           LBRA Sub_0C5E         

; --------------------------------------------------------------

Dat_1750
; 12-byte orphaned string copy loop (unreferenced from branch analysis)
; ── 12 bytes  ($1750—$175B) ──
         FCB    $A6
         FCB    $80
         FCB    $A7
         FCB    $A0
         FCB    $81
         FCB    $20
         FCB    $27
         FCB    $03
         FCB    $5A
         FCB    $26
         FCB    $F5
         FCB    $39
$175C  6D C8 72            Sub_175C:      TST 114,U             
$175F  27 0B                              BEQ Sub_176C          
$1761  A6 C8 75                           LDA 117,U             
$1764  27 09                              BEQ Sub_176F          
$1766  6F C8 75                           CLR 117,U             
$1769  17 F7 B4                           LBSR Sub_0F20          ; call Sub_0F20
$176C  16 F4 EF            Sub_176C:      LBRA Sub_0C5E         
$176F  6C C8 75            Sub_176F:      INC 117,U             
$1772  30 8D EB F0                        LEAX Dat_0366,PC       ; X → Dat_0366
$1776  31 C8 77                           LEAY 119,U            
$1779  C6 0B                              LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
$177B  17 15 A0                           LBSR Sub_2D1E          ; call Sub_2D1E
$177E  30 C8 77                           LEAX 119,U            
$1781  10 8E 00 0B                        LDY #$000B            
$1785  A6 C8 3E                           LDA 62,U              
$1788  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$178B  A6 C8 73                           LDA 115,U             
$178E  A7 C8 74                           STA 116,U             
$1791  20 D9                              BRA Sub_176C          

; --------------------------------------------------------------
$1793  CC 08 02            Sub_1793:      LDD #$0802            
$1796  ED C9 0C 8F                        STD 3215,U            
$179A  CC 40 0A                           LDD #$400A            
$179D  ED C9 0C 91                        STD 3217,U            
$17A1  17 04 DD                           LBSR Sub_1C81          ; call Sub_1C81
$17A4  30 8D EB 48                        LEAX Dat_02F0,PC       ; X → Dat_02F0
$17A8  17 03 58                           LBSR WriteBlock        ; call WriteBlock
$17AB  30 8D EC E0                        LEAX Dat_048F,PC       ; X → Dat_048F
$17AF  17 03 51                           LBSR WriteBlock        ; call WriteBlock
$17B2  30 C9 13 A9                        LEAX 5033,U           
$17B6  86 01                              LDA #$01              
$17B8  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$17BA  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$17BD  30 C9 13 A9                        LEAX 5033,U           
$17C1  86 01                              LDA #$01              
$17C3  A7 05                              STA 5,X               
$17C5  6F 07                              CLR 7,X               
$17C7  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$17C9  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$17CC  86 00                              LDA #$00               ; A = NUL
$17CE  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$17D1  A7 C8 6E                           STA 110,U             
$17D4  86 00                              LDA #$00               ; A = NUL
$17D6  10 3F 8F                           OS9 I$Close            ; path=A
$17D9  A6 C8 2B                           LDA 43,U              
$17DC  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$17DF  33 8D EB 06                        LEAU Dat_02E9,PC       ; U → Dat_02E9
$17E3  30 8D EA FF                        LEAX Dat_02E6,PC       ; X → Dat_02E6
$17E7  10 8E 00 0A                        LDY #$000A            
$17EB  5F                                 CLRB                   ; B = 0
$17EC  86 11                              LDA #$11               ; A = XON
$17EE  10 3F 03                           OS9 F$Fork             ; module→D:X  args→Y  size=D
$17F1  CE 00 00                           LDU #$0000            
$17F4  34 01                              PSHS CC               
$17F6  A7 C8 76                           STA 118,U             
$17F9  86 00                              LDA #$00               ; A = NUL
$17FB  10 3F 8F                           OS9 I$Close            ; path=A
$17FE  A6 C8 6E                           LDA 110,U             
$1801  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1804  A6 C8 6E                           LDA 110,U             
$1807  10 3F 8F                           OS9 I$Close            ; path=A
$180A  35 01                              PULS CC               
$180C  25 38                              BCS Sub_1846           ; C=1 (BLO)
$180E  8E 00 01            Sub_180E:      LDX #$0001            
$1811  17 F7 42                           LBSR Sub_0F56          ; call Sub_0F56
$1814  86 00                              LDA #$00               ; A = NUL
$1816  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$1818  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$181B  25 19                              BCS Sub_1836           ; C=1 (BLO)
$181D  4F                                 CLRA                   ; A = 0
$181E  C1 00                              CMPB #$00              ; compare B with NUL
$1820  27 14                              BEQ Sub_1836          
$1822  1F 02                              TFR D,Y               
$1824  30 C9 13 A9                        LEAX 5033,U           
$1828  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$182B  A6 C9 13 A9                        LDA 5033,U            
$182F  81 05                              CMPA #$05             
$1831  26 03                              BNE Sub_1836          
$1833  17 01 45                           LBSR Sub_197B          ; call Sub_197B
$1836  10 3F 04            Sub_1836:      OS9 F$Wait             ; → wait for child; status→D
$1839  25 0B                              BCS Sub_1846           ; C=1 (BLO)
$183B  A1 C8 76                           CMPA 118,U            
$183E  26 CE                              BNE Sub_180E          
$1840  5D                                 TSTB                  
$1841  27 03                              BEQ Sub_1846          
$1843  17 12 7F                           LBSR Sub_2AC5          ; call Sub_2AC5
$1846  17 04 95            Sub_1846:      LBSR Sub_1CDE          ; call Sub_1CDE
$1849  30 8D EC 3E                        LEAX Dat_048B,PC       ; X → Dat_048B
$184D  17 02 B3                           LBSR WriteBlock        ; call WriteBlock
$1850  17 FA 62                           LBSR Sub_12B5          ; call Sub_12B5
$1853  17 03 57                           LBSR Sub_1BAD          ; call Sub_1BAD
$1856  16 F4 05                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$1859  CC 08 02            Sub_1859:      LDD #$0802            
$185C  ED C9 0C 8F                        STD 3215,U            
$1860  CC 40 0A                           LDD #$400A            
$1863  ED C9 0C 91                        STD 3217,U            
$1867  17 04 17                           LBSR Sub_1C81          ; call Sub_1C81
$186A  30 8D EA B4                        LEAX Dat_0322,PC       ; X → Dat_0322
$186E  17 02 92                           LBSR WriteBlock        ; call WriteBlock
$1871  31 C9 07 0D                        LEAY 1805,U           
$1875  10 AF C8 48                        STY 72,U              
$1879  86 2D                              LDA #$2D               ; A = '-'
$187B  A7 A0                              STA ,Y+               
$187D  86 76                              LDA #$76               ; A = 'v'
$187F  A7 A0                              STA ,Y+               
$1881  A7 A0                              STA ,Y+               
$1883  86 20                              LDA #$20               ; A = ' '
$1885  A7 A0                              STA ,Y+               
$1887  30 8D EC D4         Sub_1887:      LEAX Dat_055F,PC       ; X → Dat_055F
$188B  34 20                              PSHS Y                
$188D  17 02 73                           LBSR WriteBlock        ; call WriteBlock
$1890  35 20                              PULS Y                
$1892  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$1894  17 02 CA                           LBSR Sub_1B61          ; call Sub_1B61
$1897  6D C8 21                           TST 33,U              
$189A  10 26 00 CA                        LBNE Sub_1968         
$189E  30 C9 06 0E                        LEAX 1550,U           
$18A2  E6 C8 1D                           LDB 29,U              
$18A5  C1 01                              CMPB #$01             
$18A7  27 0D                              BEQ Sub_18B6          
$18A9  A6 80               Sub_18A9:      LDA ,X+               
$18AB  A7 A0                              STA ,Y+               
$18AD  5A                                 DECB                  
$18AE  26 F9                              BNE Sub_18A9          
$18B0  86 20                              LDA #$20               ; A = ' '
$18B2  A7 3F                              STA -1,Y              
$18B4  20 D1                              BRA Sub_1887          

; --------------------------------------------------------------
$18B6  86 0D               Sub_18B6:      LDA #$0D               ; A = CR
$18B8  A7 A0                              STA ,Y+               
$18BA  1F 20                              TFR Y,D               
$18BC  A3 C8 48                           SUBD 72,U             
$18BF  ED C8 48                           STD 72,U              
$18C2  10 83 00 07                        CMPD #$0007           
$18C6  10 25 00 9E                        LBCS Sub_1968         
$18CA  17 06 0F                           LBSR Sub_1EDC          ; call Sub_1EDC
$18CD  30 8D EB BE                        LEAX Dat_048F,PC       ; X → Dat_048F
$18D1  17 02 2F                           LBSR WriteBlock        ; call WriteBlock
$18D4  30 C9 13 A9                        LEAX 5033,U           
$18D8  86 01                              LDA #$01              
$18DA  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$18DC  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$18DF  86 01                              LDA #$01              
$18E1  30 C9 13 A9                        LEAX 5033,U           
$18E5  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$18E7  A7 05                              STA 5,X               
$18E9  6F 07                              CLR 7,X               
$18EB  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$18EE  86 00                              LDA #$00               ; A = NUL
$18F0  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$18F3  A7 C8 6E                           STA 110,U             
$18F6  86 00                              LDA #$00               ; A = NUL
$18F8  10 3F 8F                           OS9 I$Close            ; path=A
$18FB  A6 C8 2B                           LDA 43,U              
$18FE  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1901  10 AE C8 48                        LDY 72,U              
$1905  33 C9 07 0D                        LEAU 1805,U           
$1909  30 8D EA 12                        LEAX Dat_031F,PC       ; X → Dat_031F
$190D  5F                                 CLRB                   ; B = 0
$190E  86 11                              LDA #$11               ; A = XON
$1910  10 3F 03                           OS9 F$Fork             ; module→D:X  args→Y  size=D
$1913  CE 00 00                           LDU #$0000            
$1916  34 01                              PSHS CC               
$1918  A7 C8 76                           STA 118,U             
$191B  86 00                              LDA #$00               ; A = NUL
$191D  10 3F 8F                           OS9 I$Close            ; path=A
$1920  A6 C8 6E                           LDA 110,U             
$1923  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1926  A6 C8 6E                           LDA 110,U             
$1929  10 3F 8F                           OS9 I$Close            ; path=A
$192C  35 01                              PULS CC               
$192E  25 38                              BCS Sub_1968           ; C=1 (BLO)
$1930  8E 00 01            Sub_1930:      LDX #$0001            
$1933  17 F6 20                           LBSR Sub_0F56          ; call Sub_0F56
$1936  86 00                              LDA #$00               ; A = NUL
$1938  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$193A  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$193D  25 19                              BCS Sub_1958           ; C=1 (BLO)
$193F  4F                                 CLRA                   ; A = 0
$1940  C1 00                              CMPB #$00              ; compare B with NUL
$1942  27 14                              BEQ Sub_1958          
$1944  1F 02                              TFR D,Y               
$1946  30 C9 13 A9                        LEAX 5033,U           
$194A  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$194D  A6 C9 13 A9                        LDA 5033,U            
$1951  81 05                              CMPA #$05             
$1953  26 03                              BNE Sub_1958          
$1955  17 00 23                           LBSR Sub_197B          ; call Sub_197B
$1958  10 3F 04            Sub_1958:      OS9 F$Wait             ; → wait for child; status→D
$195B  25 0B                              BCS Sub_1968           ; C=1 (BLO)
$195D  A1 C8 76                           CMPA 118,U            
$1960  26 CE                              BNE Sub_1930          
$1962  5D                                 TSTB                  
$1963  27 03                              BEQ Sub_1968          
$1965  17 11 5D                           LBSR Sub_2AC5          ; call Sub_2AC5
$1968  17 03 73            Sub_1968:      LBSR Sub_1CDE          ; call Sub_1CDE
$196B  17 F9 47                           LBSR Sub_12B5          ; call Sub_12B5
$196E  30 8D EB 19                        LEAX Dat_048B,PC       ; X → Dat_048B
$1972  17 01 8E                           LBSR WriteBlock        ; call WriteBlock
$1975  17 02 35                           LBSR Sub_1BAD          ; call Sub_1BAD
$1978  16 F2 E3                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$197B  A6 C8 76            Sub_197B:      LDA 118,U             
$197E  5F                                 CLRB                   ; B = 0
$197F  10 3F 08                           OS9 F$Send             ; pid=A  signal=B
$1982  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1983  6D C8 72            Sub_1983:      TST 114,U             
$1986  27 06                              BEQ Sub_198E          
$1988  6F C8 75                           CLR 117,U             
$198B  17 F5 92                           LBSR Sub_0F20          ; call Sub_0F20
$198E  CC 21 05            Sub_198E:      LDD #$2105            
$1991  ED C9 0C 8F                        STD 3215,U            
$1995  CC 0E 03                           LDD #$0E03            
$1998  ED C9 0C 91                        STD 3217,U            
$199C  17 02 E2                           LBSR Sub_1C81          ; call Sub_1C81
$199F  30 8D EA EC                        LEAX Dat_048F,PC       ; X → Dat_048F
$19A3  17 01 5D                           LBSR WriteBlock        ; call WriteBlock
$19A6  30 8D E9 9F                        LEAX Dat_0349,PC       ; X → Dat_0349
$19AA  17 01 56                           LBSR WriteBlock        ; call WriteBlock
$19AD  6D C9 0C AB                        TST 3243,U            
$19B1  26 2F                              BNE Sub_19E2          
$19B3  6D C8 1A                           TST 26,U              
$19B6  27 10                              BEQ Sub_19C8          
$19B8  A6 C8 2B                           LDA 43,U              
$19BB  C6 2B                              LDB #$2B               ; B = SS.CtlSg  (GetStt/SetStt subcode)
$19BD  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$19C0  8E 00 3C                           LDX #$003C            
$19C3  17 F5 90                           LBSR Sub_0F56          ; call Sub_0F56
$19C6  20 44                              BRA Sub_1A0C          

; --------------------------------------------------------------
$19C8  AE C8 11            Sub_19C8:      LDX 17,U              
$19CB  E6 02                              LDB 2,X               
$19CD  C4 FE                              ANDB #$FE             
$19CF  E7 02                              STB 2,X               
$19D1  8E 00 3C                           LDX #$003C            
$19D4  17 F5 7F                           LBSR Sub_0F56          ; call Sub_0F56
$19D7  AE C8 11                           LDX 17,U              
$19DA  E6 02                              LDB 2,X               
$19DC  CA 01                              ORB #$01              
$19DE  E7 02                              STB 2,X               
$19E0  20 2A                              BRA Sub_1A0C          

; --------------------------------------------------------------
$19E2  A6 C8 2B            Sub_19E2:      LDA 43,U              
$19E5  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$19E7  30 8D EF 96         Sub_19E7:      LEAX Dat_0981,PC       ; X → Dat_0981
$19EB  10 8E 00 01         Insn_19EB:     LDY #$0001            
$19EC  8E                  Sub_19EC:      EQU    $19EC            ; mid-instruction overlap: Insn_19EB+1 -- mid-instruction entry point -- byte 2 of LDY #$0001 ($10 8E 00 01) at $19EB; BSR from $1A02 executes LDX #$0001 then falls to OS9 I$Write
$19EF  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$19F2  8E 00 0C                           LDX #$000C            
$19F5  17 F5 5E                           LBSR Sub_0F56          ; call Sub_0F56
$19F8  5A                                 DECB                  
$19F9  26 EC                              BNE Sub_19E7          
$19FB  8E 00 80                           LDX #$0080            
$19FE  17 F5 55                           LBSR Sub_0F56          ; call Sub_0F56
$1A01  30 8D E8 D7                        LEAX Dat_02DC,PC       ; X → Dat_02DC
$1A05  10 8E 00 04                        LDY #$0004            
$1A09  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1A0C  17 02 CF            Sub_1A0C:      LBSR Sub_1CDE          ; call Sub_1CDE
$1A0F  30 8D EA 78                        LEAX Dat_048B,PC       ; X → Dat_048B
$1A13  17 00 ED                           LBSR WriteBlock        ; call WriteBlock
$1A16  16 F2 45                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$1A19  34 36               Sub_1A19:      PSHS A,B,X,Y          
$1A1B  30 C9 13 1C                        LEAX 4892,U           
$1A1F  20 0D                              BRA Sub_1A2E          

; --------------------------------------------------------------
$1A21  34 36               Sub_1A21:      PSHS A,B,X,Y          
$1A23  80 B1                              SUBA #$B1             
$1A25  C6 80                              LDB #$80              
$1A27  3D                                 MUL                    ; D = A×B unsigned
$1A28  30 C9 0D 1C                        LEAX 3356,U           
$1A2C  30 8B                              LEAX D,X              
$1A2E  34 10               Sub_1A2E:      PSHS X                
$1A30  5F                                 CLRB                   ; B = 0
$1A31  A6 80               Sub_1A31:      LDA ,X+               
$1A33  5C                                 INCB                  
$1A34  C1 80                              CMPB #$80             
$1A36  22 04                              BHI Sub_1A3C          
$1A38  81 0D                              CMPA #$0D              ; compare A with CR
$1A3A  26 F5                              BNE Sub_1A31          
$1A3C  5A                  Sub_1A3C:      DECB                  
$1A3D  4F                                 CLRA                   ; A = 0
$1A3E  35 10                              PULS X                
$1A40  5D                                 TSTB                  
$1A41  27 0C                              BEQ Sub_1A4F          
$1A43  A6 80               Sub_1A43:      LDA ,X+               
$1A45  5A                                 DECB                  
$1A46  81 5C                              CMPA #$5C              ; compare A with '\'
$1A48  27 13                              BEQ Sub_1A5D          
$1A4A  8D 2A                              BSR Sub_1A76           ; call Sub_1A76
$1A4C  5D                  Sub_1A4C:      TSTB                  
$1A4D  26 F4                              BNE Sub_1A43          
$1A4F  35 B6               Sub_1A4F:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$1A51  34 10               Sub_1A51:      PSHS X                
$1A53  8E 00 1E                           LDX #$001E            
$1A56  17 F4 FD                           LBSR Sub_0F56          ; call Sub_0F56
$1A59  35 10                              PULS X                
$1A5B  20 EF                              BRA Sub_1A4C          

; --------------------------------------------------------------
$1A5D  A6 80               Sub_1A5D:      LDA ,X+               
$1A5F  5A                                 DECB                  
$1A60  81 5E                              CMPA #$5E              ; compare A with '^'
$1A62  27 0E                              BEQ Sub_1A72          
$1A64  81 2A                              CMPA #$2A              ; compare A with '*'
$1A66  27 E9                              BEQ Sub_1A51          
$1A68  81 5C                              CMPA #$5C              ; compare A with '\'
$1A6A  27 02                              BEQ Sub_1A6E          
$1A6C  80 40                              SUBA #$40             
$1A6E  8D 06               Sub_1A6E:      BSR Sub_1A76           ; call Sub_1A76
$1A70  20 DA                              BRA Sub_1A4C          

; --------------------------------------------------------------
$1A72  86 1B               Sub_1A72:      LDA #$1B               ; A = ESC
$1A74  20 F8                              BRA Sub_1A6E          

; --------------------------------------------------------------
$1A76  34 32               Sub_1A76:      PSHS A,X,Y            
$1A78  30 C9 13 A9                        LEAX 5033,U           
$1A7C  A7 84                              STA ,X                
$1A7E  10 8E 00 01                        LDY #$0001            
$1A82  A6 C8 2B                           LDA 43,U              
$1A85  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1A88  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1A8A  34 32               Sub_1A8A:      PSHS A,X,Y            
$1A8C  CC 1B 24                           LDD #$1B24             ; D=ESC+'$'  → W.DWEnd: Device Window End
$1A8F  ED C9 13 A9                        STD 5033,U            
$1A93  86 01                              LDA #$01              
$1A95  10 8E 00 02                        LDY #$0002            
$1A99  30 C9 13 A9                        LEAX 5033,U           
$1A9D  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1AA0  31 8D E9 C5                        LEAY Dat_0469,PC       ; Y → Dat_0469
$1AA4  30 C9 13 A9                        LEAX 5033,U           
$1AA8  C6 0C                              LDB #$0C               ; B = FF
$1AAA  17 12 79                           LBSR Sub_2D26          ; call Sub_2D26
$1AAD  30 C9 13 A9                        LEAX 5033,U           
$1AB1  30 02                              LEAX 2,X              
$1AB3  86 1E                              LDA #$1E              
$1AB5  A7 C9 0C 84         Sub_1AB5:      STA 3204,U            
$1AB9  A7 06                              STA 6,X               
$1ABB  A7 C9 00 91                        STA 145,U             
$1ABF  10 8E 00 0A                        LDY #$000A            
$1AC3  86 01                              LDA #$01              
$1AC5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1AC8  25 0E                              BCS Sub_1AD8           ; C=1 (BLO)
$1ACA  A6 05                              LDA 5,X               
$1ACC  A7 C9 00 90                        STA 144,U             
$1AD0  A6 06                              LDA 6,X               
$1AD2  A7 C9 00 91                        STA 145,U             
$1AD6  35 B2               Sub_1AD6:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
$1AD8  A6 C9 0C 84         Sub_1AD8:      LDA 3204,U            
$1ADC  4A                                 DECA                  
$1ADD  81 0A                              CMPA #$0A              ; compare A with LF
$1ADF  22 05                              BHI Sub_1AE6          
$1AE1  53                                 COMB                  
$1AE2  C6 C3                              LDB #$C3              
$1AE4  20 F0                              BRA Sub_1AD6          

; --------------------------------------------------------------
$1AE6  20 CD               Sub_1AE6:      BRA Sub_1AB5          
$1AE8  30 8D E9 7B         Sub_1AE8:      LEAX Dat_0467,PC       ; X → Dat_0467
$1AEC  86 02                              LDA #$02               ; A = CurXY
$1AEE  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$1AF1  A7 C8 3E                           STA 62,U              
$1AF4  30 8D E9 7F                        LEAX Dat_0477,PC       ; X → Dat_0477
$1AF8  10 8E 00 0A                        LDY #$000A            
$1AFC  A6 C8 3E                           LDA 62,U              
$1AFF  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1B02  39                                 RTS                    ; return from subroutine
; WriteBlock — write count-prefixed block to STDOUT (path=1)
;   LEAX  DataLabel,PC    ; X → FDB count / data payload
;   LBSR  WriteBlock      ; LDY [X]++  OS9 I$Write  path=STDOUT
; 106 callers use this entry.

; --------------------------------------------------------------
; WriteBlock — write count-prefixed block to STDOUT (path=1)
;   LEAX  DataLabel,PC    ; X → FDB count / data payload
;   LBSR  WriteBlock      ; LDY [X]++  OS9 I$Write  path=STDOUT
; 106 callers use this entry.
$1B03  86 01               WriteBlock:    LDA #$01              
; WriteBlockPath — write count-prefixed block to path already in A
;   LDA   #path           ; A = path number
;   LEAX  DataLabel,PC
;   LBSR  WriteBlockPath
; 3 callers use this entry (non-STDOUT paths).
; WriteBlockPath — write count-prefixed block to path already in A
;   LDA   #path           ; A = path number
;   LEAX  DataLabel,PC
;   LBSR  WriteBlockPath
; 3 callers use this entry (non-STDOUT paths).
$1B05  10 AE 81            WriteBlockPath: LDY ,X++              
$1B08  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1B0B  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1B0C  8D 0F               Sub_1B0C:      BSR Sub_1B1D           ; call Sub_1B1D
$1B0E  81 79                              CMPA #$79              ; compare A with 'y'
$1B10  10 27 F3 DB                        LBEQ Sub_0EEF         
$1B14  81 59                              CMPA #$59              ; compare A with 'Y'
$1B16  10 27 F3 D5                        LBEQ Sub_0EEF         
$1B1A  16 F1 41                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$1B1D  34 20               Sub_1B1D:      PSHS Y                
$1B1F  CC 1D 04                           LDD #$1D04            
$1B22  ED C9 0C 8F                        STD 3215,U            
$1B26  CC 16 03                           LDD #$1603            
$1B29  ED C9 0C 91                        STD 3217,U            
$1B2D  17 01 51                           LBSR Sub_1C81          ; call Sub_1C81
$1B30  30 8D E9 65                        LEAX Dat_0499,PC       ; X → Dat_0499
$1B34  8D CD                              BSR WriteBlock         ; call WriteBlock
$1B36  30 8D E9 55                        LEAX Dat_048F,PC       ; X → Dat_048F
$1B3A  8D C7                              BSR WriteBlock         ; call WriteBlock
$1B3C  17 0F 7D                           LBSR Sub_2ABC          ; call Sub_2ABC
$1B3F  34 02                              PSHS A                
$1B41  30 8D E9 46                        LEAX Dat_048B,PC       ; X → Dat_048B
$1B45  8D BC                              BSR WriteBlock         ; call WriteBlock
$1B47  17 01 94                           LBSR Sub_1CDE          ; call Sub_1CDE
$1B4A  35 02                              PULS A                
$1B4C  35 A0                              PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1B4E  34 14               Sub_1B4E:      PSHS B,X              
$1B50  30 C9 0C 99                        LEAX 3225,U           
$1B54  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$1B57  A6 05                              LDA 5,X               
$1B59  8E 00 02                           LDX #$0002            
$1B5C  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1B5F  35 94                              PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1B61  34 36               Sub_1B61:      PSHS A,B,X,Y          
$1B63  6F C8 1C                           CLR 28,U              
$1B66  6F C8 1D                           CLR 29,U              
$1B69  6F C8 21                           CLR 33,U              
$1B6C  30 C9 06 0E                        LEAX 1550,U           
$1B70  17 0F 49            Sub_1B70:      LBSR Sub_2ABC          ; call Sub_2ABC
$1B73  81 2D                              CMPA #$2D              ; compare A with '-'
$1B75  23 0E                              BLS Sub_1B85          
$1B77  5D                                 TSTB                  
$1B78  27 F6                              BEQ Sub_1B70          
$1B7A  A7 80                              STA ,X+               
$1B7C  5A                                 DECB                  
$1B7D  6C C8 1D                           INC 29,U              
$1B80  17 03 88                           LBSR Sub_1F0B          ; call Sub_1F0B
$1B83  20 EB                              BRA Sub_1B70          

; --------------------------------------------------------------
$1B85  81 08               Sub_1B85:      CMPA #$08              ; compare A with BS
$1B87  26 10                              BNE Sub_1B99          
$1B89  6D C8 1D                           TST 29,U              
$1B8C  27 E2                              BEQ Sub_1B70          
$1B8E  5C                                 INCB                  
$1B8F  6A C8 1D                           DEC 29,U              
$1B92  30 1F                              LEAX -1,X             
$1B94  17 03 74                           LBSR Sub_1F0B          ; call Sub_1F0B
$1B97  20 D7                              BRA Sub_1B70          

; --------------------------------------------------------------
$1B99  81 05               Sub_1B99:      CMPA #$05             
$1B9B  26 05                              BNE Sub_1BA2          
$1B9D  6C C8 21                           INC 33,U              
$1BA0  20 09                              BRA Sub_1BAB          

; --------------------------------------------------------------
$1BA2  81 0D               Sub_1BA2:      CMPA #$0D              ; compare A with CR
$1BA4  26 CA                              BNE Sub_1B70          
$1BA6  A7 84                              STA ,X                
$1BA8  6C C8 1D                           INC 29,U              
$1BAB  35 B6               Sub_1BAB:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$1BAD  86 00               Sub_1BAD:      LDA #$00               ; A = NUL
$1BAF  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$1BB1  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1BB4  24 01                              BCC Sub_1BB7           ; C=0 (BHS)
$1BB6  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1BB7  5D                  Sub_1BB7:      TSTB                  
$1BB8  27 0C                              BEQ Sub_1BC6          
$1BBA  4F                                 CLRA                   ; A = 0
$1BBB  1F 02                              TFR D,Y               
$1BBD  30 C9 13 A9                        LEAX 5033,U           
$1BC1  86 00                              LDA #$00               ; A = NUL
$1BC3  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$1BC6  39                  Sub_1BC6:      RTS                    ; return from subroutine
$1BC7  34 16               Sub_1BC7:      PSHS A,B,X            
$1BC9  C6 08                              LDB #$08               ; B = BS
$1BCB  30 C9 0D 1C                        LEAX 3356,U           
$1BCF  86 0D                              LDA #$0D               ; A = CR
$1BD1  A7 84               Sub_1BD1:      STA ,X                
$1BD3  A7 01                              STA 1,X               
$1BD5  30 89 00 80                        LEAX 128,X            
$1BD9  5A                                 DECB                  
$1BDA  26 F5                              BNE Sub_1BD1          
$1BDC  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1BDE  39                  Sub_1BDE:      RTS                    ; return from subroutine
$1BDF  A6 C8 65            Sub_1BDF:      LDA BSS.BufPtr3,U     
$1BE2  81 02                              CMPA #$02              ; compare A with CurXY
$1BE4  26 06                              BNE Sub_1BEC          
$1BE6  31 8D E7 87                        LEAY Dat_0371,PC       ; Y → Dat_0371
$1BEA  20 2A                              BRA Sub_1C16          

; --------------------------------------------------------------
$1BEC  6D C9 0C A6         Sub_1BEC:      TST 3238,U            
$1BF0  26 20                              BNE Sub_1C12          
$1BF2  31 8D E7 9B                        LEAY Dat_0391,PC       ; Y → Dat_0391
$1BF6  CC 06 01                           LDD #$0601            
$1BF9  ED C9 00 85                        STD 133,U             
$1BFD  CC 00 02                           LDD #$0002            
$1C00  ED C9 00 87                        STD 135,U             
$1C04  CC 07 04                           LDD #$0704            
$1C07  DD 89                              STD <$89              
$1C09  CC 03 05                           LDD #$0305            
$1C0C  ED C9 00 8B                        STD 139,U             
$1C10  20 1E                              BRA Sub_1C30          

; --------------------------------------------------------------
$1C12  31 8D E7 6B         Sub_1C12:      LEAY Dat_0381,PC       ; Y → Dat_0381
$1C16  CC 05 04            Sub_1C16:      LDD #$0504            
$1C19  ED C9 00 85                        STD 133,U             
$1C1D  CC 07 00                           LDD #$0700            
$1C20  DD 87                              STD <$87              
$1C22  CC 06 01                           LDD #$0601            
$1C25  ED C9 00 89                        STD 137,U             
$1C29  CC 02 03                           LDD #$0203            
$1C2C  ED C9 00 8B                        STD 139,U             
$1C30  30 C9 13 A9         Sub_1C30:      LEAX 5033,U           
$1C34  CC 1B 31                           LDD #$1B31             ; D=ESC+$31
$1C37  ED 84                              STD ,X                
$1C39  4F                                 CLRA                   ; A = 0
$1C3A  E6 A6               Sub_1C3A:      LDB A,Y               
$1C3C  34 22                              PSHS A,Y              
$1C3E  ED 02                              STD 2,X               
$1C40  10 8E 00 04                        LDY #$0004            
$1C44  86 01                              LDA #$01              
$1C46  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1C49  35 22                              PULS A,Y              
$1C4B  4C                                 INCA                  
$1C4C  81 10                              CMPA #$10             
$1C4E  25 EA                              BCS Sub_1C3A           ; C=1 (BLO)
$1C50  17 0F C5                           LBSR Sub_2C18          ; call Sub_2C18
$1C53  17 0F 30                           LBSR Sub_2B86          ; call Sub_2B86
$1C56  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1C57  34 12               Sub_1C57:      PSHS A,X              
$1C59  A6 C8 65                           LDA BSS.BufPtr3,U     
$1C5C  81 02                              CMPA #$02              ; compare A with CurXY
$1C5E  27 0C                              BEQ Sub_1C6C          
$1C60  6D C9 0C A6                        TST 3238,U            
$1C64  26 06                              BNE Sub_1C6C          
$1C66  30 8D E7 3A                        LEAX Dat_03A4,PC       ; X → Dat_03A4
$1C6A  20 04                              BRA Sub_1C70          

; --------------------------------------------------------------
$1C6C  30 8D E7 31         Sub_1C6C:      LEAX Dat_03A1,PC       ; X → Dat_03A1
$1C70  A6 84               Sub_1C70:      LDA ,X                
$1C72  17 06 D2                           LBSR Sub_2347          ; call Sub_2347
$1C75  A6 01                              LDA 1,X               
$1C77  17 06 C1                           LBSR Sub_233B          ; call Sub_233B
$1C7A  A6 02                              LDA 2,X               
$1C7C  17 06 C2                           LBSR Sub_2341          ; call Sub_2341
$1C7F  35 92                              PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1C81  34 36               Sub_1C81:      PSHS A,B,X,Y          
$1C83  30 C9 13 A9                        LEAX 5033,U           
$1C87  CC 1B 22                           LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
$1C8A  ED 84                              STD ,X                
$1C8C  86 01                              LDA #$01              
$1C8E  A7 02                              STA 2,X               
$1C90  EC C9 0C 8F                        LDD 3215,U            
$1C94  8B 01                              ADDA #$01             
$1C96  CB 01                              ADDB #$01             
$1C98  ED 03                              STD 3,X               
$1C9A  EC C9 0C 91                        LDD 3217,U            
$1C9E  ED 05                              STD 5,X               
$1CA0  E6 C9 00 85                        LDB 133,U             
$1CA4  4F                                 CLRA                   ; A = 0
$1CA5  ED 07                              STD 7,X               
$1CA7  86 01                              LDA #$01              
$1CA9  10 8E 00 09                        LDY #$0009            
$1CAD  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1CB0  CC 1B 22                           LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
$1CB3  ED 84                              STD ,X                
$1CB5  86 01                              LDA #$01              
$1CB7  A7 02                              STA 2,X               
$1CB9  EC C9 0C 8F                        LDD 3215,U            
$1CBD  ED 03                              STD 3,X               
$1CBF  EC C9 0C 91                        LDD 3217,U            
$1CC3  ED 05                              STD 5,X               
$1CC5  A6 C9 00 87                        LDA 135,U             
$1CC9  E6 C9 00 86                        LDB 134,U             
$1CCD  ED 07                              STD 7,X               
$1CCF  86 0C                              LDA #$0C               ; A = FF
$1CD1  A7 09                              STA 9,X               
$1CD3  86 01                              LDA #$01              
$1CD5  10 8E 00 0A                        LDY #$000A            
$1CD9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1CDC  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1CDE  34 36               Sub_1CDE:      PSHS A,B,X,Y          
$1CE0  30 C9 13 A9                        LEAX 5033,U           
$1CE4  CC 1B 23                           LDD #$1B23             ; D=ESC+'#'  → W.OWEnd: Overlay Window End
$1CE7  ED 84                              STD ,X                
$1CE9  86 01                              LDA #$01              
$1CEB  10 8E 00 02                        LDY #$0002            
$1CEF  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1CF2  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1CF5  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1CF7  34 36               Sub_1CF7:      PSHS A,B,X,Y          
$1CF9  8E 10 03                           LDX #$1003            
$1CFC  10 8E 0E A0                        LDY #$0EA0            
$1D00  86 01               Sub_1D00:      LDA #$01              
$1D02  C6 98                              LDB #$98              
$1D04  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1D07  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1D09  34 36               Sub_1D09:      PSHS A,B,X,Y          
$1D0B  8E 3F 03                           LDX #$3F03            
$1D0E  10 8E 0F D1                        LDY #$0FD1            
$1D12  20 EC                              BRA Sub_1D00          

; --------------------------------------------------------------
$1D14  34 16               Sub_1D14:      PSHS A,B,X            
$1D16  C6 1D                              LDB #$1D              
$1D18  A6 C8 2B                           LDA 43,U              
$1D1B  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1D1E  24 0D                              BCC Sub_1D2D           ; C=0 (BHS)
$1D20  AE C8 11                           LDX 17,U              
$1D23  A6 02                              LDA 2,X               
$1D25  8A 0C                              ORA #$0C              
$1D27  A7 02                              STA 2,X               
$1D29  94 F3                              ANDA <$F3             
$1D2B  A7 02                              STA 2,X               
$1D2D  35 96               Sub_1D2D:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$1D2F  34 36               Sub_1D2F:      PSHS A,B,X,Y          
$1D31  30 8D E7 5A                        LEAX Dat_048F,PC       ; X → Dat_048F
$1D35  17 FD CB                           LBSR WriteBlock        ; call WriteBlock
$1D38  CC 1E 03                           LDD #$1E03            
$1D3B  ED C9 0C 8F                        STD 3215,U            
$1D3F  CC 12 03                           LDD #$1203            
$1D42  ED C9 0C 91                        STD 3217,U            
$1D46  17 FF 38                           LBSR Sub_1C81          ; call Sub_1C81
$1D49  30 8D E8 F0                        LEAX Dat_063D,PC       ; X → Dat_063D
$1D4D  17 FD B3                           LBSR WriteBlock        ; call WriteBlock
$1D50  E6 C9 0C A5                        LDB 3237,U            
$1D54  C4 07                              ANDB #$07             
$1D56  E7 C9 0C 84         Sub_1D56:      STB 3204,U            
$1D5A  30 8D E6 6C                        LEAX Dat_03CA,PC       ; X → Dat_03CA
$1D5E  10 8E 00 05                        LDY #$0005            
$1D62  86 01                              LDA #$01              
$1D64  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D67  30 8D E8 E7                        LEAX Dat_0652,PC       ; X → Dat_0652
$1D6B  86 05                              LDA #$05              
$1D6D  E6 C9 0C 84                        LDB 3204,U            
$1D71  3D                                 MUL                    ; D = A×B unsigned
$1D72  30 8B                              LEAX D,X              
$1D74  86 01                              LDA #$01              
$1D76  10 8E 00 05                        LDY #$0005            
$1D7A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D7D  17 0D 3C            Sub_1D7D:      LBSR Sub_2ABC          ; call Sub_2ABC
$1D80  81 0D                              CMPA #$0D              ; compare A with CR
$1D82  27 17                              BEQ Sub_1D9B          
$1D84  81 05                              CMPA #$05             
$1D86  27 13                              BEQ Sub_1D9B          
$1D88  81 20                              CMPA #$20              ; compare A with ' '
$1D8A  26 F1                              BNE Sub_1D7D          
$1D8C  6C C9 0C 84                        INC 3204,U            
$1D90  E6 C9 0C 84                        LDB 3204,U            
$1D94  C1 08                              CMPB #$08              ; compare B with BS
$1D96  26 BE                              BNE Sub_1D56          
$1D98  5F                                 CLRB                   ; B = 0
$1D99  20 BB                              BRA Sub_1D56          

; --------------------------------------------------------------
$1D9B  E6 C9 0C A5         Sub_1D9B:      LDB 3237,U            
$1D9F  C4 F8                              ANDB #$F8             
$1DA1  EA C9 0C 84                        ORB 3204,U            
$1DA5  E7 C9 0C A5                        STB 3237,U            
$1DA9  17 FF 32                           LBSR Sub_1CDE          ; call Sub_1CDE
$1DAC  17 F3 E0                           LBSR Sub_118F          ; call Sub_118F
$1DAF  30 8D E6 D8                        LEAX Dat_048B,PC       ; X → Dat_048B
$1DB3  17 FD 4D                           LBSR WriteBlock        ; call WriteBlock
$1DB6  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1DB8  34 32               Sub_1DB8:      PSHS A,X,Y            
$1DBA  6F C9 00 99                        CLR 153,U             
$1DBE  E7 C9 0C 84                        STB 3204,U            
$1DC2  30 C9 13 A9                        LEAX 5033,U           
$1DC6  CC 1B 25                           LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
$1DC9  ED 84                              STD ,X                
$1DCB  CC 01 02                           LDD #$0102            
$1DCE  ED 02                              STD 2,X               
$1DD0  86 04                              LDA #$04              
$1DD2  E6 C9 13 9E                        LDB 5022,U            
$1DD6  5C                                 INCB                  
$1DD7  ED 04                              STD 4,X               
$1DD9  86 01                              LDA #$01              
$1DDB  10 8E 00 06                        LDY #$0006            
$1DDF  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1DE2  E6 C9 0C 84                        LDB 3204,U            
$1DE6  4F                  Sub_1DE6:      CLRA                   ; A = 0
$1DE7  5C                                 INCB                  
$1DE8  1F 02                              TFR D,Y               
$1DEA  30 8D E8 9A                        LEAX Dat_0688,PC       ; X → Dat_0688
$1DEE  86 01                              LDA #$01              
$1DF0  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1DF3  30 8D E8 9C                        LEAX Dat_0693,PC       ; X → Dat_0693
$1DF7  10 8E 00 03                        LDY #$0003            
$1DFB  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1DFE  17 0C C4            Sub_1DFE:      LBSR Sub_2AC5          ; call Sub_2AC5
$1E01  84 7F                              ANDA #$7F             
$1E03  81 0A                              CMPA #$0A              ; compare A with LF
$1E05  27 12                              BEQ Sub_1E19          
$1E07  81 0C                              CMPA #$0C              ; compare A with FF
$1E09  27 20                              BEQ Sub_1E2B          
$1E0B  81 20                              CMPA #$20              ; compare A with ' '
$1E0D  27 2A                              BEQ Sub_1E39          
$1E0F  81 05                              CMPA #$05             
$1E11  27 2C                              BEQ Sub_1E3F          
$1E13  81 0D                              CMPA #$0D              ; compare A with CR
$1E15  27 33                              BEQ Sub_1E4A          
$1E17  20 E5                              BRA Sub_1DFE          

; --------------------------------------------------------------
$1E19  E6 C9 0C 84         Sub_1E19:      LDB 3204,U            
$1E1D  5C                                 INCB                  
$1E1E  E1 C9 13 9E                        CMPB 5022,U           
$1E22  25 01                              BCS Sub_1E25           ; C=1 (BLO)
$1E24  5F                                 CLRB                   ; B = 0
$1E25  E7 C9 0C 84         Sub_1E25:      STB 3204,U            
$1E29  20 BB                              BRA Sub_1DE6          

; --------------------------------------------------------------
$1E2B  E6 C9 0C 84         Sub_1E2B:      LDB 3204,U            
$1E2F  5A                                 DECB                  
$1E30  2A 05                              BPL Sub_1E37          
$1E32  E6 C9 13 9E                        LDB 5022,U            
$1E36  5A                                 DECB                  
$1E37  20 EC               Sub_1E37:      BRA Sub_1E25          
$1E39  E6 C9 0C 84         Sub_1E39:      LDB 3204,U            
$1E3D  35 B2               Sub_1E3D:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
$1E3F  E6 C9 13 9E         Sub_1E3F:      LDB 5022,U            
$1E43  5C                                 INCB                  
$1E44  E7 C9 0C 84                        STB 3204,U            
$1E48  20 F3                              BRA Sub_1E3D          

; --------------------------------------------------------------
$1E4A  6C C9 00 99         Sub_1E4A:      INC 153,U             
$1E4E  20 E9                              BRA Sub_1E39          

; --------------------------------------------------------------
$1E50  34 36               Sub_1E50:      PSHS A,B,X,Y          
$1E52  30 8D E6 39                        LEAX Dat_048F,PC       ; X → Dat_048F
$1E56  17 FC AA                           LBSR WriteBlock        ; call WriteBlock
$1E59  CC 1C 03                           LDD #$1C03            
$1E5C  ED C9 0C 8F                        STD 3215,U            
$1E60  CC 17 03                           LDD #$1703            
$1E63  ED C9 0C 91                        STD 3217,U            
$1E67  17 FE 17                           LBSR Sub_1C81          ; call Sub_1C81
$1E6A  30 8D E8 28                        LEAX Dat_0696,PC       ; X → Dat_0696
$1E6E  17 FC 92                           LBSR WriteBlock        ; call WriteBlock
$1E71  E6 C9 0C A6                        LDB 3238,U            
$1E75  E7 C9 0C 84         Sub_1E75:      STB 3204,U            
$1E79  30 8D E5 4D                        LEAX Dat_03CA,PC       ; X → Dat_03CA
$1E7D  86 01                              LDA #$01              
$1E7F  10 8E 00 05                        LDY #$0005            
$1E83  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1E86  30 8D E8 26                        LEAX Dat_06B0,PC       ; X → Dat_06B0
$1E8A  86 05                              LDA #$05              
$1E8C  E6 C9 0C 84                        LDB 3204,U            
$1E90  3D                                 MUL                    ; D = A×B unsigned
$1E91  30 8B                              LEAX D,X              
$1E93  10 8E 00 05                        LDY #$0005            
$1E97  86 01                              LDA #$01              
$1E99  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1E9C  17 0C 1D            Sub_1E9C:      LBSR Sub_2ABC          ; call Sub_2ABC
$1E9F  81 0D                              CMPA #$0D              ; compare A with CR
$1EA1  27 17                              BEQ Sub_1EBA          
$1EA3  81 05                              CMPA #$05             
$1EA5  27 13                              BEQ Sub_1EBA          
$1EA7  81 20                              CMPA #$20              ; compare A with ' '
$1EA9  26 F1                              BNE Sub_1E9C          
$1EAB  6C C9 0C 84                        INC 3204,U            
$1EAF  E6 C9 0C 84                        LDB 3204,U            
$1EB3  C1 03                              CMPB #$03             
$1EB5  26 BE                              BNE Sub_1E75          
$1EB7  5F                                 CLRB                   ; B = 0
$1EB8  20 BB                              BRA Sub_1E75          

; --------------------------------------------------------------
$1EBA  E6 C9 0C 84         Sub_1EBA:      LDB 3204,U            
$1EBE  E7 C9 0C A6                        STB 3238,U            
$1EC2  17 FD 1A                           LBSR Sub_1BDF          ; call Sub_1BDF
$1EC5  17 FE 16                           LBSR Sub_1CDE          ; call Sub_1CDE
$1EC8  17 FD 8C                           LBSR Sub_1C57          ; call Sub_1C57
$1ECB  8D 0F                              BSR Sub_1EDC           ; call Sub_1EDC
$1ECD  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1ECE  40                                 NEGA                  
$1ECF  27 02                              BEQ Sub_1ED3          
$1ED1  8D 12                              BSR Sub_1EE5           ; call Sub_1EE5
$1ED3  30 8D E5 B4         Sub_1ED3:      LEAX Dat_048B,PC       ; X → Dat_048B
$1ED7  17 FC 29                           LBSR WriteBlock        ; call WriteBlock
$1EDA  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1EDC  34 02               Sub_1EDC:      PSHS A                
$1EDE  86 0C                              LDA #$0C               ; A = FF
$1EE0  17 00 28                           LBSR Sub_1F0B          ; call Sub_1F0B
$1EE3  35 82                              PULS A,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1EE5  34 36               Sub_1EE5:      PSHS A,B,X,Y          
$1EE7  30 C9 13 A9                        LEAX 5033,U           
$1EEB  CC 1B 25                           LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
$1EEE  ED 84                              STD ,X                
$1EF0  CC 00 00                           LDD #$0000            
$1EF3  ED 02                              STD 2,X               
$1EF5  CC 50 03                           LDD #$5003            
$1EF8  ED 04                              STD 4,X               
$1EFA  86 01                              LDA #$01              
$1EFC  A7 06                              STA 6,X               
$1EFE  10 8E 00 07                        LDY #$0007            
$1F02  A6 C8 3F                           LDA 63,U              
$1F05  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F08  16 07 82                           LBRA Sub_268D         

; --------------------------------------------------------------
$1F0B  34 36               Sub_1F0B:      PSHS A,B,X,Y          
$1F0D  30 C8 1B                           LEAX 27,U             
$1F10  A7 84                              STA ,X                
$1F12  10 8E 00 01                        LDY #$0001            
$1F16  86 01                              LDA #$01              
$1F18  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F1B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1F1D  34 36               Sub_1F1D:      PSHS A,B,X,Y          
$1F1F  30 8D E5 6C                        LEAX Dat_048F,PC       ; X → Dat_048F
$1F23  17 FB DD                           LBSR WriteBlock        ; call WriteBlock
$1F26  CC 1F 03                           LDD #$1F03            
$1F29  ED C9 0C 8F                        STD 3215,U            
$1F2D  CC 16 0E                           LDD #$160E            
$1F30  ED C9 0C 91                        STD 3217,U            
$1F34  17 FD 4A                           LBSR Sub_1C81          ; call Sub_1C81
$1F37  30 8D E8 E6                        LEAX Dat_0821,PC       ; X → Dat_0821
$1F3B  17 FB C5                           LBSR WriteBlock        ; call WriteBlock
$1F3E  17 01 9A                           LBSR Sub_20DB          ; call Sub_20DB
$1F41  17 01 C4                           LBSR Sub_2108          ; call Sub_2108
$1F44  17 01 D1                           LBSR Sub_2118          ; call Sub_2118
$1F47  17 01 AE                           LBSR Sub_20F8          ; call Sub_20F8
$1F4A  17 02 88                           LBSR Sub_21D5          ; call Sub_21D5
$1F4D  17 02 24                           LBSR Sub_2174          ; call Sub_2174
$1F50  17 02 66                           LBSR Sub_21B9          ; call Sub_21B9
$1F53  17 01 D2                           LBSR Sub_2128          ; call Sub_2128
$1F56  17 01 DF                           LBSR Sub_2138          ; call Sub_2138
$1F59  17 01 EC                           LBSR Sub_2148          ; call Sub_2148
$1F5C  17 01 F9                           LBSR Sub_2158          ; call Sub_2158
$1F5F  86 0B                              LDA #$0B              
$1F61  A7 C9 13 9E                        STA 5022,U            
$1F65  5F                                 CLRB                   ; B = 0
$1F66  17 FE 4F            Sub_1F66:      LBSR Sub_1DB8          ; call Sub_1DB8
$1F69  30 C9 13 A9                        LEAX 5033,U           
$1F6D  CC 1B 25                           LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
$1F70  ED 84                              STD ,X                
$1F72  CC 00 00                           LDD #$0000            
$1F75  ED 02                              STD 2,X               
$1F77  CC 16 0E                           LDD #$160E            
$1F7A  ED 04                              STD 4,X               
$1F7C  10 8E 00 06                        LDY #$0006            
$1F80  86 01                              LDA #$01              
$1F82  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F85  6D C9 00 99                        TST 153,U             
$1F89  10 26 01 42                        LBNE Sub_20CF         
$1F8D  E6 C9 0C 84                        LDB 3204,U            
$1F91  C1 0A                              CMPB #$0A              ; compare B with LF
$1F93  10 22 01 38                        LBHI Sub_20CF         
$1F97  C1 00                              CMPB #$00              ; compare B with NUL
$1F99  26 10                              BNE Sub_1FAB          
$1F9B  A6 C9 0C A7                        LDA 3239,U            
$1F9F  26 06                              BNE Sub_1FA7          
$1FA1  6C C9 0C A7                        INC 3239,U            
$1FA5  20 04                              BRA Sub_1FAB          

; --------------------------------------------------------------
$1FA7  6F C9 0C A7         Sub_1FA7:      CLR 3239,U            
$1FAB  17 01 2D            Sub_1FAB:      LBSR Sub_20DB          ; call Sub_20DB
$1FAE  C1 03                              CMPB #$03             
$1FB0  26 10                              BNE Sub_1FC2          
$1FB2  A6 C9 0C AA                        LDA 3242,U            
$1FB6  26 06                              BNE Sub_1FBE          
$1FB8  6C C9 0C AA                        INC 3242,U            
$1FBC  20 04                              BRA Sub_1FC2          

; --------------------------------------------------------------
$1FBE  6F C9 0C AA         Sub_1FBE:      CLR 3242,U            
$1FC2  17 01 33            Sub_1FC2:      LBSR Sub_20F8          ; call Sub_20F8
$1FC5  C1 07                              CMPB #$07             
$1FC7  26 10                              BNE Sub_1FD9          
$1FC9  A6 C9 0C B1                        LDA 3249,U            
$1FCD  26 06                              BNE Sub_1FD5          
$1FCF  6C C9 0C B1                        INC 3249,U            
$1FD3  20 04                              BRA Sub_1FD9          

; --------------------------------------------------------------
$1FD5  6F C9 0C B1         Sub_1FD5:      CLR 3249,U            
$1FD9  17 01 4C            Sub_1FD9:      LBSR Sub_2128          ; call Sub_2128
$1FDC  17 F1 B0                           LBSR Sub_118F          ; call Sub_118F
$1FDF  C1 05                              CMPB #$05             
$1FE1  26 29                              BNE Sub_200C          
$1FE3  A6 C9 0C AC                        LDA 3244,U            
$1FE7  84 E0                              ANDA #$E0             
$1FE9  81 00                              CMPA #$00              ; compare A with NUL
$1FEB  27 24                              BEQ Sub_2011          
$1FED  81 E0                              CMPA #$E0             
$1FEF  27 24                              BEQ Sub_2015          
$1FF1  8B 40                              ADDA #$40             
$1FF3  34 04               Sub_1FF3:      PSHS B                
$1FF5  E6 C9 0C AC                        LDB 3244,U            
$1FF9  C4 1F                              ANDB #$1F             
$1FFB  E7 C9 0C AC                        STB 3244,U            
$1FFF  35 04                              PULS B                
$2001  AA C9 0C AC                        ORA 3244,U            
$2005  A7 C9 0C AC                        STA 3244,U            
$2009  17 F1 83                           LBSR Sub_118F          ; call Sub_118F
$200C  17 01 65            Sub_200C:      LBSR Sub_2174          ; call Sub_2174
$200F  20 07                              BRA Sub_2018          

; --------------------------------------------------------------
$2011  8B 20               Sub_2011:      ADDA #$20             
$2013  20 DE                              BRA Sub_1FF3          

; --------------------------------------------------------------
$2015  4F                  Sub_2015:      CLRA                   ; A = 0
$2016  20 DB                              BRA Sub_1FF3          

; --------------------------------------------------------------
$2018  C1 06               Sub_2018:      CMPB #$06             
$201A  26 16                              BNE Sub_2032          
$201C  A6 C9 0C A5                        LDA 3237,U            
$2020  2A 04                              BPL Sub_2026          
$2022  84 7F                              ANDA #$7F             
$2024  20 02                              BRA Sub_2028          

; --------------------------------------------------------------
$2026  8A 80               Sub_2026:      ORA #$80              
$2028  A7 C9 0C A5         Sub_2028:      STA 3237,U            
$202C  17 F1 60                           LBSR Sub_118F          ; call Sub_118F
$202F  17 01 87                           LBSR Sub_21B9          ; call Sub_21B9
$2032  C1 04               Sub_2032:      CMPB #$04             
$2034  26 18                              BNE Sub_204E          
$2036  A6 C9 0C A5                        LDA 3237,U            
$203A  85 20                              BITA #$20             
$203C  27 04                              BEQ Sub_2042          
$203E  84 DF                              ANDA #$DF             
$2040  20 02                              BRA Sub_2044          

; --------------------------------------------------------------
$2042  8A 20               Sub_2042:      ORA #$20              
$2044  A7 C9 0C A5         Sub_2044:      STA 3237,U            
$2048  17 F1 44                           LBSR Sub_118F          ; call Sub_118F
$204B  17 01 87                           LBSR Sub_21D5          ; call Sub_21D5
$204E  C1 01               Sub_204E:      CMPB #$01             
$2050  26 10                              BNE Sub_2062          
$2052  A6 C9 0C A8                        LDA 3240,U            
$2056  26 06                              BNE Sub_205E          
$2058  6C C9 0C A8                        INC 3240,U            
$205C  20 04                              BRA Sub_2062          

; --------------------------------------------------------------
$205E  6F C9 0C A8         Sub_205E:      CLR 3240,U            
$2062  17 00 A3            Sub_2062:      LBSR Sub_2108          ; call Sub_2108
$2065  C1 02                              CMPB #$02              ; compare B with CurXY
$2067  26 13                              BNE Sub_207C          
$2069  A6 C9 0C A9                        LDA 3241,U            
$206D  26 06                              BNE Sub_2075          
$206F  6C C9 0C A9                        INC 3241,U            
$2073  20 07                              BRA Sub_207C          

; --------------------------------------------------------------
$2075  6F C9 0C A9         Sub_2075:      CLR 3241,U            
$2079  17 F1 13                           LBSR Sub_118F          ; call Sub_118F
$207C  17 00 99            Sub_207C:      LBSR Sub_2118          ; call Sub_2118
$207F  C1 08                              CMPB #$08              ; compare B with BS
$2081  26 10                              BNE Sub_2093          
$2083  6D C9 0C AB                        TST 3243,U            
$2087  26 06                              BNE Sub_208F          
$2089  6C C9 0C AB                        INC 3243,U            
$208D  20 04                              BRA Sub_2093          

; --------------------------------------------------------------
$208F  6F C9 0C AB         Sub_208F:      CLR 3243,U            
$2093  17 00 C2            Sub_2093:      LBSR Sub_2158          ; call Sub_2158
$2096  C1 09                              CMPB #$09             
$2098  26 10                              BNE Sub_20AA          
$209A  6D C9 0C AE                        TST 3246,U            
$209E  26 06                              BNE Sub_20A6          
$20A0  6C C9 0C AE                        INC 3246,U            
$20A4  20 04                              BRA Sub_20AA          

; --------------------------------------------------------------
$20A6  6F C9 0C AE         Sub_20A6:      CLR 3246,U            
$20AA  17 00 9B            Sub_20AA:      LBSR Sub_2148          ; call Sub_2148
$20AD  C1 0A                              CMPB #$0A              ; compare B with LF
$20AF  26 10                              BNE Sub_20C1          
$20B1  6D C9 0C AD                        TST 3245,U            
$20B5  26 06                              BNE Sub_20BD          
$20B7  6C C9 0C AD                        INC 3245,U            
$20BB  20 04                              BRA Sub_20C1          

; --------------------------------------------------------------
$20BD  6F C9 0C AD         Sub_20BD:      CLR 3245,U            
$20C1  17 00 74            Sub_20C1:      LBSR Sub_2138          ; call Sub_2138
$20C4  C1 0A                              CMPB #$0A              ; compare B with LF
$20C6  22 07                              BHI Sub_20CF          
$20C8  E6 C9 0C 84                        LDB 3204,U            
$20CC  16 FE 97                           LBRA Sub_1F66         

; --------------------------------------------------------------
$20CF  17 FC 0C            Sub_20CF:      LBSR Sub_1CDE          ; call Sub_1CDE
$20D2  30 8D E3 B5                        LEAX Dat_048B,PC       ; X → Dat_048B
$20D6  17 FA 2A                           LBSR WriteBlock        ; call WriteBlock
$20D9  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$20DB  34 16               Sub_20DB:      PSHS A,B,X            
$20DD  CC 11 02                           LDD #$1102            
$20E0  17 01 B1                           LBSR Sub_2294          ; call Sub_2294
$20E3  A6 C9 0C A7                        LDA 3239,U            
$20E7  26 09                              BNE Sub_20F2          
$20E9  30 8D E8 98         Sub_20E9:      LEAX Dat_0985,PC       ; X → Dat_0985
$20ED  17 FA 13            Sub_20ED:      LBSR WriteBlock        ; call WriteBlock
$20F0  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$20F2  30 8D E8 95         Sub_20F2:      LEAX Dat_098B,PC       ; X → Dat_098B
$20F6  20 F5                              BRA Sub_20ED          

; --------------------------------------------------------------
$20F8  34 16               Sub_20F8:      PSHS A,B,X            
$20FA  CC 11 05                           LDD #$1105            
$20FD  17 01 94                           LBSR Sub_2294          ; call Sub_2294
$2100  A6 C9 0C AA                        LDA 3242,U            
$2104  26 EC                              BNE Sub_20F2          
$2106  20 E1                              BRA Sub_20E9          

; --------------------------------------------------------------
$2108  34 16               Sub_2108:      PSHS A,B,X            
$210A  CC 11 03                           LDD #$1103            
$210D  17 01 84                           LBSR Sub_2294          ; call Sub_2294
$2110  A6 C9 0C A8                        LDA 3240,U            
$2114  26 DC                              BNE Sub_20F2          
$2116  20 D1                              BRA Sub_20E9          

; --------------------------------------------------------------
$2118  34 16               Sub_2118:      PSHS A,B,X            
$211A  CC 11 04                           LDD #$1104            
$211D  17 01 74                           LBSR Sub_2294          ; call Sub_2294
$2120  A6 C9 0C A9                        LDA 3241,U            
$2124  26 CC                              BNE Sub_20F2          
$2126  20 C1                              BRA Sub_20E9          

; --------------------------------------------------------------
$2128  34 16               Sub_2128:      PSHS A,B,X            
$212A  CC 11 09                           LDD #$1109            
$212D  17 01 64                           LBSR Sub_2294          ; call Sub_2294
$2130  A6 C9 0C B1                        LDA 3249,U            
$2134  26 BC                              BNE Sub_20F2          
$2136  20 B1                              BRA Sub_20E9          

; --------------------------------------------------------------
$2138  34 16               Sub_2138:      PSHS A,B,X            
$213A  CC 11 0C                           LDD #$110C            
$213D  17 01 54                           LBSR Sub_2294          ; call Sub_2294
$2140  A6 C9 0C AD                        LDA 3245,U            
$2144  26 AC                              BNE Sub_20F2          
$2146  20 A1                              BRA Sub_20E9          

; --------------------------------------------------------------
$2148  34 16               Sub_2148:      PSHS A,B,X            
$214A  CC 11 0B                           LDD #$110B            
$214D  17 01 44                           LBSR Sub_2294          ; call Sub_2294
$2150  A6 C9 0C AE                        LDA 3246,U            
$2154  27 9C                              BEQ Sub_20F2          
$2156  20 91                              BRA Sub_20E9          

; --------------------------------------------------------------
$2158  34 16               Sub_2158:      PSHS A,B,X            
$215A  CC 11 0A                           LDD #$110A            
$215D  17 01 34                           LBSR Sub_2294          ; call Sub_2294
$2160  A6 C9 0C AB                        LDA 3243,U            
$2164  26 07                              BNE Sub_216D          
$2166  30 8D E8 0F                        LEAX Dat_0979,PC       ; X → Dat_0979
$216A  16 FF 80                           LBRA Sub_20ED         

; --------------------------------------------------------------
$216D  30 8D E8 0E         Sub_216D:      LEAX Dat_097F,PC       ; X → Dat_097F
$2171  16 FF 79                           LBRA Sub_20ED         

; --------------------------------------------------------------
$2174  34 36               Sub_2174:      PSHS A,B,X,Y          
$2176  CC 10 07                           LDD #$1007            
$2179  17 01 18                           LBSR Sub_2294          ; call Sub_2294
$217C  A6 C9 0C AC                        LDA 3244,U            
$2180  84 E0                              ANDA #$E0             
$2182  81 A0                              CMPA #$A0             
$2184  26 06                              BNE Sub_218C          
$2186  30 8D E8 06                        LEAX Dat_0990,PC       ; X → Dat_0990
$218A  20 22                              BRA Sub_21AE          

; --------------------------------------------------------------
$218C  81 E0               Sub_218C:      CMPA #$E0             
$218E  26 06                              BNE Sub_2196          
$2190  30 8D E8 01                        LEAX Dat_0995,PC       ; X → Dat_0995
$2194  20 18                              BRA Sub_21AE          

; --------------------------------------------------------------
$2196  81 60               Sub_2196:      CMPA #$60              ; compare A with '`'
$2198  26 06                              BNE Sub_21A0          
$219A  30 8D E7 FC                        LEAX Dat_099A,PC       ; X → Dat_099A
$219E  20 0E                              BRA Sub_21AE          

; --------------------------------------------------------------
$21A0  81 20               Sub_21A0:      CMPA #$20              ; compare A with ' '
$21A2  26 06                              BNE Sub_21AA          
$21A4  30 8D E7 F7                        LEAX Dat_099F,PC       ; X → Dat_099F
$21A8  20 04                              BRA Sub_21AE          

; --------------------------------------------------------------
$21AA  30 8D E7 F6         Sub_21AA:      LEAX Dat_09A4,PC       ; X → Dat_09A4
$21AE  86 01               Sub_21AE:      LDA #$01              
$21B0  10 8E 00 05                        LDY #$0005            
$21B4  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$21B7  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$21B9  34 16               Sub_21B9:      PSHS A,B,X            
$21BB  CC 12 08                           LDD #$1208            
$21BE  17 00 D3                           LBSR Sub_2294          ; call Sub_2294
$21C1  A6 C9 0C A5                        LDA 3237,U            
$21C5  2A 07                              BPL Sub_21CE          
$21C7  86 32                              LDA #$32               ; A = '2'
$21C9  17 FD 3F                           LBSR Sub_1F0B          ; call Sub_1F0B
$21CC  20 05                              BRA Sub_21D3          

; --------------------------------------------------------------
$21CE  86 31               Sub_21CE:      LDA #$31               ; A = '1'
$21D0  17 FD 38                           LBSR Sub_1F0B          ; call Sub_1F0B
$21D3  35 96               Sub_21D3:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$21D5  34 16               Sub_21D5:      PSHS A,B,X            
$21D7  CC 12 06                           LDD #$1206            
$21DA  17 00 B7                           LBSR Sub_2294          ; call Sub_2294
$21DD  A6 C9 0C A5                        LDA 3237,U            
$21E1  85 20                              BITA #$20             
$21E3  26 04                              BNE Sub_21E9          
$21E5  86 38                              LDA #$38               ; A = '8'
$21E7  20 02                              BRA Sub_21EB          

; --------------------------------------------------------------
$21E9  86 37               Sub_21E9:      LDA #$37               ; A = '7'
$21EB  17 FD 1D            Sub_21EB:      LBSR Sub_1F0B          ; call Sub_1F0B
$21EE  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$21F0  81 8C               Sub_21F0:      CMPA #$8C             
$21F2  26 04                              BNE Sub_21F8          
$21F4  86 41                              LDA #$41               ; A = 'A'
$21F6  20 41                              BRA Sub_2239          

; --------------------------------------------------------------
$21F8  81 8A               Sub_21F8:      CMPA #$8A             
$21FA  26 04                              BNE Sub_2200          
$21FC  86 42                              LDA #$42               ; A = 'B'
$21FE  20 39                              BRA Sub_2239          

; --------------------------------------------------------------
$2200  81 88               Sub_2200:      CMPA #$88             
$2202  26 04                              BNE Sub_2208          
$2204  86 44                              LDA #$44               ; A = 'D'
$2206  20 31                              BRA Sub_2239          

; --------------------------------------------------------------
$2208  81 89               Sub_2208:      CMPA #$89             
$220A  26 04                              BNE Sub_2210          
$220C  86 43                              LDA #$43               ; A = 'C'
$220E  20 29                              BRA Sub_2239          

; --------------------------------------------------------------
$2210  E6 C8 41            Sub_2210:      LDB 65,U              
$2213  C5 78                              BITB #$78             
$2215  10 27 F3 7E                        LBEQ Sub_1597         
$2219  81 13                              CMPA #$13              ; compare A with XOFF
$221B  26 04                              BNE Sub_2221          
$221D  86 48                              LDA #$48               ; A = 'H'
$221F  20 18                              BRA Sub_2239          

; --------------------------------------------------------------
$2221  81 12               Sub_2221:      CMPA #$12             
$2223  26 04                              BNE Sub_2229          
$2225  86 4B                              LDA #$4B               ; A = 'K'
$2227  20 10                              BRA Sub_2239          

; --------------------------------------------------------------
$2229  81 10               Sub_2229:      CMPA #$10             
$222B  26 04                              BNE Sub_2231          
$222D  86 50                              LDA #$50               ; A = 'P'
$222F  20 08                              BRA Sub_2239          

; --------------------------------------------------------------
$2231  81 11               Sub_2231:      CMPA #$11              ; compare A with XON
$2233  10 26 F3 60                        LBNE Sub_1597         
$2237  86 40                              LDA #$40               ; A = '@'
$2239  30 C9 04 EF         Sub_2239:      LEAX 1263,U           
$223D  A7 02                              STA 2,X               
$223F  34 02                              PSHS A                
$2241  CC 1B 5B                           LDD #$1B5B             ; D=ESC+$5B
$2244  ED 84                              STD ,X                
$2246  A6 C8 2B                           LDA 43,U              
$2249  10 8E 00 03                        LDY #$0003            
$224D  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2250  35 02                              PULS A                
$2252  6D C9 0C A7                        TST 3239,U            
$2256  10 27 EA 04                        LBEQ Sub_0C5E         
$225A  81 41                              CMPA #$41              ; compare A with 'A'
$225C  26 04                              BNE Sub_2262          
$225E  86 09                              LDA #$09              
$2260  20 20                              BRA Sub_2282          

; --------------------------------------------------------------
$2262  81 42               Sub_2262:      CMPA #$42              ; compare A with 'B'
$2264  26 04                              BNE Sub_226A          
$2266  86 0A                              LDA #$0A               ; A = LF
$2268  20 18                              BRA Sub_2282          

; --------------------------------------------------------------
$226A  81 43               Sub_226A:      CMPA #$43              ; compare A with 'C'
$226C  26 04                              BNE Sub_2272          
$226E  86 06                              LDA #$06              
$2270  20 10                              BRA Sub_2282          

; --------------------------------------------------------------
$2272  81 44               Sub_2272:      CMPA #$44              ; compare A with 'D'
$2274  26 04                              BNE Sub_227A          
$2276  86 08                              LDA #$08               ; A = BS
$2278  20 08                              BRA Sub_2282          

; --------------------------------------------------------------
$227A  81 48               Sub_227A:      CMPA #$48              ; compare A with 'H'
$227C  10 26 E9 DE                        LBNE Sub_0C5E         
$2280  86 01                              LDA #$01              
$2282  30 C9 04 EF         Sub_2282:      LEAX 1263,U           
$2286  A7 84                              STA ,X                
$2288  86 01                              LDA #$01              
$228A  10 8E 00 01                        LDY #$0001            
$228E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2291  16 E9 CA                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$2294  34 36               Sub_2294:      PSHS A,B,X,Y          
$2296  30 C9 00 95                        LEAX 149,U            
$229A  8B 20                              ADDA #$20             
$229C  A7 01                              STA 1,X               
$229E  CB 20                              ADDB #$20             
$22A0  E7 02                              STB 2,X               
$22A2  86 02                              LDA #$02               ; A = CurXY
$22A4  A7 84                              STA ,X                
$22A6  86 01                              LDA #$01              
$22A8  10 8E 00 03                        LDY #$0003            
$22AC  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$22AF  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$22B1  34 36               Sub_22B1:      PSHS A,B,X,Y          
$22B3  CC 15 04                           LDD #$1504            
$22B6  ED C9 0C 8F                        STD 3215,U            
$22BA  CC 25 07                           LDD #$2507            
$22BD  ED C9 0C 91                        STD 3217,U            
$22C1  17 F9 BD                           LBSR Sub_1C81          ; call Sub_1C81
$22C4  30 8D E2 54                        LEAX Dat_051C,PC       ; X → Dat_051C
$22C8  17 F8 38                           LBSR WriteBlock        ; call WriteBlock
$22CB  CC 01 02                           LDD #$0102            
$22CE  8D C4                              BSR Sub_2294           ; call Sub_2294
$22D0  86 01                              LDA #$01              
$22D2  30 C9 0C D2                        LEAX 3282,U           
$22D6  10 8E 00 20                        LDY #$0020            
$22DA  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$22DD  C6 1F                              LDB #$1F              
$22DF  30 8D E6 C6                        LEAX Dat_09A9,PC       ; X → Dat_09A9
$22E3  17 F8 1D                           LBSR WriteBlock        ; call WriteBlock
$22E6  17 F8 78                           LBSR Sub_1B61          ; call Sub_1B61
$22E9  6D C8 21                           TST 33,U              
$22EC  26 20                              BNE Sub_230E          
$22EE  A6 C9 06 0E                        LDA 1550,U            
$22F2  81 0D                              CMPA #$0D              ; compare A with CR
$22F4  27 18                              BEQ Sub_230E          
$22F6  86 03                              LDA #$03              
$22F8  30 C9 06 0E                        LEAX 1550,U           
$22FC  10 3F 86                           OS9 I$ChgDir           ; mode=B  name→X
$22FF  25 12                              BCS Sub_2313           ; C=1 (BLO)
$2301  30 C9 06 0E                        LEAX 1550,U           
$2305  31 C9 0C D2                        LEAY 3282,U           
$2309  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$230B  17 0A 10                           LBSR Sub_2D1E          ; call Sub_2D1E
$230E  17 F9 CD            Sub_230E:      LBSR Sub_1CDE          ; call Sub_1CDE
$2311  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2313  86 07               Sub_2313:      LDA #$07              
$2315  17 FB F3                           LBSR Sub_1F0B          ; call Sub_1F0B
$2318  34 04                              PSHS B                
$231A  CC 0D 02                           LDD #$0D02            
$231D  17 FF 74                           LBSR Sub_2294          ; call Sub_2294
$2320  30 8D E1 6B                        LEAX Dat_048F,PC       ; X → Dat_048F
$2324  17 F7 DC                           LBSR WriteBlock        ; call WriteBlock
$2327  35 04                              PULS B                
$2329  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$232C  8E 00 3C                           LDX #$003C            
$232F  17 EC 24                           LBSR Sub_0F56          ; call Sub_0F56
$2332  30 8D E1 55                        LEAX Dat_048B,PC       ; X → Dat_048B
$2336  17 F7 CA                           LBSR WriteBlock        ; call WriteBlock
$2339  20 D3                              BRA Sub_230E          

; --------------------------------------------------------------
$233B  34 36               Sub_233B:      PSHS A,B,X,Y          
$233D  C6 33                              LDB #$33               ; B = '3'
$233F  20 0A                              BRA Sub_234B          

; --------------------------------------------------------------
$2341  34 36               Sub_2341:      PSHS A,B,X,Y          
$2343  C6 34                              LDB #$34               ; B = '4'
$2345  20 04                              BRA Sub_234B          

; --------------------------------------------------------------
$2347  34 36               Sub_2347:      PSHS A,B,X,Y          
$2349  C6 32                              LDB #$32               ; B = '2'
$234B  30 C9 13 A9         Sub_234B:      LEAX 5033,U           
$234F  A7 02                              STA 2,X               
$2351  86 1B                              LDA #$1B               ; A = ESC
$2353  ED 84                              STD ,X                
$2355  86 01                              LDA #$01              
$2357  10 8E 00 03                        LDY #$0003            
$235B  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$235E  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2360  20 1C               Sub_2360:      BRA Sub_237E          
$2362  20 1A               Sub_2362:      BRA Sub_237E          
$2364  34 06               Sub_2364:      PSHS A,B              
$2366  6D C8 26                           TST 38,U              
$2369  27 07                              BEQ Sub_2372          
$236B  6F C8 26                           CLR 38,U              
$236E  8D F2                              BSR Sub_2362           ; call Sub_2362
$2370  35 86               Sub_2370:      PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)
$2372  6D C8 25            Sub_2372:      TST 37,U              
$2375  27 F9                              BEQ Sub_2370          
$2377  6C C8 26                           INC 38,U              
$237A  8D E4                              BSR Sub_2360           ; call Sub_2360
$237C  20 F2                              BRA Sub_2370          

; --------------------------------------------------------------
$237E  34 36               Sub_237E:      PSHS A,B,X,Y          
$2380  6D C8 26                           TST 38,U              
$2383  26 25                              BNE Sub_23AA          
$2385  31 8D E5 E4                        LEAY Dat_096D,PC       ; Y → Dat_096D
$2389  30 C9 13 A9                        LEAX 5033,U           
$238D  34 10                              PSHS X                
$238F  C6 0C                              LDB #$0C               ; B = FF
$2391  17 09 92                           LBSR Sub_2D26          ; call Sub_2D26
$2394  35 10                              PULS X                
$2396  A6 C9 00 88                        LDA 136,U             
$239A  A7 07                              STA 7,X               
$239C  A6 C9 00 87                        LDA 135,U             
$23A0  A7 0B                              STA 11,X              
$23A2  A6 C8 3E                           LDA 62,U              
$23A5  17 F7 5D                           LBSR WriteBlockPath    ; call WriteBlockPath
$23A8  35 B6               Sub_23A8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$23AA  31 8D E5 B2         Sub_23AA:      LEAY Dat_0960,PC       ; Y → Dat_0960
$23AE  30 C9 13 A9                        LEAX 5033,U           
$23B2  34 10                              PSHS X                
$23B4  C6 0D                              LDB #$0D               ; B = CR
$23B6  17 09 6D                           LBSR Sub_2D26          ; call Sub_2D26
$23B9  35 10                              PULS X                
$23BB  A6 C9 00 87                        LDA 135,U             
$23BF  A7 09                              STA 9,X               
$23C1  A6 C8 3E                           LDA 62,U              
$23C4  17 F7 3E                           LBSR WriteBlockPath    ; call WriteBlockPath
$23C7  A6 42                              LDA BSS.ParamStr,U    
$23C9  A0 46                              SUBA BSS.RxBufPtr,U   
$23CB  17 21 31                           LBSR Sub_44FF          ; call Sub_44FF
$23CE  20 D8                              BRA Sub_23A8          

; --------------------------------------------------------------
$23D0  34 36               Sub_23D0:      PSHS A,B,X,Y          
$23D2  AE C9 00 93                        LDX 147,U             
$23D6  5F                                 CLRB                   ; B = 0
$23D7  A6 80               Sub_23D7:      LDA ,X+               
$23D9  5C                                 INCB                  
$23DA  C1 1E                              CMPB #$1E             
$23DC  22 07                              BHI Sub_23E5          
$23DE  4D                                 TSTA                  
$23DF  2B 04                              BMI Sub_23E5          
$23E1  81 2E                              CMPA #$2E              ; compare A with '.'
$23E3  26 F2                              BNE Sub_23D7          
$23E5  CB 08               Sub_23E5:      ADDB #$08             
$23E7  30 C9 13 A9                        LEAX 5033,U           
$23EB  34 04                              PSHS B                
$23ED  86 28                              LDA #$28               ; A = '('
$23EF  A0 E0                              SUBA ,S+              
$23F1  44                                 LSRA                  
$23F2  8B 21                              ADDA #$21             
$23F4  A7 01                              STA 1,X               
$23F6  CC 02 21                           LDD #$0221            
$23F9  E7 02                              STB 2,X               
$23FB  A7 84                              STA ,X                
$23FD  10 8E 00 03                        LDY #$0003            
$2401  86 01                              LDA #$01              
$2403  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2406  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2408  34 36               Sub_2408:      PSHS A,B,X,Y          
$240A  EC C8 53                           LDD 83,U              
$240D  26 02                              BNE Sub_2411          
$240F  20 5E                              BRA Sub_246F          

; --------------------------------------------------------------
$2411  30 C9 00 E2         Sub_2411:      LEAX 226,U            
$2415  10 AE C8 57                        LDY 87,U              
$2419  A6 C8 42                           LDA 66,U              
$241C  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$241F  24 09                              BCC Sub_242A           ; C=0 (BHS)
$2421  10 8E 00 00                        LDY #$0000            
$2425  6C C8 5F                           INC BSS.BufCount,U    
$2428  20 06                              BRA Sub_2430          

; --------------------------------------------------------------
$242A  10 AC C8 57         Sub_242A:      CMPY 87,U             
$242E  27 19                              BEQ Sub_2449          
$2430  1F 20               Sub_2430:      TFR Y,D               
$2432  30 C9 00 E2                        LEAX 226,U            
$2436  30 8B                              LEAX D,X              
$2438  34 06                              PSHS A,B              
$243A  EC C8 57                           LDD 87,U              
$243D  A3 E1                              SUBD ,S++             
$243F  1F 02                              TFR D,Y               
$2441  86 1A                              LDA #$1A               ; A = SUB
$2443  A7 80               Sub_2443:      STA ,X+               
$2445  31 3F                              LEAY -1,Y             
$2447  26 FA                              BNE Sub_2443          
$2449  30 C9 00 DF         Sub_2449:      LEAX 223,U            
$244D  EC C8 53                           LDD 83,U              
$2450  E7 01                              STB 1,X               
$2452  53                                 COMB                  
$2453  E7 02                              STB 2,X               
$2455  EC C8 53                           LDD 83,U              
$2458  27 09                              BEQ Sub_2463          
$245A  EC C8 57                           LDD 87,U              
$245D  10 83 00 80                        CMPD #$0080           
$2461  26 06                              BNE Sub_2469          
$2463  86 01               Sub_2463:      LDA #$01              
$2465  A7 84                              STA ,X                
$2467  20 04                              BRA Sub_246D          

; --------------------------------------------------------------
$2469  86 02               Sub_2469:      LDA #$02               ; A = CurXY
$246B  A7 84                              STA ,X                
$246D  35 B6               Sub_246D:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$246F  6D C8 69            Sub_246F:      TST 105,U             
$2472  27 0D                              BEQ Sub_2481          
$2474  30 C9 00 E2                        LEAX 226,U            
$2478  C6 80                              LDB #$80              
$247A  6F 80               Sub_247A:      CLR ,X+               
$247C  5A                                 DECB                  
$247D  26 FB                              BNE Sub_247A          
$247F  20 C8                              BRA Sub_2449          

; --------------------------------------------------------------
$2481  30 C9 00 E2         Sub_2481:      LEAX 226,U            
$2485  31 C9 00 9F                        LEAY 159,U            
$2489  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$248B  A6 A0               Sub_248B:      LDA ,Y+               
$248D  27 09                              BEQ Sub_2498          
$248F  81 0D                              CMPA #$0D              ; compare A with CR
$2491  27 05                              BEQ Sub_2498          
$2493  A7 80                              STA ,X+               
$2495  5A                                 DECB                  
$2496  26 F3                              BNE Sub_248B          
$2498  6F 80               Sub_2498:      CLR ,X+               
$249A  17 07 D5                           LBSR Sub_2C72          ; call Sub_2C72
$249D  20 AA                              BRA Sub_2449          

; --------------------------------------------------------------
$249F  34 36               Sub_249F:      PSHS A,B,X,Y          
$24A1  6F C8 48                           CLR 72,U              
$24A4  6F C8 49                           CLR 73,U              
$24A7  30 C9 00 E2                        LEAX 226,U            
$24AB  EC C8 57                           LDD 87,U              
$24AE  31 8B                              LEAY D,X              
$24B0  10 AF C8 50                        STY 80,U              
$24B4  6D C8 5A                           TST BSS.ConnState,U   
$24B7  26 0C                              BNE Sub_24C5          
$24B9  17 19 81                           LBSR Sub_3E3D          ; call Sub_3E3D
$24BC  30 8B                              LEAX D,X              
$24BE  A6 C8 48                           LDA 72,U              
$24C1  A7 84                              STA ,X                
$24C3  35 B6               Sub_24C3:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$24C5  17 19 47            Sub_24C5:      LBSR Sub_3E0F          ; call Sub_3E0F
$24C8  30 8B                              LEAX D,X              
$24CA  EC C8 48                           LDD 72,U              
$24CD  ED 84                              STD ,X                
$24CF  20 F2                              BRA Sub_24C3          

; --------------------------------------------------------------
$24D1  34 36               Sub_24D1:      PSHS A,B,X,Y          
$24D3  30 C9 11 1C                        LEAX 4380,U           
$24D7  10 8E 02 00                        LDY #$0200            
$24DB  6F 80               Sub_24DB:      CLR ,X+               
$24DD  31 3F                              LEAY -1,Y             
$24DF  26 FA                              BNE Sub_24DB          
$24E1  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$24E3  A6 1E               Sub_24E3:      LDA -2,X              
$24E5  80 31                              SUBA #$31             
$24E7  81 03                              CMPA #$03             
$24E9  22 56                              BHI Sub_2541          
$24EB  C6 40                              LDB #$40               ; B = '@'
$24ED  3D                                 MUL                    ; D = A×B unsigned
$24EE  31 C9 12 1C                        LEAY 4636,U           
$24F2  31 AB                              LEAY D,Y              
$24F4  C6 40                              LDB #$40               ; B = '@'
$24F6  A6 80               Sub_24F6:      LDA ,X+               
$24F8  5A                                 DECB                  
$24F9  81 0D                              CMPA #$0D              ; compare A with CR
$24FB  27 05                              BEQ Sub_2502          
$24FD  A7 A0                              STA ,Y+               
$24FF  5D                                 TSTB                  
$2500  26 F4                              BNE Sub_24F6          
$2502  86 0D               Sub_2502:      LDA #$0D               ; A = CR
$2504  A7 A4                              STA ,Y                
$2506  20 39                              BRA Sub_2541          

; --------------------------------------------------------------
$2508  A6 1E               Sub_2508:      LDA -2,X              
$250A  80 31                              SUBA #$31             
$250C  81 03                              CMPA #$03             
$250E  22 31                              BHI Sub_2541          
$2510  C6 40                              LDB #$40               ; B = '@'
$2512  3D                                 MUL                    ; D = A×B unsigned
$2513  31 C9 11 1C                        LEAY 4380,U           
$2517  31 AB                              LEAY D,Y              
$2519  86 01                              LDA #$01              
$251B  A7 C9 0C 82                        STA 3202,U            
$251F  34 10                              PSHS X                
$2521  30 C9 11 1C                        LEAX 4380,U           
$2525  AF C9 13 9C                        STX 5020,U            
$2529  35 10                              PULS X                
$252B  C6 40                              LDB #$40               ; B = '@'
$252D  A6 80               Sub_252D:      LDA ,X+               
$252F  81 0D                              CMPA #$0D              ; compare A with CR
$2531  27 0B                              BEQ Sub_253E          
$2533  81 5C                              CMPA #$5C              ; compare A with '\'
$2535  27 0D                              BEQ Sub_2544          
$2537  A7 A0               Sub_2537:      STA ,Y+               
$2539  5A                                 DECB                  
$253A  26 F1                              BNE Sub_252D          
$253C  20 03                              BRA Sub_2541          

; --------------------------------------------------------------
$253E  5F                  Sub_253E:      CLRB                   ; B = 0
$253F  E7 A4                              STB ,Y                
$2541  16 0D 2B            Sub_2541:      LBRA Sub_326F         
$2544  A6 80               Sub_2544:      LDA ,X+               
$2546  80 40                              SUBA #$40             
$2548  20 ED                              BRA Sub_2537          

; --------------------------------------------------------------
$254A  34 36               Sub_254A:      PSHS A,B,X,Y          
$254C  E6 C9 0C 89                        LDB 3209,U            
$2550  10 AE C9 13 9C                     LDY 5020,U            
$2555  A6 80               Sub_2555:      LDA ,X+               
$2557  84 7F                              ANDA #$7F             
$2559  5A                                 DECB                  
$255A  6F C8 71                           CLR 113,U             
$255D  A1 A4               Sub_255D:      CMPA ,Y               
$255F  27 29                              BEQ Sub_258A          
$2561  A6 C9 0C 82                        LDA 3202,U            
$2565  4A                                 DECA                  
$2566  34 04                              PSHS B                
$2568  C6 40                              LDB #$40               ; B = '@'
$256A  3D                                 MUL                    ; D = A×B unsigned
$256B  31 C9 11 1C                        LEAY 4380,U           
$256F  31 AB                              LEAY D,Y              
$2571  10 AF C9 13 9C                     STY 5020,U            
$2576  35 04                              PULS B                
$2578  6D C8 71                           TST 113,U             
$257B  26 05                              BNE Sub_2582          
$257D  6C C8 71                           INC 113,U             
$2580  20 DB                              BRA Sub_255D          

; --------------------------------------------------------------
$2582  6F C8 71            Sub_2582:      CLR 113,U             
$2585  5D                                 TSTB                  
$2586  26 CD                              BNE Sub_2555          
$2588  35 B6               Sub_2588:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$258A  31 21               Sub_258A:      LEAY 1,Y              
$258C  10 AF C9 13 9C                     STY 5020,U            
$2591  6D A4                              TST ,Y                
$2593  26 ED                              BNE Sub_2582          
$2595  A6 C9 0C 82                        LDA 3202,U            
$2599  6C C9 0C 82                        INC 3202,U            
$259D  6C C9 0C 83                        INC 3203,U            
$25A1  C6 40                              LDB #$40               ; B = '@'
$25A3  3D                                 MUL                    ; D = A×B unsigned
$25A4  31 C9 11 1C                        LEAY 4380,U           
$25A8  31 AB                              LEAY D,Y              
$25AA  10 AF C9 13 9C                     STY 5020,U            
$25AF  20 D7                              BRA Sub_2588          

; --------------------------------------------------------------
$25B1  34 36               Sub_25B1:      PSHS A,B,X,Y          
$25B3  6F C9 0C 83                        CLR 3203,U            
$25B7  A6 C9 0C 82                        LDA 3202,U            
$25BB  80 02                              SUBA #$02             
$25BD  C6 40                              LDB #$40               ; B = '@'
$25BF  3D                                 MUL                    ; D = A×B unsigned
$25C0  30 C9 12 1C                        LEAX 4636,U           
$25C4  30 8B                              LEAX D,X              
$25C6  34 10                              PSHS X                
$25C8  5F                                 CLRB                   ; B = 0
$25C9  A6 80               Sub_25C9:      LDA ,X+               
$25CB  5C                                 INCB                  
$25CC  C1 40                              CMPB #$40              ; compare B with '@'
$25CE  22 04                              BHI Sub_25D4          
$25D0  81 0D                              CMPA #$0D              ; compare A with CR
$25D2  26 F5                              BNE Sub_25C9          
$25D4  5A                  Sub_25D4:      DECB                  
$25D5  4F                                 CLRA                   ; A = 0
$25D6  35 10                              PULS X                
$25D8  5D                                 TSTB                  
$25D9  27 0D                              BEQ Sub_25E8          
$25DB  A6 80               Sub_25DB:      LDA ,X+               
$25DD  5A                                 DECB                  
$25DE  81 5C                              CMPA #$5C              ; compare A with '\'
$25E0  27 14                              BEQ Sub_25F6          
$25E2  17 F4 91                           LBSR Sub_1A76          ; call Sub_1A76
$25E5  5D                  Sub_25E5:      TSTB                  
$25E6  26 F3                              BNE Sub_25DB          
$25E8  35 B6               Sub_25E8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$25EA  34 10               Sub_25EA:      PSHS X                
$25EC  8E 00 1E                           LDX #$001E            
$25EF  17 E9 64                           LBSR Sub_0F56          ; call Sub_0F56
$25F2  35 10                              PULS X                
$25F4  20 EF                              BRA Sub_25E5          

; --------------------------------------------------------------
$25F6  A6 80               Sub_25F6:      LDA ,X+               
$25F8  5A                                 DECB                  
$25F9  81 5E                              CMPA #$5E              ; compare A with '^'
$25FB  27 0F                              BEQ Sub_260C          
$25FD  81 2A                              CMPA #$2A              ; compare A with '*'
$25FF  27 E9                              BEQ Sub_25EA          
$2601  81 5C                              CMPA #$5C              ; compare A with '\'
$2603  27 02                              BEQ Sub_2607          
$2605  80 40                              SUBA #$40             
$2607  17 F4 6C            Sub_2607:      LBSR Sub_1A76          ; call Sub_1A76
$260A  20 D9                              BRA Sub_25E5          

; --------------------------------------------------------------
$260C  86 1B               Sub_260C:      LDA #$1B               ; A = ESC
$260E  20 F7                              BRA Sub_2607          

; --------------------------------------------------------------
$2610  34 36               Sub_2610:      PSHS A,B,X,Y          
$2612  6D C8 40            Sub_2612:      TST 64,U              
$2615  10 26 00 D5                        LBNE Sub_26EE         
$2619  6C C8 40                           INC 64,U              
$261C  8D 02                              BSR Sub_2620           ; call Sub_2620
$261E  20 0E                              BRA Sub_262E          

; --------------------------------------------------------------
$2620  30 8D DE 45         Sub_2620:      LEAX Dat_0469,PC       ; X → Dat_0469
$2624  31 C9 13 A9                        LEAY 5033,U           
$2628  C6 0C                              LDB #$0C               ; B = FF
$262A  17 06 F1                           LBSR Sub_2D1E          ; call Sub_2D1E
$262D  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$262E  30 C9 13 A9         Sub_262E:      LEAX 5033,U           
$2632  A6 C9 00 90                        LDA 144,U             
$2636  E6 C9 00 91                        LDB 145,U             
$263A  C0 03                              SUBB #$03             
$263C  ED 07                              STD 7,X               
$263E  86 FF                              LDA #$FF              
$2640  A7 04                              STA 4,X               
$2642  A6 C9 00 87                        LDA 135,U             
$2646  E6 C9 00 88                        LDB 136,U             
$264A  ED 09                              STD 9,X               
$264C  86 01                              LDA #$01              
$264E  10 8E 00 0B                        LDY #$000B            
$2652  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2655  86 02                              LDA #$02               ; A = CurXY
$2657  30 8D DE 0C                        LEAX Dat_0467,PC       ; X → Dat_0467
$265B  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$265E  25 B2                              BCS Sub_2612           ; C=1 (BLO)
$2660  A7 C8 3F                           STA 63,U              
$2663  30 C9 13 A9                        LEAX 5033,U           
$2667  30 02                              LEAX 2,X              
$2669  6F 02                              CLR 2,X               
$266B  A6 C9 00 91                        LDA 145,U             
$266F  80 02                              SUBA #$02             
$2671  A7 04                              STA 4,X               
$2673  86 03                              LDA #$03              
$2675  A7 06                              STA 6,X               
$2677  A6 C9 00 89                        LDA 137,U             
$267B  A7 07                              STA 7,X               
$267D  A6 C9 00 88                        LDA 136,U             
$2681  A7 08                              STA 8,X               
$2683  A6 C8 3F                           LDA 63,U              
$2686  10 8E 00 09                        LDY #$0009            
$268A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$268D  A6 C9 00 87         Sub_268D:      LDA 135,U             
$2691  30 C9 00 9C                        LEAX 156,U            
$2695  A7 02                              STA 2,X               
$2697  10 8E 00 03                        LDY #$0003            
$269B  A6 C8 3F                           LDA 63,U              
$269E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$26A1  30 C9 13 A9                        LEAX 5033,U           
$26A5  86 2D                              LDA #$2D               ; A = '-'
$26A7  C6 50                              LDB #$50               ; B = 'P'
$26A9  A7 80               Sub_26A9:      STA ,X+               
$26AB  5A                                 DECB                  
$26AC  26 FB                              BNE Sub_26A9          
$26AE  30 C9 13 A9                        LEAX 5033,U           
$26B2  A6 C8 3F                           LDA 63,U              
$26B5  10 8E 00 50                        LDY #$0050            
$26B9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$26BC  30 C9 00 9C                        LEAX 156,U            
$26C0  A6 C9 00 89                        LDA 137,U             
$26C4  A7 02                              STA 2,X               
$26C6  10 8E 00 03                        LDY #$0003            
$26CA  A6 C8 3F                           LDA 63,U              
$26CD  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$26D0  30 8D E3 1B                        LEAX Dat_09EF,PC       ; X → Dat_09EF
$26D4  10 8E 00 06                        LDY #$0006            
$26D8  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$26DB  17 01 70                           LBSR Sub_284E          ; call Sub_284E
$26DE  30 8D E3 06                        LEAX Dat_09E8,PC       ; X → Dat_09E8
$26E2  A6 C8 3E                           LDA 62,U              
$26E5  10 8E 00 07                        LDY #$0007            
$26E9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$26EC  35 B6               Sub_26EC:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$26EE  6F C8 40            Sub_26EE:      CLR 64,U              
$26F1  30 8D DD 80                        LEAX Dat_0475,PC       ; X → Dat_0475
$26F5  A6 C8 3F                           LDA 63,U              
$26F8  10 8E 00 02                        LDY #$0002            
$26FC  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$26FF  A6 C8 3F                           LDA 63,U              
$2702  10 3F 8F                           OS9 I$Close            ; path=A
$2705  17 FF 18                           LBSR Sub_2620          ; call Sub_2620
$2708  30 C9 13 A9                        LEAX 5033,U           
$270C  A6 C9 00 90                        LDA 144,U             
$2710  E6 C9 00 91                        LDB 145,U             
$2714  ED 07                              STD 7,X               
$2716  86 FF                              LDA #$FF              
$2718  A7 04                              STA 4,X               
$271A  A6 C9 00 87                        LDA 135,U             
$271E  E6 C9 00 88                        LDB 136,U             
$2722  ED 09                              STD 9,X               
$2724  86 01                              LDA #$01              
$2726  10 8E 00 0B                        LDY #$000B            
$272A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$272D  30 8D E2 B0                        LEAX Dat_09E1,PC       ; X → Dat_09E1
$2731  A6 C8 3E                           LDA 62,U              
$2734  10 8E 00 07                        LDY #$0007            
$2738  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$273B  20 AF                              BRA Sub_26EC          

; --------------------------------------------------------------
$273D  86 00               Sub_273D:      LDA #$00               ; A = NUL
$273F  10 8E 00 01                        LDY #$0001            
$2743  30 C9 06 0E                        LEAX 1550,U           
$2747  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$274A  AE C8 66                           LDX 102,U             
$274D  A6 C9 06 0E                        LDA 1550,U            
$2751  81 8C                              CMPA #$8C             
$2753  10 22 EE 24                        LBHI Sub_157B         
$2757  81 7F                              CMPA #$7F             
$2759  10 22 01 00                        LBHI Sub_285D         
$275D  81 18                              CMPA #$18             
$275F  26 04                              BNE Sub_2765          
$2761  86 7F                              LDA #$7F              
$2763  20 3C                              BRA Sub_27A1          

; --------------------------------------------------------------
$2765  81 1A               Sub_2765:      CMPA #$1A              ; compare A with SUB
$2767  10 27 EE 10                        LBEQ Sub_157B         
$276B  81 1C                              CMPA #$1C             
$276D  10 27 EE 0A                        LBEQ Sub_157B         
$2771  81 0A                              CMPA #$0A              ; compare A with LF
$2773  10 27 00 E6                        LBEQ Sub_285D         
$2777  81 0C                              CMPA #$0C              ; compare A with FF
$2779  10 27 00 E0                        LBEQ Sub_285D         
$277D  81 09                              CMPA #$09             
$277F  10 27 00 DA                        LBEQ Sub_285D         
$2783  81 08                              CMPA #$08              ; compare A with BS
$2785  26 0F                              BNE Sub_2796          
$2787  E6 C8 68                           LDB 104,U             
$278A  27 26                              BEQ Sub_27B2          
$278C  30 1F                              LEAX -1,X             
$278E  AF C8 66                           STX 102,U             
$2791  6A C8 68                           DEC 104,U             
$2794  20 17                              BRA Sub_27AD          

; --------------------------------------------------------------
$2796  E6 C8 68            Sub_2796:      LDB 104,U             
$2799  C1 FD                              CMPB #$FD             
$279B  25 04                              BCS Sub_27A1           ; C=1 (BLO)
$279D  81 0D                              CMPA #$0D              ; compare A with CR
$279F  26 11                              BNE Sub_27B2          
$27A1  A7 80               Sub_27A1:      STA ,X+               
$27A3  AF C8 66                           STX 102,U             
$27A6  6C C8 68                           INC 104,U             
$27A9  81 0D                              CMPA #$0D              ; compare A with CR
$27AB  27 19                              BEQ Sub_27C6          
$27AD  8D 4E               Sub_27AD:      BSR Sub_27FD           ; call Sub_27FD
$27AF  16 00 AB                           LBRA Sub_285D         

; --------------------------------------------------------------
$27B2  86 07               Sub_27B2:      LDA #$07              
$27B4  30 C9 13 A9                        LEAX 5033,U           
$27B8  A7 84                              STA ,X                
$27BA  86 01                              LDA #$01              
$27BC  10 8E 00 01                        LDY #$0001            
$27C0  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$27C3  16 00 97                           LBRA Sub_285D         

; --------------------------------------------------------------
$27C6  86 0A               Sub_27C6:      LDA #$0A               ; A = LF
$27C8  A7 80                              STA ,X+               
$27CA  E6 C8 68                           LDB 104,U             
$27CD  6D C9 0C A9                        TST 3241,U            
$27D1  27 01                              BEQ Sub_27D4          
$27D3  5C                                 INCB                  
$27D4  4F                  Sub_27D4:      CLRA                   ; A = 0
$27D5  1F 02                              TFR D,Y               
$27D7  A6 C8 2B                           LDA 43,U              
$27DA  30 C9 05 0F                        LEAX 1295,U           
$27DE  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$27E1  6F C8 68                           CLR 104,U             
$27E4  30 C9 05 0F                        LEAX 1295,U           
$27E8  AF C8 66                           STX 102,U             
$27EB  86 0D                              LDA #$0D               ; A = CR
$27ED  A7 C9 06 0E                        STA 1550,U            
$27F1  8D 0A                              BSR Sub_27FD           ; call Sub_27FD
$27F3  86 0A                              LDA #$0A               ; A = LF
$27F5  A7 C9 06 0E                        STA 1550,U            
$27F9  8D 02                              BSR Sub_27FD           ; call Sub_27FD
$27FB  20 60                              BRA Sub_285D          

; --------------------------------------------------------------
$27FD  A6 C9 06 0E         Sub_27FD:      LDA 1550,U            
$2801  81 0D                              CMPA #$0D              ; compare A with CR
$2803  26 17                              BNE Sub_281C          
$2805  CC 20 0D                           LDD #$200D            
$2808  ED C9 13 A9                        STD 5033,U            
$280C  30 C9 13 A9                        LEAX 5033,U           
$2810  A6 C8 3F                           LDA 63,U              
$2813  10 8E 00 02                        LDY #$0002            
$2817  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$281A  20 31                              BRA Sub_284D          

; --------------------------------------------------------------
$281C  81 08               Sub_281C:      CMPA #$08              ; compare A with BS
$281E  26 15                              BNE Sub_2835          
$2820  CC 20 08                           LDD #$2008            
$2823  ED C9 13 A9                        STD 5033,U            
$2827  30 C9 13 A9                        LEAX 5033,U           
$282B  A6 C8 3F                           LDA 63,U              
$282E  10 8E 00 02                        LDY #$0002            
$2832  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2835  30 C9 06 0E         Sub_2835:      LEAX 1550,U           
$2839  10 8E 00 01                        LDY #$0001            
$283D  A6 C8 3F                           LDA 63,U              
$2840  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2843  A6 C9 06 0E                        LDA 1550,U            
$2847  81 0D                              CMPA #$0D              ; compare A with CR
$2849  27 02                              BEQ Sub_284D          
$284B  8D 01                              BSR Sub_284E           ; call Sub_284E
$284D  39                  Sub_284D:      RTS                    ; return from subroutine
$284E  A6 C8 3F            Sub_284E:      LDA 63,U              
$2851  30 8D DC 3E                        LEAX Dat_0493,PC       ; X → Dat_0493
$2855  10 8E 00 06                        LDY #$0006            
$2859  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$285C  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$285D  16 E3 FE            Sub_285D:      LBRA Sub_0C5E         
$2860  34 36               Sub_2860:      PSHS A,B,X,Y          
$2862  30 C9 00 E2                        LEAX 226,U            
$2866  34 10                              PSHS X                
$2868  6D 80               Sub_2868:      TST ,X+               
$286A  26 FC                              BNE Sub_2868          
$286C  30 1F                              LEAX -1,X             
$286E  34 10                              PSHS X                
$2870  6F C9 00 9A                        CLR 154,U             
$2874  A6 82               Sub_2874:      LDA ,-X               
$2876  AC 62                              CMPX 2,S              
$2878  25 30                              BCS Sub_28AA           ; C=1 (BLO)
$287A  81 41                              CMPA #$41              ; compare A with 'A'
$287C  25 12                              BCS Sub_2890           ; C=1 (BLO)
$287E  81 5A                              CMPA #$5A              ; compare A with 'Z'
$2880  23 F2                              BLS Sub_2874          
$2882  81 61                              CMPA #$61              ; compare A with 'a'
$2884  25 1A                              BCS Sub_28A0           ; C=1 (BLO)
$2886  81 7A                              CMPA #$7A              ; compare A with 'z'
$2888  22 1C                              BHI Sub_28A6          
$288A  A7 C9 00 9A                        STA 154,U             
$288E  20 E4                              BRA Sub_2874          

; --------------------------------------------------------------
$2890  81 39               Sub_2890:      CMPA #$39              ; compare A with '9'
$2892  22 0C                              BHI Sub_28A0          
$2894  81 30                              CMPA #$30              ; compare A with '0'
$2896  24 DC                              BCC Sub_2874           ; C=0 (BHS)
$2898  81 2E                              CMPA #$2E              ; compare A with '.'
$289A  27 D8                              BEQ Sub_2874          
$289C  81 2F                              CMPA #$2F              ; compare A with '/'
$289E  27 0A                              BEQ Sub_28AA          
$28A0  86 5F               Sub_28A0:      LDA #$5F               ; A = '_'
$28A2  A7 84                              STA ,X                
$28A4  20 CE                              BRA Sub_2874          

; --------------------------------------------------------------
$28A6  81 5C               Sub_28A6:      CMPA #$5C              ; compare A with '\'
$28A8  26 F6                              BNE Sub_28A0          
$28AA  30 01               Sub_28AA:      LEAX 1,X              
$28AC  A6 84                              LDA ,X                
$28AE  27 12                              BEQ Sub_28C2          
$28B0  81 0D                              CMPA #$0D              ; compare A with CR
$28B2  27 0E                              BEQ Sub_28C2          
$28B4  81 41                              CMPA #$41              ; compare A with 'A'
$28B6  25 04                              BCS Sub_28BC           ; C=1 (BLO)
$28B8  81 5F                              CMPA #$5F              ; compare A with '_'
$28BA  26 06                              BNE Sub_28C2          
$28BC  30 1F               Sub_28BC:      LEAX -1,X             
$28BE  86 78                              LDA #$78               ; A = 'x'
$28C0  A7 84                              STA ,X                
$28C2  AF 62               Sub_28C2:      STX 2,S               
$28C4  6D C9 00 9A                        TST 154,U             
$28C8  26 14                              BNE Sub_28DE          
$28CA  A6 80               Sub_28CA:      LDA ,X+               
$28CC  AC E4                              CMPX ,S               
$28CE  22 0E                              BHI Sub_28DE          
$28D0  81 41                              CMPA #$41              ; compare A with 'A'
$28D2  25 F6                              BCS Sub_28CA           ; C=1 (BLO)
$28D4  81 5A                              CMPA #$5A              ; compare A with 'Z'
$28D6  22 F2                              BHI Sub_28CA          
$28D8  8A 20                              ORA #$20              
$28DA  A7 1F                              STA -1,X              
$28DC  20 EC                              BRA Sub_28CA          

; --------------------------------------------------------------
$28DE  31 C9 00 9F         Sub_28DE:      LEAY 159,U            
$28E2  AE 62                              LDX 2,S               
$28E4  EC E1                              LDD ,S++              
$28E6  A3 E1                              SUBD ,S++             
$28E8  C1 1D                              CMPB #$1D             
$28EA  23 02                              BLS Sub_28EE          
$28EC  C6 1D                              LDB #$1D              
$28EE  17 04 2D            Sub_28EE:      LBSR Sub_2D1E          ; call Sub_2D1E
$28F1  86 0D                              LDA #$0D               ; A = CR
$28F3  A7 A4                              STA ,Y                
$28F5  30 01                              LEAX 1,X              
$28F7  8D 6F                              BSR Sub_2968           ; call Sub_2968
$28F9  30 8D DC 6E                        LEAX Dat_056B,PC       ; X → Dat_056B
$28FD  17 F2 03                           LBSR WriteBlock        ; call WriteBlock
$2900  30 C9 00 9F                        LEAX 159,U            
$2904  A6 84                              LDA ,X                
$2906  27 30                              BEQ Sub_2938          
$2908  81 0D                              CMPA #$0D              ; compare A with CR
$290A  27 2C                              BEQ Sub_2938          
$290C  86 01                              LDA #$01              
$290E  10 8E 00 20                        LDY #$0020            
$2912  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$2915  30 8D DB 76                        LEAX Dat_048F,PC       ; X → Dat_048F
$2919  17 F1 E7                           LBSR WriteBlock        ; call WriteBlock
$291C  EC C8 5D                           LDD BSS.BufPtr1,U     
$291F  26 23                              BNE Sub_2944          
$2921  EC C8 5B                           LDD BSS.ConnWord,U    
$2924  26 1E                              BNE Sub_2944          
$2926  30 C9 00 9F         Sub_2926:      LEAX 159,U            
$292A  86 02                              LDA #$02               ; A = CurXY
$292C  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$292E  10 3F 83                           OS9 I$Create           ; mode=B  name→X  → path→A
$2931  25 05                              BCS Sub_2938           ; C=1 (BLO)
$2933  A7 C8 42                           STA 66,U              
$2936  35 B6               Sub_2936:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2938  86 FF               Sub_2938:      LDA #$FF              
$293A  A7 C8 42                           STA 66,U              
$293D  86 0A                              LDA #$0A               ; A = LF
$293F  A7 C8 52                           STA 82,U              
$2942  20 F2                              BRA Sub_2936          

; --------------------------------------------------------------
$2944  30 8D DC 2F         Sub_2944:      LEAX Dat_0577,PC       ; X → Dat_0577
$2948  17 F1 B8                           LBSR WriteBlock        ; call WriteBlock
$294B  30 C9 13 AA                        LEAX 5034,U           
$294F  10 8E 00 07                        LDY #$0007            
$2953  A6 84               Sub_2953:      LDA ,X                
$2955  81 30                              CMPA #$30              ; compare A with '0'
$2957  26 08                              BNE Sub_2961          
$2959  30 01                              LEAX 1,X              
$295B  31 3F                              LEAY -1,Y             
$295D  27 C7                              BEQ Sub_2926          
$295F  20 F2                              BRA Sub_2953          

; --------------------------------------------------------------
$2961  86 01               Sub_2961:      LDA #$01              
$2963  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2966  20 BE                              BRA Sub_2926          

; --------------------------------------------------------------
$2968  34 36               Sub_2968:      PSHS A,B,X,Y          
$296A  CC 00 00                           LDD #$0000            
$296D  ED C8 5B                           STD BSS.ConnWord,U    
$2970  ED C8 5D                           STD BSS.BufPtr1,U     
$2973  C6 08                              LDB #$08               ; B = BS
$2975  A6 80               Sub_2975:      LDA ,X+               
$2977  81 20                              CMPA #$20              ; compare A with ' '
$2979  27 08                              BEQ Sub_2983          
$297B  4D                                 TSTA                  
$297C  27 05                              BEQ Sub_2983          
$297E  5A                                 DECB                  
$297F  26 F4                              BNE Sub_2975          
$2981  20 2C                              BRA Sub_29AF          

; --------------------------------------------------------------
$2983  31 C9 13 B0         Sub_2983:      LEAY 5040,U           
$2987  30 1F                              LEAX -1,X             
$2989  C6 08                              LDB #$08               ; B = BS
$298B  A6 82               Sub_298B:      LDA ,-X               
$298D  27 07                              BEQ Sub_2996          
$298F  A7 A2                              STA ,-Y               
$2991  5A                                 DECB                  
$2992  C1 01                              CMPB #$01             
$2994  26 F5                              BNE Sub_298B          
$2996  86 30               Sub_2996:      LDA #$30               ; A = '0'
$2998  A7 A2               Sub_2998:      STA ,-Y               
$299A  5A                                 DECB                  
$299B  C1 01                              CMPB #$01             
$299D  26 F9                              BNE Sub_2998          
$299F  31 C9 13 A9                        LEAY 5033,U           
$29A3  30 8D E0 4E                        LEAX Dat_09F5,PC       ; X → Dat_09F5
$29A7  5F                                 CLRB                   ; B = 0
$29A8  8D 07               Sub_29A8:      BSR Sub_29B1           ; call Sub_29B1
$29AA  5C                                 INCB                  
$29AB  C1 08                              CMPB #$08              ; compare B with BS
$29AD  26 F9                              BNE Sub_29A8          
$29AF  35 B6               Sub_29AF:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$29B1  34 14               Sub_29B1:      PSHS B,X              
$29B3  86 04                              LDA #$04              
$29B5  3D                                 MUL                    ; D = A×B unsigned
$29B6  30 8B                              LEAX D,X              
$29B8  E6 E4                              LDB ,S                
$29BA  A6 A5                              LDA B,Y               
$29BC  80 30                              SUBA #$30             
$29BE  1F 89                              TFR A,B               
$29C0  27 27                              BEQ Sub_29E9          
$29C2  34 04               Sub_29C2:      PSHS B                
$29C4  E6 03                              LDB 3,X               
$29C6  EB C8 5E                           ADDB 94,U             
$29C9  E7 C8 5E                           STB 94,U              
$29CC  A6 02                              LDA 2,X               
$29CE  A9 C8 5D                           ADCA BSS.BufPtr1,U    
$29D1  A7 C8 5D                           STA BSS.BufPtr1,U     
$29D4  E6 01                              LDB 1,X               
$29D6  E9 C8 5C                           ADCB 92,U             
$29D9  E7 C8 5C                           STB 92,U              
$29DC  A6 84                              LDA ,X                
$29DE  A9 C8 5B                           ADCA BSS.ConnWord,U   
$29E1  A7 C8 5B                           STA BSS.ConnWord,U    
$29E4  35 04                              PULS B                
$29E6  5A                                 DECB                  
$29E7  26 D9                              BNE Sub_29C2          
$29E9  35 94               Sub_29E9:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)
$29EB  34 36               Sub_29EB:      PSHS A,B,X,Y          
$29ED  17 E9 D2                           LBSR Sub_13C2          ; call Sub_13C2
$29F0  25 1D                              BCS Sub_2A0F           ; C=1 (BLO)
$29F2  4F                                 CLRA                   ; A = 0
$29F3  1F 02                              TFR D,Y               
$29F5  30 C9 06 0E                        LEAX 1550,U           
$29F9  86 00                              LDA #$00               ; A = NUL
$29FB  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$29FE  25 0F                              BCS Sub_2A0F           ; C=1 (BLO)
$2A00  1F 20                              TFR Y,D               
$2A02  30 C9 06 0E                        LEAX 1550,U           
$2A06  A6 80               Sub_2A06:      LDA ,X+               
$2A08  81 05                              CMPA #$05             
$2A0A  27 06                              BEQ Sub_2A12          
$2A0C  5A                                 DECB                  
$2A0D  26 F7                              BNE Sub_2A06          
$2A0F  5F                  Sub_2A0F:      CLRB                   ; B = 0
$2A10  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2A12  53                  Sub_2A12:      COMB                  
$2A13  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2A15  34 34               Sub_2A15:      PSHS B,X,Y            
$2A17  17 11 A2                           LBSR Sub_3BBC          ; call Sub_3BBC
$2A1A  8D CF               Sub_2A1A:      BSR Sub_29EB           ; call Sub_29EB
$2A1C  25 2E                              BCS Sub_2A4C           ; C=1 (BLO)
$2A1E  A6 C8 2B                           LDA 43,U              
$2A21  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2A23  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2A26  24 09                              BCC Sub_2A31           ; C=0 (BHS)
$2A28  17 11 AF                           LBSR Sub_3BDA          ; call Sub_3BDA
$2A2B  81 3B                              CMPA #$3B              ; compare A with ';'
$2A2D  25 EB                              BCS Sub_2A1A           ; C=1 (BLO)
$2A2F  20 1B                              BRA Sub_2A4C          

; --------------------------------------------------------------
$2A31  10 8E 00 01         Sub_2A31:      LDY #$0001            
$2A35  A6 C8 2B                           LDA 43,U              
$2A38  30 C9 04 EF                        LEAX 1263,U           
$2A3C  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2A3F  25 0E                              BCS Sub_2A4F           ; C=1 (BLO)
$2A41  A6 C9 04 EF                        LDA 1263,U            
$2A45  6F C9 04 EF                        CLR 1263,U            
$2A49  5F                  Sub_2A49:      CLRB                   ; B = 0
$2A4A  35 B4                              PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2A4C  53                  Sub_2A4C:      COMB                  
$2A4D  35 B4                              PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2A4F  4F                  Sub_2A4F:      CLRA                   ; A = 0
$2A50  20 F7                              BRA Sub_2A49          

; --------------------------------------------------------------
$2A52  34 36               Sub_2A52:      PSHS A,B,X,Y          
$2A54  30 8D DA 33                        LEAX Dat_048B,PC       ; X → Dat_048B
$2A58  17 F0 A8                           LBSR WriteBlock        ; call WriteBlock
$2A5B  5F                                 CLRB                   ; B = 0
$2A5C  30 C9 07 0D                        LEAX 1805,U           
$2A60  34 14               Sub_2A60:      PSHS B,X              
$2A62  8D 1D                              BSR Sub_2A81           ; call Sub_2A81
$2A64  35 14                              PULS B,X              
$2A66  A6 C9 06 0E                        LDA 1550,U            
$2A6A  81 0D                              CMPA #$0D              ; compare A with CR
$2A6C  27 0A                              BEQ Sub_2A78          
$2A6E  6D C8 21                           TST 33,U              
$2A71  26 05                              BNE Sub_2A78          
$2A73  5C                                 INCB                  
$2A74  C1 20                              CMPB #$20              ; compare B with ' '
$2A76  26 E8                              BNE Sub_2A60          
$2A78  30 8D DA 13         Sub_2A78:      LEAX Dat_048F,PC       ; X → Dat_048F
$2A7C  17 F0 84                           LBSR WriteBlock        ; call WriteBlock
$2A7F  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2A81  86 20               Sub_2A81:      LDA #$20               ; A = ' '
$2A83  3D                                 MUL                    ; D = A×B unsigned
$2A84  30 8B                              LEAX D,X              
$2A86  34 10                              PSHS X                
$2A88  30 8D DA D3                        LEAX Dat_055F,PC       ; X → Dat_055F
$2A8C  17 F0 74                           LBSR WriteBlock        ; call WriteBlock
$2A8F  C6 1E                              LDB #$1E              
$2A91  17 F0 CD                           LBSR Sub_1B61          ; call Sub_1B61
$2A94  35 10                              PULS X                
$2A96  31 C9 06 0E                        LEAY 1550,U           
$2A9A  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$2A9C  17 02 87                           LBSR Sub_2D26          ; call Sub_2D26
$2A9F  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2AA0  34 36               Sub_2AA0:      PSHS A,B,X,Y          
$2AA2  E6 C8 6A                           LDB 106,U             
$2AA5  86 20                              LDA #$20               ; A = ' '
$2AA7  3D                                 MUL                    ; D = A×B unsigned
$2AA8  30 C9 07 0D                        LEAX 1805,U           
$2AAC  30 8B                              LEAX D,X              
$2AAE  31 C9 00 9F                        LEAY 159,U            
$2AB2  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$2AB4  17 02 67                           LBSR Sub_2D1E          ; call Sub_2D1E
$2AB7  6C C8 6A                           INC 106,U             
$2ABA  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2ABC  34 34               Sub_2ABC:      PSHS B,X,Y            
$2ABE  86 01                              LDA #$01              
$2AC0  A7 C8 29                           STA 41,U              
$2AC3  20 05                              BRA Sub_2ACA          

; --------------------------------------------------------------
$2AC5  34 34               Sub_2AC5:      PSHS B,X,Y            
$2AC7  6F C8 29                           CLR 41,U              
$2ACA  17 E8 F5            Sub_2ACA:      LBSR Sub_13C2          ; call Sub_13C2
$2ACD  24 08                              BCC Sub_2AD7           ; C=0 (BHS)
$2ACF  8E 00 03                           LDX #$0003            
$2AD2  17 E4 81                           LBSR Sub_0F56          ; call Sub_0F56
$2AD5  20 F3                              BRA Sub_2ACA          

; --------------------------------------------------------------
$2AD7  5D                  Sub_2AD7:      TSTB                  
$2AD8  27 F0                              BEQ Sub_2ACA          
$2ADA  30 C8 1B                           LEAX 27,U             
$2ADD  10 8E 00 01                        LDY #$0001            
$2AE1  86 00                              LDA #$00               ; A = NUL
$2AE3  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2AE6  A6 84                              LDA ,X                
$2AE8  6D C8 29                           TST 41,U              
$2AEB  26 06                              BNE Sub_2AF3          
$2AED  81 60                              CMPA #$60              ; compare A with '`'
$2AEF  25 02                              BCS Sub_2AF3           ; C=1 (BLO)
$2AF1  80 20                              SUBA #$20             
$2AF3  35 B4               Sub_2AF3:      PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
$2AF5  6F C8 1A            Sub_2AF5:      CLR 26,U              
$2AF8  A6 C8 2B                           LDA 43,U              
$2AFB  C6 2B                              LDB #$2B               ; B = SS.CtlSg  (GetStt/SetStt subcode)
$2AFD  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$2B00  25 05                              BCS Sub_2B07           ; C=1 (BLO)
$2B02  6C C8 1A                           INC 26,U              
$2B05  20 48                              BRA Sub_2B4F          

; --------------------------------------------------------------
$2B07  30 C9 0C 2E         Sub_2B07:      LEAX 3118,U           
$2B0B  EC 88 1B                           LDD 27,X              
$2B0E  C3 00 04                           ADDD #$0004           
$2B11  ED C8 13                           STD 19,U              
$2B14  86 01                              LDA #$01              
$2B16  30 C9 07 0D                        LEAX 1805,U           
$2B1A  10 3F 18                           OS9 F$GPrDsc           ; pid=A  buf→X
$2B1D  30 88 40                           LEAX 64,X             
$2B20  AF C9 0C 84                        STX 3204,U            
$2B24  1F 10                              TFR X,D               
$2B26  AE C8 13                           LDX 19,U              
$2B29  10 8E 00 02                        LDY #$0002            
$2B2D  33 C9 13 A9                        LEAU 5033,U           
$2B31  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$2B34  CE 00 00                           LDU #$0000            
$2B37  AE C9 13 A9                        LDX 5033,U            
$2B3B  30 88 15                           LEAX 21,X             
$2B3E  EC C9 0C 84                        LDD 3204,U            
$2B42  10 8E 00 02                        LDY #$0002            
$2B46  33 C8 11                           LEAU 17,U             
$2B49  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$2B4C  CE 00 00                           LDU #$0000            
$2B4F  39                  Sub_2B4F:      RTS                    ; return from subroutine
$2B50  34 36               Sub_2B50:      PSHS A,B,X,Y          
$2B52  30 C9 13 A9                        LEAX 5033,U           
$2B56  CC 02 53                           LDD #$0253            
$2B59  ED 84                              STD ,X                
$2B5B  86 20                              LDA #$20               ; A = ' '
$2B5D  A7 02                              STA 2,X               
$2B5F  10 8E 00 03                        LDY #$0003            
$2B63  A6 C8 3E                           LDA 62,U              
$2B66  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2B69  30 C8 2D                           LEAX BSS.Counter1,U   
$2B6C  5F                                 CLRB                   ; B = 0
$2B6D  A6 80               Sub_2B6D:      LDA ,X+               
$2B6F  5C                                 INCB                  
$2B70  81 21                              CMPA #$21              ; compare A with '!'
$2B72  25 04                              BCS Sub_2B78           ; C=1 (BLO)
$2B74  C1 05                              CMPB #$05             
$2B76  25 F5                              BCS Sub_2B6D           ; C=1 (BLO)
$2B78  30 C8 2D            Sub_2B78:      LEAX BSS.Counter1,U   
$2B7B  4F                                 CLRA                   ; A = 0
$2B7C  1F 02                              TFR D,Y               
$2B7E  A6 C8 3E                           LDA 62,U              
$2B81  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2B84  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2B86  31 8D D8 F7         Sub_2B86:      LEAY Dat_0481,PC       ; Y → Dat_0481
$2B8A  30 C9 13 A9                        LEAX 5033,U           
$2B8E  34 10                              PSHS X                
$2B90  C6 07                              LDB #$07              
$2B92  17 01 91                           LBSR Sub_2D26          ; call Sub_2D26
$2B95  35 10                              PULS X                
$2B97  A6 C9 00 86                        LDA 134,U             
$2B9B  A7 05                              STA 5,X               
$2B9D  A6 C9 00 87                        LDA 135,U             
$2BA1  A7 02                              STA 2,X               
$2BA3  A6 C8 3E                           LDA 62,U              
$2BA6  10 8E 00 07                        LDY #$0007            
$2BAA  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2BAD  6D C8 40                           TST 64,U              
$2BB0  27 0E                              BEQ Sub_2BC0          
$2BB2  A6 C8 3E                           LDA 62,U              
$2BB5  30 8D DE 2F                        LEAX Dat_09E8,PC       ; X → Dat_09E8
$2BB9  10 8E 00 07                        LDY #$0007            
$2BBD  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2BC0  31 8D D5 27         Sub_2BC0:      LEAY Dat_00EB,PC       ; Y → Dat_00EB
$2BC4  30 C9 13 A9                        LEAX 5033,U           
$2BC8  C6 1E                              LDB #$1E              
$2BCA  17 01 59                           LBSR Sub_2D26          ; call Sub_2D26
$2BCD  30 C9 13 A9                        LEAX 5033,U           
$2BD1  A6 C9 00 8C                        LDA 140,U             
$2BD5  A7 07                              STA 7,X               
$2BD7  A6 C9 00 87                        LDA 135,U             
$2BDB  A7 88 19                           STA 25,X              
$2BDE  6D C8 19                           TST 25,U              
$2BE1  27 05                              BEQ Sub_2BE8          
$2BE3  86 61                              LDA #$61               ; A = 'a'
$2BE5  A7 88 16                           STA 22,X              
$2BE8  A6 C8 3E            Sub_2BE8:      LDA 62,U              
$2BEB  17 EF 17                           LBSR WriteBlockPath    ; call WriteBlockPath
$2BEE  17 FF 5F                           LBSR Sub_2B50          ; call Sub_2B50
$2BF1  17 F7 6E                           LBSR Sub_2362          ; call Sub_2362
$2BF4  6D C8 2B                           TST 43,U              
$2BF7  27 03                              BEQ Sub_2BFC          
$2BF9  17 E5 93                           LBSR Sub_118F          ; call Sub_118F
$2BFC  A6 C8 72            Sub_2BFC:      LDA 114,U             
$2BFF  27 12                              BEQ Sub_2C13          
$2C01  6D C8 75                           TST 117,U             
$2C04  27 0E                              BEQ Sub_2C14          
$2C06  30 C8 77                           LEAX 119,U            
$2C09  10 8E 00 0B                        LDY #$000B            
$2C0D  A6 C8 3E                           LDA 62,U              
$2C10  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2C13  39                  Sub_2C13:      RTS                    ; return from subroutine
$2C14  17 E3 09            Sub_2C14:      LBSR Sub_0F20          ; call Sub_0F20
$2C17  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2C18  6D C8 40            Sub_2C18:      TST 64,U              
$2C1B  27 54                              BEQ Sub_2C71          
$2C1D  30 8D DD CE                        LEAX Dat_09EF,PC       ; X → Dat_09EF
$2C21  31 C9 13 A9                        LEAY 5033,U           
$2C25  C6 06                              LDB #$06               ; B = SS.EOF  (GetStt/SetStt subcode)
$2C27  17 00 F4                           LBSR Sub_2D1E          ; call Sub_2D1E
$2C2A  30 C9 13 A9                        LEAX 5033,U           
$2C2E  4F                                 CLRA                   ; A = 0
$2C2F  A7 03                              STA 3,X               
$2C31  86 03                              LDA #$03              
$2C33  A7 05                              STA 5,X               
$2C35  10 8E 00 06                        LDY #$0006            
$2C39  A6 C8 3F                           LDA 63,U              
$2C3C  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2C3F  31 8D D8 3E                        LEAY Dat_0481,PC       ; Y → Dat_0481
$2C43  30 C9 13 A9                        LEAX 5033,U           
$2C47  34 10                              PSHS X                
$2C49  C6 07                              LDB #$07              
$2C4B  17 00 D8                           LBSR Sub_2D26          ; call Sub_2D26
$2C4E  35 10                              PULS X                
$2C50  A6 C9 00 88                        LDA 136,U             
$2C54  A7 05                              STA 5,X               
$2C56  A6 C9 00 89                        LDA 137,U             
$2C5A  A7 02                              STA 2,X               
$2C5C  A6 C8 3F                           LDA 63,U              
$2C5F  10 8E 00 07                        LDY #$0007            
$2C63  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2C66  30 8D DD 85                        LEAX Dat_09EF,PC       ; X → Dat_09EF
$2C6A  10 8E 00 06                        LDY #$0006            
$2C6E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2C71  39                  Sub_2C71:      RTS                    ; return from subroutine
$2C72  34 36               Sub_2C72:      PSHS A,B,X,Y          
$2C74  A6 C8 42                           LDA 66,U              
$2C77  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$2C79  34 40                              PSHS U                
$2C7B  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2C7E  1F 32                              TFR U,Y               
$2C80  35 40                              PULS U                
$2C82  25 09                              BCS Sub_2C8D           ; C=1 (BLO)
$2C84  AF C8 5B                           STX BSS.ConnWord,U    
$2C87  10 AF C8 5D                        STY BSS.BufPtr1,U     
$2C8B  20 0B                              BRA Sub_2C98          

; --------------------------------------------------------------
$2C8D  CC 00 00            Sub_2C8D:      LDD #$0000            
$2C90  ED C8 5B                           STD BSS.ConnWord,U    
$2C93  ED C8 5D                           STD BSS.BufPtr1,U     
$2C96  20 41                              BRA Sub_2CD9          

; --------------------------------------------------------------
$2C98  AE 62               Sub_2C98:      LDX 2,S               
$2C9A  31 8D DD 57                        LEAY Dat_09F5,PC       ; Y → Dat_09F5
$2C9E  34 10                              PSHS X                
$2CA0  86 30                              LDA #$30               ; A = '0'
$2CA2  C6 07                              LDB #$07              
$2CA4  A7 80               Sub_2CA4:      STA ,X+               
$2CA6  5A                                 DECB                  
$2CA7  26 FB                              BNE Sub_2CA4          
$2CA9  35 10                              PULS X                
$2CAB  5F                                 CLRB                   ; B = 0
$2CAC  34 36               Sub_2CAC:      PSHS A,B,X,Y          
$2CAE  8D 2B                              BSR Sub_2CDB           ; call Sub_2CDB
$2CB0  35 36                              PULS A,B,X,Y          
$2CB2  5C                                 INCB                  
$2CB3  C1 08                              CMPB #$08              ; compare B with BS
$2CB5  26 F5                              BNE Sub_2CAC          
$2CB7  34 10                              PSHS X                
$2CB9  30 8D D8 BA                        LEAX Dat_0577,PC       ; X → Dat_0577
$2CBD  17 EE 43                           LBSR WriteBlock        ; call WriteBlock
$2CC0  35 10                              PULS X                
$2CC2  10 8E 00 07                        LDY #$0007            
$2CC6  A6 84               Sub_2CC6:      LDA ,X                
$2CC8  81 30                              CMPA #$30              ; compare A with '0'
$2CCA  26 08                              BNE Sub_2CD4          
$2CCC  30 01                              LEAX 1,X              
$2CCE  31 3F                              LEAY -1,Y             
$2CD0  27 07                              BEQ Sub_2CD9          
$2CD2  20 F2                              BRA Sub_2CC6          

; --------------------------------------------------------------
$2CD4  86 01               Sub_2CD4:      LDA #$01              
$2CD6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2CD9  35 B6               Sub_2CD9:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2CDB  30 85               Sub_2CDB:      LEAX B,X              
$2CDD  86 04                              LDA #$04              
$2CDF  3D                                 MUL                    ; D = A×B unsigned
$2CE0  31 AB                              LEAY D,Y              
$2CE2  EC A4               Sub_2CE2:      LDD ,Y                
$2CE4  10 A3 C8 5B                        CMPD BSS.ConnWord,U   
$2CE8  22 33                              BHI Sub_2D1D          
$2CEA  25 08                              BCS Sub_2CF4           ; C=1 (BLO)
$2CEC  EC 22                              LDD 2,Y               
$2CEE  10 A3 C8 5D                        CMPD BSS.BufPtr1,U    
$2CF2  22 29                              BHI Sub_2D1D          
$2CF4  EC C8 5B            Sub_2CF4:      LDD BSS.ConnWord,U    
$2CF7  26 05                              BNE Sub_2CFE          
$2CF9  EC C8 5D                           LDD BSS.BufPtr1,U     
$2CFC  27 1F                              BEQ Sub_2D1D          
$2CFE  6C 84               Sub_2CFE:      INC ,X                
$2D00  EC C8 5D                           LDD BSS.BufPtr1,U     
$2D03  A3 22                              SUBD 2,Y              
$2D05  ED C8 5D                           STD BSS.BufPtr1,U     
$2D08  24 09                              BCC Sub_2D13           ; C=0 (BHS)
$2D0A  EC C8 5B                           LDD BSS.ConnWord,U    
$2D0D  83 00 01                           SUBD #$0001           
$2D10  ED C8 5B                           STD BSS.ConnWord,U    
$2D13  EC C8 5B            Sub_2D13:      LDD BSS.ConnWord,U    
$2D16  A3 A4                              SUBD ,Y               
$2D18  ED C8 5B                           STD BSS.ConnWord,U    
$2D1B  20 C5                              BRA Sub_2CE2          

; --------------------------------------------------------------
$2D1D  39                  Sub_2D1D:      RTS                    ; return from subroutine
$2D1E  A6 80               Sub_2D1E:      LDA ,X+               
$2D20  A7 A0                              STA ,Y+               
$2D22  5A                                 DECB                  
$2D23  26 F9                              BNE Sub_2D1E          
$2D25  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2D26  A6 A0               Sub_2D26:      LDA ,Y+               
$2D28  A7 80                              STA ,X+               
$2D2A  5A                                 DECB                  
$2D2B  26 F9                              BNE Sub_2D26          
$2D2D  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2D2E  34 12               Sub_2D2E:      PSHS A,X              
$2D30  6D C8 1A                           TST 26,U              
$2D33  27 0C                              BEQ Sub_2D41          
$2D35  A6 C8 2B                           LDA 43,U              
$2D38  C6 28                              LDB #$28               ; B = SS.EnRTS  (GetStt/SetStt subcode)
$2D3A  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2D3D  1F 98                              TFR B,A               
$2D3F  20 05                              BRA Sub_2D46          

; --------------------------------------------------------------
$2D41  AE C8 11            Sub_2D41:      LDX 17,U              
$2D44  A6 01                              LDA 1,X               
$2D46  84 20               Sub_2D46:      ANDA #$20             
$2D48  27 03                              BEQ Sub_2D4D          
$2D4A  5F                                 CLRB                   ; B = 0
$2D4B  35 92               Sub_2D4B:      PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)
$2D4D  53                  Sub_2D4D:      COMB                  
$2D4E  20 FB                              BRA Sub_2D4B          

; --------------------------------------------------------------
$2D50  34 16               Sub_2D50:      PSHS A,B,X            
$2D52  8E 00 03                           LDX #$0003            
$2D55  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$2D58  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2D5A  A6 C8 2B                           LDA 43,U              
$2D5D  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2D60  25 1C                              BCS Sub_2D7E           ; C=1 (BLO)
$2D62  8E 00 15                           LDX #$0015            
$2D65  17 E1 EE                           LBSR Sub_0F56          ; call Sub_0F56
$2D68  A6 C8 2B                           LDA 43,U              
$2D6B  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2D6D  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2D70  4F                                 CLRA                   ; A = 0
$2D71  1F 02                              TFR D,Y               
$2D73  30 C9 13 A9                        LEAX 5033,U           
$2D77  A6 C8 2B                           LDA 43,U              
$2D7A  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2D7D  5F                                 CLRB                   ; B = 0
$2D7E  35 96               Sub_2D7E:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
         FCB    $C6,$10,$A6,$80,$5A,$26,$04,$C6,$01,$20,$3C,$81,$30,$25,$F3,$81,$39,$22,$EF,$1F,$12,$31,$3F,$A6,$80,$81,$30,$25,$06,$81,$39,$22,$02,$20,$F4,$30,$1F,$CC,$20,$20,$ED,$84,$86,$A0,$A7,$24,$30,$8D,$D8,$A0,$5F,$34,$34,$C6,$05,$10,$3F,$11,$35,$34,$24,$09,$30,$05,$5C,$C1,$08,$26,$EE,$20,$15,$A6,$C9,$0C,$A5,$84,$F8,$A7,$C9,$0C,$A5,$EA,$C9,$0C,$A5,$E7,$C9,$0C,$A5,$17,$E3,$B3,$39  ; unreachable padding
$2DDD  34 36               Sub_2DDD:      PSHS A,B,X,Y          
$2DDF  17 FF 6E                           LBSR Sub_2D50          ; call Sub_2D50
$2DE2  25 37                              BCS Sub_2E1B           ; C=1 (BLO)
$2DE4  10 AF C9 0C 88                     STY 3208,U            
$2DE9  30 C9 13 A9                        LEAX 5033,U           
$2DED  E6 C9 0C 89                        LDB 3209,U            
$2DF1  C0 07                              SUBB #$07             
$2DF3  34 14               Sub_2DF3:      PSHS B,X              
$2DF5  31 8D D4 D8                        LEAY Dat_02D1,PC       ; Y → Dat_02D1
$2DF9  C6 07                              LDB #$07              
$2DFB  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$2DFE  35 14                              PULS B,X              
$2E00  24 07                              BCC Sub_2E09           ; C=0 (BHS)
$2E02  30 01                              LEAX 1,X              
$2E04  5A                                 DECB                  
$2E05  26 EC                              BNE Sub_2DF3          
$2E07  20 12                              BRA Sub_2E1B          

; --------------------------------------------------------------
$2E09  E6 C9 0C 89         Sub_2E09:      LDB 3209,U            
$2E0D  30 C9 13 A9                        LEAX 5033,U           
$2E11  31 C9 00 DF                        LEAY 223,U            
$2E15  17 FF 06                           LBSR Sub_2D1E          ; call Sub_2D1E
$2E18  5F                                 CLRB                   ; B = 0
$2E19  35 B6               Sub_2E19:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2E1B  53                  Sub_2E1B:      COMB                  
$2E1C  20 FB                              BRA Sub_2E19          

; --------------------------------------------------------------
$2E1E  34 36               Sub_2E1E:      PSHS A,B,X,Y          
$2E20  30 C9 13 A9                        LEAX 5033,U           
$2E24  C6 0E                              LDB #$0E              
$2E26  34 14               Sub_2E26:      PSHS B,X              
$2E28  31 8D D4 AC                        LEAY Dat_02D8,PC       ; Y → Dat_02D8
$2E2C  C6 04                              LDB #$04              
$2E2E  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$2E31  35 14                              PULS B,X              
$2E33  24 07                              BCC Sub_2E3C           ; C=0 (BHS)
$2E35  30 01                              LEAX 1,X              
$2E37  5A                                 DECB                  
$2E38  26 EC                              BNE Sub_2E26          
$2E3A  20 00                              BRA Sub_2E3C          

; --------------------------------------------------------------
$2E3C  35 B6               Sub_2E3C:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2E3E  34 76               Sub_2E3E:      PSHS A,B,X,Y,U        
$2E40  30 8D D1 BC                        LEAX ModHeader,PC     
$2E44  10 AE 02                           LDY 2,X               
$2E47  AF C8 15                           STX 21,U              
$2E4A  31 3D                              LEAY -3,Y             
$2E4C  10 AF C8 17                        STY 23,U              
$2E50  1F 13                              TFR X,U               
$2E52  1F 20                              TFR Y,D               
$2E54  33 CB                              LEAU D,U              
$2E56  CC FF FF                           LDD #$FFFF            
$2E59  ED C4                              STD ,U                
$2E5B  A7 42                              STA BSS.ParamStr,U    
$2E5D  10 3F 17                           OS9 F$CRC              ; buf→X  count=Y  seed=D  → CRC-24
$2E60  63 C4                              COM ,U                
$2E62  63 41                              COM 1,U               
$2E64  63 42                              COM BSS.ParamStr,U    
$2E66  35 76                              PULS A,B,X,Y,U        
$2E68  86 07                              LDA #$07              
$2E6A  30 8D D1 9F                        LEAX ModName,PC        ; X → ModName
$2E6E  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$2E71  25 0F                              BCS Sub_2E82           ; C=1 (BLO)
$2E73  AE C8 15                           LDX 21,U              
$2E76  10 AE C8 17                        LDY 23,U              
$2E7A  31 23                              LEAY 3,Y              
$2E7C  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2E7F  10 3F 8F                           OS9 I$Close            ; path=A
$2E82  39                  Sub_2E82:      RTS                    ; return from subroutine
$2E83  34 36               Sub_2E83:      PSHS A,B,X,Y          
$2E85  30 8D DB 9B                        LEAX Dat_0A24,PC       ; X → Dat_0A24
$2E89  31 C9 0C A5                        LEAY 3237,U           
$2E8D  C6 4D                              LDB #$4D               ; B = 'M'
$2E8F  17 FE 94                           LBSR Sub_2D26          ; call Sub_2D26
$2E92  CC 16 03                           LDD #$1603            
$2E95  ED C9 0C 91                        STD 3217,U            
$2E99  CC 1D 04                           LDD #$1D04            
$2E9C  ED C9 0C 8F                        STD 3215,U            
$2EA0  17 ED DE                           LBSR Sub_1C81          ; call Sub_1C81
$2EA3  30 8D D5 E8                        LEAX Dat_048F,PC       ; X → Dat_048F
$2EA7  17 EC 59                           LBSR WriteBlock        ; call WriteBlock
$2EAA  30 8D DA 08                        LEAX Dat_08B6,PC       ; X → Dat_08B6
$2EAE  17 EC 52                           LBSR WriteBlock        ; call WriteBlock
$2EB1  8D 8B                              BSR Sub_2E3E           ; call Sub_2E3E
$2EB3  30 8D D5 D4                        LEAX Dat_048B,PC       ; X → Dat_048B
$2EB7  17 EC 49                           LBSR WriteBlock        ; call WriteBlock
$2EBA  17 EE 21                           LBSR Sub_1CDE          ; call Sub_1CDE
$2EBD  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2EBF  34 36               Sub_2EBF:      PSHS A,B,X,Y          
$2EC1  6D C8 72                           TST 114,U             
$2EC4  27 12                              BEQ Sub_2ED8          
$2EC6  6F C8 75                           CLR 117,U             
$2EC9  30 8D D4 99                        LEAX Dat_0366,PC       ; X → Dat_0366
$2ECD  31 C8 77                           LEAY 119,U            
$2ED0  C6 0B                              LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
$2ED2  17 FE 49                           LBSR Sub_2D1E          ; call Sub_2D1E
$2ED5  17 E0 48                           LBSR Sub_0F20          ; call Sub_0F20
$2ED8  17 14 EF            Sub_2ED8:      LBSR Sub_43CA          ; call Sub_43CA
$2EDB  6D C8 40                           TST 64,U              
$2EDE  27 03                              BEQ Sub_2EE3          
$2EE0  17 F7 2D                           LBSR Sub_2610          ; call Sub_2610
$2EE3  CC 00 00            Sub_2EE3:      LDD #$0000            
$2EE6  ED 49                              STD 9,U               
$2EE8  30 C9 16 B9                        LEAX 5817,U           
$2EEC  AF C9 00 93                        STX 147,U             
$2EF0  6F C8 64                           CLR 100,U             
$2EF3  17 EF E6                           LBSR Sub_1EDC          ; call Sub_1EDC
$2EF6  CC 05 03                           LDD #$0503            
$2EF9  ED C9 0C 8F                        STD 3215,U            
$2EFD  CC 44 11                           LDD #$4411            
$2F00  ED C9 0C 91                        STD 3217,U            
$2F04  17 ED 7A                           LBSR Sub_1C81          ; call Sub_1C81
$2F07  86 81                              LDA #$81              
$2F09  30 8D DB 24                        LEAX Dat_0A31,PC       ; X → Dat_0A31
$2F0D  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$2F10  10 25 00 86                        LBCS Sub_2F9A         
$2F14  A7 C8 3D                           STA 61,U              
$2F17  34 40                              PSHS U                
$2F19  8E 00 00                           LDX #$0000            
$2F1C  CE 00 40                           LDU #$0040            
$2F1F  10 3F 88                           OS9 I$Seek             ; path=A  mode=B  offset→X:D
$2F22  35 40                              PULS U                
$2F24  25 74                              BCS Sub_2F9A           ; C=1 (BLO)
$2F26  A6 C8 3D            Sub_2F26:      LDA 61,U              
$2F29  10 8E 00 20                        LDY #$0020            
$2F2D  30 C9 13 A9                        LEAX 5033,U           
$2F31  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2F34  24 06                              BCC Sub_2F3C           ; C=0 (BHS)
$2F36  C1 D3                              CMPB #$D3             
$2F38  26 60                              BNE Sub_2F9A          
$2F3A  20 10                              BRA Sub_2F4C          

; --------------------------------------------------------------
$2F3C  17 01 D9            Sub_2F3C:      LBSR Sub_3118          ; call Sub_3118
$2F3F  25 02                              BCS Sub_2F43           ; C=1 (BLO)
$2F41  8D 62                              BSR Sub_2FA5           ; call Sub_2FA5
$2F43  A6 C8 64            Sub_2F43:      LDA 100,U             
$2F46  81 1D                              CMPA #$1D             
$2F48  22 02                              BHI Sub_2F4C          
$2F4A  20 DA                              BRA Sub_2F26          

; --------------------------------------------------------------
$2F4C  A6 C8 64            Sub_2F4C:      LDA 100,U             
$2F4F  A7 C9 0C 98                        STA 3224,U            
$2F53  A6 C8 3D                           LDA 61,U              
$2F56  10 3F 8F                           OS9 I$Close            ; path=A
$2F59  17 00 DC                           LBSR Sub_3038          ; call Sub_3038
$2F5C  6D C9 00 92                        TST 146,U             
$2F60  27 17                              BEQ Sub_2F79          
$2F62  17 EC 62                           LBSR Sub_1BC7          ; call Sub_1BC7
$2F65  CC 00 00                           LDD #$0000            
$2F68  ED C9 13 1C                        STD 4892,U            
$2F6C  17 EF 6D                           LBSR Sub_1EDC          ; call Sub_1EDC
$2F6F  30 8D D5 1C                        LEAX Dat_048F,PC       ; X → Dat_048F
$2F73  17 EB 8D                           LBSR WriteBlock        ; call WriteBlock
$2F76  17 01 D2                           LBSR Sub_314B          ; call Sub_314B
$2F79  17 ED 62            Sub_2F79:      LBSR Sub_1CDE          ; call Sub_1CDE
$2F7C  17 EC 60                           LBSR Sub_1BDF          ; call Sub_1BDF
$2F7F  17 EC D5                           LBSR Sub_1C57          ; call Sub_1C57
$2F82  17 EF 57                           LBSR Sub_1EDC          ; call Sub_1EDC
$2F85  30 8D D5 02                        LEAX Dat_048B,PC       ; X → Dat_048B
$2F89  17 EB 77                           LBSR WriteBlock        ; call WriteBlock
$2F8C  35 36                              PULS A,B,X,Y          
$2F8E  10 AE C9 0C 88                     LDY 3208,U            
$2F93  30 C9 00 DF                        LEAX 223,U            
$2F97  16 E0 38                           LBRA Sub_0FD2         

; --------------------------------------------------------------
$2F9A  10 3F 0F            Sub_2F9A:      OS9 F$PErr             ; path=A  error=B
$2F9D  8E 00 78                           LDX #$0078            
$2FA0  17 DF B3                           LBSR Sub_0F56          ; call Sub_0F56
$2FA3  20 D4                              BRA Sub_2F79          

; --------------------------------------------------------------
$2FA5  34 36               Sub_2FA5:      PSHS A,B,X,Y          
$2FA7  30 C9 13 A9                        LEAX 5033,U           
$2FAB  10 AE C9 00 93                     LDY 147,U             
$2FB0  C6 1E                              LDB #$1E              
$2FB2  A6 80               Sub_2FB2:      LDA ,X+               
$2FB4  5A                                 DECB                  
$2FB5  4D                                 TSTA                  
$2FB6  2A 0B                              BPL Sub_2FC3          
$2FB8  80 80                              SUBA #$80             
$2FBA  A7 A0                              STA ,Y+               
$2FBC  CC 0A 0D                           LDD #$0A0D            
$2FBF  ED A4                              STD ,Y                
$2FC1  20 05                              BRA Sub_2FC8          

; --------------------------------------------------------------
$2FC3  A7 A0               Sub_2FC3:      STA ,Y+               
$2FC5  5D                                 TSTB                  
$2FC6  26 EA                              BNE Sub_2FB2          
$2FC8  6C C8 64            Sub_2FC8:      INC 100,U             
$2FCB  8D 41                              BSR Sub_300E           ; call Sub_300E
$2FCD  8D 0F                              BSR Sub_2FDE           ; call Sub_2FDE
$2FCF  10 AE C9 00 93                     LDY 147,U             
$2FD4  31 A8 20                           LEAY 32,Y             
$2FD7  10 AF C9 00 93                     STY 147,U             
$2FDC  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2FDE  34 36               Sub_2FDE:      PSHS A,B,X,Y          
$2FE0  AE C9 00 93                        LDX 147,U             
$2FE4  31 C9 13 A9                        LEAY 5033,U           
$2FE8  C6 1E                              LDB #$1E              
$2FEA  A6 80               Sub_2FEA:      LDA ,X+               
$2FEC  5A                                 DECB                  
$2FED  81 5F                              CMPA #$5F              ; compare A with '_'
$2FEF  26 02                              BNE Sub_2FF3          
$2FF1  86 20                              LDA #$20               ; A = ' '
$2FF3  81 2E               Sub_2FF3:      CMPA #$2E              ; compare A with '.'
$2FF5  26 03                              BNE Sub_2FFA          
$2FF7  86 0D                              LDA #$0D               ; A = CR
$2FF9  5F                                 CLRB                   ; B = 0
$2FFA  A7 A0               Sub_2FFA:      STA ,Y+               
$2FFC  5D                                 TSTB                  
$2FFD  26 EB                              BNE Sub_2FEA          
$2FFF  86 01                              LDA #$01              
$3001  10 8E 00 1E                        LDY #$001E            
$3005  30 C9 13 A9                        LEAX 5033,U           
$3009  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$300C  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$300E  34 36               Sub_300E:      PSHS A,B,X,Y          
$3010  30 C9 13 A9                        LEAX 5033,U           
$3014  E6 C8 64                           LDB 100,U             
$3017  C1 0F                              CMPB #$0F             
$3019  22 04                              BHI Sub_301F          
$301B  86 24                              LDA #$24               ; A = '$'
$301D  20 04                              BRA Sub_3023          

; --------------------------------------------------------------
$301F  86 45               Sub_301F:      LDA #$45               ; A = 'E'
$3021  C0 0F                              SUBB #$0F             
$3023  A7 01               Sub_3023:      STA 1,X               
$3025  86 02                              LDA #$02               ; A = CurXY
$3027  A7 84                              STA ,X                
$3029  CB 20                              ADDB #$20             
$302B  E7 02                              STB 2,X               
$302D  10 8E 00 03                        LDY #$0003            
$3031  86 01                              LDA #$01              
$3033  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3036  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3038  34 36               Sub_3038:      PSHS A,B,X,Y          
$303A  30 8D D4 51                        LEAX Dat_048F,PC       ; X → Dat_048F
$303E  17 EA C2                           LBSR WriteBlock        ; call WriteBlock
$3041  86 01                              LDA #$01              
$3043  A7 C9 00 92                        STA 146,U             
$3047  30 C9 13 A9         Sub_3047:      LEAX 5033,U           
$304B  A1 C9 0C 98                        CMPA 3224,U           
$304F  23 08                              BLS Sub_3059          
$3051  A6 C9 0C 98                        LDA 3224,U            
$3055  A7 C9 00 92                        STA 146,U             
$3059  81 0F               Sub_3059:      CMPA #$0F             
$305B  22 04                              BHI Sub_3061          
$305D  8B 20                              ADDA #$20             
$305F  20 02                              BRA Sub_3063          

; --------------------------------------------------------------
$3061  8B 11               Sub_3061:      ADDA #$11             
$3063  A7 02               Sub_3063:      STA 2,X               
$3065  A6 C9 00 92                        LDA 146,U             
$3069  81 0F                              CMPA #$0F             
$306B  22 04                              BHI Sub_3071          
$306D  86 21                              LDA #$21               ; A = '!'
$306F  20 02                              BRA Sub_3073          

; --------------------------------------------------------------
$3071  86 42               Sub_3071:      LDA #$42               ; A = 'B'
$3073  A7 01               Sub_3073:      STA 1,X               
$3075  86 02                              LDA #$02               ; A = CurXY
$3077  A7 84                              STA ,X                
$3079  17 00 8B                           LBSR Sub_3107          ; call Sub_3107
$307C  86 01                              LDA #$01              
$307E  10 8E 00 03                        LDY #$0003            
$3082  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3085  30 8D D6 0A                        LEAX Dat_0693,PC       ; X → Dat_0693
$3089  10 8E 00 03                        LDY #$0003            
$308D  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3090  17 FA 32            Sub_3090:      LBSR Sub_2AC5          ; call Sub_2AC5
$3093  81 08                              CMPA #$08              ; compare A with BS
$3095  26 10                              BNE Sub_30A7          
$3097  A6 C9 00 92         Sub_3097:      LDA 146,U             
$309B  81 0F                              CMPA #$0F             
$309D  22 04                              BHI Sub_30A3          
$309F  8B 0F                              ADDA #$0F             
$30A1  20 02                              BRA Sub_30A5          

; --------------------------------------------------------------
$30A3  80 0F               Sub_30A3:      SUBA #$0F             
$30A5  20 59               Sub_30A5:      BRA Sub_3100          
$30A7  81 09               Sub_30A7:      CMPA #$09             
$30A9  26 02                              BNE Sub_30AD          
$30AB  20 EA                              BRA Sub_3097          

; --------------------------------------------------------------
$30AD  81 0C               Sub_30AD:      CMPA #$0C              ; compare A with FF
$30AF  26 1A                              BNE Sub_30CB          
$30B1  A6 C9 00 92                        LDA 146,U             
$30B5  81 01                              CMPA #$01             
$30B7  27 08                              BEQ Sub_30C1          
$30B9  80 01                              SUBA #$01             
$30BB  A7 C9 00 92                        STA 146,U             
$30BF  20 3F                              BRA Sub_3100          

; --------------------------------------------------------------
$30C1  A6 C9 0C 98         Sub_30C1:      LDA 3224,U            
$30C5  A7 C9 00 92                        STA 146,U             
$30C9  20 35                              BRA Sub_3100          

; --------------------------------------------------------------
$30CB  81 0A               Sub_30CB:      CMPA #$0A              ; compare A with LF
$30CD  26 1A                              BNE Sub_30E9          
$30CF  A6 C9 00 92                        LDA 146,U             
$30D3  A1 C9 0C 98                        CMPA 3224,U           
$30D7  27 08                              BEQ Sub_30E1          
$30D9  8B 01                              ADDA #$01             
$30DB  A7 C9 00 92                        STA 146,U             
$30DF  20 1F                              BRA Sub_3100          

; --------------------------------------------------------------
$30E1  86 01               Sub_30E1:      LDA #$01              
$30E3  A7 C9 00 92                        STA 146,U             
$30E7  20 17                              BRA Sub_3100          

; --------------------------------------------------------------
$30E9  81 0D               Sub_30E9:      CMPA #$0D              ; compare A with CR
$30EB  26 09                              BNE Sub_30F6          
$30ED  30 8D D3 9A         Sub_30ED:      LEAX Dat_048B,PC       ; X → Dat_048B
$30F1  17 EA 0F                           LBSR WriteBlock        ; call WriteBlock
$30F4  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$30F6  81 05               Sub_30F6:      CMPA #$05             
$30F8  26 96                              BNE Sub_3090          
$30FA  6F C9 00 92                        CLR 146,U             
$30FE  20 ED                              BRA Sub_30ED          

; --------------------------------------------------------------
$3100  A7 C9 00 92         Sub_3100:      STA 146,U             
$3104  16 FF 40                           LBRA Sub_3047         

; --------------------------------------------------------------
$3107  34 32               Sub_3107:      PSHS A,X,Y            
$3109  86 01                              LDA #$01              
$310B  30 8D D5 73                        LEAX Dat_0682,PC       ; X → Dat_0682
$310F  10 8E 00 06                        LDY #$0006            
$3113  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3116  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3118  34 36               Sub_3118:      PSHS A,B,X,Y          
$311A  30 C9 13 A9                        LEAX 5033,U           
$311E  A6 84                              LDA ,X                
$3120  27 26                              BEQ Sub_3148          
$3122  C6 1B                              LDB #$1B               ; B = ESC
$3124  A6 80               Sub_3124:      LDA ,X+               
$3126  5A                                 DECB                  
$3127  81 2E                              CMPA #$2E              ; compare A with '.'
$3129  27 05                              BEQ Sub_3130          
$312B  5D                  Sub_312B:      TSTB                  
$312C  26 F6                              BNE Sub_3124          
$312E  20 18                              BRA Sub_3148          

; --------------------------------------------------------------
$3130  A6 80               Sub_3130:      LDA ,X+               
$3132  5A                                 DECB                  
$3133  81 61                              CMPA #$61              ; compare A with 'a'
$3135  26 F4                              BNE Sub_312B          
$3137  A6 80                              LDA ,X+               
$3139  5A                                 DECB                  
$313A  81 64                              CMPA #$64              ; compare A with 'd'
$313C  26 ED                              BNE Sub_312B          
$313E  A6 80                              LDA ,X+               
$3140  5A                                 DECB                  
$3141  81 E6                              CMPA #$E6             
$3143  26 E6                              BNE Sub_312B          
$3145  5F                                 CLRB                   ; B = 0
$3146  35 B6               Sub_3146:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$3148  53                  Sub_3148:      COMB                  
$3149  20 FB                              BRA Sub_3146          

; --------------------------------------------------------------
$314B  34 36               Sub_314B:      PSHS A,B,X,Y          
$314D  A6 C9 00 92                        LDA 146,U             
$3151  4A                                 DECA                  
$3152  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$3154  3D                                 MUL                    ; D = A×B unsigned
$3155  30 C9 16 B9                        LEAX 5817,U           
$3159  30 8B                              LEAX D,X              
$315B  AF C9 00 93                        STX 147,U             
$315F  34 10                              PSHS X                
$3161  30 C9 13 A9                        LEAX 5033,U           
$3165  31 8D D8 C8                        LEAY Dat_0A31,PC       ; Y → Dat_0A31
$3169  A6 A0               Sub_3169:      LDA ,Y+               
$316B  2B 04                              BMI Sub_3171          
$316D  A7 80                              STA ,X+               
$316F  20 F8                              BRA Sub_3169          

; --------------------------------------------------------------
$3171  80 80               Sub_3171:      SUBA #$80             
$3173  C6 2F                              LDB #$2F               ; B = '/'
$3175  ED 81                              STD ,X++              
$3177  1F 12                              TFR X,Y               
$3179  35 10                              PULS X                
$317B  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$317D  A6 80               Sub_317D:      LDA ,X+               
$317F  2B 07                              BMI Sub_3188          
$3181  A7 A0                              STA ,Y+               
$3183  5A                                 DECB                  
$3184  26 F7                              BNE Sub_317D          
$3186  20 02                              BRA Sub_318A          

; --------------------------------------------------------------
$3188  A7 A0               Sub_3188:      STA ,Y+               
$318A  30 C9 13 A9         Sub_318A:      LEAX 5033,U           
$318E  86 01                              LDA #$01              
$3190  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$3193  25 3A                              BCS Sub_31CF           ; C=1 (BLO)
$3195  A7 C8 3D                           STA 61,U              
$3198  17 F3 36                           LBSR Sub_24D1          ; call Sub_24D1
$319B  86 01                              LDA #$01              
$319D  A7 C9 0D 19                        STA 3353,U            
$31A1  86 1E                              LDA #$1E              
$31A3  A7 C9 0D 1A                        STA 3354,U            
$31A7  A6 C8 3D            Sub_31A7:      LDA 61,U              
$31AA  30 C9 13 A9                        LEAX 5033,U           
$31AE  10 8E 00 50                        LDY #$0050            
$31B2  10 3F 8B                           OS9 I$ReadLn           ; path=A  max=Y  buf→X
$31B5  24 06                              BCC Sub_31BD           ; C=0 (BHS)
$31B7  C1 D3                              CMPB #$D3             
$31B9  26 14                              BNE Sub_31CF          
$31BB  20 04                              BRA Sub_31C1          

; --------------------------------------------------------------
$31BD  8D 15               Sub_31BD:      BSR Sub_31D4           ; call Sub_31D4
$31BF  20 E6                              BRA Sub_31A7          

; --------------------------------------------------------------
$31C1  A6 C8 3D            Sub_31C1:      LDA 61,U              
$31C4  10 3F 8F                           OS9 I$Close            ; path=A
$31C7  17 DF C5                           LBSR Sub_118F          ; call Sub_118F
$31CA  16 02 13                           LBRA Sub_33E0         

; --------------------------------------------------------------
$31CD  35 B6               Sub_31CD:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$31CF  10 3F 0F            Sub_31CF:      OS9 F$PErr             ; path=A  error=B
$31D2  20 F9                              BRA Sub_31CD          

; --------------------------------------------------------------
$31D4  34 36               Sub_31D4:      PSHS A,B,X,Y          
$31D6  4F                                 CLRA                   ; A = 0
$31D7  31 8D D4 F6                        LEAY Dat_06D1,PC       ; Y → Dat_06D1
$31DB  30 C9 13 A9         Sub_31DB:      LEAX 5033,U           
$31DF  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$31E1  4C                                 INCA                  
$31E2  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$31E5  31 23                              LEAY 3,Y              
$31E7  24 04                              BCC Sub_31ED           ; C=0 (BHS)
$31E9  81 20                              CMPA #$20              ; compare A with ' '
$31EB  25 EE                              BCS Sub_31DB           ; C=1 (BLO)
$31ED  81 1F               Sub_31ED:      CMPA #$1F             
$31EF  22 7E                              BHI Sub_326F          
$31F1  30 03                              LEAX 3,X              
$31F3  E6 80                              LDB ,X+               
$31F5  C1 3D                              CMPB #$3D              ; compare B with '='
$31F7  26 76                              BNE Sub_326F          
$31F9  81 01                              CMPA #$01             
$31FB  27 74                              BEQ Sub_3271          
$31FD  81 02                              CMPA #$02              ; compare A with CurXY
$31FF  10 27 00 87                        LBEQ Sub_328A         
$3203  81 03                              CMPA #$03             
$3205  10 27 00 9A                        LBEQ Sub_32A3         
$3209  81 04                              CMPA #$04             
$320B  10 27 00 A2                        LBEQ Sub_32B1         
$320F  81 05                              CMPA #$05             
$3211  10 27 00 AA                        LBEQ Sub_32BF         
$3215  81 06                              CMPA #$06             
$3217  10 27 00 B3                        LBEQ Sub_32CE         
$321B  81 07                              CMPA #$07             
$321D  10 27 00 BF                        LBEQ Sub_32E0         
$3221  81 08                              CMPA #$08              ; compare A with BS
$3223  10 27 00 C2                        LBEQ Sub_32E9         
$3227  81 09                              CMPA #$09             
$3229  10 27 00 C6                        LBEQ Sub_32F3         
$322D  81 0A                              CMPA #$0A              ; compare A with LF
$322F  10 27 00 CA                        LBEQ Sub_32FD         
$3233  81 0B                              CMPA #$0B             
$3235  10 27 00 CE                        LBEQ Sub_3307         
$3239  81 0C                              CMPA #$0C              ; compare A with FF
$323B  10 27 00 D2                        LBEQ Sub_3311         
$323F  81 0D                              CMPA #$0D              ; compare A with CR
$3241  10 27 00 DB                        LBEQ Sub_3320         
$3245  81 0E                              CMPA #$0E             
$3247  10 27 00 ED                        LBEQ Sub_3338         
$324B  81 16                              CMPA #$16             
$324D  10 23 01 07                        LBLS Sub_3358         
$3251  81 17                              CMPA #$17             
$3253  10 27 01 27                        LBEQ Sub_337E         
$3257  81 1B                              CMPA #$1B              ; compare A with ESC
$3259  10 23 F2 AB                        LBLS Sub_2508         
$325D  81 1F                              CMPA #$1F             
$325F  10 23 F2 80                        LBLS Sub_24E3         
$3263  81 20                              CMPA #$20              ; compare A with ' '
$3265  10 27 01 29                        LBEQ Sub_3392         
$3269  81 21                              CMPA #$21              ; compare A with '!'
$326B  10 27 01 32                        LBEQ Sub_33A1         
$326F  35 B6               Sub_326F:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$3271  31 C9 0C F2         Sub_3271:      LEAY 3314,U           
$3275  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$3277  A6 80               Sub_3277:      LDA ,X+               
$3279  81 0D                              CMPA #$0D              ; compare A with CR
$327B  27 07                              BEQ Sub_3284          
$327D  A7 A0                              STA ,Y+               
$327F  5A                                 DECB                  
$3280  26 F5                              BNE Sub_3277          
$3282  20 04                              BRA Sub_3288          

; --------------------------------------------------------------
$3284  A7 A0               Sub_3284:      STA ,Y+               
$3286  6F A0                              CLR ,Y+               
$3288  20 E5               Sub_3288:      BRA Sub_326F          
$328A  17 01 23            Sub_328A:      LBSR Sub_33B0          ; call Sub_33B0
$328D  C4 07                              ANDB #$07             
$328F  A6 C9 0C A5                        LDA 3237,U            
$3293  84 F8                              ANDA #$F8             
$3295  A7 C9 0C A5                        STA 3237,U            
$3299  EA C9 0C A5                        ORB 3237,U            
$329D  E7 C9 0C A5                        STB 3237,U            
$32A1  20 CC                              BRA Sub_326F          

; --------------------------------------------------------------
$32A3  17 01 0A            Sub_32A3:      LBSR Sub_33B0          ; call Sub_33B0
$32A6  5D                                 TSTB                  
$32A7  27 02                              BEQ Sub_32AB          
$32A9  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$32AB  E7 C9 0C A7         Sub_32AB:      STB 3239,U            
$32AF  20 BE                              BRA Sub_326F          

; --------------------------------------------------------------
$32B1  17 00 FC            Sub_32B1:      LBSR Sub_33B0          ; call Sub_33B0
$32B4  5D                                 TSTB                  
$32B5  27 02                              BEQ Sub_32B9          
$32B7  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$32B9  E7 C9 0C B1         Sub_32B9:      STB 3249,U            
$32BD  20 B0                              BRA Sub_326F          

; --------------------------------------------------------------
$32BF  17 00 EE            Sub_32BF:      LBSR Sub_33B0          ; call Sub_33B0
$32C2  C1 03                              CMPB #$03             
$32C4  25 02                              BCS Sub_32C8           ; C=1 (BLO)
$32C6  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$32C8  E7 C9 0C A6         Sub_32C8:      STB 3238,U            
$32CC  20 A1                              BRA Sub_326F          

; --------------------------------------------------------------
$32CE  17 00 DF            Sub_32CE:      LBSR Sub_33B0          ; call Sub_33B0
$32D1  5D                                 TSTB                  
$32D2  27 02                              BEQ Sub_32D6          
$32D4  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$32D6  E7 C9 0C A8         Sub_32D6:      STB 3240,U            
$32DA  E7 C9 0C A9                        STB 3241,U            
$32DE  20 8F                              BRA Sub_326F          

; --------------------------------------------------------------
$32E0  17 00 CD            Sub_32E0:      LBSR Sub_33B0          ; call Sub_33B0
$32E3  E7 C9 0C AF                        STB 3247,U            
$32E7  20 86                              BRA Sub_326F          

; --------------------------------------------------------------
$32E9  17 00 C4            Sub_32E9:      LBSR Sub_33B0          ; call Sub_33B0
$32EC  E7 C9 0C B0                        STB 3248,U            
$32F0  16 FF 7C                           LBRA Sub_326F         

; --------------------------------------------------------------
$32F3  17 00 BA            Sub_32F3:      LBSR Sub_33B0          ; call Sub_33B0
$32F6  E7 C9 0D 19                        STB 3353,U            
$32FA  16 FF 72                           LBRA Sub_326F         

; --------------------------------------------------------------
$32FD  17 00 B0            Sub_32FD:      LBSR Sub_33B0          ; call Sub_33B0
$3300  E7 C9 0D 1A                        STB 3354,U            
$3304  16 FF 68                           LBRA Sub_326F         

; --------------------------------------------------------------
$3307  17 00 A6            Sub_3307:      LBSR Sub_33B0          ; call Sub_33B0
$330A  E7 C9 0C AC                        STB 3244,U            
$330E  16 FF 5E                           LBRA Sub_326F         

; --------------------------------------------------------------
$3311  17 00 9C            Sub_3311:      LBSR Sub_33B0          ; call Sub_33B0
$3314  5D                                 TSTB                  
$3315  27 02                              BEQ Sub_3319          
$3317  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3319  E7 C9 0C AA         Sub_3319:      STB 3242,U            
$331D  16 FF 4F                           LBRA Sub_326F         

; --------------------------------------------------------------
$3320  17 00 8D            Sub_3320:      LBSR Sub_33B0          ; call Sub_33B0
$3323  A6 C9 0C A5                        LDA 3237,U            
$3327  84 4F                              ANDA #$4F             
$3329  A7 C9 0C A5                        STA 3237,U            
$332D  EA C9 0C A5                        ORB 3237,U            
$3331  E7 C9 0C A5                        STB 3237,U            
$3335  16 FF 37                           LBRA Sub_326F         

; --------------------------------------------------------------
$3338  8D 76               Sub_3338:      BSR Sub_33B0           ; call Sub_33B0
$333A  5D                                 TSTB                  
$333B  27 07                              BEQ Sub_3344          
$333D  C1 80                              CMPB #$80             
$333F  27 03                              BEQ Sub_3344          
$3341  16 FF 2B            Sub_3341:      LBRA Sub_326F         
$3344  A6 C9 0C A5         Sub_3344:      LDA 3237,U            
$3348  84 7F                              ANDA #$7F             
$334A  A7 C9 0C A5                        STA 3237,U            
$334E  EA C9 0C A5                        ORB 3237,U            
$3352  E7 C9 0C A5                        STB 3237,U            
$3356  20 E9                              BRA Sub_3341          

; --------------------------------------------------------------
$3358  A6 1E               Sub_3358:      LDA -2,X              
$335A  80 31                              SUBA #$31             
$335C  81 07                              CMPA #$07             
$335E  22 1B                              BHI Sub_337B          
$3360  C6 80                              LDB #$80              
$3362  3D                                 MUL                    ; D = A×B unsigned
$3363  31 C9 0D 1C                        LEAY 3356,U           
$3367  31 AB                              LEAY D,Y              
$3369  C6 80                              LDB #$80              
$336B  A6 80               Sub_336B:      LDA ,X+               
$336D  81 0D                              CMPA #$0D              ; compare A with CR
$336F  27 07                              BEQ Sub_3378          
$3371  A7 A0                              STA ,Y+               
$3373  5A                                 DECB                  
$3374  26 F5                              BNE Sub_336B          
$3376  20 03                              BRA Sub_337B          

; --------------------------------------------------------------
$3378  5F                  Sub_3378:      CLRB                   ; B = 0
$3379  ED A4                              STD ,Y                
$337B  16 FE F1            Sub_337B:      LBRA Sub_326F         
$337E  31 C9 13 1C         Sub_337E:      LEAY 4892,U           
$3382  C6 80                              LDB #$80              
$3384  A6 80               Sub_3384:      LDA ,X+               
$3386  81 0D                              CMPA #$0D              ; compare A with CR
$3388  27 EE                              BEQ Sub_3378          
$338A  A7 A0                              STA ,Y+               
$338C  5A                                 DECB                  
$338D  26 F5                              BNE Sub_3384          
$338F  16 FE DD                           LBRA Sub_326F         

; --------------------------------------------------------------
$3392  17 00 1B            Sub_3392:      LBSR Sub_33B0          ; call Sub_33B0
$3395  5D                                 TSTB                  
$3396  27 02                              BEQ Sub_339A          
$3398  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$339A  E7 C9 0C A9         Sub_339A:      STB 3241,U            
$339E  16 FE CE                           LBRA Sub_326F         

; --------------------------------------------------------------
$33A1  17 00 0C            Sub_33A1:      LBSR Sub_33B0          ; call Sub_33B0
$33A4  5D                                 TSTB                  
$33A5  27 02                              BEQ Sub_33A9          
$33A7  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$33A9  E7 C9 0C A8         Sub_33A9:      STB 3240,U            
$33AD  16 FE BF                           LBRA Sub_326F         

; --------------------------------------------------------------
$33B0  A6 01               Sub_33B0:      LDA 1,X               
$33B2  81 21                              CMPA #$21              ; compare A with '!'
$33B4  25 1C                              BCS Sub_33D2           ; C=1 (BLO)
$33B6  A6 84                              LDA ,X                
$33B8  80 30                              SUBA #$30             
$33BA  81 0A                              CMPA #$0A              ; compare A with LF
$33BC  25 02                              BCS Sub_33C0           ; C=1 (BLO)
$33BE  80 07                              SUBA #$07             
$33C0  C6 10               Sub_33C0:      LDB #$10              
$33C2  3D                                 MUL                    ; D = A×B unsigned
$33C3  A6 01                              LDA 1,X               
$33C5  80 30                              SUBA #$30             
$33C7  81 0A                              CMPA #$0A              ; compare A with LF
$33C9  25 02                              BCS Sub_33CD           ; C=1 (BLO)
$33CB  80 07                              SUBA #$07             
$33CD  A7 01               Sub_33CD:      STA 1,X               
$33CF  EB 01                              ADDB 1,X              
$33D1  39                  Sub_33D1:      RTS                    ; return from subroutine
$33D2  A6 84               Sub_33D2:      LDA ,X                
$33D4  80 30                              SUBA #$30             
$33D6  81 0A                              CMPA #$0A              ; compare A with LF
$33D8  25 02                              BCS Sub_33DC           ; C=1 (BLO)
$33DA  80 07                              SUBA #$07             
$33DC  1F 89               Sub_33DC:      TFR A,B               
$33DE  20 F1                              BRA Sub_33D1          

; --------------------------------------------------------------
$33E0  6D C9 0D 19         Sub_33E0:      TST 3353,U            
$33E4  26 07                              BNE Sub_33ED          
$33E6  6F C9 13 1C                        CLR 4892,U            
$33EA  16 01 46                           LBRA Sub_3533         

; --------------------------------------------------------------
$33ED  17 E8 EE            Sub_33ED:      LBSR Sub_1CDE          ; call Sub_1CDE
$33F0  CC 14 03                           LDD #$1403            
$33F3  ED C9 0C 8F                        STD 3215,U            
$33F7  CC 28 08                           LDD #$2808            
$33FA  ED C9 0C 91                        STD 3217,U            
$33FE  17 E8 80                           LBSR Sub_1C81          ; call Sub_1C81
$3401  30 8D D0 AC                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$3405  17 E6 FB                           LBSR WriteBlock        ; call WriteBlock
$3408  17 EF C5                           LBSR Sub_23D0          ; call Sub_23D0
$340B  30 8D D0 CC                        LEAX Dat_04DB,PC       ; X → Dat_04DB
$340F  17 E6 F1                           LBSR WriteBlock        ; call WriteBlock
$3412  17 FB C9                           LBSR Sub_2FDE          ; call Sub_2FDE
$3415  30 8D D0 CC                        LEAX Dat_04E5,PC       ; X → Dat_04E5
$3419  17 E6 E7                           LBSR WriteBlock        ; call WriteBlock
$341C  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$341E  E7 C9 13 9F                        STB 5023,U            
$3422  17 01 26                           LBSR Sub_354B          ; call Sub_354B
$3425  30 C9 0C F2                        LEAX 3314,U           
$3429  5F                                 CLRB                   ; B = 0
$342A  A6 80               Sub_342A:      LDA ,X+               
$342C  5C                                 INCB                  
$342D  C1 20                              CMPB #$20              ; compare B with ' '
$342F  22 03                              BHI Sub_3434          
$3431  4D                                 TSTA                  
$3432  26 F6                              BNE Sub_342A          
$3434  5A                  Sub_3434:      DECB                  
$3435  26 07                              BNE Sub_343E          
$3437  6F C9 13 1C                        CLR 4892,U            
$343B  16 00 F5                           LBRA Sub_3533         

; --------------------------------------------------------------
$343E  4F                  Sub_343E:      CLRA                   ; A = 0
$343F  1F 02                              TFR D,Y               
$3441  10 AF C9 0C A1                     STY 3233,U            
$3446  30 8D CE 92         Sub_3446:      LEAX Dat_02DC,PC       ; X → Dat_02DC
$344A  10 8E 00 04                        LDY #$0004            
$344E  A6 C8 2B                           LDA 43,U              
$3451  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3454  8E 00 5A                           LDX #$005A            
$3457  17 DA FC                           LBSR Sub_0F56          ; call Sub_0F56
$345A  A6 C8 2B                           LDA 43,U              
$345D  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$345F  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3462  24 0A                              BCC Sub_346E           ; C=0 (BHS)
$3464  17 F8 C7                           LBSR Sub_2D2E          ; call Sub_2D2E
$3467  25 05                              BCS Sub_346E           ; C=1 (BLO)
$3469  6F C8 22                           CLR 34,U              
$346C  20 05                              BRA Sub_3473          

; --------------------------------------------------------------
$346E  86 01               Sub_346E:      LDA #$01              
$3470  A7 C8 22                           STA 34,U              
$3473  17 F8 DA            Sub_3473:      LBSR Sub_2D50          ; call Sub_2D50
$3476  10 AE C9 0C A1                     LDY 3233,U            
$347B  30 C9 0C F2                        LEAX 3314,U           
$347F  A6 C8 2B                           LDA 43,U              
$3482  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3485  17 F8 C8                           LBSR Sub_2D50          ; call Sub_2D50
$3488  C6 FF                              LDB #$FF              
$348A  E7 C9 0C A4                        STB 3236,U            
$348E  17 E6 BD            Sub_348E:      LBSR Sub_1B4E          ; call Sub_1B4E
$3491  A7 C9 0C A3                        STA 3235,U            
$3495  6D C8 22            Sub_3495:      TST 34,U              
$3498  27 0C                              BEQ Sub_34A6          
$349A  17 F9 40                           LBSR Sub_2DDD          ; call Sub_2DDD
$349D  24 6A                              BCC Sub_3509           ; C=0 (BHS)
$349F  17 F9 7C                           LBSR Sub_2E1E          ; call Sub_2E1E
$34A2  25 07                              BCS Sub_34AB           ; C=1 (BLO)
$34A4  20 36                              BRA Sub_34DC          

; --------------------------------------------------------------
$34A6  17 F8 85            Sub_34A6:      LBSR Sub_2D2E          ; call Sub_2D2E
$34A9  25 5E                              BCS Sub_3509           ; C=1 (BLO)
$34AB  86 00               Sub_34AB:      LDA #$00               ; A = NUL
$34AD  C6 27                              LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
$34AF  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$34B2  81 80                              CMPA #$80             
$34B4  26 06                              BNE Sub_34BC          
$34B6  6F C9 13 1C                        CLR 4892,U            
$34BA  20 77                              BRA Sub_3533          

; --------------------------------------------------------------
$34BC  17 E6 8F            Sub_34BC:      LBSR Sub_1B4E          ; call Sub_1B4E
$34BF  A1 C9 0C A3                        CMPA 3235,U           
$34C3  27 D0                              BEQ Sub_3495          
$34C5  6C C9 0C A4                        INC 3236,U            
$34C9  30 8D D0 1D                        LEAX Dat_04EA,PC       ; X → Dat_04EA
$34CD  17 E6 33                           LBSR WriteBlock        ; call WriteBlock
$34D0  E6 C9 0C A4                        LDB 3236,U            
$34D4  8D 75                              BSR Sub_354B           ; call Sub_354B
$34D6  E1 C9 0D 1A                        CMPB 3354,U           
$34DA  25 B2                              BCS Sub_348E           ; C=1 (BLO)
$34DC  6C C9 13 9F         Sub_34DC:      INC 5023,U            
$34E0  30 8D D0 01                        LEAX Dat_04E5,PC       ; X → Dat_04E5
$34E4  17 E6 1C                           LBSR WriteBlock        ; call WriteBlock
$34E7  E6 C9 13 9F                        LDB 5023,U            
$34EB  8D 5E                              BSR Sub_354B           ; call Sub_354B
$34ED  E6 C9 0D 19                        LDB 3353,U            
$34F1  C1 FF                              CMPB #$FF             
$34F3  10 27 FF 4F                        LBEQ Sub_3446         
$34F7  E6 C9 13 9F                        LDB 5023,U            
$34FB  E1 C9 0D 19                        CMPB 3353,U           
$34FF  10 25 FF 43                        LBCS Sub_3446         
$3503  6F C9 13 1C                        CLR 4892,U            
$3507  20 2A                              BRA Sub_3533          

; --------------------------------------------------------------
$3509  86 01               Sub_3509:      LDA #$01              
$350B  C6 98                              LDB #$98              
$350D  8E 3F 06                           LDX #$3F06            
$3510  10 8E 0D 00                        LDY #$0D00            
$3514  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$3517  10 8E 0E 00                        LDY #$0E00            
$351B  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$351E  10 8E 0F 00                        LDY #$0F00            
$3522  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$3525  6D C8 72                           TST 114,U             
$3528  27 09                              BEQ Sub_3533          
$352A  6C C8 75                           INC 117,U             
$352D  A6 C8 73                           LDA 115,U             
$3530  A7 C8 74                           STA 116,U             
$3533  17 E6 77            Sub_3533:      LBSR Sub_1BAD          ; call Sub_1BAD
$3536  A6 C8 3D                           LDA 61,U              
$3539  10 3F 8F                           OS9 I$Close            ; path=A
$353C  6D C9 13 1C                        TST 4892,U            
$3540  27 03                              BEQ Sub_3545          
$3542  17 E4 D4                           LBSR Sub_1A19          ; call Sub_1A19
$3545  17 DD 6D            Sub_3545:      LBSR Sub_12B5          ; call Sub_12B5
$3548  16 FC 82                           LBRA Sub_31CD         

; --------------------------------------------------------------
$354B  34 16               Sub_354B:      PSHS A,B,X            
$354D  30 C9 13 A9                        LEAX 5033,U           
$3551  4F                                 CLRA                   ; A = 0
$3552  C1 64               Sub_3552:      CMPB #$64              ; compare B with 'd'
$3554  25 05                              BCS Sub_355B           ; C=1 (BLO)
$3556  C0 64                              SUBB #$64             
$3558  4C                                 INCA                  
$3559  20 F7                              BRA Sub_3552          

; --------------------------------------------------------------
$355B  8B 30               Sub_355B:      ADDA #$30             
$355D  A7 80                              STA ,X+               
$355F  4F                                 CLRA                   ; A = 0
$3560  C1 0A               Sub_3560:      CMPB #$0A              ; compare B with LF
$3562  25 05                              BCS Sub_3569           ; C=1 (BLO)
$3564  C0 0A                              SUBB #$0A             
$3566  4C                                 INCA                  
$3567  20 F7                              BRA Sub_3560          

; --------------------------------------------------------------
$3569  8B 30               Sub_3569:      ADDA #$30             
$356B  A7 80                              STA ,X+               
$356D  CB 30                              ADDB #$30             
$356F  E7 80                              STB ,X+               
$3571  30 C9 13 A9                        LEAX 5033,U           
$3575  10 8E 00 03                        LDY #$0003            
$3579  86 01                              LDA #$01              
$357B  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$357E  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3580  30 8D CF 0B         Sub_3580:      LEAX Dat_048F,PC       ; X → Dat_048F
$3584  6C C9 0C A0                        INC 3232,U            
$3588  17 E5 78                           LBSR WriteBlock        ; call WriteBlock
$358B  CC 1C 05                           LDD #$1C05            
$358E  ED C9 0C 8F                        STD 3215,U            
$3592  CC 19 07                           LDD #$1907            
$3595  ED C9 0C 91                        STD 3217,U            
$3599  17 E6 E5                           LBSR Sub_1C81          ; call Sub_1C81
$359C  30 8D D1 94                        LEAX Dat_0734,PC       ; X → Dat_0734
$35A0  17 E5 60                           LBSR WriteBlock        ; call WriteBlock
$35A3  86 04                              LDA #$04              
$35A5  A7 C9 13 9E                        STA 5022,U            
$35A9  E6 C8 4B                           LDB 75,U              
$35AC  17 E8 09                           LBSR Sub_1DB8          ; call Sub_1DB8
$35AF  17 E7 2C                           LBSR Sub_1CDE          ; call Sub_1CDE
$35B2  30 8D CE D5                        LEAX Dat_048B,PC       ; X → Dat_048B
$35B6  17 E5 4A                           LBSR WriteBlock        ; call WriteBlock
$35B9  6F C8 46                           CLR BSS.EchoFlag,U    
$35BC  E6 C9 0C 84                        LDB 3204,U            
$35C0  27 14                              BEQ Sub_35D6          
$35C2  C1 03                              CMPB #$03             
$35C4  22 16                              BHI Sub_35DC          
$35C6  E7 C8 4B                           STB 75,U              
$35C9  C1 02                              CMPB #$02              ; compare B with CurXY
$35CB  10 22 E1 C4                        LBHI Sub_1793         
$35CF  25 77                              BCS Sub_3648           ; C=1 (BLO)
$35D1  6C C8 46                           INC BSS.EchoFlag,U    
$35D4  20 72                              BRA Sub_3648          

; --------------------------------------------------------------
$35D6  E7 C8 4B            Sub_35D6:      STB 75,U              
$35D9  16 0C 57                           LBRA Sub_4233         

; --------------------------------------------------------------
$35DC  16 D6 7F            Sub_35DC:      LBRA Sub_0C5E         
$35DF  30 8D CE AC         Sub_35DF:      LEAX Dat_048F,PC       ; X → Dat_048F
$35E3  6F C9 0C A0                        CLR 3232,U            
$35E7  17 E5 19                           LBSR WriteBlock        ; call WriteBlock
$35EA  CC 1C 05                           LDD #$1C05            
$35ED  ED C9 0C 8F                        STD 3215,U            
$35F1  CC 19 08                           LDD #$1908            
$35F4  ED C9 0C 91                        STD 3217,U            
$35F8  17 E6 86                           LBSR Sub_1C81          ; call Sub_1C81
$35FB  30 8D D1 A6                        LEAX Dat_07A5,PC       ; X → Dat_07A5
$35FF  17 E5 01                           LBSR WriteBlock        ; call WriteBlock
$3602  86 05                              LDA #$05              
$3604  A7 C9 13 9E                        STA 5022,U            
$3608  E6 C8 4A                           LDB BSS.FlowCtrl,U    
$360B  17 E7 AA                           LBSR Sub_1DB8          ; call Sub_1DB8
$360E  17 E6 CD                           LBSR Sub_1CDE          ; call Sub_1CDE
$3611  30 8D CE 76                        LEAX Dat_048B,PC       ; X → Dat_048B
$3615  17 E4 EB                           LBSR WriteBlock        ; call WriteBlock
$3618  6F C8 46                           CLR BSS.EchoFlag,U    
$361B  6F C8 45                           CLR 69,U              
$361E  E6 C9 0C 84                        LDB 3204,U            
$3622  27 1B                              BEQ Sub_363F          
$3624  C1 04                              CMPB #$04             
$3626  22 B4                              BHI Sub_35DC          
$3628  E7 C8 4A                           STB BSS.FlowCtrl,U    
$362B  C1 02                              CMPB #$02              ; compare B with CurXY
$362D  25 19                              BCS Sub_3648           ; C=1 (BLO)
$362F  6C C8 45                           INC 69,U              
$3632  C1 03                              CMPB #$03             
$3634  25 12                              BCS Sub_3648           ; C=1 (BLO)
$3636  10 22 E2 1F                        LBHI Sub_1859         
$363A  6C C8 46                           INC BSS.EchoFlag,U    
$363D  20 09                              BRA Sub_3648          

; --------------------------------------------------------------
$363F  E7 C8 4A            Sub_363F:      STB BSS.FlowCtrl,U    
$3642  16 0B EE                           LBRA Sub_4233         
         FCB    $16,$D6,$16  ; unreachable padding
$3648  34 36               Sub_3648:      PSHS A,B,X,Y          
$364A  16 00 A7                           LBRA Sub_36F4         

; --------------------------------------------------------------
$364D  86 FF               Sub_364D:      LDA #$FF              
$364E  FF                  Sub_364E:      EQU    $364E            ; mid-instruction overlap: Sub_364D+1 -- mid-instruction entry point -- byte 2 of LDA #$FF (86 FF) at $364D
$364F  A7 C8 42                           STA 66,U              
$3652  6F C8 69                           CLR 105,U             
$3655  6F C8 5F                           CLR BSS.BufCount,U    
$3658  6F C8 4C                           CLR 76,U              
$365B  6F C8 6A                           CLR 106,U             
$365E  6F C8 62                           CLR 98,U              
$3661  6F C8 52                           CLR 82,U              
$3664  6F C9 00 9B                        CLR 155,U             
$3668  30 C9 13 A9                        LEAX 5033,U           
$366C  A6 C8 2B                           LDA 43,U              
$366F  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$3671  34 06                              PSHS A,B              
$3673  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3676  30 C9 13 A9                        LEAX 5033,U           
$367A  A6 88 15                           LDA 21,X              
$367D  84 0F                              ANDA #$0F             
$367F  A7 88 15                           STA 21,X              
$3682  A6 88 14                           LDA 20,X              
$3685  84 03                              ANDA #$03             
$3687  A7 88 14                           STA 20,X              
$368A  4F                                 CLRA                   ; A = 0
$368B  5F                                 CLRB                   ; B = 0
$368C  ED 88 18                           STD 24,X              
$368F  ED 04                              STD 4,X               
$3691  35 06                              PULS A,B              
$3693  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$3696  A6 C9 0C B0                        LDA 3248,U            
$369A  E6 C9 0C AF                        LDB 3247,U            
$369E  34 06                              PSHS A,B              
$36A0  4F                                 CLRA                   ; A = 0
$36A1  A7 C9 0C AF                        STA 3247,U            
$36A5  A7 C9 0C B0                        STA 3248,U            
$36A9  17 0D 1E                           LBSR Sub_43CA          ; call Sub_43CA
$36AC  35 06                              PULS A,B              
$36AE  A7 C9 0C B0                        STA 3248,U            
$36B2  E7 C9 0C AF                        STB 3247,U            
$36B6  CC 00 00                           LDD #$0000            
$36B9  ED 49                              STD 9,U               
$36BB  CC 15 04                           LDD #$1504            
$36BE  ED C9 0C 8F                        STD 3215,U            
$36C2  CC 25 09                           LDD #$2509            
$36C5  ED C9 0C 91                        STD 3217,U            
$36C9  17 E5 B5                           LBSR Sub_1C81          ; call Sub_1C81
$36CC  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$36CD  34 36               Sub_36CD:      PSHS A,B,X,Y          
$36CF  17 04 EA            Sub_36CF:      LBSR Sub_3BBC          ; call Sub_3BBC
$36D2  A6 C8 2B            Sub_36D2:      LDA 43,U              
$36D5  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$36D7  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$36DA  24 09                              BCC Sub_36E5           ; C=0 (BHS)
$36DC  17 04 FB                           LBSR Sub_3BDA          ; call Sub_3BDA
$36DF  81 02                              CMPA #$02              ; compare A with CurXY
$36E1  25 EF                              BCS Sub_36D2           ; C=1 (BLO)
$36E3  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$36E5  4F                  Sub_36E5:      CLRA                   ; A = 0
$36E6  1F 02                              TFR D,Y               
$36E8  A6 C8 2B                           LDA 43,U              
$36EB  30 C9 13 A9                        LEAX 5033,U           
$36EF  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$36F2  20 DB                              BRA Sub_36CF          

; --------------------------------------------------------------
$36F4  17 FF 56            Sub_36F4:      LBSR Sub_364D          ; call Sub_364D
$36F7  30 8D CD F4                        LEAX Dat_04EF,PC       ; X → Dat_04EF
$36FB  17 E4 05                           LBSR WriteBlock        ; call WriteBlock
$36FE  6D C8 46                           TST BSS.EchoFlag,U    
$3701  27 07                              BEQ Sub_370A          
$3703  30 8D CE 0A                        LEAX Dat_0511,PC       ; X → Dat_0511
$3707  17 E3 F9                           LBSR WriteBlock        ; call WriteBlock
$370A  30 8D CE 21         Sub_370A:      LEAX Dat_052F,PC       ; X → Dat_052F
$370E  17 E3 F2                           LBSR WriteBlock        ; call WriteBlock
$3711  6D C8 46                           TST BSS.EchoFlag,U    
$3714  27 09                              BEQ Sub_371F          
$3716  30 8D CD 75                        LEAX Dat_048F,PC       ; X → Dat_048F
$371A  17 E3 E6                           LBSR WriteBlock        ; call WriteBlock
$371D  20 4B                              BRA Sub_376A          

; --------------------------------------------------------------
$371F  30 8D CE 3C         Sub_371F:      LEAX Dat_055F,PC       ; X → Dat_055F
$3723  17 E3 DD                           LBSR WriteBlock        ; call WriteBlock
$3726  17 0E 34                           LBSR Sub_455D          ; call Sub_455D
$3729  6D C9 00 9B                        TST 155,U             
$372D  27 13                              BEQ Sub_3742          
$372F  30 C9 00 9F                        LEAX 159,U            
$3733  10 8E 00 20                        LDY #$0020            
$3737  86 01                              LDA #$01              
$3739  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$373C  CC 07 04                           LDD #$0704            
$373F  17 EB 52                           LBSR Sub_2294          ; call Sub_2294
$3742  C6 1E               Sub_3742:      LDB #$1E              
$3744  17 E4 1A                           LBSR Sub_1B61          ; call Sub_1B61
$3747  6D C8 21                           TST 33,U              
$374A  10 26 02 06                        LBNE Sub_3954         
$374E  30 8D CD 0C                        LEAX Dat_045E,PC       ; X → Dat_045E
$3752  17 E3 AE                           LBSR WriteBlock        ; call WriteBlock
$3755  30 8D CD 96                        LEAX Dat_04EF,PC       ; X → Dat_04EF
$3759  17 E3 A7                           LBSR WriteBlock        ; call WriteBlock
$375C  6D C8 46                           TST BSS.EchoFlag,U    
$375F  27 11                              BEQ Sub_3772          
$3761  30 8D CD AC                        LEAX Dat_0511,PC       ; X → Dat_0511
$3765  17 E3 9B                           LBSR WriteBlock        ; call WriteBlock
$3768  20 08                              BRA Sub_3772          

; --------------------------------------------------------------
$376A  6D C9 0C A0         Sub_376A:      TST 3232,U            
$376E  10 27 07 96                        LBEQ Sub_3F08         
$3772  31 C9 06 0E         Sub_3772:      LEAY 1550,U           
$3776  30 C9 00 9F                        LEAX 159,U            
$377A  A6 A4                              LDA ,Y                
$377C  81 0D                              CMPA #$0D              ; compare A with CR
$377E  26 0A                              BNE Sub_378A          
$3780  6D C9 00 9B                        TST 155,U             
$3784  10 27 01 CC                        LBEQ Sub_3954         
$3788  20 05                              BRA Sub_378F          

; --------------------------------------------------------------
$378A  C6 20               Sub_378A:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$378C  17 F5 97                           LBSR Sub_2D26          ; call Sub_2D26
$378F  6D C9 0C A0         Sub_378F:      TST 3232,U            
$3793  10 27 07 71                        LBEQ Sub_3F08         
$3797  6D C8 46                           TST BSS.EchoFlag,U    
$379A  26 2D                              BNE Sub_37C9          
$379C  30 8D CD CB                        LEAX Dat_056B,PC       ; X → Dat_056B
$37A0  17 E3 60                           LBSR WriteBlock        ; call WriteBlock
$37A3  86 01                              LDA #$01              
$37A5  30 C9 00 9F                        LEAX 159,U            
$37A9  10 8E 00 20                        LDY #$0020            
$37AD  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$37B0  30 8D CC DB                        LEAX Dat_048F,PC       ; X → Dat_048F
$37B4  17 E3 4C                           LBSR WriteBlock        ; call WriteBlock
$37B7  86 02                              LDA #$02               ; A = CurXY
$37B9  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$37BB  30 C9 00 9F                        LEAX 159,U            
$37BF  10 3F 83                           OS9 I$Create           ; mode=B  name→X  → path→A
$37C2  10 25 01 9F                        LBCS Sub_3965         
$37C6  A7 C8 42                           STA 66,U              
$37C9  EC 44               Sub_37C9:      LDD BSS.ParamBase,U   
$37CB  ED 46                              STD BSS.RxBufPtr,U    
$37CD  30 8D CD C2                        LEAX Dat_0593,PC       ; X → Dat_0593
$37D1  17 E3 2F                           LBSR WriteBlock        ; call WriteBlock
$37D4  30 8D CD DF                        LEAX Dat_05B7,PC       ; X → Dat_05B7
$37D8  17 E3 28                           LBSR WriteBlock        ; call WriteBlock
$37DB  30 8D CD 50                        LEAX Dat_052F,PC       ; X → Dat_052F
$37DF  17 E3 21                           LBSR WriteBlock        ; call WriteBlock
$37E2  17 06 9E                           LBSR Sub_3E83          ; call Sub_3E83
$37E5  17 06 B3                           LBSR Sub_3E9B          ; call Sub_3E9B
$37E8  6D C8 46                           TST BSS.EchoFlag,U    
$37EB  27 0B                              BEQ Sub_37F8          
$37ED  17 06 93            Sub_37ED:      LBSR Sub_3E83          ; call Sub_3E83
$37F0  17 06 A8                           LBSR Sub_3E9B          ; call Sub_3E9B
$37F3  CC 00 00                           LDD #$0000            
$37F6  20 06                              BRA Sub_37FE          

; --------------------------------------------------------------
$37F8  17 06 E2            Sub_37F8:      LBSR Sub_3EDD          ; call Sub_3EDD
$37FB  CC 00 01                           LDD #$0001            
$37FE  ED C8 53            Sub_37FE:      STD 83,U              
$3801  30 8D CE C2                        LEAX Dat_06C7,PC       ; X → Dat_06C7
$3805  17 E2 FB                           LBSR WriteBlock        ; call WriteBlock
$3808  CC 0D 07                           LDD #$0D07            
$380B  17 EA 86                           LBSR Sub_2294          ; call Sub_2294
$380E  30 8D CD B5                        LEAX Dat_05C7,PC       ; X → Dat_05C7
$3812  86 01                              LDA #$01              
$3814  10 8E 00 14                        LDY #$0014            
$3818  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$381B  6C C8 5A                           INC BSS.ConnState,U   
$381E  C6 04                              LDB #$04              
$3820  E7 C8 59                           STB 89,U              
$3823  17 06 4D            Sub_3823:      LBSR Sub_3E73          ; call Sub_3E73
$3826  6A C8 59                           DEC 89,U              
$3829  17 03 90                           LBSR Sub_3BBC          ; call Sub_3BBC
$382C  A6 C8 2B            Sub_382C:      LDA 43,U              
$382F  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3831  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3834  24 6D                              BCC Sub_38A3           ; C=0 (BHS)
$3836  17 F1 B2                           LBSR Sub_29EB          ; call Sub_29EB
$3839  10 25 01 55                        LBCS Sub_3992         
$383D  17 03 9A                           LBSR Sub_3BDA          ; call Sub_3BDA
$3840  81 03                              CMPA #$03             
$3842  25 E8                              BCS Sub_382C           ; C=1 (BLO)
$3844  6D C8 59                           TST 89,U              
$3847  26 DA                              BNE Sub_3823          
$3849  6F C8 5A                           CLR BSS.ConnState,U   
$384C  17 06 30            Sub_384C:      LBSR Sub_3E7F          ; call Sub_3E7F
$384F  17 03 6A                           LBSR Sub_3BBC          ; call Sub_3BBC
$3852  A6 C8 2B            Sub_3852:      LDA 43,U              
$3855  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3857  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$385A  24 47                              BCC Sub_38A3           ; C=0 (BHS)
$385C  17 F1 8C                           LBSR Sub_29EB          ; call Sub_29EB
$385F  10 25 01 2F                        LBCS Sub_3992         
$3863  17 03 74                           LBSR Sub_3BDA          ; call Sub_3BDA
$3866  81 0A                              CMPA #$0A              ; compare A with LF
$3868  25 E8                              BCS Sub_3852           ; C=1 (BLO)
$386A  6C C8 52                           INC 82,U              
$386D  17 06 55                           LBSR Sub_3EC5          ; call Sub_3EC5
$3870  17 E4 84                           LBSR Sub_1CF7          ; call Sub_1CF7
$3873  A6 C8 52                           LDA 82,U              
$3876  81 0A                              CMPA #$0A              ; compare A with LF
$3878  25 D2                              BCS Sub_384C           ; C=1 (BLO)
$387A  16 01 15                           LBRA Sub_3992         

; --------------------------------------------------------------
$387D  EC C8 53            Sub_387D:      LDD 83,U              
$3880  10 83 00 00                        CMPD #$0000           
$3884  26 08                              BNE Sub_388E          
$3886  17 05 F2                           LBSR Sub_3E7B          ; call Sub_3E7B
$3889  17 05 E7                           LBSR Sub_3E73          ; call Sub_3E73
$388C  20 03                              BRA Sub_3891          

; --------------------------------------------------------------
$388E  17 05 EA            Sub_388E:      LBSR Sub_3E7B          ; call Sub_3E7B
$3891  EC C8 53            Sub_3891:      LDD 83,U              
$3894  C3 00 01                           ADDD #$0001           
$3897  ED C8 53                           STD 83,U              
$389A  17 06 40                           LBSR Sub_3EDD          ; call Sub_3EDD
$389D  6F C8 52                           CLR 82,U              
$38A0  17 06 10                           LBSR Sub_3EB3          ; call Sub_3EB3
$38A3  17 F1 45            Sub_38A3:      LBSR Sub_29EB          ; call Sub_29EB
$38A6  10 25 00 E8                        LBCS Sub_3992         
$38AA  6F C9 00 E2                        CLR 226,U             
$38AE  17 01 40                           LBSR Sub_39F1          ; call Sub_39F1
$38B1  34 01                              PSHS CC               
$38B3  EC C8 53                           LDD 83,U              
$38B6  10 83 00 00                        CMPD #$0000           
$38BA  26 0B                              BNE Sub_38C7          
$38BC  6D C9 00 E2                        TST 226,U             
$38C0  26 0B                              BNE Sub_38CD          
$38C2  35 01                              PULS CC               
$38C4  16 00 CB                           LBRA Sub_3992         

; --------------------------------------------------------------
$38C7  35 01               Sub_38C7:      PULS CC               
$38C9  25 21                              BCS Sub_38EC           ; C=1 (BLO)
$38CB  20 0D                              BRA Sub_38DA          

; --------------------------------------------------------------
$38CD  35 01               Sub_38CD:      PULS CC               
$38CF  24 AC                              BCC Sub_387D           ; C=0 (BHS)
$38D1  86 0D                              LDA #$0D               ; A = CR
$38D3  A7 C9 00 9F                        STA 159,U             
$38D7  16 00 B8                           LBRA Sub_3992         

; --------------------------------------------------------------
$38DA  6D C8 5F            Sub_38DA:      TST BSS.BufCount,U    
$38DD  26 1E                              BNE Sub_38FD          
$38DF  6D C8 62                           TST 98,U              
$38E2  27 99                              BEQ Sub_387D          
$38E4  6F C8 62                           CLR 98,U              
$38E7  17 05 91                           LBSR Sub_3E7B          ; call Sub_3E7B
$38EA  20 B7                              BRA Sub_38A3          

; --------------------------------------------------------------
$38EC  A6 C8 52            Sub_38EC:      LDA 82,U              
$38EF  81 09                              CMPA #$09             
$38F1  10 22 00 9D                        LBHI Sub_3992         
$38F5  17 FD D5                           LBSR Sub_36CD          ; call Sub_36CD
$38F8  17 05 84                           LBSR Sub_3E7F          ; call Sub_3E7F
$38FB  20 A6                              BRA Sub_38A3          

; --------------------------------------------------------------
$38FD  6D C8 46            Sub_38FD:      TST BSS.EchoFlag,U    
$3900  27 3F                              BEQ Sub_3941          
$3902  17 05 7A                           LBSR Sub_3E7F          ; call Sub_3E7F
$3905  17 00 E9                           LBSR Sub_39F1          ; call Sub_39F1
$3908  6F C8 5F                           CLR BSS.BufCount,U    
$390B  34 40                              PSHS U                
$390D  6D C8 4C                           TST 76,U              
$3910  26 1B                              BNE Sub_392D          
$3912  EC C8 5B                           LDD BSS.ConnWord,U    
$3915  26 05                              BNE Sub_391C          
$3917  EC C8 5D                           LDD BSS.BufPtr1,U     
$391A  27 11                              BEQ Sub_392D          
$391C  A6 C8 42            Sub_391C:      LDA 66,U              
$391F  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$3921  AE C8 5B                           LDX BSS.ConnWord,U    
$3924  10 AE C8 5D                        LDY BSS.BufPtr1,U     
$3928  1F 23                              TFR Y,U               
$392A  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$392D  35 40               Sub_392D:      PULS U                
$392F  A6 C8 42                           LDA 66,U              
$3932  10 3F 8F                           OS9 I$Close            ; path=A
$3935  86 0D                              LDA #$0D               ; A = CR
$3937  A7 C9 00 9F                        STA 159,U             
$393B  17 05 3D                           LBSR Sub_3E7B          ; call Sub_3E7B
$393E  16 FE AC                           LBRA Sub_37ED         

; --------------------------------------------------------------
$3941  6F C8 5F            Sub_3941:      CLR BSS.BufCount,U    
$3944  17 05 34                           LBSR Sub_3E7B          ; call Sub_3E7B
$3947  6F C9 0C A0         Sub_3947:      CLR 3232,U            
$394B  17 E3 BB                           LBSR Sub_1D09          ; call Sub_1D09
$394E  A6 C8 42                           LDA 66,U              
$3951  10 3F 8F                           OS9 I$Close            ; path=A
$3954  17 D8 38            Sub_3954:      LBSR Sub_118F          ; call Sub_118F
$3957  17 E3 84                           LBSR Sub_1CDE          ; call Sub_1CDE
$395A  6F C8 45                           CLR 69,U              
$395D  6F C8 46                           CLR BSS.EchoFlag,U    
$3960  35 36                              PULS A,B,X,Y          
$3962  16 D2 F9                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$3965  86 07               Sub_3965:      LDA #$07              
$3967  17 E5 A1                           LBSR Sub_1F0B          ; call Sub_1F0B
$396A  34 04                              PSHS B                
$396C  CC 0D 02                           LDD #$0D02            
$396F  17 E9 22                           LBSR Sub_2294          ; call Sub_2294
$3972  86 03                              LDA #$03              
$3974  17 E5 94                           LBSR Sub_1F0B          ; call Sub_1F0B
$3977  30 8D CB 14                        LEAX Dat_048F,PC       ; X → Dat_048F
$397B  17 E1 85                           LBSR WriteBlock        ; call WriteBlock
$397E  35 04                              PULS B                
$3980  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$3983  8E 00 3C                           LDX #$003C            
$3986  17 D5 CD                           LBSR Sub_0F56          ; call Sub_0F56
$3989  30 8D CA FE                        LEAX Dat_048B,PC       ; X → Dat_048B
$398D  17 E1 73                           LBSR WriteBlock        ; call WriteBlock
$3990  20 C2                              BRA Sub_3954          

; --------------------------------------------------------------
$3992  A6 C9 00 9F         Sub_3992:      LDA 159,U             
$3996  81 0D                              CMPA #$0D              ; compare A with CR
$3998  27 10                              BEQ Sub_39AA          
$399A  A6 C8 42                           LDA 66,U              
$399D  10 3F 8F                           OS9 I$Close            ; path=A
$39A0  30 C9 00 9F                        LEAX 159,U            
$39A4  10 3F 87                           OS9 I$Delete           ; name→X
$39A7  17 FD 23                           LBSR Sub_36CD          ; call Sub_36CD
$39AA  30 C9 13 A9         Sub_39AA:      LEAX 5033,U           
$39AE  86 18                              LDA #$18              
$39B0  C6 04                              LDB #$04              
$39B2  A7 80               Sub_39B2:      STA ,X+               
$39B4  5A                                 DECB                  
$39B5  26 FB                              BNE Sub_39B2          
$39B7  86 03                              LDA #$03              
$39B9  C6 04                              LDB #$04              
$39BB  A7 80               Sub_39BB:      STA ,X+               
$39BD  5A                                 DECB                  
$39BE  26 FB                              BNE Sub_39BB          
$39C0  A6 C8 2B                           LDA 43,U              
$39C3  10 8E 00 08                        LDY #$0008            
$39C7  30 C9 13 A9                        LEAX 5033,U           
$39CB  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$39CE  16 FF 76                           LBRA Sub_3947         

; --------------------------------------------------------------
$39D1  86 04               Sub_39D1:      LDA #$04              
$39D3  A7 C8 4F                           STA 79,U              
$39D6  16 01 AA                           LBRA Sub_3B83         

; --------------------------------------------------------------
$39D9  86 03               Sub_39D9:      LDA #$03              
$39DB  A7 C8 4F                           STA 79,U              
$39DE  16 01 A2                           LBRA Sub_3B83         

; --------------------------------------------------------------
$39E1  86 02               Sub_39E1:      LDA #$02               ; Error # 2 (Wrong Block #)
$39E3  A7 C8 4F                           STA 79,U              
$39E6  16 D2 6E                           LBRA Sub_3B83          ; RESTORED: original binary has corrupted branch to Sub_0C57
                                                                  ; (lands mid-instruction at $0C57, 3 bytes into LDY #$0001)
                                                                  ; NitrOS9 source confirms correct target is Sub_3B83
                                                                  ; Bug only triggered on XMODEM wrong-block-number error

; --------------------------------------------------------------
$39E9  86 01               Sub_39E9:      LDA #$01              
$39EB  A7 C8 4F                           STA 79,U              
$39EE  16 01 92                           LBRA Sub_3B83         

; --------------------------------------------------------------
$39F1  34 30               Sub_39F1:      PSHS X,Y              
$39F3  CC 00 00                           LDD #$0000            
$39F6  ED C8 4D                           STD BSS.Counter2,U    
$39F9  ED C8 48                           STD 72,U              
$39FC  6F C8 62                           CLR 98,U              
$39FF  6F C8 4F                           CLR 79,U              
$3A02  6F C8 5F                           CLR BSS.BufCount,U    
$3A05  17 01 B4                           LBSR Sub_3BBC          ; call Sub_3BBC
$3A08  30 C9 00 DF         Sub_3A08:      LEAX 223,U            
$3A0C  17 01 CB            Sub_3A0C:      LBSR Sub_3BDA          ; call Sub_3BDA
$3A0F  81 0A                              CMPA #$0A              ; compare A with LF
$3A11  10 22 FF BC                        LBHI Sub_39D1         
$3A15  A6 C8 2B                           LDA 43,U              
$3A18  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3A1A  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3A1D  25 ED                              BCS Sub_3A0C           ; C=1 (BLO)
$3A1F  10 8E 00 01                        LDY #$0001            
$3A23  A6 C8 2B                           LDA 43,U              
$3A26  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3A29  25 E1                              BCS Sub_3A0C           ; C=1 (BLO)
$3A2B  1F 20                              TFR Y,D               
$3A2D  ED C8 4D                           STD BSS.Counter2,U    
$3A30  3A                                 ABX                   
$3A31  A6 C9 00 DF                        LDA 223,U             
$3A35  81 02                              CMPA #$02              ; compare A with CurXY
$3A37  27 1E                              BEQ Sub_3A57          
$3A39  81 01                              CMPA #$01             
$3A3B  27 15                              BEQ Sub_3A52          
$3A3D  81 04                              CMPA #$04             
$3A3F  10 27 01 69                        LBEQ Sub_3BAC         
$3A43  81 18                              CMPA #$18             
$3A45  10 27 01 6B                        LBEQ Sub_3BB4         
$3A49  81 03                              CMPA #$03             
$3A4B  10 27 01 65                        LBEQ Sub_3BB4         
$3A4F  16 FF B6                           LBRA Sub_3A08         

; --------------------------------------------------------------
$3A52  CC 00 80            Sub_3A52:      LDD #$0080            
$3A55  20 03                              BRA Sub_3A5A          

; --------------------------------------------------------------
$3A57  CC 04 00            Sub_3A57:      LDD #$0400            
$3A5A  ED C8 57            Sub_3A5A:      STD 87,U              
$3A5D  31 C9 00 E2                        LEAY 226,U            
$3A61  31 AB                              LEAY D,Y              
$3A63  10 AF C8 50                        STY 80,U              
$3A67  CA 04                              ORB #$04              
$3A69  6D C8 5A                           TST BSS.ConnState,U   
$3A6C  27 02                              BEQ Sub_3A70          
$3A6E  CA 01                              ORB #$01              
$3A70  ED C8 55            Sub_3A70:      STD 85,U              
$3A73  17 01 46                           LBSR Sub_3BBC          ; call Sub_3BBC
$3A76  20 09                              BRA Sub_3A81          

; --------------------------------------------------------------
$3A78  17 01 5F            Sub_3A78:      LBSR Sub_3BDA          ; call Sub_3BDA
$3A7B  81 02                              CMPA #$02              ; compare A with CurXY
$3A7D  10 22 FF 50                        LBHI Sub_39D1         
$3A81  A6 C8 2B            Sub_3A81:      LDA 43,U              
$3A84  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3A86  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3A89  25 ED                              BCS Sub_3A78           ; C=1 (BLO)
$3A8B  C1 02                              CMPB #$02              ; compare B with CurXY
$3A8D  25 E9                              BCS Sub_3A78           ; C=1 (BLO)
$3A8F  4F                                 CLRA                   ; A = 0
$3A90  10 8E 00 02                        LDY #$0002            
$3A94  A6 C8 2B                           LDA 43,U              
$3A97  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3A9A  1F 20                              TFR Y,D               
$3A9C  3A                                 ABX                   
$3A9D  E3 C8 4D                           ADDD BSS.Counter2,U   
$3AA0  ED C8 4D                           STD BSS.Counter2,U    
$3AA3  EC C8 53                           LDD 83,U              
$3AA6  E1 C9 00 E0                        CMPB 224,U            
$3AAA  26 0A                              BNE Sub_3AB6          
$3AAC  53                  Sub_3AAC:      COMB                  
$3AAD  E1 C9 00 E1                        CMPB 225,U            
$3AB1  27 0F                              BEQ Sub_3AC2          
$3AB3  16 FF 2B            Sub_3AB3:      LBRA Sub_39E1         
$3AB6  5A                  Sub_3AB6:      DECB                  
$3AB7  E1 C9 00 E0                        CMPB 224,U            
$3ABB  26 F6                              BNE Sub_3AB3          
$3ABD  6C C8 62                           INC 98,U              
$3AC0  20 EA                              BRA Sub_3AAC          

; --------------------------------------------------------------
$3AC2  17 00 F7            Sub_3AC2:      LBSR Sub_3BBC          ; call Sub_3BBC
$3AC5  17 01 12            Sub_3AC5:      LBSR Sub_3BDA          ; call Sub_3BDA
$3AC8  81 02                              CMPA #$02              ; compare A with CurXY
$3ACA  10 22 FF 03                        LBHI Sub_39D1         
$3ACE  A6 C8 2B            Sub_3ACE:      LDA 43,U              
$3AD1  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3AD3  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3AD6  25 ED                              BCS Sub_3AC5           ; C=1 (BLO)
$3AD8  4F                                 CLRA                   ; A = 0
$3AD9  1F 02                              TFR D,Y               
$3ADB  A6 C8 2B                           LDA 43,U              
$3ADE  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3AE1  25 E2                              BCS Sub_3AC5           ; C=1 (BLO)
$3AE3  1F 20                              TFR Y,D               
$3AE5  17 00 D4                           LBSR Sub_3BBC          ; call Sub_3BBC
$3AE8  6D C8 5A                           TST BSS.ConnState,U   
$3AEB  26 05                              BNE Sub_3AF2          
$3AED  17 03 4D                           LBSR Sub_3E3D          ; call Sub_3E3D
$3AF0  20 03                              BRA Sub_3AF5          

; --------------------------------------------------------------
$3AF2  17 03 1A            Sub_3AF2:      LBSR Sub_3E0F          ; call Sub_3E0F
$3AF5  3A                  Sub_3AF5:      ABX                   
$3AF6  E3 C8 4D                           ADDD BSS.Counter2,U   
$3AF9  ED C8 4D                           STD BSS.Counter2,U    
$3AFC  10 A3 C8 55                        CMPD 85,U             
$3B00  25 CC                              BCS Sub_3ACE           ; C=1 (BLO)
$3B02  AE C8 50                           LDX 80,U              
$3B05  EC C8 48                           LDD 72,U              
$3B08  6D C8 5A                           TST BSS.ConnState,U   
$3B0B  27 09                              BEQ Sub_3B16          
$3B0D  10 A3 84                           CMPD ,X               
$3B10  10 26 FE C5         Sub_3B10:      LBNE Sub_39D9         
$3B14  20 04                              BRA Sub_3B1A          

; --------------------------------------------------------------
$3B16  A1 84               Sub_3B16:      CMPA ,X               
$3B18  20 F6                              BRA Sub_3B10          

; --------------------------------------------------------------
$3B1A  6D C8 62            Sub_3B1A:      TST 98,U              
$3B1D  26 60                              BNE Sub_3B7F          
$3B1F  EC C8 53                           LDD 83,U              
$3B22  10 83 00 00                        CMPD #$0000           
$3B26  26 07                              BNE Sub_3B2F          
$3B28  17 ED 35                           LBSR Sub_2860          ; call Sub_2860
$3B2B  25 56                              BCS Sub_3B83           ; C=1 (BLO)
$3B2D  20 51                              BRA Sub_3B80          

; --------------------------------------------------------------
$3B2F  30 C9 00 E2         Sub_3B2F:      LEAX 226,U            
$3B33  10 83 00 01                        CMPD #$0001           
$3B37  26 40                              BNE Sub_3B79          
$3B39  EC C8 57                           LDD 87,U              
$3B3C  17 06 C7                           LBSR Sub_4206          ; call Sub_4206
$3B3F  6D C8 4C                           TST 76,U              
$3B42  27 35                              BEQ Sub_3B79          
$3B44  34 32                              PSHS A,X,Y            
$3B46  30 C9 00 9C                        LEAX 156,U            
$3B4A  A6 C9 00 89                        LDA 137,U             
$3B4E  A7 02                              STA 2,X               
$3B50  10 8E 00 03                        LDY #$0003            
$3B54  86 01                              LDA #$01              
$3B56  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3B59  30 8D CB 62                        LEAX Dat_06BF,PC       ; X → Dat_06BF
$3B5D  10 8E 00 08                        LDY #$0008            
$3B61  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3B64  A6 C9 00 87                        LDA 135,U             
$3B68  30 C9 00 9C                        LEAX 156,U            
$3B6C  A7 02                              STA 2,X               
$3B6E  10 8E 00 03                        LDY #$0003            
$3B72  86 01                              LDA #$01              
$3B74  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3B77  35 32                              PULS A,X,Y            
$3B79  EC C8 57            Sub_3B79:      LDD 87,U              
$3B7C  17 06 12                           LBSR Sub_4191          ; call Sub_4191
$3B7F  5F                  Sub_3B7F:      CLRB                   ; B = 0
$3B80  35 30               Sub_3B80:      PULS X,Y              
$3B82  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$3B83  6C C8 52            Sub_3B83:      INC 82,U              
$3B86  17 03 3C                           LBSR Sub_3EC5          ; call Sub_3EC5
$3B89  17 E1 6B                           LBSR Sub_1CF7          ; call Sub_1CF7
$3B8C  CC 0D 07                           LDD #$0D07            
$3B8F  17 E7 02                           LBSR Sub_2294          ; call Sub_2294
$3B92  C6 14                              LDB #$14              
$3B94  A6 C8 4F                           LDA 79,U              
$3B97  27 10                              BEQ Sub_3BA9          
$3B99  3D                                 MUL                    ; D = A×B unsigned
$3B9A  30 8D CA 29                        LEAX Dat_05C7,PC       ; X → Dat_05C7
$3B9E  30 8B                              LEAX D,X              
$3BA0  86 01                              LDA #$01              
$3BA2  10 8E 00 14                        LDY #$0014            
$3BA6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3BA9  53                  Sub_3BA9:      COMB                  
$3BAA  20 D4                              BRA Sub_3B80          

; --------------------------------------------------------------
$3BAC  6C C8 5F            Sub_3BAC:      INC BSS.BufCount,U    
$3BAF  17 06 3A                           LBSR Sub_41EC          ; call Sub_41EC
$3BB2  20 CC                              BRA Sub_3B80          

; --------------------------------------------------------------
$3BB4  86 0A               Sub_3BB4:      LDA #$0A               ; A = LF
$3BB6  A7 C8 52                           STA 82,U              
$3BB9  16 FE 2D                           LBRA Sub_39E9         

; --------------------------------------------------------------
$3BBC  34 16               Sub_3BBC:      PSHS A,B,X            
$3BBE  6D C8 72                           TST 114,U             
$3BC1  27 09                              BEQ Sub_3BCC          
$3BC3  4F                                 CLRA                   ; A = 0
$3BC4  E6 C8 73                           LDB 115,U             
$3BC7  ED C8 60                           STD 96,U              
$3BCA  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3BCC  30 C9 0C 99         Sub_3BCC:      LEAX 3225,U           
$3BD0  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$3BD3  A6 05                              LDA 5,X               
$3BD5  A7 C8 60                           STA 96,U              
$3BD8  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3BDA  34 14               Sub_3BDA:      PSHS B,X              
$3BDC  6D C8 72                           TST 114,U             
$3BDF  27 12                              BEQ Sub_3BF3          
$3BE1  86 01                              LDA #$01              
$3BE3  E6 C8 73                           LDB 115,U             
$3BE6  A3 C8 60                           SUBD 96,U             
$3BE9  1F 98                              TFR B,A               
$3BEB  8E 00 01                           LDX #$0001            
$3BEE  17 D3 65                           LBSR Sub_0F56          ; call Sub_0F56
$3BF1  35 94                              PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3BF3  30 C9 0C 99         Sub_3BF3:      LEAX 3225,U           
$3BF7  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$3BFA  A6 05                              LDA 5,X               
$3BFC  8E 00 01                           LDX #$0001            
$3BFF  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$3C02  8B 3C                              ADDA #$3C             
$3C04  A0 C8 60                           SUBA 96,U             
$3C07  81 3C                              CMPA #$3C              ; compare A with '<'
$3C09  25 02                              BCS Sub_3C0D           ; C=1 (BLO)
$3C0B  80 3C                              SUBA #$3C             
$3C0D  35 94               Sub_3C0D:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)
; CrcTable — CRC-16/CCITT lookup table  (256 × FDB = 512 bytes)
; Indexed as: LEAY CrcTable,PC  then LDD B,Y to fetch entry.
; Added in v2.2 to replace the slower OS9 F$CRC syscall.

CrcTable
; Referenced by: $3E20
; CRC-16/CCITT lookup table — 256 entries x 2 bytes = 512 bytes
Used by file transfer protocol routines for fast CRC calculation.
Dave Philipsen added this in v2.2; v2.1 used OS9 F$CRC syscall instead.
Table polynomial: $1021 (CRC-CCITT / CRC-16-IBM-SDLC)
; ── 512 bytes  ($3C0F—$3E0E) ──
         FDB    $0000
         FDB    $1021
         FDB    $2042
         FDB    $3063
         FDB    $4084
         FDB    $50A5
         FDB    $60C6
         FDB    $70E7
         FDB    $8108
         FDB    $9129
         FDB    $A14A
         FDB    $B16B
         FDB    $C18C
         FDB    $D1AD
         FDB    $E1CE
         FDB    $F1EF
         FDB    $1231
         FDB    $0210
         FDB    $3273
         FDB    $2252
         FDB    $52B5
         FDB    $4294
         FDB    $72F7
         FDB    $62D6
         FDB    $9339
         FDB    $8318
         FDB    $B37B
         FDB    $A35A
         FDB    $D3BD
         FDB    $C39C
         FDB    $F3FF
         FDB    $E3DE
         FDB    $2462
         FDB    $3443
         FDB    $0420
         FDB    $1401
         FDB    $64E6
         FDB    $74C7
         FDB    $44A4
         FDB    $5485
         FDB    $A56A
         FDB    $B54B
         FDB    $8528
         FDB    $9509
         FDB    $E5EE

Dat_3C69
         FDB    $F5CF
         FDB    $C5AC
         FDB    $D58D
         FDB    $3653
         FDB    $2672
         FDB    $1611
         FDB    $0630
         FDB    $76D7
         FDB    $66F6
         FDB    $5695
         FDB    $46B4
         FDB    $B75B
         FDB    $A77A
         FDB    $9719
         FDB    $8738
         FDB    $F7DF

Dat_3C89
         FDB    $E7FE
         FDB    $D79D
         FDB    $C7BC
         FDB    $48C4
         FDB    $58E5
         FDB    $6886
         FDB    $78A7
         FDB    $0840
         FDB    $1861
         FDB    $2802
         FDB    $3823

Dat_3C9F
         FDB    $C9CC
         FDB    $D9ED
         FDB    $E98E
         FDB    $F9AF
         FDB    $8948
         FDB    $9969
         FDB    $A90A
         FDB    $B92B
         FDB    $5AF5
         FDB    $4AD4

Dat_3CB3
         FDB    $7AB7
         FDB    $6A96
         FDB    $1A71
         FDB    $0A50
         FDB    $3A33
         FDB    $2A12
         FDB    $DBFD
         FDB    $CBDC
         FDB    $FBBF
         FDB    $EB9E
         FDB    $9B79
         FDB    $8B58
         FDB    $BB3B
         FDB    $AB1A
         FDB    $6CA6
         FDB    $7C87
         FDB    $4CE4
         FDB    $5CC5
         FDB    $2C22
         FDB    $3C03
         FDB    $0C60
         FDB    $1C41
         FDB    $EDAE
         FDB    $FD8F
         FDB    $CDEC

Dat_3CE5
         FDB    $DDCD
         FDB    $AD2A
         FDB    $BD0B
         FDB    $8D68
         FDB    $9D49
         FDB    $7E97
         FDB    $6EB6
         FDB    $5ED5
         FDB    $4EF4
         FDB    $3E13
         FDB    $2E32
         FDB    $1E51
         FDB    $0E70
         FDB    $FF9F
         FDB    $EFBE
         FDB    $DFDD
         FDB    $CFFC
         FDB    $BF1B
         FDB    $AF3A
         FDB    $9F59
         FDB    $8F78
         FDB    $9188
         FDB    $81A9
         FDB    $B1CA
         FDB    $A1EB
         FDB    $D10C
         FDB    $C12D
         FDB    $F14E
         FDB    $E16F
         FDB    $1080
         FDB    $00A1
         FDB    $30C2
         FDB    $20E3
         FDB    $5004
         FDB    $4025
         FDB    $7046
         FDB    $6067
         FDB    $83B9

Dat_3D31
         FDB    $9398
         FDB    $A3FB
         FDB    $B3DA
         FDB    $C33D
         FDB    $D31C
         FDB    $E37F
         FDB    $F35E
         FDB    $02B1
         FDB    $1290
         FDB    $22F3
         FDB    $32D2
         FDB    $4235
         FDB    $5214
         FDB    $6277
         FDB    $7256
         FDB    $B5EA
         FDB    $A5CB
         FDB    $95A8
         FDB    $8589
         FDB    $F56E
         FDB    $E54F
         FDB    $D52C
         FDB    $C50D
         FDB    $34E2
         FDB    $24C3
         FDB    $14A0
         FDB    $0481
         FDB    $7466
         FDB    $6447
         FDB    $5424
         FDB    $4405
         FDB    $A7DB
         FDB    $B7FA
         FDB    $8799
         FDB    $97B8
         FDB    $E75F
         FDB    $F77E
         FDB    $C71D
         FDB    $D73C
         FDB    $26D3
         FDB    $36F2
         FDB    $0691
         FDB    $16B0
         FDB    $6657
         FDB    $7676
         FDB    $4615
         FDB    $5634
         FDB    $D94C
         FDB    $C96D
         FDB    $F90E
         FDB    $E92F
         FDB    $99C8
         FDB    $89E9
         FDB    $B98A
         FDB    $A9AB
         FDB    $5844
         FDB    $4865
         FDB    $7806
         FDB    $6827
         FDB    $18C0
         FDB    $08E1
         FDB    $3882
         FDB    $28A3
         FDB    $CB7D
         FDB    $DB5C
         FDB    $EB3F
         FDB    $FB1E
         FDB    $8BF9
         FDB    $9BD8
         FDB    $ABBB
         FDB    $BB9A

Dat_3DBF
         FDB    $4A75
         FDB    $5A54
         FDB    $6A37
         FDB    $7A16
         FDB    $0AF1
         FDB    $1AD0
         FDB    $2AB3
         FDB    $3A92
         FDB    $FD2E
         FDB    $ED0F
         FDB    $DD6C
         FDB    $CD4D
         FDB    $BDAA
         FDB    $AD8B
         FDB    $9DE8
         FDB    $8DC9
         FDB    $7C26
         FDB    $6C07
         FDB    $5C64
         FDB    $4C45
         FDB    $3CA2
         FDB    $2C83
         FDB    $1CE0
         FDB    $0CC1
         FDB    $EF1F
         FDB    $FF3E
         FDB    $CF5D
         FDB    $DF7C
         FDB    $AF9B
         FDB    $BFBA
         FDB    $8FD9
         FDB    $9FF8
         FDB    $6E17
         FDB    $7E36
         FDB    $4E55
         FDB    $5E74
         FDB    $2E93
         FDB    $3EB2
         FDB    $0ED1
         FDB    $1EF0
$3E0F  34 36               Sub_3E0F:      PSHS A,B,X,Y          
$3E11  31 8B                              LEAY D,X              
$3E13  34 20                              PSHS Y                
$3E15  10 AE C8 50                        LDY 80,U              
$3E19  34 20                              PSHS Y                
$3E1B  AC C8 50                           CMPX 80,U             
$3E1E  24 19                              BCC Sub_3E39           ; C=0 (BHS)
$3E20  31 8D FD EB                        LEAY CrcTable,PC       ; Y → CrcTable
$3E24  D6 48               Sub_3E24:      LDB <$48              
$3E26  4F                                 CLRA                   ; A = 0
$3E27  E8 80                              EORB ,X+              
$3E29  58                                 LSLB                  
$3E2A  49                                 ROLA                  
$3E2B  EC AB                              LDD D,Y               
$3E2D  98 49                              EORA <$49             
$3E2F  DD 48                              STD <$48              
$3E31  AC E4                              CMPX ,S               
$3E33  27 04                              BEQ Sub_3E39          
$3E35  AC 62                              CMPX 2,S              
$3E37  25 EB                              BCS Sub_3E24           ; C=1 (BLO)
$3E39  32 64               Sub_3E39:      LEAS 4,S              
$3E3B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E3D  34 36               Sub_3E3D:      PSHS A,B,X,Y          
$3E3F  31 8B                              LEAY D,X              
$3E41  34 20                              PSHS Y                
$3E43  AC C8 50                           CMPX 80,U             
$3E46  27 0E                              BEQ Sub_3E56          
$3E48  A6 C8 48                           LDA 72,U              
$3E4B  AB 80               Sub_3E4B:      ADDA ,X+              
$3E4D  AC C8 50            Insn_3E4D:     CMPX 80,U             
$3E4E  C8                  Sub_3E4E:      EQU    $3E4E            ; mid-instruction overlap: Insn_3E4D+1 -- mid-instruction entry point -- byte 2 of CMPX 80,U ($AC C8 50) at $3E4D; BNE from $3DE0
$3E50  27 04                              BEQ Sub_3E56          
$3E52  AC E4                              CMPX ,S               
$3E54  25 F5                              BCS Sub_3E4B           ; C=1 (BLO)
$3E56  A7 C8 48            Sub_3E56:      STA 72,U              
$3E59  32 62                              LEAS 2,S              
$3E5B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E5D  34 32               Sub_3E5D:      PSHS A,X,Y            
$3E5F  30 C8 44                           LEAX 68,U             
$3E62  A6 C8 2B                           LDA 43,U              
$3E65  10 8E 00 01                        LDY #$0001            
$3E69  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3E6C  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E6E  A7 C8 44            Sub_3E6E:      STA 68,U              
$3E71  20 EA                              BRA Sub_3E5D          

; --------------------------------------------------------------
$3E73  86 43               Sub_3E73:      LDA #$43               ; A = 'C'
$3E75  20 F7                              BRA Sub_3E6E          

; --------------------------------------------------------------
$3E77  86 04               Sub_3E77:      LDA #$04              
$3E79  20 F3                              BRA Sub_3E6E          

; --------------------------------------------------------------
$3E7B  86 06               Sub_3E7B:      LDA #$06              
$3E7D  20 EF                              BRA Sub_3E6E          

; --------------------------------------------------------------
$3E7F  86 15               Sub_3E7F:      LDA #$15              
$3E81  20 EB                              BRA Sub_3E6E          

; --------------------------------------------------------------
$3E83  34 36               Sub_3E83:      PSHS A,B,X,Y          
$3E85  30 8D C7 A2                        LEAX Dat_062B,PC       ; X → Dat_062B
$3E89  31 C9 14 49                        LEAY 5193,U           
$3E8D  C6 09                              LDB #$09              
$3E8F  17 EE 8C                           LBSR Sub_2D1E          ; call Sub_2D1E
$3E92  30 C9 14 49                        LEAX 5193,U           
$3E96  17 DC 6A                           LBSR WriteBlock        ; call WriteBlock
$3E99  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E9B  34 36               Sub_3E9B:      PSHS A,B,X,Y          
$3E9D  30 8D C7 93                        LEAX Dat_0634,PC       ; X → Dat_0634
$3EA1  31 C9 14 39                        LEAY 5177,U           
$3EA5  C6 09                              LDB #$09              
$3EA7  17 EE 74                           LBSR Sub_2D1E          ; call Sub_2D1E
$3EAA  30 C9 14 39                        LEAX 5177,U           
$3EAE  17 DC 52                           LBSR WriteBlock        ; call WriteBlock
$3EB1  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3EB3  34 36               Sub_3EB3:      PSHS A,B,X,Y          
$3EB5  30 C9 14 39                        LEAX 5177,U           
$3EB9  CC 30 30                           LDD #$3030            
$3EBC  ED 05                              STD 5,X               
$3EBE  ED 07                              STD 7,X               
$3EC0  17 DC 40                           LBSR WriteBlock        ; call WriteBlock
$3EC3  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3EC5  34 32               Sub_3EC5:      PSHS A,X,Y            
$3EC7  30 C9 14 39                        LEAX 5177,U           
$3ECB  8D 1D                              BSR Sub_3EEA           ; call Sub_3EEA
$3ECD  17 DC 33                           LBSR WriteBlock        ; call WriteBlock
$3ED0  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------

Dat_3ED2
; 11-byte orphaned code between subroutines (unreferenced)
; ── 11 bytes  ($3ED2—$3EDC) ──
         FCB    $34
         FCB    $32
         FCB    $30
         FCB    $C9
         FCB    $14
         FCB    $49
         FCB    $17
         FCB    $DC
         FCB    $28
         FCB    $35
         FCB    $B2
$3EDD  34 32               Sub_3EDD:      PSHS A,X,Y            
$3EDF  30 C9 14 49                        LEAX 5193,U           
$3EE3  8D 05                              BSR Sub_3EEA           ; call Sub_3EEA
$3EE5  17 DC 1B                           LBSR WriteBlock        ; call WriteBlock
$3EE8  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3EEA  34 04               Sub_3EEA:      PSHS B                
$3EEC  C6 08                              LDB #$08               ; B = BS
$3EEE  8D 09               Sub_3EEE:      BSR Sub_3EF9           ; call Sub_3EF9
$3EF0  81 30                              CMPA #$30              ; compare A with '0'
$3EF2  26 03                              BNE Sub_3EF7          
$3EF4  5A                                 DECB                  
$3EF5  24 F7                              BCC Sub_3EEE           ; C=0 (BHS)
$3EF7  35 84               Sub_3EF7:      PULS B,PC              ; return from subroutine  (PULS PC = RTS)
$3EF9  A6 85               Sub_3EF9:      LDA B,X               
$3EFB  4C                                 INCA                  
$3EFC  81 39                              CMPA #$39              ; compare A with '9'
$3EFE  22 03                              BHI Sub_3F03          
$3F00  A7 85                              STA B,X               
$3F02  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$3F03  86 30               Sub_3F03:      LDA #$30               ; A = '0'
$3F05  A7 85                              STA B,X               
$3F07  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$3F08  6D C8 46            Sub_3F08:      TST BSS.EchoFlag,U    
$3F0B  27 0D                              BEQ Sub_3F1A          
$3F0D  17 EB 42                           LBSR Sub_2A52          ; call Sub_2A52
$3F10  6D C8 21                           TST 33,U              
$3F13  10 26 FA 3D                        LBNE Sub_3954         
$3F17  17 EB 86            Sub_3F17:      LBSR Sub_2AA0          ; call Sub_2AA0
$3F1A  30 8D C6 65         Sub_3F1A:      LEAX Dat_0583,PC       ; X → Dat_0583
$3F1E  17 DB E2                           LBSR WriteBlock        ; call WriteBlock
$3F21  30 C9 00 9F                        LEAX 159,U            
$3F25  86 01                              LDA #$01              
$3F27  10 8E 00 20                        LDY #$0020            
$3F2B  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$3F2E  30 8D C5 5D                        LEAX Dat_048F,PC       ; X → Dat_048F
$3F32  17 DB CE                           LBSR WriteBlock        ; call WriteBlock
$3F35  30 8D C7 8E                        LEAX Dat_06C7,PC       ; X → Dat_06C7
$3F39  17 DB C7                           LBSR WriteBlock        ; call WriteBlock
$3F3C  86 01                              LDA #$01              
$3F3E  30 C9 00 9F                        LEAX 159,U            
$3F42  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$3F45  24 0C                              BCC Sub_3F53           ; C=0 (BHS)
$3F47  6D C8 46            Sub_3F47:      TST BSS.EchoFlag,U    
$3F4A  10 27 FA 06                        LBEQ Sub_3954         
$3F4E  6C C8 69                           INC 105,U             
$3F51  20 1E                              BRA Sub_3F71          

; --------------------------------------------------------------
$3F53  A7 C8 42            Sub_3F53:      STA 66,U              
$3F56  30 C9 00 DF                        LEAX 223,U            
$3F5A  10 8E 00 7F                        LDY #$007F            
$3F5E  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3F61  25 E4                              BCS Sub_3F47           ; C=1 (BLO)
$3F63  1F 20                              TFR Y,D               
$3F65  17 02 9E                           LBSR Sub_4206          ; call Sub_4206
$3F68  A6 C8 42                           LDA 66,U              
$3F6B  8E 00 00                           LDX #$0000            
$3F6E  10 3F 88                           OS9 I$Seek             ; path=A  mode=B  offset→X:D
$3F71  30 8D C6 1E         Sub_3F71:      LEAX Dat_0593,PC       ; X → Dat_0593
$3F75  17 DB 8B                           LBSR WriteBlock        ; call WriteBlock
$3F78  30 8D C5 B3                        LEAX Dat_052F,PC       ; X → Dat_052F
$3F7C  17 DB 84                           LBSR WriteBlock        ; call WriteBlock
$3F7F  17 FF 01                           LBSR Sub_3E83          ; call Sub_3E83
$3F82  17 FF 16                           LBSR Sub_3E9B          ; call Sub_3E9B
$3F85  6D C8 4C                           TST 76,U              
$3F88  27 2F                              BEQ Sub_3FB9          
$3F8A  30 C9 00 9C                        LEAX 156,U            
$3F8E  A6 C9 00 89                        LDA 137,U             
$3F92  A7 02                              STA 2,X               
$3F94  10 8E 00 03                        LDY #$0003            
$3F98  86 01                              LDA #$01              
$3F9A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3F9D  30 8D C7 1E                        LEAX Dat_06BF,PC       ; X → Dat_06BF
$3FA1  10 8E 00 08                        LDY #$0008            
$3FA5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3FA8  30 C9 00 9C                        LEAX 156,U            
$3FAC  E6 C9 00 87                        LDB 135,U             
$3FB0  E7 02                              STB 2,X               
$3FB2  10 8E 00 03                        LDY #$0003            
$3FB6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3FB9  6F C8 5A            Sub_3FB9:      CLR BSS.ConnState,U   
$3FBC  CC 00 80                           LDD #$0080            
$3FBF  ED C8 57                           STD 87,U              
$3FC2  C3 00 04                           ADDD #$0004           
$3FC5  ED C8 55                           STD 85,U              
$3FC8  6D C8 46                           TST BSS.EchoFlag,U    
$3FCB  10 26 01 1B                        LBNE Sub_40EA         
$3FCF  30 C9 13 A9                        LEAX 5033,U           
$3FD3  17 EC 9C                           LBSR Sub_2C72          ; call Sub_2C72
$3FD6  6D C8 45                           TST 69,U              
$3FD9  27 0C                              BEQ Sub_3FE7          
$3FDB  CC 04 00                           LDD #$0400            
$3FDE  ED C8 57                           STD 87,U              
$3FE1  C3 00 04                           ADDD #$0004           
$3FE4  ED C8 55                           STD 85,U              
$3FE7  CC 00 01            Sub_3FE7:      LDD #$0001            
$3FEA  ED C8 53                           STD 83,U              
$3FED  17 FE ED                           LBSR Sub_3EDD          ; call Sub_3EDD
$3FF0  17 FE C0                           LBSR Sub_3EB3          ; call Sub_3EB3
$3FF3  17 F6 D7                           LBSR Sub_36CD          ; call Sub_36CD
$3FF6  17 E4 0F                           LBSR Sub_2408          ; call Sub_2408
$3FF9  6D C8 46                           TST BSS.EchoFlag,U    
$3FFC  27 09                              BEQ Sub_4007          
$3FFE  EC C8 53                           LDD 83,U              
$4001  10 83 00 01                        CMPD #$0001           
$4005  27 10                              BEQ Sub_4017          
$4007  17 EA 0B            Sub_4007:      LBSR Sub_2A15          ; call Sub_2A15
$400A  10 25 00 D9                        LBCS Sub_40E7         
$400E  81 43                              CMPA #$43              ; compare A with 'C'
$4010  27 05                              BEQ Sub_4017          
$4012  17 E4 8A                           LBSR Sub_249F          ; call Sub_249F
$4015  20 1A                              BRA Sub_4031          

; --------------------------------------------------------------
$4017  86 01               Sub_4017:      LDA #$01              
$4019  A7 C8 5A                           STA BSS.ConnState,U   
$401C  17 E4 80                           LBSR Sub_249F          ; call Sub_249F
$401F  EC C8 57                           LDD 87,U              
$4022  C3 00 05                           ADDD #$0005           
$4025  ED C8 55                           STD 85,U              
$4028  20 17                              BRA Sub_4041          

; --------------------------------------------------------------
$402A  17 E9 E8            Sub_402A:      LBSR Sub_2A15          ; call Sub_2A15
$402D  10 25 00 B6                        LBCS Sub_40E7         
$4031  81 15               Sub_4031:      CMPA #$15             
$4033  27 0C                              BEQ Sub_4041          
$4035  81 06                              CMPA #$06             
$4037  27 37                              BEQ Sub_4070          
$4039  81 18                              CMPA #$18             
$403B  10 27 00 A8                        LBEQ Sub_40E7         
$403F  20 C6                              BRA Sub_4007          

; --------------------------------------------------------------
$4041  6C C8 52            Sub_4041:      INC 82,U              
$4044  A6 C8 52                           LDA 82,U              
$4047  81 09                              CMPA #$09             
$4049  10 22 00 9A                        LBHI Sub_40E7         
$404D  81 01                              CMPA #$01             
$404F  26 09                              BNE Sub_405A          
$4051  EC C8 53                           LDD 83,U              
$4054  10 83 00 01                        CMPD #$0001           
$4058  27 06                              BEQ Sub_4060          
$405A  17 FE 68            Sub_405A:      LBSR Sub_3EC5          ; call Sub_3EC5
$405D  17 DC 97                           LBSR Sub_1CF7          ; call Sub_1CF7
$4060  10 AE C8 55         Sub_4060:      LDY 85,U              
$4064  A6 C8 2B                           LDA 43,U              
$4067  30 C9 00 DF                        LEAX 223,U            
$406B  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$406E  20 BA                              BRA Sub_402A          

; --------------------------------------------------------------
$4070  6F C8 52            Sub_4070:      CLR 82,U              
$4073  17 FE 3D                           LBSR Sub_3EB3          ; call Sub_3EB3
$4076  6D C8 5F                           TST BSS.BufCount,U    
$4079  26 43                              BNE Sub_40BE          
$407B  EC C8 53                           LDD 83,U              
$407E  C3 00 01                           ADDD #$0001           
$4081  ED C8 53                           STD 83,U              
$4084  6D C8 45                           TST 69,U              
$4087  27 16                              BEQ Sub_409F          
$4089  CC 04 00                           LDD #$0400            
$408C  ED C8 57                           STD 87,U              
$408F  6D C8 5A                           TST BSS.ConnState,U   
$4092  27 05                              BEQ Sub_4099          
$4094  C3 00 05                           ADDD #$0005           
$4097  20 03                              BRA Sub_409C          

; --------------------------------------------------------------
$4099  C3 00 04            Sub_4099:      ADDD #$0004           
$409C  ED C8 55            Sub_409C:      STD 85,U              
$409F  17 FE 3B            Sub_409F:      LBSR Sub_3EDD          ; call Sub_3EDD
$40A2  17 E3 63                           LBSR Sub_2408          ; call Sub_2408
$40A5  6D C8 5F                           TST BSS.BufCount,U    
$40A8  26 14                              BNE Sub_40BE          
$40AA  17 E3 F2                           LBSR Sub_249F          ; call Sub_249F
$40AD  A6 C8 2B                           LDA 43,U              
$40B0  30 C9 00 DF                        LEAX 223,U            
$40B4  10 AE C8 55                        LDY 85,U              
$40B8  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$40BB  16 FF 6C                           LBRA Sub_402A         

; --------------------------------------------------------------
$40BE  A6 C8 42            Sub_40BE:      LDA 66,U              
$40C1  10 3F 8F                           OS9 I$Close            ; path=A
$40C4  6F C8 5F                           CLR BSS.BufCount,U    
$40C7  6D C8 46                           TST BSS.EchoFlag,U    
$40CA  27 0C                              BEQ Sub_40D8          
$40CC  17 FD A8                           LBSR Sub_3E77          ; call Sub_3E77
$40CF  17 E9 43                           LBSR Sub_2A15          ; call Sub_2A15
$40D2  25 13                              BCS Sub_40E7           ; C=1 (BLO)
$40D4  12                                 NOP                   
$40D5  16 FE 3F                           LBRA Sub_3F17         

; --------------------------------------------------------------
$40D8  17 FD 9C            Sub_40D8:      LBSR Sub_3E77          ; call Sub_3E77
$40DB  17 E9 37                           LBSR Sub_2A15          ; call Sub_2A15
$40DE  25 07                              BCS Sub_40E7           ; C=1 (BLO)
$40E0  81 06                              CMPA #$06             
$40E2  26 F4                              BNE Sub_40D8          
$40E4  16 F8 60                           LBRA Sub_3947         

; --------------------------------------------------------------
$40E7  16 F8 C0            Sub_40E7:      LBRA Sub_39AA         
$40EA  17 E9 28            Sub_40EA:      LBSR Sub_2A15          ; call Sub_2A15
$40ED  25 F8                              BCS Sub_40E7           ; C=1 (BLO)
$40EF  81 43                              CMPA #$43              ; compare A with 'C'
$40F1  26 F7                              BNE Sub_40EA          
$40F3  6C C8 5A                           INC BSS.ConnState,U   
$40F6  EC C8 57                           LDD 87,U              
$40F9  C3 00 05                           ADDD #$0005           
$40FC  ED C8 55                           STD 85,U              
$40FF  CC 00 00                           LDD #$0000            
$4102  ED C8 53                           STD 83,U              
$4105  17 E3 00                           LBSR Sub_2408          ; call Sub_2408
$4108  17 E3 94                           LBSR Sub_249F          ; call Sub_249F
$410B  30 C9 00 DF                        LEAX 223,U            
$410F  31 C9 13 A9                        LEAY 5033,U           
$4113  C6 86                              LDB #$86              
$4115  17 EC 06                           LBSR Sub_2D1E          ; call Sub_2D1E
$4118  6D C8 69                           TST 105,U             
$411B  26 12                              BNE Sub_412F          
$411D  CC 00 01                           LDD #$0001            
$4120  ED C8 53                           STD 83,U              
$4123  CC 04 00                           LDD #$0400            
$4126  ED C8 57                           STD 87,U              
$4129  17 E2 DC                           LBSR Sub_2408          ; call Sub_2408
$412C  17 E3 70                           LBSR Sub_249F          ; call Sub_249F
$412F  A6 C8 2B            Sub_412F:      LDA 43,U              
$4132  30 C9 13 A9                        LEAX 5033,U           
$4136  10 AE C8 55                        LDY 85,U              
$413A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$413D  17 E8 D5            Sub_413D:      LBSR Sub_2A15          ; call Sub_2A15
$4140  25 A5                              BCS Sub_40E7           ; C=1 (BLO)
$4142  81 06                              CMPA #$06             
$4144  27 16                              BEQ Sub_415C          
$4146  81 15                              CMPA #$15             
$4148  26 F3                              BNE Sub_413D          
$414A  6C C8 52                           INC 82,U              
$414D  A6 C8 52                           LDA 82,U              
$4150  81 09                              CMPA #$09             
$4152  22 93                              BHI Sub_40E7          
$4154  17 FD 6E                           LBSR Sub_3EC5          ; call Sub_3EC5
$4157  17 DB 9D                           LBSR Sub_1CF7          ; call Sub_1CF7
$415A  20 D3                              BRA Sub_412F          

; --------------------------------------------------------------
$415C  6D C8 69            Sub_415C:      TST 105,U             
$415F  10 26 F7 F1                        LBNE Sub_3954         
$4163  CC 00 01                           LDD #$0001            
$4166  ED C8 53                           STD 83,U              
$4169  17 FD 71                           LBSR Sub_3EDD          ; call Sub_3EDD
$416C  EC C8 57                           LDD 87,U              
$416F  C3 00 05                           ADDD #$0005           
$4172  ED C8 55                           STD 85,U              
$4175  17 E8 9D                           LBSR Sub_2A15          ; call Sub_2A15
$4178  10 25 FF 6B                        LBCS Sub_40E7         
$417C  81 43                              CMPA #$43              ; compare A with 'C'
$417E  26 DC                              BNE Sub_415C          
$4180  A6 C8 2B                           LDA 43,U              
$4183  30 C9 00 DF                        LEAX 223,U            
$4187  10 AE C8 55                        LDY 85,U              
$418B  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$418E  16 FE 99                           LBRA Sub_402A         

; --------------------------------------------------------------
$4191  34 26               Sub_4191:      PSHS A,B,Y            
$4193  EC 42                              LDD BSS.ParamStr,U    
$4195  A3 E4                              SUBD ,S               
$4197  10 A3 46                           CMPD BSS.RxBufPtr,U   
$419A  24 02                              BCC Sub_419E           ; C=0 (BHS)
$419C  8D 4E                              BSR Sub_41EC           ; call Sub_41EC
$419E  10 AE 46            Sub_419E:      LDY BSS.RxBufPtr,U    
$41A1  6D C8 4C                           TST 76,U              
$41A4  26 16                              BNE Sub_41BC          
$41A6  EC 81               Sub_41A6:      LDD ,X++              
$41A8  ED A1                              STD ,Y++              
$41AA  EC E4                              LDD ,S                
$41AC  83 00 02                           SUBD #$0002           
$41AF  ED E4                              STD ,S                
$41B1  22 F3                              BHI Sub_41A6          
$41B3  27 02                              BEQ Sub_41B7          
$41B5  31 3F                              LEAY -1,Y             
$41B7  10 AF 46            Sub_41B7:      STY BSS.RxBufPtr,U    
$41BA  35 A6                              PULS A,B,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$41BC  EC 81               Sub_41BC:      LDD ,X++              
$41BE  81 1F                              CMPA #$1F             
$41C0  22 08                              BHI Sub_41CA          
$41C2  81 0A                              CMPA #$0A              ; compare A with LF
$41C4  27 06                              BEQ Sub_41CC          
$41C6  81 1A                              CMPA #$1A              ; compare A with SUB
$41C8  27 02                              BEQ Sub_41CC          
$41CA  A7 A0               Sub_41CA:      STA ,Y+               
$41CC  C1 1F               Sub_41CC:      CMPB #$1F             
$41CE  22 08                              BHI Sub_41D8          
$41D0  C1 0A                              CMPB #$0A              ; compare B with LF
$41D2  27 06                              BEQ Sub_41DA          
$41D4  C1 1A                              CMPB #$1A              ; compare B with SUB
$41D6  27 02                              BEQ Sub_41DA          
$41D8  E7 A0               Sub_41D8:      STB ,Y+               
$41DA  EC E4               Sub_41DA:      LDD ,S                
$41DC  83 00 02                           SUBD #$0002           
$41DF  ED E4                              STD ,S                
$41E1  22 D9                              BHI Sub_41BC          
$41E3  27 02                              BEQ Sub_41E7          
$41E5  31 3F                              LEAY -1,Y             
$41E7  10 AF 46            Sub_41E7:      STY BSS.RxBufPtr,U    
$41EA  35 A6                              PULS A,B,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$41EC  34 10               Sub_41EC:      PSHS X                
$41EE  AE 44                              LDX BSS.ParamBase,U   
$41F0  EC 46                              LDD BSS.RxBufPtr,U    
$41F2  A3 44                              SUBD BSS.ParamBase,U  
$41F4  1F 02                              TFR D,Y               
$41F6  A6 C8 42                           LDA 66,U              
$41F9  81 FF                              CMPA #$FF             
$41FB  27 03                              BEQ Sub_4200          
$41FD  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4200  EC 44               Sub_4200:      LDD BSS.ParamBase,U   
$4202  ED 46                              STD BSS.RxBufPtr,U    
$4204  35 90                              PULS X,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$4206  34 16               Sub_4206:      PSHS A,B,X            
$4208  6D C9 0C AD                        TST 3245,U            
$420C  27 20                              BEQ Sub_422E          
$420E  6C C8 4C                           INC 76,U              
$4211  C4 7F                              ANDB #$7F             
$4213  A6 80               Sub_4213:      LDA ,X+               
$4215  2B 17                              BMI Sub_422E          
$4217  27 10                              BEQ Sub_4229          
$4219  81 1F                              CMPA #$1F             
$421B  22 0C                              BHI Sub_4229          
$421D  81 0D                              CMPA #$0D              ; compare A with CR
$421F  27 08                              BEQ Sub_4229          
$4221  81 0A                              CMPA #$0A              ; compare A with LF
$4223  27 04                              BEQ Sub_4229          
$4225  81 09                              CMPA #$09             
$4227  26 05                              BNE Sub_422E          
$4229  5A                  Sub_4229:      DECB                  
$422A  26 E7                              BNE Sub_4213          
$422C  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$422E  6F C8 4C            Sub_422E:      CLR 76,U              
$4231  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$4233  CC 15 04            Sub_4233:      LDD #$1504            
$4236  ED C9 0C 8F                        STD 3215,U            
$423A  CC 25 07                           LDD #$2507            
$423D  ED C9 0C 91                        STD 3217,U            
$4241  17 DA 3D                           LBSR Sub_1C81          ; call Sub_1C81
$4244  30 8D C2 47                        LEAX Dat_048F,PC       ; X → Dat_048F
$4248  17 D8 B8                           LBSR WriteBlock        ; call WriteBlock
$424B  6D C9 0C A0                        TST 3232,U            
$424F  10 27 01 F9                        LBEQ Sub_444C         
$4253  30 8D C6 78                        LEAX Dat_08CF,PC       ; X → Dat_08CF
$4257  17 D8 A9                           LBSR WriteBlock        ; call WriteBlock
$425A  30 8D C2 BE                        LEAX Dat_051C,PC       ; X → Dat_051C
$425E  17 D8 A2                           LBSR WriteBlock        ; call WriteBlock
$4261  30 8D C2 26                        LEAX Dat_048B,PC       ; X → Dat_048B
$4265  17 D8 9B                           LBSR WriteBlock        ; call WriteBlock
$4268  6D C8 25                           TST 37,U              
$426B  27 51                              BEQ Sub_42BE          
$426D  30 8D C6 B4                        LEAX Dat_0925,PC       ; X → Dat_0925
$4271  17 D8 8F                           LBSR WriteBlock        ; call WriteBlock
$4274  30 C9 00 BF                        LEAX 191,U            
$4278  86 01                              LDA #$01              
$427A  10 AE C8 1E                        LDY BSS.CurrChar,U    
$427E  31 3F                              LEAY -1,Y             
$4280  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4283  30 8D C6 61                        LEAX Dat_08E8,PC       ; X → Dat_08E8
$4287  17 D8 79                           LBSR WriteBlock        ; call WriteBlock
$428A  17 E8 38            Sub_428A:      LBSR Sub_2AC5          ; call Sub_2AC5
$428D  81 59                              CMPA #$59              ; compare A with 'Y'
$428F  27 12                              BEQ Sub_42A3          
$4291  81 0D                              CMPA #$0D              ; compare A with CR
$4293  27 0E                              BEQ Sub_42A3          
$4295  81 4E                              CMPA #$4E              ; compare A with 'N'
$4297  10 27 00 97                        LBEQ Sub_4332         
$429B  81 05                              CMPA #$05             
$429D  10 27 00 91                        LBEQ Sub_4332         
$42A1  20 E7                              BRA Sub_428A          

; --------------------------------------------------------------
$42A3  17 01 24            Sub_42A3:      LBSR Sub_43CA          ; call Sub_43CA
$42A6  17 02 38                           LBSR Sub_44E1          ; call Sub_44E1
$42A9  A6 C8 2A                           LDA 42,U              
$42AC  10 3F 8F                           OS9 I$Close            ; path=A
$42AF  10 25 00 88                        LBCS Sub_433B         
$42B3  6F C8 25                           CLR 37,U              
$42B6  6F C8 26                           CLR 38,U              
$42B9  17 E0 A6                           LBSR Sub_2362          ; call Sub_2362
$42BC  20 74                              BRA Sub_4332          

; --------------------------------------------------------------
$42BE  6D C8 20            Sub_42BE:      TST BSS.StateFlag,U   
$42C1  26 24                              BNE Sub_42E7          
$42C3  30 8D C2 98                        LEAX Dat_055F,PC       ; X → Dat_055F
$42C7  17 D8 39                           LBSR WriteBlock        ; call WriteBlock
$42CA  C6 1E                              LDB #$1E              
$42CC  17 D8 92                           LBSR Sub_1B61          ; call Sub_1B61
$42CF  6D C8 21                           TST 33,U              
$42D2  26 5E                              BNE Sub_4332          
$42D4  EC C8 1C                           LDD 28,U              
$42D7  ED C8 1E                           STD BSS.CurrChar,U    
$42DA  30 C9 06 0E                        LEAX 1550,U           
$42DE  31 C9 00 BF                        LEAY 191,U            
$42E2  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$42E4  17 EA 37                           LBSR Sub_2D1E          ; call Sub_2D1E
$42E7  30 C9 00 BF         Sub_42E7:      LEAX 191,U            
$42EB  A6 84                              LDA ,X                
$42ED  81 0D                              CMPA #$0D              ; compare A with CR
$42EF  27 41                              BEQ Sub_4332          
$42F1  86 02                              LDA #$02               ; A = CurXY
$42F3  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$42F5  10 3F 83                           OS9 I$Create           ; mode=B  name→X  → path→A
$42F8  24 1E                              BCC Sub_4318           ; C=0 (BHS)
$42FA  C1 DA                              CMPB #$DA             
$42FC  26 3D                              BNE Sub_433B          
$42FE  30 8D C6 29                        LEAX Dat_092B,PC       ; X → Dat_092B
$4302  17 D7 FE                           LBSR WriteBlock        ; call WriteBlock
$4305  17 E7 BD            Sub_4305:      LBSR Sub_2AC5          ; call Sub_2AC5
$4308  81 41                              CMPA #$41              ; compare A with 'A'
$430A  27 57                              BEQ Sub_4363          
$430C  81 4F                              CMPA #$4F              ; compare A with 'O'
$430E  10 27 00 78                        LBEQ Sub_438A         
$4312  81 0D                              CMPA #$0D              ; compare A with CR
$4314  27 1C                              BEQ Sub_4332          
$4316  20 ED                              BRA Sub_4305          

; --------------------------------------------------------------
$4318  A7 C8 2A            Sub_4318:      STA 42,U              
$431B  6C C8 25            Sub_431B:      INC 37,U              
$431E  6D C8 24                           TST 36,U              
$4321  26 0F                              BNE Sub_4332          
$4323  6C C8 26                           INC 38,U              
$4326  17 E0 37                           LBSR Sub_2360          ; call Sub_2360
$4329  A6 42                              LDA BSS.ParamStr,U    
$432B  A0 46                              SUBA BSS.RxBufPtr,U   
$432D  A7 48                              STA BSS.TxBufPtr,U    
$432F  17 01 CD                           LBSR Sub_44FF          ; call Sub_44FF
$4332  6F C8 24            Sub_4332:      CLR 36,U              
$4335  17 D9 A6                           LBSR Sub_1CDE          ; call Sub_1CDE
$4338  16 C9 23                           LBRA Sub_0C5E         

; --------------------------------------------------------------
$433B  86 07               Sub_433B:      LDA #$07              
$433D  17 DB CB                           LBSR Sub_1F0B          ; call Sub_1F0B
$4340  34 04                              PSHS B                
$4342  CC 0D 02                           LDD #$0D02            
$4345  17 DF 4C                           LBSR Sub_2294          ; call Sub_2294
$4348  30 8D C1 43                        LEAX Dat_048F,PC       ; X → Dat_048F
$434C  17 D7 B4                           LBSR WriteBlock        ; call WriteBlock
$434F  35 04                              PULS B                
$4351  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$4354  8E 00 3C                           LDX #$003C            
$4357  17 CB FC                           LBSR Sub_0F56          ; call Sub_0F56
$435A  30 8D C1 2D                        LEAX Dat_048B,PC       ; X → Dat_048B
$435E  17 D7 A2                           LBSR WriteBlock        ; call WriteBlock
$4361  20 CF                              BRA Sub_4332          

; --------------------------------------------------------------
$4363  30 C9 00 BF         Sub_4363:      LEAX 191,U            
$4367  86 03                              LDA #$03              
$4369  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$436C  24 0B                              BCC Sub_4379           ; C=0 (BHS)
$436E  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$4371  8E 00 3C                           LDX #$003C            
$4374  17 CB DF                           LBSR Sub_0F56          ; call Sub_0F56
$4377  20 C2                              BRA Sub_433B          

; --------------------------------------------------------------
$4379  A7 C8 2A            Sub_4379:      STA 42,U              
$437C  34 40                              PSHS U                
$437E  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$4380  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$4383  10 3F 88                           OS9 I$Seek             ; path=A  mode=B  offset→X:D
$4386  35 40                              PULS U                
$4388  20 91                              BRA Sub_431B          

; --------------------------------------------------------------
$438A  30 C9 00 BF         Sub_438A:      LEAX 191,U            
$438E  10 3F 87                           OS9 I$Delete           ; name→X
$4391  16 FF 53                           LBRA Sub_42E7         

; --------------------------------------------------------------
$4394  34 36               Sub_4394:      PSHS A,B,X,Y          
$4396  30 C9 07 0D                        LEAX 1805,U           
$439A  10 AE C9 0C 88                     LDY 3208,U            
$439F  1F 20                              TFR Y,D               
$43A1  10 AE 46                           LDY BSS.RxBufPtr,U    
$43A4  A6 80               Sub_43A4:      LDA ,X+               
$43A6  81 0A                              CMPA #$0A              ; compare A with LF
$43A8  27 05                              BEQ Sub_43AF          
$43AA  A7 A0                              STA ,Y+               
$43AC  10 AF 46                           STY BSS.RxBufPtr,U    
$43AF  5A                  Sub_43AF:      DECB                  
$43B0  10 AC 42                           CMPY BSS.ParamStr,U   
$43B3  25 05                              BCS Sub_43BA           ; C=1 (BLO)
$43B5  8D 13                              BSR Sub_43CA           ; call Sub_43CA
$43B7  10 AE 46                           LDY BSS.RxBufPtr,U    
$43BA  5D                  Sub_43BA:      TSTB                  
$43BB  26 E7                              BNE Sub_43A4          
$43BD  A6 42                              LDA BSS.ParamStr,U    
$43BF  A0 46                              SUBA BSS.RxBufPtr,U   
$43C1  A1 48                              CMPA BSS.TxBufPtr,U   
$43C3  27 03                              BEQ Sub_43C8          
$43C5  17 01 37                           LBSR Sub_44FF          ; call Sub_44FF
$43C8  35 B6               Sub_43C8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$43CA  34 36               Sub_43CA:      PSHS A,B,X,Y          
$43CC  EC 46                              LDD BSS.RxBufPtr,U    
$43CE  ED 49                              STD 9,U               
$43D0  6D C8 25                           TST 37,U              
$43D3  27 28                              BEQ Sub_43FD          
$43D5  A6 C9 0C B0                        LDA 3248,U            
$43D9  27 06                              BEQ Sub_43E1          
$43DB  A7 C8 44                           STA 68,U              
$43DE  17 FA 7C                           LBSR Sub_3E5D          ; call Sub_3E5D
$43E1  EC 46               Sub_43E1:      LDD BSS.RxBufPtr,U    
$43E3  A3 44                              SUBD BSS.ParamBase,U  
$43E5  1F 02                              TFR D,Y               
$43E7  30 C9 16 B9                        LEAX 5817,U           
$43EB  A6 C8 2A                           LDA 42,U              
$43EE  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$43F1  A6 C9 0C AF                        LDA 3247,U            
$43F5  27 06                              BEQ Sub_43FD          
$43F7  A7 C8 44                           STA 68,U              
$43FA  17 FA 60                           LBSR Sub_3E5D          ; call Sub_3E5D
$43FD  EC 44               Sub_43FD:      LDD BSS.ParamBase,U   
$43FF  ED 46                              STD BSS.RxBufPtr,U    
$4401  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$4403  34 36               Sub_4403:      PSHS A,B,X,Y          
$4405  6F C8 24                           CLR 36,U              
$4408  AE C4                              LDX ,U                
$440A  A6 80               Sub_440A:      LDA ,X+               
$440C  81 0D                              CMPA #$0D              ; compare A with CR
$440E  27 37                              BEQ Sub_4447          
$4410  81 66                              CMPA #$66              ; compare A with 'f'
$4412  27 04                              BEQ Sub_4418          
$4414  81 46                              CMPA #$46              ; compare A with 'F'
$4416  26 F2                              BNE Sub_440A          
$4418  A6 1E               Sub_4418:      LDA -2,X              
$441A  81 20                              CMPA #$20              ; compare A with ' '
$441C  27 07                              BEQ Sub_4425          
$441E  81 2D                              CMPA #$2D              ; compare A with '-'
$4420  26 E8                              BNE Sub_440A          
$4422  6C C8 24                           INC 36,U              
$4425  A6 80               Sub_4425:      LDA ,X+               
$4427  81 3D                              CMPA #$3D              ; compare A with '='
$4429  26 DF                              BNE Sub_440A          
$442B  31 C9 00 BF                        LEAY 191,U            
$442F  5F                                 CLRB                   ; B = 0
$4430  A6 80               Sub_4430:      LDA ,X+               
$4432  A7 A0                              STA ,Y+               
$4434  5C                                 INCB                  
$4435  81 0D                              CMPA #$0D              ; compare A with CR
$4437  27 04                              BEQ Sub_443D          
$4439  C1 20                              CMPB #$20              ; compare B with ' '
$443B  25 F3                              BCS Sub_4430           ; C=1 (BLO)
$443D  4F                  Sub_443D:      CLRA                   ; A = 0
$443E  ED C8 1E                           STD BSS.CurrChar,U    
$4441  6C C8 20                           INC BSS.StateFlag,U   
$4444  17 FD EC                           LBSR Sub_4233          ; call Sub_4233
$4447  6F C8 20            Sub_4447:      CLR BSS.StateFlag,U   
$444A  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$444C  30 8D C4 C0         Sub_444C:      LEAX Dat_0910,PC       ; X → Dat_0910
$4450  17 D6 B0                           LBSR WriteBlock        ; call WriteBlock
$4453  30 8D C0 34                        LEAX Dat_048B,PC       ; X → Dat_048B
$4457  17 D6 A9                           LBSR WriteBlock        ; call WriteBlock
$445A  30 8D C1 01                        LEAX Dat_055F,PC       ; X → Dat_055F
$445E  17 D6 A2                           LBSR WriteBlock        ; call WriteBlock
$4461  C6 1E                              LDB #$1E              
$4463  17 D6 FB                           LBSR Sub_1B61          ; call Sub_1B61
$4466  6D C8 21                           TST 33,U              
$4469  26 64                              BNE Sub_44CF          
$446B  30 C9 06 0E                        LEAX 1550,U           
$446F  31 C9 13 A9                        LEAY 5033,U           
$4473  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$4475  17 E8 A6                           LBSR Sub_2D1E          ; call Sub_2D1E
$4478  30 C9 13 A9                        LEAX 5033,U           
$447C  A6 84                              LDA ,X                
$447E  81 0D                              CMPA #$0D              ; compare A with CR
$4480  27 4D                              BEQ Sub_44CF          
$4482  86 01                              LDA #$01              
$4484  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$4487  25 46                              BCS Sub_44CF           ; C=1 (BLO)
$4489  A7 C8 2C                           STA 44,U              
$448C  86 01                              LDA #$01              
$448E  A7 C8 23                           STA 35,U              
$4491  17 D8 4A                           LBSR Sub_1CDE          ; call Sub_1CDE
$4494  A6 C8 2C            Sub_4494:      LDA 44,U              
$4497  30 C9 13 A9                        LEAX 5033,U           
$449B  10 8E 00 FF                        LDY #$00FF            
$449F  10 3F 8B                           OS9 I$ReadLn           ; path=A  max=Y  buf→X
$44A2  25 1F                              BCS Sub_44C3           ; C=1 (BLO)
$44A4  A6 C8 2B                           LDA 43,U              
$44A7  30 C9 13 A9                        LEAX 5033,U           
$44AB  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$44AE  17 CF 11                           LBSR Sub_13C2          ; call Sub_13C2
$44B1  24 21                              BCC Sub_44D4           ; C=0 (BHS)
$44B3  16 C7 A8            Sub_44B3:      LBRA Sub_0C5E         
$44B6  8E 00 04            Sub_44B6:      LDX #$0004            
$44B9  17 CA 9A                           LBSR Sub_0F56          ; call Sub_0F56
$44BC  17 CF 07                           LBSR Sub_13C6          ; call Sub_13C6
$44BF  24 F2                              BCC Sub_44B3           ; C=0 (BHS)
$44C1  20 D1                              BRA Sub_4494          

; --------------------------------------------------------------
$44C3  A6 C8 2C            Sub_44C3:      LDA 44,U              
$44C6  10 3F 8F                           OS9 I$Close            ; path=A
$44C9  6F C8 23                           CLR 35,U              
$44CC  16 C7 8F            Sub_44CC:      LBRA Sub_0C5E         
$44CF  17 D8 0C            Sub_44CF:      LBSR Sub_1CDE          ; call Sub_1CDE
$44D2  20 F8                              BRA Sub_44CC          

; --------------------------------------------------------------
$44D4  17 E5 EE            Sub_44D4:      LBSR Sub_2AC5          ; call Sub_2AC5
$44D7  81 03                              CMPA #$03             
$44D9  27 E8                              BEQ Sub_44C3          
$44DB  81 05                              CMPA #$05             
$44DD  27 E4                              BEQ Sub_44C3          
$44DF  20 D2                              BRA Sub_44B3          

; --------------------------------------------------------------
$44E1  34 36               Sub_44E1:      PSHS A,B,X,Y          
$44E3  30 C9 13 A9                        LEAX 5033,U           
$44E7  CC 02 6A                           LDD #$026A            
$44EA  ED 84                              STD ,X                
$44EC  CC 20 20                           LDD #$2020            
$44EF  ED 02                              STD 2,X               
$44F1  ED 04                              STD 4,X               
$44F3  A6 C8 3E                           LDA 62,U              
$44F6  10 8E 00 06                        LDY #$0006            
$44FA  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$44FD  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$44FF  34 36               Sub_44FF:      PSHS A,B,X,Y          
$4501  A7 48                              STA BSS.TxBufPtr,U    
$4503  44                                 LSRA                  
$4504  44                                 LSRA                  
$4505  4C                                 INCA                  
$4506  30 C9 13 A9                        LEAX 5033,U           
$450A  5F                                 CLRB                   ; B = 0
$450B  81 0A               Sub_450B:      CMPA #$0A              ; compare A with LF
$450D  25 05                              BCS Sub_4514           ; C=1 (BLO)
$450F  80 0A                              SUBA #$0A             
$4511  5C                                 INCB                  
$4512  20 F7                              BRA Sub_450B          

; --------------------------------------------------------------
$4514  CB 30               Sub_4514:      ADDB #$30             
$4516  8B 30                              ADDA #$30             
$4518  C1 30                              CMPB #$30              ; compare B with '0'
$451A  26 02                              BNE Sub_451E          
$451C  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$451E  E7 03               Sub_451E:      STB 3,X               
$4520  A7 04                              STA 4,X               
$4522  CC 02 6A                           LDD #$026A            
$4525  ED 84                              STD ,X                
$4527  86 20                              LDA #$20               ; A = ' '
$4529  A7 02                              STA 2,X               
$452B  86 4B                              LDA #$4B               ; A = 'K'
$452D  A7 05                              STA 5,X               
$452F  A6 C8 3E                           LDA 62,U              
$4532  10 8E 00 06                        LDY #$0006            
$4536  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4539  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$453B  34 36               Sub_453B:      PSHS A,B,X,Y          
$453D  30 C9 07 0D                        LEAX 1805,U           
$4541  E6 C9 0C 89                        LDB 3209,U            
$4545  10 AE 4F                           LDY 15,U              
$4548  A6 80               Sub_4548:      LDA ,X+               
$454A  A7 A0                              STA ,Y+               
$454C  5A                                 DECB                  
$454D  10 AC 4B                           CMPY BSS.Var000B,U    
$4550  25 03                              BCS Sub_4555           ; C=1 (BLO)
$4552  10 AE 4D                           LDY 13,U              
$4555  5D                  Sub_4555:      TSTB                  
$4556  26 F0                              BNE Sub_4548          
$4558  10 AF 4F                           STY 15,U              
$455B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$455D  34 36               Sub_455D:      PSHS A,B,X,Y          
$455F  AE 4F                              LDX 15,U              
$4561  A6 82               Sub_4561:      LDA ,-X               
$4563  81 2E                              CMPA #$2E              ; compare A with '.'
$4565  27 10                              BEQ Sub_4577          
$4567  AC 4D               Sub_4567:      CMPX 13,U             
$4569  26 02                              BNE Sub_456D          
$456B  AE 4B                              LDX BSS.Var000B,U     
$456D  AC 4F               Sub_456D:      CMPX 15,U             
$456F  26 F0                              BNE Sub_4561          
$4571  6F C9 00 9B                        CLR 155,U             
$4575  35 B6               Sub_4575:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$4577  A6 01               Sub_4577:      LDA 1,X               
$4579  81 2E                              CMPA #$2E              ; compare A with '.'
$457B  25 EA                              BCS Sub_4567           ; C=1 (BLO)
$457D  A6 1F                              LDA -1,X              
$457F  81 2E                              CMPA #$2E              ; compare A with '.'
$4581  25 E4                              BCS Sub_4567           ; C=1 (BLO)
$4583  A6 82               Sub_4583:      LDA ,-X               
$4585  81 30                              CMPA #$30              ; compare A with '0'
$4587  25 06                              BCS Sub_458F           ; C=1 (BLO)
$4589  AC 4F                              CMPX 15,U             
$458B  27 E0                              BEQ Sub_456D          
$458D  20 F4                              BRA Sub_4583          

; --------------------------------------------------------------
$458F  A6 01               Sub_458F:      LDA 1,X               
$4591  81 41                              CMPA #$41              ; compare A with 'A'
$4593  25 D8                              BCS Sub_456D           ; C=1 (BLO)
$4595  C6 1F                              LDB #$1F              
$4597  30 01                              LEAX 1,X              
$4599  31 C9 00 9F                        LEAY 159,U            
$459D  A6 80               Sub_459D:      LDA ,X+               
$459F  81 2E               Sub_459F:      CMPA #$2E              ; compare A with '.'
$45A1  25 15                              BCS Sub_45B8           ; C=1 (BLO)
$45A3  A7 A0                              STA ,Y+               
$45A5  5A                                 DECB                  
$45A6  27 10                              BEQ Sub_45B8          
$45A8  AC 4B                              CMPX BSS.Var000B,U    
$45AA  27 06                              BEQ Sub_45B2          
$45AC  AC 4F                              CMPX 15,U             
$45AE  27 08                              BEQ Sub_45B8          
$45B0  20 EB                              BRA Sub_459D          

; --------------------------------------------------------------
$45B2  A6 84               Sub_45B2:      LDA ,X                
$45B4  AE 4D                              LDX 13,U              
$45B6  20 E7                              BRA Sub_459F          

; --------------------------------------------------------------
$45B8  86 0D               Sub_45B8:      LDA #$0D               ; A = CR
$45BA  A7 A4                              STA ,Y                
$45BC  6C C9 00 9B                        INC 155,U             
$45C0  20 B3                              BRA Sub_4575          

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

; ══════════════════════════════════════════════════════════════