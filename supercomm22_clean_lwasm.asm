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
; Disassembly:  supercomm22
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

Init:          STX ,U                
	LEAX -64,X            
	STX BSS.ParamStr,U    
	LEAS -1,S             
	LEAX 5817,U           
	STX BSS.ParamBase,U   
	STX BSS.RxBufPtr,U    
	LEAX -1,X             
	STX BSS.Var000B,U     
	LEAX 5305,U           
	STX 13,U              
	STX 15,U              
	LDD #$0000            
	STD 9,U               
	LEAX 25,U             
Sub_0A96:      CLR ,X+               
	CMPX BSS.ParamStr,U   
	BCS *-4  ; C=1 (BLO)
	LDX ,U                
	LDA #$20               ; A = ' '
	STA -1,X              
Sub_0AA2:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+16
	CMPA #$2F              ; compare A with '/'
	BNE *-8
	LDA -2,X              
	CMPA #$20              ; compare A with ' '
	BNE *-14
	LEAX -1,X             
	BRA *+6

; --------------------------------------------------------------
Sub_0AB6:      LEAX Dat_035A,PCR       ; X → Dat_035A
Sub_0ABA:      LEAY BSS.Counter1,U   
	LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
Sub_0ABF:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+7
	STA ,Y+               
	DECB                  
	BNE *-9
Sub_0ACA:      STA ,Y+               
	LBSR Sub_12F5          ; call Sub_12F5
	LBCS Sub_0F15         
	LBSR Sub_1A8A          ; call Sub_1A8A
	LBCS Sub_0F15         
	LDA #$01              
	STA BSS.BufPtr3,U     
	LDX #$0001            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDA #$01              
	LDB #$92              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+49  ; C=1 (BLO)
	TFR X,D               
	STB 3204,U            
	ORA 3204,U            
	STA BSS.BufPtr3,U     
	LEAX Dat_0A24,PCR       ; X → Dat_0A24
	LEAY 3237,U           
	LDB #$4D               ; B = 'M'
	LBSR Sub_2D1E          ; call Sub_2D1E
	LDA #$03              
	LEAX Dat_0A51,PCR       ; X → Dat_0A51
	OS9 I$ChgDir           ; mode=B  name→X
	LEAX Dat_0366,PCR       ; X → Dat_0366
	LEAY 119,U            
	LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
Sub_0B1D:      LBSR Sub_1BDF          ; call Sub_1BDF
	LBSR Sub_1C57          ; call Sub_1C57
	LBSR Sub_1BC7          ; call Sub_1BC7
	LEAX Dat_0F18,PCR       ; X → Dat_0F18
	OS9 F$Icpt             ; handler→X  data→U
	LEAX 223,U            
	LDD #$0000            
	STD ,X                
	STD 2,X               
	STD 4,X               
	STB 6,X               
	TFR X,D               
	LDX #$007C            
	LDY #$0001            
	PSHS U                
	LEAU 25,U             
	OS9 F$CpyMem           ; src→X  dst→Y  count=D
	PULS U                
	LEAX Dat_0360,PCR       ; X → Dat_0360
	LDA #$03              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+58  ; C=1 (BLO)
	STA 114,U             
	LDB #$81              
	LDY #$0001            
	LDX #$003C            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	BCS *+32  ; C=1 (BLO)
	LDA 114,U             
	LDY #$0800            
	LDX #$0800            
	LDB #$80              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+15  ; C=1 (BLO)
	CMPX #$0800           
	BCC *+10  ; C=0 (BHS)
	CMPY #$0800           
	BCC *+4  ; C=0 (BHS)
	BRA *+11

; --------------------------------------------------------------
Sub_0B89:      LDA 114,U             
Insn_0B8C:     OS9 I$Close            ; path=A
Sub_0B8D:      EQU    $0B8D            ; mid-instruction overlap: Insn_0B8C+1 -- mid-instruction entry point -- byte 2 of OS9 I$Close ($10 3F 8F) at $0B8C
	CLR 114,U             
Sub_0B92:      LEAX 1295,U           
	STX 102,U             
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	STB 3353,U            
	CLRA                   ; A = 0
	LDB #$14              
	STA 3354,U            
	LDD #$1B32             ; D=ESC+'2'  → W.FColor: Foreground Color
	STD 156,U             
	LEAX Dat_045E,PCR       ; X → Dat_045E
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDD #$1A04            
	STD 3215,U            
	LDD #$1609            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_006F,PCR       ; X → Dat_006F
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_1AE8          ; call Sub_1AE8
	LDX #$001C            
	LBSR Sub_0F56          ; call Sub_0F56
	LDD #$3210            
	STD 3215,U            
	LDD #$1304            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_00C6,PCR       ; X → Dat_00C6
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_3BBC          ; call Sub_3BBC
Sub_0BF7:      CLRA                   ; A = 0
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$0A              ; compare A with LF
	BCS *-13  ; C=1 (BLO)
	BRA *+5

; --------------------------------------------------------------
Sub_0C08:      LBSR Sub_2AC5          ; call Sub_2AC5
Sub_0C0B:      LBSR Sub_1CDE          ; call Sub_1CDE
	LBSR Sub_1CDE          ; call Sub_1CDE
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LDA #$03              
	LEAX BSS.Counter1,U   
	OS9 I$Open             ; mode=B  name→X  → path→A
	LBCS Sub_0F15         
	STA 43,U              
	LEAX Dat_045E,PCR       ; X → Dat_045E
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_117F          ; call Sub_117F
	LBSR Sub_2B86          ; call Sub_2B86
	LBSR Sub_4403          ; call Sub_4403
	LDD #$0103            
	STD 3220,U            
	LBSR Sub_2AF5          ; call Sub_2AF5
	LBSR Sub_134D          ; call Sub_134D
	LBSR Sub_12B5          ; call Sub_12B5
	LDA #$00               ; A = NUL
	LEAX Dat_031A,PCR       ; X → Dat_031A
	STX 108,U             
	LEAX 1550,U           
Insn_0C54:     LDY #$0001            
Sub_0C57:      EQU    $0C57            ; [*1] branch target 3 byte(s) inside Insn_0C54 -- see [*1]
	OS9 I$Read             ; path=A  count=Y  buf→X
	LBRA Sub_157B         

; --------------------------------------------------------------
Sub_0C5E:      LBSR Sub_13C6          ; call Sub_13C6
	LBCC Sub_0FB8         
	TST 35,U              
	LBNE Sub_44B6         
	LDX #$0003            
	LBSR Sub_0F56          ; call Sub_0F56
Sub_0C72:      LBSR Sub_13C2          ; call Sub_13C2
	BCS *-23  ; C=1 (BLO)
	TST 64,U              
	LBNE Sub_273D         
	LBRA Sub_156E         

; --------------------------------------------------------------
Sub_0C81:      LEAX 223,U            
	LEAY 1805,U           
	LDB 3209,U            
Sub_0C8D:      LDA ,X+               
	ANDA #$7F             
	CMPA #$20              ; compare A with ' '
	BCS *+15  ; C=1 (BLO)
	CMPA #$7F             
	BHI *+11
	LBSR Sub_13CF          ; call Sub_13CF
Sub_0C9C:      STA ,Y+               
Sub_0C9E:      DECB                  
	BNE *-18
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0CA2:      CMPA #$08              ; compare A with BS
	BNE *+7
	LBSR Sub_13EC          ; call Sub_13EC
	BRA *-13

; --------------------------------------------------------------
Sub_0CAB:      CMPA #$0D              ; compare A with CR
	BNE *+24
	LBSR Sub_1405          ; call Sub_1405
	TST 3240,U            
	BEQ *-26
	LBSR Sub_140E          ; call Sub_140E
	INC 3209,U            
	STA ,Y+               
	LDA #$0A               ; A = LF
	BRA *-39

; --------------------------------------------------------------
Sub_0CC5:      CMPA #$0C              ; compare A with FF
	BNE *+7
	LBSR Sub_1422          ; call Sub_1422
	BRA *-48

; --------------------------------------------------------------
Sub_0CCE:      CMPA #$07             
	BEQ *-52
	CMPA #$0A              ; compare A with LF
	BNE *+7
	LBSR Sub_140E          ; call Sub_140E
	BRA *-61

; --------------------------------------------------------------
Sub_0CDB:      CMPA #$09             
	BNE *+7
	LBSR Sub_1BDE          ; call Sub_1BDE
	BRA *-68

; --------------------------------------------------------------
Sub_0CE4:      DEC 3209,U            
	BRA *-74

; --------------------------------------------------------------
Sub_0CEA:      LEAX 223,U            
	LEAY 1805,U           
	LDB 3209,U            
Sub_0CF6:      TST 3210,U            
	LBNE Sub_0D9F         
	LDA ,X+               
	CMPA #$20              ; compare A with ' '
	BCS *+17  ; C=1 (BLO)
	CMPA #$80             
	BCS *+4  ; C=1 (BLO)
	LDA #$2A               ; A = '*'
Sub_0D0A:      LBSR Sub_13CF          ; call Sub_13CF
Sub_0D0D:      STA ,Y+               
Sub_0D0F:      DECB                  
	BNE *-26
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0D13:      CMPA #$08              ; compare A with BS
	BEQ *+28
	CMPA #$0D              ; compare A with CR
	BEQ *+41
	CMPA #$0A              ; compare A with LF
	BEQ *+59
	CMPA #$0C              ; compare A with FF
	BEQ *+60
	CMPA #$07             
	BEQ *-27
	CMPA #$1B              ; compare A with ESC
	BEQ *+57
Sub_0D2B:      DEC 3209,U            
	BRA *-32

; --------------------------------------------------------------
Sub_0D31:      PSHS A                
	LDA 3220,U            
	CMPA #$01             
	PULS A                
	BEQ *-16
	LBSR Sub_13EC          ; call Sub_13EC
	BRA *-51

; --------------------------------------------------------------
Sub_0D42:      LBSR Sub_1405          ; call Sub_1405
	TST 3240,U            
	BEQ *-60
	LBSR Sub_140E          ; call Sub_140E
	INC 3209,U            
	STA ,Y+               
	LDA #$0A               ; A = LF
	BRA *-73

; --------------------------------------------------------------
Sub_0D58:      LBSR Sub_140E          ; call Sub_140E
	BRA *-78

; --------------------------------------------------------------
Sub_0D5D:      LBSR Sub_1422          ; call Sub_1422
	BRA *-83

; --------------------------------------------------------------
Sub_0D62:      INC 3210,U            
	CLR 3211,U            
	LDA #$FF              
	STA 3168,U            
	PSHS Y                
	LEAY 3168,U           
	STY 3200,U            
	CLR 3168,U            
	CLR 3169,U            
	STA 3170,U            
	PULS Y                
	BSR *+9  ; call Sub_0D92
	DEC 3209,U            
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_0D92:      PSHS Y                
	LEAY 2829,U           
	STY 3213,U            
	PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_0D9F:      PSHS Y                
	LDY 3213,U            
	LDA ,X+               
	STA ,Y+               
	STY 3213,U            
	PULS Y                
	CMPA #$5B              ; compare A with '['
	BEQ *+6
	CMPA #$40              ; compare A with '@'
	BHI *+9
Sub_0DB9:      DEC 3209,U            
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_0DC0:      CLR 3210,U            
	STA 3212,U            
	DEC 3209,U            
	BSR *-58  ; call Sub_0D92
	PSHS B,Y              
	LDY 3200,U            
	LDA #$FF              
	STA ,Y                
	LEAY 3168,U           
	STY 3200,U            
	LDY 3213,U            
	LEAY 1,Y              
	STY 3213,U            
Sub_0DEE:      LDA ,Y+               
	CMPA #$40              ; compare A with '@'
	BHI *+73
	CMPA #$3A              ; compare A with ':'
	BCS *+6  ; C=1 (BLO)
	LDB #$FE              
	BRA *+31

; --------------------------------------------------------------
Sub_0DFC:      SUBA #$30             
	STA 3204,U            
	LDA ,Y+               
	CMPA #$39              ; compare A with '9'
	BHI *+45
	SUBA #$30             
	STA 3205,U            
	LDA 3204,U            
	LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	ADDB -1,Y             
	SUBB #$30             
Sub_0E19:      PSHS Y                
	LDY 3200,U            
	STB ,Y+               
	LDB #$FF              
	STB ,Y                
	STB 1,Y               
	STB 2,Y               
	STY 3200,U            
	PULS Y                
	BRA *-67

; --------------------------------------------------------------
Sub_0E33:      LEAY -1,Y             
	LDB 3204,U            
	BRA *-32

; --------------------------------------------------------------
Sub_0E3B:      PULS B,Y              
	LDA 3212,U            
	CMPA #$6D              ; compare A with 'm'
	BEQ *+65
	CMPA #$4A              ; compare A with 'J'
	LBEQ Sub_10E2         
	CMPA #$66              ; compare A with 'f'
	LBEQ Sub_1467         
	CMPA #$48              ; compare A with 'H'
	LBEQ Sub_1467         
	CMPA #$43              ; compare A with 'C'
	LBEQ Sub_14B0         
	CMPA #$44              ; compare A with 'D'
	LBEQ Sub_14F4         
	CMPA #$41              ; compare A with 'A'
	LBEQ Sub_151D         
	CMPA #$42              ; compare A with 'B'
	LBEQ Sub_1546         
	CMPA #$73              ; compare A with 's'
	LBEQ Sub_1433         
	CMPA #$75              ; compare A with 'u'
	LBEQ Sub_1442         
	CMPA #$4B              ; compare A with 'K'
	LBEQ Sub_1102         
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_0E84:      PSHS A,B,X            
	LEAX 3168,U           
Sub_0E8A:      LDA ,X+               
	CMPA #$FF             
	BEQ *+24
	CMPA #$00              ; compare A with NUL
	BEQ *+75
	CMPA #$01             
	BEQ *-12
	CMPA #$08              ; compare A with BS
	BCS *+17  ; C=1 (BLO)
	CMPA #$26              ; compare A with '&'
	BCS *+21  ; C=1 (BLO)
	CMPA #$30              ; compare A with '0'
	BCS *+38  ; C=1 (BLO)
	BRA *-26

; --------------------------------------------------------------
Sub_0EA6:      PULS A,B,X            
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_0EAB:      PSHS X                
	LEAX Dat_03E6,PCR       ; X → Dat_03E6
	BRA *+50

; --------------------------------------------------------------
Sub_0EB3:      LDB BSS.BufPtr3,U     
	CMPB #$02              ; compare B with CurXY
	BEQ *-46
	CMPA #$1E             
	BCS *-50  ; C=1 (BLO)
	SUBA #$1E             
	PSHS X                
	LEAX Dat_040E,PCR       ; X → Dat_040E
	BRA *+29

; --------------------------------------------------------------
Sub_0EC8:      LDB BSS.BufPtr3,U     
	CMPB #$02              ; compare B with CurXY
	BEQ *-67
	CMPA #$28              ; compare A with '('
	BCS *-71  ; C=1 (BLO)
	SUBA #$28             
	PSHS X                
	LEAX Dat_0436,PCR       ; X → Dat_0436
	BRA *+8

; --------------------------------------------------------------
Sub_0EDD:      PSHS X                
	LEAX Dat_03D6,PCR       ; X → Dat_03D6
Sub_0EE3:      LDB #$05               ; B = SS.Pos  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	LEAX B,X              
	LBSR Sub_10D2          ; call Sub_10D2
	PULS X                
	BRA *-99

; --------------------------------------------------------------
Sub_0EEF:      LDA 62,U              
	OS9 I$Close            ; path=A
	LBSR Sub_134D          ; call Sub_134D
	LBSR Sub_135C          ; call Sub_135C
	LBSR Sub_13BA          ; call Sub_13BA
	LDA 114,U             
	BEQ *+5
	OS9 I$Close            ; path=A
Sub_0F06:      TST 37,U              
	BEQ *+11
	LBSR Sub_43CA          ; call Sub_43CA
	LDA 42,U              
	OS9 I$Close            ; path=A
Sub_0F14:      CLRB                   ; B = 0
Sub_0F15:      OS9 F$Exit             ; status=B

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
Sub_0F1F:      RTI                    ; return from interrupt
Sub_0F20:      PSHS A,X,Y            
	LEAX 156,U            
	LDA 136,U             
	STA 2,X               
	LDA 62,U              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX 119,U            
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX 156,U            
	LDA 135,U             
	STA 2,X               
	LDA 62,U              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_0F56:      PSHS A                
	TST 117,U             
	BEQ *+18
	LDA 116,U             
Sub_0F60:      CMPA 115,U            
	BEQ *+10
	BSR *+19  ; call Sub_0F78
	INCA                  
	STA 116,U             
	BRA *-11

; --------------------------------------------------------------
Sub_0F6D:      PULS A                
	OS9 F$Sleep            ; ticks→X  (0=forever)
	CMPX #$0000           
	BNE *-31
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0F78:      PSHS A,B,X,Y          
	LEAX 119,U            
	LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
Sub_0F7F:      BSR *+13  ; call Sub_0F8C
	TSTA                  
	BPL *+42
	DECB                  
	DECB                  
	CMPB #$04             
	BCS *+36  ; C=1 (BLO)
	BRA *-11

; --------------------------------------------------------------
Sub_0F8C:      LDA B,X               
	CMPA #$39              ; compare A with '9'
	BEQ *+6
	INCA                  
	STA B,X               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0F96:      LDA #$30               ; A = '0'
	STA B,X               
	DECB                  
	LDA B,X               
	CMPA #$35              ; compare A with '5'
	BEQ *+6
	INCA                  
	STA B,X               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0FA5:      LDA #$30               ; A = '0'
	STA B,X               
	LDA #$FF              
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0FAC:      LDA 62,U              
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_0FB8:      CLRA                   ; A = 0
	CMPB #$C0             
	BCS *+4  ; C=1 (BLO)
	LDB #$C0              
Sub_0FBF:      TFR D,Y               
	LDA 43,U              
	LEAX 223,U            
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *+88  ; C=1 (BLO)
	STY 3208,U            
Sub_0FD2:      CMPY #$0000           
	BEQ *+65
	TST 3246,U            
	BNE *+5
	LBSR Sub_1062          ; call Sub_1062
Sub_0FE1:      LDA 3202,U            
	BEQ *+15
	CMPA #$05             
	BNE *+8
	CLRA                   ; A = 0
	STA $0C82             
	BRA *+5

; --------------------------------------------------------------
Sub_0FF1:      LBSR Sub_254A          ; call Sub_254A
Sub_0FF4:      BSR *+76  ; call Sub_1040
	LDA #$01              
	LEAX 1805,U           
	LDY 3208,U            
	CMPY #$0000           
	BEQ *+18
	OS9 I$Write            ; path=A  count=Y  buf→X
	TST 37,U              
	BEQ *+10
	TST 38,U              
	BEQ *+5
	LBSR Sub_4394          ; call Sub_4394
Sub_1017:      LBSR Sub_453B          ; call Sub_453B
	TST 3203,U            
	BEQ *+5
	LBSR Sub_25B1          ; call Sub_25B1
Sub_1023:      TST 107,U             
	BPL *+16
	CLR 107,U             
	TST 3232,U            
	LBEQ Sub_1859         
	LBRA Sub_1793         

; --------------------------------------------------------------
Sub_1036:      TST 35,U              
	LBEQ Sub_0C72         
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_1040:      LDA 3238,U            
	BEQ *+14
	CMPA #$01             
	LBEQ Sub_0C81         
	CMPA #$02              ; compare A with CurXY
	LBEQ Sub_0CEA         
Sub_1052:      LEAX 223,U            
	LEAY 1805,U           
	LDB 3209,U            
	LBSR Sub_2D1E          ; call Sub_2D1E
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1062:      PSHS A,B,X,Y          
	LDB 3209,U            
	LDY 108,U             
	LEAX 223,U            
Sub_1070:      TSTB                  
	BEQ *+55
	TST 107,U             
	BEQ *+14
	LDA ,X                
	CMPA #$30              ; compare A with '0'
	BEQ *+69
	CMPA #$31              ; compare A with '1'
	BEQ *+71
	BRA *+14

; --------------------------------------------------------------
Sub_1084:      LDA ,X+               
	ANDA #$7F             
	DECB                  
	CLR 113,U             
Sub_108C:      CMPA ,Y               
	BEQ *+28
Sub_1090:      LEAY Dat_031A,PCR       ; Y → Dat_031A
	STY 108,U             
	TST 113,U             
	BNE *+7
	INC 113,U             
	BRA *-20

; --------------------------------------------------------------
Sub_10A2:      CLR 113,U             
	TSTB                  
	BNE *-34
Sub_10A8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_10AA:      LEAY 1,Y              
	STY 108,U             
	TST ,Y                
	BNE *-16
	INC 107,U             
	LEAY Dat_031A,PCR       ; Y → Dat_031A
	STY 108,U             
	BRA *-79

; --------------------------------------------------------------
Sub_10C1:      INC 3232,U            
	BRA *+6

; --------------------------------------------------------------
Sub_10C7:      CLR 3232,U            
Sub_10CB:      LDA #$FF              
	STA 107,U             
	BRA *-40

; --------------------------------------------------------------
Sub_10D2:      LDB 1,X               
	LEAX 2,X              
Sub_10D6:      LDA ,X+               
	STA ,Y+               
	INC 3209,U            
	DECB                  
	BNE *-9
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_10E2:      PSHS A,B,X            
	LEAX 3168,U           
	LDA ,X                
	CMPA #$02              ; compare A with CurXY
	BEQ *+11
	LEAX Dat_0464,PCR       ; X → Dat_0464
	BSR *-32  ; call Sub_10D2
Sub_10F4:      LBRA Sub_0EA6         
Sub_10F7:      LEAX Dat_045E,PCR       ; X → Dat_045E
	BSR *-41  ; call Sub_10D2
	LBSR Sub_1422          ; call Sub_1422
	BRA *-12

; --------------------------------------------------------------
Sub_1102:      PSHS A,B,X            
	LEAX Dat_0461,PCR       ; X → Dat_0461
	BSR *-54  ; call Sub_10D2
	LBRA Sub_0EA6         

; --------------------------------------------------------------
Sub_110D:      LDD #$1A01            
	STD 3215,U            
	LDD #$340D            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_0109,PCR       ; X → Dat_0109
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
Sub_112C:      LBSR Sub_2AC5          ; call Sub_2AC5
	CMPA #$20              ; compare A with ' '
	BEQ *+58
	CMPA #$05             
	BEQ *+54
	CMPA #$0C              ; compare A with FF
	BNE *+6
Sub_113B:      ADDA #$80             
	BRA *+25

; --------------------------------------------------------------
Sub_113F:      CMPA #$0A              ; compare A with LF
	BEQ *-6
	LDB Dat_0A15,PCR       
	LEAX Dat_0A16,PCR       ; X → Dat_0A16
Sub_114B:      CMPA ,X+              
	BEQ *+7
	DECB                  
	BNE *-5
	BRA *-38

; --------------------------------------------------------------
Sub_1154:      ADDA #$A0             
Sub_1156:      PSHS A                
	LEAX Dat_03C4,PCR       ; X → Dat_03C4
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	PULS A                
	LBRA Sub_1597         

; --------------------------------------------------------------
Sub_116B:      LEAX Dat_03C4,PCR       ; X → Dat_03C4
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_1BAD          ; call Sub_1BAD
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_117F:      PSHS A,B,X,Y          
	LDA 43,U              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	LEAX 3118,U           
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_118F:      PSHS A,B,X,Y          
	LEAX 3118,U           
	LDB 3237,U            
	STB 21,X              
	LDB 20,X              
	ANDB #$0F             
	ORB 3244,U            
	STB 20,X              
	LDB 3247,U            
	STB 24,X              
	LDB 3248,U            
	STB 25,X              
	LDB 3249,U            
	STB 4,X               
	LDB 3241,U            
	STB 5,X               
	CLR 7,X               
	LEAX 9,X              
	LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
Sub_11C8:      CLR ,X+               
	DECB                  
	BNE *-3
	LDA 43,U              
	CMPA #$03             
	LBLS Sub_12B3         
	LEAX 3118,U           
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LEAX 149,U            
	LDD #$025A            
	STD ,X                
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	STB 2,X               
	LDY #$0003            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 3237,U            
	ANDA #$07             
	LDB #$05               ; B = SS.Pos  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	LEAX Dat_0652,PCR       ; X → Dat_0652
	LEAX B,X              
	LDY #$0005            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB #$61               ; B = 'a'
	LEAX 149,U            
	STB 1,X               
	LDA 62,U              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB 3237,U            
	BITB #$20             
	BNE *+6
	LDB #$38               ; B = '8'
	BRA *+4

; --------------------------------------------------------------
Sub_122D:      LDB #$37               ; B = '7'
Sub_122F:      LEAX 68,U             
	STB ,X                
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB #$63               ; B = 'c'
	LEAX 149,U            
	STB 1,X               
	LDY #$0003            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 3244,U            
	ANDA #$E0             
	CMPA #$A0             
	BNE *+8
	LEAX Dat_0991,PCR       ; X → Dat_0991
	BRA *+36

; --------------------------------------------------------------
Sub_125D:      CMPA #$E0             
	BNE *+8
	LEAX Dat_0995,PCR       ; X → Dat_0995
	BRA *+26

; --------------------------------------------------------------
Sub_1267:      CMPA #$60              ; compare A with '`'
	BNE *+8
	LEAX Dat_099B,PCR       ; X → Dat_099B
	BRA *+16

; --------------------------------------------------------------
Sub_1271:      CMPA #$20              ; compare A with ' '
	BNE *+8
	LEAX Dat_09A0,PCR       ; X → Dat_09A0
	BRA *+6

; --------------------------------------------------------------
Sub_127B:      LEAX Dat_09A5,PCR       ; X → Dat_09A5
Sub_127F:      LDA 62,U              
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB #$65               ; B = 'e'
	LEAX 149,U            
	STB 1,X               
	LDA 62,U              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB 3237,U            
	BPL *+6
	LDB #$32               ; B = '2'
	BRA *+4

; --------------------------------------------------------------
Sub_12A5:      LDB #$31               ; B = '1'
Sub_12A7:      LEAX 68,U             
	STB ,X                
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_12B3:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_12B5:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LEAY 3084,U           
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D26          ; call Sub_2D26
	LEAX 5033,U           
	CLR 4,X               
	LDA 3240,U            
	STA 5,X               
	CLR 7,X               
	LDA 5027,U            
	STA 12,X              
	LDA 5030,U            
	STA 15,X              
	LDA 5028,U            
	STA 16,X              
	LDA 5029,U            
	STA 17,X              
	LDA #$01              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_12F5:      PSHS A,B,X            
	LDA #$00               ; A = NUL
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	LEAX 3084,U           
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDA 20,X              
	BPL *+67
	LDA #$01              
	LDB #$96              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	STA 141,U             
	STB 142,U             
	TFR X,D               
	STB 143,U             
	LEAX 3152,U           
	LDA #$01              
	LDB #$91              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDA #$01              
	LDB #$26               ; B = SS.FSig  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	TFR X,D               
	STB 130,U             
	TFR Y,D               
	STB 131,U             
	LDA #$01              
	LDB #$93              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	STA 132,U             
	CLRB                   ; B = 0
Sub_1346:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1348:      COMB                  
	LDB #$B7              
	BRA *-5

; --------------------------------------------------------------
Sub_134D:      PSHS A,B,X            
	LDA #$00               ; A = NUL
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	LEAX 3084,U           
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_135C:      PSHS A,B,X,Y          
	LEAY Dat_0469,PCR       ; Y → Dat_0469
	LDB #$10              
	LEAX 5033,U           
	LBSR Sub_2D26          ; call Sub_2D26
	LEAX 5033,U           
	LDA 132,U             
	STA 4,X               
	CLRA                   ; A = 0
	STA 6,X               
	LDA 130,U             
	STA 7,X               
	LDA 131,U             
	STA 8,X               
	LDA 141,U             
	STA 9,X               
	LDA 142,U             
	STA 10,X              
	LDA 143,U             
	STA 11,X              
	LDY #$000C            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX 3152,U           
	LDA #$01              
	LDB #$91              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDD #$1B21             ; D=ESC+'!'  → W.Select: Select window
	STD ,X                
	LDA #$01              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_13BA:      LEAX Dat_03A7,PCR       ; X → Dat_03A7
	LBSR WriteBlock        ; call WriteBlock
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_13C2:      LDA #$00               ; A = NUL
	BRA *+5

; --------------------------------------------------------------
Sub_13C6:      LDA 43,U              
Sub_13C9:      LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_13CF:      PSHS A,B              
	LDD 3220,U            
	INCA                  
	CMPA 144,U            
	BLS *+12
	LDA #$01              
	INCB                  
	CMPB 145,U            
	BLS *+3
	DECB                  
Sub_13E6:      STD 3220,U            
	PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_13EC:      PSHS A,B              
	LDD 3220,U            
	DECA                  
	BNE *+12
	LDA 144,U             
	DECB                  
	BNE *+5
	LDD #$0101            
Sub_13FF:      STD 3220,U            
	PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1405:      CLR 3220,U            
	INC 3220,U            
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_140E:      PSHS A,B              
	LDD 3220,U            
	INCB                  
	CMPB 145,U            
	BLS *+3
	DECB                  
Sub_141C:      STD 3220,U            
	PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1422:      CLR 3220,U            
	CLR 3221,U            
	INC 3220,U            
	INC 3221,U            
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1433:      PSHS A,B              
	LDD 3220,U            
	STD 3222,U            
	PULS A,B              
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_1442:      PSHS A,B              
	LDA #$02               ; A = CurXY
	STA ,Y+               
	LDD 3222,U            
	STD 3220,U            
	ADDA #$1F             
	ADDB #$1F             
	STA ,Y+               
	STB ,Y+               
	LDB 3209,U            
	ADDB #$03             
	STB 3209,U            
	PULS A,B              
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_1467:      PSHS A,B,X            
	LEAX 3168,U           
	LDA #$02               ; A = CurXY
	STA ,Y+               
	LDA 1,X               
	BEQ *+16
	CMPA #$FE             
	BNE *+6
	LDA 2,X               
	BEQ *+8
Sub_147D:      CMPA 144,U            
	BLS *+4
Sub_1483:      LDA #$01              
Sub_1485:      STA 3220,U            
	ADDA #$1F             
	STA ,Y+               
	LDA ,X                
	BEQ *+8
	CMPA 145,U            
	BLS *+4
Sub_1497:      LDA #$01              
Sub_1499:      STA 3221,U            
	ADDA #$1F             
	STA ,Y+               
	LDB 3209,U            
	ADDB #$03             
	STB 3209,U            
	PULS A,B,X            
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_14B0:      PSHS A,B,X            
	LEAX 3168,U           
	LDA ,X                
	CMPA 144,U            
	BCC *+5  ; C=0 (BHS)
	TSTA                  
	BNE *+4
Sub_14C1:      LDA #$01              
Sub_14C3:      ADDA 3220,U           
	CMPA 144,U            
	BLS *+6
	LDA 144,U             
Sub_14D1:      STA 3220,U            
Sub_14D5:      LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
	STB ,Y+               
	LDD 3220,U            
	ADDA #$1F             
	ADDB #$1F             
	STA ,Y+               
	STB ,Y+               
	LDB 3209,U            
	ADDB #$03             
	STB 3209,U            
	PULS A,B,X            
	LBRA Sub_0D0F         

; --------------------------------------------------------------
Sub_14F4:      PSHS A,B,X            
	LEAX 3168,U           
	LDA ,X                
	CMPA 144,U            
	BCC *+5  ; C=0 (BHS)
	TSTA                  
	BNE *+4
Sub_1505:      LDA #$01              
Sub_1507:      STA 3204,U            
	LDA 3220,U            
	SUBA 3204,U           
	BGT *+4
	LDA #$01              
Sub_1517:      STA 3220,U            
	BRA *-70

; --------------------------------------------------------------
Sub_151D:      PSHS A,B,X            
	LEAX 3168,U           
	LDA ,X                
	CMPA 145,U            
	BCC *+5  ; C=0 (BHS)
	TSTA                  
	BNE *+4
Sub_152E:      LDA #$01              
Sub_1530:      STA 3204,U            
	LDA 3221,U            
	SUBA 3204,U           
	BGT *+4
	LDA #$01              
Sub_1540:      STA 3221,U            
	BRA *-111

; --------------------------------------------------------------
Sub_1546:      PSHS A,B,X            
	LEAX 3168,U           
	LDA ,X                
	CMPA 145,U            
	BCC *+5  ; C=0 (BHS)
	TSTA                  
	BNE *+4
Sub_1557:      LDA #$01              
Sub_1559:      ADDA 3221,U           
	CMPA 145,U            
	BLS *+6
	LDA 145,U             
Sub_1567:      STA 3221,U            
	LBRA Sub_14D5         

; --------------------------------------------------------------
Sub_156E:      LDA #$00               ; A = NUL
	LDY #$0001            
	LEAX 1550,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
Sub_157B:      LDA #$00               ; A = NUL
	LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	STA 65,U              
	LDA 1550,U            
	CLR 1550,U            
	LDB 3238,U            
	CMPB #$02              ; compare B with CurXY
	LBEQ Sub_21F0         
Sub_1597:      CMPA #$1A              ; compare A with SUB
	BNE *+12
	LDB 65,U              
	ANDB #$10             
	BEQ *+5
	LBRA Sub_3580         

; --------------------------------------------------------------
Sub_15A5:      CMPA #$1C             
	BNE *+12
	LDB 65,U              
	ANDB #$08             
	BEQ *+5
	LBRA Sub_35DF         

; --------------------------------------------------------------
Sub_15B3:      CMPA #$F1             
	LBEQ Sub_1B0C         
	CMPA #$E8             
	LBEQ Sub_1983         
	CMPA #$AF             
	LBEQ Sub_110D         
	CMPA #$E1             
	LBEQ Sub_2EBF         
	CMPA #$E2             
	BNE *+5
	LBSR Sub_1D2F          ; call Sub_1D2F
Sub_15D2:      CMPA #$E9             
	BNE *+5
	LBRA Sub_175C         

; --------------------------------------------------------------
Sub_15D9:      CMPA #$F4             
	BNE *+5
	LBSR Sub_1E50          ; call Sub_1E50
Sub_15E0:      CMPA #$F5             
	BNE *+5
	LBSR Sub_2E83          ; call Sub_2E83
Sub_15E7:      CMPA #$E3             
	BNE *+5
	LBSR Sub_1EDC          ; call Sub_1EDC
Sub_15EE:      CMPA #$85             
	BNE *+5
	LBSR Sub_1D14          ; call Sub_1D14
Sub_15F5:      CMPA #$18             
	BNE *+6
	LDA #$7F              
	BRA *+94

; --------------------------------------------------------------
Sub_15FD:      CMPA #$F2             
	LBEQ Sub_16CB         
	CMPA #$F3             
	LBEQ Sub_16DC         
	CMPA #$8A             
	LBEQ Sub_3580         
	CMPA #$8C             
	LBEQ Sub_35DF         
	CMPA #$EF             
	BNE *+5
	LBSR Sub_1F1D          ; call Sub_1F1D
Sub_161C:      CMPA #$ED             
	BNE *+5
	LBSR Sub_2364          ; call Sub_2364
Sub_1623:      CMPA #$E4             
	BNE *+5
	LBSR Sub_22B1          ; call Sub_22B1
Sub_162A:      CMPA #$FA             
	BNE *+5
	LBSR Sub_2610          ; call Sub_2610
Sub_1631:      LDB 65,U              
	ANDB #$04             
	BEQ *+16
	CMPA #$B1             
	BCS *+31  ; C=1 (BLO)
	CMPA #$B8             
	BHI *+27
	LBSR Sub_1A21          ; call Sub_1A21
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_1646:      CMPA #$B1             
	LBEQ Sub_110D         
	CMPA #$18             
	BNE *+11
	LDB 65,U              
	ANDB #$20             
	BEQ *+4
	LDA #$7F              
Sub_1659:      CMPA #$AF             
	BHI *+109
	STA 1263,U            
	TST 3242,U            
	BEQ *+16
	LDA #$01              
	LDB #$98              
	LDX #$2801            
	LDY #$0900            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
Sub_1675:      LDY #$0001            
	LEAX 1263,U           
	LDA ,X                
	CMPA #$0D              ; compare A with CR
	BNE *+14
	TST 3241,U            
	BEQ *+8
	LDA #$0A               ; A = LF
	STA 1,X               
	LEAY 1,Y              
Sub_168F:      LDA 43,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	TST 1263,U            
	BMI *+47
	LDA 3239,U            
	BEQ *+41
	TST 3240,U            
	BEQ *+22
	LDA 1263,U            
	CMPA #$0D              ; compare A with CR
	BNE *+14
	LDA #$0A               ; A = LF
	STA 1264,U            
	LDY #$0002            
	BRA *+6

; --------------------------------------------------------------
Sub_16BB:      LDY #$0001            
Sub_16BF:      LEAX 1263,U           
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_16C8:      LBRA Sub_0C5E         
Sub_16CB:      PSHS A,X,Y            
	LEAX Dat_03D6,PCR       ; X → Dat_03D6
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_1C57          ; call Sub_1C57
	PULS A,X,Y            
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_16DC:      PSHS U                
	LBSR Sub_134D          ; call Sub_134D
	LDB #$13               ; B = XOFF
	LEAY Dat_03B2,PCR       ; Y → Dat_03B2
	LEAX 5033,U           
	LBSR Sub_2D26          ; call Sub_2D26
	LEAX 5033,U           
	LDA 144,U             
	STA 5,X               
	LDA 145,U             
	TST 64,U              
	BEQ *+4
	SUBA #$03             
Sub_1703:      STA 6,X               
	LDA 137,U             
	LDB 136,U             
	STD 7,X               
	LDA #$01              
	LDY #$0009            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAU Dat_02E5,PCR       ; U → Dat_02E5
	LEAX Dat_02E0,PCR       ; X → Dat_02E0
	CLRB                   ; B = 0
	LDA #$11               ; A = XON
	OS9 F$Fork             ; module→D:X  args→Y  size=D
	PULS U                
	BCS *+21  ; C=1 (BLO)
	STA 118,U             
Sub_172D:      LDX #$0001            
	LBSR Sub_0F56          ; call Sub_0F56
	OS9 F$Wait             ; → wait for child; status→D
	BCS *+7  ; C=1 (BLO)
	CMPA 118,U            
	BNE *-14
Sub_173D:      LDA #$01              
	LEAX Dat_03C6,PCR       ; X → Dat_03C6
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_12B5          ; call Sub_12B5
	LBRA Sub_0C5E         

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
Sub_175C:      TST 114,U             
	BEQ *+13
	LDA 117,U             
	BEQ *+11
	CLR 117,U             
	LBSR Sub_0F20          ; call Sub_0F20
Sub_176C:      LBRA Sub_0C5E         
Sub_176F:      INC 117,U             
	LEAX Dat_0366,PCR       ; X → Dat_0366
	LEAY 119,U            
	LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
	LEAX 119,U            
	LDY #$000B            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 115,U             
	STA 116,U             
	BRA *-37

; --------------------------------------------------------------
Sub_1793:      LDD #$0802            
	STD 3215,U            
	LDD #$400A            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_02F0,PCR       ; X → Dat_02F0
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LEAX 5033,U           
	LDA #$01              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LEAX 5033,U           
	LDA #$01              
	STA 5,X               
	CLR 7,X               
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDA #$00               ; A = NUL
	OS9 I$Dup              ; path=A  → new path→A
	STA 110,U             
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA 43,U              
	OS9 I$Dup              ; path=A  → new path→A
	LEAU Dat_02E9,PCR       ; U → Dat_02E9
	LEAX Dat_02E6,PCR       ; X → Dat_02E6
	LDY #$000A            
	CLRB                   ; B = 0
	LDA #$11               ; A = XON
	OS9 F$Fork             ; module→D:X  args→Y  size=D
	LDU #$0000            
	PSHS CC               
	STA 118,U             
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA 110,U             
	OS9 I$Dup              ; path=A  → new path→A
	LDA 110,U             
	OS9 I$Close            ; path=A
	PULS CC               
	BCS *+58  ; C=1 (BLO)
Sub_180E:      LDX #$0001            
	LBSR Sub_0F56          ; call Sub_0F56
	LDA #$00               ; A = NUL
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+27  ; C=1 (BLO)
	CLRA                   ; A = 0
	CMPB #$00              ; compare B with NUL
	BEQ *+22
	TFR D,Y               
	LEAX 5033,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDA 5033,U            
	CMPA #$05             
	BNE *+5
	LBSR Sub_197B          ; call Sub_197B
Sub_1836:      OS9 F$Wait             ; → wait for child; status→D
	BCS *+13  ; C=1 (BLO)
	CMPA 118,U            
	BNE *-48
	TSTB                  
	BEQ *+5
	LBSR Sub_2AC5          ; call Sub_2AC5
Sub_1846:      LBSR Sub_1CDE          ; call Sub_1CDE
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_12B5          ; call Sub_12B5
	LBSR Sub_1BAD          ; call Sub_1BAD
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_1859:      LDD #$0802            
	STD 3215,U            
	LDD #$400A            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_0322,PCR       ; X → Dat_0322
	LBSR WriteBlock        ; call WriteBlock
	LEAY 1805,U           
	STY 72,U              
	LDA #$2D               ; A = '-'
	STA ,Y+               
	LDA #$76               ; A = 'v'
	STA ,Y+               
	STA ,Y+               
	LDA #$20               ; A = ' '
	STA ,Y+               
Sub_1887:      LEAX Dat_055F,PCR       ; X → Dat_055F
	PSHS Y                
	LBSR WriteBlock        ; call WriteBlock
	PULS Y                
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_1B61          ; call Sub_1B61
	TST 33,U              
	LBNE Sub_1968         
	LEAX 1550,U           
	LDB 29,U              
	CMPB #$01             
	BEQ *+15
Sub_18A9:      LDA ,X+               
	STA ,Y+               
	DECB                  
	BNE *-5
	LDA #$20               ; A = ' '
	STA -1,Y              
	BRA *-45

; --------------------------------------------------------------
Sub_18B6:      LDA #$0D               ; A = CR
	STA ,Y+               
	TFR Y,D               
	SUBD 72,U             
	STD 72,U              
	CMPD #$0007           
	LBCS Sub_1968         
	LBSR Sub_1EDC          ; call Sub_1EDC
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LEAX 5033,U           
	LDA #$01              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDA #$01              
	LEAX 5033,U           
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	STA 5,X               
	CLR 7,X               
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDA #$00               ; A = NUL
	OS9 I$Dup              ; path=A  → new path→A
	STA 110,U             
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA 43,U              
	OS9 I$Dup              ; path=A  → new path→A
	LDY 72,U              
	LEAU 1805,U           
	LEAX Dat_031F,PCR       ; X → Dat_031F
	CLRB                   ; B = 0
	LDA #$11               ; A = XON
	OS9 F$Fork             ; module→D:X  args→Y  size=D
	LDU #$0000            
	PSHS CC               
	STA 118,U             
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA 110,U             
	OS9 I$Dup              ; path=A  → new path→A
	LDA 110,U             
	OS9 I$Close            ; path=A
	PULS CC               
	BCS *+58  ; C=1 (BLO)
Sub_1930:      LDX #$0001            
	LBSR Sub_0F56          ; call Sub_0F56
	LDA #$00               ; A = NUL
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+27  ; C=1 (BLO)
	CLRA                   ; A = 0
	CMPB #$00              ; compare B with NUL
	BEQ *+22
	TFR D,Y               
	LEAX 5033,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDA 5033,U            
	CMPA #$05             
	BNE *+5
	LBSR Sub_197B          ; call Sub_197B
Sub_1958:      OS9 F$Wait             ; → wait for child; status→D
	BCS *+13  ; C=1 (BLO)
	CMPA 118,U            
	BNE *-48
	TSTB                  
	BEQ *+5
	LBSR Sub_2AC5          ; call Sub_2AC5
Sub_1968:      LBSR Sub_1CDE          ; call Sub_1CDE
	LBSR Sub_12B5          ; call Sub_12B5
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_1BAD          ; call Sub_1BAD
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_197B:      LDA 118,U             
	CLRB                   ; B = 0
	OS9 F$Send             ; pid=A  signal=B
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1983:      TST 114,U             
	BEQ *+8
	CLR 117,U             
	LBSR Sub_0F20          ; call Sub_0F20
Sub_198E:      LDD #$2105            
	STD 3215,U            
	LDD #$0E03            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_0349,PCR       ; X → Dat_0349
	LBSR WriteBlock        ; call WriteBlock
	TST 3243,U            
	BNE *+49
	TST 26,U              
	BEQ *+18
	LDA 43,U              
	LDB #$2B               ; B = SS.CtlSg  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDX #$003C            
	LBSR Sub_0F56          ; call Sub_0F56
	BRA *+70

; --------------------------------------------------------------
Sub_19C8:      LDX 17,U              
	LDB 2,X               
	ANDB #$FE             
	STB 2,X               
	LDX #$003C            
	LBSR Sub_0F56          ; call Sub_0F56
	LDX 17,U              
	LDB 2,X               
	ORB #$01              
	STB 2,X               
	BRA *+44

; --------------------------------------------------------------
Sub_19E2:      LDA 43,U              
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
Sub_19E7:      LEAX Dat_0981,PCR       ; X → Dat_0981
Insn_19EB:     LDY #$0001            
Sub_19EC:      EQU    $19EC            ; mid-instruction overlap: Insn_19EB+1 -- mid-instruction entry point -- byte 2 of LDY #$0001 ($10 8E 00 01) at $19EB; BSR from $1A02 executes LDX #$0001 then falls to OS9 I$Write
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$000C            
	LBSR Sub_0F56          ; call Sub_0F56
	DECB                  
	BNE *-18
	LDX #$0080            
	LBSR Sub_0F56          ; call Sub_0F56
	LEAX Dat_02DC,PCR       ; X → Dat_02DC
	LDY #$0004            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_1A0C:      LBSR Sub_1CDE          ; call Sub_1CDE
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_1A19:      PSHS A,B,X,Y          
	LEAX 4892,U           
	BRA *+15

; --------------------------------------------------------------
Sub_1A21:      PSHS A,B,X,Y          
	SUBA #$B1             
	LDB #$80              
	MUL                    ; D = A×B unsigned
	LEAX 3356,U           
	LEAX D,X              
Sub_1A2E:      PSHS X                
	CLRB                   ; B = 0
Sub_1A31:      LDA ,X+               
	INCB                  
	CMPB #$80             
	BHI *+6
	CMPA #$0D              ; compare A with CR
	BNE *-9
Sub_1A3C:      DECB                  
	CLRA                   ; A = 0
	PULS X                
	TSTB                  
	BEQ *+14
Sub_1A43:      LDA ,X+               
	DECB                  
	CMPA #$5C              ; compare A with '\'
	BEQ *+21
	BSR *+44  ; call Sub_1A76
Sub_1A4C:      TSTB                  
	BNE *-10
Sub_1A4F:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_1A51:      PSHS X                
	LDX #$001E            
	LBSR Sub_0F56          ; call Sub_0F56
	PULS X                
	BRA *-15

; --------------------------------------------------------------
Sub_1A5D:      LDA ,X+               
	DECB                  
	CMPA #$5E              ; compare A with '^'
	BEQ *+16
	CMPA #$2A              ; compare A with '*'
	BEQ *-21
	CMPA #$5C              ; compare A with '\'
	BEQ *+4
	SUBA #$40             
Sub_1A6E:      BSR *+8  ; call Sub_1A76
	BRA *-36

; --------------------------------------------------------------
Sub_1A72:      LDA #$1B               ; A = ESC
	BRA *-6

; --------------------------------------------------------------
Sub_1A76:      PSHS A,X,Y            
	LEAX 5033,U           
	STA ,X                
	LDY #$0001            
	LDA 43,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1A8A:      PSHS A,X,Y            
	LDD #$1B24             ; D=ESC+'$'  → W.DWEnd: Device Window End
	STD 5033,U            
	LDA #$01              
	LDY #$0002            
	LEAX 5033,U           
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAY Dat_0469,PCR       ; Y → Dat_0469
	LEAX 5033,U           
	LDB #$0C               ; B = FF
	LBSR Sub_2D26          ; call Sub_2D26
	LEAX 5033,U           
	LEAX 2,X              
	LDA #$1E              
Sub_1AB5:      STA 3204,U            
	STA 6,X               
	STA 145,U             
	LDY #$000A            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	BCS *+16  ; C=1 (BLO)
	LDA 5,X               
	STA 144,U             
	LDA 6,X               
	STA 145,U             
Sub_1AD6:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1AD8:      LDA 3204,U            
	DECA                  
	CMPA #$0A              ; compare A with LF
	BHI *+7
	COMB                  
	LDB #$C3              
	BRA *-14

; --------------------------------------------------------------
Sub_1AE6:      BRA *-49
Sub_1AE8:      LEAX Dat_0467,PCR       ; X → Dat_0467
	LDA #$02               ; A = CurXY
	OS9 I$Open             ; mode=B  name→X  → path→A
	STA 62,U              
	LEAX Dat_0477,PCR       ; X → Dat_0477
	LDY #$000A            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	RTS                    ; return from subroutine
; WriteBlock — write count-prefixed block to STDOUT (path=1)
;   LEAX  DataLabel,PC    ; X → FDB count / data payload
;   LBSR  WriteBlock      ; LDY [X]++  OS9 I$Write  path=STDOUT
; 106 callers use this entry.

; --------------------------------------------------------------
; WriteBlock — write count-prefixed block to STDOUT (path=1)
;   LEAX  DataLabel,PC    ; X → FDB count / data payload
;   LBSR  WriteBlock      ; LDY [X]++  OS9 I$Write  path=STDOUT
; 106 callers use this entry.
WriteBlock:    LDA #$01              
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
WriteBlockPath: LDY ,X++              
	OS9 I$Write            ; path=A  count=Y  buf→X
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1B0C:      BSR *+17  ; call Sub_1B1D
	CMPA #$79              ; compare A with 'y'
	LBEQ Sub_0EEF         
	CMPA #$59              ; compare A with 'Y'
	LBEQ Sub_0EEF         
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_1B1D:      PSHS Y                
	LDD #$1D04            
	STD 3215,U            
	LDD #$1603            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_0499,PCR       ; X → Dat_0499
	BSR *-49  ; call WriteBlock
	LEAX Dat_048F,PCR       ; X → Dat_048F
	BSR *-55  ; call WriteBlock
	LBSR Sub_2ABC          ; call Sub_2ABC
	PSHS A                
	LEAX Dat_048B,PCR       ; X → Dat_048B
	BSR *-66  ; call WriteBlock
	LBSR Sub_1CDE          ; call Sub_1CDE
	PULS A                
	PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1B4E:      PSHS B,X              
	LEAX 3225,U           
	OS9 F$Time             ; buf→X  → 6-byte time
	LDA 5,X               
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1B61:      PSHS A,B,X,Y          
	CLR 28,U              
	CLR 29,U              
	CLR 33,U              
	LEAX 1550,U           
Sub_1B70:      LBSR Sub_2ABC          ; call Sub_2ABC
	CMPA #$2D              ; compare A with '-'
	BLS *+16
	TSTB                  
	BEQ *-8
	STA ,X+               
	DECB                  
	INC 29,U              
	LBSR Sub_1F0B          ; call Sub_1F0B
	BRA *-19

; --------------------------------------------------------------
Sub_1B85:      CMPA #$08              ; compare A with BS
	BNE *+18
	TST 29,U              
	BEQ *-28
	INCB                  
	DEC 29,U              
	LEAX -1,X             
	LBSR Sub_1F0B          ; call Sub_1F0B
	BRA *-39

; --------------------------------------------------------------
Sub_1B99:      CMPA #$05             
	BNE *+7
	INC 33,U              
	BRA *+11

; --------------------------------------------------------------
Sub_1BA2:      CMPA #$0D              ; compare A with CR
	BNE *-52
	STA ,X                
	INC 29,U              
Sub_1BAB:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_1BAD:      LDA #$00               ; A = NUL
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+3  ; C=0 (BHS)
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1BB7:      TSTB                  
	BEQ *+14
	CLRA                   ; A = 0
	TFR D,Y               
	LEAX 5033,U           
	LDA #$00               ; A = NUL
	OS9 I$Read             ; path=A  count=Y  buf→X
Sub_1BC6:      RTS                    ; return from subroutine
Sub_1BC7:      PSHS A,B,X            
	LDB #$08               ; B = BS
	LEAX 3356,U           
	LDA #$0D               ; A = CR
Sub_1BD1:      STA ,X                
	STA 1,X               
	LEAX 128,X            
	DECB                  
	BNE *-9
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1BDE:      RTS                    ; return from subroutine
Sub_1BDF:      LDA BSS.BufPtr3,U     
	CMPA #$02              ; compare A with CurXY
	BNE *+8
	LEAY Dat_0371,PCR       ; Y → Dat_0371
	BRA *+44

; --------------------------------------------------------------
Sub_1BEC:      TST 3238,U            
	BNE *+34
	LEAY Dat_0391,PCR       ; Y → Dat_0391
	LDD #$0601            
	STD 133,U             
	LDD #$0002            
	STD 135,U             
	LDD #$0704            
	STD <$89              
	LDD #$0305            
	STD 139,U             
	BRA *+32

; --------------------------------------------------------------
Sub_1C12:      LEAY Dat_0381,PCR       ; Y → Dat_0381
Sub_1C16:      LDD #$0504            
	STD 133,U             
	LDD #$0700            
	STD <$87              
	LDD #$0601            
	STD 137,U             
	LDD #$0203            
	STD 139,U             
Sub_1C30:      LEAX 5033,U           
	LDD #$1B31             ; D=ESC+$31
	STD ,X                
	CLRA                   ; A = 0
Sub_1C3A:      LDB A,Y               
	PSHS A,Y              
	STD 2,X               
	LDY #$0004            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,Y              
	INCA                  
	CMPA #$10             
	BCS *-20  ; C=1 (BLO)
	LBSR Sub_2C18          ; call Sub_2C18
	LBSR Sub_2B86          ; call Sub_2B86
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1C57:      PSHS A,X              
	LDA BSS.BufPtr3,U     
	CMPA #$02              ; compare A with CurXY
	BEQ *+14
	TST 3238,U            
	BNE *+8
	LEAX Dat_03A4,PCR       ; X → Dat_03A4
	BRA *+6

; --------------------------------------------------------------
Sub_1C6C:      LEAX Dat_03A1,PCR       ; X → Dat_03A1
Sub_1C70:      LDA ,X                
	LBSR Sub_2347          ; call Sub_2347
	LDA 1,X               
	LBSR Sub_233B          ; call Sub_233B
	LDA 2,X               
	LBSR Sub_2341          ; call Sub_2341
	PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1C81:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
	STD ,X                
	LDA #$01              
	STA 2,X               
	LDD 3215,U            
	ADDA #$01             
	ADDB #$01             
	STD 3,X               
	LDD 3217,U            
	STD 5,X               
	LDB 133,U             
	CLRA                   ; A = 0
	STD 7,X               
	LDA #$01              
	LDY #$0009            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
	STD ,X                
	LDA #$01              
	STA 2,X               
	LDD 3215,U            
	STD 3,X               
	LDD 3217,U            
	STD 5,X               
	LDA 135,U             
	LDB 134,U             
	STD 7,X               
	LDA #$0C               ; A = FF
	STA 9,X               
	LDA #$01              
	LDY #$000A            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1CDE:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDD #$1B23             ; D=ESC+'#'  → W.OWEnd: Overlay Window End
	STD ,X                
	LDA #$01              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1CF7:      PSHS A,B,X,Y          
	LDX #$1003            
	LDY #$0EA0            
Sub_1D00:      LDA #$01              
	LDB #$98              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1D09:      PSHS A,B,X,Y          
	LDX #$3F03            
	LDY #$0FD1            
	BRA *-18

; --------------------------------------------------------------
Sub_1D14:      PSHS A,B,X            
	LDB #$1D              
	LDA 43,U              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	BCC *+15  ; C=0 (BHS)
	LDX 17,U              
	LDA 2,X               
	ORA #$0C              
	STA 2,X               
	ANDA <$F3             
	STA 2,X               
Sub_1D2D:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1D2F:      PSHS A,B,X,Y          
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDD #$1E03            
	STD 3215,U            
	LDD #$1203            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_063D,PCR       ; X → Dat_063D
	LBSR WriteBlock        ; call WriteBlock
	LDB 3237,U            
	ANDB #$07             
Sub_1D56:      STB 3204,U            
	LEAX Dat_03CA,PCR       ; X → Dat_03CA
	LDY #$0005            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_0652,PCR       ; X → Dat_0652
	LDA #$05              
	LDB 3204,U            
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	LDA #$01              
	LDY #$0005            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_1D7D:      LBSR Sub_2ABC          ; call Sub_2ABC
	CMPA #$0D              ; compare A with CR
	BEQ *+25
	CMPA #$05             
	BEQ *+21
	CMPA #$20              ; compare A with ' '
	BNE *-13
	INC 3204,U            
	LDB 3204,U            
	CMPB #$08              ; compare B with BS
	BNE *-64
	CLRB                   ; B = 0
	BRA *-67

; --------------------------------------------------------------
Sub_1D9B:      LDB 3237,U            
	ANDB #$F8             
	ORB 3204,U            
	STB 3237,U            
	LBSR Sub_1CDE          ; call Sub_1CDE
	LBSR Sub_118F          ; call Sub_118F
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1DB8:      PSHS A,X,Y            
	CLR 153,U             
	STB 3204,U            
	LEAX 5033,U           
	LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
	STD ,X                
	LDD #$0102            
	STD 2,X               
	LDA #$04              
	LDB 5022,U            
	INCB                  
	STD 4,X               
	LDA #$01              
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB 3204,U            
Sub_1DE6:      CLRA                   ; A = 0
	INCB                  
	TFR D,Y               
	LEAX Dat_0688,PCR       ; X → Dat_0688
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_0693,PCR       ; X → Dat_0693
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_1DFE:      LBSR Sub_2AC5          ; call Sub_2AC5
	ANDA #$7F             
	CMPA #$0A              ; compare A with LF
	BEQ *+20
	CMPA #$0C              ; compare A with FF
	BEQ *+34
	CMPA #$20              ; compare A with ' '
	BEQ *+44
	CMPA #$05             
	BEQ *+46
	CMPA #$0D              ; compare A with CR
	BEQ *+53
	BRA *-25

; --------------------------------------------------------------
Sub_1E19:      LDB 3204,U            
	INCB                  
	CMPB 5022,U           
	BCS *+3  ; C=1 (BLO)
	CLRB                   ; B = 0
Sub_1E25:      STB 3204,U            
	BRA *-67

; --------------------------------------------------------------
Sub_1E2B:      LDB 3204,U            
	DECB                  
	BPL *+7
	LDB 5022,U            
	DECB                  
Sub_1E37:      BRA *-18
Sub_1E39:      LDB 3204,U            
Sub_1E3D:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1E3F:      LDB 5022,U            
	INCB                  
	STB 3204,U            
	BRA *-11

; --------------------------------------------------------------
Sub_1E4A:      INC 153,U             
	BRA *-21

; --------------------------------------------------------------
Sub_1E50:      PSHS A,B,X,Y          
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDD #$1C03            
	STD 3215,U            
	LDD #$1703            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_0696,PCR       ; X → Dat_0696
	LBSR WriteBlock        ; call WriteBlock
	LDB 3238,U            
Sub_1E75:      STB 3204,U            
	LEAX Dat_03CA,PCR       ; X → Dat_03CA
	LDA #$01              
	LDY #$0005            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_06B0,PCR       ; X → Dat_06B0
	LDA #$05              
	LDB 3204,U            
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	LDY #$0005            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_1E9C:      LBSR Sub_2ABC          ; call Sub_2ABC
	CMPA #$0D              ; compare A with CR
	BEQ *+25
	CMPA #$05             
	BEQ *+21
	CMPA #$20              ; compare A with ' '
	BNE *-13
	INC 3204,U            
	LDB 3204,U            
	CMPB #$03             
	BNE *-64
	CLRB                   ; B = 0
	BRA *-67

; --------------------------------------------------------------
Sub_1EBA:      LDB 3204,U            
	STB 3238,U            
	LBSR Sub_1BDF          ; call Sub_1BDF
	LBSR Sub_1CDE          ; call Sub_1CDE
	LBSR Sub_1C57          ; call Sub_1C57
	BSR *+17  ; call Sub_1EDC
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	NEGA                  
	BEQ *+4
	BSR *+20  ; call Sub_1EE5
Sub_1ED3:      LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1EDC:      PSHS A                
	LDA #$0C               ; A = FF
	LBSR Sub_1F0B          ; call Sub_1F0B
	PULS A,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1EE5:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
	STD ,X                
	LDD #$0000            
	STD 2,X               
	LDD #$5003            
	STD 4,X               
	LDA #$01              
	STA 6,X               
	LDY #$0007            
	LDA 63,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_268D         

; --------------------------------------------------------------
Sub_1F0B:      PSHS A,B,X,Y          
	LEAX 27,U             
	STA ,X                
	LDY #$0001            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1F1D:      PSHS A,B,X,Y          
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDD #$1F03            
	STD 3215,U            
	LDD #$160E            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_0821,PCR       ; X → Dat_0821
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_20DB          ; call Sub_20DB
	LBSR Sub_2108          ; call Sub_2108
	LBSR Sub_2118          ; call Sub_2118
	LBSR Sub_20F8          ; call Sub_20F8
	LBSR Sub_21D5          ; call Sub_21D5
	LBSR Sub_2174          ; call Sub_2174
	LBSR Sub_21B9          ; call Sub_21B9
	LBSR Sub_2128          ; call Sub_2128
	LBSR Sub_2138          ; call Sub_2138
	LBSR Sub_2148          ; call Sub_2148
	LBSR Sub_2158          ; call Sub_2158
	LDA #$0B              
	STA 5022,U            
	CLRB                   ; B = 0
Sub_1F66:      LBSR Sub_1DB8          ; call Sub_1DB8
	LEAX 5033,U           
	LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
	STD ,X                
	LDD #$0000            
	STD 2,X               
	LDD #$160E            
	STD 4,X               
	LDY #$0006            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	TST 153,U             
	LBNE Sub_20CF         
	LDB 3204,U            
	CMPB #$0A              ; compare B with LF
	LBHI Sub_20CF         
	CMPB #$00              ; compare B with NUL
	BNE *+18
	LDA 3239,U            
	BNE *+8
	INC 3239,U            
	BRA *+6

; --------------------------------------------------------------
Sub_1FA7:      CLR 3239,U            
Sub_1FAB:      LBSR Sub_20DB          ; call Sub_20DB
	CMPB #$03             
	BNE *+18
	LDA 3242,U            
	BNE *+8
	INC 3242,U            
	BRA *+6

; --------------------------------------------------------------
Sub_1FBE:      CLR 3242,U            
Sub_1FC2:      LBSR Sub_20F8          ; call Sub_20F8
	CMPB #$07             
	BNE *+18
	LDA 3249,U            
	BNE *+8
	INC 3249,U            
	BRA *+6

; --------------------------------------------------------------
Sub_1FD5:      CLR 3249,U            
Sub_1FD9:      LBSR Sub_2128          ; call Sub_2128
	LBSR Sub_118F          ; call Sub_118F
	CMPB #$05             
	BNE *+43
	LDA 3244,U            
	ANDA #$E0             
	CMPA #$00              ; compare A with NUL
	BEQ *+38
	CMPA #$E0             
	BEQ *+38
	ADDA #$40             
Sub_1FF3:      PSHS B                
	LDB 3244,U            
	ANDB #$1F             
	STB 3244,U            
	PULS B                
	ORA 3244,U            
	STA 3244,U            
	LBSR Sub_118F          ; call Sub_118F
Sub_200C:      LBSR Sub_2174          ; call Sub_2174
	BRA *+9

; --------------------------------------------------------------
Sub_2011:      ADDA #$20             
	BRA *-32

; --------------------------------------------------------------
Sub_2015:      CLRA                   ; A = 0
	BRA *-35

; --------------------------------------------------------------
Sub_2018:      CMPB #$06             
	BNE *+24
	LDA 3237,U            
	BPL *+6
	ANDA #$7F             
	BRA *+4

; --------------------------------------------------------------
Sub_2026:      ORA #$80              
Sub_2028:      STA 3237,U            
	LBSR Sub_118F          ; call Sub_118F
	LBSR Sub_21B9          ; call Sub_21B9
Sub_2032:      CMPB #$04             
	BNE *+26
	LDA 3237,U            
	BITA #$20             
	BEQ *+6
	ANDA #$DF             
	BRA *+4

; --------------------------------------------------------------
Sub_2042:      ORA #$20              
Sub_2044:      STA 3237,U            
	LBSR Sub_118F          ; call Sub_118F
	LBSR Sub_21D5          ; call Sub_21D5
Sub_204E:      CMPB #$01             
	BNE *+18
	LDA 3240,U            
	BNE *+8
	INC 3240,U            
	BRA *+6

; --------------------------------------------------------------
Sub_205E:      CLR 3240,U            
Sub_2062:      LBSR Sub_2108          ; call Sub_2108
	CMPB #$02              ; compare B with CurXY
	BNE *+21
	LDA 3241,U            
	BNE *+8
	INC 3241,U            
	BRA *+9

; --------------------------------------------------------------
Sub_2075:      CLR 3241,U            
	LBSR Sub_118F          ; call Sub_118F
Sub_207C:      LBSR Sub_2118          ; call Sub_2118
	CMPB #$08              ; compare B with BS
	BNE *+18
	TST 3243,U            
	BNE *+8
	INC 3243,U            
	BRA *+6

; --------------------------------------------------------------
Sub_208F:      CLR 3243,U            
Sub_2093:      LBSR Sub_2158          ; call Sub_2158
	CMPB #$09             
	BNE *+18
	TST 3246,U            
	BNE *+8
	INC 3246,U            
	BRA *+6

; --------------------------------------------------------------
Sub_20A6:      CLR 3246,U            
Sub_20AA:      LBSR Sub_2148          ; call Sub_2148
	CMPB #$0A              ; compare B with LF
	BNE *+18
	TST 3245,U            
	BNE *+8
	INC 3245,U            
	BRA *+6

; --------------------------------------------------------------
Sub_20BD:      CLR 3245,U            
Sub_20C1:      LBSR Sub_2138          ; call Sub_2138
	CMPB #$0A              ; compare B with LF
	BHI *+9
	LDB 3204,U            
	LBRA Sub_1F66         

; --------------------------------------------------------------
Sub_20CF:      LBSR Sub_1CDE          ; call Sub_1CDE
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_20DB:      PSHS A,B,X            
	LDD #$1102            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3239,U            
	BNE *+11
Sub_20E9:      LEAX Dat_0985,PCR       ; X → Dat_0985
Sub_20ED:      LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_20F2:      LEAX Dat_098B,PCR       ; X → Dat_098B
	BRA *-9

; --------------------------------------------------------------
Sub_20F8:      PSHS A,B,X            
	LDD #$1105            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3242,U            
	BNE *-18
	BRA *-29

; --------------------------------------------------------------
Sub_2108:      PSHS A,B,X            
	LDD #$1103            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3240,U            
	BNE *-34
	BRA *-45

; --------------------------------------------------------------
Sub_2118:      PSHS A,B,X            
	LDD #$1104            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3241,U            
	BNE *-50
	BRA *-61

; --------------------------------------------------------------
Sub_2128:      PSHS A,B,X            
	LDD #$1109            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3249,U            
	BNE *-66
	BRA *-77

; --------------------------------------------------------------
Sub_2138:      PSHS A,B,X            
	LDD #$110C            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3245,U            
	BNE *-82
	BRA *-93

; --------------------------------------------------------------
Sub_2148:      PSHS A,B,X            
	LDD #$110B            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3246,U            
	BEQ *-98
	BRA *-109

; --------------------------------------------------------------
Sub_2158:      PSHS A,B,X            
	LDD #$110A            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3243,U            
	BNE *+9
	LEAX Dat_0979,PCR       ; X → Dat_0979
	LBRA Sub_20ED         

; --------------------------------------------------------------
Sub_216D:      LEAX Dat_097F,PCR       ; X → Dat_097F
	LBRA Sub_20ED         

; --------------------------------------------------------------
Sub_2174:      PSHS A,B,X,Y          
	LDD #$1007            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3244,U            
	ANDA #$E0             
	CMPA #$A0             
	BNE *+8
	LEAX Dat_0990,PCR       ; X → Dat_0990
	BRA *+36

; --------------------------------------------------------------
Sub_218C:      CMPA #$E0             
	BNE *+8
	LEAX Dat_0995,PCR       ; X → Dat_0995
	BRA *+26

; --------------------------------------------------------------
Sub_2196:      CMPA #$60              ; compare A with '`'
	BNE *+8
	LEAX Dat_099A,PCR       ; X → Dat_099A
	BRA *+16

; --------------------------------------------------------------
Sub_21A0:      CMPA #$20              ; compare A with ' '
	BNE *+8
	LEAX Dat_099F,PCR       ; X → Dat_099F
	BRA *+6

; --------------------------------------------------------------
Sub_21AA:      LEAX Dat_09A4,PCR       ; X → Dat_09A4
Sub_21AE:      LDA #$01              
	LDY #$0005            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_21B9:      PSHS A,B,X            
	LDD #$1208            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3237,U            
	BPL *+9
	LDA #$32               ; A = '2'
	LBSR Sub_1F0B          ; call Sub_1F0B
	BRA *+7

; --------------------------------------------------------------
Sub_21CE:      LDA #$31               ; A = '1'
	LBSR Sub_1F0B          ; call Sub_1F0B
Sub_21D3:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_21D5:      PSHS A,B,X            
	LDD #$1206            
	LBSR Sub_2294          ; call Sub_2294
	LDA 3237,U            
	BITA #$20             
	BNE *+6
	LDA #$38               ; A = '8'
	BRA *+4

; --------------------------------------------------------------
Sub_21E9:      LDA #$37               ; A = '7'
Sub_21EB:      LBSR Sub_1F0B          ; call Sub_1F0B
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_21F0:      CMPA #$8C             
	BNE *+6
	LDA #$41               ; A = 'A'
	BRA *+67

; --------------------------------------------------------------
Sub_21F8:      CMPA #$8A             
	BNE *+6
	LDA #$42               ; A = 'B'
	BRA *+59

; --------------------------------------------------------------
Sub_2200:      CMPA #$88             
	BNE *+6
	LDA #$44               ; A = 'D'
	BRA *+51

; --------------------------------------------------------------
Sub_2208:      CMPA #$89             
	BNE *+6
	LDA #$43               ; A = 'C'
	BRA *+43

; --------------------------------------------------------------
Sub_2210:      LDB 65,U              
	BITB #$78             
	LBEQ Sub_1597         
	CMPA #$13              ; compare A with XOFF
	BNE *+6
	LDA #$48               ; A = 'H'
	BRA *+26

; --------------------------------------------------------------
Sub_2221:      CMPA #$12             
	BNE *+6
	LDA #$4B               ; A = 'K'
	BRA *+18

; --------------------------------------------------------------
Sub_2229:      CMPA #$10             
	BNE *+6
	LDA #$50               ; A = 'P'
	BRA *+10

; --------------------------------------------------------------
Sub_2231:      CMPA #$11              ; compare A with XON
	LBNE Sub_1597         
	LDA #$40               ; A = '@'
Sub_2239:      LEAX 1263,U           
	STA 2,X               
	PSHS A                
	LDD #$1B5B             ; D=ESC+$5B
	STD ,X                
	LDA 43,U              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A                
	TST 3239,U            
	LBEQ Sub_0C5E         
	CMPA #$41              ; compare A with 'A'
	BNE *+6
	LDA #$09              
	BRA *+34

; --------------------------------------------------------------
Sub_2262:      CMPA #$42              ; compare A with 'B'
	BNE *+6
	LDA #$0A               ; A = LF
	BRA *+26

; --------------------------------------------------------------
Sub_226A:      CMPA #$43              ; compare A with 'C'
	BNE *+6
	LDA #$06              
	BRA *+18

; --------------------------------------------------------------
Sub_2272:      CMPA #$44              ; compare A with 'D'
	BNE *+6
	LDA #$08               ; A = BS
	BRA *+10

; --------------------------------------------------------------
Sub_227A:      CMPA #$48              ; compare A with 'H'
	LBNE Sub_0C5E         
	LDA #$01              
Sub_2282:      LEAX 1263,U           
	STA ,X                
	LDA #$01              
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_2294:      PSHS A,B,X,Y          
	LEAX 149,U            
	ADDA #$20             
	STA 1,X               
	ADDB #$20             
	STB 2,X               
	LDA #$02               ; A = CurXY
	STA ,X                
	LDA #$01              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_22B1:      PSHS A,B,X,Y          
	LDD #$1504            
	STD 3215,U            
	LDD #$2507            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_051C,PCR       ; X → Dat_051C
	LBSR WriteBlock        ; call WriteBlock
	LDD #$0102            
	BSR *-58  ; call Sub_2294
	LDA #$01              
	LEAX 3282,U           
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LDB #$1F              
	LEAX Dat_09A9,PCR       ; X → Dat_09A9
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_1B61          ; call Sub_1B61
	TST 33,U              
	BNE *+34
	LDA 1550,U            
	CMPA #$0D              ; compare A with CR
	BEQ *+26
	LDA #$03              
	LEAX 1550,U           
	OS9 I$ChgDir           ; mode=B  name→X
	BCS *+20  ; C=1 (BLO)
	LEAX 1550,U           
	LEAY 3282,U           
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
Sub_230E:      LBSR Sub_1CDE          ; call Sub_1CDE
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2313:      LDA #$07              
	LBSR Sub_1F0B          ; call Sub_1F0B
	PSHS B                
	LDD #$0D02            
	LBSR Sub_2294          ; call Sub_2294
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	PULS B                
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_0F56          ; call Sub_0F56
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	BRA *-43

; --------------------------------------------------------------
Sub_233B:      PSHS A,B,X,Y          
	LDB #$33               ; B = '3'
	BRA *+12

; --------------------------------------------------------------
Sub_2341:      PSHS A,B,X,Y          
	LDB #$34               ; B = '4'
	BRA *+6

; --------------------------------------------------------------
Sub_2347:      PSHS A,B,X,Y          
	LDB #$32               ; B = '2'
Sub_234B:      LEAX 5033,U           
	STA 2,X               
	LDA #$1B               ; A = ESC
	STD ,X                
	LDA #$01              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2360:      BRA *+30
Sub_2362:      BRA *+28
Sub_2364:      PSHS A,B              
	TST 38,U              
	BEQ *+9
	CLR 38,U              
	BSR *-12  ; call Sub_2362
Sub_2370:      PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)
Sub_2372:      TST 37,U              
	BEQ *-5
	INC 38,U              
	BSR *-26  ; call Sub_2360
	BRA *-12

; --------------------------------------------------------------
Sub_237E:      PSHS A,B,X,Y          
	TST 38,U              
	BNE *+39
	LEAY Dat_096D,PCR       ; Y → Dat_096D
	LEAX 5033,U           
	PSHS X                
	LDB #$0C               ; B = FF
	LBSR Sub_2D26          ; call Sub_2D26
	PULS X                
	LDA 136,U             
	STA 7,X               
	LDA 135,U             
	STA 11,X              
	LDA 62,U              
	LBSR WriteBlockPath    ; call WriteBlockPath
Sub_23A8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_23AA:      LEAY Dat_0960,PCR       ; Y → Dat_0960
	LEAX 5033,U           
	PSHS X                
	LDB #$0D               ; B = CR
	LBSR Sub_2D26          ; call Sub_2D26
	PULS X                
	LDA 135,U             
	STA 9,X               
	LDA 62,U              
	LBSR WriteBlockPath    ; call WriteBlockPath
	LDA BSS.ParamStr,U    
	SUBA BSS.RxBufPtr,U   
	LBSR Sub_44FF          ; call Sub_44FF
	BRA *-38

; --------------------------------------------------------------
Sub_23D0:      PSHS A,B,X,Y          
	LDX 147,U             
	CLRB                   ; B = 0
Sub_23D7:      LDA ,X+               
	INCB                  
	CMPB #$1E             
	BHI *+9
	TSTA                  
	BMI *+6
	CMPA #$2E              ; compare A with '.'
	BNE *-12
Sub_23E5:      ADDB #$08             
	LEAX 5033,U           
	PSHS B                
	LDA #$28               ; A = '('
	SUBA ,S+              
	LSRA                  
	ADDA #$21             
	STA 1,X               
	LDD #$0221            
	STB 2,X               
	STA ,X                
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2408:      PSHS A,B,X,Y          
	LDD 83,U              
	BNE *+4
	BRA *+96

; --------------------------------------------------------------
Sub_2411:      LEAX 226,U            
	LDY 87,U              
	LDA 66,U              
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCC *+11  ; C=0 (BHS)
	LDY #$0000            
	INC BSS.BufCount,U    
	BRA *+8

; --------------------------------------------------------------
Sub_242A:      CMPY 87,U             
	BEQ *+27
Sub_2430:      TFR Y,D               
	LEAX 226,U            
	LEAX D,X              
	PSHS A,B              
	LDD 87,U              
	SUBD ,S++             
	TFR D,Y               
	LDA #$1A               ; A = SUB
Sub_2443:      STA ,X+               
	LEAY -1,Y             
	BNE *-4
Sub_2449:      LEAX 223,U            
	LDD 83,U              
	STB 1,X               
	COMB                  
	STB 2,X               
	LDD 83,U              
	BEQ *+11
	LDD 87,U              
	CMPD #$0080           
	BNE *+8
Sub_2463:      LDA #$01              
	STA ,X                
	BRA *+6

; --------------------------------------------------------------
Sub_2469:      LDA #$02               ; A = CurXY
	STA ,X                
Sub_246D:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_246F:      TST 105,U             
	BEQ *+15
	LEAX 226,U            
	LDB #$80              
Sub_247A:      CLR ,X+               
	DECB                  
	BNE *-3
	BRA *-54

; --------------------------------------------------------------
Sub_2481:      LEAX 226,U            
	LEAY 159,U            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
Sub_248B:      LDA ,Y+               
	BEQ *+11
	CMPA #$0D              ; compare A with CR
	BEQ *+7
	STA ,X+               
	DECB                  
	BNE *-11
Sub_2498:      CLR ,X+               
	LBSR Sub_2C72          ; call Sub_2C72
	BRA *-84

; --------------------------------------------------------------
Sub_249F:      PSHS A,B,X,Y          
	CLR 72,U              
	CLR 73,U              
	LEAX 226,U            
	LDD 87,U              
	LEAY D,X              
	STY 80,U              
	TST BSS.ConnState,U   
	BNE *+14
	LBSR Sub_3E3D          ; call Sub_3E3D
	LEAX D,X              
	LDA 72,U              
	STA ,X                
Sub_24C3:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_24C5:      LBSR Sub_3E0F          ; call Sub_3E0F
	LEAX D,X              
	LDD 72,U              
	STD ,X                
	BRA *-12

; --------------------------------------------------------------
Sub_24D1:      PSHS A,B,X,Y          
	LEAX 4380,U           
	LDY #$0200            
Sub_24DB:      CLR ,X+               
	LEAY -1,Y             
	BNE *-4
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_24E3:      LDA -2,X              
	SUBA #$31             
	CMPA #$03             
	BHI *+88
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LEAY 4636,U           
	LEAY D,Y              
	LDB #$40               ; B = '@'
Sub_24F6:      LDA ,X+               
	DECB                  
	CMPA #$0D              ; compare A with CR
	BEQ *+7
	STA ,Y+               
	TSTB                  
	BNE *-10
Sub_2502:      LDA #$0D               ; A = CR
	STA ,Y                
	BRA *+59

; --------------------------------------------------------------
Sub_2508:      LDA -2,X              
	SUBA #$31             
	CMPA #$03             
	BHI *+51
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LEAY 4380,U           
	LEAY D,Y              
	LDA #$01              
	STA 3202,U            
	PSHS X                
	LEAX 4380,U           
	STX 5020,U            
	PULS X                
	LDB #$40               ; B = '@'
Sub_252D:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+13
	CMPA #$5C              ; compare A with '\'
	BEQ *+15
Sub_2537:      STA ,Y+               
	DECB                  
	BNE *-13
	BRA *+5

; --------------------------------------------------------------
Sub_253E:      CLRB                   ; B = 0
	STB ,Y                
Sub_2541:      LBRA Sub_326F         
Sub_2544:      LDA ,X+               
	SUBA #$40             
	BRA *-17

; --------------------------------------------------------------
Sub_254A:      PSHS A,B,X,Y          
	LDB 3209,U            
	LDY 5020,U            
Sub_2555:      LDA ,X+               
	ANDA #$7F             
	DECB                  
	CLR 113,U             
Sub_255D:      CMPA ,Y               
	BEQ *+43
	LDA 3202,U            
	DECA                  
	PSHS B                
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LEAY 4380,U           
	LEAY D,Y              
	STY 5020,U            
	PULS B                
	TST 113,U             
	BNE *+7
	INC 113,U             
	BRA *-35

; --------------------------------------------------------------
Sub_2582:      CLR 113,U             
	TSTB                  
	BNE *-49
Sub_2588:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_258A:      LEAY 1,Y              
	STY 5020,U            
	TST ,Y                
	BNE *-17
	LDA 3202,U            
	INC 3202,U            
	INC 3203,U            
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LEAY 4380,U           
	LEAY D,Y              
	STY 5020,U            
	BRA *-39

; --------------------------------------------------------------
Sub_25B1:      PSHS A,B,X,Y          
	CLR 3203,U            
	LDA 3202,U            
	SUBA #$02             
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LEAX 4636,U           
	LEAX D,X              
	PSHS X                
	CLRB                   ; B = 0
Sub_25C9:      LDA ,X+               
	INCB                  
	CMPB #$40              ; compare B with '@'
	BHI *+6
	CMPA #$0D              ; compare A with CR
	BNE *-9
Sub_25D4:      DECB                  
	CLRA                   ; A = 0
	PULS X                
	TSTB                  
	BEQ *+15
Sub_25DB:      LDA ,X+               
	DECB                  
	CMPA #$5C              ; compare A with '\'
	BEQ *+22
	LBSR Sub_1A76          ; call Sub_1A76
Sub_25E5:      TSTB                  
	BNE *-11
Sub_25E8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_25EA:      PSHS X                
	LDX #$001E            
	LBSR Sub_0F56          ; call Sub_0F56
	PULS X                
	BRA *-15

; --------------------------------------------------------------
Sub_25F6:      LDA ,X+               
	DECB                  
	CMPA #$5E              ; compare A with '^'
	BEQ *+17
	CMPA #$2A              ; compare A with '*'
	BEQ *-21
	CMPA #$5C              ; compare A with '\'
	BEQ *+4
	SUBA #$40             
Sub_2607:      LBSR Sub_1A76          ; call Sub_1A76
	BRA *-37

; --------------------------------------------------------------
Sub_260C:      LDA #$1B               ; A = ESC
	BRA *-7

; --------------------------------------------------------------
Sub_2610:      PSHS A,B,X,Y          
Sub_2612:      TST 64,U              
	LBNE Sub_26EE         
	INC 64,U              
	BSR *+4  ; call Sub_2620
	BRA *+16

; --------------------------------------------------------------
Sub_2620:      LEAX Dat_0469,PCR       ; X → Dat_0469
	LEAY 5033,U           
	LDB #$0C               ; B = FF
	LBSR Sub_2D1E          ; call Sub_2D1E
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_262E:      LEAX 5033,U           
	LDA 144,U             
	LDB 145,U             
	SUBB #$03             
	STD 7,X               
	LDA #$FF              
	STA 4,X               
	LDA 135,U             
	LDB 136,U             
	STD 9,X               
	LDA #$01              
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA #$02               ; A = CurXY
	LEAX Dat_0467,PCR       ; X → Dat_0467
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *-76  ; C=1 (BLO)
	STA 63,U              
	LEAX 5033,U           
	LEAX 2,X              
	CLR 2,X               
	LDA 145,U             
	SUBA #$02             
	STA 4,X               
	LDA #$03              
	STA 6,X               
	LDA 137,U             
	STA 7,X               
	LDA 136,U             
	STA 8,X               
	LDA 63,U              
	LDY #$0009            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_268D:      LDA 135,U             
	LEAX 156,U            
	STA 2,X               
	LDY #$0003            
	LDA 63,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX 5033,U           
	LDA #$2D               ; A = '-'
	LDB #$50               ; B = 'P'
Sub_26A9:      STA ,X+               
	DECB                  
	BNE *-3
	LEAX 5033,U           
	LDA 63,U              
	LDY #$0050            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX 156,U            
	LDA 137,U             
	STA 2,X               
	LDY #$0003            
	LDA 63,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_09EF,PCR       ; X → Dat_09EF
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_284E          ; call Sub_284E
	LEAX Dat_09E8,PCR       ; X → Dat_09E8
	LDA 62,U              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_26EC:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_26EE:      CLR 64,U              
	LEAX Dat_0475,PCR       ; X → Dat_0475
	LDA 63,U              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 63,U              
	OS9 I$Close            ; path=A
	LBSR Sub_2620          ; call Sub_2620
	LEAX 5033,U           
	LDA 144,U             
	LDB 145,U             
	STD 7,X               
	LDA #$FF              
	STA 4,X               
	LDA 135,U             
	LDB 136,U             
	STD 9,X               
	LDA #$01              
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_09E1,PCR       ; X → Dat_09E1
	LDA 62,U              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *-79

; --------------------------------------------------------------
Sub_273D:      LDA #$00               ; A = NUL
	LDY #$0001            
	LEAX 1550,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDX 102,U             
	LDA 1550,U            
	CMPA #$8C             
	LBHI Sub_157B         
	CMPA #$7F             
	LBHI Sub_285D         
	CMPA #$18             
	BNE *+6
	LDA #$7F              
	BRA *+62

; --------------------------------------------------------------
Sub_2765:      CMPA #$1A              ; compare A with SUB
	LBEQ Sub_157B         
	CMPA #$1C             
	LBEQ Sub_157B         
	CMPA #$0A              ; compare A with LF
	LBEQ Sub_285D         
	CMPA #$0C              ; compare A with FF
	LBEQ Sub_285D         
	CMPA #$09             
	LBEQ Sub_285D         
	CMPA #$08              ; compare A with BS
	BNE *+17
	LDB 104,U             
	BEQ *+40
	LEAX -1,X             
	STX 102,U             
	DEC 104,U             
	BRA *+25

; --------------------------------------------------------------
Sub_2796:      LDB 104,U             
	CMPB #$FD             
	BCS *+6  ; C=1 (BLO)
	CMPA #$0D              ; compare A with CR
	BNE *+19
Sub_27A1:      STA ,X+               
	STX 102,U             
	INC 104,U             
	CMPA #$0D              ; compare A with CR
	BEQ *+27
Sub_27AD:      BSR *+80  ; call Sub_27FD
	LBRA Sub_285D         

; --------------------------------------------------------------
Sub_27B2:      LDA #$07              
	LEAX 5033,U           
	STA ,X                
	LDA #$01              
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_285D         

; --------------------------------------------------------------
Sub_27C6:      LDA #$0A               ; A = LF
	STA ,X+               
	LDB 104,U             
	TST 3241,U            
	BEQ *+3
	INCB                  
Sub_27D4:      CLRA                   ; A = 0
	TFR D,Y               
	LDA 43,U              
	LEAX 1295,U           
	OS9 I$Write            ; path=A  count=Y  buf→X
	CLR 104,U             
	LEAX 1295,U           
	STX 102,U             
	LDA #$0D               ; A = CR
	STA 1550,U            
	BSR *+12  ; call Sub_27FD
	LDA #$0A               ; A = LF
	STA 1550,U            
	BSR *+4  ; call Sub_27FD
	BRA *+98

; --------------------------------------------------------------
Sub_27FD:      LDA 1550,U            
	CMPA #$0D              ; compare A with CR
	BNE *+25
	LDD #$200D            
	STD 5033,U            
	LEAX 5033,U           
	LDA 63,U              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *+51

; --------------------------------------------------------------
Sub_281C:      CMPA #$08              ; compare A with BS
	BNE *+23
	LDD #$2008            
	STD 5033,U            
	LEAX 5033,U           
	LDA 63,U              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2835:      LEAX 1550,U           
	LDY #$0001            
	LDA 63,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 1550,U            
	CMPA #$0D              ; compare A with CR
	BEQ *+4
	BSR *+3  ; call Sub_284E
Sub_284D:      RTS                    ; return from subroutine
Sub_284E:      LDA 63,U              
	LEAX Dat_0493,PCR       ; X → Dat_0493
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_285D:      LBRA Sub_0C5E         
Sub_2860:      PSHS A,B,X,Y          
	LEAX 226,U            
	PSHS X                
Sub_2868:      TST ,X+               
	BNE *-2
	LEAX -1,X             
	PSHS X                
	CLR 154,U             
Sub_2874:      LDA ,-X               
	CMPX 2,S              
	BCS *+50  ; C=1 (BLO)
	CMPA #$41              ; compare A with 'A'
	BCS *+20  ; C=1 (BLO)
	CMPA #$5A              ; compare A with 'Z'
	BLS *-12
	CMPA #$61              ; compare A with 'a'
	BCS *+28  ; C=1 (BLO)
	CMPA #$7A              ; compare A with 'z'
	BHI *+30
	STA 154,U             
	BRA *-26

; --------------------------------------------------------------
Sub_2890:      CMPA #$39              ; compare A with '9'
	BHI *+14
	CMPA #$30              ; compare A with '0'
	BCC *-34  ; C=0 (BHS)
	CMPA #$2E              ; compare A with '.'
	BEQ *-38
	CMPA #$2F              ; compare A with '/'
	BEQ *+12
Sub_28A0:      LDA #$5F               ; A = '_'
	STA ,X                
	BRA *-48

; --------------------------------------------------------------
Sub_28A6:      CMPA #$5C              ; compare A with '\'
	BNE *-8
Sub_28AA:      LEAX 1,X              
	LDA ,X                
	BEQ *+20
	CMPA #$0D              ; compare A with CR
	BEQ *+16
	CMPA #$41              ; compare A with 'A'
	BCS *+6  ; C=1 (BLO)
	CMPA #$5F              ; compare A with '_'
	BNE *+8
Sub_28BC:      LEAX -1,X             
	LDA #$78               ; A = 'x'
	STA ,X                
Sub_28C2:      STX 2,S               
	TST 154,U             
	BNE *+22
Sub_28CA:      LDA ,X+               
	CMPX ,S               
	BHI *+16
	CMPA #$41              ; compare A with 'A'
	BCS *-8  ; C=1 (BLO)
	CMPA #$5A              ; compare A with 'Z'
	BHI *-12
	ORA #$20              
	STA -1,X              
	BRA *-18

; --------------------------------------------------------------
Sub_28DE:      LEAY 159,U            
	LDX 2,S               
	LDD ,S++              
	SUBD ,S++             
	CMPB #$1D             
	BLS *+4
	LDB #$1D              
Sub_28EE:      LBSR Sub_2D1E          ; call Sub_2D1E
	LDA #$0D               ; A = CR
	STA ,Y                
	LEAX 1,X              
	BSR *+113  ; call Sub_2968
	LEAX Dat_056B,PCR       ; X → Dat_056B
	LBSR WriteBlock        ; call WriteBlock
	LEAX 159,U            
	LDA ,X                
	BEQ *+50
	CMPA #$0D              ; compare A with CR
	BEQ *+46
	LDA #$01              
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDD BSS.BufPtr1,U     
	BNE *+37
	LDD BSS.ConnWord,U    
	BNE *+32
Sub_2926:      LEAX 159,U            
	LDA #$02               ; A = CurXY
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	OS9 I$Create           ; mode=B  name→X  → path→A
	BCS *+7  ; C=1 (BLO)
	STA 66,U              
Sub_2936:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2938:      LDA #$FF              
	STA 66,U              
	LDA #$0A               ; A = LF
	STA 82,U              
	BRA *-12

; --------------------------------------------------------------
Sub_2944:      LEAX Dat_0577,PCR       ; X → Dat_0577
	LBSR WriteBlock        ; call WriteBlock
	LEAX 5034,U           
	LDY #$0007            
Sub_2953:      LDA ,X                
	CMPA #$30              ; compare A with '0'
	BNE *+10
	LEAX 1,X              
	LEAY -1,Y             
	BEQ *-55
	BRA *-12

; --------------------------------------------------------------
Sub_2961:      LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *-64

; --------------------------------------------------------------
Sub_2968:      PSHS A,B,X,Y          
	LDD #$0000            
	STD BSS.ConnWord,U    
	STD BSS.BufPtr1,U     
	LDB #$08               ; B = BS
Sub_2975:      LDA ,X+               
	CMPA #$20              ; compare A with ' '
	BEQ *+10
	TSTA                  
	BEQ *+7
	DECB                  
	BNE *-10
	BRA *+46

; --------------------------------------------------------------
Sub_2983:      LEAY 5040,U           
	LEAX -1,X             
	LDB #$08               ; B = BS
Sub_298B:      LDA ,-X               
	BEQ *+9
	STA ,-Y               
	DECB                  
	CMPB #$01             
	BNE *-9
Sub_2996:      LDA #$30               ; A = '0'
Sub_2998:      STA ,-Y               
	DECB                  
	CMPB #$01             
	BNE *-5
	LEAY 5033,U           
	LEAX Dat_09F5,PCR       ; X → Dat_09F5
	CLRB                   ; B = 0
Sub_29A8:      BSR *+9  ; call Sub_29B1
	INCB                  
	CMPB #$08              ; compare B with BS
	BNE *-5
Sub_29AF:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_29B1:      PSHS B,X              
	LDA #$04              
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	LDB ,S                
	LDA B,Y               
	SUBA #$30             
	TFR A,B               
	BEQ *+41
Sub_29C2:      PSHS B                
	LDB 3,X               
	ADDB 94,U             
	STB 94,U              
	LDA 2,X               
	ADCA BSS.BufPtr1,U    
	STA BSS.BufPtr1,U     
	LDB 1,X               
	ADCB 92,U             
	STB 92,U              
	LDA ,X                
	ADCA BSS.ConnWord,U   
	STA BSS.ConnWord,U    
	PULS B                
	DECB                  
	BNE *-37
Sub_29E9:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)
Sub_29EB:      PSHS A,B,X,Y          
	LBSR Sub_13C2          ; call Sub_13C2
	BCS *+31  ; C=1 (BLO)
	CLRA                   ; A = 0
	TFR D,Y               
	LEAX 1550,U           
	LDA #$00               ; A = NUL
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *+17  ; C=1 (BLO)
	TFR Y,D               
	LEAX 1550,U           
Sub_2A06:      LDA ,X+               
	CMPA #$05             
	BEQ *+8
	DECB                  
	BNE *-7
Sub_2A0F:      CLRB                   ; B = 0
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2A12:      COMB                  
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2A15:      PSHS B,X,Y            
	LBSR Sub_3BBC          ; call Sub_3BBC
Sub_2A1A:      BSR *-47  ; call Sub_29EB
	BCS *+48  ; C=1 (BLO)
	LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$3B              ; compare A with ';'
	BCS *-19  ; C=1 (BLO)
	BRA *+29

; --------------------------------------------------------------
Sub_2A31:      LDY #$0001            
	LDA 43,U              
	LEAX 1263,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *+16  ; C=1 (BLO)
	LDA 1263,U            
	CLR 1263,U            
Sub_2A49:      CLRB                   ; B = 0
	PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2A4C:      COMB                  
	PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2A4F:      CLRA                   ; A = 0
	BRA *-7

; --------------------------------------------------------------
Sub_2A52:      PSHS A,B,X,Y          
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	CLRB                   ; B = 0
	LEAX 1805,U           
Sub_2A60:      PSHS B,X              
	BSR *+31  ; call Sub_2A81
	PULS B,X              
	LDA 1550,U            
	CMPA #$0D              ; compare A with CR
	BEQ *+12
	TST 33,U              
	BNE *+7
	INCB                  
	CMPB #$20              ; compare B with ' '
	BNE *-22
Sub_2A78:      LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2A81:      LDA #$20               ; A = ' '
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	PSHS X                
	LEAX Dat_055F,PCR       ; X → Dat_055F
	LBSR WriteBlock        ; call WriteBlock
	LDB #$1E              
	LBSR Sub_1B61          ; call Sub_1B61
	PULS X                
	LEAY 1550,U           
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D26          ; call Sub_2D26
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_2AA0:      PSHS A,B,X,Y          
	LDB 106,U             
	LDA #$20               ; A = ' '
	MUL                    ; D = A×B unsigned
	LEAX 1805,U           
	LEAX D,X              
	LEAY 159,U            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
	INC 106,U             
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2ABC:      PSHS B,X,Y            
	LDA #$01              
	STA 41,U              
	BRA *+7

; --------------------------------------------------------------
Sub_2AC5:      PSHS B,X,Y            
	CLR 41,U              
Sub_2ACA:      LBSR Sub_13C2          ; call Sub_13C2
	BCC *+10  ; C=0 (BHS)
	LDX #$0003            
	LBSR Sub_0F56          ; call Sub_0F56
	BRA *-11

; --------------------------------------------------------------
Sub_2AD7:      TSTB                  
	BEQ *-14
	LEAX 27,U             
	LDY #$0001            
	LDA #$00               ; A = NUL
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDA ,X                
	TST 41,U              
	BNE *+8
	CMPA #$60              ; compare A with '`'
	BCS *+4  ; C=1 (BLO)
	SUBA #$20             
Sub_2AF3:      PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_2AF5:      CLR 26,U              
	LDA 43,U              
	LDB #$2B               ; B = SS.CtlSg  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	BCS *+7  ; C=1 (BLO)
	INC 26,U              
	BRA *+74

; --------------------------------------------------------------
Sub_2B07:      LEAX 3118,U           
	LDD 27,X              
	ADDD #$0004           
	STD 19,U              
	LDA #$01              
	LEAX 1805,U           
	OS9 F$GPrDsc           ; pid=A  buf→X
	LEAX 64,X             
	STX 3204,U            
	TFR X,D               
	LDX 19,U              
	LDY #$0002            
	LEAU 5033,U           
	OS9 F$CpyMem           ; src→X  dst→Y  count=D
	LDU #$0000            
	LDX 5033,U            
	LEAX 21,X             
	LDD 3204,U            
	LDY #$0002            
	LEAU 17,U             
	OS9 F$CpyMem           ; src→X  dst→Y  count=D
	LDU #$0000            
Sub_2B4F:      RTS                    ; return from subroutine
Sub_2B50:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDD #$0253            
	STD ,X                
	LDA #$20               ; A = ' '
	STA 2,X               
	LDY #$0003            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX BSS.Counter1,U   
	CLRB                   ; B = 0
Sub_2B6D:      LDA ,X+               
	INCB                  
	CMPA #$21              ; compare A with '!'
	BCS *+6  ; C=1 (BLO)
	CMPB #$05             
	BCS *-9  ; C=1 (BLO)
Sub_2B78:      LEAX BSS.Counter1,U   
	CLRA                   ; A = 0
	TFR D,Y               
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2B86:      LEAY Dat_0481,PCR       ; Y → Dat_0481
	LEAX 5033,U           
	PSHS X                
	LDB #$07              
	LBSR Sub_2D26          ; call Sub_2D26
	PULS X                
	LDA 134,U             
	STA 5,X               
	LDA 135,U             
	STA 2,X               
	LDA 62,U              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
	TST 64,U              
	BEQ *+16
	LDA 62,U              
	LEAX Dat_09E8,PCR       ; X → Dat_09E8
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2BC0:      LEAY Dat_00EB,PCR       ; Y → Dat_00EB
	LEAX 5033,U           
	LDB #$1E              
	LBSR Sub_2D26          ; call Sub_2D26
	LEAX 5033,U           
	LDA 140,U             
	STA 7,X               
	LDA 135,U             
	STA 25,X              
	TST 25,U              
	BEQ *+7
	LDA #$61               ; A = 'a'
	STA 22,X              
Sub_2BE8:      LDA 62,U              
	LBSR WriteBlockPath    ; call WriteBlockPath
	LBSR Sub_2B50          ; call Sub_2B50
	LBSR Sub_2362          ; call Sub_2362
	TST 43,U              
	BEQ *+5
	LBSR Sub_118F          ; call Sub_118F
Sub_2BFC:      LDA 114,U             
	BEQ *+20
	TST 117,U             
	BEQ *+16
	LEAX 119,U            
	LDY #$000B            
	LDA 62,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2C13:      RTS                    ; return from subroutine
Sub_2C14:      LBSR Sub_0F20          ; call Sub_0F20
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_2C18:      TST 64,U              
	BEQ *+86
	LEAX Dat_09EF,PCR       ; X → Dat_09EF
	LEAY 5033,U           
	LDB #$06               ; B = SS.EOF  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
	LEAX 5033,U           
	CLRA                   ; A = 0
	STA 3,X               
	LDA #$03              
	STA 5,X               
	LDY #$0006            
	LDA 63,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAY Dat_0481,PCR       ; Y → Dat_0481
	LEAX 5033,U           
	PSHS X                
	LDB #$07              
	LBSR Sub_2D26          ; call Sub_2D26
	PULS X                
	LDA 136,U             
	STA 5,X               
	LDA 137,U             
	STA 2,X               
	LDA 63,U              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_09EF,PCR       ; X → Dat_09EF
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2C71:      RTS                    ; return from subroutine
Sub_2C72:      PSHS A,B,X,Y          
	LDA 66,U              
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
	PSHS U                
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	TFR U,Y               
	PULS U                
	BCS *+11  ; C=1 (BLO)
	STX BSS.ConnWord,U    
	STY BSS.BufPtr1,U     
	BRA *+13

; --------------------------------------------------------------
Sub_2C8D:      LDD #$0000            
	STD BSS.ConnWord,U    
	STD BSS.BufPtr1,U     
	BRA *+67

; --------------------------------------------------------------
Sub_2C98:      LDX 2,S               
	LEAY Dat_09F5,PCR       ; Y → Dat_09F5
	PSHS X                
	LDA #$30               ; A = '0'
	LDB #$07              
Sub_2CA4:      STA ,X+               
	DECB                  
	BNE *-3
	PULS X                
	CLRB                   ; B = 0
Sub_2CAC:      PSHS A,B,X,Y          
	BSR *+45  ; call Sub_2CDB
	PULS A,B,X,Y          
	INCB                  
	CMPB #$08              ; compare B with BS
	BNE *-9
	PSHS X                
	LEAX Dat_0577,PCR       ; X → Dat_0577
	LBSR WriteBlock        ; call WriteBlock
	PULS X                
	LDY #$0007            
Sub_2CC6:      LDA ,X                
	CMPA #$30              ; compare A with '0'
	BNE *+10
	LEAX 1,X              
	LEAY -1,Y             
	BEQ *+9
	BRA *-12

; --------------------------------------------------------------
Sub_2CD4:      LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2CD9:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2CDB:      LEAX B,X              
	LDA #$04              
	MUL                    ; D = A×B unsigned
	LEAY D,Y              
Sub_2CE2:      LDD ,Y                
	CMPD BSS.ConnWord,U   
	BHI *+53
	BCS *+10  ; C=1 (BLO)
	LDD 2,Y               
	CMPD BSS.BufPtr1,U    
	BHI *+43
Sub_2CF4:      LDD BSS.ConnWord,U    
	BNE *+7
	LDD BSS.BufPtr1,U     
	BEQ *+33
Sub_2CFE:      INC ,X                
	LDD BSS.BufPtr1,U     
	SUBD 2,Y              
	STD BSS.BufPtr1,U     
	BCC *+11  ; C=0 (BHS)
	LDD BSS.ConnWord,U    
	SUBD #$0001           
	STD BSS.ConnWord,U    
Sub_2D13:      LDD BSS.ConnWord,U    
	SUBD ,Y               
	STD BSS.ConnWord,U    
	BRA *-57

; --------------------------------------------------------------
Sub_2D1D:      RTS                    ; return from subroutine
Sub_2D1E:      LDA ,X+               
	STA ,Y+               
	DECB                  
	BNE *-5
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_2D26:      LDA ,Y+               
	STA ,X+               
	DECB                  
	BNE *-5
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_2D2E:      PSHS A,X              
	TST 26,U              
	BEQ *+14
	LDA 43,U              
	LDB #$28               ; B = SS.EnRTS  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	TFR B,A               
	BRA *+7

; --------------------------------------------------------------
Sub_2D41:      LDX 17,U              
	LDA 1,X               
Sub_2D46:      ANDA #$20             
	BEQ *+5
	CLRB                   ; B = 0
Sub_2D4B:      PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)
Sub_2D4D:      COMB                  
	BRA *-3

; --------------------------------------------------------------
Sub_2D50:      PSHS A,B,X            
	LDX #$0003            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	LDA 43,U              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+30  ; C=1 (BLO)
	LDX #$0015            
	LBSR Sub_0F56          ; call Sub_0F56
	LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	CLRA                   ; A = 0
	TFR D,Y               
	LEAX 5033,U           
	LDA 43,U              
	OS9 I$Read             ; path=A  count=Y  buf→X
	CLRB                   ; B = 0
Sub_2D7E:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
         FCB    $C6,$10,$A6,$80,$5A,$26,$04,$C6,$01,$20,$3C,$81,$30,$25,$F3,$81,$39,$22,$EF,$1F,$12,$31,$3F,$A6,$80,$81,$30,$25,$06,$81,$39,$22,$02,$20,$F4,$30,$1F,$CC,$20,$20,$ED,$84,$86,$A0,$A7,$24,$30,$8D,$D8,$A0,$5F,$34,$34,$C6,$05,$10,$3F,$11,$35,$34,$24,$09,$30,$05,$5C,$C1,$08,$26,$EE,$20,$15,$A6,$C9,$0C,$A5,$84,$F8,$A7,$C9,$0C,$A5,$EA,$C9,$0C,$A5,$E7,$C9,$0C,$A5,$17,$E3,$B3,$39  ; unreachable padding
Sub_2DDD:      PSHS A,B,X,Y          
	LBSR Sub_2D50          ; call Sub_2D50
	BCS *+57  ; C=1 (BLO)
	STY 3208,U            
	LEAX 5033,U           
	LDB 3209,U            
	SUBB #$07             
Sub_2DF3:      PSHS B,X              
	LEAY Dat_02D1,PCR       ; Y → Dat_02D1
	LDB #$07              
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	PULS B,X              
	BCC *+9  ; C=0 (BHS)
	LEAX 1,X              
	DECB                  
	BNE *-18
	BRA *+20

; --------------------------------------------------------------
Sub_2E09:      LDB 3209,U            
	LEAX 5033,U           
	LEAY 223,U            
	LBSR Sub_2D1E          ; call Sub_2D1E
	CLRB                   ; B = 0
Sub_2E19:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2E1B:      COMB                  
	BRA *-3

; --------------------------------------------------------------
Sub_2E1E:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDB #$0E              
Sub_2E26:      PSHS B,X              
	LEAY Dat_02D8,PCR       ; Y → Dat_02D8
	LDB #$04              
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	PULS B,X              
	BCC *+9  ; C=0 (BHS)
	LEAX 1,X              
	DECB                  
	BNE *-18
	BRA *+2

; --------------------------------------------------------------
Sub_2E3C:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2E3E:      PSHS A,B,X,Y,U        
	LEAX ModHeader,PCR     
	LDY 2,X               
	STX 21,U              
	LEAY -3,Y             
	STY 23,U              
	TFR X,U               
	TFR Y,D               
	LEAU D,U              
	LDD #$FFFF            
	STD ,U                
	STA BSS.ParamStr,U    
	OS9 F$CRC              ; buf→X  count=Y  seed=D  → CRC-24
	COM ,U                
	COM 1,U               
	COM BSS.ParamStr,U    
	PULS A,B,X,Y,U        
	LDA #$07              
	LEAX ModName,PCR        ; X → ModName
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+17  ; C=1 (BLO)
	LDX 21,U              
	LDY 23,U              
	LEAY 3,Y              
	OS9 I$Write            ; path=A  count=Y  buf→X
	OS9 I$Close            ; path=A
Sub_2E82:      RTS                    ; return from subroutine
Sub_2E83:      PSHS A,B,X,Y          
	LEAX Dat_0A24,PCR       ; X → Dat_0A24
	LEAY 3237,U           
	LDB #$4D               ; B = 'M'
	LBSR Sub_2D26          ; call Sub_2D26
	LDD #$1603            
	STD 3217,U            
	LDD #$1D04            
	STD 3215,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_08B6,PCR       ; X → Dat_08B6
	LBSR WriteBlock        ; call WriteBlock
	BSR *-115  ; call Sub_2E3E
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_1CDE          ; call Sub_1CDE
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2EBF:      PSHS A,B,X,Y          
	TST 114,U             
	BEQ *+20
	CLR 117,U             
	LEAX Dat_0366,PCR       ; X → Dat_0366
	LEAY 119,U            
	LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
	LBSR Sub_0F20          ; call Sub_0F20
Sub_2ED8:      LBSR Sub_43CA          ; call Sub_43CA
	TST 64,U              
	BEQ *+5
	LBSR Sub_2610          ; call Sub_2610
Sub_2EE3:      LDD #$0000            
	STD 9,U               
	LEAX 5817,U           
	STX 147,U             
	CLR 100,U             
	LBSR Sub_1EDC          ; call Sub_1EDC
	LDD #$0503            
	STD 3215,U            
	LDD #$4411            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LDA #$81              
	LEAX Dat_0A31,PCR       ; X → Dat_0A31
	OS9 I$Open             ; mode=B  name→X  → path→A
	LBCS Sub_2F9A         
	STA 61,U              
	PSHS U                
	LDX #$0000            
	LDU #$0040            
	OS9 I$Seek             ; path=A  mode=B  offset→X:D
	PULS U                
	BCS *+118  ; C=1 (BLO)
Sub_2F26:      LDA 61,U              
	LDY #$0020            
	LEAX 5033,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCC *+8  ; C=0 (BHS)
	CMPB #$D3             
	BNE *+98
	BRA *+18

; --------------------------------------------------------------
Sub_2F3C:      LBSR Sub_3118          ; call Sub_3118
	BCS *+4  ; C=1 (BLO)
	BSR *+100  ; call Sub_2FA5
Sub_2F43:      LDA 100,U             
	CMPA #$1D             
	BHI *+4
	BRA *-36

; --------------------------------------------------------------
Sub_2F4C:      LDA 100,U             
	STA 3224,U            
	LDA 61,U              
	OS9 I$Close            ; path=A
	LBSR Sub_3038          ; call Sub_3038
	TST 146,U             
	BEQ *+25
	LBSR Sub_1BC7          ; call Sub_1BC7
	LDD #$0000            
	STD 4892,U            
	LBSR Sub_1EDC          ; call Sub_1EDC
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_314B          ; call Sub_314B
Sub_2F79:      LBSR Sub_1CDE          ; call Sub_1CDE
	LBSR Sub_1BDF          ; call Sub_1BDF
	LBSR Sub_1C57          ; call Sub_1C57
	LBSR Sub_1EDC          ; call Sub_1EDC
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y          
	LDY 3208,U            
	LEAX 223,U            
	LBRA Sub_0FD2         

; --------------------------------------------------------------
Sub_2F9A:      OS9 F$PErr             ; path=A  error=B
	LDX #$0078            
	LBSR Sub_0F56          ; call Sub_0F56
	BRA *-42

; --------------------------------------------------------------
Sub_2FA5:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDY 147,U             
	LDB #$1E              
Sub_2FB2:      LDA ,X+               
	DECB                  
	TSTA                  
	BPL *+13
	SUBA #$80             
	STA ,Y+               
	LDD #$0A0D            
	STD ,Y                
	BRA *+7

; --------------------------------------------------------------
Sub_2FC3:      STA ,Y+               
	TSTB                  
	BNE *-20
Sub_2FC8:      INC 100,U             
	BSR *+67  ; call Sub_300E
	BSR *+17  ; call Sub_2FDE
	LDY 147,U             
	LEAY 32,Y             
	STY 147,U             
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2FDE:      PSHS A,B,X,Y          
	LDX 147,U             
	LEAY 5033,U           
	LDB #$1E              
Sub_2FEA:      LDA ,X+               
	DECB                  
	CMPA #$5F              ; compare A with '_'
	BNE *+4
	LDA #$20               ; A = ' '
Sub_2FF3:      CMPA #$2E              ; compare A with '.'
	BNE *+5
	LDA #$0D               ; A = CR
	CLRB                   ; B = 0
Sub_2FFA:      STA ,Y+               
	TSTB                  
	BNE *-19
	LDA #$01              
	LDY #$001E            
	LEAX 5033,U           
	OS9 I$WritLn           ; path=A  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_300E:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDB 100,U             
	CMPB #$0F             
	BHI *+6
	LDA #$24               ; A = '$'
	BRA *+6

; --------------------------------------------------------------
Sub_301F:      LDA #$45               ; A = 'E'
	SUBB #$0F             
Sub_3023:      STA 1,X               
	LDA #$02               ; A = CurXY
	STA ,X                
	ADDB #$20             
	STB 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3038:      PSHS A,B,X,Y          
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDA #$01              
	STA 146,U             
Sub_3047:      LEAX 5033,U           
	CMPA 3224,U           
	BLS *+10
	LDA 3224,U            
	STA 146,U             
Sub_3059:      CMPA #$0F             
	BHI *+6
	ADDA #$20             
	BRA *+4

; --------------------------------------------------------------
Sub_3061:      ADDA #$11             
Sub_3063:      STA 2,X               
	LDA 146,U             
	CMPA #$0F             
	BHI *+6
	LDA #$21               ; A = '!'
	BRA *+4

; --------------------------------------------------------------
Sub_3071:      LDA #$42               ; A = 'B'
Sub_3073:      STA 1,X               
	LDA #$02               ; A = CurXY
	STA ,X                
	LBSR Sub_3107          ; call Sub_3107
	LDA #$01              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_0693,PCR       ; X → Dat_0693
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_3090:      LBSR Sub_2AC5          ; call Sub_2AC5
	CMPA #$08              ; compare A with BS
	BNE *+18
Sub_3097:      LDA 146,U             
	CMPA #$0F             
	BHI *+6
	ADDA #$0F             
	BRA *+4

; --------------------------------------------------------------
Sub_30A3:      SUBA #$0F             
Sub_30A5:      BRA *+91
Sub_30A7:      CMPA #$09             
	BNE *+4
	BRA *-20

; --------------------------------------------------------------
Sub_30AD:      CMPA #$0C              ; compare A with FF
	BNE *+28
	LDA 146,U             
	CMPA #$01             
	BEQ *+10
	SUBA #$01             
	STA 146,U             
	BRA *+65

; --------------------------------------------------------------
Sub_30C1:      LDA 3224,U            
	STA 146,U             
	BRA *+55

; --------------------------------------------------------------
Sub_30CB:      CMPA #$0A              ; compare A with LF
	BNE *+28
	LDA 146,U             
	CMPA 3224,U           
	BEQ *+10
	ADDA #$01             
	STA 146,U             
	BRA *+33

; --------------------------------------------------------------
Sub_30E1:      LDA #$01              
	STA 146,U             
	BRA *+25

; --------------------------------------------------------------
Sub_30E9:      CMPA #$0D              ; compare A with CR
	BNE *+11
Sub_30ED:      LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_30F6:      CMPA #$05             
	BNE *-104
	CLR 146,U             
	BRA *-17

; --------------------------------------------------------------
Sub_3100:      STA 146,U             
	LBRA Sub_3047         

; --------------------------------------------------------------
Sub_3107:      PSHS A,X,Y            
	LDA #$01              
	LEAX Dat_0682,PCR       ; X → Dat_0682
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3118:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDA ,X                
	BEQ *+40
	LDB #$1B               ; B = ESC
Sub_3124:      LDA ,X+               
	DECB                  
	CMPA #$2E              ; compare A with '.'
	BEQ *+7
Sub_312B:      TSTB                  
	BNE *-8
	BRA *+26

; --------------------------------------------------------------
Sub_3130:      LDA ,X+               
	DECB                  
	CMPA #$61              ; compare A with 'a'
	BNE *-10
	LDA ,X+               
	DECB                  
	CMPA #$64              ; compare A with 'd'
	BNE *-17
	LDA ,X+               
	DECB                  
	CMPA #$E6             
	BNE *-24
	CLRB                   ; B = 0
Sub_3146:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_3148:      COMB                  
	BRA *-3

; --------------------------------------------------------------
Sub_314B:      PSHS A,B,X,Y          
	LDA 146,U             
	DECA                  
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	LEAX 5817,U           
	LEAX D,X              
	STX 147,U             
	PSHS X                
	LEAX 5033,U           
	LEAY Dat_0A31,PCR       ; Y → Dat_0A31
Sub_3169:      LDA ,Y+               
	BMI *+6
	STA ,X+               
	BRA *-6

; --------------------------------------------------------------
Sub_3171:      SUBA #$80             
	LDB #$2F               ; B = '/'
	STD ,X++              
	TFR X,Y               
	PULS X                
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
Sub_317D:      LDA ,X+               
	BMI *+9
	STA ,Y+               
	DECB                  
	BNE *-7
	BRA *+4

; --------------------------------------------------------------
Sub_3188:      STA ,Y+               
Sub_318A:      LEAX 5033,U           
	LDA #$01              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+60  ; C=1 (BLO)
	STA 61,U              
	LBSR Sub_24D1          ; call Sub_24D1
	LDA #$01              
	STA 3353,U            
	LDA #$1E              
	STA 3354,U            
Sub_31A7:      LDA 61,U              
	LEAX 5033,U           
	LDY #$0050            
	OS9 I$ReadLn           ; path=A  max=Y  buf→X
	BCC *+8  ; C=0 (BHS)
	CMPB #$D3             
	BNE *+22
	BRA *+6

; --------------------------------------------------------------
Sub_31BD:      BSR *+23  ; call Sub_31D4
	BRA *-24

; --------------------------------------------------------------
Sub_31C1:      LDA 61,U              
	OS9 I$Close            ; path=A
	LBSR Sub_118F          ; call Sub_118F
	LBRA Sub_33E0         

; --------------------------------------------------------------
Sub_31CD:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_31CF:      OS9 F$PErr             ; path=A  error=B
	BRA *-5

; --------------------------------------------------------------
Sub_31D4:      PSHS A,B,X,Y          
	CLRA                   ; A = 0
	LEAY Dat_06D1,PCR       ; Y → Dat_06D1
Sub_31DB:      LEAX 5033,U           
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	INCA                  
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	LEAY 3,Y              
	BCC *+6  ; C=0 (BHS)
	CMPA #$20              ; compare A with ' '
	BCS *-16  ; C=1 (BLO)
Sub_31ED:      CMPA #$1F             
	BHI *+128
	LEAX 3,X              
	LDB ,X+               
	CMPB #$3D              ; compare B with '='
	BNE *+120
	CMPA #$01             
	BEQ *+118
	CMPA #$02              ; compare A with CurXY
	LBEQ Sub_328A         
	CMPA #$03             
	LBEQ Sub_32A3         
	CMPA #$04             
	LBEQ Sub_32B1         
	CMPA #$05             
	LBEQ Sub_32BF         
	CMPA #$06             
	LBEQ Sub_32CE         
	CMPA #$07             
	LBEQ Sub_32E0         
	CMPA #$08              ; compare A with BS
	LBEQ Sub_32E9         
	CMPA #$09             
	LBEQ Sub_32F3         
	CMPA #$0A              ; compare A with LF
	LBEQ Sub_32FD         
	CMPA #$0B             
	LBEQ Sub_3307         
	CMPA #$0C              ; compare A with FF
	LBEQ Sub_3311         
	CMPA #$0D              ; compare A with CR
	LBEQ Sub_3320         
	CMPA #$0E             
	LBEQ Sub_3338         
	CMPA #$16             
	LBLS Sub_3358         
	CMPA #$17             
	LBEQ Sub_337E         
	CMPA #$1B              ; compare A with ESC
	LBLS Sub_2508         
	CMPA #$1F             
	LBLS Sub_24E3         
	CMPA #$20              ; compare A with ' '
	LBEQ Sub_3392         
	CMPA #$21              ; compare A with '!'
	LBEQ Sub_33A1         
Sub_326F:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_3271:      LEAY 3314,U           
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
Sub_3277:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+9
	STA ,Y+               
	DECB                  
	BNE *-9
	BRA *+6

; --------------------------------------------------------------
Sub_3284:      STA ,Y+               
	CLR ,Y+               
Sub_3288:      BRA *-25
Sub_328A:      LBSR Sub_33B0          ; call Sub_33B0
	ANDB #$07             
	LDA 3237,U            
	ANDA #$F8             
	STA 3237,U            
	ORB 3237,U            
	STB 3237,U            
	BRA *-50

; --------------------------------------------------------------
Sub_32A3:      LBSR Sub_33B0          ; call Sub_33B0
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_32AB:      STB 3239,U            
	BRA *-64

; --------------------------------------------------------------
Sub_32B1:      LBSR Sub_33B0          ; call Sub_33B0
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_32B9:      STB 3249,U            
	BRA *-78

; --------------------------------------------------------------
Sub_32BF:      LBSR Sub_33B0          ; call Sub_33B0
	CMPB #$03             
	BCS *+4  ; C=1 (BLO)
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
Sub_32C8:      STB 3238,U            
	BRA *-93

; --------------------------------------------------------------
Sub_32CE:      LBSR Sub_33B0          ; call Sub_33B0
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_32D6:      STB 3240,U            
	STB 3241,U            
	BRA *-111

; --------------------------------------------------------------
Sub_32E0:      LBSR Sub_33B0          ; call Sub_33B0
	STB 3247,U            
	BRA *-120

; --------------------------------------------------------------
Sub_32E9:      LBSR Sub_33B0          ; call Sub_33B0
	STB 3248,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_32F3:      LBSR Sub_33B0          ; call Sub_33B0
	STB 3353,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_32FD:      LBSR Sub_33B0          ; call Sub_33B0
	STB 3354,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_3307:      LBSR Sub_33B0          ; call Sub_33B0
	STB 3244,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_3311:      LBSR Sub_33B0          ; call Sub_33B0
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_3319:      STB 3242,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_3320:      LBSR Sub_33B0          ; call Sub_33B0
	LDA 3237,U            
	ANDA #$4F             
	STA 3237,U            
	ORB 3237,U            
	STB 3237,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_3338:      BSR *+120  ; call Sub_33B0
	TSTB                  
	BEQ *+9
	CMPB #$80             
	BEQ *+5
Sub_3341:      LBRA Sub_326F         
Sub_3344:      LDA 3237,U            
	ANDA #$7F             
	STA 3237,U            
	ORB 3237,U            
	STB 3237,U            
	BRA *-21

; --------------------------------------------------------------
Sub_3358:      LDA -2,X              
	SUBA #$31             
	CMPA #$07             
	BHI *+29
	LDB #$80              
	MUL                    ; D = A×B unsigned
	LEAY 3356,U           
	LEAY D,Y              
	LDB #$80              
Sub_336B:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+9
	STA ,Y+               
	DECB                  
	BNE *-9
	BRA *+5

; --------------------------------------------------------------
Sub_3378:      CLRB                   ; B = 0
	STD ,Y                
Sub_337B:      LBRA Sub_326F         
Sub_337E:      LEAY 4892,U           
	LDB #$80              
Sub_3384:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *-16
	STA ,Y+               
	DECB                  
	BNE *-9
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_3392:      LBSR Sub_33B0          ; call Sub_33B0
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_339A:      STB 3241,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_33A1:      LBSR Sub_33B0          ; call Sub_33B0
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_33A9:      STB 3240,U            
	LBRA Sub_326F         

; --------------------------------------------------------------
Sub_33B0:      LDA 1,X               
	CMPA #$21              ; compare A with '!'
	BCS *+30  ; C=1 (BLO)
	LDA ,X                
	SUBA #$30             
	CMPA #$0A              ; compare A with LF
	BCS *+4  ; C=1 (BLO)
	SUBA #$07             
Sub_33C0:      LDB #$10              
	MUL                    ; D = A×B unsigned
	LDA 1,X               
	SUBA #$30             
	CMPA #$0A              ; compare A with LF
	BCS *+4  ; C=1 (BLO)
	SUBA #$07             
Sub_33CD:      STA 1,X               
	ADDB 1,X              
Sub_33D1:      RTS                    ; return from subroutine
Sub_33D2:      LDA ,X                
	SUBA #$30             
	CMPA #$0A              ; compare A with LF
	BCS *+4  ; C=1 (BLO)
	SUBA #$07             
Sub_33DC:      TFR A,B               
	BRA *-13

; --------------------------------------------------------------
Sub_33E0:      TST 3353,U            
	BNE *+9
	CLR 4892,U            
	LBRA Sub_3533         

; --------------------------------------------------------------
Sub_33ED:      LBSR Sub_1CDE          ; call Sub_1CDE
	LDD #$1403            
	STD 3215,U            
	LDD #$2808            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_04B1,PCR       ; X → Dat_04B1
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_23D0          ; call Sub_23D0
	LEAX Dat_04DB,PCR       ; X → Dat_04DB
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_2FDE          ; call Sub_2FDE
	LEAX Dat_04E5,PCR       ; X → Dat_04E5
	LBSR WriteBlock        ; call WriteBlock
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	STB 5023,U            
	LBSR Sub_354B          ; call Sub_354B
	LEAX 3314,U           
	CLRB                   ; B = 0
Sub_342A:      LDA ,X+               
	INCB                  
	CMPB #$20              ; compare B with ' '
	BHI *+5
	TSTA                  
	BNE *-8
Sub_3434:      DECB                  
	BNE *+9
	CLR 4892,U            
	LBRA Sub_3533         

; --------------------------------------------------------------
Sub_343E:      CLRA                   ; A = 0
	TFR D,Y               
	STY 3233,U            
Sub_3446:      LEAX Dat_02DC,PCR       ; X → Dat_02DC
	LDY #$0004            
	LDA 43,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$005A            
	LBSR Sub_0F56          ; call Sub_0F56
	LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+12  ; C=0 (BHS)
	LBSR Sub_2D2E          ; call Sub_2D2E
	BCS *+7  ; C=1 (BLO)
	CLR 34,U              
	BRA *+7

; --------------------------------------------------------------
Sub_346E:      LDA #$01              
	STA 34,U              
Sub_3473:      LBSR Sub_2D50          ; call Sub_2D50
	LDY 3233,U            
	LEAX 3314,U           
	LDA 43,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_2D50          ; call Sub_2D50
	LDB #$FF              
	STB 3236,U            
Sub_348E:      LBSR Sub_1B4E          ; call Sub_1B4E
	STA 3235,U            
Sub_3495:      TST 34,U              
	BEQ *+14
	LBSR Sub_2DDD          ; call Sub_2DDD
	BCC *+108  ; C=0 (BHS)
	LBSR Sub_2E1E          ; call Sub_2E1E
	BCS *+9  ; C=1 (BLO)
	BRA *+56

; --------------------------------------------------------------
Sub_34A6:      LBSR Sub_2D2E          ; call Sub_2D2E
	BCS *+96  ; C=1 (BLO)
Sub_34AB:      LDA #$00               ; A = NUL
	LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	CMPA #$80             
	BNE *+8
	CLR 4892,U            
	BRA *+121

; --------------------------------------------------------------
Sub_34BC:      LBSR Sub_1B4E          ; call Sub_1B4E
	CMPA 3235,U           
	BEQ *-46
	INC 3236,U            
	LEAX Dat_04EA,PCR       ; X → Dat_04EA
	LBSR WriteBlock        ; call WriteBlock
	LDB 3236,U            
	BSR *+119  ; call Sub_354B
	CMPB 3354,U           
	BCS *-76  ; C=1 (BLO)
Sub_34DC:      INC 5023,U            
	LEAX Dat_04E5,PCR       ; X → Dat_04E5
	LBSR WriteBlock        ; call WriteBlock
	LDB 5023,U            
	BSR *+96  ; call Sub_354B
	LDB 3353,U            
	CMPB #$FF             
	LBEQ Sub_3446         
	LDB 5023,U            
	CMPB 3353,U           
	LBCS Sub_3446         
	CLR 4892,U            
	BRA *+44

; --------------------------------------------------------------
Sub_3509:      LDA #$01              
	LDB #$98              
	LDX #$3F06            
	LDY #$0D00            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDY #$0E00            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDY #$0F00            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	TST 114,U             
	BEQ *+11
	INC 117,U             
	LDA 115,U             
	STA 116,U             
Sub_3533:      LBSR Sub_1BAD          ; call Sub_1BAD
	LDA 61,U              
	OS9 I$Close            ; path=A
	TST 4892,U            
	BEQ *+5
	LBSR Sub_1A19          ; call Sub_1A19
Sub_3545:      LBSR Sub_12B5          ; call Sub_12B5
	LBRA Sub_31CD         

; --------------------------------------------------------------
Sub_354B:      PSHS A,B,X            
	LEAX 5033,U           
	CLRA                   ; A = 0
Sub_3552:      CMPB #$64              ; compare B with 'd'
	BCS *+7  ; C=1 (BLO)
	SUBB #$64             
	INCA                  
	BRA *-7

; --------------------------------------------------------------
Sub_355B:      ADDA #$30             
	STA ,X+               
	CLRA                   ; A = 0
Sub_3560:      CMPB #$0A              ; compare B with LF
	BCS *+7  ; C=1 (BLO)
	SUBB #$0A             
	INCA                  
	BRA *-7

; --------------------------------------------------------------
Sub_3569:      ADDA #$30             
	STA ,X+               
	ADDB #$30             
	STB ,X+               
	LEAX 5033,U           
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3580:      LEAX Dat_048F,PCR       ; X → Dat_048F
	INC 3232,U            
	LBSR WriteBlock        ; call WriteBlock
	LDD #$1C05            
	STD 3215,U            
	LDD #$1907            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_0734,PCR       ; X → Dat_0734
	LBSR WriteBlock        ; call WriteBlock
	LDA #$04              
	STA 5022,U            
	LDB 75,U              
	LBSR Sub_1DB8          ; call Sub_1DB8
	LBSR Sub_1CDE          ; call Sub_1CDE
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	CLR BSS.EchoFlag,U    
	LDB 3204,U            
	BEQ *+22
	CMPB #$03             
	BHI *+24
	STB 75,U              
	CMPB #$02              ; compare B with CurXY
	LBHI Sub_1793         
	BCS *+121  ; C=1 (BLO)
	INC BSS.EchoFlag,U    
	BRA *+116

; --------------------------------------------------------------
Sub_35D6:      STB 75,U              
	LBRA Sub_4233         

; --------------------------------------------------------------
Sub_35DC:      LBRA Sub_0C5E         
Sub_35DF:      LEAX Dat_048F,PCR       ; X → Dat_048F
	CLR 3232,U            
	LBSR WriteBlock        ; call WriteBlock
	LDD #$1C05            
	STD 3215,U            
	LDD #$1908            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_07A5,PCR       ; X → Dat_07A5
	LBSR WriteBlock        ; call WriteBlock
	LDA #$05              
	STA 5022,U            
	LDB BSS.FlowCtrl,U    
	LBSR Sub_1DB8          ; call Sub_1DB8
	LBSR Sub_1CDE          ; call Sub_1CDE
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	CLR BSS.EchoFlag,U    
	CLR 69,U              
	LDB 3204,U            
	BEQ *+29
	CMPB #$04             
	BHI *-74
	STB BSS.FlowCtrl,U    
	CMPB #$02              ; compare B with CurXY
	BCS *+27  ; C=1 (BLO)
	INC 69,U              
	CMPB #$03             
	BCS *+20  ; C=1 (BLO)
	LBHI Sub_1859         
	INC BSS.EchoFlag,U    
	BRA *+11

; --------------------------------------------------------------
Sub_363F:      STB BSS.FlowCtrl,U    
	LBRA Sub_4233         
         FCB    $16,$D6,$16  ; unreachable padding
Sub_3648:      PSHS A,B,X,Y          
	LBRA Sub_36F4         

; --------------------------------------------------------------
Sub_364D:      LDA #$FF              
Sub_364E:      EQU    $364E            ; mid-instruction overlap: Sub_364D+1 -- mid-instruction entry point -- byte 2 of LDA #$FF (86 FF) at $364D
	STA 66,U              
	CLR 105,U             
	CLR BSS.BufCount,U    
	CLR 76,U              
	CLR 106,U             
	CLR 98,U              
	CLR 82,U              
	CLR 155,U             
	LEAX 5033,U           
	LDA 43,U              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	PSHS A,B              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LEAX 5033,U           
	LDA 21,X              
	ANDA #$0F             
	STA 21,X              
	LDA 20,X              
	ANDA #$03             
	STA 20,X              
	CLRA                   ; A = 0
	CLRB                   ; B = 0
	STD 24,X              
	STD 4,X               
	PULS A,B              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDA 3248,U            
	LDB 3247,U            
	PSHS A,B              
	CLRA                   ; A = 0
	STA 3247,U            
	STA 3248,U            
	LBSR Sub_43CA          ; call Sub_43CA
	PULS A,B              
	STA 3248,U            
	STB 3247,U            
	LDD #$0000            
	STD 9,U               
	LDD #$1504            
	STD 3215,U            
	LDD #$2509            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_36CD:      PSHS A,B,X,Y          
Sub_36CF:      LBSR Sub_3BBC          ; call Sub_3BBC
Sub_36D2:      LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$02              ; compare A with CurXY
	BCS *-15  ; C=1 (BLO)
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_36E5:      CLRA                   ; A = 0
	TFR D,Y               
	LDA 43,U              
	LEAX 5033,U           
	OS9 I$Read             ; path=A  count=Y  buf→X
	BRA *-35

; --------------------------------------------------------------
Sub_36F4:      LBSR Sub_364D          ; call Sub_364D
	LEAX Dat_04EF,PCR       ; X → Dat_04EF
	LBSR WriteBlock        ; call WriteBlock
	TST BSS.EchoFlag,U    
	BEQ *+9
	LEAX Dat_0511,PCR       ; X → Dat_0511
	LBSR WriteBlock        ; call WriteBlock
Sub_370A:      LEAX Dat_052F,PCR       ; X → Dat_052F
	LBSR WriteBlock        ; call WriteBlock
	TST BSS.EchoFlag,U    
	BEQ *+11
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	BRA *+77

; --------------------------------------------------------------
Sub_371F:      LEAX Dat_055F,PCR       ; X → Dat_055F
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_455D          ; call Sub_455D
	TST 155,U             
	BEQ *+21
	LEAX 159,U            
	LDY #$0020            
	LDA #$01              
	OS9 I$WritLn           ; path=A  buf→X
	LDD #$0704            
	LBSR Sub_2294          ; call Sub_2294
Sub_3742:      LDB #$1E              
	LBSR Sub_1B61          ; call Sub_1B61
	TST 33,U              
	LBNE Sub_3954         
	LEAX Dat_045E,PCR       ; X → Dat_045E
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_04EF,PCR       ; X → Dat_04EF
	LBSR WriteBlock        ; call WriteBlock
	TST BSS.EchoFlag,U    
	BEQ *+19
	LEAX Dat_0511,PCR       ; X → Dat_0511
	LBSR WriteBlock        ; call WriteBlock
	BRA *+10

; --------------------------------------------------------------
Sub_376A:      TST 3232,U            
	LBEQ Sub_3F08         
Sub_3772:      LEAY 1550,U           
	LEAX 159,U            
	LDA ,Y                
	CMPA #$0D              ; compare A with CR
	BNE *+12
	TST 155,U             
	LBEQ Sub_3954         
	BRA *+7

; --------------------------------------------------------------
Sub_378A:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D26          ; call Sub_2D26
Sub_378F:      TST 3232,U            
	LBEQ Sub_3F08         
	TST BSS.EchoFlag,U    
	BNE *+47
	LEAX Dat_056B,PCR       ; X → Dat_056B
	LBSR WriteBlock        ; call WriteBlock
	LDA #$01              
	LEAX 159,U            
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LDA #$02               ; A = CurXY
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	LEAX 159,U            
	OS9 I$Create           ; mode=B  name→X  → path→A
	LBCS Sub_3965         
	STA 66,U              
Sub_37C9:      LDD BSS.ParamBase,U   
	STD BSS.RxBufPtr,U    
	LEAX Dat_0593,PCR       ; X → Dat_0593
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_05B7,PCR       ; X → Dat_05B7
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_052F,PCR       ; X → Dat_052F
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_3E83          ; call Sub_3E83
	LBSR Sub_3E9B          ; call Sub_3E9B
	TST BSS.EchoFlag,U    
	BEQ *+13
Sub_37ED:      LBSR Sub_3E83          ; call Sub_3E83
	LBSR Sub_3E9B          ; call Sub_3E9B
	LDD #$0000            
	BRA *+8

; --------------------------------------------------------------
Sub_37F8:      LBSR Sub_3EDD          ; call Sub_3EDD
	LDD #$0001            
Sub_37FE:      STD 83,U              
	LEAX Dat_06C7,PCR       ; X → Dat_06C7
	LBSR WriteBlock        ; call WriteBlock
	LDD #$0D07            
	LBSR Sub_2294          ; call Sub_2294
	LEAX Dat_05C7,PCR       ; X → Dat_05C7
	LDA #$01              
	LDY #$0014            
	OS9 I$Write            ; path=A  count=Y  buf→X
	INC BSS.ConnState,U   
	LDB #$04              
	STB 89,U              
Sub_3823:      LBSR Sub_3E73          ; call Sub_3E73
	DEC 89,U              
	LBSR Sub_3BBC          ; call Sub_3BBC
Sub_382C:      LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+111  ; C=0 (BHS)
	LBSR Sub_29EB          ; call Sub_29EB
	LBCS Sub_3992         
	LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$03             
	BCS *-22  ; C=1 (BLO)
	TST 89,U              
	BNE *-36
	CLR BSS.ConnState,U   
Sub_384C:      LBSR Sub_3E7F          ; call Sub_3E7F
	LBSR Sub_3BBC          ; call Sub_3BBC
Sub_3852:      LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+73  ; C=0 (BHS)
	LBSR Sub_29EB          ; call Sub_29EB
	LBCS Sub_3992         
	LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$0A              ; compare A with LF
	BCS *-22  ; C=1 (BLO)
	INC 82,U              
	LBSR Sub_3EC5          ; call Sub_3EC5
	LBSR Sub_1CF7          ; call Sub_1CF7
	LDA 82,U              
	CMPA #$0A              ; compare A with LF
	BCS *-44  ; C=1 (BLO)
	LBRA Sub_3992         

; --------------------------------------------------------------
Sub_387D:      LDD 83,U              
	CMPD #$0000           
	BNE *+10
	LBSR Sub_3E7B          ; call Sub_3E7B
	LBSR Sub_3E73          ; call Sub_3E73
	BRA *+5

; --------------------------------------------------------------
Sub_388E:      LBSR Sub_3E7B          ; call Sub_3E7B
Sub_3891:      LDD 83,U              
	ADDD #$0001           
	STD 83,U              
	LBSR Sub_3EDD          ; call Sub_3EDD
	CLR 82,U              
	LBSR Sub_3EB3          ; call Sub_3EB3
Sub_38A3:      LBSR Sub_29EB          ; call Sub_29EB
	LBCS Sub_3992         
	CLR 226,U             
	LBSR Sub_39F1          ; call Sub_39F1
	PSHS CC               
	LDD 83,U              
	CMPD #$0000           
	BNE *+13
	TST 226,U             
	BNE *+13
	PULS CC               
	LBRA Sub_3992         

; --------------------------------------------------------------
Sub_38C7:      PULS CC               
	BCS *+35  ; C=1 (BLO)
	BRA *+15

; --------------------------------------------------------------
Sub_38CD:      PULS CC               
	BCC *-82  ; C=0 (BHS)
	LDA #$0D               ; A = CR
	STA 159,U             
	LBRA Sub_3992         

; --------------------------------------------------------------
Sub_38DA:      TST BSS.BufCount,U    
	BNE *+32
	TST 98,U              
	BEQ *-101
	CLR 98,U              
	LBSR Sub_3E7B          ; call Sub_3E7B
	BRA *-71

; --------------------------------------------------------------
Sub_38EC:      LDA 82,U              
	CMPA #$09             
	LBHI Sub_3992         
	LBSR Sub_36CD          ; call Sub_36CD
	LBSR Sub_3E7F          ; call Sub_3E7F
	BRA *-88

; --------------------------------------------------------------
Sub_38FD:      TST BSS.EchoFlag,U    
	BEQ *+65
	LBSR Sub_3E7F          ; call Sub_3E7F
	LBSR Sub_39F1          ; call Sub_39F1
	CLR BSS.BufCount,U    
	PSHS U                
	TST 76,U              
	BNE *+29
	LDD BSS.ConnWord,U    
	BNE *+7
	LDD BSS.BufPtr1,U     
	BEQ *+19
Sub_391C:      LDA 66,U              
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
	LDX BSS.ConnWord,U    
	LDY BSS.BufPtr1,U     
	TFR Y,U               
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
Sub_392D:      PULS U                
	LDA 66,U              
	OS9 I$Close            ; path=A
	LDA #$0D               ; A = CR
	STA 159,U             
	LBSR Sub_3E7B          ; call Sub_3E7B
	LBRA Sub_37ED         

; --------------------------------------------------------------
Sub_3941:      CLR BSS.BufCount,U    
	LBSR Sub_3E7B          ; call Sub_3E7B
Sub_3947:      CLR 3232,U            
	LBSR Sub_1D09          ; call Sub_1D09
	LDA 66,U              
	OS9 I$Close            ; path=A
Sub_3954:      LBSR Sub_118F          ; call Sub_118F
	LBSR Sub_1CDE          ; call Sub_1CDE
	CLR 69,U              
	CLR BSS.EchoFlag,U    
	PULS A,B,X,Y          
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_3965:      LDA #$07              
	LBSR Sub_1F0B          ; call Sub_1F0B
	PSHS B                
	LDD #$0D02            
	LBSR Sub_2294          ; call Sub_2294
	LDA #$03              
	LBSR Sub_1F0B          ; call Sub_1F0B
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	PULS B                
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_0F56          ; call Sub_0F56
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	BRA *-60

; --------------------------------------------------------------
Sub_3992:      LDA 159,U             
	CMPA #$0D              ; compare A with CR
	BEQ *+18
	LDA 66,U              
	OS9 I$Close            ; path=A
	LEAX 159,U            
	OS9 I$Delete           ; name→X
	LBSR Sub_36CD          ; call Sub_36CD
Sub_39AA:      LEAX 5033,U           
	LDA #$18              
	LDB #$04              
Sub_39B2:      STA ,X+               
	DECB                  
	BNE *-3
	LDA #$03              
	LDB #$04              
Sub_39BB:      STA ,X+               
	DECB                  
	BNE *-3
	LDA 43,U              
	LDY #$0008            
	LEAX 5033,U           
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_3947         

; --------------------------------------------------------------
Sub_39D1:      LDA #$04              
	STA 79,U              
	LBRA Sub_3B83         

; --------------------------------------------------------------
Sub_39D9:      LDA #$03              
	STA 79,U              
	LBRA Sub_3B83         

; --------------------------------------------------------------
Sub_39E1:      LDA #$02               ; A = CurXY
	STA 79,U              
	LBRA Sub_0C57         

; --------------------------------------------------------------
Sub_39E9:      LDA #$01              
	STA 79,U              
	LBRA Sub_3B83         

; --------------------------------------------------------------
Sub_39F1:      PSHS X,Y              
	LDD #$0000            
	STD BSS.Counter2,U    
	STD 72,U              
	CLR 98,U              
	CLR 79,U              
	CLR BSS.BufCount,U    
	LBSR Sub_3BBC          ; call Sub_3BBC
Sub_3A08:      LEAX 223,U            
Sub_3A0C:      LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$0A              ; compare A with LF
	LBHI Sub_39D1         
	LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *-17  ; C=1 (BLO)
	LDY #$0001            
	LDA 43,U              
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *-29  ; C=1 (BLO)
	TFR Y,D               
	STD BSS.Counter2,U    
	ABX                   
	LDA 223,U             
	CMPA #$02              ; compare A with CurXY
	BEQ *+32
	CMPA #$01             
	BEQ *+23
	CMPA #$04             
	LBEQ Sub_3BAC         
	CMPA #$18             
	LBEQ Sub_3BB4         
	CMPA #$03             
	LBEQ Sub_3BB4         
	LBRA Sub_3A08         

; --------------------------------------------------------------
Sub_3A52:      LDD #$0080            
	BRA *+5

; --------------------------------------------------------------
Sub_3A57:      LDD #$0400            
Sub_3A5A:      STD 87,U              
	LEAY 226,U            
	LEAY D,Y              
	STY 80,U              
	ORB #$04              
	TST BSS.ConnState,U   
	BEQ *+4
	ORB #$01              
Sub_3A70:      STD 85,U              
	LBSR Sub_3BBC          ; call Sub_3BBC
	BRA *+11

; --------------------------------------------------------------
Sub_3A78:      LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$02              ; compare A with CurXY
	LBHI Sub_39D1         
Sub_3A81:      LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *-17  ; C=1 (BLO)
	CMPB #$02              ; compare B with CurXY
	BCS *-21  ; C=1 (BLO)
	CLRA                   ; A = 0
	LDY #$0002            
	LDA 43,U              
	OS9 I$Read             ; path=A  count=Y  buf→X
	TFR Y,D               
	ABX                   
	ADDD BSS.Counter2,U   
	STD BSS.Counter2,U    
	LDD 83,U              
	CMPB 224,U            
	BNE *+12
Sub_3AAC:      COMB                  
	CMPB 225,U            
	BEQ *+17
Sub_3AB3:      LBRA Sub_39E1         
Sub_3AB6:      DECB                  
	CMPB 224,U            
	BNE *-8
	INC 98,U              
	BRA *-20

; --------------------------------------------------------------
Sub_3AC2:      LBSR Sub_3BBC          ; call Sub_3BBC
Sub_3AC5:      LBSR Sub_3BDA          ; call Sub_3BDA
	CMPA #$02              ; compare A with CurXY
	LBHI Sub_39D1         
Sub_3ACE:      LDA 43,U              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *-17  ; C=1 (BLO)
	CLRA                   ; A = 0
	TFR D,Y               
	LDA 43,U              
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *-28  ; C=1 (BLO)
	TFR Y,D               
	LBSR Sub_3BBC          ; call Sub_3BBC
	TST BSS.ConnState,U   
	BNE *+7
	LBSR Sub_3E3D          ; call Sub_3E3D
	BRA *+5

; --------------------------------------------------------------
Sub_3AF2:      LBSR Sub_3E0F          ; call Sub_3E0F
Sub_3AF5:      ABX                   
	ADDD BSS.Counter2,U   
	STD BSS.Counter2,U    
	CMPD 85,U             
	BCS *-50  ; C=1 (BLO)
	LDX 80,U              
	LDD 72,U              
	TST BSS.ConnState,U   
	BEQ *+11
	CMPD ,X               
Sub_3B10:      LBNE Sub_39D9         
	BRA *+6

; --------------------------------------------------------------
Sub_3B16:      CMPA ,X               
	BRA *-8

; --------------------------------------------------------------
Sub_3B1A:      TST 98,U              
	BNE *+98
	LDD 83,U              
	CMPD #$0000           
	BNE *+9
	LBSR Sub_2860          ; call Sub_2860
	BCS *+88  ; C=1 (BLO)
	BRA *+83

; --------------------------------------------------------------
Sub_3B2F:      LEAX 226,U            
	CMPD #$0001           
	BNE *+66
	LDD 87,U              
	LBSR Sub_4206          ; call Sub_4206
	TST 76,U              
	BEQ *+55
	PSHS A,X,Y            
	LEAX 156,U            
	LDA 137,U             
	STA 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_06BF,PCR       ; X → Dat_06BF
	LDY #$0008            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 135,U             
	LEAX 156,U            
	STA 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y            
Sub_3B79:      LDD 87,U              
	LBSR Sub_4191          ; call Sub_4191
Sub_3B7F:      CLRB                   ; B = 0
Sub_3B80:      PULS X,Y              
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_3B83:      INC 82,U              
	LBSR Sub_3EC5          ; call Sub_3EC5
	LBSR Sub_1CF7          ; call Sub_1CF7
	LDD #$0D07            
	LBSR Sub_2294          ; call Sub_2294
	LDB #$14              
	LDA 79,U              
	BEQ *+18
	MUL                    ; D = A×B unsigned
	LEAX Dat_05C7,PCR       ; X → Dat_05C7
	LEAX D,X              
	LDA #$01              
	LDY #$0014            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_3BA9:      COMB                  
	BRA *-42

; --------------------------------------------------------------
Sub_3BAC:      INC BSS.BufCount,U    
	LBSR Sub_41EC          ; call Sub_41EC
	BRA *-50

; --------------------------------------------------------------
Sub_3BB4:      LDA #$0A               ; A = LF
	STA 82,U              
	LBRA Sub_39E9         

; --------------------------------------------------------------
Sub_3BBC:      PSHS A,B,X            
	TST 114,U             
	BEQ *+11
	CLRA                   ; A = 0
	LDB 115,U             
	STD 96,U              
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3BCC:      LEAX 3225,U           
	OS9 F$Time             ; buf→X  → 6-byte time
	LDA 5,X               
	STA 96,U              
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3BDA:      PSHS B,X              
	TST 114,U             
	BEQ *+20
	LDA #$01              
	LDB 115,U             
	SUBD 96,U             
	TFR B,A               
	LDX #$0001            
	LBSR Sub_0F56          ; call Sub_0F56
	PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3BF3:      LEAX 3225,U           
	OS9 F$Time             ; buf→X  → 6-byte time
	LDA 5,X               
	LDX #$0001            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	ADDA #$3C             
	SUBA 96,U             
	CMPA #$3C              ; compare A with '<'
	BCS *+4  ; C=1 (BLO)
	SUBA #$3C             
Sub_3C0D:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)
; CrcTable — CRC-16/CCITT lookup table  (256 × FDB = 512 bytes)
; Indexed as: LEAY CrcTable,PC  then LDD B,Y to fetch entry.
; Added in v2.2 to replace the slower OS9 F$CRC syscall.

CrcTable
; Referenced by: $3E20
; CRC-16/CCITT lookup table — 256 entries x 2 bytes = 512 bytes
; Used by file transfer protocol routines for fast CRC calculation.
; Dave Philipsen added this in v2.2; v2.1 used OS9 F$CRC syscall instead.
; Table polynomial: $1021 (CRC-CCITT / CRC-16-IBM-SDLC)
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
Sub_3E0F:      PSHS A,B,X,Y          
	LEAY D,X              
	PSHS Y                
	LDY 80,U              
	PSHS Y                
	CMPX 80,U             
	BCC *+27  ; C=0 (BHS)
	LEAY CrcTable,PCR       ; Y → CrcTable
Sub_3E24:      LDB <$48              
	CLRA                   ; A = 0
	EORB ,X+              
	LSLB                  
	ROLA                  
	LDD D,Y               
	EORA <$49             
	STD <$48              
	CMPX ,S               
	BEQ *+6
	CMPX 2,S              
	BCS *-19  ; C=1 (BLO)
Sub_3E39:      LEAS 4,S              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E3D:      PSHS A,B,X,Y          
	LEAY D,X              
	PSHS Y                
	CMPX 80,U             
	BEQ *+16
	LDA 72,U              
Sub_3E4B:      ADDA ,X+              
Insn_3E4D:     CMPX 80,U             
Sub_3E4E:      EQU    $3E4E            ; mid-instruction overlap: Insn_3E4D+1 -- mid-instruction entry point -- byte 2 of CMPX 80,U ($AC C8 50) at $3E4D; BNE from $3DE0
	BEQ *+6
	CMPX ,S               
	BCS *-9  ; C=1 (BLO)
Sub_3E56:      STA 72,U              
	LEAS 2,S              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E5D:      PSHS A,X,Y            
	LEAX 68,U             
	LDA 43,U              
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E6E:      STA 68,U              
	BRA *-20

; --------------------------------------------------------------
Sub_3E73:      LDA #$43               ; A = 'C'
	BRA *-7

; --------------------------------------------------------------
Sub_3E77:      LDA #$04              
	BRA *-11

; --------------------------------------------------------------
Sub_3E7B:      LDA #$06              
	BRA *-15

; --------------------------------------------------------------
Sub_3E7F:      LDA #$15              
	BRA *-19

; --------------------------------------------------------------
Sub_3E83:      PSHS A,B,X,Y          
	LEAX Dat_062B,PCR       ; X → Dat_062B
	LEAY 5193,U           
	LDB #$09              
	LBSR Sub_2D1E          ; call Sub_2D1E
	LEAX 5193,U           
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E9B:      PSHS A,B,X,Y          
	LEAX Dat_0634,PCR       ; X → Dat_0634
	LEAY 5177,U           
	LDB #$09              
	LBSR Sub_2D1E          ; call Sub_2D1E
	LEAX 5177,U           
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3EB3:      PSHS A,B,X,Y          
	LEAX 5177,U           
	LDD #$3030            
	STD 5,X               
	STD 7,X               
	LBSR WriteBlock        ; call WriteBlock
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3EC5:      PSHS A,X,Y            
	LEAX 5177,U           
	BSR *+31  ; call Sub_3EEA
	LBSR WriteBlock        ; call WriteBlock
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

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
Sub_3EDD:      PSHS A,X,Y            
	LEAX 5193,U           
	BSR *+7  ; call Sub_3EEA
	LBSR WriteBlock        ; call WriteBlock
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3EEA:      PSHS B                
	LDB #$08               ; B = BS
Sub_3EEE:      BSR *+11  ; call Sub_3EF9
	CMPA #$30              ; compare A with '0'
	BNE *+5
	DECB                  
	BCC *-7  ; C=0 (BHS)
Sub_3EF7:      PULS B,PC              ; return from subroutine  (PULS PC = RTS)
Sub_3EF9:      LDA B,X               
	INCA                  
	CMPA #$39              ; compare A with '9'
	BHI *+5
	STA B,X               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_3F03:      LDA #$30               ; A = '0'
	STA B,X               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_3F08:      TST BSS.EchoFlag,U    
	BEQ *+15
	LBSR Sub_2A52          ; call Sub_2A52
	TST 33,U              
	LBNE Sub_3954         
Sub_3F17:      LBSR Sub_2AA0          ; call Sub_2AA0
Sub_3F1A:      LEAX Dat_0583,PCR       ; X → Dat_0583
	LBSR WriteBlock        ; call WriteBlock
	LEAX 159,U            
	LDA #$01              
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_06C7,PCR       ; X → Dat_06C7
	LBSR WriteBlock        ; call WriteBlock
	LDA #$01              
	LEAX 159,U            
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCC *+14  ; C=0 (BHS)
Sub_3F47:      TST BSS.EchoFlag,U    
	LBEQ Sub_3954         
	INC 105,U             
	BRA *+32

; --------------------------------------------------------------
Sub_3F53:      STA 66,U              
	LEAX 223,U            
	LDY #$007F            
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *-26  ; C=1 (BLO)
	TFR Y,D               
	LBSR Sub_4206          ; call Sub_4206
	LDA 66,U              
	LDX #$0000            
	OS9 I$Seek             ; path=A  mode=B  offset→X:D
Sub_3F71:      LEAX Dat_0593,PCR       ; X → Dat_0593
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_052F,PCR       ; X → Dat_052F
	LBSR WriteBlock        ; call WriteBlock
	LBSR Sub_3E83          ; call Sub_3E83
	LBSR Sub_3E9B          ; call Sub_3E9B
	TST 76,U              
	BEQ *+49
	LEAX 156,U            
	LDA 137,U             
	STA 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_06BF,PCR       ; X → Dat_06BF
	LDY #$0008            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX 156,U            
	LDB 135,U             
	STB 2,X               
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_3FB9:      CLR BSS.ConnState,U   
	LDD #$0080            
	STD 87,U              
	ADDD #$0004           
	STD 85,U              
	TST BSS.EchoFlag,U    
	LBNE Sub_40EA         
	LEAX 5033,U           
	LBSR Sub_2C72          ; call Sub_2C72
	TST 69,U              
	BEQ *+14
	LDD #$0400            
	STD 87,U              
	ADDD #$0004           
	STD 85,U              
Sub_3FE7:      LDD #$0001            
	STD 83,U              
	LBSR Sub_3EDD          ; call Sub_3EDD
	LBSR Sub_3EB3          ; call Sub_3EB3
	LBSR Sub_36CD          ; call Sub_36CD
	LBSR Sub_2408          ; call Sub_2408
	TST BSS.EchoFlag,U    
	BEQ *+11
	LDD 83,U              
	CMPD #$0001           
	BEQ *+18
Sub_4007:      LBSR Sub_2A15          ; call Sub_2A15
	LBCS Sub_40E7         
	CMPA #$43              ; compare A with 'C'
	BEQ *+7
	LBSR Sub_249F          ; call Sub_249F
	BRA *+28

; --------------------------------------------------------------
Sub_4017:      LDA #$01              
	STA BSS.ConnState,U   
	LBSR Sub_249F          ; call Sub_249F
	LDD 87,U              
	ADDD #$0005           
	STD 85,U              
	BRA *+25

; --------------------------------------------------------------
Sub_402A:      LBSR Sub_2A15          ; call Sub_2A15
	LBCS Sub_40E7         
Sub_4031:      CMPA #$15             
	BEQ *+14
	CMPA #$06             
	BEQ *+57
	CMPA #$18             
	LBEQ Sub_40E7         
	BRA *-56

; --------------------------------------------------------------
Sub_4041:      INC 82,U              
	LDA 82,U              
	CMPA #$09             
	LBHI Sub_40E7         
	CMPA #$01             
	BNE *+11
	LDD 83,U              
	CMPD #$0001           
	BEQ *+8
Sub_405A:      LBSR Sub_3EC5          ; call Sub_3EC5
	LBSR Sub_1CF7          ; call Sub_1CF7
Sub_4060:      LDY 85,U              
	LDA 43,U              
	LEAX 223,U            
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *-68

; --------------------------------------------------------------
Sub_4070:      CLR 82,U              
	LBSR Sub_3EB3          ; call Sub_3EB3
	TST BSS.BufCount,U    
	BNE *+69
	LDD 83,U              
	ADDD #$0001           
	STD 83,U              
	TST 69,U              
	BEQ *+24
	LDD #$0400            
	STD 87,U              
	TST BSS.ConnState,U   
	BEQ *+7
	ADDD #$0005           
	BRA *+5

; --------------------------------------------------------------
Sub_4099:      ADDD #$0004           
Sub_409C:      STD 85,U              
Sub_409F:      LBSR Sub_3EDD          ; call Sub_3EDD
	LBSR Sub_2408          ; call Sub_2408
	TST BSS.BufCount,U    
	BNE *+22
	LBSR Sub_249F          ; call Sub_249F
	LDA 43,U              
	LEAX 223,U            
	LDY 85,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_402A         

; --------------------------------------------------------------
Sub_40BE:      LDA 66,U              
	OS9 I$Close            ; path=A
	CLR BSS.BufCount,U    
	TST BSS.EchoFlag,U    
	BEQ *+14
	LBSR Sub_3E77          ; call Sub_3E77
	LBSR Sub_2A15          ; call Sub_2A15
	BCS *+21  ; C=1 (BLO)
	NOP                   
	LBRA Sub_3F17         

; --------------------------------------------------------------
Sub_40D8:      LBSR Sub_3E77          ; call Sub_3E77
	LBSR Sub_2A15          ; call Sub_2A15
	BCS *+9  ; C=1 (BLO)
	CMPA #$06             
	BNE *-10
	LBRA Sub_3947         

; --------------------------------------------------------------
Sub_40E7:      LBRA Sub_39AA         
Sub_40EA:      LBSR Sub_2A15          ; call Sub_2A15
	BCS *-6  ; C=1 (BLO)
	CMPA #$43              ; compare A with 'C'
	BNE *-7
	INC BSS.ConnState,U   
	LDD 87,U              
	ADDD #$0005           
	STD 85,U              
	LDD #$0000            
	STD 83,U              
	LBSR Sub_2408          ; call Sub_2408
	LBSR Sub_249F          ; call Sub_249F
	LEAX 223,U            
	LEAY 5033,U           
	LDB #$86              
	LBSR Sub_2D1E          ; call Sub_2D1E
	TST 105,U             
	BNE *+20
	LDD #$0001            
	STD 83,U              
	LDD #$0400            
	STD 87,U              
	LBSR Sub_2408          ; call Sub_2408
	LBSR Sub_249F          ; call Sub_249F
Sub_412F:      LDA 43,U              
	LEAX 5033,U           
	LDY 85,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_413D:      LBSR Sub_2A15          ; call Sub_2A15
	BCS *-89  ; C=1 (BLO)
	CMPA #$06             
	BEQ *+24
	CMPA #$15             
	BNE *-11
	INC 82,U              
	LDA 82,U              
	CMPA #$09             
	BHI *-107
	LBSR Sub_3EC5          ; call Sub_3EC5
	LBSR Sub_1CF7          ; call Sub_1CF7
	BRA *-43

; --------------------------------------------------------------
Sub_415C:      TST 105,U             
	LBNE Sub_3954         
	LDD #$0001            
	STD 83,U              
	LBSR Sub_3EDD          ; call Sub_3EDD
	LDD 87,U              
	ADDD #$0005           
	STD 85,U              
	LBSR Sub_2A15          ; call Sub_2A15
	LBCS Sub_40E7         
	CMPA #$43              ; compare A with 'C'
	BNE *-34
	LDA 43,U              
	LEAX 223,U            
	LDY 85,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_402A         

; --------------------------------------------------------------
Sub_4191:      PSHS A,B,Y            
	LDD BSS.ParamStr,U    
	SUBD ,S               
	CMPD BSS.RxBufPtr,U   
	BCC *+4  ; C=0 (BHS)
	BSR *+80  ; call Sub_41EC
Sub_419E:      LDY BSS.RxBufPtr,U    
	TST 76,U              
	BNE *+24
Sub_41A6:      LDD ,X++              
	STD ,Y++              
	LDD ,S                
	SUBD #$0002           
	STD ,S                
	BHI *-11
	BEQ *+4
	LEAY -1,Y             
Sub_41B7:      STY BSS.RxBufPtr,U    
	PULS A,B,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_41BC:      LDD ,X++              
	CMPA #$1F             
	BHI *+10
	CMPA #$0A              ; compare A with LF
	BEQ *+8
	CMPA #$1A              ; compare A with SUB
	BEQ *+4
Sub_41CA:      STA ,Y+               
Sub_41CC:      CMPB #$1F             
	BHI *+10
	CMPB #$0A              ; compare B with LF
	BEQ *+8
	CMPB #$1A              ; compare B with SUB
	BEQ *+4
Sub_41D8:      STB ,Y+               
Sub_41DA:      LDD ,S                
	SUBD #$0002           
	STD ,S                
	BHI *-37
	BEQ *+4
	LEAY -1,Y             
Sub_41E7:      STY BSS.RxBufPtr,U    
	PULS A,B,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_41EC:      PSHS X                
	LDX BSS.ParamBase,U   
	LDD BSS.RxBufPtr,U    
	SUBD BSS.ParamBase,U  
	TFR D,Y               
	LDA 66,U              
	CMPA #$FF             
	BEQ *+5
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_4200:      LDD BSS.ParamBase,U   
	STD BSS.RxBufPtr,U    
	PULS X,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_4206:      PSHS A,B,X            
	TST 3245,U            
	BEQ *+34
	INC 76,U              
	ANDB #$7F             
Sub_4213:      LDA ,X+               
	BMI *+25
	BEQ *+18
	CMPA #$1F             
	BHI *+14
	CMPA #$0D              ; compare A with CR
	BEQ *+10
	CMPA #$0A              ; compare A with LF
	BEQ *+6
	CMPA #$09             
	BNE *+7
Sub_4229:      DECB                  
	BNE *-23
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_422E:      CLR 76,U              
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_4233:      LDD #$1504            
	STD 3215,U            
	LDD #$2507            
	STD 3217,U            
	LBSR Sub_1C81          ; call Sub_1C81
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	TST 3232,U            
	LBEQ Sub_444C         
	LEAX Dat_08CF,PCR       ; X → Dat_08CF
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_051C,PCR       ; X → Dat_051C
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	TST 37,U              
	BEQ *+83
	LEAX Dat_0925,PCR       ; X → Dat_0925
	LBSR WriteBlock        ; call WriteBlock
	LEAX 191,U            
	LDA #$01              
	LDY BSS.CurrChar,U    
	LEAY -1,Y             
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_08E8,PCR       ; X → Dat_08E8
	LBSR WriteBlock        ; call WriteBlock
Sub_428A:      LBSR Sub_2AC5          ; call Sub_2AC5
	CMPA #$59              ; compare A with 'Y'
	BEQ *+20
	CMPA #$0D              ; compare A with CR
	BEQ *+16
	CMPA #$4E              ; compare A with 'N'
	LBEQ Sub_4332         
	CMPA #$05             
	LBEQ Sub_4332         
	BRA *-23

; --------------------------------------------------------------
Sub_42A3:      LBSR Sub_43CA          ; call Sub_43CA
	LBSR Sub_44E1          ; call Sub_44E1
	LDA 42,U              
	OS9 I$Close            ; path=A
	LBCS Sub_433B         
	CLR 37,U              
	CLR 38,U              
	LBSR Sub_2362          ; call Sub_2362
	BRA *+118

; --------------------------------------------------------------
Sub_42BE:      TST BSS.StateFlag,U   
	BNE *+38
	LEAX Dat_055F,PCR       ; X → Dat_055F
	LBSR WriteBlock        ; call WriteBlock
	LDB #$1E              
	LBSR Sub_1B61          ; call Sub_1B61
	TST 33,U              
	BNE *+96
	LDD 28,U              
	STD BSS.CurrChar,U    
	LEAX 1550,U           
	LEAY 191,U            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
Sub_42E7:      LEAX 191,U            
	LDA ,X                
	CMPA #$0D              ; compare A with CR
	BEQ *+67
	LDA #$02               ; A = CurXY
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	OS9 I$Create           ; mode=B  name→X  → path→A
	BCC *+32  ; C=0 (BHS)
	CMPB #$DA             
	BNE *+63
	LEAX Dat_092B,PCR       ; X → Dat_092B
	LBSR WriteBlock        ; call WriteBlock
Sub_4305:      LBSR Sub_2AC5          ; call Sub_2AC5
	CMPA #$41              ; compare A with 'A'
	BEQ *+89
	CMPA #$4F              ; compare A with 'O'
	LBEQ Sub_438A         
	CMPA #$0D              ; compare A with CR
	BEQ *+30
	BRA *-17

; --------------------------------------------------------------
Sub_4318:      STA 42,U              
Sub_431B:      INC 37,U              
	TST 36,U              
	BNE *+17
	INC 38,U              
	LBSR Sub_2360          ; call Sub_2360
	LDA BSS.ParamStr,U    
	SUBA BSS.RxBufPtr,U   
	STA BSS.TxBufPtr,U    
	LBSR Sub_44FF          ; call Sub_44FF
Sub_4332:      CLR 36,U              
	LBSR Sub_1CDE          ; call Sub_1CDE
	LBRA Sub_0C5E         

; --------------------------------------------------------------
Sub_433B:      LDA #$07              
	LBSR Sub_1F0B          ; call Sub_1F0B
	PSHS B                
	LDD #$0D02            
	LBSR Sub_2294          ; call Sub_2294
	LEAX Dat_048F,PCR       ; X → Dat_048F
	LBSR WriteBlock        ; call WriteBlock
	PULS B                
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_0F56          ; call Sub_0F56
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	BRA *-47

; --------------------------------------------------------------
Sub_4363:      LEAX 191,U            
	LDA #$03              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCC *+13  ; C=0 (BHS)
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_0F56          ; call Sub_0F56
	BRA *-60

; --------------------------------------------------------------
Sub_4379:      STA 42,U              
	PSHS U                
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	OS9 I$Seek             ; path=A  mode=B  offset→X:D
	PULS U                
	BRA *-109

; --------------------------------------------------------------
Sub_438A:      LEAX 191,U            
	OS9 I$Delete           ; name→X
	LBRA Sub_42E7         

; --------------------------------------------------------------
Sub_4394:      PSHS A,B,X,Y          
	LEAX 1805,U           
	LDY 3208,U            
	TFR Y,D               
	LDY BSS.RxBufPtr,U    
Sub_43A4:      LDA ,X+               
	CMPA #$0A              ; compare A with LF
	BEQ *+7
	STA ,Y+               
	STY BSS.RxBufPtr,U    
Sub_43AF:      DECB                  
	CMPY BSS.ParamStr,U   
	BCS *+7  ; C=1 (BLO)
	BSR *+21  ; call Sub_43CA
	LDY BSS.RxBufPtr,U    
Sub_43BA:      TSTB                  
	BNE *-23
	LDA BSS.ParamStr,U    
	SUBA BSS.RxBufPtr,U   
	CMPA BSS.TxBufPtr,U   
	BEQ *+5
	LBSR Sub_44FF          ; call Sub_44FF
Sub_43C8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_43CA:      PSHS A,B,X,Y          
	LDD BSS.RxBufPtr,U    
	STD 9,U               
	TST 37,U              
	BEQ *+42
	LDA 3248,U            
	BEQ *+8
	STA 68,U              
	LBSR Sub_3E5D          ; call Sub_3E5D
Sub_43E1:      LDD BSS.RxBufPtr,U    
	SUBD BSS.ParamBase,U  
	TFR D,Y               
	LEAX 5817,U           
	LDA 42,U              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA 3247,U            
	BEQ *+8
	STA 68,U              
	LBSR Sub_3E5D          ; call Sub_3E5D
Sub_43FD:      LDD BSS.ParamBase,U   
	STD BSS.RxBufPtr,U    
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_4403:      PSHS A,B,X,Y          
	CLR 36,U              
	LDX ,U                
Sub_440A:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+57
	CMPA #$66              ; compare A with 'f'
	BEQ *+6
	CMPA #$46              ; compare A with 'F'
	BNE *-12
Sub_4418:      LDA -2,X              
	CMPA #$20              ; compare A with ' '
	BEQ *+9
	CMPA #$2D              ; compare A with '-'
	BNE *-22
	INC 36,U              
Sub_4425:      LDA ,X+               
	CMPA #$3D              ; compare A with '='
	BNE *-31
	LEAY 191,U            
	CLRB                   ; B = 0
Sub_4430:      LDA ,X+               
	STA ,Y+               
	INCB                  
	CMPA #$0D              ; compare A with CR
	BEQ *+6
	CMPB #$20              ; compare B with ' '
	BCS *-11  ; C=1 (BLO)
Sub_443D:      CLRA                   ; A = 0
	STD BSS.CurrChar,U    
	INC BSS.StateFlag,U   
	LBSR Sub_4233          ; call Sub_4233
Sub_4447:      CLR BSS.StateFlag,U   
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_444C:      LEAX Dat_0910,PCR       ; X → Dat_0910
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_048B,PCR       ; X → Dat_048B
	LBSR WriteBlock        ; call WriteBlock
	LEAX Dat_055F,PCR       ; X → Dat_055F
	LBSR WriteBlock        ; call WriteBlock
	LDB #$1E              
	LBSR Sub_1B61          ; call Sub_1B61
	TST 33,U              
	BNE *+102
	LEAX 1550,U           
	LEAY 5033,U           
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_2D1E          ; call Sub_2D1E
	LEAX 5033,U           
	LDA ,X                
	CMPA #$0D              ; compare A with CR
	BEQ *+79
	LDA #$01              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+72  ; C=1 (BLO)
	STA 44,U              
	LDA #$01              
	STA 35,U              
	LBSR Sub_1CDE          ; call Sub_1CDE
Sub_4494:      LDA 44,U              
	LEAX 5033,U           
	LDY #$00FF            
	OS9 I$ReadLn           ; path=A  max=Y  buf→X
	BCS *+33  ; C=1 (BLO)
	LDA 43,U              
	LEAX 5033,U           
	OS9 I$WritLn           ; path=A  buf→X
	LBSR Sub_13C2          ; call Sub_13C2
	BCC *+35  ; C=0 (BHS)
Sub_44B3:      LBRA Sub_0C5E         
Sub_44B6:      LDX #$0004            
	LBSR Sub_0F56          ; call Sub_0F56
	LBSR Sub_13C6          ; call Sub_13C6
	BCC *-12  ; C=0 (BHS)
	BRA *-45

; --------------------------------------------------------------
Sub_44C3:      LDA 44,U              
	OS9 I$Close            ; path=A
	CLR 35,U              
Sub_44CC:      LBRA Sub_0C5E         
Sub_44CF:      LBSR Sub_1CDE          ; call Sub_1CDE
	BRA *-6

; --------------------------------------------------------------
Sub_44D4:      LBSR Sub_2AC5          ; call Sub_2AC5
	CMPA #$03             
	BEQ *-22
	CMPA #$05             
	BEQ *-26
	BRA *-44

; --------------------------------------------------------------
Sub_44E1:      PSHS A,B,X,Y          
	LEAX 5033,U           
	LDD #$026A            
	STD ,X                
	LDD #$2020            
	STD 2,X               
	STD 4,X               
	LDA 62,U              
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_44FF:      PSHS A,B,X,Y          
	STA BSS.TxBufPtr,U    
	LSRA                  
	LSRA                  
	INCA                  
	LEAX 5033,U           
	CLRB                   ; B = 0
Sub_450B:      CMPA #$0A              ; compare A with LF
	BCS *+7  ; C=1 (BLO)
	SUBA #$0A             
	INCB                  
	BRA *-7

; --------------------------------------------------------------
Sub_4514:      ADDB #$30             
	ADDA #$30             
	CMPB #$30              ; compare B with '0'
	BNE *+4
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
Sub_451E:      STB 3,X               
	STA 4,X               
	LDD #$026A            
	STD ,X                
	LDA #$20               ; A = ' '
	STA 2,X               
	LDA #$4B               ; A = 'K'
	STA 5,X               
	LDA 62,U              
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_453B:      PSHS A,B,X,Y          
	LEAX 1805,U           
	LDB 3209,U            
	LDY 15,U              
Sub_4548:      LDA ,X+               
	STA ,Y+               
	DECB                  
	CMPY BSS.Var000B,U    
	BCS *+5  ; C=1 (BLO)
	LDY 13,U              
Sub_4555:      TSTB                  
	BNE *-14
	STY 15,U              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_455D:      PSHS A,B,X,Y          
	LDX 15,U              
Sub_4561:      LDA ,-X               
	CMPA #$2E              ; compare A with '.'
	BEQ *+18
Sub_4567:      CMPX 13,U             
	BNE *+4
	LDX BSS.Var000B,U     
Sub_456D:      CMPX 15,U             
	BNE *-14
	CLR 155,U             
Sub_4575:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_4577:      LDA 1,X               
	CMPA #$2E              ; compare A with '.'
	BCS *-20  ; C=1 (BLO)
	LDA -1,X              
	CMPA #$2E              ; compare A with '.'
	BCS *-26  ; C=1 (BLO)
Sub_4583:      LDA ,-X               
	CMPA #$30              ; compare A with '0'
	BCS *+8  ; C=1 (BLO)
	CMPX 15,U             
	BEQ *-30
	BRA *-10

; --------------------------------------------------------------
Sub_458F:      LDA 1,X               
	CMPA #$41              ; compare A with 'A'
	BCS *-38  ; C=1 (BLO)
	LDB #$1F              
	LEAX 1,X              
	LEAY 159,U            
Sub_459D:      LDA ,X+               
Sub_459F:      CMPA #$2E              ; compare A with '.'
	BCS *+23  ; C=1 (BLO)
	STA ,Y+               
	DECB                  
	BEQ *+18
	CMPX BSS.Var000B,U    
	BEQ *+8
	CMPX 15,U             
	BEQ *+10
	BRA *-19

; --------------------------------------------------------------
Sub_45B2:      LDA ,X                
	LDX 13,U              
	BRA *-23

; --------------------------------------------------------------
Sub_45B8:      LDA #$0D               ; A = CR
	STA ,Y                
	INC 155,U             
	BRA *-75

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
;      $0C57 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0C54).
;      Byte $01 at $0C57 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $01 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $01 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0C57 EQU Insn_0C54+3' resolves
;      to $0C57 at assembly time. Branches to Sub_0C57
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; ══════════════════════════════════════════════════════════════