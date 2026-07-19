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
; Disassembly:  /home/claude/SuperComm/supercomm23
; Module:       SuperComm
; Type:         program  ($11)
; Size:         $4717  (18199 bytes)
; Entry:        $0BB2
; BSS:          $2000  (8192 bytes)
; CRC-24:       $63F8C2
;
; ── PROCESSOR: Motorola 6309 required ──────────────────────────
; This module uses 6309-specific instructions and registers.
; It will NOT run on a stock CoCo 3 with a 6809 processor.
; ────────────────────────────────────────────────────────────────
; ==============================================================

; ----- Module Header -----
ModHeader
         FDB    $87CD             ; OS-9 module sync bytes
         FDB    ModEnd-$0000      ; module size
         FDB    ModName           ; name offset
         FCB    $11               ; type: program
         FCB    $81               ; language
         FCB    $78               ; attributes/parity
         FDB    Init              ; execution entry
         FDB    $2000             ; BSS size

; ----- Module Name -----
ModName
         FCS    "SuperComm"

; ==============================================================
; Pre-exec data  (post-name)—$0BB1
; Everything here is DATA — no executable code.
; ==============================================================

         FCB    $0A               ; LF
         FCC    "Program by Dave Philipsen Copyright (c) 1988, 1989, 1992, 1993 ('92/3 up"
         FCC    "dates by Randy K. Wilson)"

Dat_0078
; Referenced by: $0D51
         FCB    $00               ; NUL
         FCB    $53               ; 'S'
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.3"
         FCB    CurXY,$24,$23     ; CurXY(row=4,col=3)
         FCC    "Copyright (c)"
         FCB    CurXY,$23,$24     ; CurXY(row=3,col=4)
         FCC    "    1988, 1995"
         FCB    CurXY,$26,$26     ; CurXY(row=6,col=6)
         FCC    "written by"
         FCB    CurXY,$24,$27     ; CurXY(row=4,col=7)
         FCC    "Dave Philipsen"

Dat_00CD
; Referenced by: $0D70
         FCB    $00               ; NUL
         FCB    $23               ; '#'
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$22,$21     ; CurXY(row=2,col=1)
         FCC    "with updates by"
         FCB    CurXY,$22,$22     ; CurXY(row=2,col=2)
         FCC    " Randy Wilson"

Dat_00F2
; Referenced by: Sub_2D43
         FCB    $00               ; NUL
         FCB    $16               ; SYN insert-line
         FCB    CurXY,$40,$20     ; CurXY(row=32,col=0)
         FCC    "SuperComm v2.3 "
         FCB    CurXY,$58,$20     ; CurXY(row=56,col=0)
         FCB    $3D               ; '='

Dat_010A
; Referenced by: $1310
         FCB    $01               ; SOH
         FCB    $DB
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
         FCC    " L - Set Screen Colors   <Up>- Upload file"
         FDB    $0D0A             ; CRLF
         FCC    " M - Open/Close Buffer   <Dn>- Download File"
         FDB    $0D0A             ; CRLF
         FCC    " O - Change Options"
         FCB    $0A               ; LF
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    "     Select function or <Space> to continue"

Dat_02E7
; Referenced by: $2F2B
         FCC    "CONNEC"
         FCS    "T"

Dat_02EE
; Referenced by: $2F68
         FCC    "BUS"
         FCS    "Y"

Dat_02F2
; Referenced by: $1C52, Sub_351A
         FDB    Dat_02F6-Dat_02F2   ; # bytes this message
         FCB    $48               ; 'H'
         FCB    $0D               ; CR

Dat_02F6
; Referenced by: $196F
         FCC    "Shell"

Dat_02FB
; Referenced by: $196B
         FCB    $0D               ; CR

Dat_02FC
; Referenced by: $1A2B
         FCC    "rz"
         FCB    $0D               ; CR

Dat_02FF
; Referenced by: $1A27
         FCC    "-vv          "
         FCB    $0D               ; CR

Dat_030D
; Referenced by: $19EE
         FCB    $00               ; NUL
         FCB    $28               ; '('
         FCB    CurXY,$34,$20     ; CurXY(row=20,col=0)
         FCC    "External ZModem File Receive"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCB    ESC,W.CWArea,$02,$03,$3E,$07  ; CPX=2 CPY=3 SZX=62 SZY=7

Dat_0337
; Referenced by: $0E17, Sub_1290, $12B1
         FCB    $2A               ; '*'
         FCB    $18               ; CAN erase-BOL
         FCC    "B0"
         FCB    $00               ; NUL

Dat_033C
; Referenced by: $1B61
         FCC    "sz"
         FCB    $0D               ; CR

Dat_033F
; Referenced by: $1AD7
         FCC    "-vv"
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6

Dat_034E
; Referenced by: $1AC9
         FCB    $00               ; NUL
         FCB    $25               ; '%'
         FCB    CurXY,$36,$20     ; CurXY(row=22,col=0)
         FCC    "External ZModem File Send"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCB    ESC,W.CWArea,$02,$03,$3E,$07  ; CPX=2 CPY=3 SZX=62 SZY=7

Dat_0375
; Referenced by: $1BFD
         FCB    $00               ; NUL
         FCB    $0F               ; SI cursor-left
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    " Hanging Up!!"

Dat_0386
; Referenced by: Sub_0BFB
         FCC    "/t2"
         FCB    $0D               ; CR
         FCB    $00               ; NUL
         FCB    $00               ; NUL

Dat_038C
; Referenced by: $0CDB
         FCC    "/nil"
         FCB    $0D               ; CR
         FCB    $00               ; NUL

Dat_0392
; Referenced by: $0CBD, $19BF, $3002
         FCB    CurXY,$2B,$20     ; CurXY(row=11,col=0)
         FCC    "00:00:00"

Dat_039D
; Referenced by: $1E69
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

Dat_03AD
; Referenced by: Sub_1E8E
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

Dat_03BD
; Referenced by: $1E74
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

Dat_03CD
; Referenced by: Sub_159C
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

Dat_03D8
; Referenced by: $1936
         FCB    ESC,W.OWSet      ; Overlay Window Set
         FCB    $01               ; SVS=save+restore
         FCB    $00,$00,$50,$17  ; CPX=0 CPY=0 SZX=80 SZY=23
         FCB    $01,$01          ; PRN1=1 PRN2=1
         FCB    ESC,W.OWSet      ; Overlay Window Set
         FCB    $01               ; SVS=save+restore
         FCB    $02,$01,$4C,$15  ; CPX=2 CPY=1 SZX=76 SZY=21
         FCB    $06,$00          ; PRN1=6 PRN2=0

Dat_03EA
; Referenced by: $1352, Sub_1374
         FCB    $00               ; NUL
         FCB    $04               ; EOT

Dat_03EC
; Referenced by: $1990
         FDB    Dat_03F0-Dat_03EC   ; # bytes this message
         FCB    ESC,W.OWEnd      ; Overlay Window End

Dat_03F0
; Referenced by: $1FC8, $20CC
         FDB    Dat_03FC-Dat_03F0   ; # bytes this message
         FCB    BS,BS,BS,BS,BS,BS  ; BS×6
         FCB    BS,BS,BS,BS  ; BS×4

Dat_03FC
; Referenced by: $1920
         FCB    $00               ; NUL
         FCB    $0E               ; SO cursor-right

Dat_03FE
; Referenced by: $10B4
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

Dat_040C
; Referenced by: $1084
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

Dat_0434
; Referenced by: Sub_1098
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

Dat_045C
; Referenced by: $10AC
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

Dat_0484
; Referenced by: $0D34, $0DF3, Sub_12EB, $37D0
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $0C               ; FF clear+home

Dat_0487
; Referenced by: $12F8
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $04               ; EOT

Dat_048A
; Referenced by: $12E2
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $0B               ; VT cursor-up

Dat_048D
; Referenced by: Sub_1D76, $2877
         FDB    Dat_048F-Dat_048D   ; # bytes this message

Dat_048F
; Referenced by: $1539, $1D27, Sub_283E
         FCB    ESC,W.DWEnd      ; Device Window End
         FCB    ESC,W.DWSet,$02,$00,$01,$50,$17,$07,$02,$02   ; Device Window Set

Dat_049B
; Referenced by: $28C9
         FDB    Dat_049D-Dat_049B   ; # bytes this message

Dat_049D
; Referenced by: $1D81
         FDB    Dat_04A7-Dat_049D   ; # bytes this message
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $50               ; 'P'
         FCB    $01               ; SOH
         FCB    $03               ; ETX
         FCB    $04               ; EOT
         FCB    $0C               ; FF clear+home

Dat_04A7
; Referenced by: Sub_2D08, $2D8B
         FCB    ESC,W.FColor,$00         ; Foreground Color palette[0]
         FCB    ESC,W.Bcolor,$00         ; Background Color palette[0]
         FCB    $0C               ; FF clear+home
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $20               ; ' '

Dat_04B1
; Referenced by: $0D94, $1359, $137E, $1AAA, $1BC4, $1C60, $1DD1, $2016, Sub_2124, $21DB, $23C9, $2573, $2BF6, $2FEE, $30AF, $31EF, $366A, $36BF, $39D2, $41AA, $42B2, $4361
         FDB    Dat_04B5-Dat_04B1   ; # bytes this message
         FCB    $05               ; $05
         FCB    $21               ; '!'

Dat_04B5
; Referenced by: $0D3B, $1317, $19F5, $1B29, $1BF6, $1DC6, $1FA3, $20A9, $214F, $223F, $2561, $2ACF, Sub_2C17, $2FDE, $3099, $3155, Sub_363D, Sub_3692, $379C, $3817, $39C0, $3F25, $418E, $42A0
         FCB    $00               ; NUL
         FCB    CurXY,$05,$20     ; CurXY(row=-27,col=0)

Dat_04B9
; Referenced by: $2A0F
         FDB    Dat_04BF-Dat_04B9   ; # bytes this message
         FCB    $20               ; ' '
         FCB    $1F               ; $1F
         FCB    $21               ; '!'
         FCB    $08               ; BS

Dat_04BF
; Referenced by: $1DC0
         FCB    $00               ; NUL
         FCB    $16               ; SYN insert-line
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    " Are you sure? (y/N)"

Dat_04D7
; Referenced by: $34D6
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

Dat_0501
; Referenced by: $34E0
         FCB    $00               ; NUL
         FCB    $08               ; BS
         FCC    "Dialing "

Dat_050B
; Referenced by: $34EA, $35AA
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    CurXY,$37,$23     ; CurXY(row=23,col=3)

Dat_0510
; Referenced by: $3596
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCB    CurXY,$37,$25     ; CurXY(row=23,col=5)

Dat_0515
; Referenced by: $377F, $37D7
         FCB    $00               ; NUL
         FCC    "      Xmodem file transfer system"

Dat_0537
; Referenced by: $378A
         FCB    $00               ; NUL
         FCB    $09               ; HT
         FCB    CurXY,$20,$20     ; CurXY(row=0,col=0)
         FCC    "     Y"

Dat_0542
; Referenced by: $2509, $41A3
         FCB    $00               ; NUL
         FCB    $11               ; DC1/XON
         FCB    CurXY,$2B,$26     ; CurXY(row=11,col=6)
         FCC    "<Break> aborts"

Dat_0555
; Referenced by: Sub_3791, $383C, $3F69
         FDB    Dat_0585-Dat_0555   ; # bytes this message
         FCB    CurXY,$2A,$28     ; CurXY(row=10,col=8)
         FCC    "<Break> aborts"
         FCB    $00               ; NUL
         FCB    $1B               ; ESC windowing cmd
         FCB    CurXY,$25,$22     ; CurXY(row=5,col=2)
         FCC    "ASCII Processing? (Y/N) "

Dat_0585
; Referenced by: Sub_1AE7, $2C27, Sub_37A5, $420D, $4368
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCC    "File: "
         FCB    $04               ; EOT

Dat_0591
; Referenced by: $2AB4, $3804
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$21,$22     ; CurXY(row=1,col=2)
         FCC    "Recv: "
         FCB    $04               ; EOT

Dat_059D
; Referenced by: Sub_2AF8, $2DF8
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$21,$23     ; CurXY(row=1,col=3)
         FCC    "Size: "
         FCB    $04               ; EOT

Dat_05A9
; Referenced by: Sub_3F12
         FCB    $00               ; NUL
         FCB    $0E               ; SO cursor-right
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCB    $04               ; EOT
         FCB    CurXY,$21,$22     ; CurXY(row=1,col=2)
         FCC    "Send: "
         FCB    $04               ; EOT

Dat_05B9
; Referenced by: Sub_382E, Sub_3F62
         FCB    $00               ; NUL
         FCB    $22               ; '"'
         FCB    CurXY,$21,$25     ; CurXY(row=1,col=5)
         FCC    "Block #                 Error #"

Dat_05DD
; Referenced by: $3835
         FCB    $00               ; NUL
         FCB    $0E               ; SO cursor-right
         FCB    CurXY,$21,$27     ; CurXY(row=1,col=7)
         FCC    "Last Error:"

Dat_05ED
; Referenced by: $3867, $3BAC
         FDB    Dat_0651-Dat_05ED   ; # bytes this message
         FCC    "                  Transfer Aborted    Wrong Block Number  Block Check Fa"
         FCC    "iled  Time Out            "

Dat_0651
; Referenced by: $3E83
         FCB    $00               ; NUL
         FCB    $07               ; BEL
         FCB    CurXY,$28,$25     ; CurXY(row=8,col=5)
         FCC    "0000"

Dat_065A
; Referenced by: $3E9B
         FCB    $00               ; NUL
         FCB    $07               ; BEL
         FCB    CurXY,$40,$25     ; CurXY(row=32,col=5)
         FCC    "0000"

Dat_0663
; Referenced by: $1FB9
         FCB    $00               ; NUL
         FCB    $14               ; DC4 erase-EOL
         FCB    $0A               ; LF
         FCB    $0D               ; CR
         FCC    " Baud Rate:       "

Dat_0679
; Referenced by: $13FA, $1FD5, $2EEA
         FDB    Dat_06E1-Dat_0679   ; # bytes this message
         FCC    "0   300   600   1200  2400  4800  9600  19200 38400 57600 76800 115200  "
         FCC    "                      "
         FCB    $00               ; NUL
         FCB    $06               ; $06
         FCB    ESC,W.CWArea,$01,$02,$04,$09  ; CPX=1 CPY=2 SZX=4 SZY=9

Dat_06E1
; Referenced by: $3209
         FDB    Dat_06E7-Dat_06E1   ; # bytes this message
         FCB    $08               ; BS
         FCC    "   "

Dat_06E7
; Referenced by: $204B
         FDB    Dat_06F2-Dat_06E7   ; # bytes this message
         FCB    LF,LF,LF,LF,LF,LF  ; LF×6
         FCB    LF,LF,LF  ; LF×3

Dat_06F2
; Referenced by: $2054, $3197
         FDB    Dat_06F5-Dat_06F2   ; # bytes this message
         FCB    $3E               ; '>'

Dat_06F5
; Referenced by: $20BF
         FCB    $00               ; NUL
         FCB    $18               ; CAN erase-BOL
         FCB    $0A               ; LF
         FCB    $0D               ; CR
         FCC    " Terminal Type :      "

Dat_070F
; Referenced by: $20D9
         FCC    "OS9  ASCIIANSI "

Dat_071E
; Referenced by: $3B6D, $3F8A
         FDB    Dat_0726-Dat_071E   ; # bytes this message
         FCC    "!ASCII"

Dat_0726
; Referenced by: $385A, $3F2C
         FCB    $00               ; NUL
         FCB    $08               ; BS
         FCB    CurXY,$30,$21     ; CurXY(row=16,col=1)
         FCC    "     "

Dat_0730
; Referenced by: $32C7
         FCC    "AD"
         FCS    "S"
         FCC    "BP"
         FCS    "S"
         FCC    "EC"
         FCS    "H"
         FCC    "HE"
         FCS    "K"
         FCC    "TR"
         FCS    "M"
         FCC    "LN"
         FCS    "F"
         FCC    "XO"
         FCS    "N"
         FCC    "XO"
         FCS    "F"
         FCC    "RT"
         FCS    "R"
         FCC    "RP"
         FCS    "S"
         FCC    "PA"
         FCS    "R"
         FCC    "CL"
         FCS    "K"
         FCC    "WR"
         FCS    "D"
         FCC    "ST"
         FCS    "P"
         FCC    "KM"
         FCS    "1"
         FCC    "KM"
         FCS    "2"
         FCC    "KM"

Dat_0762
         FCB    $B3
         FCC    "KM"
         FCS    "4"
         FCC    "KM"
         FCS    "5"
         FCC    "KM"
         FCS    "6"
         FCC    "KM"
         FCS    "7"
         FCC    "KM"
         FCS    "8"
         FCC    "CN"
         FCS    "S"
         FCC    "SS"
         FCS    "1"
         FCC    "SS"
         FCS    "2"
         FCC    "SS"
         FCS    "3"
         FCC    "SS"
         FCS    "4"
         FCC    "RS"
         FCS    "1"
         FCC    "RS"
         FCS    "2"
         FCC    "RS"
         FCS    "3"
         FCC    "RS"
         FCS    "4"
         FCC    "RL"
         FCS    "F"
         FCC    "TL"
         FCS    "F"

Dat_0793
; Referenced by: $3656
         FCB    $00               ; NUL
         FCC    "o SuperComm File Receive"
         FDB    $0D0A             ; CRLF
         FCB    $0A               ; LF
         FCC    "     ASCII Receive"
         FDB    $0D0A             ; CRLF
         FCC    "     XModem (and X-1k)"
         FDB    $0D0A             ; CRLF
         FCC    "     YModem Batch"
         FDB    $0D0A             ; CRLF
         FCC    "     ZModem (external)"

Dat_0804
; Referenced by: $36AB
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

Dat_0880
; Referenced by: $2255
         FDB    Dat_0915-Dat_0880   ; # bytes this message
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

Dat_0915
; Referenced by: $2184
         FDB    Dat_09B4-Dat_0915   ; # bytes this message
         FCC    "        Change Colors"
         FCB    ESC,W.CWArea,$05,$02,$1C,$0B  ; CPX=5 CPY=2 SZX=28 SZY=11
         FCC    "Main Fore"
         FDB    $0D0A             ; CRLF
         FCC    "Main Back"
         FDB    $0D0A             ; CRLF
         FCC    "Status Fore"
         FDB    $0D0A             ; CRLF
         FCC    "Status Back"
         FDB    $0D0A             ; CRLF
         FCC    "Status Alt"
         FDB    $0D0A             ; CRLF
         FCC    "Overlay Fore"
         FDB    $0D0A             ; CRLF
         FCC    "Overlay Back"
         FDB    $0D0A             ; CRLF
         FCC    "Overlay Shadow"
         FDB    $0D0A             ; CRLF
         FCC    "Conf Fore"
         FDB    $0D0A             ; CRLF
         FCC    "Conf Back"
         FCB    ESC,W.CWArea,$00,$00,$21,$0D  ; CPX=0 CPY=0 SZX=33 SZY=13

Dat_09B4
; Referenced by: $2FE5
         FCB    $00               ; NUL
         FCB    $17               ; ETB delete-line
         FCB    $0D               ; CR
         FCB    $0A               ; LF
         FCC    " Saving  SuperComm..."

Dat_09CD
; Referenced by: $419C
         FCB    $00               ; NUL
         FCB    $17               ; ETB delete-line
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$29,$20     ; CurXY(row=9,col=0)
         FCC    "File Capture System"

Dat_09E6
; Referenced by: $41C9
         FCB    $00               ; NUL


; & and quote chars -- emitted as FCB to avoid FCC string embedding issues
         FCB    $26
         FCB    $22
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCC    "is already open.  Close it? (Y/n) "

Dat_0A0E
; Referenced by: Sub_435A
         FCB    $00               ; NUL
         FCB    $13               ; DC3/XOFF
         FCB    CurXY,$2B,$22     ; CurXY(row=11,col=2)
         FCB    $03               ; ETX
         FCC    "Send ASCII file"

Dat_0A23
; Referenced by: $41B5
         FDB    Dat_0A29-Dat_0A23   ; # bytes this message
         FCB    CurXY,$21,$22     ; CurXY(row=1,col=2)
         FCB    $22               ; '"'

Dat_0A29
; Referenced by: $4244
         FCB    $00               ; NUL
         FCB    $33               ; '3'
         FCB    CurXY,$29,$20     ; CurXY(row=9,col=0)
         FCC    "File already exists!"
         FCB    CurXY,$26,$22     ; CurXY(row=6,col=2)
         FCC    "<A>ppend or <O>verwrite? "

Dat_0A5E
; Referenced by: Sub_25E8
         FCB    $00               ; NUL
         FCB    $0B               ; VT cursor-up
         FCB    CurXY,$6E,$20     ; CurXY(row=78,col=0)
         FCB    $1F               ; $1F
         FCB    $24               ; '$'
         FCB    ESC,W.FColor,$03         ; Foreground Color palette[3]
         FCB    $42               ; 'B'
         FCB    $1F               ; $1F
         FCB    $25               ; '%'
         FCB    $00               ; NUL
         FCB    $0A               ; LF
         FCB    CurXY,$6E,$20     ; CurXY(row=78,col=0)
         FCB    ESC,W.FColor,$00         ; Foreground Color palette[0]
         FCB    $42               ; 'B'
         FCB    ESC,W.FColor,$03         ; Foreground Color palette[3]

Dat_0A77
; Referenced by: $2455
         FCB    $00               ; NUL
         FCB    $04               ; EOT
         FCC    "DTR"
         FCB    $04               ; EOT

Dat_0A7D
; Referenced by: Sub_245C
         FCB    $00               ; NUL
         FCB    $04               ; EOT

Dat_0A7F
; Referenced by: Sub_1C38
         FDB    Dat_0A83-Dat_0A7F   ; # bytes this message
         FCB    $2B               ; '+'
         FCB    $04               ; EOT

Dat_0A83
; Referenced by: Sub_23DF
         FCB    $00               ; NUL
         FCB    $04               ; EOT
         FCC    "Off"
         FCB    $04               ; EOT

Dat_0A89
; Referenced by: Sub_23E8
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCC    "On"
         FCB    $04               ; EOT

Dat_0A8E
; Referenced by: $2474
         FCB    $20               ; ' '

Dat_0A8F
; Referenced by: $144B
         FCC    "Mark"

Dat_0A93
; Referenced by: $1455, $247E
         FCC    "Space"

Dat_0A98
; Referenced by: Insn_2488
         FCB    $20               ; ' '

Dat_0A99
; Referenced by: $145F
         FCC    "Even"

Dat_0A9D
; Referenced by: $2492
         FCB    $20               ; ' '

Dat_0A9E
; Referenced by: $1469
         FCC    "Odd "

Dat_0AA2
; Referenced by: Sub_2498
         FCB    $20               ; ' '

Dat_0AA3
; Referenced by: Sub_146F
         FCC    "None"
         FCB    $00               ; NUL
         FCB    $36               ; '6'
         FCB    CurXY,$28,$20     ; CurXY(row=8,col=0)
         FCC    "Change Data Directory"
         FCB    CurXY,$29,$25     ; CurXY(row=9,col=5)
         FCC    "(use full pathname)"
         FCB    CurXY,$21,$24     ; CurXY(row=1,col=4)
         FCC    "Path:"

Dat_0ADF
; Referenced by: $222A
         FDB    Dat_0B17-Dat_0ADF   ; # bytes this message
         FCC    "ite  Blue   Black  Green  Red    Yellow MagentaCyan   "

Dat_0B17
; Referenced by: $290A
         FDB    Dat_0B1E-Dat_0B17   ; # bytes this message
         FCC    "     "

Dat_0B1E
; Referenced by: $28B8, $2D38
         FDB    Dat_0B2B-Dat_0B1E   ; # bytes this message
         FCC    " Conf"
         FCB    ESC,W.CWArea,$00,$01,$50,$02  ; CPX=0 CPY=1 SZX=80 SZY=2

Dat_0B2B
; Referenced by: $2B54, $2DD9
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
         FCB    $E8
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $64               ; 'd'
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $0A               ; LF
         FCB    NUL,NUL,NUL  ; NUL×3
         FCB    $01               ; SOH
         FCB    NUL,NUL,NUL,NUL  ; NUL×4

Dat_0B4B
         FCB    $0F               ; SI cursor-left

Dat_0B4C
; Referenced by: $133D
         FCC    "ABCDHILMOQRSTUZ"

Dat_0B5B
; Referenced by: $0CA6, $2FC1
         FCB    $04               ; EOT
         FCB    $01               ; SOH
         FCB    NUL,NUL,NUL,NUL,NUL,NUL  ; NUL×6
         FCB    $01               ; SOH
         FCB    $00               ; NUL
         FCB    $11               ; DC1/XON
         FCB    $13               ; DC3/XOFF
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    CurXY,$00,$01     ; CurXY(row=-32,col=-31)
         FCB    CurXY,$00,$01     ; CurXY(row=-32,col=-31)
         FCB    $06               ; $06
         FCB    $07               ; BEL
         FCB    $02               ; CurXY

Dat_0B72
; Referenced by: $303D, $325C
         FCC    "/dd/sys/dia"
         FCS    "l"
         FCC    "               "

Dat_0B8D
         FCC    "     "

Dat_0B92
; Referenced by: $0CB6
         FCC    "/dd"
         FCB    $0D               ; CR
         FCC    "                            "

; ==============================================================
; Code section  $0BB2—$4713  (15202 bytes)
; ==============================================================

$0BB2  9F 00               Init:          STX <$00              
$0BB4  30 1D                              LEAX -3,X             
$0BB6  9F 02                              STX <$02              
$0BB8  8E 00 12                           LDX #$0012            
$0BBB  6F 80               Sub_0BBB:      CLR ,X+               
$0BBD  9C 02                              CMPX <$02             
$0BBF  25 FA                              BCS Sub_0BBB           ; C=1 (BLO)
$0BC1  9E 00                              LDX <$00              
$0BC3  30 88 80                           LEAX -128,X           
$0BC6  9F 02                              STX <$02              
$0BC8  32 7F                              LEAS -1,S             
$0BCA  8E 16 D3                           LDX #$16D3            
$0BCD  9F 04                              STX <$04              
$0BCF  9F 06                              STX <$06              
$0BD1  30 1F                              LEAX -1,X             
$0BD3  9F 0C                              STX <$0C              
$0BD5  8E 14 D3                           LDX #$14D3            
$0BD8  9F 0E                              STX <$0E              
$0BDA  9F 10                              STX <$10              
$0BDC  CC 00 00                           LDD #$0000            
$0BDF  DD 0A                              STD <$0A              
$0BE1  9E 00                              LDX <$00              
$0BE3  86 20                              LDA #$20               ; A = ' '
$0BE5  A7 1F                              STA -1,X              
$0BE7  A6 80               Sub_0BE7:      LDA ,X+               
$0BE9  81 0D                              CMPA #$0D              ; compare A with CR
$0BEB  27 0E                              BEQ Sub_0BFB          
$0BED  81 2F                              CMPA #$2F              ; compare A with '/'
$0BEF  26 F6                              BNE Sub_0BE7          
$0BF1  A6 1E                              LDA -2,X              
$0BF3  81 20                              CMPA #$20              ; compare A with ' '
$0BF5  26 F0                              BNE Sub_0BE7          
$0BF7  30 1F                              LEAX -1,X             
$0BF9  20 04                              BRA Sub_0BFF          

; --------------------------------------------------------------
$0BFB  30 8D F7 87         Sub_0BFB:      LEAX Dat_0386,PC       ; X → Dat_0386
$0BFF  10 8E 00 3A         Sub_0BFF:      LDY #$003A            
$0C03  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$0C05  A6 80               Sub_0C05:      LDA ,X+               
$0C07  81 0D                              CMPA #$0D              ; compare A with CR
$0C09  27 05                              BEQ Sub_0C10          
$0C0B  A7 A0                              STA ,Y+               
$0C0D  5A                                 DECB                  
$0C0E  26 F5                              BNE Sub_0C05          
$0C10  A7 A0               Sub_0C10:      STA ,Y+               
$0C12  86 FF                              LDA #$FF              
$0C14  97 37                              STA <$37              
$0C16  97 4F                              STA <$4F              
$0C18  8E 00 EC                           LDX #$00EC            
$0C1A  EC CC 00            Insn_0C1A:     LDD Dat_0C1D,PC       

Dat_0C1D
; ── 1 bytes  ($0C1D—$0C1D) ──
         FCB    $00               ; NUL
$0C1E  DD 12               Sub_0C1E:      STD <$12              
$0C20  ED 84                              STD ,X                
$0C22  ED 02                              STD 2,X               
$0C24  ED 04                              STD 4,X               
$0C26  E7 06                              STB 6,X               
$0C28  1F 10                              TFR X,D               
$0C2A  8E 00 7C                           LDX #$007C            
$0C2D  10 8E 00 01                        LDY #$0001            
$0C31  34 40                              PSHS U                
$0C33  CE 00 28                           LDU #$0028            
$0C36  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$0C39  35 40                              PULS U                
$0C3B  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0C3C  28 26                              BVC Sub_0C64          
$0C3E  14                                 FCB    $14                ; undefined opcode $14 -- not a valid 6809 instruction
$0C3F  CC 00 EC                           LDD #$00EC            
$0C42  10 8E 00 01                        LDY #$0001            
$0C46  8E 00 3A            Insn_0C46:     LDX #$003A            
$0C47  00                  Sub_0C47:      EQU    $0C47            ; [*1] branch target 1 byte(s) inside Insn_0C46 -- see [*1]
$0C48  3A                                 ABX                   
$0C49  34 40                              PSHS U                
$0C4B  CE 00 28                           LDU #$0028            
$0C4E  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$0C51  35 40                              PULS U                
$0C53  34 80               Sub_0C53:      PSHS PC               
$0C55  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0C56  28 27                              BVC Sub_0C7F          
$0C58  12                                 NOP                   
$0C59  CC 22 0E                           LDD #$220E            
$0C5C  E3 E4                              ADDD ,S               
$0C5E  FD 0C AF            Insn_0C5E:     STD $0CAF             
$0C5F  0C                  Sub_0C5F:      EQU    $0C5F            ; [*2] branch target 1 byte(s) inside Insn_0C5E -- see [*2]
$0C60  AF CC 22                           STX Sub_0C85,PC       
$0C63  15                                 FCB    $15                ; undefined opcode $15 -- not a valid 6809 instruction
$0C64  E3 E1               Sub_0C64:      ADDD ,S++             
$0C66  FD 0C B1                           STD $0CB1             
$0C69  20 10                              BRA Sub_0C7B          

; --------------------------------------------------------------
$0C6B  CC 21 FE            Sub_0C6B:      LDD #$21FE            
$0C6C  21 FE               Sub_0C6C:      BRN Sub_0C6C          
$0C6E  E3 E4                              ADDD ,S               
$0C70  FD 0C AF                           STD $0CAF             
$0C73  CC 22 06                           LDD #$2206            
$0C76  E3 E1                              ADDD ,S++             
$0C78  FD 0C B1            Insn_0C78:     STD $0CB1             
$0C79  0C                  Sub_0C79:      EQU    $0C79            ; [*3] branch target 1 byte(s) inside Insn_0C78 -- see [*3]
$0C7A  B1 17 08                           CMPA $1708            
$0C7B  17 08 61            Sub_0C7B:      LBSR Sub_14DF          ; call Sub_14DF
$0C7E  10 25 04 85                        LBCS Sub_1107         
$0C7F  25 04               Sub_0C7F:      BCS Sub_0C85           ; C=1 (BLO)
$0C81  85 17                              BITA #$17             
$0C83  10 8E 10 25                        LDY #$1025            
$0C85  10 25 04 7E         Sub_0C85:      LBCS Sub_1107         
$0C89  86 01                              LDA #$01              
$0C8B  97 70                              STA <$70              
$0C8D  8E 00 01                           LDX #$0001            
$0C90  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$0C93  86 01                              LDA #$01              
$0C95  C6 92                              LDB #$92              
$0C97  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0C9A  25 2F                              BCS Sub_0CCB           ; C=1 (BLO)
$0C9C  1F 10                              TFR X,D               
$0C9E  F7 0C 91                           STB $0C91             
$0CA1  BA 0C 91                           ORA $0C91             
$0CA4  97 70                              STA <$70              
$0CA6  30 8D FE B1                        LEAX Dat_0B5B,PC       ; X → Dat_0B5B
$0CAA  10 8E 0C BA                        LDY #$0CBA            
$0CAE  C6 4D                              LDB #$4D               ; B = 'M'
$0CB0  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$0CB4  86 03                              LDA #$03              
$0CB6  30 8D FE D8                        LEAX Dat_0B92,PC       ; X → Dat_0B92
$0CBA  10 3F 86                           OS9 I$ChgDir           ; mode=B  name→X
$0CBD  30 8D F6 D1                        LEAX Dat_0392,PC       ; X → Dat_0392
$0CC1  10 8E 00 80                        LDY #$0080            
$0CC5  C6 0B                              LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
$0CC7  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$0CCB  17 11 95            Sub_0CCB:      LBSR Sub_1E63          ; call Sub_1E63
$0CCE  17 12 06                           LBSR Sub_1ED7          ; call Sub_1ED7
$0CD1  17 11 78                           LBSR Sub_1E4C          ; call Sub_1E4C
$0CD4  30 8D 04 32                        LEAX Sub_110A,PC       ; X → Sub_110A
$0CD8  10 3F 09                           OS9 F$Icpt             ; handler→X  data→U
$0CDB  30 8D F6 AD                        LEAX Dat_038C,PC       ; X → Dat_038C
$0CDF  86 03                              LDA #$03              
$0CE1  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$0CE4  25 34                              BCS Sub_0D1A           ; C=1 (BLO)
$0CE6  97 7B                              STA <$7B              
$0CE8  C6 81                              LDB #$81              
$0CEA  10 8E 00 01                        LDY #$0001            
$0CEE  8E 00 3C                           LDX #$003C            
$0CF1  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$0CF4  25 1D                              BCS Sub_0D13           ; C=1 (BLO)
$0CF6  96 7B                              LDA <$7B              
$0CF8  10 8E 08 00                        LDY #$0800            
$0CFC  8E 08 00                           LDX #$0800            
$0CFF  C6 80                              LDB #$80              
$0D01  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0D04  25 0D                              BCS Sub_0D13           ; C=1 (BLO)
$0D06  8C 08 00                           CMPX #$0800           
$0D09  24 08                              BCC Sub_0D13           ; C=0 (BHS)
$0D0B  10 8C 08 00                        CMPY #$0800           
$0D0F  24 02                              BCC Sub_0D13           ; C=0 (BHS)
$0D11  20 07                              BRA Sub_0D1A          

; --------------------------------------------------------------
$0D13  96 7B               Sub_0D13:      LDA <$7B              
$0D15  10 3F 8F                           OS9 I$Close            ; path=A
$0D18  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0D19  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$0D1A  8E 05 1C            Sub_0D1A:      LDX #$051C            
$0D1D  9F 71                              STX <$71              
$0D1F  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$0D21  F7 0D 38                           STB $0D38             
$0D24  4F                                 CLRA                   ; A = 0
$0D25  C6 07                              LDB #$07              
$0D27  F7 0C B9                           STB $0CB9             
$0D2A  C6 14                              LDB #$14              
$0D2C  B7 0D 39                           STA $0D39             
$0D2F  CC 1B 32                           LDD #$1B32             ; D=ESC+'2'  → W.FColor: Foreground Color
$0D32  DD A9                              STD <$A9              
$0D34  30 8D F7 4C                        LEAX Dat_0484,PC       ; X → Dat_0484
$0D38  17 10 5A                           LBSR Sub_1D95          ; call Sub_1D95
$0D3B  30 8D F7 76                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$0D3F  17 10 53                           LBSR Sub_1D95          ; call Sub_1D95
$0D42  CC 1A 04                           LDD #$1A04            
$0D45  FD 0C 9A                           STD $0C9A             
$0D48  CC 16 09            Insn_0D48:     LDD #$1609            
$0D4A  09                  Sub_0D4A:      EQU    $0D4A            ; [*4] branch target 2 byte(s) inside Insn_0D48 -- see [*4]
$0D4B  FD 0C 9C                           STD $0C9C             
$0D4E  17 11 A0                           LBSR Sub_1EF1          ; call Sub_1EF1
$0D51  30 8D F3 23                        LEAX Dat_0078,PC       ; X → Dat_0078
$0D55  17 10 3D                           LBSR Sub_1D95          ; call Sub_1D95
$0D58  17 10 1B                           LBSR Sub_1D76          ; call Sub_1D76
$0D5B  8E 00 1C                           LDX #$001C            
$0D5E  17 04 17                           LBSR Sub_1178          ; call Sub_1178
$0D61  CC 32 10                           LDD #$3210            
$0D64  FD 0C 9A                           STD $0C9A             
$0D67  CC 13 04                           LDD #$1304            
$0D6A  FD 0C 9C                           STD $0C9C             
$0D6D  17 11 81                           LBSR Sub_1EF1          ; call Sub_1EF1
$0D70  30 8D F3 59                        LEAX Dat_00CD,PC       ; X → Dat_00CD
$0D74  17 10 1E                           LBSR Sub_1D95          ; call Sub_1D95
$0D77  17 2E 52                           LBSR Sub_3BCC          ; call Sub_3BCC
$0D7A  4F                  Sub_0D7A:      CLRA                   ; A = 0
$0D7B  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$0D7D  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0D80  24 09                              BCC Sub_0D8B           ; C=0 (BHS)
$0D82  17 2E 60                           LBSR Sub_3BE5          ; call Sub_3BE5
$0D85  81 0A                              CMPA #$0A              ; compare A with LF
$0D87  25 F1                              BCS Sub_0D7A           ; C=1 (BLO)
$0D89  20 03                              BRA Sub_0D8E          

; --------------------------------------------------------------
$0D8B  17 1E D4            Sub_0D8B:      LBSR Sub_2C62          ; call Sub_2C62
$0D8E  17 11 C2            Sub_0D8E:      LBSR Sub_1F53          ; call Sub_1F53
$0D91  17 11 BF                           LBSR Sub_1F53          ; call Sub_1F53
$0D94  30 8D F7 19                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$0D98  17 0F FA                           LBSR Sub_1D95          ; call Sub_1D95
$0D9B  86 03                              LDA #$03              
$0D9D  8E 00 3A                           LDX #$003A            
$0DA0  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$0DA3  10 25 03 60                        LBCS Sub_1107         
$0DA7  97 38                              STA <$38              
$0DA9  C6 D2                              LDB #$D2              
$0DAB  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$0DAE  24 03                              BCC Sub_0DB3           ; C=0 (BHS)
$0DB0  4F                                 CLRA                   ; A = 0
$0DB1  20 11                              BRA Sub_0DC4          

; --------------------------------------------------------------
$0DB3  84 0F               Sub_0DB3:      ANDA #$0F             
$0DB5  B7 0C B9                           STA $0CB9             
$0DB8  BF 0C B7                           STX $0CB7             
$0DBB  1F 10                              TFR X,D               
$0DBD  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0DBE  29 5D                              BVS Sub_0E1D          
$0DC0  27 02                              BEQ Sub_0DC4          
$0DC2  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0DC3  29 85                              BVS Sub_0D4A          
$0DC4  85 01               Sub_0DC4:      BITA #$01             
$0DC6  34 80                              PSHS PC               
$0DC8  26 07                              BNE Sub_0DD1          
$0DCA  CC 03 53                           LDD #$0353            
$0DCD  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0DCE  1F 20                              TFR Y,D               
$0DD0  05                                 FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
$0DD1  CC 03 49            Sub_0DD1:      LDD #$0349            
$0DD4  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0DD5  1F E3                              TFR E,U               
$0DD7  E4 FD 0C B3                        ANDB [+3251,PC]       
$0DDB  B6 0C B7                           LDA $0CB7             
$0DDE  85 02                              BITA #$02             
$0DE0  26 07                              BNE Sub_0DE9          
$0DE2  CC 03 75                           LDD #$0375            
$0DE5  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$0DE6  1E 20                              EXG Y,D               
$0DE8  05                                 FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
$0DE9  CC 03 6C            Sub_0DE9:      LDD #$036C            
$0DEC  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0DED  1E E3                              EXG E,U               
$0DEF  E1 FD 0C B5                        CMPB [+3253,PC]       
$0DF3  30 8D F6 8D                        LEAX Dat_0484,PC       ; X → Dat_0484
$0DF7  17 0F 9B                           LBSR Sub_1D95          ; call Sub_1D95
$0DFA  17 05 8B                           LBSR Sub_1388          ; call Sub_1388
$0DFD  17 1F 08                           LBSR Sub_2D08          ; call Sub_2D08
$0E00  17 36 F0                           LBSR Sub_44F3          ; call Sub_44F3
$0E03  17 35 0D                           LBSR Sub_4313          ; call Sub_4313
$0E06  CC 01 01                           LDD #$0101            
$0E09  FD 0C 9E                           STD $0C9E             
$0E0C  17 1E 83                           LBSR Sub_2C92          ; call Sub_2C92
$0E0F  17 07 17                           LBSR Sub_1529          ; call Sub_1529
$0E12  17 06 90                           LBSR Sub_14A5          ; call Sub_14A5
$0E15  86 00                              LDA #$00               ; A = NUL
$0E17  30 8D F5 1C                        LEAX Dat_0337,PC       ; X → Dat_0337
$0E1B  9F 77                              STX <$77              
$0E1D  8E 06 1B            Sub_0E1D:      LDX #$061B            
$0E20  10 8E 00 01                        LDY #$0001            
$0E24  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$0E27  16 09 15                           LBRA Sub_173F         

; --------------------------------------------------------------
$0E2A  8E 00 EC            Sub_0E2A:      LDX #$00EC            
$0E2D  96 38                              LDA <$38              
$0E2F  AD 9F 0C B3                        JSR [$0CB3]            ; call via indexed pointer
$0E33  10 24 03 A9                        LBCC Sub_11E0         
$0E37  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0E38  32 10                              LEAS -16,X            
$0E3A  26 35                              BNE Sub_0E71          
$0E3C  7F 8E 00                           CLR $8E00             
$0E3F  03                                 FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
$0E40  17 03 35                           LBSR Sub_1178          ; call Sub_1178
$0E43  17 07 5E                           LBSR Sub_15A4          ; call Sub_15A4
$0E46  25 E2                              BCS Sub_0E2A           ; C=1 (BLO)
$0E48  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$0E49  4D                                 TSTA                  
$0E4A  10 26 1A CB                        LBNE Sub_2919         
$0E4E  16 08 E2                           LBRA Sub_1733         

; --------------------------------------------------------------
$0E51  8E 00 EC            Sub_0E51:      LDX #$00EC            
$0E54  10 8E 07 1A                        LDY #$071A            
$0E58  F6 0C 96                           LDB $0C96             
$0E5B  A6 80               Sub_0E5B:      LDA ,X+               
$0E5D  84 7F                              ANDA #$7F             
$0E5F  81 20                              CMPA #$20              ; compare A with ' '
$0E61  25 09                              BCS Sub_0E6C           ; C=1 (BLO)
$0E63  17 07 4A                           LBSR Sub_15B0          ; call Sub_15B0
$0E66  A7 A0               Sub_0E66:      STA ,Y+               
$0E68  5A                  Sub_0E68:      DECB                  
$0E69  26 F0                              BNE Sub_0E5B          
$0E6B  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$0E6C  81 08               Sub_0E6C:      CMPA #$08              ; compare A with BS
$0E6E  26 05                              BNE Sub_0E75          
$0E70  17 07 54            Insn_0E70:     LBSR Sub_15C7          ; call Sub_15C7
$0E71  07                  Sub_0E71:      EQU    $0E71            ; [*5] branch target 1 byte(s) inside Insn_0E70 -- see [*5]
$0E72  54                                 LSRB                  
$0E73  20 F1                              BRA Sub_0E66          

; --------------------------------------------------------------
$0E75  81 0D               Sub_0E75:      CMPA #$0D              ; compare A with CR
$0E77  26 14                              BNE Sub_0E8D          
$0E79  17 07 60                           LBSR Sub_15DC          ; call Sub_15DC
$0E7C  7D 0C BD                           TST $0CBD             
$0E7F  27 E5                              BEQ Sub_0E66          
$0E81  17 07 5F                           LBSR Sub_15E3          ; call Sub_15E3
$0E84  7C 0C 96                           INC $0C96             
$0E87  A7 A0                              STA ,Y+               
$0E89  86 0A                              LDA #$0A               ; A = LF
$0E8B  20 D9                              BRA Sub_0E66          

; --------------------------------------------------------------
$0E8D  81 0C               Sub_0E8D:      CMPA #$0C              ; compare A with FF
$0E8F  26 05                              BNE Sub_0E96          
$0E91  17 07 5F                           LBSR Sub_15F3          ; call Sub_15F3
$0E94  20 D0                              BRA Sub_0E66          

; --------------------------------------------------------------
$0E96  81 07               Sub_0E96:      CMPA #$07             
$0E98  27 CC                              BEQ Sub_0E66          
$0E9A  81 0A                              CMPA #$0A              ; compare A with LF
$0E9C  26 05                              BNE Sub_0EA3          
$0E9E  17 07 42                           LBSR Sub_15E3          ; call Sub_15E3
$0EA1  20 C3                              BRA Sub_0E66          

; --------------------------------------------------------------
$0EA3  81 09               Sub_0EA3:      CMPA #$09             
$0EA5  26 02                              BNE Sub_0EA9          
$0EA7  8D 62                              BSR Sub_0F0B           ; call Sub_0F0B
$0EA9  7A 0C 96            Sub_0EA9:      DEC $0C96             
$0EAC  20 BA                              BRA Sub_0E68          

; --------------------------------------------------------------
$0EAE  8E 00 EC            Sub_0EAE:      LDX #$00EC            
$0EB1  10 8E 07 1A                        LDY #$071A            
$0EB5  F6 0C 96                           LDB $0C96             
$0EB7  96 0D               Insn_0EB7:     LDA <$0D              
$0EB8  0D                  Sub_0EB8:      EQU    $0EB8            ; [*6] branch target 1 byte(s) inside Insn_0EB7 -- see [*6]
$0EB9  6E 2B                              JMP 11,Y              
$0EBB  1D                                 SEX                    ; sign-extend B into A
$0EBC  10 26 00 C2                        LBNE Sub_0F82         
$0EC0  A6 80                              LDA ,X+               
$0EC2  81 20                              CMPA #$20              ; compare A with ' '
$0EC4  25 22                              BCS Sub_0EE8           ; C=1 (BLO)
$0EC6  81 80                              CMPA #$80             
$0EC8  25 02                              BCS Sub_0ECC           ; C=1 (BLO)
$0ECA  86 2A                              LDA #$2A               ; A = '*'
$0ECC  17 06 E1            Sub_0ECC:      LBSR Sub_15B0          ; call Sub_15B0
$0ECF  A7 A0               Sub_0ECF:      STA ,Y+               
$0ED1  5A                  Sub_0ED1:      DECB                  
$0ED2  26 E4                              BNE Sub_0EB8          
$0ED4  39                  Insn_0ED4:     RTS                    ; return from subroutine
$0ED5  0F                  Sub_0ED5:      EQU    $0ED5            ; [*7] branch target 1 byte(s) inside Insn_0ED4 -- see [*7]
$0ED6  6E 20                              JMP 0,Y               
$0ED8  F6 A6 80                           LDB $A680             
$0ED9  A6 80               Sub_0ED9:      LDA ,X+               
$0EDB  81 5B                              CMPA #$5B              ; compare A with '['
$0EDD  26 F6                              BNE Sub_0ED5          
$0EDF  86 01                              LDA #$01              
$0EE1  97 6E                              STA <$6E              
$0EE3  7A 0C 96            Insn_0EE3:     DEC $0C96             
$0EE4  0C                  Sub_0EE4:      EQU    $0EE4            ; [*8] branch target 1 byte(s) inside Insn_0EE3 -- see [*8]
$0EE5  96 20                              LDA <$20              
$0EE7  E9 81                              ADCB ,X++             
$0EE8  81 08               Sub_0EE8:      CMPA #$08              ; compare A with BS
$0EEA  27 37               Sub_0EEA:      BEQ Sub_0F23          
$0EEC  81 0D                              CMPA #$0D              ; compare A with CR
$0EEE  27 43                              BEQ Sub_0F33          
$0EF0  81 0A                              CMPA #$0A              ; compare A with LF
$0EF2  27 53                              BEQ Sub_0F47          
$0EF4  81 0C                              CMPA #$0C              ; compare A with FF
$0EF6  27 54                              BEQ Sub_0F4C          
$0EF8  81 07                              CMPA #$07             
$0EFA  27 D0                              BEQ Sub_0ECC          
$0EFC  81 1B               Sub_0EFC:      CMPA #$1B              ; compare A with ESC
$0EFE  27 52                              BEQ Sub_0F52          
$0F00  81 09                              CMPA #$09             
$0F02  26 02                              BNE Sub_0F06          
$0F04  8D 05                              BSR Sub_0F0B           ; call Sub_0F0B
$0F06  7A 0C 96            Sub_0F06:      DEC $0C96             
$0F09  20 C6                              BRA Sub_0ED1          

; --------------------------------------------------------------
$0F0B  34 06               Sub_0F0B:      PSHS A,B              
$0F0D  FC 0C 9E                           LDD $0C9E             
$0F10  81 48                              CMPA #$48              ; compare A with 'H'
$0F12  22 0D                              BHI Sub_0F21          
$0F14  8B 08                              ADDA #$08             
$0F16  84 F8                              ANDA #$F8             
$0F18  4C                                 INCA                  
$0F19  B7 0C 9E                           STA $0C9E             
$0F1C  4A                                 DECA                  
$0F1D  5A                                 DECB                  
$0F1E  17 15 BB                           LBSR Sub_24DC          ; call Sub_24DC
$0F21  35 86               Sub_0F21:      PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)
$0F23  34 02               Sub_0F23:      PSHS A                
$0F25  B6 0C 9E                           LDA $0C9E             
$0F28  81 01                              CMPA #$01             
$0F2A  35 02                              PULS A                
$0F2C  27 D8                              BEQ Sub_0F06          
$0F2E  17 06 96                           LBSR Sub_15C7          ; call Sub_15C7
$0F31  20 9C                              BRA Sub_0ECF          

; --------------------------------------------------------------
$0F33  17 06 A6            Sub_0F33:      LBSR Sub_15DC          ; call Sub_15DC
$0F36  7D 0C BD                           TST $0CBD             
$0F39  27 94                              BEQ Sub_0ECF          
$0F3B  17 06 A5                           LBSR Sub_15E3          ; call Sub_15E3
$0F3E  7C 0C 96                           INC $0C96             
$0F41  A7 A0                              STA ,Y+               
$0F43  86 0A                              LDA #$0A               ; A = LF
$0F45  20 88                              BRA Sub_0ECF          

; --------------------------------------------------------------
$0F47  17 06 99            Sub_0F47:      LBSR Sub_15E3          ; call Sub_15E3
$0F4A  20 83                              BRA Sub_0ECF          

; --------------------------------------------------------------
$0F4C  17 06 A4            Sub_0F4C:      LBSR Sub_15F3          ; call Sub_15F3
$0F4F  16 FF 7D                           LBRA Sub_0ECF         

; --------------------------------------------------------------
$0F52  86 FF               Sub_0F52:      LDA #$FF              
$0F54  97 6E                              STA <$6E              
$0F56  B7 0C 6D            Sub_0F56:      STA $0C6D             
$0F59  34 20                              PSHS Y                
$0F5B  10 8E 0C 6D                        LDY #$0C6D            
$0F5F  10 BF 0C 8D                        STY $0C8D             
$0F63  7F 0C 6D                           CLR $0C6D             
$0F66  7F 0C 6E                           CLR $0C6E             
$0F69  B7 0C 6F                           STA $0C6F             
$0F6C  35 20               Sub_0F6C:      PULS Y                
$0F6E  8D 06                              BSR Sub_0F76           ; call Sub_0F76
$0F70  7A 0C 96                           DEC $0C96             
$0F73  16 FF 5B                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$0F76  34 20               Sub_0F76:      PSHS Y                
$0F78  10 8E 0B 1A                        LDY #$0B1A            
$0F7C  10 BF 0C 98                        STY $0C98             
$0F80  35 A0                              PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$0F82  34 20               Sub_0F82:      PSHS Y                
$0F84  10 BE 0C 98                        LDY $0C98             
$0F88  A6 80                              LDA ,X+               
$0F89  80 A7               Sub_0F89:      SUBA #$A7             
$0F8B  A0 10                              SUBA -16,X            
$0F8D  BF 0C 98                           STX $0C98             
$0F90  35 20                              PULS Y                
$0F92  81 40                              CMPA #$40              ; compare A with '@'
$0F94  22 06               Insn_0F94:     BHI Sub_0F9C          
$0F95  06                  Sub_0F95:      EQU    $0F95            ; [*9] branch target 1 byte(s) inside Insn_0F94 -- see [*9]
$0F96  7A 0C 96                           DEC $0C96             
$0F99  16 FF 35            Insn_0F99:     LBRA Sub_0ED1         
$0F9C  0F                  Sub_0F9C:      EQU    $0F9C            ; [*10] branch target 3 byte(s) inside Insn_0F99 -- see [*10]
$0F9D  6E B7                              JMP [E,Y]             
$0F9F  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0FA0  97 7A                              STA <$7A              
$0FA2  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0FA3  96 8D                              LDA <$8D              
$0FA5  D0 34                              SUBB <$34             
$0FA7  24 10                              BCC Sub_0FB9           ; C=0 (BHS)
$0FA9  BE 0C 8D                           LDX $0C8D             
$0FAC  86 FF                              LDA #$FF              
$0FAE  A7 A4                              STA ,Y                
$0FB0  10 8E 0C 6D                        LDY #$0C6D            
$0FB4  10 BF 0C 8D                        STY $0C8D             
$0FB8  10 BE 0C 98                        LDY $0C98             
$0FB9  BE 0C 98            Sub_0FB9:      LDX $0C98             
$0FBB  98 A6               Sub_0FBB:      EORA <$A6             
$0FBC  A6 A0               Sub_0FBC:      LDA ,Y+               
$0FBE  81 40                              CMPA #$40              ; compare A with '@'
$0FC0  22 40                              BHI Sub_1002          
$0FC2  81 3A                              CMPA #$3A              ; compare A with ':'
$0FC4  25 04                              BCS Sub_0FCA           ; C=1 (BLO)
$0FC6  C6 FE                              LDB #$FE              
$0FC8  20 19                              BRA Sub_0FE3          

; --------------------------------------------------------------
$0FC9  19                  Sub_0FC9:      DAA                   
$0FCA  80 30               Sub_0FCA:      SUBA #$30             
$0FCC  B7 0C 91                           STA $0C91             
$0FCF  A6 A0                              LDA ,Y+               
$0FD1  81 39               Sub_0FD1:      CMPA #$39              ; compare A with '9'
$0FD3  22 26                              BHI Sub_0FFB          
$0FD5  80 30                              SUBA #$30             
$0FD7  B7 0C 92                           STA $0C92             
$0FD9  92 B6               Sub_0FD9:      SBCA <$B6             
$0FDB  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$0FDC  91 C6                              CMPA <$C6             
$0FDE  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$0FDF  3D                                 MUL                    ; D = A×B unsigned
$0FE0  FB 0C 92                           ADDB $0C92            
$0FE3  34 20               Sub_0FE3:      PSHS Y                
$0FE5  10 BE 0C 8D                        LDY $0C8D             
$0FE9  E7 A0                              STB ,Y+               
$0FEB  C6 FF                              LDB #$FF              
$0FED  E7 A4                              STB ,Y                
$0FEF  E7 21                              STB 1,Y               
$0FF1  E7 22                              STB 2,Y               
$0FF3  10 BF 0C 8D                        STY $0C8D             
$0FF6  8D 35               Sub_0FF6:      BSR Sub_102D           ; call Sub_102D
$0FF8  20 20                              BRA Sub_101A          
         FCB    $C1  ; unreachable padding
$0FFB  31 3F               Sub_0FFB:      LEAY -1,Y             
$0FFD  F6 0C 91                           LDB $0C91             
$1000  20 E1                              BRA Sub_0FE3          

; --------------------------------------------------------------
$1002  35 24               Sub_1002:      PULS B,Y              
$1004  B6 0C 97            Sub_1004:      LDA $0C97             
$1007  81 6D                              CMPA #$6D              ; compare A with 'm'
$1009  27 4B                              BEQ Sub_1056          
$100B  81 4A                              CMPA #$4A              ; compare A with 'J'
$100D  10 27 02 C6                        LBEQ Sub_12D7         
$1011  81 66                              CMPA #$66              ; compare A with 'f'
$1012  66 10               Sub_1012:      ROR -16,X             
$1014  27 06                              BEQ Sub_101C          
$1016  17 81 48                           LBSR $9161            
$1019  10 27 06 11                        LBEQ Sub_162E         
$101A  27 06               Sub_101A:      BEQ Sub_1022          
$101C  11 81               Sub_101C:      FCB $11,$81            ; unknown opcode $1181
$101E  43                                 COMA                  
$101F  10 27 06 4B         Insn_101F:     LBEQ Sub_166E         
$1022  4B                  Sub_1022:      EQU    $1022            ; [*11] branch target 3 byte(s) inside Insn_101F -- see [*11]
$1023  81 44                              CMPA #$44              ; compare A with 'D'
$1025  10 27 06 7D                        LBEQ Sub_16A6         
$1028  7D 81 41            Sub_1028:      TST $8141             
$102B  10 27 06 99         Insn_102B:     LBEQ Sub_16C8         
$102D  06                  Sub_102D:      EQU    $102D            ; [*12] branch target 2 byte(s) inside Insn_102B -- see [*12]
$102E  99 81               Sub_102E:      ADCA <$81             
$1030  42                                 FCB    $42                ; undefined opcode $42 -- not a valid 6809 instruction
$1031  10 27 06 B5                        LBEQ Sub_16EA         
$1034  B5 81 73            Sub_1034:      BITA $8173            
$1037  10 27 05 C5                        LBEQ Sub_1600         
$103A  C5 81               Sub_103A:      BITB #$81             
$103C  75                                 FCB    $75                ; undefined opcode $75 -- not a valid 6809 instruction
$103D  10 27 05 CC         Insn_103D:     LBEQ Sub_160D         
$103F  05                  Sub_103F:      EQU    $103F            ; [*13] branch target 2 byte(s) inside Insn_103D -- see [*13]
$1040  CC 81 4B                           LDD #$814B            
$1043  10 27 02 AF         Insn_1043:     LBEQ Sub_12F6         
$1045  02                  Sub_1045:      EQU    $1045            ; [*14] branch target 2 byte(s) inside Insn_1043 -- see [*14]
$1046  AF 81                              STX ,X++              
$1048  4C                  Sub_1048:      INCA                  
$1049  10 27 06 BC                        LBEQ Sub_1709         
$104D  81 4D                              CMPA #$4D              ; compare A with 'M'
$104F  10 27 06 BC                        LBEQ Sub_170F         
$1052  BC 16 FE            Sub_1052:      CMPX $16FE            
$1055  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$1056  34 16               Sub_1056:      PSHS A,B,X            
$1058  8E 0C 6D            Sub_1058:      LDX #$0C6D            
$105B  A6 84                              LDA ,X                
$105D  81 FF                              CMPA #$FF             
$105F  27 51                              BEQ Sub_10B2          
$1061  A6 80               Sub_1061:      LDA ,X+               
$1063  81 FF                              CMPA #$FF             
$1065  27 16                              BEQ Sub_107D          
$1067  81 00                              CMPA #$00              ; compare A with NUL
$1069  27 47                              BEQ Sub_10B2          
$106B  81 01                              CMPA #$01             
$106D  27 F2                              BEQ Sub_1061          
$106F  81 08                              CMPA #$08              ; compare A with BS
$1071  25 0F                              BCS Sub_1082           ; C=1 (BLO)
$1073  81 26                              CMPA #$26              ; compare A with '&'
$1075  25 13                              BCS Sub_108A           ; C=1 (BLO)
$1077  81 30                              CMPA #$30              ; compare A with '0'
$1079  25 23                              BCS Sub_109E           ; C=1 (BLO)
$107A  23 20               Sub_107A:      BLS Sub_109C          
$107C  E4 35                              ANDB -11,Y            
$107D  35 16               Sub_107D:      PULS A,B,X            
$107F  16 FE 4F                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$1082  34 10               Sub_1082:      PSHS X                
$1084  30 8D F3 84                        LEAX Dat_040C,PC       ; X → Dat_040C
$1088  20 4E                              BRA Sub_10D8          

; --------------------------------------------------------------
$108A  D6 70               Sub_108A:      LDB <$70              
$108C  C1 02                              CMPB #$02              ; compare B with CurXY
$108E  27 D1               Sub_108E:      BEQ Sub_1061          
$1090  81 1E                              CMPA #$1E             
$1092  25 CD                              BCS Sub_1061           ; C=1 (BLO)
$1094  80 1E                              SUBA #$1E             
$1096  34 10                              PSHS X                
$1098  30 8D F3 98         Sub_1098:      LEAX Dat_0434,PC       ; X → Dat_0434
$109B  98 20               Sub_109B:      EORA <$20             
$109C  20 3A               Sub_109C:      BRA Sub_10D8          
$109E  D6 70               Sub_109E:      LDB <$70              
$10A0  C1 02                              CMPB #$02              ; compare B with CurXY
$10A2  27 BD               Sub_10A2:      BEQ Sub_1061          
$10A4  81 28                              CMPA #$28              ; compare A with '('
$10A6  25 B9                              BCS Sub_1061           ; C=1 (BLO)
$10A8  80 28                              SUBA #$28             
$10AA  34 10               Sub_10AA:      PSHS X                
$10AC  30 8D F3 AC                        LEAX Dat_045C,PC       ; X → Dat_045C
$10B0  20 26                              BRA Sub_10D8          

; --------------------------------------------------------------
$10B2  34 10               Sub_10B2:      PSHS X                
$10B4  30 8D F3 46                        LEAX Dat_03FE,PC       ; X → Dat_03FE
$10B8  E6 1F                              LDB -1,X              
$10BA  A6 80               Sub_10BA:      LDA ,X+               
$10BC  A7 A0                              STA ,Y+               
$10BE  7C 0C 96                           INC $0C96             
$10C1  5A                                 DECB                  
$10C2  26 F6                              BNE Sub_10BA          
$10C4  B6 0C C7                           LDA $0CC7             
$10C7  17 0E 02                           LBSR Sub_1ECC          ; call Sub_1ECC
$10CA  A7 3A                              STA -6,Y              
$10CC  B6 0C C8            Sub_10CC:      LDA $0CC8             
$10CF  17 0D FA                           LBSR Sub_1ECC          ; call Sub_1ECC
$10D2  A7 3D                              STA -3,Y              
$10D4  35 10                              PULS X                
$10D6  20 89                              BRA Sub_1061          

; --------------------------------------------------------------
$10D8  C6 05               Sub_10D8:      LDB #$05               ; B = SS.Pos  (GetStt/SetStt subcode)
$10DA  3D                                 MUL                    ; D = A×B unsigned
$10DB  30 85                              LEAX B,X              
$10DD  17 01 E8                           LBSR Sub_12C8          ; call Sub_12C8
$10DF  E8 35               Sub_10DF:      EORB -11,Y            
$10E1  10 16 FF 7C                        LBRA Sub_1061         

; --------------------------------------------------------------
$10E5  96 4B               Sub_10E5:      LDA <$4B              
$10E7  10 3F 8F                           OS9 I$Close            ; path=A
$10EA  17 04 3C                           LBSR Sub_1529          ; call Sub_1529
$10ED  17 04 47                           LBSR Sub_1537          ; call Sub_1537
$10F0  17 04 A9                           LBSR Sub_159C          ; call Sub_159C
$10F3  96 7B                              LDA <$7B              
$10F5  27 03                              BEQ Sub_10FA          
$10F7  10 3F 8F            Insn_10F7:     OS9 I$Close            ; path=A
$10FA  0D                  Sub_10FA:      EQU    $10FA            ; [*15] branch target 3 byte(s) inside Insn_10F7 -- see [*15]
$10FB  34 27                              PSHS CC,A,B,Y         
$10FD  08                                 FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
$10FE  17 35 29                           LBSR Sub_462A          ; call Sub_462A
$1101  96 37                              LDA <$37              
$1103  10 3F 8F                           OS9 I$Close            ; path=A
$1106  5F                                 CLRB                   ; B = 0
$1107  10 3F 06            Sub_1107:      OS9 F$Exit             ; status=B
$110A  C1 80               Sub_110A:      CMPB #$80             
$110C  26 02                              BNE Sub_1110          
$110E  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$110F  7C 3B 10                           INC $3B10             
$1110  3B                  Sub_1110:      RTI                    ; return from interrupt
$1111  10 8E 00 80         Sub_1111:      LDY #$0080            
$1115  C6 D0                              LDB #$D0              
$1117  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$111A  39                                 RTS                    ; return from subroutine
         FCB    $C6,$01,$10,$3F,$8D,$25,$0D,$34,$02,$4F,$5D,$2B,$08  ; unreachable padding
$1128  1F 02               Sub_1128:      TFR D,Y               
$112A  35 02                              PULS A                
$112C  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$112F  39                  Sub_112F:      RTS                    ; return from subroutine
$1130  C6 80               Sub_1130:      LDB #$80              
$1132  20 F4                              BRA Sub_1128          

; --------------------------------------------------------------
$1134  34 04               Sub_1134:      PSHS B                
$1136  C6 D1                              LDB #$D1              
$1138  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$113B  35 84                              PULS B,PC              ; return from subroutine  (PULS PC = RTS)
         FCB    $10,$3F,$8A,$35,$80  ; unreachable padding
$1142  34 32               Sub_1142:      PSHS A,X,Y            
$1144  8E 00 A9                           LDX #$00A9            
$1146  A9 B6               Sub_1146:      ADCA [A,Y]            
$1148  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$1149  CB 17                              ADDB #$17             
$114B  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$114C  7F A7 02                           CLR $A702             
$114F  96 4B                              LDA <$4B              
$1151  10 8E 00 03         Insn_1151:     LDY #$0003            
$1154  03                  Sub_1154:      EQU    $1154            ; [*16] branch target 3 byte(s) inside Insn_1151 -- see [*16]
$1155  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1158  8E 00 80                           LDX #$0080            
$115B  10 8E 00 0B                        LDY #$000B            
$115F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1162  8E 00 A9                           LDX #$00A9            
$1165  B6 0C C9                           LDA $0CC9             
$1168  17 0D 61                           LBSR Sub_1ECC          ; call Sub_1ECC
$116B  A7 02                              STA 2,X               
$116D  96 4B                              LDA <$4B              
$116F  10 8E 00 03                        LDY #$0003            
$1173  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1176  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1178  34 20               Sub_1178:      PSHS Y                
$117A  10 9E 12                           LDY <$12              
$117D  31 21                              LEAY 1,Y              
$117F  10 9F 12                           STY <$12              
$1182  34 02               Sub_1182:      PSHS A                
$1184  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1185  7E 27 0D                           JMP $270D             
$1188  96 7D                              LDA <$7D              
$118A  91 7C                              CMPA <$7C             
$118C  27 07                              BEQ Sub_1195          
$118E  8D 11                              BSR Sub_11A1           ; call Sub_11A1
$1190  4C                                 INCA                  
$1191  97 7D                              STA <$7D              
$1193  20 F5                              BRA $118A             

; --------------------------------------------------------------
$1195  35 02               Sub_1195:      PULS A                
$1197  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$119A  8C 00 00                           CMPX #$0000           
$119D  26 E3                              BNE Sub_1182          
$119F  35 A0                              PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$11A1  34 36               Sub_11A1:      PSHS A,B,X,Y          
$11A3  8E 00 80                           LDX #$0080            
$11A6  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$11A8  8D 0B               Sub_11A8:      BSR Sub_11B5           ; call Sub_11B5
$11AA  4D                                 TSTA                  
$11AB  2A 28                              BPL Sub_11D5          
$11AD  5A                                 DECB                  
$11AE  5A                                 DECB                  
$11AF  C1 04                              CMPB #$04             
$11B1  25 22                              BCS Sub_11D5           ; C=1 (BLO)
$11B3  20 F3                              BRA Sub_11A8          

; --------------------------------------------------------------
$11B5  A6 85               Sub_11B5:      LDA B,X               
$11B7  81 39                              CMPA #$39              ; compare A with '9'
$11B9  27 04                              BEQ Sub_11BF          
$11BB  4C                                 INCA                  
$11BC  A7 85                              STA B,X               
$11BE  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$11BF  86 30               Sub_11BF:      LDA #$30               ; A = '0'
$11C1  A7 85                              STA B,X               
$11C3  5A                                 DECB                  
$11C4  A6 85                              LDA B,X               
$11C6  81 35                              CMPA #$35              ; compare A with '5'
$11C8  27 04                              BEQ Sub_11CE          
$11CA  4C                                 INCA                  
$11CB  A7 85                              STA B,X               
$11CD  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$11CE  86 30               Sub_11CE:      LDA #$30               ; A = '0'
$11D0  A7 85                              STA B,X               
$11D2  86 FF                              LDA #$FF              
$11D4  39                  Sub_11D4:      RTS                    ; return from subroutine
$11D5  96 4B               Sub_11D5:      LDA <$4B              
$11D7  10 8E 00 0B                        LDY #$000B            
$11DB  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$11DE  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$11E0  10 BF 0C 95         Sub_11E0:      STY $0C95             
$11E4  10 8C 00 00                        CMPY #$0000           
$11E8  27 39                              BEQ Sub_1223          
$11EA  7D 0C C3                           TST $0CC3             
$11ED  26 03                              BNE Sub_11F2          
$11EF  17 00 75                           LBSR Sub_1267          ; call Sub_1267
$11F2  B6 0C 8F            Sub_11F2:      LDA $0C8F             
$11F5  27 0D                              BEQ Sub_1204          
$11F7  81 05                              CMPA #$05             
$11F9  26 06                              BNE Sub_1201          
$11FB  4F                                 CLRA                   ; A = 0
$11FC  B7 0C 8F                           STA $0C8F             
$11FF  20 03                              BRA Sub_1204          

; --------------------------------------------------------------
$1201  17 15 76            Sub_1201:      LBSR Sub_277A          ; call Sub_277A
$1204  8D 41               Sub_1204:      BSR Sub_1247           ; call Sub_1247
$1206  86 01                              LDA #$01              
$1208  8E 07 1A                           LDX #$071A            
$120B  10 BE 0C 95                        LDY $0C95             
$120F  10 8C 00 00                        CMPY #$0000           
$1213  27 0E                              BEQ Sub_1223          
$1215  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1218  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1219  34 27                              PSHS CC,A,B,Y         
$121B  07                                 FCB    $07                ; undefined opcode $07 -- not a valid 6809 instruction
$121C  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$121D  35 27                              PULS CC,A,B,Y         
$121F  03                                 FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
$1220  17 30 C8                           LBSR Sub_42EB          ; call Sub_42EB
$1223  17 32 4C            Sub_1223:      LBSR Sub_4472          ; call Sub_4472
$1226  7D 0C 90                           TST $0C90             
$1229  27 03                              BEQ Sub_122E          
$122B  17 15 A6            Insn_122B:     LBSR Sub_27D4          ; call Sub_27D4
$122E  0D                  Sub_122E:      EQU    $122E            ; [*17] branch target 3 byte(s) inside Insn_122B -- see [*17]
$122F  76 2A 0C                           ROR $2A0C             
$1232  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$1233  76 7D 0C                           ROR $7D0C             
$1236  AA 10                              ORA -16,X             
$1238  27 08                              BEQ Sub_1242          
$123A  7F 16 07                           CLR $1607             
$123D  A1 0D               Insn_123D:     CMPA 13,X             
$123E  0D                  Sub_123E:      EQU    $123E            ; [*18] branch target 1 byte(s) inside Insn_123D -- see [*18]
$123F  32 10                              LEAS -16,X            
$1241  27 FB                              BEQ Sub_123E          
$1242  FB FF 16            Sub_1242:      ADDB $FF16            
$1245  FB E3 B6                           ADDB $E3B6            
$1247  B6 0C BB            Sub_1247:      LDA $0CBB             
$124A  27 0C                              BEQ Sub_1258          
$124C  81 01                              CMPA #$01             
$124E  10 27 FB FF                        LBEQ Sub_0E51         
$1252  81 02                              CMPA #$02              ; compare A with CurXY
$1254  10 27 FC 56                        LBEQ Sub_0EAE         
$1258  8E 00 EC            Sub_1258:      LDX #$00EC            
$125B  10 8E 07 1A                        LDY #$071A            
$125F  F6 0C 96                           LDB $0C96             
$1262  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$1266  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1267  34 36               Sub_1267:      PSHS A,B,X,Y          
$1269  F6 0C 96                           LDB $0C96             
$126C  10 9E 77                           LDY <$77              
$126F  8E 00 EC                           LDX #$00EC            
$1272  5D                  Sub_1272:      TSTB                  
$1273  27 2F                              BEQ Sub_12A4          
$1275  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1276  76 27 0C                           ROR $270C             
$1279  A6 84                              LDA ,X                
$127B  81 30                              CMPA #$30              ; compare A with '0'
$127D  27 3B                              BEQ Sub_12BA          
$127F  81 31                              CMPA #$31              ; compare A with '1'
$1281  27 3C                              BEQ Sub_12BF          
$1283  20 0B                              BRA Sub_1290          

; --------------------------------------------------------------
$1285  A6 80               Sub_1285:      LDA ,X+               
$1287  84 7F                              ANDA #$7F             
$1289  5A                                 DECB                  
$128A  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$128B  7A A1 A4                           DEC $A1A4             
$128C  A1 A4               Sub_128C:      CMPA ,Y               
$128E  27 16                              BEQ Sub_12A6          
$1290  31 8D F0 A3         Sub_1290:      LEAY Dat_0337,PC       ; Y → Dat_0337
$1294  10 9F 77                           STY <$77              
$1297  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1298  7A 26 04                           DEC $2604             
$129B  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$129C  7A 20 ED            Insn_129C:     DEC $20ED             
$129F  0F                  Sub_129F:      EQU    $129F            ; [*19] branch target 3 byte(s) inside Insn_129C -- see [*19]
$12A0  7A 5D 26                           DEC $5D26             
$12A3  E1 35                              CMPB -11,Y            
$12A4  35 B6               Sub_12A4:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$12A6  31 21               Sub_12A6:      LEAY 1,Y              
$12A8  10 9F 77                           STY <$77              
$12AB  6D A4                              TST ,Y                
$12AD  26 F0                              BNE Sub_129F          
$12AF  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$12B0  76 31 8D                           ROR $318D             
$12B3  F0 82 10                           SUBB $8210            
$12B6  9F 77                              STX <$77              
$12B8  20 B8                              BRA Sub_1272          

; --------------------------------------------------------------
$12B9  B8 7C 0C            Sub_12B9:      EORA $7C0C            
$12BA  7C 0C AA            Sub_12BA:      INC $0CAA             
$12BD  20 03                              BRA Sub_12C2          

; --------------------------------------------------------------
$12BF  7F 0C AA            Sub_12BF:      CLR $0CAA             
$12C2  86 FF               Sub_12C2:      LDA #$FF              
$12C4  97 76                              STA <$76              
$12C6  20 DC                              BRA Sub_12A4          

; --------------------------------------------------------------
$12C8  E6 01               Sub_12C8:      LDB 1,X               
$12CA  30 02                              LEAX 2,X              
$12CC  A6 80               Sub_12CC:      LDA ,X+               
$12CE  A7 A0                              STA ,Y+               
$12D0  7C 0C 96                           INC $0C96             
$12D3  5A                                 DECB                  
$12D4  26 F6                              BNE Sub_12CC          
$12D6  39                  Sub_12D6:      RTS                    ; return from subroutine
$12D7  34 16               Sub_12D7:      PSHS A,B,X            
$12D9  8E 0C 6D                           LDX #$0C6D            
$12DC  A6 84                              LDA ,X                
$12DD  84 81               Insn_12DD:     ANDA #$81             
$12DF  02                  Sub_12DF:      EQU    $12DF            ; [*20] branch target 2 byte(s) inside Insn_12DD -- see [*20]
$12E0  27 09                              BEQ Sub_12EB          
$12E2  30 8D F1 A4                        LEAX Dat_048A,PC       ; X → Dat_048A
$12E6  8D E0                              BSR Sub_12C8           ; call Sub_12C8
$12E8  16 FD 92            Sub_12E8:      LBRA Sub_107D         
$12EB  30 8D F1 95         Sub_12EB:      LEAX Dat_0484,PC       ; X → Dat_0484
$12EC  8D F1               Sub_12EC:      BSR Sub_12DF           ; call Sub_12DF
$12EE  95 8D                              BITA <$8D             
$12F0  D7 17                              STB <$17              
$12F2  02                                 FCB    $02                ; undefined opcode $02 -- not a valid 6809 instruction
$12F3  FF 20 F2                           STU $20F2             
$12F6  34 16               Sub_12F6:      PSHS A,B,X            
$12F8  30 8D F1 8B                        LEAX Dat_0487,PC       ; X → Dat_0487
$12FC  8D CA                              BSR Sub_12C8           ; call Sub_12C8
$12FE  16 FD 7C                           LBRA Sub_107D         

; --------------------------------------------------------------
$1300  7C CC 1A            Sub_1300:      INC $CC1A             
$1301  CC 1A 01            Sub_1301:      LDD #$1A01            
$1304  FD 0C 9A                           STD $0C9A             
$1307  CC 34 0E                           LDD #$340E            
$130A  FD 0C 9C                           STD $0C9C             
$130D  17 0B E1                           LBSR Sub_1EF1          ; call Sub_1EF1
$1310  30 8D ED F6                        LEAX Dat_010A,PC       ; X → Dat_010A
$1314  17 0A 7E                           LBSR Sub_1D95          ; call Sub_1D95
$1317  30 8D F1 9A                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$131B  17 0A 77                           LBSR Sub_1D95          ; call Sub_1D95
$131E  17 19 41            Sub_131E:      LBSR Sub_2C62          ; call Sub_2C62
$1321  81 20                              CMPA #$20              ; compare A with ' '
$1323  27 4F                              BEQ Sub_1374          
$1325  81 05                              CMPA #$05             
$1327  27 4B                              BEQ Sub_1374          
$1329  81 0C                              CMPA #$0C              ; compare A with FF
$132B  26 04                              BNE Sub_1331          
$132D  86 1C                              LDA #$1C              
$132F  20 37                              BRA Sub_1368          

; --------------------------------------------------------------
$1331  81 0A               Sub_1331:      CMPA #$0A              ; compare A with LF
$1333  26 04                              BNE Sub_1339          
$1335  86 1A                              LDA #$1A               ; A = SUB
$1337  20 35                              BRA Sub_136E          

; --------------------------------------------------------------
$1339  E6 8D F8 0E         Sub_1339:      LDB Dat_0B4B,PC       
$133D  30 8D F8 0B                        LEAX Dat_0B4C,PC       ; X → Dat_0B4C
$1341  A1 80               Sub_1341:      CMPA ,X+              
$1343  27 05                              BEQ Sub_134A          
$1345  5A                                 DECB                  
$1346  26 F9                              BNE Sub_1341          
$1348  20 D4                              BRA Sub_131E          

; --------------------------------------------------------------
$134A  8B A0               Sub_134A:      ADDA #$A0             
$134C  34 02                              PSHS A                
$134E  86 04                              LDA #$04              
$1350  97 4E               Sub_1350:      STA <$4E              
$1352  30 8D F0 94                        LEAX Dat_03EA,PC       ; X → Dat_03EA
$1356  17 0A 3C                           LBSR Sub_1D95          ; call Sub_1D95
$1359  30 8D F1 54                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$135D  17 0A 35                           LBSR Sub_1D95          ; call Sub_1D95
$1360  35 02                              PULS A                
$1362  B7 06 1B                           STA $061B             
$1365  16 03 E0                           LBRA Sub_1748         

; --------------------------------------------------------------
$1368  34 02               Sub_1368:      PSHS A                
$136A  86 09                              LDA #$09              
$136C  20 E2                              BRA Sub_1350          

; --------------------------------------------------------------
$136E  34 02               Sub_136E:      PSHS A                
$1370  86 11                              LDA #$11               ; A = XON
$1372  20 DC                              BRA Sub_1350          

; --------------------------------------------------------------
$1374  30 8D F0 72         Sub_1374:      LEAX Dat_03EA,PC       ; X → Dat_03EA
$1378  17 0A 1A                           LBSR Sub_1D95          ; call Sub_1D95
$137B  17 0A B5                           LBSR Sub_1E33          ; call Sub_1E33
$137E  30 8D F1 2F                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$1382  17 0A 10                           LBSR Sub_1D95          ; call Sub_1D95
$1385  16 FA A2                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1388  34 36               Sub_1388:      PSHS A,B,X,Y          
$138A  96 38                              LDA <$38              
$138C  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$138E  8E 0C 3B                           LDX #$0C3B            
$1391  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1394  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1396  34 36               Sub_1396:      PSHS A,B,X,Y          
$1398  8E 0C 3B                           LDX #$0C3B            
$139B  F6 0C BA                           LDB $0CBA             
$139E  E7 88 15                           STB 21,X              
$13A1  E6 88 14                           LDB 20,X              
$13A4  C4 0F                              ANDB #$0F             
$13A6  FA 0C C1                           ORB $0CC1             
$13A9  E7 88 14                           STB 20,X              
$13AC  F6 0C C4                           LDB $0CC4             
$13AF  E7 88 18                           STB 24,X              
$13B2  F6 0C C5                           LDB $0CC5             
$13B5  E7 88 19                           STB 25,X              
$13B8  F6 0C C6                           LDB $0CC6             
$13BB  E7 04                              STB 4,X               
$13BD  F6 0C BE                           LDB $0CBE             
$13C0  E7 05                              STB 5,X               
$13C2  6F 07                              CLR 7,X               
$13C4  30 09                              LEAX 9,X              
$13C6  C6 0A                              LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
$13C8  6F 80                              CLR ,X+               
$13CA  5A                                 DECB                  
$13CB  26 FB                              BNE $13C8             
$13CD  96 38                              LDA <$38              
$13CF  81 03                              CMPA #$03             
$13D1  10 23 00 CE                        LBLS Sub_14A3         
$13D5  8E 0C 3B                           LDX #$0C3B            
$13D8  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$13DA  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$13DD  8E 00 A2                           LDX #$00A2            
$13E0  CC 02 5A                           LDD #$025A            
$13E3  ED 84                              STD ,X                
$13E5  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$13E7  E7 02                              STB 2,X               
$13E9  10 8E 00 03                        LDY #$0003            
$13ED  96 4B                              LDA <$4B              
$13EF  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$13F2  B6 0C BA                           LDA $0CBA             
$13F5  84 0F                              ANDA #$0F             
$13F7  C6 06                              LDB #$06               ; B = SS.EOF  (GetStt/SetStt subcode)
$13F9  3D                                 MUL                    ; D = A×B unsigned
$13FA  30 8D F2 7B                        LEAX Dat_0679,PC       ; X → Dat_0679
$13FE  30 85                              LEAX B,X              
$1400  10 8E 00 06                        LDY #$0006            
$1404  96 4B                              LDA <$4B              
$1406  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1409  C6 62                              LDB #$62               ; B = 'b'
$140B  8E 00 A2                           LDX #$00A2            
$140E  E7 01                              STB 1,X               
$1410  96 4B                              LDA <$4B              
$1412  10 8E 00 03                        LDY #$0003            
$1416  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1419  F6 0C BA                           LDB $0CBA             
$141C  C5 20                              BITB #$20             
$141E  26 04                              BNE Sub_1424          
$1420  C6 38                              LDB #$38               ; B = '8'
$1422  20 02                              BRA Sub_1426          

; --------------------------------------------------------------
$1424  C6 37               Sub_1424:      LDB #$37               ; B = '7'
$1426  8E 00 50            Sub_1426:      LDX #$0050            
$1429  E7 84                              STB ,X                
$142B  10 8E 00 01                        LDY #$0001            
$142F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1432  C6 64                              LDB #$64               ; B = 'd'
$1434  8E 00 A2                           LDX #$00A2            
$1437  E7 01                              STB 1,X               
$1439  10 8E 00 03                        LDY #$0003            
$143D  96 4B                              LDA <$4B              
$143F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1442  B6 0C C1                           LDA $0CC1             
$1444  C1 84               Sub_1444:      CMPB #$84             
$1445  84 E0               Sub_1445:      ANDA #$E0             
$1447  81 A0                              CMPA #$A0             
$1449  26 06                              BNE Sub_1451          
$144B  30 8D F6 40                        LEAX Dat_0A8F,PC       ; X → Dat_0A8F
$144E  40                  Sub_144E:      NEGA                  
$144F  20 22                              BRA Sub_1473          

; --------------------------------------------------------------
$1451  81 E0               Sub_1451:      CMPA #$E0             
$1453  26 06                              BNE Sub_145B          
$1455  30 8D F6 3A                        LEAX Dat_0A93,PC       ; X → Dat_0A93
$1458  3A                  Sub_1458:      ABX                   
$1459  20 18                              BRA Sub_1473          

; --------------------------------------------------------------
$145B  81 60               Sub_145B:      CMPA #$60              ; compare A with '`'
$145D  26 06               Insn_145D:     BNE Sub_1465          
$145E  06                  Sub_145E:      EQU    $145E            ; [*21] branch target 1 byte(s) inside Insn_145D -- see [*21]
$145F  30 8D F6 36                        LEAX Dat_0A99,PC       ; X → Dat_0A99
$1462  36 20               Sub_1462:      PSHU Y                
$1464  0E                                 FCB    $0E                ; undefined opcode $0E -- not a valid 6809 instruction
$1465  81 20               Sub_1465:      CMPA #$20              ; compare A with ' '
$1467  26 06               Insn_1467:     BNE Sub_146F          
$1468  06                  Sub_1468:      EQU    $1468            ; [*22] branch target 1 byte(s) inside Insn_1467 -- see [*22]
$1469  30 8D F6 31                        LEAX Dat_0A9E,PC       ; X → Dat_0A9E
$146D  20 04                              BRA Sub_1473          

; --------------------------------------------------------------
$146F  30 8D F6 30         Sub_146F:      LEAX Dat_0AA3,PC       ; X → Dat_0AA3
$1473  96 4B               Sub_1473:      LDA <$4B              
$1475  10 8E 00 01                        LDY #$0001            
$1479  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$147C  C6 66                              LDB #$66               ; B = 'f'
$147E  8E 00 A2                           LDX #$00A2            
$1481  E7 01                              STB 1,X               
$1483  96 4B                              LDA <$4B              
$1485  10 8E 00 03                        LDY #$0003            
$1489  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$148C  F6 0C BA                           LDB $0CBA             
$148E  BA 2A 04            Sub_148E:      ORA $2A04             
$148F  2A 04               Sub_148F:      BPL Sub_1495          
$1490  04                  Sub_1490:      EQU    $1490            ; [*23] branch target 1 byte(s) inside Sub_148F -- see [*23]
$1491  C6 32                              LDB #$32               ; B = '2'
$1492  32 20               Sub_1492:      LEAS 0,Y              
$1494  02                                 FCB    $02                ; undefined opcode $02 -- not a valid 6809 instruction
$1495  C6 31               Sub_1495:      LDB #$31               ; B = '1'
$1497  8E 00 50            Sub_1497:      LDX #$0050            
$149A  E7 84                              STB ,X                
$149C  10 8E 00 01                        LDY #$0001            
$14A0  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$14A3  35 B6               Sub_14A3:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$14A5  34 36               Sub_14A5:      PSHS A,B,X,Y          
$14A7  8E 13 C3                           LDX #$13C3            
$14AA  10 8E 0C 19                        LDY #$0C19            
$14AE  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$14B0  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$14B4  8E 13 C3                           LDX #$13C3            
$14B7  6F 04                              CLR 4,X               
$14B9  B6 0C BD                           LDA $0CBD             
$14BC  A7 05                              STA 5,X               
$14BE  6F 07                              CLR 7,X               
$14C0  B6 13 BF                           LDA $13BF             
$14C3  A7 0C                              STA 12,X              
$14C5  B6 13 C2                           LDA $13C2             
$14C8  A7 0F                              STA 15,X              
$14CA  B6 13 C0                           LDA $13C0             
$14CD  A7 88 10                           STA 16,X              
$14D0  B6 13 C1                           LDA $13C1             
$14D3  A7 88 11                           STA 17,X              
$14D6  86 01                              LDA #$01              
$14D8  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$14DA  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$14DD  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$14DF  34 16               Sub_14DF:      PSHS A,B,X            
$14E1  86 00                              LDA #$00               ; A = NUL
$14E3  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$14E5  8E 0C 19                           LDX #$0C19            
$14E8  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$14EB  A6 88 14                           LDA 20,X              
$14EE  2A 34                              BPL Sub_1524          
$14F0  86 01                              LDA #$01              
$14F2  C6 96                              LDB #$96              
$14F4  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$14F7  97 9A                              STA <$9A              
$14F9  D7 9B                              STB <$9B              
$14FB  1F 10                              TFR X,D               
$14FD  D7 9C                              STB <$9C              
$14FF  8E 0C 5D                           LDX #$0C5D            
$1502  86 01                              LDA #$01              
$1504  C6 91                              LDB #$91              
$1506  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1509  86 01                              LDA #$01              
$150B  C6 26                              LDB #$26               ; B = SS.FSig  (GetStt/SetStt subcode)
$150D  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1510  1F 10                              TFR X,D               
$1512  D7 8B                              STB <$8B              
$1514  1F 20                              TFR Y,D               
$1516  D7 8C                              STB <$8C              
$1518  86 01                              LDA #$01              
$151A  C6 93                              LDB #$93              
$151C  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$151F  97 8D                              STA <$8D              
$1521  5F                                 CLRB                   ; B = 0
$1522  35 96               Sub_1522:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$1524  53                  Sub_1524:      COMB                  
$1525  C6 B7                              LDB #$B7              
$1527  20 F9                              BRA Sub_1522          

; --------------------------------------------------------------
$1529  34 16               Sub_1529:      PSHS A,B,X            
$152B  86 00                              LDA #$00               ; A = NUL
$152D  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$152F  8E 0C 19                           LDX #$0C19            
$1532  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1535  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1537  34 36               Sub_1537:      PSHS A,B,X,Y          
$1539  31 8D EF 52                        LEAY Dat_048F,PC       ; Y → Dat_048F
$153D  C6 10                              LDB #$10              
$153F  8E 13 C3                           LDX #$13C3            
$1542  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$1546  8E 13 C3                           LDX #$13C3            
$1549  96 8D                              LDA <$8D              
$154B  A7 04                              STA 4,X               
$154D  4F                                 CLRA                   ; A = 0
$154E  A7 06                              STA 6,X               
$1550  96 8B                              LDA <$8B              
$1552  A7 07                              STA 7,X               
$1554  96 8C                              LDA <$8C              
$1556  A7 08                              STA 8,X               
$1558  96 9A                              LDA <$9A              
$155A  A7 09                              STA 9,X               
$155C  96 9B                              LDA <$9B              
$155E  A7 0A                              STA 10,X              
$1560  96 9C                              LDA <$9C              
$1562  A7 0B                              STA 11,X              
$1564  10 8E 00 0C                        LDY #$000C            
$1568  86 01                              LDA #$01              
$156A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$156D  8E 00 02                           LDX #$0002            
$1570  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1573  8E 0C 5D                           LDX #$0C5D            
$1576  86 01                              LDA #$01              
$1578  C6 91                              LDB #$91              
$157A  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$157D  8E 00 02                           LDX #$0002            
$1580  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1583  8E 13 C3                           LDX #$13C3            
$1586  CC 1B 21                           LDD #$1B21             ; D=ESC+'!'  → W.Select: Select window
$1589  ED 84                              STD ,X                
$158B  86 01                              LDA #$01              
$158D  10 8E 00 02                        LDY #$0002            
$1591  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1594  8E 00 02                           LDX #$0002            
$1597  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$159A  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$159C  30 8D EE 2D         Sub_159C:      LEAX Dat_03CD,PC       ; X → Dat_03CD
$15A0  17 07 F2                           LBSR Sub_1D95          ; call Sub_1D95
$15A3  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$15A4  86 00               Sub_15A4:      LDA #$00               ; A = NUL
$15A6  20 02                              BRA Sub_15AA          

; --------------------------------------------------------------
$15A8  96 38               Sub_15A8:      LDA <$38              
$15AA  C6 01               Sub_15AA:      LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$15AC  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$15AF  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$15B0  34 06               Sub_15B0:      PSHS A,B              
$15B2  FC 0C 9E                           LDD $0C9E             
$15B5  4C                                 INCA                  
$15B6  91 9D                              CMPA <$9D             
$15B8  23 08                              BLS Sub_15C2          
$15BA  86 01                              LDA #$01              
$15BC  5C                                 INCB                  
$15BD  D1 9E                              CMPB <$9E             
$15BF  23 01                              BLS Sub_15C2          
$15C1  5A                                 DECB                  
$15C2  FD 0C 9E            Sub_15C2:      STD $0C9E             
$15C5  35 86                              PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$15C7  34 06               Sub_15C7:      PSHS A,B              
$15C9  FC 0C 9E                           LDD $0C9E             
$15CC  4A                                 DECA                  
$15CD  26 08                              BNE Sub_15D7          
$15CF  96 9D                              LDA <$9D              
$15D1  5A                                 DECB                  
$15D2  26 03                              BNE Sub_15D7          
$15D4  CC 01 01                           LDD #$0101            
$15D7  FD 0C 9E            Sub_15D7:      STD $0C9E             
$15DA  35 86                              PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$15DC  7F 0C 9E            Sub_15DC:      CLR $0C9E             
$15DF  7C 0C 9E                           INC $0C9E             
$15E2  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$15E3  34 06               Sub_15E3:      PSHS A,B              
$15E5  FC 0C 9E                           LDD $0C9E             
$15E8  5C                                 INCB                  
$15E9  D1 9E                              CMPB <$9E             
$15EB  23 01                              BLS Sub_15EE          
$15ED  5A                                 DECB                  
$15EE  FD 0C 9E            Sub_15EE:      STD $0C9E             
$15F1  35 86                              PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$15F3  7F 0C 9E            Sub_15F3:      CLR $0C9E             
$15F6  7F 0C 9F                           CLR $0C9F             
$15F9  7C 0C 9E                           INC $0C9E             
$15FC  7C 0C 9F                           INC $0C9F             
$15FF  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1600  34 06               Sub_1600:      PSHS A,B              
$1602  FC 0C 9E                           LDD $0C9E             
$1605  FD 0C A0                           STD $0CA0             
$1608  35 06                              PULS A,B              
$160A  16 F8 C4                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$160D  34 06               Sub_160D:      PSHS A,B              
$160E  06                  Sub_160E:      EQU    $160E            ; [*24] branch target 1 byte(s) inside Sub_160D -- see [*24]
$160F  86 02                              LDA #$02               ; A = CurXY
$1611  A7 A0                              STA ,Y+               
$1613  FC 0C A0                           LDD $0CA0             
$1616  FD 0C 9E                           STD $0C9E             
$1619  8B 1F                              ADDA #$1F             
$161B  CB 1F                              ADDB #$1F             
$161D  A7 A0                              STA ,Y+               
$161F  E7 A0                              STB ,Y+               
$1621  F6 0C 96                           LDB $0C96             
$1624  CB 03                              ADDB #$03             
$1626  F7 0C 96                           STB $0C96             
$1629  35 06                              PULS A,B              
$162B  16 F8 A3                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$162E  34 16               Sub_162E:      PSHS A,B,X            
$1630  8E 0C 6D                           LDX #$0C6D            
$1633  86 02                              LDA #$02               ; A = CurXY
$1635  A7 A0                              STA ,Y+               
$1637  A6 01                              LDA 1,X               
$1639  27 0C                              BEQ Sub_1647          
$163B  81 FE                              CMPA #$FE             
$163D  26 04                              BNE Sub_1643          
$163F  A6 02                              LDA 2,X               
$1641  27 04                              BEQ Sub_1647          
$1643  91 9D               Sub_1643:      CMPA <$9D             
$1645  23 02                              BLS Sub_1649          
$1647  86 01               Sub_1647:      LDA #$01              
$1649  B7 0C 9E            Sub_1649:      STA $0C9E             
$164C  8B 1F                              ADDA #$1F             
$164E  A7 A0                              STA ,Y+               
$1650  A6 84                              LDA ,X                
$1652  27 04                              BEQ Sub_1658          
$1654  91 9E                              CMPA <$9E             
$1656  23 02                              BLS Sub_165A          
$1658  86 01               Sub_1658:      LDA #$01              
$165A  B7 0C 9F            Sub_165A:      STA $0C9F             
$165D  8B 1F                              ADDA #$1F             
$165F  A7 A0                              STA ,Y+               
$1661  F6 0C 96                           LDB $0C96             
$1664  CB 03                              ADDB #$03             
$1666  F7 0C 96                           STB $0C96             
$1669  35 16                              PULS A,B,X            
$166B  16 F8 63                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$166E  34 16               Sub_166E:      PSHS A,B,X            
$1670  8E 0C 6D                           LDX #$0C6D            
$1673  A6 84                              LDA ,X                
$1675  91 9D                              CMPA <$9D             
$1677  24 03                              BCC Sub_167C           ; C=0 (BHS)
$1679  4D                                 TSTA                  
$167A  26 02                              BNE Sub_167E          
$167C  86 01               Sub_167C:      LDA #$01              
$167E  BB 0C 9E            Sub_167E:      ADDB $0C9E            
$1681  91 9D                              CMPA <$9D             
$1683  23 02                              BLS Sub_1687          
$1685  96 9D                              LDA <$9D              
$1687  B7 0C 9E            Sub_1687:      STA $0C9E             
$168A  C6 02               Sub_168A:      LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$168C  E7 A0                              STB ,Y+               
$168E  FC 0C 9E                           LDD $0C9E             
$1691  8B 1F                              ADDA #$1F             
$1693  CB 1F                              ADDB #$1F             
$1695  A7 A0                              STA ,Y+               
$1697  E7 A0                              STB ,Y+               
$1699  F6 0C 96                           LDB $0C96             
$169C  CB 03                              ADDB #$03             
$169E  F7 0C 96                           STB $0C96             
$16A1  35 16                              PULS A,B,X            
$16A3  16 F8 2B                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$16A6  34 16               Sub_16A6:      PSHS A,B,X            
$16A8  8E 0C 6D                           LDX #$0C6D            
$16AB  A6 84                              LDA ,X                
$16AD  91 9D                              CMPA <$9D             
$16AF  24 03                              BCC Sub_16B4           ; C=0 (BHS)
$16B1  4D                                 TSTA                  
$16B2  26 02                              BNE Sub_16B6          
$16B4  86 01               Sub_16B4:      LDA #$01              
$16B6  B7 0C 91            Sub_16B6:      STA $0C91             
$16B9  B6 0C 9E                           LDA $0C9E             
$16BC  B0 0C 91                           SUBA $0C91            
$16BF  2E 02                              BGT Sub_16C3          
$16C1  86 01                              LDA #$01              
$16C3  B7 0C 9E            Sub_16C3:      STA $0C9E             
$16C6  20 C2                              BRA Sub_168A          

; --------------------------------------------------------------
$16C8  34 16               Sub_16C8:      PSHS A,B,X            
$16CA  8E 0C 6D                           LDX #$0C6D            
$16CD  A6 84                              LDA ,X                
$16CF  91 9E                              CMPA <$9E             
$16D1  24 03                              BCC Sub_16D6           ; C=0 (BHS)
$16D3  4D                                 TSTA                  
$16D4  26 02                              BNE Sub_16D8          
$16D6  86 01               Sub_16D6:      LDA #$01              
$16D8  B7 0C 91            Sub_16D8:      STA $0C91             
$16DB  B6 0C 9F            Sub_16DB:      LDA $0C9F             
$16DE  B0 0C 91            Sub_16DE:      SUBA $0C91            
$16E1  2E 02                              BGT Sub_16E5          
$16E3  86 01                              LDA #$01              
$16E5  B7 0C 9F            Sub_16E5:      STA $0C9F             
$16E8  20 A0                              BRA Sub_168A          

; --------------------------------------------------------------
$16EA  34 16               Sub_16EA:      PSHS A,B,X            
$16EC  8E 0C 6D                           LDX #$0C6D            
$16EF  A6 84                              LDA ,X                
$16F1  91 9E                              CMPA <$9E             
$16F3  24 03                              BCC Sub_16F8           ; C=0 (BHS)
$16F5  4D                                 TSTA                  
$16F6  26 02                              BNE Sub_16FA          
$16F8  86 01               Sub_16F8:      LDA #$01              
$16FA  BB 0C 9F            Sub_16FA:      ADDB $0C9F            
$16FD  91 9E                              CMPA <$9E             
$16FF  23 02                              BLS Sub_1703          
$1701  96 9E                              LDA <$9E              
$1703  B7 0C 9F            Sub_1703:      STA $0C9F             
$1706  16 FF 81                           LBRA Sub_168A         

; --------------------------------------------------------------
$1707  FF 81 34            Sub_1707:      STU $8134             
$1709  34 16               Sub_1709:      PSHS A,B,X            
$170B  C6 30                              LDB #$30               ; B = '0'
$170D  20 04                              BRA Sub_1713          

; --------------------------------------------------------------
$170F  34 16               Sub_170F:      PSHS A,B,X            
$1711  C6 31                              LDB #$31               ; B = '1'
$1712  31 B6               Sub_1712:      LEAY [A,Y]            
$1713  B6 0C 6D            Sub_1713:      LDA $0C6D             
$1716  27 16                              BEQ Sub_172E          
$1718  2A 02                              BPL Sub_171C          
$171A  86 01                              LDA #$01              
$171C  34 02               Sub_171C:      PSHS A                
$171E  86 1F                              LDA #$1F              
$1720  ED A1               Sub_1720:      STD ,Y++              
$1722  7C 0C 96                           INC $0C96             
$1725  7C 0C 96                           INC $0C96             
$1728  6A E4                              DEC ,S                
$172A  26 F4                              BNE Sub_1720          
$172C  35 02                              PULS A                
$172E  35 16               Sub_172E:      PULS A,B,X            
$1730  16 F7 9E                           LBRA Sub_0ED1         

; --------------------------------------------------------------
$1733  86 00               Sub_1733:      LDA #$00               ; A = NUL
$1735  10 8E 00 01                        LDY #$0001            
$1739  8E 06 1B                           LDX #$061B            
$173C  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$173F  86 00               Sub_173F:      LDA #$00               ; A = NUL
$1741  C6 27                              LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
$1743  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1746  97 4E                              STA <$4E              
$1748  1F 89               Sub_1748:      TFR A,B               
$174A  B6 06 1B                           LDA $061B             
$174D  7F 06 1B                           CLR $061B             
$1750  C5 07                              BITB #$07             
$1752  10 27 01 5B                        LBEQ Sub_18B1         
$1756  F6 0C BB                           LDB $0CBB             
$1759  C1 02                              CMPB #$02              ; compare B with CurXY
$175B  10 26 00 A5                        LBNE Sub_1804         
$175F  D6 4E                              LDB <$4E              
$1761  C5 06                              BITB #$06             
$1763  10 27 00 9D                        LBEQ Sub_1804         
$1767  C5 78                              BITB #$78             
$1769  10 27 00 97                        LBEQ Sub_1804         
$176D  81 8C                              CMPA #$8C             
$176F  26 04                              BNE Sub_1775          
$1771  86 41                              LDA #$41               ; A = 'A'
$1773  20 38                              BRA Sub_17AD          

; --------------------------------------------------------------
$1775  81 8A               Sub_1775:      CMPA #$8A             
$1777  26 04                              BNE Sub_177D          
$1779  86 42                              LDA #$42               ; A = 'B'
$177B  20 30                              BRA Sub_17AD          

; --------------------------------------------------------------
$177D  81 88               Sub_177D:      CMPA #$88             
$177F  26 04                              BNE Sub_1785          
$1781  86 44                              LDA #$44               ; A = 'D'
$1783  20 28                              BRA Sub_17AD          

; --------------------------------------------------------------
$1785  81 89               Sub_1785:      CMPA #$89             
$1787  26 04                              BNE Sub_178D          
$1789  86 43                              LDA #$43               ; A = 'C'
$178B  20 20                              BRA Sub_17AD          

; --------------------------------------------------------------
$178D  81 13               Sub_178D:      CMPA #$13              ; compare A with XOFF
$178F  26 04                              BNE Sub_1795          
$1791  86 48                              LDA #$48               ; A = 'H'
$1793  20 18                              BRA Sub_17AD          

; --------------------------------------------------------------
$1795  81 12               Sub_1795:      CMPA #$12             
$1797  26 04                              BNE Sub_179D          
$1799  86 4B                              LDA #$4B               ; A = 'K'
$179B  20 10                              BRA Sub_17AD          

; --------------------------------------------------------------
$179D  81 10               Sub_179D:      CMPA #$10             
$179F  26 04                              BNE Sub_17A5          
$17A1  86 50                              LDA #$50               ; A = 'P'
$17A3  20 08                              BRA Sub_17AD          

; --------------------------------------------------------------
$17A5  81 11               Sub_17A5:      CMPA #$11              ; compare A with XON
$17A7  10 26 00 59                        LBNE Sub_1804         
$17AB  86 40                              LDA #$40               ; A = '@'
$17AD  8E 04 FC            Sub_17AD:      LDX #$04FC            
$17B0  A7 02                              STA 2,X               
$17B2  34 02                              PSHS A                
$17B4  CC 1B 5B                           LDD #$1B5B             ; D=ESC+$5B
$17B7  ED 84                              STD ,X                
$17B9  96 38                              LDA <$38              
$17BB  10 8E 00 03                        LDY #$0003            
$17BF  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$17C2  35 02                              PULS A                
$17C4  7D 0C BC                           TST $0CBC             
$17C7  10 27 F6 5F                        LBEQ Sub_0E2A         
$17CB  81 41                              CMPA #$41              ; compare A with 'A'
$17CD  26 04                              BNE Sub_17D3          
$17CF  86 09                              LDA #$09              
$17D1  20 20                              BRA Sub_17F3          

; --------------------------------------------------------------
$17D3  81 42               Sub_17D3:      CMPA #$42              ; compare A with 'B'
$17D5  26 04                              BNE Sub_17DB          
$17D7  86 0A                              LDA #$0A               ; A = LF
$17D9  20 18                              BRA Sub_17F3          

; --------------------------------------------------------------
$17DB  81 43               Sub_17DB:      CMPA #$43              ; compare A with 'C'
$17DD  26 04                              BNE Sub_17E3          
$17DF  86 06                              LDA #$06              
$17E1  20 10                              BRA Sub_17F3          

; --------------------------------------------------------------
$17E3  81 44               Sub_17E3:      CMPA #$44              ; compare A with 'D'
$17E5  26 04                              BNE Sub_17EB          
$17E7  86 08                              LDA #$08               ; A = BS
$17E9  20 08                              BRA Sub_17F3          

; --------------------------------------------------------------
$17EB  81 48               Sub_17EB:      CMPA #$48              ; compare A with 'H'
$17ED  10 26 F6 39                        LBNE Sub_0E2A         
$17F1  86 01                              LDA #$01              
$17F3  8E 04 FC            Sub_17F3:      LDX #$04FC            
$17F5  FC A7 84            Sub_17F5:      LDD $A784             
$17F7  84 86               Sub_17F7:      ANDA #$86             
$17F9  01                                 FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
$17FA  10 8E 00 01                        LDY #$0001            
$17FE  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1801  16 F6 26                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1804  D6 4E               Sub_1804:      LDB <$4E              
$1806  C5 04                              BITB #$04             
$1808  10 27 00 8B                        LBEQ Sub_1897         
$180C  81 F1                              CMPA #$F1             
$180E  10 27 05 8C                        LBEQ Sub_1D9E         
$1812  81 E8                              CMPA #$E8             
$1814  10 27 03 C3                        LBEQ Sub_1BDB         
$1818  81 AF                              CMPA #$AF             
$181A  10 27 FA E3                        LBEQ Sub_1301         
$181E  81 E1                              CMPA #$E1             
$1820  10 27 17 D6                        LBEQ Sub_2FFA         
$1824  81 E2                              CMPA #$E2             
$1826  26 03                              BNE Sub_182B          
$1828  17 07 76                           LBSR Sub_1FA1          ; call Sub_1FA1
$182B  81 E9               Sub_182B:      CMPA #$E9             
$182D  26 03                              BNE Sub_1832          
$182F  16 01 7B                           LBRA Sub_19AD         

; --------------------------------------------------------------
$1832  81 F4               Sub_1832:      CMPA #$F4             
$1834  26 03                              BNE Sub_1839          
$1836  17 08 6E                           LBSR Sub_20A7          ; call Sub_20A7
$1839  81 F5               Sub_1839:      CMPA #$F5             
$183B  26 03                              BNE Sub_1840          
$183D  17 17 7F                           LBSR Sub_2FBF          ; call Sub_2FBF
$1840  81 E3               Sub_1840:      CMPA #$E3             
$1842  26 03                              BNE Sub_1847          
$1844  17 08 E6                           LBSR Sub_212D          ; call Sub_212D
$1847  81 EC               Sub_1847:      CMPA #$EC             
$1849  26 03                              BNE Sub_184E          
$184B  17 08 FF                           LBSR Sub_214D          ; call Sub_214D
$184E  81 85               Sub_184E:      CMPA #$85             
$1850  26 03                              BNE Sub_1855          
$1852  17 07 33                           LBSR Sub_1F88          ; call Sub_1F88
$1855  81 F2               Sub_1855:      CMPA #$F2             
$1857  10 27 00 C3                        LBEQ Sub_191E         
$185B  81 F3                              CMPA #$F3             
$185D  10 27 00 CE                        LBEQ Sub_192F         
$1861  81 8A                              CMPA #$8A             
$1863  10 27 1D D6                        LBEQ Sub_363D         
$1867  81 8C                              CMPA #$8C             
$1869  10 27 1E 25                        LBEQ Sub_3692         
$186D  81 EF                              CMPA #$EF             
$186F  26 03                              BNE Sub_1874          
$1871  17 09 C9                           LBSR Sub_223D          ; call Sub_223D
$1874  81 ED               Sub_1874:      CMPA #$ED             
$1876  26 03                              BNE Sub_187B          
$1878  17 0D 29                           LBSR Sub_25A4          ; call Sub_25A4
$187B  81 E4               Sub_187B:      CMPA #$E4             
$187D  26 03                              BNE Sub_1882          
$187F  17 0C 76                           LBSR Sub_24F8          ; call Sub_24F8
$1882  81 FA               Sub_1882:      CMPA #$FA             
$1884  26 03                              BNE Sub_1889          
$1886  17 0F A7                           LBSR Sub_2830          ; call Sub_2830
$1889  81 B1               Sub_1889:      CMPA #$B1             
$188B  25 2A                              BCS Sub_18B7           ; C=1 (BLO)
$188D  81 B8                              CMPA #$B8             
$188F  22 26                              BHI Sub_18B7          
$1891  17 03 DD                           LBSR Sub_1C71          ; call Sub_1C71
$1894  16 F5 93                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1897  C5 78               Sub_1897:      BITB #$78             
$1899  27 16                              BEQ Sub_18B1          
$189B  81 1A                              CMPA #$1A              ; compare A with SUB
$189D  10 27 1D 9C                        LBEQ Sub_363D         
$18A1  81 1C                              CMPA #$1C             
$18A3  10 27 1D EB                        LBEQ Sub_3692         
$18A7  81 18                              CMPA #$18             
$18A9  10 26 F5 7D                        LBNE Sub_0E2A         
$18AD  86 7F                              LDA #$7F              
$18AF  20 06                              BRA Sub_18B7          

; --------------------------------------------------------------
$18B1  81 B1               Sub_18B1:      CMPA #$B1             
$18B3  10 27 FA 4A                        LBEQ Sub_1301         
$18B7  81 7F               Sub_18B7:      CMPA #$7F             
$18B9  22 60                              BHI Sub_191B          
$18BB  B7 04 FC                           STA $04FC             
$18BE  7D 0C BF                           TST $0CBF             
$18C1  27 0E                              BEQ Sub_18D1          
$18C3  86 01                              LDA #$01              
$18C5  C6 98                              LDB #$98              
$18C7  8E 28 01                           LDX #$2801            
$18CA  10 8E 09 00                        LDY #$0900            
$18CE  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$18D1  10 8E 00 01         Sub_18D1:      LDY #$0001            
$18D5  8E 04 FC                           LDX #$04FC            
$18D8  A6 84                              LDA ,X                
$18DA  81 0D                              CMPA #$0D              ; compare A with CR
$18DC  26 0B                              BNE Sub_18E9          
$18DE  7D 0C BE                           TST $0CBE             
$18E1  27 06                              BEQ Sub_18E9          
$18E3  86 0A                              LDA #$0A               ; A = LF
$18E5  A7 01                              STA 1,X               
$18E7  31 21                              LEAY 1,Y              
$18E9  96 38               Sub_18E9:      LDA <$38              
$18EB  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$18EE  7D 04 FC                           TST $04FC             
$18F1  2B 28                              BMI Sub_191B          
$18F3  B6 0C BC                           LDA $0CBC             
$18F6  27 23                              BEQ Sub_191B          
$18F8  7D 0C BD                           TST $0CBD             
$18FB  27 12                              BEQ Sub_190F          
$18FD  B6 04 FC                           LDA $04FC             
$1900  81 0D                              CMPA #$0D              ; compare A with CR
$1902  26 0B                              BNE Sub_190F          
$1904  86 0A                              LDA #$0A               ; A = LF
$1906  B7 04 FD                           STA $04FD             
$1909  10 8E 00 02                        LDY #$0002            
$190D  20 04                              BRA Sub_1913          

; --------------------------------------------------------------
$190F  10 8E 00 01         Sub_190F:      LDY #$0001            
$1913  8E 04 FC            Sub_1913:      LDX #$04FC            
$1916  86 01                              LDA #$01              
$1918  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$191B  16 F5 0C            Sub_191B:      LBRA Sub_0E2A         
$191E  34 32               Sub_191E:      PSHS A,X,Y            
$1920  30 8D EA D8                        LEAX Dat_03FC,PC       ; X → Dat_03FC
$1924  17 04 6E                           LBSR Sub_1D95          ; call Sub_1D95
$1927  17 05 AD                           LBSR Sub_1ED7          ; call Sub_1ED7
$192A  35 32                              PULS A,X,Y            
$192C  16 F4 FB                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$192F  34 40               Sub_192F:      PSHS U                
$1931  17 FB F5                           LBSR Sub_1529          ; call Sub_1529
$1934  C6 13                              LDB #$13               ; B = XOFF
$1936  31 8D EA 9E                        LEAY Dat_03D8,PC       ; Y → Dat_03D8
$193A  8E 13 C3                           LDX #$13C3            
$193D  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$1941  8E 13 C3                           LDX #$13C3            
$1944  96 9D                              LDA <$9D              
$1946  A7 05                              STA 5,X               
$1948  96 9E                              LDA <$9E              
$194A  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$194B  4D                                 TSTA                  
$194C  27 02                              BEQ Sub_1950          
$194E  80 03                              SUBA #$03             
$1950  A7 06               Sub_1950:      STA 6,X               
$1952  B6 0C C7                           LDA $0CC7             
$1955  17 05 74                           LBSR Sub_1ECC          ; call Sub_1ECC
$1958  A7 07                              STA 7,X               
$195A  B6 0C C8                           LDA $0CC8             
$195D  17 05 6C                           LBSR Sub_1ECC          ; call Sub_1ECC
$1960  A7 08                              STA 8,X               
$1962  86 01                              LDA #$01              
$1964  10 8E 00 09                        LDY #$0009            
$1968  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$196B  33 8D E9 8C                        LEAU Dat_02FB,PC       ; U → Dat_02FB
$196F  30 8D E9 83                        LEAX Dat_02F6,PC       ; X → Dat_02F6
$1973  5F                                 CLRB                   ; B = 0
$1974  86 11                              LDA #$11               ; A = XON
$1976  10 3F 03                           OS9 F$Fork             ; module→D:X  args→Y  size=D
$1979  35 40                              PULS U                
$197B  25 11                              BCS Sub_198E           ; C=1 (BLO)
$197D  97 7F                              STA <$7F              
$197F  8E 00 01            Sub_197F:      LDX #$0001            
$1982  17 F7 F3                           LBSR Sub_1178          ; call Sub_1178
$1985  10 3F 04                           OS9 F$Wait             ; → wait for child; status→D
$1988  25 04                              BCS Sub_198E           ; C=1 (BLO)
$198A  91 7F                              CMPA <$7F             
$198C  26 F1                              BNE Sub_197F          
$198E  86 01               Sub_198E:      LDA #$01              
$1990  30 8D EA 58                        LEAX Dat_03EC,PC       ; X → Dat_03EC
$1994  10 8E 00 02                        LDY #$0002            
$1998  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$199B  17 FB 07                           LBSR Sub_14A5          ; call Sub_14A5
$199E  16 F4 89                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$19A1  A6 80               Sub_19A1:      LDA ,X+               
$19A3  A7 A0                              STA ,Y+               
$19A5  81 20                              CMPA #$20              ; compare A with ' '
$19A7  27 03                              BEQ Sub_19AC          
$19A9  5A                                 DECB                  
$19AA  26 F5                              BNE Sub_19A1          
$19AB  F5 39 0D            Sub_19AB:      BITB $390D            
$19AC  39                  Sub_19AC:      RTS                    ; return from subroutine
$19AD  0D                  Sub_19AD:      EQU    $19AD            ; [*25] branch target 1 byte(s) inside Sub_19AC -- see [*25]
$19AE  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$19AF  27 09                              BEQ Sub_19BA          
$19B1  96 7E                              LDA <$7E              
$19B3  27 08                              BEQ Sub_19BD          
$19B5  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$19B6  7E 17 F7                           JMP $17F7             
$19B9  88 16                              EORA #$16             
$19BA  16 F4 6D            Sub_19BA:      LBRA Sub_0E2A         
$19BD  0C                  Sub_19BD:      EQU    $19BD            ; [*26] branch target 3 byte(s) inside Sub_19BA -- see [*26]
$19BE  7E 30 8D                           JMP $308D             
$19C1  E9 CF 10 8E                        ADCB [$108E]          
$19C5  00                                 FCB    $00                ; undefined opcode $00 -- not a valid 6809 instruction
$19C6  80 C6                              SUBA #$C6             
$19C8  0B                                 FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
$19C9  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$19CD  8E 00 80                           LDX #$0080            
$19D0  10 8E 00 0B                        LDY #$000B            
$19D4  96 4B                              LDA <$4B              
$19D6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$19D9  96 7C                              LDA <$7C              
$19DB  97 7D                              STA <$7D              
$19DD  20 DB                              BRA Sub_19BA          

; --------------------------------------------------------------
$19DF  CC 08 02            Sub_19DF:      LDD #$0802            
$19E2  FD 0C 9A                           STD $0C9A             
$19E5  CC 40 0A                           LDD #$400A            
$19E8  FD 0C 9C                           STD $0C9C             
$19EB  17 05 03                           LBSR Sub_1EF1          ; call Sub_1EF1
$19EE  30 8D E9 1B                        LEAX Dat_030D,PC       ; X → Dat_030D
$19F2  17 03 A0                           LBSR Sub_1D95          ; call Sub_1D95
$19F5  30 8D EA BC                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$19F9  17 03 99                           LBSR Sub_1D95          ; call Sub_1D95
$19FC  8E 13 C3                           LDX #$13C3            
$19FF  86 01                              LDA #$01              
$1A01  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$1A03  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1A06  8E 13 C3                           LDX #$13C3            
$1A09  86 01                              LDA #$01              
$1A0B  A7 05                              STA 5,X               
$1A0D  6F 07                              CLR 7,X               
$1A0F  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$1A11  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1A14  86 00                              LDA #$00               ; A = NUL
$1A16  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1A19  97 79                              STA <$79              
$1A1B  86 00                              LDA #$00               ; A = NUL
$1A1D  10 3F 8F                           OS9 I$Close            ; path=A
$1A20  96 38                              LDA <$38              
$1A22  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1A25  34 40                              PSHS U                
$1A27  33 8D E8 D4                        LEAU Dat_02FF,PC       ; U → Dat_02FF
$1A2B  30 8D E8 CD                        LEAX Dat_02FC,PC       ; X → Dat_02FC
$1A2F  10 8E 00 0E                        LDY #$000E            
$1A33  5F                                 CLRB                   ; B = 0
$1A34  86 11                              LDA #$11               ; A = XON
$1A36  10 3F 03                           OS9 F$Fork             ; module→D:X  args→Y  size=D
$1A39  35 40                              PULS U                
$1A3B  34 01                              PSHS CC               
$1A3D  97 7F                              STA <$7F              
$1A3F  86 00                              LDA #$00               ; A = NUL
$1A41  10 3F 8F                           OS9 I$Close            ; path=A
$1A44  96 79                              LDA <$79              
$1A46  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1A49  96 79                              LDA <$79              
$1A4B  10 3F 8F                           OS9 I$Close            ; path=A
$1A4E  35 01                              PULS CC               
$1A50  25 55                              BCS Sub_1AA7           ; C=1 (BLO)
$1A52  8E 00 01            Sub_1A52:      LDX #$0001            
$1A55  17 F7 20                           LBSR Sub_1178          ; call Sub_1178
$1A58  86 00                              LDA #$00               ; A = NUL
$1A5A  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$1A5C  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1A5F  25 32                              BCS Sub_1A93           ; C=1 (BLO)
$1A61  4F                                 CLRA                   ; A = 0
$1A62  C1 00                              CMPB #$00              ; compare B with NUL
$1A64  27 2D                              BEQ Sub_1A93          
$1A66  1F 02                              TFR D,Y               
$1A68  8E 13 C3                           LDX #$13C3            
$1A6B  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$1A6E  B6 13 C3                           LDA $13C3             
$1A71  81 05                              CMPA #$05             
$1A73  26 1E                              BNE Sub_1A93          
$1A75  17 01 59                           LBSR Sub_1BD1          ; call Sub_1BD1
$1A78  8E 00 2D                           LDX #$002D            
$1A7B  17 F6 FA                           LBSR Sub_1178          ; call Sub_1178
$1A7E  96 38                              LDA <$38              
$1A80  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$1A82  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1A85  25 20                              BCS Sub_1AA7           ; C=1 (BLO)
$1A87  1F 02                              TFR D,Y               
$1A89  8E 13 C3                           LDX #$13C3            
$1A8C  96 38                              LDA <$38              
$1A8E  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$1A91  20 14                              BRA Sub_1AA7          

; --------------------------------------------------------------
$1A93  10 3F 04            Sub_1A93:      OS9 F$Wait             ; → wait for child; status→D
$1A96  25 0F                              BCS Sub_1AA7           ; C=1 (BLO)
$1A98  91 7F                              CMPA <$7F             
$1A9A  26 B6                              BNE Sub_1A52          
$1A9C  5D                                 TSTB                  
$1A9D  27 05                              BEQ Sub_1AA4          
$1A9F  17 11 C0                           LBSR Sub_2C62          ; call Sub_2C62
$1AA2  20 03                              BRA Sub_1AA7          

; --------------------------------------------------------------
$1AA4  17 04 D6            Sub_1AA4:      LBSR Sub_1F7D          ; call Sub_1F7D
$1AA7  17 04 A9            Sub_1AA7:      LBSR Sub_1F53          ; call Sub_1F53
$1AAA  30 8D EA 03                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$1AAE  17 02 E4                           LBSR Sub_1D95          ; call Sub_1D95
$1AB1  17 F9 F1                           LBSR Sub_14A5          ; call Sub_14A5
$1AB4  17 03 7C                           LBSR Sub_1E33          ; call Sub_1E33
$1AB7  16 F3 70                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1ABA  CC 08 02            Sub_1ABA:      LDD #$0802            
$1ABD  FD 0C 9A                           STD $0C9A             
$1AC0  CC 40 0A                           LDD #$400A            
$1AC3  FD 0C 9C                           STD $0C9C             
$1AC6  17 04 28                           LBSR Sub_1EF1          ; call Sub_1EF1
$1AC9  30 8D E8 81                        LEAX Dat_034E,PC       ; X → Dat_034E
$1ACD  17 02 C5                           LBSR Sub_1D95          ; call Sub_1D95
$1AD0  10 8E 07 1A                        LDY #$071A            
$1AD4  10 9F 53                           STY <$53              
$1AD7  30 8D E8 64                        LEAX Dat_033F,PC       ; X → Dat_033F
$1ADB  A6 80               Sub_1ADB:      LDA ,X+               
$1ADD  27 04                              BEQ Sub_1AE3          
$1ADF  A7 A0                              STA ,Y+               
$1AE1  20 F8                              BRA Sub_1ADB          

; --------------------------------------------------------------
$1AE3  86 20               Sub_1AE3:      LDA #$20               ; A = ' '
$1AE5  A7 A0                              STA ,Y+               
$1AE7  30 8D EA 9A         Sub_1AE7:      LEAX Dat_0585,PC       ; X → Dat_0585
$1AEB  34 20                              PSHS Y                
$1AED  17 02 A5                           LBSR Sub_1D95          ; call Sub_1D95
$1AF0  35 20                              PULS Y                
$1AF2  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$1AF4  17 02 F9                           LBSR Sub_1DF0          ; call Sub_1DF0
$1AF7  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1AF8  30 10                              LEAX -16,X            
$1AFA  26 00                              BNE Sub_1AFC          
$1AFC  BE 8E 06            Sub_1AFC:      LDX $8E06             
$1AFF  1B                                 FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
$1B00  F6 00 2C                           LDB $002C             
$1B03  C1 01                              CMPB #$01             
$1B05  27 0D                              BEQ Sub_1B14          
$1B07  A6 80               Sub_1B07:      LDA ,X+               
$1B09  A7 A0                              STA ,Y+               
$1B0B  5A                                 DECB                  
$1B0C  26 F9                              BNE Sub_1B07          
$1B0E  86 20                              LDA #$20               ; A = ' '
$1B10  A7 3F                              STA -1,Y              
$1B12  20 D3                              BRA Sub_1AE7          

; --------------------------------------------------------------
$1B14  86 0D               Sub_1B14:      LDA #$0D               ; A = CR
$1B16  A7 A0                              STA ,Y+               
$1B18  1F 20                              TFR Y,D               
$1B1A  93 53                              SUBD <$53             
$1B1C  DD 53                              STD <$53              
$1B1E  10 83 00 07                        CMPD #$0007           
$1B22  10 25 00 98                        LBCS Sub_1BBE         
$1B26  17 06 04                           LBSR Sub_212D          ; call Sub_212D
$1B29  30 8D E9 88                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$1B2D  17 02 65                           LBSR Sub_1D95          ; call Sub_1D95
$1B30  8E 13 C3                           LDX #$13C3            
$1B33  86 01                              LDA #$01              
$1B35  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$1B37  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1B3A  86 01                              LDA #$01              
$1B3C  8E 13 C3                           LDX #$13C3            
$1B3F  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$1B41  A7 05                              STA 5,X               
$1B43  6F 07                              CLR 7,X               
$1B45  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1B48  86 00                              LDA #$00               ; A = NUL
$1B4A  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1B4D  97 79                              STA <$79              
$1B4F  86 00                              LDA #$00               ; A = NUL
$1B51  10 3F 8F                           OS9 I$Close            ; path=A
$1B54  96 38                              LDA <$38              
$1B56  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1B59  10 9E 53                           LDY <$53              
$1B5C  34 40                              PSHS U                
$1B5E  CE 07 1A                           LDU #$071A            
$1B61  30 8D E7 D7                        LEAX Dat_033C,PC       ; X → Dat_033C
$1B65  5F                                 CLRB                   ; B = 0
$1B66  86 11                              LDA #$11               ; A = XON
$1B68  10 3F 03                           OS9 F$Fork             ; module→D:X  args→Y  size=D
$1B6B  35 40                              PULS U                
$1B6D  34 01                              PSHS CC               
$1B6F  97 7F                              STA <$7F              
$1B71  86 00                              LDA #$00               ; A = NUL
$1B73  10 3F 8F                           OS9 I$Close            ; path=A
$1B76  96 79                              LDA <$79              
$1B78  10 3F 82                           OS9 I$Dup              ; path=A  → new path→A
$1B7B  96 79                              LDA <$79              
$1B7D  10 3F 8F                           OS9 I$Close            ; path=A
$1B80  35 01                              PULS CC               
$1B82  25 3A                              BCS Sub_1BBE           ; C=1 (BLO)
$1B84  8E 00 01            Sub_1B84:      LDX #$0001            
$1B87  17 F5 EE                           LBSR Sub_1178          ; call Sub_1178
$1B8A  86 00                              LDA #$00               ; A = NUL
$1B8C  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$1B8E  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1B91  25 17                              BCS Sub_1BAA           ; C=1 (BLO)
$1B93  4F                                 CLRA                   ; A = 0
$1B94  C1 00                              CMPB #$00              ; compare B with NUL
$1B96  27 12                              BEQ Sub_1BAA          
$1B98  1F 02                              TFR D,Y               
$1B9A  8E 13 C3                           LDX #$13C3            
$1B9D  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$1BA0  B6 13 C3                           LDA $13C3             
$1BA3  81 05                              CMPA #$05             
$1BA5  26 03                              BNE Sub_1BAA          
$1BA7  17 00 27                           LBSR Sub_1BD1          ; call Sub_1BD1
$1BAA  10 3F 04            Sub_1BAA:      OS9 F$Wait             ; → wait for child; status→D
$1BAD  25 0F                              BCS Sub_1BBE           ; C=1 (BLO)
$1BAF  91 7F                              CMPA <$7F             
$1BB1  26 D1                              BNE Sub_1B84          
$1BB3  5D                                 TSTB                  
$1BB4  27 05                              BEQ Sub_1BBB          
$1BB6  17 10 A9                           LBSR Sub_2C62          ; call Sub_2C62
$1BB9  20 03                              BRA Sub_1BBE          

; --------------------------------------------------------------
$1BBB  17 03 BF            Sub_1BBB:      LBSR Sub_1F7D          ; call Sub_1F7D
$1BBE  17 03 92            Sub_1BBE:      LBSR Sub_1F53          ; call Sub_1F53
$1BC1  17 F8 E1                           LBSR Sub_14A5          ; call Sub_14A5
$1BC4  30 8D E8 E9                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$1BC8  17 01 CA                           LBSR Sub_1D95          ; call Sub_1D95
$1BCB  17 02 65            Sub_1BCB:      LBSR Sub_1E33          ; call Sub_1E33
$1BCE  16 F2 59                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1BD1  96 7F               Sub_1BD1:      LDA <$7F              
$1BD3  5F                                 CLRB                   ; B = 0
$1BD4  10 3F 08                           OS9 F$Send             ; pid=A  signal=B
$1BD7  10 3F 04                           OS9 F$Wait             ; → wait for child; status→D
$1BDA  39                  Insn_1BDA:     RTS                    ; return from subroutine
$1BDB  0D                  Sub_1BDB:      EQU    $1BDB            ; [*27] branch target 1 byte(s) inside Insn_1BDA -- see [*27]
$1BDC  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$1BDD  27 05                              BEQ Sub_1BE4          
$1BDF  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$1BE0  7E 17 F5                           JMP $17F5             
$1BE3  5E                                 FCB    $5E                ; undefined opcode $5E -- not a valid 6809 instruction
$1BE4  7F 0C 8F            Sub_1BE4:      CLR $0C8F             
$1BE7  CC 21 05                           LDD #$2105            
$1BEA  FD 0C 9A                           STD $0C9A             
$1BED  CC 0E 03                           LDD #$0E03            
$1BF0  FD 0C 9C                           STD $0C9C             
$1BF3  17 02 FB                           LBSR Sub_1EF1          ; call Sub_1EF1
$1BF6  30 8D E8 BB                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$1BFA  17 01 98                           LBSR Sub_1D95          ; call Sub_1D95
$1BFD  30 8D E7 74                        LEAX Dat_0375,PC       ; X → Dat_0375
$1C01  17 01 91                           LBSR Sub_1D95          ; call Sub_1D95
$1C04  7D 0C C0                           TST $0CC0             
$1C07  26 2B                              BNE Sub_1C34          
$1C09  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1C0A  29 27                              BVS Sub_1C33          
$1C0C  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$1C0D  96 38                              LDA <$38              
$1C0F  C6 2B                              LDB #$2B               ; B = SS.CtlSg  (GetStt/SetStt subcode)
$1C11  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1C13  8E 8E 00            Sub_1C13:      LDX #$8E00            
$1C16  3C 17                              CWAI #$17             
$1C18  F5 5E 20                           BITB $5E20            
$1C1B  41                                 FCB    $41                ; undefined opcode $41 -- not a valid 6809 instruction
$1C1C  9E 20                              LDX <$20              
$1C1E  E6 02                              LDB 2,X               
$1C20  C4 FE                              ANDB #$FE             
$1C22  E7 02                              STB 2,X               
$1C24  8E 00 3C                           LDX #$003C            
$1C27  17 F5 4E                           LBSR Sub_1178          ; call Sub_1178
$1C2A  9E 20                              LDX <$20              
$1C2C  E6 02                              LDB 2,X               
$1C2E  CA 01                              ORB #$01              
$1C30  E7 02                              STB 2,X               
$1C32  20 29                              BRA $1C5D             

; --------------------------------------------------------------
$1C33  29 96               Sub_1C33:      BVS Sub_1BCB          
$1C34  96 38               Sub_1C34:      LDA <$38              
$1C36  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$1C38  30 8D EE 43         Sub_1C38:      LEAX Dat_0A7F,PC       ; X → Dat_0A7F
$1C3B  43                  Sub_1C3B:      COMA                  
$1C3C  10 8E 00 01                        LDY #$0001            
$1C40  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1C43  8E 00 0C                           LDX #$000C            
$1C46  17 F5 2F                           LBSR Sub_1178          ; call Sub_1178
$1C49  5A                                 DECB                  
$1C4A  26 EC                              BNE Sub_1C38          
$1C4C  8E 00 80                           LDX #$0080            
$1C4F  17 F5 26                           LBSR Sub_1178          ; call Sub_1178
$1C52  30 8D E6 9C                        LEAX Dat_02F2,PC       ; X → Dat_02F2
$1C56  10 8E 00 04                        LDY #$0004            
$1C5A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1C5D  17 02 F3                           LBSR Sub_1F53          ; call Sub_1F53
$1C60  30 8D E8 4D                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$1C64  17 01 2E                           LBSR Sub_1D95          ; call Sub_1D95
$1C67  16 F1 C0                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1C6A  34 36               Sub_1C6A:      PSHS A,B,X,Y          
$1C6C  8E 13 3B                           LDX #$133B            
$1C6F  20 0C                              BRA $1C7D             

; --------------------------------------------------------------
$1C71  34 36               Sub_1C71:      PSHS A,B,X,Y          
$1C73  80 B1                              SUBA #$B1             
$1C75  C6 80                              LDB #$80              
$1C77  3D                                 MUL                    ; D = A×B unsigned
$1C78  8E 0D 3B                           LDX #$0D3B            
$1C7B  30 8B                              LEAX D,X              
$1C7D  34 10                              PSHS X                
$1C7F  5F                                 CLRB                   ; B = 0
$1C80  A6 80                              LDA ,X+               
$1C82  5C                                 INCB                  
$1C83  C1 80                              CMPB #$80             
$1C85  22 04                              BHI $1C8B             
$1C87  81 0D                              CMPA #$0D              ; compare A with CR
$1C89  26 F5                              BNE $1C80             
$1C8B  5A                                 DECB                  
$1C8C  4F                                 CLRA                   ; A = 0
$1C8D  35 10                              PULS X                
$1C8F  5D                                 TSTB                  
$1C90  27 0C                              BEQ $1C9E             
$1C92  A6 80               Sub_1C92:      LDA ,X+               
$1C94  5A                                 DECB                  
$1C95  81 5C                              CMPA #$5C              ; compare A with '\'
$1C97  27 13                              BEQ Sub_1CAC          
$1C99  8D 2E                              BSR Sub_1CC9           ; call Sub_1CC9
$1C9B  5D                  Sub_1C9B:      TSTB                  
$1C9C  26 F4                              BNE Sub_1C92          
$1C9E  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1CA0  34 10               Sub_1CA0:      PSHS X                
$1CA2  8E 00 1E                           LDX #$001E            
$1CA4  1E 17               Sub_1CA4:      EXG X,V               
$1CA6  F4 D0 35                           ANDB $D035            
$1CA9  10 20 EF A6                        LBRA Sub_0C53         

; --------------------------------------------------------------
$1CAC  A6 80               Sub_1CAC:      LDA ,X+               
$1CAE  5A                                 DECB                  
$1CAF  81 5E                              CMPA #$5E              ; compare A with '^'
$1CB1  27 12                              BEQ Sub_1CC5          
$1CB3  81 2A                              CMPA #$2A              ; compare A with '*'
$1CB5  27 E9                              BEQ Sub_1CA0          
$1CB7  81 5C                              CMPA #$5C              ; compare A with '\'
$1CB9  27 06                              BEQ Sub_1CC1          
$1CBB  81 2B                              CMPA #$2B              ; compare A with '+'
$1CBD  27 1C                              BEQ Sub_1CDB          
$1CBF  80 40                              SUBA #$40             
$1CC1  8D 06               Sub_1CC1:      BSR Sub_1CC9           ; call Sub_1CC9
$1CC3  20 D6                              BRA Sub_1C9B          

; --------------------------------------------------------------
$1CC5  86 1B               Sub_1CC5:      LDA #$1B               ; A = ESC
$1CC7  20 F8                              BRA Sub_1CC1          

; --------------------------------------------------------------
$1CC9  34 32               Sub_1CC9:      PSHS A,X,Y            
$1CCB  8E 13 C3                           LDX #$13C3            
$1CCE  A7 84                              STA ,X                
$1CD0  10 8E 00 01                        LDY #$0001            
$1CD4  96 38                              LDA <$38              
$1CD6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1CD9  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1CDB  34 36               Sub_1CDB:      PSHS A,B,X,Y          
$1CDD  8E 13 C3            Sub_1CDD:      LDX #$13C3            
$1CE0  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$1CE3  8E 13 C3                           LDX #$13C3            
$1CE5  C3 EC 01            Sub_1CE5:      ADDD #$EC01           
$1CE8  34 02                              PSHS A                
$1CEA  8D 19                              BSR Sub_1D05           ; call Sub_1D05
$1CEC  ED 03                              STD 3,X               
$1CEE  86 5F                              LDA #$5F               ; A = '_'
$1CF0  A7 02                              STA 2,X               
$1CF2  35 04                              PULS B                
$1CF4  8D 0F                              BSR Sub_1D05           ; call Sub_1D05
$1CF6  ED 84                              STD ,X                
$1CF8  96 38               Insn_1CF8:     LDA <$38              
$1CF9  38                  Sub_1CF9:      EQU    $1CF9            ; [*28] branch target 1 byte(s) inside Insn_1CF8 -- see [*28]
$1CFA  10 8E 00 05                        LDY #$0005            
$1CFE  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D01  35 36                              PULS A,B,X,Y          
$1D03  20 96                              BRA Sub_1C9B          

; --------------------------------------------------------------
$1D05  86 30               Sub_1D05:      LDA #$30               ; A = '0'
$1D07  CB 30                              ADDB #$30             
$1D09  C1 3A               Sub_1D09:      CMPB #$3A              ; compare B with ':'
$1D0B  25 05                              BCS Sub_1D12           ; C=1 (BLO)
$1D0D  4C                                 INCA                  
$1D0E  C0 0A                              SUBB #$0A             
$1D10  20 F7                              BRA Sub_1D09          

; --------------------------------------------------------------
$1D11  F7 39 34            Sub_1D11:      STB $3934             
$1D12  39                  Sub_1D12:      RTS                    ; return from subroutine
$1D13  34 32               Sub_1D13:      PSHS A,X,Y            
$1D14  32 CC 1B            Insn_1D14:     LEAS Dat_1D32,PC      
$1D16  1B                  Sub_1D16:      EQU    $1D16            ; [*29] branch target 1 byte(s) inside Insn_1D15 -- see [*29]
$1D17  24 FD                              BCC Sub_1D16           ; C=0 (BHS)
$1D19  13                                 SYNC                   ; wait for interrupt
$1D1A  C3 86 01                           ADDD #$8601           
$1D1D  10 8E 00 02                        LDY #$0002            
$1D21  8E 13 C3                           LDX #$13C3            
$1D24  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D27  31 8D E7 64                        LEAY Dat_048F,PC       ; Y → Dat_048F
$1D2B  8E 13 C3                           LDX #$13C3            
$1D2E  C6 0C                              LDB #$0C               ; B = FF
$1D30  AD 9F 0C B1         Insn_1D30:     JSR [$0CB1]            ; call via indexed pointer

Dat_1D32
; ── 9 bytes  ($1D32—$1D3A) ──
         FCB    $0C               ; FF clear+home
         FCB    $B1
         FCB    $8E
         FCB    $13               ; DC3/XOFF
         FCB    $C3
         FCB    $30               ; '0'
         FCB    CurXY,$86,$1E     ; CurXY(row=102,col=-2)
$1D3B  B7 0C 91            Sub_1D3B:      STA $0C91             
$1D3E  A7 06                              STA 6,X               
$1D40  97 9E                              STA <$9E              
$1D42  10 8E 00 0A                        LDY #$000A            
$1D46  86 01                              LDA #$01              
$1D48  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D4B  25 10                              BCS Sub_1D5D           ; C=1 (BLO)
$1D4D  A6 05                              LDA 5,X               
$1D4F  97 9D                              STA <$9D              
$1D51  A6 06                              LDA 6,X               
$1D53  97 9E                              STA <$9E              
$1D55  8E 00 02                           LDX #$0002            
$1D58  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1D5B  35 B2               Sub_1D5B:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
$1D5D  B6 0C 91            Sub_1D5D:      LDA $0C91             
$1D60  4A                                 DECA                  
$1D61  34 10                              PSHS X                
$1D63  8E 00 02                           LDX #$0002            
$1D66  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1D69  35 10                              PULS X                
$1D6B  81 0A                              CMPA #$0A              ; compare A with LF
$1D6D  22 05                              BHI Sub_1D74          
$1D6F  53                                 COMB                  
$1D70  C6 C3                              LDB #$C3              
$1D72  20 E7                              BRA Sub_1D5B          

; --------------------------------------------------------------
$1D74  20 C5               Sub_1D74:      BRA Sub_1D3B          
$1D76  30 8D E7 13         Sub_1D76:      LEAX Dat_048D,PC       ; X → Dat_048D
$1D7A  86 02                              LDA #$02               ; A = CurXY
$1D7C  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$1D7F  97 4B                              STA <$4B              
$1D81  30 8D E7 18                        LEAX Dat_049D,PC       ; X → Dat_049D
$1D85  10 8E 00 0A                        LDY #$000A            
$1D89  96 4B                              LDA <$4B              
$1D8B  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D8E  8E 00 02                           LDX #$0002            
$1D91  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1D94  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1D95  86 01               Sub_1D95:      LDA #$01              
$1D97  10 AE 81            Sub_1D97:      LDY ,X++              
$1D9A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1D9D  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1D9E  8D 0F               Sub_1D9E:      BSR Sub_1DAF           ; call Sub_1DAF
$1DA0  81 79                              CMPA #$79              ; compare A with 'y'
$1DA2  10 27 F3 3F                        LBEQ Sub_10E5         
$1DA6  81 59                              CMPA #$59              ; compare A with 'Y'
$1DA8  10 27 F3 39                        LBEQ Sub_10E5         
$1DAC  16 F0 7B                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$1DAF  34 20               Sub_1DAF:      PSHS Y                
$1DB1  CC 1D 04                           LDD #$1D04            
$1DB4  FD 0C 9A                           STD $0C9A             
$1DB7  CC 16 03                           LDD #$1603            
$1DBA  FD 0C 9C                           STD $0C9C             
$1DBD  17 01 31                           LBSR Sub_1EF1          ; call Sub_1EF1
$1DC0  30 8D E6 FB                        LEAX Dat_04BF,PC       ; X → Dat_04BF
$1DC4  8D CF                              BSR Sub_1D95           ; call Sub_1D95
$1DC6  30 8D E6 EB                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$1DCA  8D C9                              BSR Sub_1D95           ; call Sub_1D95
$1DCC  17 0E 8B                           LBSR Sub_2C5A          ; call Sub_2C5A
$1DCF  34 02                              PSHS A                
$1DD1  30 8D E6 DC                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$1DD5  8D BE                              BSR Sub_1D95           ; call Sub_1D95
$1DD7  17 01 79                           LBSR Sub_1F53          ; call Sub_1F53
$1DDA  35 02                              PULS A                
$1DDC  35 A0                              PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1DDE  34 14               Sub_1DDE:      PSHS B,X              
$1DE0  8E 0C A3                           LDX #$0CA3            
$1DE3  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$1DE6  A6 05                              LDA 5,X               
$1DE8  8E 00 02                           LDX #$0002            
$1DEB  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$1DEE  35 94                              PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1DF0  34 36               Sub_1DF0:      PSHS A,B,X,Y          
$1DF2  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$1DF3  2B 0F                              BMI Sub_1E04          
$1DF5  2C 0F                              BGE Sub_1E06          
$1DF7  30 8E 06                           LEAX [+6,PC]          
$1DFA  1B                                 FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
$1DFB  17 0E 5C            Sub_1DFB:      LBSR Sub_2C5A          ; call Sub_2C5A
$1DFE  81 2D                              CMPA #$2D              ; compare A with '-'
$1E00  23 0D                              BLS Sub_1E0F          
$1E02  5D                                 TSTB                  
$1E03  27 F6                              BEQ Sub_1DFB          
$1E04  F6 A7 80            Sub_1E04:      LDB $A780             
$1E06  80 5A               Sub_1E06:      SUBA #$5A             
$1E08  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$1E09  2C 17                              BGE Sub_1E22          
$1E0B  03                                 FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
$1E0C  2E 20                              BGT Sub_1E2E          
$1E0E  EC 81                              LDD ,X++              
$1E0F  81 08               Sub_1E0F:      CMPA #$08              ; compare A with BS
$1E11  26 0E                              BNE Sub_1E21          
$1E13  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$1E14  2C 27                              BGE Sub_1E3D          
$1E16  E4 5C                              ANDB -4,U             
$1E18  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$1E19  2C 30                              BGE Sub_1E4B          
$1E1B  1F 17                              TFR X,V               
$1E1D  03                                 FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
$1E1E  1C 20                              ANDCC #$20             ; clr CC: C,V,Z,N,I,F,E
$1E20  DA 81               Insn_1E20:     ORB <$81              
$1E21  81 05               Sub_1E21:      CMPA #$05             
$1E22  05                  Sub_1E22:      EQU    $1E22            ; [*30] branch target 1 byte(s) inside Sub_1E21 -- see [*30]
$1E23  26 04                              BNE Sub_1E29          
$1E25  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$1E26  30 20                              LEAX 0,Y              
$1E28  08                                 FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
$1E29  81 0D               Sub_1E29:      CMPA #$0D              ; compare A with CR
$1E2B  26 CE                              BNE Sub_1DFB          
$1E2D  A7 84                              STA ,X                
$1E2E  84 0C               Sub_1E2E:      ANDA #$0C             
$1E30  2C 35                              BGE Sub_1E67          
$1E32  B6 86 00                           LDA $8600             
$1E33  86 00               Sub_1E33:      LDA #$00               ; A = NUL
$1E35  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$1E37  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$1E3A  24 01                              BCC Sub_1E3D           ; C=0 (BHS)
$1E3C  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1E3D  5D                  Sub_1E3D:      TSTB                  
$1E3E  27 0B                              BEQ Sub_1E4B          
$1E40  4F                                 CLRA                   ; A = 0
$1E41  1F 02                              TFR D,Y               
$1E43  8E 13 C3                           LDX #$13C3            
$1E46  86 00                              LDA #$00               ; A = NUL
$1E48  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$1E4B  39                  Sub_1E4B:      RTS                    ; return from subroutine
$1E4C  34 16               Sub_1E4C:      PSHS A,B,X            
$1E4E  C6 08                              LDB #$08               ; B = BS
$1E50  8E 0D 3B                           LDX #$0D3B            
$1E53  86 0D                              LDA #$0D               ; A = CR
$1E55  A7 84                              STA ,X                
$1E57  A7 01                              STA 1,X               
$1E59  30 89 00 80                        LEAX 128,X            
$1E5D  5A                                 DECB                  
$1E5E  26 F5                              BNE $1E55             
$1E60  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1E62  39                  Sub_1E62:      RTS                    ; return from subroutine
$1E63  96 70               Sub_1E63:      LDA <$70              
$1E65  81 02                              CMPA #$02              ; compare A with CurXY
$1E67  26 06               Sub_1E67:      BNE Sub_1E6F          
$1E69  31 8D E5 30                        LEAY Dat_039D,PC       ; Y → Dat_039D
$1E6D  20 23                              BRA Sub_1E92          

; --------------------------------------------------------------
$1E6F  7D 0C BB            Sub_1E6F:      TST $0CBB             
$1E72  26 1A                              BNE Sub_1E8E          
$1E74  31 8D E5 45                        LEAY Dat_03BD,PC       ; Y → Dat_03BD
$1E78  CC 00 01                           LDD #$0001            
$1E7B  DD 8E                              STD <$8E              
$1E7D  CC 02 03                           LDD #$0203            
$1E80  DD 90                              STD <$90              
$1E82  CC 04 05                           LDD #$0405            
$1E85  DD 92                              STD <$92              
$1E87  CC 06 07                           LDD #$0607            
$1E8A  DD 94                              STD <$94              
$1E8C  20 18                              BRA Sub_1EA6          

; --------------------------------------------------------------
$1E8E  31 8D E5 1B         Sub_1E8E:      LEAY Dat_03AD,PC       ; Y → Dat_03AD
$1E92  CC 07 04            Sub_1E92:      LDD #$0704            
$1E95  DD 8E                              STD <$8E              
$1E97  CC 00 02                           LDD #$0002            
$1E9A  DD 90                              STD <$90              
$1E9C  CC 01 03                           LDD #$0103            
$1E9F  DD 92                              STD <$92              
$1EA1  CC 05 06                           LDD #$0506            
$1EA4  DD 94                              STD <$94              
$1EA6  8E 13 C3            Sub_1EA6:      LDX #$13C3            
$1EA9  CC 1B 31                           LDD #$1B31             ; D=ESC+$31
$1EAC  ED 84                              STD ,X                
$1EAE  4F                                 CLRA                   ; A = 0
$1EAF  E6 A6               Sub_1EAF:      LDB A,Y               
$1EB1  34 22                              PSHS A,Y              
$1EB3  ED 02                              STD 2,X               
$1EB5  10 8E 00 04                        LDY #$0004            
$1EB9  86 01                              LDA #$01              
$1EBB  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1EBE  35 22                              PULS A,Y              
$1EC0  4C                                 INCA                  
$1EC1  81 10                              CMPA #$10             
$1EC3  25 EA                              BCS Sub_1EAF           ; C=1 (BLO)
$1EC5  17 0E BF                           LBSR Sub_2D87          ; call Sub_2D87
$1EC8  17 0E 3D                           LBSR Sub_2D08          ; call Sub_2D08
$1ECB  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$1ECC  34 14               Sub_1ECC:      PSHS B,X              
$1ECE  8E 00 8E                           LDX #$008E            
$1ED1  E6 86                              LDB A,X               
$1ED3  1F 98                              TFR B,A               
$1ED5  35 94                              PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1ED7  34 12               Sub_1ED7:      PSHS A,X              
$1ED9  B6 0C C7                           LDA $0CC7             
$1EDC  8D EE                              BSR Sub_1ECC           ; call Sub_1ECC
$1EDE  17 06 A7                           LBSR Sub_2588          ; call Sub_2588
$1EE1  B6 0C C8                           LDA $0CC8             
$1EE4  8D E6                              BSR Sub_1ECC           ; call Sub_1ECC
$1EE6  17 06 93                           LBSR Sub_257C          ; call Sub_257C
$1EE9  B6 00 90                           LDA $0090             
$1EEC  17 06 93                           LBSR Sub_2582          ; call Sub_2582
$1EEF  35 92                              PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1EF1  34 36               Sub_1EF1:      PSHS A,B,X,Y          
$1EF3  8E 13 C3                           LDX #$13C3            
$1EF6  CC 1B 22                           LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
$1EF9  ED 84                              STD ,X                
$1EFB  86 01                              LDA #$01              
$1EFD  A7 02                              STA 2,X               
$1EFF  FC 0C 9A                           LDD $0C9A             
$1F02  8B 01                              ADDA #$01             
$1F04  CB 01                              ADDB #$01             
$1F06  ED 03                              STD 3,X               
$1F08  FC 0C 9C                           LDD $0C9C             
$1F0B  ED 05                              STD 5,X               
$1F0D  B6 0C CE                           LDA $0CCE             
$1F10  17 FF B9                           LBSR Sub_1ECC          ; call Sub_1ECC
$1F13  1F 89                              TFR A,B               
$1F15  4F                                 CLRA                   ; A = 0
$1F16  ED 07                              STD 7,X               
$1F18  86 01                              LDA #$01              
$1F1A  10 8E 00 09                        LDY #$0009            
$1F1E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F21  CC 1B 22                           LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
$1F24  ED 84                              STD ,X                
$1F26  86 01                              LDA #$01              
$1F28  A7 02                              STA 2,X               
$1F2A  FC 0C 9A                           LDD $0C9A             
$1F2D  ED 03                              STD 3,X               
$1F2F  FC 0C 9C                           LDD $0C9C             
$1F32  ED 05                              STD 5,X               
$1F34  B6 0C CC                           LDA $0CCC             
$1F37  17 FF 92                           LBSR Sub_1ECC          ; call Sub_1ECC
$1F3A  A7 07                              STA 7,X               
$1F3C  B6 0C CD                           LDA $0CCD             
$1F3F  17 FF 8A                           LBSR Sub_1ECC          ; call Sub_1ECC
$1F42  A7 08                              STA 8,X               
$1F44  86 0C                              LDA #$0C               ; A = FF
$1F46  A7 09                              STA 9,X               
$1F48  86 01                              LDA #$01              
$1F4A  10 8E 00 0A                        LDY #$000A            
$1F4E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F51  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1F53  34 36               Sub_1F53:      PSHS A,B,X,Y          
$1F55  8E 13 C3                           LDX #$13C3            
$1F58  CC 1B 23                           LDD #$1B23             ; D=ESC+'#'  → W.OWEnd: Overlay Window End
$1F5B  ED 84                              STD ,X                
$1F5D  86 01                              LDA #$01              
$1F5F  10 8E 00 02                        LDY #$0002            
$1F63  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F66  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1F69  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1F6B  34 36               Sub_1F6B:      PSHS A,B,X,Y          
$1F6D  8E 10 03                           LDX #$1003            
$1F70  10 8E 0E A0                        LDY #$0EA0            
$1F74  86 01               Sub_1F74:      LDA #$01              
$1F76  C6 98                              LDB #$98              
$1F78  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1F7B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$1F7D  34 36               Sub_1F7D:      PSHS A,B,X,Y          
$1F7F  8E 3F 03                           LDX #$3F03            
$1F82  10 8E 0F D1                        LDY #$0FD1            
$1F86  20 EC                              BRA Sub_1F74          

; --------------------------------------------------------------
$1F88  34 16               Sub_1F88:      PSHS A,B,X            
$1F8A  C6 1D                              LDB #$1D              
$1F8C  96 38                              LDA <$38              
$1F8E  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$1F91  24 0C                              BCC Sub_1F9F           ; C=0 (BHS)
$1F93  9E 20                              LDX <$20              
$1F95  A6 02                              LDA 2,X               
$1F97  8A 0C                              ORA #$0C              
$1F99  A7 02                              STA 2,X               
$1F9B  94 F3                              ANDA <$F3             
$1F9D  A7 02                              STA 2,X               
$1F9F  35 96               Sub_1F9F:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$1FA1  34 36               Sub_1FA1:      PSHS A,B,X,Y          
$1FA3  30 8D E5 0E                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$1FA7  17 FD EB                           LBSR Sub_1D95          ; call Sub_1D95
$1FAA  CC 1E 03                           LDD #$1E03            
$1FAD  FD 0C 9A                           STD $0C9A             
$1FB0  CC 12 03                           LDD #$1203            
$1FB3  FD 0C 9C                           STD $0C9C             
$1FB6  17 FF 38                           LBSR Sub_1EF1          ; call Sub_1EF1
$1FB9  30 8D E6 A6                        LEAX Dat_0663,PC       ; X → Dat_0663
$1FBD  17 FD D5                           LBSR Sub_1D95          ; call Sub_1D95
$1FC0  F6 0C BA                           LDB $0CBA             
$1FC3  C4 0F                              ANDB #$0F             
$1FC5  F7 0C 91            Sub_1FC5:      STB $0C91             
$1FC8  30 8D E4 24                        LEAX Dat_03F0,PC       ; X → Dat_03F0
$1FCC  10 8E 00 06                        LDY #$0006            
$1FD0  86 01                              LDA #$01              
$1FD2  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1FD5  30 8D E6 A0                        LEAX Dat_0679,PC       ; X → Dat_0679
$1FD9  86 06                              LDA #$06              
$1FDB  F6 0C 91                           LDB $0C91             
$1FDE  3D                                 MUL                    ; D = A×B unsigned
$1FDF  30 8B                              LEAX D,X              
$1FE1  86 01                              LDA #$01              
$1FE3  10 8E 00 06                        LDY #$0006            
$1FE7  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$1FEA  17 0C 6D            Sub_1FEA:      LBSR Sub_2C5A          ; call Sub_2C5A
$1FED  81 0D                              CMPA #$0D              ; compare A with CR
$1FEF  27 14                              BEQ Sub_2005          
$1FF1  81 05                              CMPA #$05             
$1FF3  27 10                              BEQ Sub_2005          
$1FF5  81 20                              CMPA #$20              ; compare A with ' '
$1FF7  26 F1                              BNE Sub_1FEA          
$1FF9  F6 0C 91                           LDB $0C91             
$1FFC  5C                                 INCB                  
$1FFD  F1 0C B9                           CMPB $0CB9            
$2000  23 C3                              BLS Sub_1FC5          
$2002  5F                                 CLRB                   ; B = 0
$2003  20 C0                              BRA Sub_1FC5          

; --------------------------------------------------------------
$2005  F6 0C BA            Sub_2005:      LDB $0CBA             
$2008  C4 F0                              ANDB #$F0             
$200A  FA 0C 91                           ORB $0C91             
$200D  F7 0C BA                           STB $0CBA             
$2010  17 FF 40                           LBSR Sub_1F53          ; call Sub_1F53
$2013  17 F3 80                           LBSR Sub_1396          ; call Sub_1396
$2016  30 8D E4 97                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$201A  17 FD 78                           LBSR Sub_1D95          ; call Sub_1D95
$201D  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$201F  34 32               Sub_201F:      PSHS A,X,Y            
$2021  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$2022  A6 F7                              LDA [E,S]             
$2024  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$2025  91 8E                              CMPA <$8E             
$2027  13                                 SYNC                   ; wait for interrupt
$2028  C3 CC 1B                           ADDD #$CC1B           
$202B  25 ED                              BCS $201A              ; C=1 (BLO)
$202D  84 CC                              ANDA #$CC             
$202F  01                                 FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
$2030  02                                 FCB    $02                ; undefined opcode $02 -- not a valid 6809 instruction
$2031  ED 02                              STD 2,X               
$2033  86 04                              LDA #$04              
$2035  F6 13 BD                           LDB $13BD             
$2038  5C                                 INCB                  
$2039  ED 04                              STD 4,X               
$203B  86 01                              LDA #$01              
$203D  10 8E 00 06                        LDY #$0006            
$2041  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2044  F6 0C 91                           LDB $0C91             
$2047  4F                  Sub_2047:      CLRA                   ; A = 0
$2048  5C                                 INCB                  
$2049  1F 02                              TFR D,Y               
$204B  30 8D E6 98                        LEAX Dat_06E7,PC       ; X → Dat_06E7
$204F  86 01                              LDA #$01              
$2051  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2054  30 8D E6 9A                        LEAX Dat_06F2,PC       ; X → Dat_06F2
$2058  10 8E 00 03                        LDY #$0003            
$205C  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$205F  17 0C 00            Sub_205F:      LBSR Sub_2C62          ; call Sub_2C62
$2062  84 7F                              ANDA #$7F             
$2064  81 0A                              CMPA #$0A              ; compare A with LF
$2066  27 12                              BEQ Sub_207A          
$2068  81 0C                              CMPA #$0C              ; compare A with FF
$206A  27 1D                              BEQ Sub_2089          
$206C  81 20                              CMPA #$20              ; compare A with ' '
$206E  27 25                              BEQ Sub_2095          
$2070  81 05                              CMPA #$05             
$2072  27 26                              BEQ Sub_209A          
$2074  81 0D                              CMPA #$0D              ; compare A with CR
$2076  27 2B                              BEQ Sub_20A3          
$2078  20 E5                              BRA Sub_205F          

; --------------------------------------------------------------
$207A  F6 0C 91            Sub_207A:      LDB $0C91             
$207D  5C                                 INCB                  
$207E  F1 13 BD                           CMPB $13BD            
$2081  25 01                              BCS Sub_2084           ; C=1 (BLO)
$2083  5F                                 CLRB                   ; B = 0
$2084  F7 0C 91            Sub_2084:      STB $0C91             
$2087  20 BE                              BRA Sub_2047          

; --------------------------------------------------------------
$2089  F6 0C 91            Sub_2089:      LDB $0C91             
$208C  5A                                 DECB                  
$208D  2A 04                              BPL Sub_2093          
$208F  F6 13 BD                           LDB $13BD             
$2090  13                  Sub_2090:      SYNC                   ; wait for interrupt
$2091  BD 5A 20                           JSR $5A20             
$2093  20 EF               Sub_2093:      BRA Sub_2084          
$2095  F6 0C 91            Sub_2095:      LDB $0C91             
$2098  35 B2               Sub_2098:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
$209A  F6 13 BD            Sub_209A:      LDB $13BD             
$209D  5C                                 INCB                  
$209E  F7 0C 91                           STB $0C91             
$20A1  20 F5               Insn_20A1:     BRA Sub_2098          
$20A3  0C                  Sub_20A3:      EQU    $20A3            ; [*31] branch target 1 byte(s) inside Insn_20A2 -- see [*31]
$20A4  A6 20                              LDA 0,Y               
$20A6  EE 34                              LDU -12,Y             
$20A7  34 36               Sub_20A7:      PSHS A,B,X,Y          
$20A9  30 8D E4 08                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$20AD  17 FC E5                           LBSR Sub_1D95          ; call Sub_1D95
$20B0  CC 1C 03                           LDD #$1C03            
$20B3  FD 0C 9A                           STD $0C9A             
$20B6  CC 17 03                           LDD #$1703            
$20B9  FD 0C 9C                           STD $0C9C             
$20BC  17 FE 32                           LBSR Sub_1EF1          ; call Sub_1EF1
$20BF  30 8D E6 32                        LEAX Dat_06F5,PC       ; X → Dat_06F5
$20C3  17 FC CF                           LBSR Sub_1D95          ; call Sub_1D95
$20C6  F6 0C BB                           LDB $0CBB             
$20C9  F7 0C 91            Sub_20C9:      STB $0C91             
$20CC  30 8D E3 20                        LEAX Dat_03F0,PC       ; X → Dat_03F0
$20D0  86 01                              LDA #$01              
$20D2  10 8E 00 05                        LDY #$0005            
$20D6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$20D9  30 8D E6 32                        LEAX Dat_070F,PC       ; X → Dat_070F
$20DD  86 05                              LDA #$05              
$20DF  F6 0C 91                           LDB $0C91             
$20E2  3D                                 MUL                    ; D = A×B unsigned
$20E3  30 8B                              LEAX D,X              
$20E5  10 8E 00 05         Insn_20E5:     LDY #$0005            
$20E8  05                  Sub_20E8:      EQU    $20E8            ; [*32] branch target 3 byte(s) inside Insn_20E5 -- see [*32]
$20E9  86 01                              LDA #$01              
$20EB  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$20EE  17 0B 69            Sub_20EE:      LBSR Sub_2C5A          ; call Sub_2C5A
$20F1  81 0D                              CMPA #$0D              ; compare A with CR
$20F3  27 15                              BEQ Sub_210A          
$20F5  81 05                              CMPA #$05             
$20F7  27 11                              BEQ Sub_210A          
$20F9  81 20                              CMPA #$20              ; compare A with ' '
$20FB  26 F1                              BNE Sub_20EE          
$20FD  7C 0C 91                           INC $0C91             
$2100  F6 0C 91                           LDB $0C91             
$2103  C1 03                              CMPB #$03             
$2105  26 C2                              BNE Sub_20C9          
$2107  5F                                 CLRB                   ; B = 0
$2108  20 BF                              BRA Sub_20C9          

; --------------------------------------------------------------
$210A  F6 0C 91            Sub_210A:      LDB $0C91             
$210D  F7 0C BB                           STB $0CBB             
$2110  17 FD 50                           LBSR Sub_1E63          ; call Sub_1E63
$2113  17 FE 3D                           LBSR Sub_1F53          ; call Sub_1F53
$2116  17 FD BE                           LBSR Sub_1ED7          ; call Sub_1ED7
$2119  8D 12                              BSR Sub_212D           ; call Sub_212D
$211B  17 F4 D5                           LBSR Sub_15F3          ; call Sub_15F3
$211E  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$211F  4D                                 TSTA                  
$2120  27 02                              BEQ Sub_2124          
$2122  8D 12                              BSR Sub_2136           ; call Sub_2136
$2124  30 8D E3 89         Sub_2124:      LEAX Dat_04B1,PC       ; X → Dat_04B1
$2128  17 FC 6A                           LBSR Sub_1D95          ; call Sub_1D95
$212B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$212D  34 02               Sub_212D:      PSHS A                
$212F  86 0C                              LDA #$0C               ; A = FF
$2131  17 00 07                           LBSR Sub_213B          ; call Sub_213B
$2134  35 82                              PULS A,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2136  34 36               Sub_2136:      PSHS A,B,X,Y          
$2138  16 07 7A                           LBRA Sub_28B5         

; --------------------------------------------------------------
$213B  34 36               Sub_213B:      PSHS A,B,X,Y          
$213D  8E 00 2A                           LDX #$002A            
$2140  A7 84                              STA ,X                
$2142  10 8E 00 01                        LDY #$0001            
$2146  86 01                              LDA #$01              
$2148  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$214B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$214D  34 36               Sub_214D:      PSHS A,B,X,Y          
$214F  30 8D E3 62                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$2153  17 FC 3F                           LBSR Sub_1D95          ; call Sub_1D95
$2156  8E 0C CC                           LDX #$0CCC            
$2159  EC 84                              LDD ,X                
$215B  34 06                              PSHS A,B              
$215D  A6 02                              LDA 2,X               
$215F  34 02                              PSHS A                
$2161  CC 00 01                           LDD #$0001            
$2164  ED 84                              STD ,X                
$2166  86 06                              LDA #$06              
$2168  A7 02                              STA 2,X               
$216A  CC 19 03                           LDD #$1903            
$216D  FD 0C 9A                           STD $0C9A             
$2170  CC 21 0D                           LDD #$210D            
$2173  FD 0C 9C                           STD $0C9C             
$2176  17 FD 78                           LBSR Sub_1EF1          ; call Sub_1EF1
$2179  8E 0C CC                           LDX #$0CCC            
$217C  35 02                              PULS A                
$217E  A7 02                              STA 2,X               
$2180  35 06                              PULS A,B              
$2182  ED 84                              STD ,X                
$2184  30 8D E7 8D                        LEAX Dat_0915,PC       ; X → Dat_0915
$2188  17 FC 0A                           LBSR Sub_1D95          ; call Sub_1D95
$218B  5F                                 CLRB                   ; B = 0
$218C  17 00 8B            Sub_218C:      LBSR Sub_221A          ; call Sub_221A
$218F  5C                                 INCB                  
$2190  C1 0A                              CMPB #$0A              ; compare B with LF
$2192  26 F8                              BNE Sub_218C          
$2194  86 0A                              LDA #$0A               ; A = LF
$2196  B7 13 BD                           STA $13BD             
$2199  5F                                 CLRB                   ; B = 0
$219A  17 FE 82            Sub_219A:      LBSR Sub_201F          ; call Sub_201F
$219D  8E 13 C3                           LDX #$13C3            
$21A0  CC 1B 25                           LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
$21A3  ED 84                              STD ,X                
$21A5  CC 00 00                           LDD #$0000            
$21A8  ED 02                              STD 2,X               
$21AA  CC 21 0D                           LDD #$210D            
$21AD  ED 04                              STD 4,X               
$21AF  10 8E 00 06                        LDY #$0006            
$21B3  86 01                              LDA #$01              
$21B5  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$21B8  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$21B9  A6 10                              LDA -16,X             
$21BB  26 00                              BNE Sub_21BD          
$21BD  1A F6               Sub_21BD:      ORCC #$F6              ; set CC: V,Z,I,H,F,E
$21BF  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$21C0  91 C1                              CMPA <$C1             
$21C2  09                                 FCB    $09                ; undefined opcode $09 -- not a valid 6809 instruction
$21C3  10 22 00 11                        LBHI Sub_21D8         
$21C7  8E 0C C7                           LDX #$0CC7            
$21CA  A6 85                              LDA B,X               
$21CC  4C                                 INCA                  
$21CD  81 08                              CMPA #$08              ; compare A with BS
$21CF  25 01                              BCS Sub_21D2           ; C=1 (BLO)
$21D1  4F                                 CLRA                   ; A = 0
$21D2  A7 85               Sub_21D2:      STA B,X               
$21D4  8D 44                              BSR Sub_221A           ; call Sub_221A
$21D6  20 C2                              BRA Sub_219A          

; --------------------------------------------------------------
$21D8  17 FD 78            Sub_21D8:      LBSR Sub_1F53          ; call Sub_1F53
$21DB  30 8D E2 D2                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$21DF  17 FB B3                           LBSR Sub_1D95          ; call Sub_1D95
$21E2  8E 13 C3                           LDX #$13C3            
$21E5  CC 1B 32                           LDD #$1B32             ; D=ESC+'2'  → W.FColor: Foreground Color
$21E8  ED 84                              STD ,X                
$21EA  5C                                 INCB                  
$21EB  ED 03                              STD 3,X               
$21ED  5C                                 INCB                  
$21EE  ED 06                              STD 6,X               
$21F0  B6 0C C7                           LDA $0CC7             
$21F3  17 FC D6                           LBSR Sub_1ECC          ; call Sub_1ECC
$21F6  A7 02                              STA 2,X               
$21F8  B6 0C C8                           LDA $0CC8             
$21FB  17 FC CE                           LBSR Sub_1ECC          ; call Sub_1ECC
$21FE  A7 05                              STA 5,X               
$2200  B6 00 90                           LDA $0090             
$2203  A7 08                              STA 8,X               
$2205  86 0C                              LDA #$0C               ; A = FF
$2207  A7 09                              STA 9,X               
$2209  10 8E 00 0A                        LDY #$000A            
$220D  86 01                              LDA #$01              
$220F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2212  17 0B 72                           LBSR Sub_2D87          ; call Sub_2D87
$2215  17 0A F0                           LBSR Sub_2D08          ; call Sub_2D08
$2218  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$221A  34 36               Sub_221A:      PSHS A,B,X,Y          
$221C  5C                                 INCB                  
$221D  5C                                 INCB                  
$221E  86 15                              LDA #$15              
$2220  17 02 B9                           LBSR Sub_24DC          ; call Sub_24DC
$2223  A6 61                              LDA 1,S               
$2225  8E 0C C7                           LDX #$0CC7            
$2228  E6 86                              LDB A,X               
$222A  30 8D E8 B1                        LEAX Dat_0ADF,PC       ; X → Dat_0ADF
$222E  86 07                              LDA #$07              
$2230  3D                                 MUL                    ; D = A×B unsigned
$2231  3A                                 ABX                   
$2232  86 01                              LDA #$01              
$2234  10 8E 00 07                        LDY #$0007            
$2238  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$223B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$223D  34 36               Sub_223D:      PSHS A,B,X,Y          
$223F  30 8D E2 72                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$2243  17 FB 4F                           LBSR Sub_1D95          ; call Sub_1D95
$2246  CC 1F 03                           LDD #$1F03            
$2249  FD 0C 9A                           STD $0C9A             
$224C  CC 16 0E                           LDD #$160E            
$224F  FD 0C 9C                           STD $0C9C             
$2252  17 FC 9C                           LBSR Sub_1EF1          ; call Sub_1EF1
$2255  30 8D E6 27                        LEAX Dat_0880,PC       ; X → Dat_0880
$2259  17 FB 39                           LBSR Sub_1D95          ; call Sub_1D95
$225C  17 01 73                           LBSR Sub_23D2          ; call Sub_23D2
$225F  17 01 9B                           LBSR Sub_23FD          ; call Sub_23FD
$2262  17 01 A7                           LBSR Sub_240C          ; call Sub_240C
$2265  17 01 86                           LBSR Sub_23EE          ; call Sub_23EE
$2268  17 02 57                           LBSR Sub_24C2          ; call Sub_24C2
$226B  17 01 F5                           LBSR Sub_2463          ; call Sub_2463
$226E  17 02 36                           LBSR Sub_24A7          ; call Sub_24A7
$2271  17 01 A7                           LBSR Sub_241B          ; call Sub_241B
$2274  17 01 B3                           LBSR Sub_242A          ; call Sub_242A
$2277  17 01 BF                           LBSR Sub_2439          ; call Sub_2439
$227A  17 01 CB                           LBSR Sub_2448          ; call Sub_2448
$227D  86 0B                              LDA #$0B              
$227F  B7 13 BD                           STA $13BD             
$2282  5F                                 CLRB                   ; B = 0
$2283  17 FD 99            Sub_2283:      LBSR Sub_201F          ; call Sub_201F
$2286  8E 13 C3                           LDX #$13C3            
$2289  CC 1B 25                           LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
$228C  ED 84                              STD ,X                
$228E  CC 00 00                           LDD #$0000            
$2291  ED 02                              STD 2,X               
$2293  CC 16 0E                           LDD #$160E            
$2296  ED 04                              STD 4,X               
$2298  10 8E 00 06                        LDY #$0006            
$229C  86 01                              LDA #$01              
$229E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$22A1  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$22A2  A6 10                              LDA -16,X             
$22A4  26 01                              BNE Sub_22A7          
$22A6  1F F6                              TFR F,W               
$22A7  F6 0C 91            Sub_22A7:      LDB $0C91             
$22AA  C1 0A                              CMPB #$0A              ; compare B with LF
$22AC  10 22 01 16                        LBHI Sub_23C6         
$22B0  C1 00                              CMPB #$00              ; compare B with NUL
$22B2  26 0D                              BNE Sub_22C1          
$22B4  B6 0C BC                           LDA $0CBC             
$22B7  26 05                              BNE Sub_22BE          
$22B9  7C 0C BC                           INC $0CBC             
$22BC  20 03                              BRA Sub_22C1          

; --------------------------------------------------------------
$22BE  7F 0C BC            Sub_22BE:      CLR $0CBC             
$22C1  17 01 0E            Sub_22C1:      LBSR Sub_23D2          ; call Sub_23D2
$22C4  C1 03                              CMPB #$03             
$22C6  26 0D                              BNE Sub_22D5          
$22C8  B6 0C BF                           LDA $0CBF             
$22CB  26 05                              BNE Sub_22D2          
$22CD  7C 0C BF                           INC $0CBF             
$22D0  20 03                              BRA Sub_22D5          

; --------------------------------------------------------------
$22D2  7F 0C BF            Sub_22D2:      CLR $0CBF             
$22D5  17 01 16            Sub_22D5:      LBSR Sub_23EE          ; call Sub_23EE
$22D8  C1 07                              CMPB #$07             
$22DA  26 0D                              BNE Sub_22E9          
$22DC  B6 0C C6                           LDA $0CC6             
$22DF  26 05                              BNE Sub_22E6          
$22E1  7C 0C C6                           INC $0CC6             
$22E4  20 03                              BRA Sub_22E9          

; --------------------------------------------------------------
$22E6  7F 0C C6            Sub_22E6:      CLR $0CC6             
$22E9  17 01 2F            Sub_22E9:      LBSR Sub_241B          ; call Sub_241B
$22EC  17 F0 A7                           LBSR Sub_1396          ; call Sub_1396
$22EF  C1 05                              CMPB #$05             
$22F1  26 24                              BNE Sub_2317          
$22F3  B6 0C C1                           LDA $0CC1             
$22F6  84 E0                              ANDA #$E0             
$22F8  81 00                              CMPA #$00              ; compare A with NUL
$22FA  27 20                              BEQ Sub_231C          
$22FC  81 E0                              CMPA #$E0             
$22FE  27 20                              BEQ Sub_2320          
$2300  8B 40                              ADDA #$40             
$2302  34 04               Sub_2302:      PSHS B                
$2304  F6 0C C1                           LDB $0CC1             
$2307  C4 1F                              ANDB #$1F             
$2309  F7 0C C1                           STB $0CC1             
$230C  35 04                              PULS B                
$230E  BA 0C C1                           ORA $0CC1             
$2311  B7 0C C1                           STA $0CC1             
$2314  17 F0 7F                           LBSR Sub_1396          ; call Sub_1396
$2317  17 01 49            Sub_2317:      LBSR Sub_2463          ; call Sub_2463
$231A  20 07                              BRA Sub_2323          

; --------------------------------------------------------------
$231C  8B 20               Sub_231C:      ADDA #$20             
$231E  20 E2                              BRA Sub_2302          

; --------------------------------------------------------------
$2320  4F                  Sub_2320:      CLRA                   ; A = 0
$2321  20 DF                              BRA Sub_2302          

; --------------------------------------------------------------
$2323  C1 06               Sub_2323:      CMPB #$06             
$2325  26 14                              BNE Sub_233B          
$2327  B6 0C BA                           LDA $0CBA             
$232A  2A 04                              BPL Sub_2330          
$232C  84 7F                              ANDA #$7F             
$232E  20 02                              BRA Sub_2332          

; --------------------------------------------------------------
$2330  8A 80               Sub_2330:      ORA #$80              
$2332  B7 0C BA            Sub_2332:      STA $0CBA             
$2335  17 F0 5E                           LBSR Sub_1396          ; call Sub_1396
$2338  17 01 6C                           LBSR Sub_24A7          ; call Sub_24A7
$233B  C1 04               Sub_233B:      CMPB #$04             
$233D  26 16                              BNE Sub_2355          
$233F  B6 0C BA                           LDA $0CBA             
$2342  85 20                              BITA #$20             
$2344  27 04                              BEQ Sub_234A          
$2346  84 DF                              ANDA #$DF             
$2348  20 02                              BRA Sub_234C          

; --------------------------------------------------------------
$234A  8A 20               Sub_234A:      ORA #$20              
$234C  B7 0C BA            Sub_234C:      STA $0CBA             
$234F  17 F0 44                           LBSR Sub_1396          ; call Sub_1396
$2352  17 01 6D                           LBSR Sub_24C2          ; call Sub_24C2
$2355  C1 01               Sub_2355:      CMPB #$01             
$2357  26 0D                              BNE Sub_2366          
$2359  B6 0C BD                           LDA $0CBD             
$235C  26 05                              BNE Sub_2363          
$235E  7C 0C BD                           INC $0CBD             
$2361  20 03                              BRA Sub_2366          

; --------------------------------------------------------------
$2363  7F 0C BD            Sub_2363:      CLR $0CBD             
$2366  17 00 94            Sub_2366:      LBSR Sub_23FD          ; call Sub_23FD
$2369  C1 02                              CMPB #$02              ; compare B with CurXY
$236B  26 10                              BNE Sub_237D          
$236D  B6 0C BE                           LDA $0CBE             
$2370  26 05                              BNE Sub_2377          
$2372  7C 0C BE                           INC $0CBE             
$2375  20 06                              BRA Sub_237D          

; --------------------------------------------------------------
$2377  7F 0C BE            Sub_2377:      CLR $0CBE             
$237A  17 F0 19                           LBSR Sub_1396          ; call Sub_1396
$237D  17 00 8C            Sub_237D:      LBSR Sub_240C          ; call Sub_240C
$2380  C1 08                              CMPB #$08              ; compare B with BS
$2382  26 0D                              BNE Sub_2391          
$2384  7D 0C C0                           TST $0CC0             
$2387  26 05                              BNE Sub_238E          
$2389  7C 0C C0                           INC $0CC0             
$238C  20 03                              BRA Sub_2391          

; --------------------------------------------------------------
$238E  7F 0C C0            Sub_238E:      CLR $0CC0             
$2391  17 00 B4            Sub_2391:      LBSR Sub_2448          ; call Sub_2448
$2394  C1 09                              CMPB #$09             
$2396  26 0D                              BNE Sub_23A5          
$2398  7D 0C C3                           TST $0CC3             
$239B  26 05                              BNE Sub_23A2          
$239D  7C 0C C3                           INC $0CC3             
$23A0  20 03                              BRA Sub_23A5          

; --------------------------------------------------------------
$23A2  7F 0C C3            Sub_23A2:      CLR $0CC3             
$23A5  17 00 91            Sub_23A5:      LBSR Sub_2439          ; call Sub_2439
$23A8  C1 0A                              CMPB #$0A              ; compare B with LF
$23AA  26 0D                              BNE Sub_23B9          
$23AC  7D 0C C2                           TST $0CC2             
$23AF  26 05                              BNE Sub_23B6          
$23B1  7C 0C C2                           INC $0CC2             
$23B4  20 03                              BRA Sub_23B9          

; --------------------------------------------------------------
$23B6  7F 0C C2            Sub_23B6:      CLR $0CC2             
$23B9  17 00 6E            Sub_23B9:      LBSR Sub_242A          ; call Sub_242A
$23BC  C1 0A                              CMPB #$0A              ; compare B with LF
$23BE  22 06                              BHI Sub_23C6          
$23C0  F6 0C 91                           LDB $0C91             
$23C3  16 FE BD                           LBRA Sub_2283         

; --------------------------------------------------------------
$23C6  17 FB 8A            Sub_23C6:      LBSR Sub_1F53          ; call Sub_1F53
$23C9  30 8D E0 E4                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$23CD  17 F9 C5                           LBSR Sub_1D95          ; call Sub_1D95
$23D0  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$23D2  34 16               Sub_23D2:      PSHS A,B,X            
$23D4  CC 11 02                           LDD #$1102            
$23D7  17 01 02                           LBSR Sub_24DC          ; call Sub_24DC
$23DA  B6 0C BC                           LDA $0CBC             
$23DD  26 09                              BNE Sub_23E8          
$23DF  30 8D E6 A0         Sub_23DF:      LEAX Dat_0A83,PC       ; X → Dat_0A83
$23E3  17 F9 AF            Sub_23E3:      LBSR Sub_1D95          ; call Sub_1D95
$23E6  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$23E8  30 8D E6 9D         Sub_23E8:      LEAX Dat_0A89,PC       ; X → Dat_0A89
$23EC  20 F5                              BRA Sub_23E3          

; --------------------------------------------------------------
$23EE  34 16               Sub_23EE:      PSHS A,B,X            
$23F0  CC 11 05                           LDD #$1105            
$23F3  17 00 E6                           LBSR Sub_24DC          ; call Sub_24DC
$23F6  B6 0C BF                           LDA $0CBF             
$23F9  26 ED                              BNE Sub_23E8          
$23FB  20 E2                              BRA Sub_23DF          

; --------------------------------------------------------------
$23FD  34 16               Sub_23FD:      PSHS A,B,X            
$23FF  CC 11 03                           LDD #$1103            
$2402  17 00 D7                           LBSR Sub_24DC          ; call Sub_24DC
$2405  B6 0C BD                           LDA $0CBD             
$2408  26 DE                              BNE Sub_23E8          
$240A  20 D3                              BRA Sub_23DF          

; --------------------------------------------------------------
$240C  34 16               Sub_240C:      PSHS A,B,X            
$240E  CC 11 04                           LDD #$1104            
$2411  17 00 C8                           LBSR Sub_24DC          ; call Sub_24DC
$2414  B6 0C BE                           LDA $0CBE             
$2417  26 CF                              BNE Sub_23E8          
$2419  20 C4                              BRA Sub_23DF          

; --------------------------------------------------------------
$241B  34 16               Sub_241B:      PSHS A,B,X            
$241D  CC 11 09                           LDD #$1109            
$2420  17 00 B9                           LBSR Sub_24DC          ; call Sub_24DC
$2423  B6 0C C6                           LDA $0CC6             
$2426  26 C0                              BNE Sub_23E8          
$2428  20 B5                              BRA Sub_23DF          

; --------------------------------------------------------------
$242A  34 16               Sub_242A:      PSHS A,B,X            
$242C  CC 11 0C                           LDD #$110C            
$242F  17 00 AA                           LBSR Sub_24DC          ; call Sub_24DC
$2432  B6 0C C2                           LDA $0CC2             
$2435  26 B1                              BNE Sub_23E8          
$2437  20 A6                              BRA Sub_23DF          

; --------------------------------------------------------------
$2439  34 16               Sub_2439:      PSHS A,B,X            
$243B  CC 11 0B                           LDD #$110B            
$243E  17 00 9B                           LBSR Sub_24DC          ; call Sub_24DC
$2441  B6 0C C3                           LDA $0CC3             
$2444  27 A2                              BEQ Sub_23E8          
$2446  20 97                              BRA Sub_23DF          

; --------------------------------------------------------------
$2448  34 16               Sub_2448:      PSHS A,B,X            
$244A  CC 11 0A                           LDD #$110A            
$244D  17 00 8C                           LBSR Sub_24DC          ; call Sub_24DC
$2450  B6 0C C0                           LDA $0CC0             
$2453  26 07                              BNE Sub_245C          
$2455  30 8D E6 1E                        LEAX Dat_0A77,PC       ; X → Dat_0A77
$2459  16 FF 87                           LBRA Sub_23E3         

; --------------------------------------------------------------
$245C  30 8D E6 1D         Sub_245C:      LEAX Dat_0A7D,PC       ; X → Dat_0A7D
$2460  16 FF 80                           LBRA Sub_23E3         

; --------------------------------------------------------------
$2463  34 36               Sub_2463:      PSHS A,B,X,Y          
$2465  CC 10 07                           LDD #$1007            
$2468  17 00 71                           LBSR Sub_24DC          ; call Sub_24DC
$246B  B6 0C C1                           LDA $0CC1             
$246E  84 E0                              ANDA #$E0             
$2470  81 A0                              CMPA #$A0             
$2472  26 06                              BNE Sub_247A          
$2474  30 8D E6 16                        LEAX Dat_0A8E,PC       ; X → Dat_0A8E
$2478  20 22                              BRA Sub_249C          

; --------------------------------------------------------------
$247A  81 E0               Sub_247A:      CMPA #$E0             
$247C  26 06                              BNE Sub_2484          
$247E  30 8D E6 11                        LEAX Dat_0A93,PC       ; X → Dat_0A93
$2482  20 18                              BRA Sub_249C          

; --------------------------------------------------------------
$2484  81 60               Sub_2484:      CMPA #$60              ; compare A with '`'
$2486  26 06                              BNE Sub_248E          
$2488  30 8D E6 0C         Insn_2488:     LEAX Dat_0A98,PC       ; X → Dat_0A98
$248B  0C                  Sub_248B:      EQU    $248B            ; [*33] branch target 3 byte(s) inside Insn_2488 -- see [*33]
$248C  20 0E                              BRA Sub_249C          

; --------------------------------------------------------------
$248E  81 20               Sub_248E:      CMPA #$20              ; compare A with ' '
$2490  26 06                              BNE Sub_2498          
$2492  30 8D E6 07                        LEAX Dat_0A9D,PC       ; X → Dat_0A9D
$2496  20 04                              BRA Sub_249C          

; --------------------------------------------------------------
$2498  30 8D E6 06         Sub_2498:      LEAX Dat_0AA2,PC       ; X → Dat_0AA2
$249C  86 01               Sub_249C:      LDA #$01              
$249E  10 8E 00 05                        LDY #$0005            
$24A2  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$24A5  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$24A7  34 16               Sub_24A7:      PSHS A,B,X            
$24A9  CC 12 08                           LDD #$1208            
$24AC  17 00 2D                           LBSR Sub_24DC          ; call Sub_24DC
$24AF  B6 0C BA                           LDA $0CBA             
$24B2  2A 07                              BPL Sub_24BB          
$24B4  86 32                              LDA #$32               ; A = '2'
$24B6  17 FC 82                           LBSR Sub_213B          ; call Sub_213B
$24B9  20 05                              BRA Sub_24C0          

; --------------------------------------------------------------
$24BB  86 31               Sub_24BB:      LDA #$31               ; A = '1'
$24BD  17 FC 7B                           LBSR Sub_213B          ; call Sub_213B
$24C0  35 96               Sub_24C0:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$24C2  34 16               Sub_24C2:      PSHS A,B,X            
$24C4  CC 12 06                           LDD #$1206            
$24C7  17 00 12                           LBSR Sub_24DC          ; call Sub_24DC
$24CA  B6 0C BA                           LDA $0CBA             
$24CD  85 20                              BITA #$20             
$24CF  26 04                              BNE Sub_24D5          
$24D1  86 38                              LDA #$38               ; A = '8'
$24D3  20 02                              BRA Sub_24D7          

; --------------------------------------------------------------
$24D5  86 37               Sub_24D5:      LDA #$37               ; A = '7'
$24D7  17 FC 61            Sub_24D7:      LBSR Sub_213B          ; call Sub_213B
$24DA  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$24DC  34 36               Sub_24DC:      PSHS A,B,X,Y          
$24DE  8E 00 A2                           LDX #$00A2            
$24E1  8B 20                              ADDA #$20             
$24E3  A7 01                              STA 1,X               
$24E5  CB 20                              ADDB #$20             
$24E7  E7 02                              STB 2,X               
$24E9  86 02                              LDA #$02               ; A = CurXY
$24EB  A7 84                              STA ,X                
$24ED  86 01                              LDA #$01              
$24EF  10 8E 00 03                        LDY #$0003            
$24F3  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$24F6  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$24F8  34 36               Sub_24F8:      PSHS A,B,X,Y          
$24FA  CC 15 04                           LDD #$1504            
$24FD  FD 0C 9A                           STD $0C9A             
$2500  CC 25 07                           LDD #$2507            
$2503  FD 0C 9C                           STD $0C9C             
$2506  17 F9 E8                           LBSR Sub_1EF1          ; call Sub_1EF1
$2509  30 8D E0 35                        LEAX Dat_0542,PC       ; X → Dat_0542
$250D  17 F8 85                           LBSR Sub_1D95          ; call Sub_1D95
$2510  CC 01 02                           LDD #$0102            
$2513  8D C7                              BSR Sub_24DC           ; call Sub_24DC
$2515  86 01                              LDA #$01              
$2517  8E 0C F1                           LDX #$0CF1            
$251A  10 8E 00 20                        LDY #$0020            
$251E  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$2521  C6 1F                              LDB #$1F              
$2523  30 8D E5 80                        LEAX -6784,PC         
$2527  17 F8 6B                           LBSR Sub_1D95          ; call Sub_1D95
$252A  17 F8 C3                           LBSR Sub_1DF0          ; call Sub_1DF0
$252D  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$252E  30 26                              LEAX 6,Y              
$252F  26 1E               Sub_252F:      BNE Sub_254F          
$2531  B6 06 1B                           LDA $061B             
$2534  81 0D                              CMPA #$0D              ; compare A with CR
$2536  27 17                              BEQ Sub_254F          
$2538  86 03                              LDA #$03              
$253A  8E 06 1B                           LDX #$061B            
$253D  10 3F 86                           OS9 I$ChgDir           ; mode=B  name→X
$2540  25 12                              BCS Sub_2554           ; C=1 (BLO)
$2542  8E 06 1B                           LDX #$061B            
$2545  10 8E 0C F1                        LDY #$0CF1            
$2549  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$254B  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$254F  17 FA 01            Sub_254F:      LBSR Sub_1F53          ; call Sub_1F53
$2552  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2554  86 07               Sub_2554:      LDA #$07              
$2556  17 FB E2                           LBSR Sub_213B          ; call Sub_213B
$2559  34 04                              PSHS B                
$255B  CC 0D 02                           LDD #$0D02            
$255E  17 FF 7B                           LBSR Sub_24DC          ; call Sub_24DC
$2561  30 8D DF 50                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$2565  17 F8 2D                           LBSR Sub_1D95          ; call Sub_1D95
$2568  35 04                              PULS B                
$256A  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$256D  8E 00 3C                           LDX #$003C            
$2570  17 EC 05                           LBSR Sub_1178          ; call Sub_1178
$2573  30 8D DF 3A                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$2577  17 F8 1B                           LBSR Sub_1D95          ; call Sub_1D95
$257A  20 D3                              BRA Sub_254F          

; --------------------------------------------------------------
$257C  34 36               Sub_257C:      PSHS A,B,X,Y          
$257E  C6 33                              LDB #$33               ; B = '3'
$2580  20 0A                              BRA Sub_258C          

; --------------------------------------------------------------
$2582  34 36               Sub_2582:      PSHS A,B,X,Y          
$2584  C6 34                              LDB #$34               ; B = '4'
$2586  20 04                              BRA Sub_258C          

; --------------------------------------------------------------
$2588  34 36               Sub_2588:      PSHS A,B,X,Y          
$258A  C6 32                              LDB #$32               ; B = '2'
$258C  8E 13 C3            Sub_258C:      LDX #$13C3            
$258F  A7 02                              STA 2,X               
$2591  86 1B                              LDA #$1B               ; A = ESC
$2593  ED 84                              STD ,X                
$2595  86 01                              LDA #$01              
$2597  10 8E 00 03                        LDY #$0003            
$259B  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$259E  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$25A0  20 18               Sub_25A0:      BRA Sub_25BA          
$25A2  20 16               Sub_25A2:      BRA Sub_25BA          
$25A4  34 06               Sub_25A4:      PSHS A,B              
$25A6  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$25A7  35 27               Sub_25A7:      PULS CC,A,B,Y         
$25A9  06                                 FCB    $06                ; undefined opcode $06 -- not a valid 6809 instruction
$25AA  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$25AB  35 8D                              PULS CC,B,DP,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$25AD  F4 35 86            Sub_25AD:      ANDB $3586            
$25AE  35 86               Sub_25AE:      PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)
$25B0  0D                  Sub_25B0:      EQU    $25B0            ; [*34] branch target 2 byte(s) inside Sub_25AE -- see [*34]
$25B1  34 27                              PSHS CC,A,B,Y         
$25B3  FA 0C 35                           ORB $0C35             
$25B6  8D E8                              BSR Sub_25A0           ; call Sub_25A0
$25B8  20 F4                              BRA Sub_25AE          

; --------------------------------------------------------------
$25BA  34 36               Sub_25BA:      PSHS A,B,X,Y          
$25BC  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$25BD  35 26                              PULS A,B,Y            
$25BF  28 31                              BVC Sub_25F2          
$25C1  8D E4                              BSR Sub_25A7           ; call Sub_25A7
$25C3  A7 8E 13                           STA [+19,PC]          
$25C6  C3 34 10                           ADDD #$3410           
$25C9  C6 0C                              LDB #$0C               ; B = FF
$25CB  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$25CF  35 10                              PULS X                
$25D1  B6 0C CB                           LDA $0CCB             
$25D4  17 F8 F5                           LBSR Sub_1ECC          ; call Sub_1ECC
$25D7  A7 07                              STA 7,X               
$25D9  B6 0C C9                           LDA $0CC9             
$25DC  17 F8 ED                           LBSR Sub_1ECC          ; call Sub_1ECC
$25DF  A7 0B                              STA 11,X              
$25E1  96 4B                              LDA <$4B              
$25E3  17 F7 B1                           LBSR Sub_1D97          ; call Sub_1D97
$25E6  35 B6               Sub_25E6:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$25E8  31 8D E4 72         Sub_25E8:      LEAY Dat_0A5E,PC       ; Y → Dat_0A5E
$25EC  8E 13 C3                           LDX #$13C3            
$25EF  34 10                              PSHS X                
$25F1  C6 0D               Insn_25F1:     LDB #$0D               ; B = CR
$25F2  0D                  Sub_25F2:      EQU    $25F2            ; [*35] branch target 1 byte(s) inside Insn_25F1 -- see [*35]
$25F3  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$25F7  35 10                              PULS X                
$25F9  B6 0C C9                           LDA $0CC9             
$25FC  17 F8 CD                           LBSR Sub_1ECC          ; call Sub_1ECC
$25FF  A7 09                              STA 9,X               
$2601  96 4B                              LDA <$4B              
$2603  17 F7 91                           LBSR Sub_1D97          ; call Sub_1D97
$2606  D6 1B                              LDB <$1B              
$2608  D0 19                              SUBB <$19             
$260A  4F                                 CLRA                   ; A = 0
$260B  34 06                              PSHS A,B              
$260D  96 15                              LDA <$15              
$260F  27 03                              BEQ Sub_2614          
$2611  4A                                 DECA                  
$2612  90 16                              SUBA <$16             
$2614  C6 20               Sub_2614:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$2616  3D                                 MUL                    ; D = A×B unsigned
$2617  E3 E1                              ADDD ,S++             
$2619  17 1D E7                           LBSR Sub_4403          ; call Sub_4403
$261C  20 C8                              BRA Sub_25E6          

; --------------------------------------------------------------
$261E  34 36               Sub_261E:      PSHS A,B,X,Y          
$2620  9E A0                              LDX <$A0              
$2622  5F                                 CLRB                   ; B = 0
$2623  A6 80               Sub_2623:      LDA ,X+               
$2625  5C                                 INCB                  
$2626  C1 1E                              CMPB #$1E             
$2628  22 07                              BHI Sub_2631          
$262A  4D                                 TSTA                  
$262B  2B 04                              BMI Sub_2631          
$262D  81 2E                              CMPA #$2E              ; compare A with '.'
$262F  26 F2                              BNE Sub_2623          
$2631  CB 08               Sub_2631:      ADDB #$08             
$2633  8E 13 C3                           LDX #$13C3            
$2636  34 04                              PSHS B                
$2638  86 28                              LDA #$28               ; A = '('
$263A  A0 E0                              SUBA ,S+              
$263C  44                                 LSRA                  
$263D  8B 21                              ADDA #$21             
$263F  A7 01                              STA 1,X               
$2641  CC 02 21                           LDD #$0221            
$2644  E7 02                              STB 2,X               
$2646  A7 84                              STA ,X                
$2648  10 8E 00 03                        LDY #$0003            
$264C  86 01                              LDA #$01              
$264E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2651  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2653  34 36               Sub_2653:      PSHS A,B,X,Y          
$2655  DC 5E                              LDD <$5E              
$2657  26 02                              BNE Sub_265B          
$2659  20 53                              BRA Sub_26AE          

; --------------------------------------------------------------
$265B  8E 00 EF            Sub_265B:      LDX #$00EF            
$265E  10 9E 62                           LDY <$62              
$2661  96 4F                              LDA <$4F              
$2663  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2666  24 08                              BCC Sub_2670           ; C=0 (BHS)
$2668  10 8E 00 00                        LDY #$0000            
$266C  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$266D  6A 20                              DEC 0,Y               
$266E  20 05               Sub_266E:      BRA Sub_2675          
$2670  10 9C 62            Sub_2670:      CMPY <$62             
$2673  27 17                              BEQ Sub_268C          
$2675  1F 20               Sub_2675:      TFR Y,D               
$2677  8E 00 EF                           LDX #$00EF            
$267A  30 8B                              LEAX D,X              
$267C  34 06                              PSHS A,B              
$267E  DC 62                              LDD <$62              
$2680  A3 E1                              SUBD ,S++             
$2682  1F 02                              TFR D,Y               
$2684  86 1A                              LDA #$1A               ; A = SUB
$2686  A7 80               Sub_2686:      STA ,X+               
$2688  31 3F                              LEAY -1,Y             
$268A  26 FA                              BNE Sub_2686          
$268C  8E 00 EC            Sub_268C:      LDX #$00EC            
$268F  DC 5E                              LDD <$5E              
$2691  E7 01                              STB 1,X               
$2693  53                                 COMB                  
$2694  E7 02                              STB 2,X               
$2696  DC 5E                              LDD <$5E              
$2698  27 08                              BEQ Sub_26A2          
$269A  DC 62                              LDD <$62              
$269C  10 83 00 80                        CMPD #$0080           
$26A0  26 06                              BNE Sub_26A8          
$26A2  86 01               Sub_26A2:      LDA #$01              
$26A4  A7 84                              STA ,X                
$26A6  20 04                              BRA Sub_26AC          

; --------------------------------------------------------------
$26A8  86 02               Sub_26A8:      LDA #$02               ; A = CurXY
$26AA  A7 84                              STA ,X                
$26AC  35 B6               Sub_26AC:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$26AE  0D                  Sub_26AE:      EQU    $26AE            ; [*36] branch target 2 byte(s) inside Sub_26AC -- see [*36]
$26AF  74 27 0C                           LSR $270C             
$26B2  8E 00 EF                           LDX #$00EF            
$26B5  C6 80                              LDB #$80              
$26B7  6F 80               Sub_26B7:      CLR ,X+               
$26B9  5A                                 DECB                  
$26BA  26 FB                              BNE Sub_26B7          
$26BC  20 CE                              BRA Sub_268C          

; --------------------------------------------------------------
$26BE  8E 00 EF            Sub_26BE:      LDX #$00EF            
$26C1  10 8E 00 AC                        LDY #$00AC            
$26C5  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$26C7  A6 A0               Sub_26C7:      LDA ,Y+               
$26C9  27 09                              BEQ Sub_26D4          
$26CB  81 0D                              CMPA #$0D              ; compare A with CR
$26CD  27 05                              BEQ Sub_26D4          
$26CF  A7 80                              STA ,X+               
$26D1  5A                                 DECB                  
$26D2  26 F3                              BNE Sub_26C7          
$26D4  6F 80               Sub_26D4:      CLR ,X+               
$26D6  17 06 DD                           LBSR Sub_2DB6          ; call Sub_2DB6
$26D9  20 B1                              BRA Sub_268C          

; --------------------------------------------------------------
$26DB  34 36               Sub_26DB:      PSHS A,B,X,Y          
$26DD  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$26DE  53                                 COMB                  
$26DF  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$26E0  54                                 LSRB                  
$26E1  8E 00 EF                           LDX #$00EF            
$26E4  DC 62                              LDD <$62              
$26E6  31 8B                              LEAY D,X              
$26E8  10 9F 5B                           STY <$5B              
$26EB  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$26EC  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$26ED  26 0B                              BNE Sub_26FA          
$26EF  17 17 4F                           LBSR Sub_3E41          ; call Sub_3E41
$26F2  30 8B                              LEAX D,X              
$26F4  96 53                              LDA <$53              
$26F6  A7 84                              STA ,X                
$26F8  35 B6               Sub_26F8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$26FA  17 17 18            Sub_26FA:      LBSR Sub_3E15          ; call Sub_3E15
$26FD  30 8B                              LEAX D,X              
$26FF  DC 53                              LDD <$53              
$2701  ED 84                              STD ,X                
$2703  20 F3                              BRA Sub_26F8          

; --------------------------------------------------------------
$2705  34 36               Sub_2705:      PSHS A,B,X,Y          
$2707  8E 11 3B                           LDX #$113B            
$270A  10 8E 02 00                        LDY #$0200            
$270D  00                  Sub_270D:      EQU    $270D            ; [*37] undefined opcode at $270D — see [*37]
$270E  6F 80               Sub_270E:      CLR ,X+               
$2710  31 3F                              LEAY -1,Y             
$2712  26 FA                              BNE Sub_270E          
$2714  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2716  A6 1E               Sub_2716:      LDA -2,X              
$2718  80 31                              SUBA #$31             
$271A  81 03                              CMPA #$03             
$271C  22 53                              BHI Sub_2771          
$271E  C6 40                              LDB #$40               ; B = '@'
$2720  3D                                 MUL                    ; D = A×B unsigned
$2721  10 8E 12 3B                        LDY #$123B            
$2725  31 AB                              LEAY D,Y              
$2727  C6 40                              LDB #$40               ; B = '@'
$2729  A6 80               Sub_2729:      LDA ,X+               
$272B  5A                                 DECB                  
$272C  81 0D                              CMPA #$0D              ; compare A with CR
$272E  27 05                              BEQ Sub_2735          
$2730  A7 A0                              STA ,Y+               
$2732  5D                                 TSTB                  
$2733  26 F4                              BNE Sub_2729          
$2735  86 0D               Sub_2735:      LDA #$0D               ; A = CR
$2737  A7 A4                              STA ,Y                
$2739  20 36                              BRA Sub_2771          

; --------------------------------------------------------------
$273B  A6 1E               Sub_273B:      LDA -2,X              
$273D  80 31                              SUBA #$31             
$273F  81 03                              CMPA #$03             
$2741  22 2E                              BHI Sub_2771          
$2743  C6 40                              LDB #$40               ; B = '@'
$2745  3D                                 MUL                    ; D = A×B unsigned
$2746  10 8E 11 3B                        LDY #$113B            
$274A  31 AB                              LEAY D,Y              
$274C  86 01                              LDA #$01              
$274E  B7 0C 8F                           STA $0C8F             
$2751  34 10                              PSHS X                
$2753  8E 11 3B                           LDX #$113B            
$2756  BF 13 BB                           STX $13BB             
$2759  35 10                              PULS X                
$275B  C6 40                              LDB #$40               ; B = '@'
$275D  A6 80               Sub_275D:      LDA ,X+               
$275F  81 0D                              CMPA #$0D              ; compare A with CR
$2761  27 0B                              BEQ Sub_276E          
$2763  81 5C                              CMPA #$5C              ; compare A with '\'
$2765  27 0D                              BEQ Sub_2774          
$2767  A7 A0               Sub_2767:      STA ,Y+               
$2769  5A                                 DECB                  
$276A  26 F1                              BNE Sub_275D          
$276C  20 03                              BRA Sub_2771          

; --------------------------------------------------------------
$276E  5F                  Sub_276E:      CLRB                   ; B = 0
$276F  E7 A4                              STB ,Y                
$2771  16 0B EA            Sub_2771:      LBRA Sub_335E         
$2774  A6 80               Sub_2774:      LDA ,X+               
$2776  80 40                              SUBA #$40             
$2778  20 ED                              BRA Sub_2767          

; --------------------------------------------------------------
$277A  34 36               Sub_277A:      PSHS A,B,X,Y          
$277C  F6 0C 96                           LDB $0C96             
$277F  10 BE 13 BB         Sub_277F:      LDY $13BB             
$2783  A6 80                              LDA ,X+               
$2785  84 7F                              ANDA #$7F             
$2787  5A                                 DECB                  
$2788  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$2789  7A A1 A4                           DEC $A1A4             
$278C  27 24                              BEQ Sub_27B2          
$278E  B6 0C 8F                           LDA $0C8F             
$2791  4A                                 DECA                  
$2792  34 04                              PSHS B                
$2794  C6 40                              LDB #$40               ; B = '@'
$2796  3D                                 MUL                    ; D = A×B unsigned
$2797  10 8E 11 3B                        LDY #$113B            
$279B  31 AB                              LEAY D,Y              
$279D  10 BF 13 BB                        STY $13BB             
$27A1  35 04                              PULS B                
$27A3  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$27A4  7A 26 04                           DEC $2604             
$27A7  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$27A8  7A 20 DF            Insn_27A8:     DEC $20DF             
$27AB  0F                  Sub_27AB:      EQU    $27AB            ; [*38] branch target 3 byte(s) inside Insn_27A8 -- see [*38]
$27AC  7A 5D 26                           DEC $5D26             
$27AF  D3 35                              ADDD <$35             
$27B0  35 B6               Sub_27B0:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$27B2  31 21               Sub_27B2:      LEAY 1,Y              
$27B4  10 BF 13 BB                        STY $13BB             
$27B8  6D A4                              TST ,Y                
$27BA  26 EF                              BNE Sub_27AB          
$27BC  B6 0C 8F                           LDA $0C8F             
$27BF  7C 0C 8F                           INC $0C8F             
$27C2  7C 0C 90                           INC $0C90             
$27C5  C6 40                              LDB #$40               ; B = '@'
$27C7  3D                                 MUL                    ; D = A×B unsigned
$27C8  10 8E 11 3B                        LDY #$113B            
$27CC  31 AB                              LEAY D,Y              
$27CE  10 BF 13 BB                        STY $13BB             
$27D2  20 DC                              BRA Sub_27B0          

; --------------------------------------------------------------
$27D4  34 36               Sub_27D4:      PSHS A,B,X,Y          
$27D6  7F 0C 90                           CLR $0C90             
$27D9  B6 0C 8F                           LDA $0C8F             
$27DC  80 02                              SUBA #$02             
$27DE  C6 40                              LDB #$40               ; B = '@'
$27E0  3D                                 MUL                    ; D = A×B unsigned
$27E1  8E 12 3B                           LDX #$123B            
$27E4  30 8B                              LEAX D,X              
$27E6  34 10                              PSHS X                
$27E8  5F                                 CLRB                   ; B = 0
$27E9  A6 80                              LDA ,X+               
$27EB  5C                                 INCB                  
$27EC  C1 40                              CMPB #$40              ; compare B with '@'
$27EE  22 04                              BHI $27F4             
$27F0  81 0D                              CMPA #$0D              ; compare A with CR
$27F2  26 F5                              BNE $27E9             
$27F4  5A                                 DECB                  
$27F5  4F                                 CLRA                   ; A = 0
$27F6  35 10                              PULS X                
$27F8  5D                                 TSTB                  
$27F9  27 0D                              BEQ $2808             
$27FB  A6 80               Sub_27FB:      LDA ,X+               
$27FD  5A                                 DECB                  
$27FE  81 5C                              CMPA #$5C              ; compare A with '\'
$2800  27 14                              BEQ Sub_2816          
$2802  17 F4 C4                           LBSR Sub_1CC9          ; call Sub_1CC9
$2805  5D                  Sub_2805:      TSTB                  
$2806  26 F3                              BNE Sub_27FB          
$2808  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$280A  34 10               Sub_280A:      PSHS X                
$280C  8E 00 1E                           LDX #$001E            
$280F  17 E9 66                           LBSR Sub_1178          ; call Sub_1178
$2812  35 10                              PULS X                
$2814  20 EF                              BRA Sub_2805          

; --------------------------------------------------------------
$2816  A6 80               Sub_2816:      LDA ,X+               
$2818  5A                                 DECB                  
$2819  81 5E                              CMPA #$5E              ; compare A with '^'
$281B  27 0F                              BEQ Sub_282C          
$281D  81 2A               Sub_281D:      CMPA #$2A              ; compare A with '*'
$281F  27 E9                              BEQ Sub_280A          
$2821  81 5C                              CMPA #$5C              ; compare A with '\'
$2823  27 02                              BEQ Sub_2827          
$2825  80 40                              SUBA #$40             
$2827  17 F4 9F            Sub_2827:      LBSR Sub_1CC9          ; call Sub_1CC9
$282A  20 D9                              BRA Sub_2805          

; --------------------------------------------------------------
$282C  86 1B               Sub_282C:      LDA #$1B               ; A = ESC
$282E  20 F7                              BRA Sub_2827          

; --------------------------------------------------------------
$2830  34 36               Sub_2830:      PSHS A,B,X,Y          
$2832  0D                  Sub_2832:      EQU    $2832            ; [*39] branch target 2 byte(s) inside Sub_2830 -- see [*39]
$2833  4D                                 TSTA                  
$2834  10 26 00 8F                        LBNE Sub_28C7         
$2838  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$2839  4D                                 TSTA                  
$283A  8D 02                              BSR Sub_283E           ; call Sub_283E
$283C  20 0F                              BRA Sub_284D          

; --------------------------------------------------------------
$283E  30 8D DC 4D         Sub_283E:      LEAX Dat_048F,PC       ; X → Dat_048F
$2842  10 8E 13 C3                        LDY #$13C3            
$2846  C6 0C                              LDB #$0C               ; B = FF
$2848  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$284C  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$284D  8E 13 C3            Sub_284D:      LDX #$13C3            
$2850  96 9D                              LDA <$9D              
$2852  D6 9E                              LDB <$9E              
$2854  C0 03                              SUBB #$03             
$2856  ED 07                              STD 7,X               
$2858  86 FF                              LDA #$FF              
$285A  A7 04                              STA 4,X               
$285C  B6 0C C7                           LDA $0CC7             
$285F  17 F6 6A                           LBSR Sub_1ECC          ; call Sub_1ECC
$2862  A7 09                              STA 9,X               
$2864  B6 0C C8                           LDA $0CC8             
$2867  17 F6 62                           LBSR Sub_1ECC          ; call Sub_1ECC
$286A  A7 0A                              STA 10,X              
$286C  86 01                              LDA #$01              
$286E  10 8E 00 0B                        LDY #$000B            
$2872  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2875  86 02                              LDA #$02               ; A = CurXY
$2877  30 8D DC 12                        LEAX Dat_048D,PC       ; X → Dat_048D
$287B  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$287E  25 B2                              BCS Sub_2832           ; C=1 (BLO)
$2880  97 4C                              STA <$4C              
$2882  8E 13 C3                           LDX #$13C3            
$2885  30 02                              LEAX 2,X              
$2887  6F 02                              CLR 2,X               
$2889  96 9E                              LDA <$9E              
$288B  80 02                              SUBA #$02             
$288D  A7 04                              STA 4,X               
$288F  86 03                              LDA #$03              
$2891  A7 06                              STA 6,X               
$2893  B6 0C CF                           LDA $0CCF             
$2896  17 F6 33                           LBSR Sub_1ECC          ; call Sub_1ECC
$2899  A7 07                              STA 7,X               
$289B  B6 0C D0                           LDA $0CD0             
$289E  17 F6 2B                           LBSR Sub_1ECC          ; call Sub_1ECC
$28A1  A7 08                              STA 8,X               
$28A3  96 4C                              LDA <$4C              
$28A5  10 8E 00 09                        LDY #$0009            
$28A9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$28AC  8E 00 02                           LDX #$0002            
$28AF  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$28B2  8E 13 C3                           LDX #$13C3            
$28B5  17 01 55            Sub_28B5:      LBSR Sub_2A0D          ; call Sub_2A0D
$28B8  30 8D E2 62                        LEAX Dat_0B1E,PC       ; X → Dat_0B1E
$28BC  96 4B                              LDA <$4B              
$28BE  10 8E 00 07                        LDY #$0007            
$28C2  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$28C5  35 B6               Sub_28C5:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$28C7  0F                  Sub_28C7:      EQU    $28C7            ; [*40] branch target 2 byte(s) inside Sub_28C5 -- see [*40]
$28C8  4D                                 TSTA                  
$28C9  30 8D DB CE                        LEAX Dat_049B,PC       ; X → Dat_049B
$28CD  96 4C                              LDA <$4C              
$28CF  10 8E 00 02                        LDY #$0002            
$28D3  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$28D6  96 4C                              LDA <$4C              
$28D8  10 3F 8F                           OS9 I$Close            ; path=A
$28DB  17 FF 60                           LBSR Sub_283E          ; call Sub_283E
$28DE  8E 13 C3                           LDX #$13C3            
$28E1  96 9D                              LDA <$9D              
$28E3  D6 9E                              LDB <$9E              
$28E5  ED 07                              STD 7,X               
$28E7  86 FF                              LDA #$FF              
$28E9  A7 04                              STA 4,X               
$28EB  B6 0C C7                           LDA $0CC7             
$28EE  17 F5 DB                           LBSR Sub_1ECC          ; call Sub_1ECC
$28F1  A7 09                              STA 9,X               
$28F3  B6 0C C8                           LDA $0CC8             
$28F6  17 F5 D3                           LBSR Sub_1ECC          ; call Sub_1ECC
$28F9  A7 0A                              STA 10,X              
$28FB  86 01                              LDA #$01              
$28FD  10 8E 00 0B                        LDY #$000B            
$2901  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2904  8E 00 02                           LDX #$0002            
$2907  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$290A  30 8D E2 09                        LEAX Dat_0B17,PC       ; X → Dat_0B17
$290E  96 4B                              LDA <$4B              
$2910  10 8E 00 07                        LDY #$0007            
$2914  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2917  20 AC                              BRA Sub_28C5          

; --------------------------------------------------------------
$2919  86 00               Sub_2919:      LDA #$00               ; A = NUL
$291B  10 8E 00 01                        LDY #$0001            
$291F  8E 06 1B                           LDX #$061B            
$2922  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2925  9E 71                              LDX <$71              
$2927  B6 06 1B                           LDA $061B             
$292A  81 8C                              CMPA #$8C             
$292C  10 22 EE 0F                        LBHI Sub_173F         
$2930  81 7F                              CMPA #$7F             
$2932  10 22 00 E5                        LBHI Sub_2A1B         
$2936  81 18                              CMPA #$18             
$2938  26 04                              BNE Sub_293E          
$293A  86 7F                              LDA #$7F              
$293C  20 38                              BRA Sub_2976          

; --------------------------------------------------------------
$293E  81 1A               Sub_293E:      CMPA #$1A              ; compare A with SUB
$2940  10 27 ED FB                        LBEQ Sub_173F         
$2944  81 1C                              CMPA #$1C             
$2946  10 27 ED F5                        LBEQ Sub_173F         
$294A  81 0A                              CMPA #$0A              ; compare A with LF
$294C  10 27 00 CB                        LBEQ Sub_2A1B         
$2950  81 0C                              CMPA #$0C              ; compare A with FF
$2952  10 27 00 C5                        LBEQ Sub_2A1B         
$2956  81 09                              CMPA #$09             
$2958  10 27 00 BF                        LBEQ Sub_2A1B         
$295C  81 08                              CMPA #$08              ; compare A with BS
$295E  26 0C                              BNE Sub_296C          
$2960  D6 73                              LDB <$73              
$2962  27 21                              BEQ Sub_2985          
$2964  30 1F                              LEAX -1,X             
$2966  9F 71                              STX <$71              
$2968  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$2969  73 20 14                           COM $2014             
$296C  D6 73               Sub_296C:      LDB <$73              
$296E  C1 FD                              CMPB #$FD             
$2970  25 04                              BCS Sub_2976           ; C=1 (BLO)
$2972  81 0D                              CMPA #$0D              ; compare A with CR
$2974  26 0F                              BNE Sub_2985          
$2976  A7 80               Sub_2976:      STA ,X+               
$2978  9F 71                              STX <$71              
$297A  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$297B  73 81 0D                           COM $810D             
$297E  27 18                              BEQ Sub_2998          
$2980  8D 44                              BSR Sub_29C6           ; call Sub_29C6
$2982  16 00 96                           LBRA Sub_2A1B         

; --------------------------------------------------------------
$2985  86 07               Sub_2985:      LDA #$07              
$2987  8E 13 C3                           LDX #$13C3            
$298A  A7 84                              STA ,X                
$298C  86 01                              LDA #$01              
$298E  10 8E 00 01                        LDY #$0001            
$2992  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2995  16 00 83                           LBRA Sub_2A1B         

; --------------------------------------------------------------
$2998  86 0A               Sub_2998:      LDA #$0A               ; A = LF
$299A  A7 80                              STA ,X+               
$299C  D6 73                              LDB <$73              
$299E  7D 0C BE                           TST $0CBE             
$29A1  27 01                              BEQ Sub_29A4          
$29A3  5C                                 INCB                  
$29A4  4F                  Sub_29A4:      CLRA                   ; A = 0
$29A5  1F 02                              TFR D,Y               
$29A7  96 38                              LDA <$38              
$29A9  8E 05 1C                           LDX #$051C            
$29AC  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$29AF  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$29B0  73 8E 05                           COM $8E05             
$29B3  1C 9F                              ANDCC #$9F             ; clr CC: H,F
$29B5  71                                 FCB    $71                ; undefined opcode $71 -- not a valid 6809 instruction
$29B6  86 0D                              LDA #$0D               ; A = CR
$29B8  B7 06 1B                           STA $061B             
$29BB  8D 09                              BSR Sub_29C6           ; call Sub_29C6
$29BD  86 0A                              LDA #$0A               ; A = LF
$29BF  B7 06 1B                           STA $061B             
$29C2  8D 02                              BSR Sub_29C6           ; call Sub_29C6
$29C4  20 55                              BRA Sub_2A1B          

; --------------------------------------------------------------
$29C6  B6 06 1B            Sub_29C6:      LDA $061B             
$29C9  81 0D                              CMPA #$0D              ; compare A with CR
$29CB  26 14                              BNE Sub_29E1          
$29CD  CC 20 0D                           LDD #$200D            
$29D0  FD 13 C3                           STD $13C3             
$29D3  8E 13 C3                           LDX #$13C3            
$29D6  96 4C                              LDA <$4C              
$29D8  10 8E 00 02                        LDY #$0002            
$29DC  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$29DF  20 2B                              BRA Sub_2A0C          

; --------------------------------------------------------------
$29E1  81 08               Sub_29E1:      CMPA #$08              ; compare A with BS
$29E3  26 12                              BNE Sub_29F7          
$29E5  CC 20 08                           LDD #$2008            
$29E8  FD 13 C3                           STD $13C3             
$29EB  8E 13 C3                           LDX #$13C3            
$29EE  96 4C                              LDA <$4C              
$29F0  10 8E 00 02                        LDY #$0002            
$29F4  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$29F7  8E 06 1B            Sub_29F7:      LDX #$061B            
$29FA  10 8E 00 01                        LDY #$0001            
$29FE  96 4C                              LDA <$4C              
$2A00  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2A03  B6 06 1B                           LDA $061B             
$2A06  81 0D                              CMPA #$0D              ; compare A with CR
$2A08  27 02                              BEQ Sub_2A0C          
$2A0A  8D 01                              BSR Sub_2A0D           ; call Sub_2A0D
$2A0C  39                  Sub_2A0C:      RTS                    ; return from subroutine
$2A0D  96 4C               Sub_2A0D:      LDA <$4C              
$2A0F  30 8D DA A6                        LEAX Dat_04B9,PC       ; X → Dat_04B9
$2A13  10 8E 00 06                        LDY #$0006            
$2A17  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2A1A  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2A1B  16 E4 0C            Sub_2A1B:      LBRA Sub_0E2A         
$2A1E  34 36               Sub_2A1E:      PSHS A,B,X,Y          
$2A20  8E 00 EF                           LDX #$00EF            
$2A23  34 10                              PSHS X                
$2A25  6D 80                              TST ,X+               
$2A27  26 FC                              BNE $2A25             
$2A29  30 1F                              LEAX -1,X             
$2A2B  34 10                              PSHS X                
$2A2D  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$2A2E  A7 A6                              STA A,Y               
$2A2F  A6 82               Sub_2A2F:      LDA ,-X               
$2A31  AC 62                              CMPX 2,S              
$2A33  25 2E                              BCS Sub_2A63           ; C=1 (BLO)
$2A35  81 41                              CMPA #$41              ; compare A with 'A'
$2A37  25 10                              BCS Sub_2A49           ; C=1 (BLO)
$2A39  81 5A                              CMPA #$5A              ; compare A with 'Z'
$2A3B  23 F2                              BLS Sub_2A2F          
$2A3D  81 61                              CMPA #$61              ; compare A with 'a'
$2A3F  25 18                              BCS Sub_2A59           ; C=1 (BLO)
$2A41  81 7A                              CMPA #$7A              ; compare A with 'z'
$2A43  22 1A                              BHI Sub_2A5F          
$2A44  1A 97               Sub_2A44:      ORCC #$97              ; set CC: C,V,Z,I,E
$2A46  A7 20                              STA 0,Y               
$2A48  E6 81                              LDB ,X++              
$2A49  81 39               Sub_2A49:      CMPA #$39              ; compare A with '9'
$2A4B  22 0C                              BHI Sub_2A59          
$2A4D  81 30                              CMPA #$30              ; compare A with '0'
$2A4F  24 DE                              BCC Sub_2A2F           ; C=0 (BHS)
$2A51  81 2E                              CMPA #$2E              ; compare A with '.'
$2A53  27 DA                              BEQ Sub_2A2F          
$2A55  81 2F                              CMPA #$2F              ; compare A with '/'
$2A57  27 0A                              BEQ Sub_2A63          
$2A59  86 5F               Sub_2A59:      LDA #$5F               ; A = '_'
$2A5B  A7 84                              STA ,X                
$2A5D  20 D0                              BRA Sub_2A2F          

; --------------------------------------------------------------
$2A5F  81 5C               Sub_2A5F:      CMPA #$5C              ; compare A with '\'
$2A61  26 F6                              BNE Sub_2A59          
$2A63  30 01               Sub_2A63:      LEAX 1,X              
$2A65  A6 84                              LDA ,X                
$2A67  27 12                              BEQ Sub_2A7B          
$2A69  81 0D                              CMPA #$0D              ; compare A with CR
$2A6B  27 0E                              BEQ Sub_2A7B          
$2A6D  81 41                              CMPA #$41              ; compare A with 'A'
$2A6F  25 04                              BCS Sub_2A75           ; C=1 (BLO)
$2A71  81 5F                              CMPA #$5F              ; compare A with '_'
$2A73  26 06                              BNE Sub_2A7B          
$2A75  30 1F               Sub_2A75:      LEAX -1,X             
$2A77  86 78                              LDA #$78               ; A = 'x'
$2A79  A7 84                              STA ,X                
$2A7B  AF 62               Sub_2A7B:      STX 2,S               
$2A7D  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2A7E  A7 26                              STA 6,Y               
$2A80  14                                 FCB    $14                ; undefined opcode $14 -- not a valid 6809 instruction
$2A81  A6 80               Sub_2A81:      LDA ,X+               
$2A83  AC E4                              CMPX ,S               
$2A85  22 0E                              BHI Sub_2A95          
$2A87  81 41                              CMPA #$41              ; compare A with 'A'
$2A89  25 F6                              BCS Sub_2A81           ; C=1 (BLO)
$2A8B  81 5A                              CMPA #$5A              ; compare A with 'Z'
$2A8D  22 F2                              BHI Sub_2A81          
$2A8F  8A 20                              ORA #$20              
$2A91  A7 1F                              STA -1,X              
$2A93  20 EC                              BRA Sub_2A81          

; --------------------------------------------------------------
$2A95  10 8E 00 AC         Sub_2A95:      LDY #$00AC            
$2A99  AE 62                              LDX 2,S               
$2A9B  EC E1                              LDD ,S++              
$2A9D  A3 E1                              SUBD ,S++             
$2A9F  5D                                 TSTB                  
$2AA0  27 0C                              BEQ Sub_2AAE          
$2AA2  C1 1D                              CMPB #$1D             
$2AA4  23 02                              BLS Sub_2AA8          
$2AA6  C6 1D                              LDB #$1D              
$2AA8  AD 9F 0C AF         Sub_2AA8:      JSR [$0CAF]            ; call via indexed pointer
$2AAC  30 01                              LEAX 1,X              
$2AAE  86 0D               Sub_2AAE:      LDA #$0D               ; A = CR
$2AB0  A7 A4                              STA ,Y                
$2AB2  8D 67                              BSR Sub_2B1B           ; call Sub_2B1B
$2AB4  30 8D DA D9                        LEAX Dat_0591,PC       ; X → Dat_0591
$2AB8  17 F2 DA                           LBSR Sub_1D95          ; call Sub_1D95
$2ABB  8E 00 AC                           LDX #$00AC            
$2ABE  A6 84                              LDA ,X                
$2AC0  27 2C                              BEQ Sub_2AEE          
$2AC2  81 0D                              CMPA #$0D              ; compare A with CR
$2AC4  27 28                              BEQ Sub_2AEE          
$2AC6  86 01                              LDA #$01              
$2AC8  10 8E 00 20                        LDY #$0020            
$2ACC  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$2ACF  30 8D D9 E2                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$2AD3  17 F2 BF                           LBSR Sub_1D95          ; call Sub_1D95
$2AD6  DC 68                              LDD <$68              
$2AD8  26 1E                              BNE Sub_2AF8          
$2ADA  DC 66                              LDD <$66              
$2ADC  26 1A                              BNE Sub_2AF8          
$2ADE  8E 00 AC            Sub_2ADE:      LDX #$00AC            
$2AE1  86 02                              LDA #$02               ; A = CurXY
$2AE3  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$2AE5  10 3F 83                           OS9 I$Create           ; mode=B  name→X  → path→A
$2AE8  25 04                              BCS Sub_2AEE           ; C=1 (BLO)
$2AEA  97 4F                              STA <$4F              
$2AEC  35 B6               Sub_2AEC:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2AEE  86 FF               Sub_2AEE:      LDA #$FF              
$2AF0  97 4F                              STA <$4F              
$2AF2  86 0A                              LDA #$0A               ; A = LF
$2AF4  97 5D                              STA <$5D              
$2AF6  20 F4                              BRA Sub_2AEC          

; --------------------------------------------------------------
$2AF8  30 8D DA A1         Sub_2AF8:      LEAX Dat_059D,PC       ; X → Dat_059D
$2AFC  17 F2 96                           LBSR Sub_1D95          ; call Sub_1D95
$2AFF  8E 13 C4                           LDX #$13C4            
$2B02  10 8E 00 07                        LDY #$0007            
$2B06  A6 84               Sub_2B06:      LDA ,X                
$2B08  81 30                              CMPA #$30              ; compare A with '0'
$2B0A  26 08                              BNE Sub_2B14          
$2B0C  30 01                              LEAX 1,X              
$2B0E  31 3F                              LEAY -1,Y             
$2B10  27 CC                              BEQ Sub_2ADE          
$2B12  20 F2                              BRA Sub_2B06          

; --------------------------------------------------------------
$2B14  86 01               Sub_2B14:      LDA #$01              
$2B16  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2B19  20 C3                              BRA Sub_2ADE          

; --------------------------------------------------------------
$2B1B  34 36               Sub_2B1B:      PSHS A,B,X,Y          
$2B1D  CC 00 00                           LDD #$0000            
$2B20  DD 66                              STD <$66              
$2B22  DD 68                              STD <$68              
$2B24  C6 08                              LDB #$08               ; B = BS
$2B26  A6 80               Sub_2B26:      LDA ,X+               
$2B28  81 20                              CMPA #$20              ; compare A with ' '
$2B2A  27 08                              BEQ Sub_2B34          
$2B2C  4D                                 TSTA                  
$2B2D  27 05                              BEQ Sub_2B34          
$2B2F  5A                                 DECB                  
$2B30  26 F4                              BNE Sub_2B26          
$2B32  20 2C                              BRA Sub_2B60          

; --------------------------------------------------------------
$2B34  10 8E 13 CA         Sub_2B34:      LDY #$13CA            
$2B38  30 1F                              LEAX -1,X             
$2B3A  C6 08                              LDB #$08               ; B = BS
$2B3C  A6 82               Sub_2B3C:      LDA ,-X               
$2B3E  27 07                              BEQ Sub_2B47          
$2B40  A7 A2                              STA ,-Y               
$2B42  5A                                 DECB                  
$2B43  C1 01                              CMPB #$01             
$2B45  26 F5                              BNE Sub_2B3C          
$2B47  86 30               Sub_2B47:      LDA #$30               ; A = '0'
$2B49  A7 A2               Sub_2B49:      STA ,-Y               
$2B4B  5A                                 DECB                  
$2B4C  C1 01                              CMPB #$01             
$2B4E  26 F9                              BNE Sub_2B49          
$2B50  10 8E 13 C3                        LDY #$13C3            
$2B54  30 8D DF D3                        LEAX Dat_0B2B,PC       ; X → Dat_0B2B
$2B58  5F                                 CLRB                   ; B = 0
$2B59  8D 07               Sub_2B59:      BSR Sub_2B62           ; call Sub_2B62
$2B5B  5C                                 INCB                  
$2B5C  C1 08                              CMPB #$08              ; compare B with BS
$2B5E  26 F9                              BNE Sub_2B59          
$2B60  35 B6               Sub_2B60:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2B62  34 14               Sub_2B62:      PSHS B,X              
$2B64  86 04                              LDA #$04              
$2B66  3D                                 MUL                    ; D = A×B unsigned
$2B67  30 8B                              LEAX D,X              
$2B69  E6 E4                              LDB ,S                
$2B6B  A6 A5                              LDA B,Y               
$2B6D  80 30                              SUBA #$30             
$2B6F  1F 89                              TFR A,B               
$2B71  27 1F                              BEQ Sub_2B92          
$2B73  34 04               Sub_2B73:      PSHS B                
$2B75  E6 03                              LDB 3,X               
$2B77  DB 69                              ADDB <$69             
$2B79  D7 69                              STB <$69              
$2B7B  A6 02                              LDA 2,X               
$2B7D  99 68                              ADCA <$68             
$2B7F  97 68                              STA <$68              
$2B81  E6 01                              LDB 1,X               
$2B83  D9 67                              ADCB <$67             
$2B85  D7 67                              STB <$67              
$2B87  A6 84                              LDA ,X                
$2B89  99 66                              ADCA <$66             
$2B8B  97 66                              STA <$66              
$2B8D  35 04                              PULS B                
$2B8F  5A                                 DECB                  
$2B90  26 E1                              BNE Sub_2B73          
$2B92  35 94               Sub_2B92:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)
$2B94  34 36               Sub_2B94:      PSHS A,B,X,Y          
$2B96  17 EA 0B                           LBSR Sub_15A4          ; call Sub_15A4
$2B99  25 1B                              BCS Sub_2BB6           ; C=1 (BLO)
$2B9B  4F                                 CLRA                   ; A = 0
$2B9C  1F 02                              TFR D,Y               
$2B9E  8E 06 1B                           LDX #$061B            
$2BA1  86 00                              LDA #$00               ; A = NUL
$2BA3  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2BA6  25 0E                              BCS Sub_2BB6           ; C=1 (BLO)
$2BA8  1F 20                              TFR Y,D               
$2BAA  8E 06 1B                           LDX #$061B            
$2BAD  A6 80               Sub_2BAD:      LDA ,X+               
$2BAF  81 05                              CMPA #$05             
$2BB1  27 06                              BEQ Sub_2BB9          
$2BB3  5A                                 DECB                  
$2BB4  26 F7                              BNE Sub_2BAD          
$2BB6  5F                  Sub_2BB6:      CLRB                   ; B = 0
$2BB7  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2BB9  53                  Sub_2BB9:      COMB                  
$2BBA  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2BBC  34 34               Sub_2BBC:      PSHS B,X,Y            
$2BBE  17 10 0B                           LBSR Sub_3BCC          ; call Sub_3BCC
$2BC1  8D D1               Sub_2BC1:      BSR Sub_2B94           ; call Sub_2B94
$2BC3  25 29                              BCS Sub_2BEE           ; C=1 (BLO)
$2BC5  96 38                              LDA <$38              
$2BC7  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2BC9  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2BCC  24 09                              BCC Sub_2BD7           ; C=0 (BHS)
$2BCE  17 10 14                           LBSR Sub_3BE5          ; call Sub_3BE5
$2BD1  81 3B                              CMPA #$3B              ; compare A with ';'
$2BD3  25 EC                              BCS Sub_2BC1           ; C=1 (BLO)
$2BD5  20 17                              BRA Sub_2BEE          

; --------------------------------------------------------------
$2BD7  10 8E 00 01         Sub_2BD7:      LDY #$0001            
$2BDB  96 38                              LDA <$38              
$2BDD  8E 04 FC                           LDX #$04FC            
$2BE0  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2BE3  25 0C                              BCS Sub_2BF1           ; C=1 (BLO)
$2BE5  B6 04 FC                           LDA $04FC             
$2BE8  7F 04 FC                           CLR $04FC             
$2BEB  5F                  Sub_2BEB:      CLRB                   ; B = 0
$2BEC  35 B4                              PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2BEE  53                  Sub_2BEE:      COMB                  
$2BEF  35 B4                              PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2BF1  4F                  Sub_2BF1:      CLRA                   ; A = 0
$2BF2  20 F7               Sub_2BF2:      BRA Sub_2BEB          
$2BF4  34 36               Sub_2BF4:      PSHS A,B,X,Y          
$2BF6  30 8D D8 B7                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$2BFA  17 F1 98                           LBSR Sub_1D95          ; call Sub_1D95
$2BFD  5F                                 CLRB                   ; B = 0
$2BFE  8E 07 1A                           LDX #$071A            
$2C00  1A 34               Sub_2C00:      ORCC #$34              ; set CC: Z,I,H
$2C01  34 14               Sub_2C01:      PSHS B,X              
$2C03  8D 1B                              BSR Sub_2C20           ; call Sub_2C20
$2C05  35 14                              PULS B,X              
$2C07  B6 06 1B                           LDA $061B             
$2C0A  81 0D                              CMPA #$0D              ; compare A with CR
$2C0C  27 09                              BEQ Sub_2C17          
$2C0E  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2C0F  30 26                              LEAX 6,Y              
$2C11  05                                 FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
$2C12  5C                                 INCB                  
$2C13  C1 20                              CMPB #$20              ; compare B with ' '
$2C15  26 EA                              BNE Sub_2C01          
$2C17  30 8D D8 9A         Sub_2C17:      LEAX Dat_04B5,PC       ; X → Dat_04B5
$2C1B  17 F1 77                           LBSR Sub_1D95          ; call Sub_1D95
$2C1E  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2C20  86 20               Sub_2C20:      LDA #$20               ; A = ' '
$2C22  3D                                 MUL                    ; D = A×B unsigned
$2C23  30 8B                              LEAX D,X              
$2C25  34 10                              PSHS X                
$2C27  30 8D D9 5A                        LEAX Dat_0585,PC       ; X → Dat_0585
$2C2B  17 F1 67                           LBSR Sub_1D95          ; call Sub_1D95
$2C2E  C6 1E                              LDB #$1E              
$2C30  17 F1 BD                           LBSR Sub_1DF0          ; call Sub_1DF0
$2C33  35 10                              PULS X                
$2C35  10 8E 06 1B                        LDY #$061B            
$2C39  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$2C3B  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$2C3F  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2C40  34 36               Sub_2C40:      PSHS A,B,X,Y          
$2C42  D6 75                              LDB <$75              
$2C44  86 20                              LDA #$20               ; A = ' '
$2C46  3D                                 MUL                    ; D = A×B unsigned
$2C47  8E 07 1A                           LDX #$071A            
$2C4A  30 8B                              LEAX D,X              
$2C4C  10 8E 00 AC                        LDY #$00AC            
$2C50  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$2C52  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$2C56  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$2C57  75                                 FCB    $75                ; undefined opcode $75 -- not a valid 6809 instruction
$2C58  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2C5A  34 34               Sub_2C5A:      PSHS B,X,Y            
$2C5C  86 01                              LDA #$01              
$2C5E  97 36                              STA <$36              
$2C60  20 04                              BRA Sub_2C66          

; --------------------------------------------------------------
$2C62  34 34               Sub_2C62:      PSHS B,X,Y            
$2C64  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$2C65  36 17                              PSHU CC,A,B,X         
$2C66  17 E9 3B            Sub_2C66:      LBSR Sub_15A4          ; call Sub_15A4
$2C69  24 08                              BCC Sub_2C73           ; C=0 (BHS)
$2C6B  8E 00 03                           LDX #$0003            
$2C6E  17 E5 07                           LBSR Sub_1178          ; call Sub_1178
$2C71  20 F3                              BRA Sub_2C66          

; --------------------------------------------------------------
$2C73  5D                  Sub_2C73:      TSTB                  
$2C74  27 F0                              BEQ Sub_2C66          
$2C76  8E 00 2A                           LDX #$002A            
$2C79  10 8E 00 01                        LDY #$0001            
$2C7D  86 00                              LDA #$00               ; A = NUL
$2C7F  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2C82  A6 84                              LDA ,X                
$2C84  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2C85  36 26                              PSHU A,B,Y            
$2C87  08                                 FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
$2C88  84 7F                              ANDA #$7F             
$2C8A  81 60               Sub_2C8A:      CMPA #$60              ; compare A with '`'
$2C8C  25 02                              BCS Sub_2C90           ; C=1 (BLO)
$2C8E  80 20                              SUBA #$20             
$2C90  35 B4               Sub_2C90:      PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
$2C92  0D                  Sub_2C92:      EQU    $2C92            ; [*41] branch target 2 byte(s) inside Sub_2C90 -- see [*41]
$2C93  29 26                              BVS Sub_2CBB          
$2C95  3E                                 FCB    $3E                ; undefined opcode $3E -- not a valid 6809 instruction
$2C96  8E 0C 3B                           LDX #$0C3B            
$2C99  EC 88 1B                           LDD 27,X              
$2C9C  C3 00 04                           ADDD #$0004           
$2C9F  DD 22                              STD <$22              
$2CA1  86 01                              LDA #$01              
$2CA3  8E 07 1A                           LDX #$071A            
$2CA6  10 3F 18                           OS9 F$GPrDsc           ; pid=A  buf→X
$2CA9  30 88 40                           LEAX 64,X             
$2CAC  BF 0C 91                           STX $0C91             
$2CAF  1F 10                              TFR X,D               
$2CB1  9E 22                              LDX <$22              
$2CB3  10 8E 00 02                        LDY #$0002            
$2CB7  34 40                              PSHS U                
$2CB9  CE 13 C3                           LDU #$13C3            
$2CBB  C3 10 3F            Sub_2CBB:      ADDD #$103F           
$2CBE  1B                                 FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
$2CBF  BE 13 C3                           LDX $13C3             
$2CC2  30 88 24                           LEAX 36,X             
$2CC5  FC 0C 91                           LDD $0C91             
$2CC8  10 8E 00 02                        LDY #$0002            
$2CCC  CE 00 20                           LDU #$0020            
$2CCF  10 3F 1B                           OS9 F$CpyMem           ; src→X  dst→Y  count=D
$2CD2  35 40                              PULS U                
$2CD4  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2CD5  34 36               Sub_2CD5:      PSHS A,B,X,Y          
$2CD7  8E 13 C3                           LDX #$13C3            
$2CDA  CC 02 53                           LDD #$0253            
$2CDD  ED 84                              STD ,X                
$2CDF  86 20                              LDA #$20               ; A = ' '
$2CE1  A7 02                              STA 2,X               
$2CE3  10 8E 00 03                        LDY #$0003            
$2CE7  96 4B                              LDA <$4B              
$2CE9  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2CEC  8E 00 3A                           LDX #$003A            
$2CEF  5F                                 CLRB                   ; B = 0
$2CF0  A6 80               Sub_2CF0:      LDA ,X+               
$2CF2  5C                                 INCB                  
$2CF3  81 21                              CMPA #$21              ; compare A with '!'
$2CF5  25 04                              BCS Sub_2CFB           ; C=1 (BLO)
$2CF7  C1 05                              CMPB #$05             
$2CF9  25 F5                              BCS Sub_2CF0           ; C=1 (BLO)
$2CFB  8E 00 3A            Sub_2CFB:      LDX #$003A            
$2CFE  4F                                 CLRA                   ; A = 0
$2CFF  1F 02                              TFR D,Y               
$2D01  96 4B                              LDA <$4B              
$2D03  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2D06  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2D08  31 8D D7 9B         Sub_2D08:      LEAY Dat_04A7,PC       ; Y → Dat_04A7
$2D0C  8E 13 C3                           LDX #$13C3            
$2D0F  34 10                              PSHS X                
$2D11  C6 07                              LDB #$07              
$2D13  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$2D17  35 10                              PULS X                
$2D19  B6 0C CA                           LDA $0CCA             
$2D1C  17 F1 AD                           LBSR Sub_1ECC          ; call Sub_1ECC
$2D1F  A7 05                              STA 5,X               
$2D21  B6 0C C9                           LDA $0CC9             
$2D24  17 F1 A5                           LBSR Sub_1ECC          ; call Sub_1ECC
$2D27  A7 02                              STA 2,X               
$2D29  96 4B                              LDA <$4B              
$2D2B  10 8E 00 07                        LDY #$0007            
$2D2F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2D32  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2D33  4D                                 TSTA                  
$2D34  27 0D                              BEQ Sub_2D43          
$2D36  96 4B                              LDA <$4B              
$2D38  30 8D DD E2                        LEAX Dat_0B1E,PC       ; X → Dat_0B1E
$2D3C  10 8E 00 07                        LDY #$0007            
$2D40  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2D43  31 8D D3 AB         Sub_2D43:      LEAY Dat_00F2,PC       ; Y → Dat_00F2
$2D47  8E 13 C3                           LDX #$13C3            
$2D4A  C6 18                              LDB #$18              
$2D4C  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$2D50  8E 13 C3                           LDX #$13C3            
$2D53  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2D54  28 27                              BVC Sub_2D7D          
$2D56  05                                 FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
$2D57  86 61                              LDA #$61               ; A = 'a'
$2D59  A7 88 13                           STA 19,X              
$2D5C  96 4B                              LDA <$4B              
$2D5E  17 F0 36                           LBSR Sub_1D97          ; call Sub_1D97
$2D61  17 FF 71                           LBSR Sub_2CD5          ; call Sub_2CD5
$2D64  17 F8 3B                           LBSR Sub_25A2          ; call Sub_25A2
$2D67  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2D68  38                                 FCB    $38                ; undefined opcode $38 -- not a valid 6809 instruction
$2D69  27 03                              BEQ Sub_2D6E          
$2D6B  17 E6 28                           LBSR Sub_1396          ; call Sub_1396
$2D6E  96 7B               Sub_2D6E:      LDA <$7B              
$2D70  27 10                              BEQ Sub_2D82          
$2D72  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2D73  7E 27 0D                           JMP $270D             
$2D76  8E 00 80                           LDX #$0080            
$2D79  10 8E 00 0B                        LDY #$000B            
$2D7D  96 4B               Sub_2D7D:      LDA <$4B              
$2D7F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2D82  39                  Sub_2D82:      RTS                    ; return from subroutine
$2D83  17 E3 BC            Sub_2D83:      LBSR Sub_1142          ; call Sub_1142
$2D86  39                  Insn_2D86:     RTS                    ; return from subroutine
$2D87  0D                  Sub_2D87:      EQU    $2D87            ; [*42] branch target 1 byte(s) inside Insn_2D86 -- see [*42]
$2D88  4D                                 TSTA                  
$2D89  27 2A                              BEQ Sub_2DB5          
$2D8B  31 8D D7 18                        LEAY Dat_04A7,PC       ; Y → Dat_04A7
$2D8F  8E 13 C3                           LDX #$13C3            
$2D92  34 10                              PSHS X                
$2D94  C6 07                              LDB #$07              
$2D96  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$2D9A  35 10                              PULS X                
$2D9C  B6 0C D0                           LDA $0CD0             
$2D9F  17 F1 2A                           LBSR Sub_1ECC          ; call Sub_1ECC
$2DA2  A7 05                              STA 5,X               
$2DA4  B6 0C CF                           LDA $0CCF             
$2DA7  17 F1 22                           LBSR Sub_1ECC          ; call Sub_1ECC
$2DAA  A7 02                              STA 2,X               
$2DAC  96 4C                              LDA <$4C              
$2DAE  10 8E 00 07                        LDY #$0007            
$2DB2  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2DB5  39                  Sub_2DB5:      RTS                    ; return from subroutine
$2DB6  34 36               Sub_2DB6:      PSHS A,B,X,Y          
$2DB8  96 4F                              LDA <$4F              
$2DBA  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$2DBC  34 40                              PSHS U                
$2DBE  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2DC1  1F 32                              TFR U,Y               
$2DC3  35 40                              PULS U                
$2DC5  25 07                              BCS Sub_2DCE           ; C=1 (BLO)
$2DC7  9F 66                              STX <$66              
$2DC9  10 9F 68                           STY <$68              
$2DCC  20 09                              BRA Sub_2DD7          

; --------------------------------------------------------------
$2DCE  CC 00 00            Sub_2DCE:      LDD #$0000            
$2DD1  DD 66                              STD <$66              
$2DD3  DD 68                              STD <$68              
$2DD5  20 41                              BRA Sub_2E18          

; --------------------------------------------------------------
$2DD7  AE 62               Sub_2DD7:      LDX 2,S               
$2DD9  31 8D DD 4E                        LEAY Dat_0B2B,PC       ; Y → Dat_0B2B
$2DDD  34 10                              PSHS X                
$2DDF  86 30                              LDA #$30               ; A = '0'
$2DE1  C6 07                              LDB #$07              
$2DE3  A7 80               Sub_2DE3:      STA ,X+               
$2DE5  5A                                 DECB                  
$2DE6  26 FB                              BNE Sub_2DE3          
$2DE8  35 10                              PULS X                
$2DEA  5F                                 CLRB                   ; B = 0
$2DEB  34 36               Sub_2DEB:      PSHS A,B,X,Y          
$2DED  8D 2B                              BSR Sub_2E1A           ; call Sub_2E1A
$2DEF  35 36                              PULS A,B,X,Y          
$2DF1  5C                                 INCB                  
$2DF2  C1 08                              CMPB #$08              ; compare B with BS
$2DF4  26 F5                              BNE Sub_2DEB          
$2DF6  34 10                              PSHS X                
$2DF8  30 8D D7 A1                        LEAX Dat_059D,PC       ; X → Dat_059D
$2DFC  17 EF 96                           LBSR Sub_1D95          ; call Sub_1D95
$2DFF  35 10                              PULS X                
$2E01  10 8E 00 07                        LDY #$0007            
$2E05  A6 84               Sub_2E05:      LDA ,X                
$2E07  81 30                              CMPA #$30              ; compare A with '0'
$2E09  26 08                              BNE Sub_2E13          
$2E0B  30 01                              LEAX 1,X              
$2E0D  31 3F                              LEAY -1,Y             
$2E0F  27 07                              BEQ Sub_2E18          
$2E11  20 F2                              BRA Sub_2E05          

; --------------------------------------------------------------
$2E13  86 01               Sub_2E13:      LDA #$01              
$2E15  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2E18  35 B6               Sub_2E18:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2E1A  30 85               Sub_2E1A:      LEAX B,X              
$2E1C  86 04                              LDA #$04              
$2E1E  3D                                 MUL                    ; D = A×B unsigned
$2E1F  31 AB                              LEAY D,Y              
$2E21  EC A4               Sub_2E21:      LDD ,Y                
$2E23  10 93 66                           CMPD <$66             
$2E26  22 2A                              BHI Sub_2E52          
$2E28  25 07                              BCS Sub_2E31           ; C=1 (BLO)
$2E2A  EC 22                              LDD 2,Y               
$2E2C  10 93 68                           CMPD <$68             
$2E2F  22 21                              BHI Sub_2E52          
$2E31  DC 66               Sub_2E31:      LDD <$66              
$2E33  26 04                              BNE Sub_2E39          
$2E35  DC 68                              LDD <$68              
$2E37  27 19                              BEQ Sub_2E52          
$2E39  6C 84               Sub_2E39:      INC ,X                
$2E3B  DC 68                              LDD <$68              
$2E3D  A3 22                              SUBD 2,Y              
$2E3F  DD 68                              STD <$68              
$2E41  24 07                              BCC Sub_2E4A           ; C=0 (BHS)
$2E43  DC 66                              LDD <$66              
$2E45  83 00 01                           SUBD #$0001           
$2E48  DD 66                              STD <$66              
$2E4A  DC 66               Sub_2E4A:      LDD <$66              
$2E4C  A3 A4                              SUBD ,Y               
$2E4E  DD 66                              STD <$66              
$2E50  20 CF                              BRA Sub_2E21          

; --------------------------------------------------------------
$2E52  39                  Sub_2E52:      RTS                    ; return from subroutine
$2E53  A6 80               Sub_2E53:      LDA ,X+               
$2E55  A7 A0                              STA ,Y+               
$2E57  5A                                 DECB                  
$2E58  26 F9                              BNE Sub_2E53          
$2E5A  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$2E5B  A6 A0               Sub_2E5B:      LDA ,Y+               
$2E5D  A7 80                              STA ,X+               
$2E5F  5A                                 DECB                  
$2E60  26 F9                              BNE Sub_2E5B          
$2E62  39                                 RTS                    ; return from subroutine
         FCB    $4F,$1E,$06,$11,$38,$12,$39,$4F,$1E,$06,$11,$38,$21,$39  ; unreachable padding
$2E71  34 12               Sub_2E71:      PSHS A,X              
$2E73  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2E74  29 27                              BVS Sub_2E9D          
$2E76  0B                                 FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
$2E77  96 38                              LDA <$38              
$2E79  C6 28                              LDB #$28               ; B = SS.EnRTS  (GetStt/SetStt subcode)
$2E7B  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2E7E  1F 98                              TFR B,A               
$2E80  20 04                              BRA Sub_2E86          

; --------------------------------------------------------------
$2E82  9E 20               Sub_2E82:      LDX <$20              
$2E84  A6 01                              LDA 1,X               
$2E86  84 20               Sub_2E86:      ANDA #$20             
$2E88  27 03                              BEQ Sub_2E8D          
$2E8A  5F                                 CLRB                   ; B = 0
$2E8B  35 92               Sub_2E8B:      PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)
$2E8D  53                  Sub_2E8D:      COMB                  
$2E8E  20 FB                              BRA Sub_2E8B          

; --------------------------------------------------------------
$2E90  34 16               Sub_2E90:      PSHS A,B,X            
$2E92  8E 00 03                           LDX #$0003            
$2E95  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$2E98  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2E9A  96 38                              LDA <$38              
$2E9C  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2E9D  3F                  Sub_2E9D:      SWI                   
$2E9E  8D 25                              BSR Sub_2EC5           ; call Sub_2EC5
$2EA0  19                                 DAA                   
$2EA1  8E 00 15                           LDX #$0015            
$2EA4  17 E2 D1                           LBSR Sub_1178          ; call Sub_1178
$2EA7  96 38                              LDA <$38              
$2EA9  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2EAB  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$2EAE  4F                                 CLRA                   ; A = 0
$2EAF  1F 02                              TFR D,Y               
$2EB1  8E 13 C3                           LDX #$13C3            
$2EB4  96 38                              LDA <$38              
$2EB6  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$2EB9  5F                                 CLRB                   ; B = 0
$2EBA  35 96               Sub_2EBA:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$2EBC  C6 10               Sub_2EBC:      LDB #$10              
$2EBE  A6 80               Sub_2EBE:      LDA ,X+               
$2EC0  5A                                 DECB                  
$2EC1  26 04                              BNE Sub_2EC7          
$2EC3  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$2EC5  20 3D               Sub_2EC5:      BRA Sub_2F04          
$2EC7  81 30               Sub_2EC7:      CMPA #$30              ; compare A with '0'
$2EC9  25 F3                              BCS Sub_2EBE           ; C=1 (BLO)
$2ECB  81 39                              CMPA #$39              ; compare A with '9'
$2ECD  22 EF                              BHI Sub_2EBE          
$2ECF  1F 12                              TFR X,Y               
$2ED1  31 3F                              LEAY -1,Y             
$2ED3  A6 80               Sub_2ED3:      LDA ,X+               
$2ED5  81 30                              CMPA #$30              ; compare A with '0'
$2ED7  25 06                              BCS Sub_2EDF           ; C=1 (BLO)
$2ED9  81 39                              CMPA #$39              ; compare A with '9'
$2EDB  22 02                              BHI Sub_2EDF          
$2EDD  20 F4                              BRA Sub_2ED3          

; --------------------------------------------------------------
$2EDF  30 1F               Sub_2EDF:      LEAX -1,X             
$2EE1  CC 20 20                           LDD #$2020            
$2EE4  ED 84                              STD ,X                
$2EE6  86 A0                              LDA #$A0              
$2EE8  A7 24                              STA 4,Y               
$2EEA  30 8D D7 8B                        LEAX Dat_0679,PC       ; X → Dat_0679
$2EEE  5F                                 CLRB                   ; B = 0
$2EEF  34 34               Sub_2EEF:      PSHS B,X,Y            
$2EF1  C6 06                              LDB #$06               ; B = SS.EOF  (GetStt/SetStt subcode)
$2EF3  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$2EF6  35 34                              PULS B,X,Y            
$2EF8  24 0A                              BCC Sub_2F04           ; C=0 (BHS)
$2EFA  30 06                              LEAX 6,X              
$2EFC  5C                                 INCB                  
$2EFD  F1 0C B9                           CMPB $0CB9            
$2F00  23 ED                              BLS Sub_2EEF          
$2F02  20 11                              BRA Sub_2F15          

; --------------------------------------------------------------
$2F04  B6 0C BA            Sub_2F04:      LDA $0CBA             
$2F07  84 F0                              ANDA #$F0             
$2F09  B7 0C BA                           STA $0CBA             
$2F0C  FA 0C BA                           ORB $0CBA             
$2F0F  F7 0C BA                           STB $0CBA             
$2F12  17 E4 81                           LBSR Sub_1396          ; call Sub_1396
$2F15  39                  Sub_2F15:      RTS                    ; return from subroutine
$2F16  34 36               Sub_2F16:      PSHS A,B,X,Y          
$2F18  17 FF 75                           LBSR Sub_2E90          ; call Sub_2E90
$2F1B  25 3F                              BCS Sub_2F5C           ; C=1 (BLO)
$2F1D  10 BF 0C 95                        STY $0C95             
$2F21  8E 13 C3                           LDX #$13C3            
$2F24  F6 0C 96                           LDB $0C96             
$2F27  C0 07                              SUBB #$07             
$2F29  34 14               Sub_2F29:      PSHS B,X              
$2F2B  31 8D D3 B8                        LEAY Dat_02E7,PC       ; Y → Dat_02E7
$2F2F  C6 07                              LDB #$07              
$2F31  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$2F34  35 14                              PULS B,X              
$2F36  24 07                              BCC Sub_2F3F           ; C=0 (BHS)
$2F38  30 01                              LEAX 1,X              
$2F3A  5A                                 DECB                  
$2F3B  26 EC                              BNE Sub_2F29          
$2F3D  20 1D                              BRA Sub_2F5C          

; --------------------------------------------------------------
$2F3F  F6 0C BA            Sub_2F3F:      LDB $0CBA             
$2F42  C4 0F                              ANDB #$0F             
$2F44  C1 04                              CMPB #$04             
$2F46  22 03                              BHI Sub_2F4B          
$2F48  17 FF 71                           LBSR Sub_2EBC          ; call Sub_2EBC
$2F4B  F6 0C 96            Sub_2F4B:      LDB $0C96             
$2F4E  8E 13 C3                           LDX #$13C3            
$2F51  10 8E 00 EC                        LDY #$00EC            
$2F55  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$2F59  5F                                 CLRB                   ; B = 0
$2F5A  35 B6               Sub_2F5A:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2F5C  53                  Sub_2F5C:      COMB                  
$2F5D  20 FB                              BRA Sub_2F5A          

; --------------------------------------------------------------
$2F5F  34 36               Sub_2F5F:      PSHS A,B,X,Y          
$2F61  8E 13 C3                           LDX #$13C3            
$2F64  C6 0E                              LDB #$0E              
$2F66  34 14               Sub_2F66:      PSHS B,X              
$2F68  31 8D D3 82                        LEAY Dat_02EE,PC       ; Y → Dat_02EE
$2F6C  C6 04                              LDB #$04              
$2F6E  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$2F71  35 14                              PULS B,X              
$2F73  24 07                              BCC Sub_2F7C           ; C=0 (BHS)
$2F75  30 01                              LEAX 1,X              
$2F77  5A                                 DECB                  
$2F78  26 EC                              BNE Sub_2F66          
$2F7A  20 00                              BRA Sub_2F7C          

; --------------------------------------------------------------
$2F7C  35 B6               Sub_2F7C:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$2F7E  34 76               Sub_2F7E:      PSHS A,B,X,Y,U        
$2F80  30 8D D0 7C                        LEAX ModHeader,PC     
$2F84  10 AE 02                           LDY 2,X               
$2F87  9F 24                              STX <$24              
$2F89  31 3D                              LEAY -3,Y             
$2F8B  10 9F 26                           STY <$26              
$2F8E  1F 13                              TFR X,U               
$2F90  1F 20                              TFR Y,D               
$2F92  33 CB                              LEAU D,U              
$2F94  CC FF FF                           LDD #$FFFF            
$2F97  ED C4                              STD ,U                
$2F99  A7 42                              STA 2,U               
$2F9B  10 3F 17                           OS9 F$CRC              ; buf→X  count=Y  seed=D  → CRC-24
$2F9E  63 C4                              COM ,U                
$2FA0  63 41                              COM 1,U               
$2FA2  63 42                              COM 2,U               
$2FA4  35 76                              PULS A,B,X,Y,U        
$2FA6  86 07                              LDA #$07              
$2FA8  30 8D D0 61                        LEAX ModName,PC        ; X → ModName
$2FAC  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$2FAF  25 0D                              BCS Sub_2FBE           ; C=1 (BLO)
$2FB1  9E 24                              LDX <$24              
$2FB3  10 9E 26                           LDY <$26              
$2FB6  31 23                              LEAY 3,Y              
$2FB8  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$2FBB  10 3F 8F                           OS9 I$Close            ; path=A
$2FBE  39                  Sub_2FBE:      RTS                    ; return from subroutine
$2FBF  34 36               Sub_2FBF:      PSHS A,B,X,Y          
$2FC1  30 8D DB 96                        LEAX Dat_0B5B,PC       ; X → Dat_0B5B
$2FC5  10 8E 0C BA                        LDY #$0CBA            
$2FC9  C6 4D                              LDB #$4D               ; B = 'M'
$2FCB  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$2FCF  CC 16 03                           LDD #$1603            
$2FD2  FD 0C 9C                           STD $0C9C             
$2FD5  CC 1D 04                           LDD #$1D04            
$2FD8  FD 0C 9A                           STD $0C9A             
$2FDB  17 EF 13                           LBSR Sub_1EF1          ; call Sub_1EF1
$2FDE  30 8D D4 D3                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$2FE2  17 ED B0                           LBSR Sub_1D95          ; call Sub_1D95
$2FE5  30 8D D9 CB                        LEAX Dat_09B4,PC       ; X → Dat_09B4
$2FE9  17 ED A9                           LBSR Sub_1D95          ; call Sub_1D95
$2FEC  8D 90                              BSR Sub_2F7E           ; call Sub_2F7E
$2FEE  30 8D D4 BF                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$2FF2  17 ED A0                           LBSR Sub_1D95          ; call Sub_1D95
$2FF5  17 EF 5B                           LBSR Sub_1F53          ; call Sub_1F53
$2FF8  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$2FFA  34 36               Sub_2FFA:      PSHS A,B,X,Y          
$2FFC  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$2FFD  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$2FFE  27 13                              BEQ Sub_3013          
$3000  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3001  7E 30 8D                           JMP $308D             
$3004  D3 8C                              ADDD <$8C             
$3006  10 8E 00 80                        LDY #$0080            
$300A  C6 0B                              LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
$300C  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$3010  17 E1 2F                           LBSR Sub_1142          ; call Sub_1142
$3013  17 16 14            Sub_3013:      LBSR Sub_462A          ; call Sub_462A
$3016  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3017  4D                                 TSTA                  
$3018  27 03                              BEQ Sub_301D          
$301A  17 F8 13                           LBSR Sub_2830          ; call Sub_2830
$301D  CC 00 00            Sub_301D:      LDD #$0000            
$3020  DD 0A                              STD <$0A              
$3022  8E 16 D3                           LDX #$16D3            
$3025  9F A0                              STX <$A0              
$3027  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3028  6F 17                              CLR -9,X              
$302A  F1 01 CC                           CMPB $01CC            
$302D  05                                 FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
$302E  03                                 FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
$302F  FD 0C 9A                           STD $0C9A             
$3032  CC 44 11                           LDD #$4411            
$3035  FD 0C 9C                           STD $0C9C             
$3038  17 EE B6                           LBSR Sub_1EF1          ; call Sub_1EF1
$303B  86 81                              LDA #$81              
$303D  30 8D DB 31                        LEAX Dat_0B72,PC       ; X → Dat_0B72
$3041  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$3044  10 25 00 7A                        LBCS Sub_30C2         
$3048  97 4A                              STA <$4A              
$304A  34 40                              PSHS U                
$304C  8E 00 00                           LDX #$0000            
$304F  CE 00 40                           LDU #$0040            
$3052  10 3F 88                           OS9 I$Seek             ; path=A  mode=B  offset→X:D
$3055  35 40                              PULS U                
$3057  25 69                              BCS Sub_30C2           ; C=1 (BLO)
$3059  96 4A               Sub_3059:      LDA <$4A              
$305B  10 8E 00 20                        LDY #$0020            
$305F  8E 13 C3                           LDX #$13C3            
$3062  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3065  24 06                              BCC Sub_306D           ; C=0 (BHS)
$3067  C1 D3                              CMPB #$D3             
$3069  26 57                              BNE Sub_30C2          
$306B  20 0F                              BRA Sub_307C          

; --------------------------------------------------------------
$306D  17 01 A6            Sub_306D:      LBSR Sub_3216          ; call Sub_3216
$3070  25 02                              BCS Sub_3074           ; C=1 (BLO)
$3072  8D 59                              BSR Sub_30CD           ; call Sub_30CD
$3074  96 6F               Sub_3074:      LDA <$6F              
$3076  81 1D                              CMPA #$1D             
$3078  22 02                              BHI Sub_307C          
$307A  20 DD                              BRA Sub_3059          

; --------------------------------------------------------------
$307C  96 6F               Sub_307C:      LDA <$6F              
$307E  B7 0C A2                           STA $0CA2             
$3081  96 4A                              LDA <$4A              
$3083  10 3F 8F                           OS9 I$Close            ; path=A
$3086  17 00 CA                           LBSR Sub_3153          ; call Sub_3153
$3089  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$308A  9F 27                              STX <$27              
$308C  16 17 ED                           LBRA $487C            

; --------------------------------------------------------------
$308D  17 ED BC            Sub_308D:      LBSR Sub_1E4C          ; call Sub_1E4C
$3090  CC 00 00                           LDD #$0000            
$3093  FD 13 3B                           STD $133B             
$3096  17 F0 94                           LBSR Sub_212D          ; call Sub_212D
$3099  30 8D D4 18                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$309D  17 EC F5                           LBSR Sub_1D95          ; call Sub_1D95
$30A0  17 01 A5                           LBSR Sub_3248          ; call Sub_3248
$30A3  17 EE AD                           LBSR Sub_1F53          ; call Sub_1F53
$30A6  17 ED BA                           LBSR Sub_1E63          ; call Sub_1E63
$30A9  17 EE 2B                           LBSR Sub_1ED7          ; call Sub_1ED7
$30AC  17 F0 7E                           LBSR Sub_212D          ; call Sub_212D
$30AF  30 8D D3 FE                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$30B3  17 EC DF                           LBSR Sub_1D95          ; call Sub_1D95
$30B6  35 36                              PULS A,B,X,Y          
$30B8  10 BE 0C 95                        LDY $0C95             
$30BC  8E 00 EC                           LDX #$00EC            
$30BF  16 E1 22                           LBRA $11E4            

; --------------------------------------------------------------
$30C2  10 3F 0F            Sub_30C2:      OS9 F$PErr             ; path=A  error=B
$30C5  8E 00 78                           LDX #$0078            
$30C8  17 E0 AD                           LBSR Sub_1178          ; call Sub_1178
$30CB  20 D6                              BRA $30A3             

; --------------------------------------------------------------
$30CD  34 36               Sub_30CD:      PSHS A,B,X,Y          
$30CF  8E 13 C3                           LDX #$13C3            
$30D2  10 9E A0                           LDY <$A0              
$30D5  C6 1E                              LDB #$1E              
$30D7  A6 80               Sub_30D7:      LDA ,X+               
$30D9  5A                                 DECB                  
$30DA  4D                                 TSTA                  
$30DB  2A 0B                              BPL Sub_30E8          
$30DD  80 80                              SUBA #$80             
$30DF  A7 A0                              STA ,Y+               
$30E1  CC 0A 0D                           LDD #$0A0D            
$30E4  ED A4                              STD ,Y                
$30E6  20 05                              BRA Sub_30ED          

; --------------------------------------------------------------
$30E8  A7 A0               Sub_30E8:      STA ,Y+               
$30EA  5D                                 TSTB                  
$30EB  26 EA               Insn_30EB:     BNE Sub_30D7          
$30ED  0C                  Sub_30ED:      EQU    $30ED            ; [*43] branch target 2 byte(s) inside Insn_30EB -- see [*43]
$30EE  6F 8D 3A 8D                        CLR +14989,PC         
$30F2  0B                                 FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
$30F3  10 9E A0                           LDY <$A0              
$30F6  31 A8 20                           LEAY 32,Y             
$30F9  10 9F A0                           STY <$A0              
$30FC  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$30FE  34 36               Sub_30FE:      PSHS A,B,X,Y          
$3100  9E A0                              LDX <$A0              
$3102  10 8E 13 C3                        LDY #$13C3            
$3106  C6 1E                              LDB #$1E              
$3108  A6 80               Sub_3108:      LDA ,X+               
$310A  5A                                 DECB                  
$310B  81 5F                              CMPA #$5F              ; compare A with '_'
$310D  26 02                              BNE Sub_3111          
$310F  86 20                              LDA #$20               ; A = ' '
$3111  81 2E               Sub_3111:      CMPA #$2E              ; compare A with '.'
$3113  26 03                              BNE Sub_3118          
$3115  86 0D                              LDA #$0D               ; A = CR
$3117  5F                                 CLRB                   ; B = 0
$3118  A7 A0               Sub_3118:      STA ,Y+               
$311A  5D                                 TSTB                  
$311B  26 EB                              BNE Sub_3108          
$311D  86 01                              LDA #$01              
$311F  10 8E 00 1E                        LDY #$001E            
$3123  8E 13 C3                           LDX #$13C3            
$3126  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$3129  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$312B  34 36               Sub_312B:      PSHS A,B,X,Y          
$312D  8E 13 C3                           LDX #$13C3            
$312E  13                  Sub_312E:      SYNC                   ; wait for interrupt
$312F  C3 D6 6F                           ADDD #$D66F           
$3132  C1 0F                              CMPB #$0F             
$3134  22 04                              BHI Sub_313A          
$3136  86 24                              LDA #$24               ; A = '$'
$3138  20 04                              BRA Sub_313E          

; --------------------------------------------------------------
$313A  86 45               Sub_313A:      LDA #$45               ; A = 'E'
$313C  C0 0F                              SUBB #$0F             
$313E  A7 01               Sub_313E:      STA 1,X               
$3140  86 02                              LDA #$02               ; A = CurXY
$3142  A7 84                              STA ,X                
$3144  CB 20                              ADDB #$20             
$3146  E7 02                              STB 2,X               
$3148  10 8E 00 03                        LDY #$0003            
$314C  86 01               Insn_314C:     LDA #$01              
$314D  01                  Sub_314D:      EQU    $314D            ; [*44] branch target 1 byte(s) inside Insn_314C -- see [*44]
$314E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3151  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3153  34 36               Sub_3153:      PSHS A,B,X,Y          
$3155  30 8D D3 5C                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$3159  17 EC 39                           LBSR Sub_1D95          ; call Sub_1D95
$315C  86 01                              LDA #$01              
$315E  97 9F                              STA <$9F              
$3160  8E 13 C3            Sub_3160:      LDX #$13C3            
$3163  B1 0C A2                           CMPA $0CA2            
$3166  23 05                              BLS Sub_316D          
$3168  B6 0C A2                           LDA $0CA2             
$316B  97 9F                              STA <$9F              
$316D  81 0F               Sub_316D:      CMPA #$0F             
$316F  22 04                              BHI Sub_3175          
$3171  8B 20                              ADDA #$20             
$3173  20 02                              BRA Sub_3177          

; --------------------------------------------------------------
$3175  8B 11               Sub_3175:      ADDA #$11             
$3177  A7 02               Sub_3177:      STA 2,X               
$3179  96 9F                              LDA <$9F              
$317B  81 0F                              CMPA #$0F             
$317D  22 04                              BHI Sub_3183          
$317F  86 21                              LDA #$21               ; A = '!'
$3181  20 02                              BRA Sub_3185          

; --------------------------------------------------------------
$3183  86 42               Sub_3183:      LDA #$42               ; A = 'B'
$3185  A7 01               Sub_3185:      STA 1,X               
$3187  86 02                              LDA #$02               ; A = CurXY
$3189  A7 84                              STA ,X                
$318B  17 00 77                           LBSR Sub_3205          ; call Sub_3205
$318E  86 01                              LDA #$01              
$3190  10 8E 00 03                        LDY #$0003            
$3194  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3197  30 8D D5 57                        LEAX Dat_06F2,PC       ; X → Dat_06F2
$319B  10 8E 00 03                        LDY #$0003            
$319F  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$31A2  17 FA BD            Sub_31A2:      LBSR Sub_2C62          ; call Sub_2C62
$31A5  81 08                              CMPA #$08              ; compare A with BS
$31A7  26 0E                              BNE Sub_31B7          
$31A9  96 9F               Sub_31A9:      LDA <$9F              
$31AB  81 0F                              CMPA #$0F             
$31AD  22 04                              BHI Sub_31B3          
$31AF  8B 0F                              ADDA #$0F             
$31B1  20 02                              BRA Sub_31B5          

; --------------------------------------------------------------
$31B3  80 0F               Sub_31B3:      SUBA #$0F             
$31B5  20 49               Sub_31B5:      BRA Sub_3200          
$31B7  81 09               Sub_31B7:      CMPA #$09             
$31B9  26 02                              BNE Sub_31BD          
$31BB  20 EC                              BRA Sub_31A9          

; --------------------------------------------------------------
$31BD  81 0C               Sub_31BD:      CMPA #$0C              ; compare A with FF
$31BF  26 13                              BNE Sub_31D4          
$31C1  96 9F                              LDA <$9F              
$31C3  81 01                              CMPA #$01             
$31C5  27 06                              BEQ Sub_31CD          
$31C7  80 01                              SUBA #$01             
$31C9  97 9F                              STA <$9F              
$31CB  20 33                              BRA Sub_3200          

; --------------------------------------------------------------
$31CD  B6 0C A2            Sub_31CD:      LDA $0CA2             
$31D0  97 9F                              STA <$9F              
$31D2  20 2C                              BRA Sub_3200          

; --------------------------------------------------------------
$31D4  81 0A               Sub_31D4:      CMPA #$0A              ; compare A with LF
$31D6  26 13                              BNE Sub_31EB          
$31D8  96 9F                              LDA <$9F              
$31DA  B1 0C A2                           CMPA $0CA2            
$31DD  27 06                              BEQ Sub_31E5          
$31DF  8B 01                              ADDA #$01             
$31E1  97 9F                              STA <$9F              
$31E3  20 1B                              BRA Sub_3200          

; --------------------------------------------------------------
$31E5  86 01               Sub_31E5:      LDA #$01              
$31E7  97 9F                              STA <$9F              
$31E9  20 15                              BRA Sub_3200          

; --------------------------------------------------------------
$31EB  81 0D               Sub_31EB:      CMPA #$0D              ; compare A with CR
$31ED  26 09                              BNE Sub_31F8          
$31EF  30 8D D2 BE                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$31F3  17 EB 9F                           LBSR Sub_1D95          ; call Sub_1D95
$31F6  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$31F8  81 05               Sub_31F8:      CMPA #$05             
$31FA  26 A6                              BNE Sub_31A2          
$31FC  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$31FD  9F 20                              STX <$20              
$31FF  EF 97                              STU [E,X]             
$3200  97 9F               Sub_3200:      STA <$9F              
$3202  16 FF 5B                           LBRA Sub_3160         

; --------------------------------------------------------------
$3205  34 32               Sub_3205:      PSHS A,X,Y            
$3207  86 01                              LDA #$01              
$3209  30 8D D4 D4                        LEAX Dat_06E1,PC       ; X → Dat_06E1
$320D  10 8E 00 06                        LDY #$0006            
$3211  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3214  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3216  34 36               Sub_3216:      PSHS A,B,X,Y          
$3218  8E 13 C3                           LDX #$13C3            
$321B  A6 84                              LDA ,X                
$321D  27 26                              BEQ Sub_3245          
$321F  C6 1B                              LDB #$1B               ; B = ESC
$3221  A6 80               Sub_3221:      LDA ,X+               
$3223  5A                                 DECB                  
$3224  81 2E                              CMPA #$2E              ; compare A with '.'
$3226  27 05                              BEQ Sub_322D          
$3228  5D                  Sub_3228:      TSTB                  
$3229  26 F6                              BNE Sub_3221          
$322B  20 18                              BRA Sub_3245          

; --------------------------------------------------------------
$322D  A6 80               Sub_322D:      LDA ,X+               
$322F  5A                                 DECB                  
$3230  81 61                              CMPA #$61              ; compare A with 'a'
$3232  26 F4                              BNE Sub_3228          
$3234  A6 80                              LDA ,X+               
$3236  5A                                 DECB                  
$3237  81 64                              CMPA #$64              ; compare A with 'd'
$3239  26 ED                              BNE Sub_3228          
$323B  A6 80                              LDA ,X+               
$323D  5A                                 DECB                  
$323E  81 E6                              CMPA #$E6             
$3240  26 E6                              BNE Sub_3228          
$3242  5F                                 CLRB                   ; B = 0
$3243  35 B6               Sub_3243:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$3245  53                  Sub_3245:      COMB                  
$3246  20 FB                              BRA Sub_3243          

; --------------------------------------------------------------
$3248  34 36               Sub_3248:      PSHS A,B,X,Y          
$324A  96 9F                              LDA <$9F              
$324C  4A                                 DECA                  
$324D  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$324F  3D                                 MUL                    ; D = A×B unsigned
$3250  8E 16 D3                           LDX #$16D3            
$3253  30 8B                              LEAX D,X              
$3255  9F A0                              STX <$A0              
$3257  34 10                              PSHS X                
$3259  8E 13 C3                           LDX #$13C3            
$325C  31 8D D9 12                        LEAY Dat_0B72,PC       ; Y → Dat_0B72
$3260  A6 A0               Sub_3260:      LDA ,Y+               
$3262  2B 04                              BMI Sub_3268          
$3264  A7 80                              STA ,X+               
$3266  20 F8                              BRA Sub_3260          

; --------------------------------------------------------------
$3268  80 80               Sub_3268:      SUBA #$80             
$326A  C6 2F                              LDB #$2F               ; B = '/'
$326C  ED 81                              STD ,X++              
$326E  1F 12                              TFR X,Y               
$3270  35 10                              PULS X                
$3272  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$3274  A6 80               Sub_3274:      LDA ,X+               
$3276  2B 07                              BMI Sub_327F          
$3278  A7 A0                              STA ,Y+               
$327A  5A                                 DECB                  
$327B  26 F7                              BNE Sub_3274          
$327D  20 02                              BRA Sub_3281          

; --------------------------------------------------------------
$327F  A7 A0               Sub_327F:      STA ,Y+               
$3281  8E 13 C3            Sub_3281:      LDX #$13C3            
$3284  86 01                              LDA #$01              
$3286  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$3289  25 34                              BCS Sub_32BF           ; C=1 (BLO)
$328B  97 4A                              STA <$4A              
$328D  17 F4 75                           LBSR Sub_2705          ; call Sub_2705
$3290  86 01                              LDA #$01              
$3292  B7 0D 38                           STA $0D38             
$3295  86 1E                              LDA #$1E              
$3297  B7 0D 39                           STA $0D39             
$329A  96 4A               Sub_329A:      LDA <$4A              
$329C  8E 13 C3                           LDX #$13C3            
$329F  10 8E 00 50                        LDY #$0050            
$32A3  10 3F 8B                           OS9 I$ReadLn           ; path=A  max=Y  buf→X
$32A6  24 06                              BCC Sub_32AE           ; C=0 (BHS)
$32A8  C1 D3                              CMPB #$D3             
$32AA  26 13                              BNE Sub_32BF          
$32AC  20 04                              BRA Sub_32B2          

; --------------------------------------------------------------
$32AE  8D 14               Sub_32AE:      BSR Sub_32C4           ; call Sub_32C4
$32B0  20 E8                              BRA Sub_329A          

; --------------------------------------------------------------
$32B2  96 4A               Sub_32B2:      LDA <$4A              
$32B4  10 3F 8F                           OS9 I$Close            ; path=A
$32B7  17 E0 DC                           LBSR Sub_1396          ; call Sub_1396
$32BA  16 01 F9                           LBRA Sub_34B6         

; --------------------------------------------------------------
$32BD  35 B6               Sub_32BD:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$32BF  10 3F 0F            Sub_32BF:      OS9 F$PErr             ; path=A  error=B
$32C2  20 F9                              BRA Sub_32BD          

; --------------------------------------------------------------
$32C4  34 36               Sub_32C4:      PSHS A,B,X,Y          
$32C6  4F                                 CLRA                   ; A = 0
$32C7  31 8D D4 65                        LEAY Dat_0730,PC       ; Y → Dat_0730
$32CB  8E 13 C3            Sub_32CB:      LDX #$13C3            
$32CE  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$32D0  4C                                 INCA                  
$32D1  10 3F 11                           OS9 F$CmpNam           ; name→X  len=Y  name2→D
$32D4  31 23                              LEAY 3,Y              
$32D6  24 04                              BCC Sub_32DC           ; C=0 (BHS)
$32D8  81 20                              CMPA #$20              ; compare A with ' '
$32DA  25 EF                              BCS Sub_32CB           ; C=1 (BLO)
$32DC  81 1F               Sub_32DC:      CMPA #$1F             
$32DE  22 7E                              BHI Sub_335E          
$32E0  30 03                              LEAX 3,X              
$32E2  E6 80                              LDB ,X+               
$32E4  C1 3D                              CMPB #$3D              ; compare B with '='
$32E6  26 76                              BNE Sub_335E          
$32E8  81 01                              CMPA #$01             
$32EA  27 74                              BEQ Sub_3360          
$32EC  81 02                              CMPA #$02              ; compare A with CurXY
$32EE  10 27 00 87                        LBEQ Sub_3379         
$32F2  81 03                              CMPA #$03             
$32F4  10 27 00 96                        LBEQ Sub_338E         
$32F8  81 04                              CMPA #$04             
$32FA  10 27 00 9D                        LBEQ Sub_339B         
$32FE  81 05                              CMPA #$05             
$3300  10 27 00 A4                        LBEQ Sub_33A8         
$3304  81 06                              CMPA #$06             
$3306  10 27 00 AC                        LBEQ Sub_33B6         
$330A  81 07                              CMPA #$07             
$330C  10 27 00 B6                        LBEQ Sub_33C6         
$3310  81 08                              CMPA #$08              ; compare A with BS
$3312  10 27 00 B8                        LBEQ Sub_33CE         
$3316  81 09                              CMPA #$09             
$3318  10 27 00 BB                        LBEQ Sub_33D7         
$331C  81 0A                              CMPA #$0A              ; compare A with LF
$331E  10 27 00 BE                        LBEQ Sub_33E0         
$3322  81 0B                              CMPA #$0B             
$3324  10 27 00 C1                        LBEQ Sub_33E9         
$3328  81 0C                              CMPA #$0C              ; compare A with FF
$332A  10 27 00 C4                        LBEQ Sub_33F2         
$332E  81 0D                              CMPA #$0D              ; compare A with CR
$3330  10 27 00 CC                        LBEQ Sub_3400         
$3334  81 0E                              CMPA #$0E             
$3336  10 27 00 DA                        LBEQ Sub_3414         
$333A  81 16                              CMPA #$16             
$333C  10 23 00 F0                        LBLS Sub_3430         
$3340  81 17                              CMPA #$17             
$3342  10 27 01 10                        LBEQ Sub_3456         
$3346  81 1B                              CMPA #$1B              ; compare A with ESC
$3348  10 23 F3 EF                        LBLS Sub_273B         
$334C  81 1F                              CMPA #$1F             
$334E  10 23 F3 C4                        LBLS Sub_2716         
$3352  81 20                              CMPA #$20              ; compare A with ' '
$3354  10 27 01 12                        LBEQ Sub_346A         
$3358  81 21                              CMPA #$21              ; compare A with '!'
$335A  10 27 01 1A                        LBEQ Sub_3478         
$335E  35 B6               Sub_335E:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$3360  10 8E 0D 11         Sub_3360:      LDY #$0D11            
$3364  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$3366  A6 80               Sub_3366:      LDA ,X+               
$3368  81 0D                              CMPA #$0D              ; compare A with CR
$336A  27 07                              BEQ Sub_3373          
$336C  A7 A0                              STA ,Y+               
$336E  5A                                 DECB                  
$336F  26 F5                              BNE Sub_3366          
$3371  20 04                              BRA Sub_3377          

; --------------------------------------------------------------
$3373  A7 A0               Sub_3373:      STA ,Y+               
$3375  6F A0                              CLR ,Y+               
$3377  20 E5               Sub_3377:      BRA Sub_335E          
$3379  17 01 0A            Sub_3379:      LBSR Sub_3486          ; call Sub_3486
$337C  C4 0F                              ANDB #$0F             
$337E  B6 0C BA                           LDA $0CBA             
$3381  84 F0                              ANDA #$F0             
$3383  B7 0C BA                           STA $0CBA             
$3386  FA 0C BA                           ORB $0CBA             
$3389  F7 0C BA                           STB $0CBA             
$338C  20 D0                              BRA Sub_335E          

; --------------------------------------------------------------
$338E  17 00 F5            Sub_338E:      LBSR Sub_3486          ; call Sub_3486
$3391  5D                                 TSTB                  
$3392  27 02                              BEQ Sub_3396          
$3394  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3396  F7 0C BC            Sub_3396:      STB $0CBC             
$3399  20 C3                              BRA Sub_335E          

; --------------------------------------------------------------
$339B  17 00 E8            Sub_339B:      LBSR Sub_3486          ; call Sub_3486
$339E  5D                                 TSTB                  
$339F  27 02                              BEQ Sub_33A3          
$33A1  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$33A3  F7 0C C6            Sub_33A3:      STB $0CC6             
$33A6  20 B6                              BRA Sub_335E          

; --------------------------------------------------------------
$33A8  17 00 DB            Sub_33A8:      LBSR Sub_3486          ; call Sub_3486
$33AB  C1 03                              CMPB #$03             
$33AD  25 02                              BCS Sub_33B1           ; C=1 (BLO)
$33AF  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$33B1  F7 0C BB            Sub_33B1:      STB $0CBB             
$33B4  20 A8                              BRA Sub_335E          

; --------------------------------------------------------------
$33B6  17 00 CD            Sub_33B6:      LBSR Sub_3486          ; call Sub_3486
$33B9  5D                                 TSTB                  
$33BA  27 02                              BEQ Sub_33BE          
$33BC  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$33BE  F7 0C BD            Sub_33BE:      STB $0CBD             
$33C1  F7 0C BE                           STB $0CBE             
$33C4  20 98                              BRA Sub_335E          

; --------------------------------------------------------------
$33C6  17 00 BD            Sub_33C6:      LBSR Sub_3486          ; call Sub_3486
$33C9  F7 0C C4                           STB $0CC4             
$33CC  20 90                              BRA Sub_335E          

; --------------------------------------------------------------
$33CE  17 00 B5            Sub_33CE:      LBSR Sub_3486          ; call Sub_3486
$33D1  F7 0C C5                           STB $0CC5             
$33D4  16 FF 87                           LBRA Sub_335E         

; --------------------------------------------------------------
$33D7  17 00 AC            Sub_33D7:      LBSR Sub_3486          ; call Sub_3486
$33DA  F7 0D 38                           STB $0D38             
$33DD  16 FF 7E                           LBRA Sub_335E         

; --------------------------------------------------------------
$33E0  17 00 A3            Sub_33E0:      LBSR Sub_3486          ; call Sub_3486
$33E3  F7 0D 39                           STB $0D39             
$33E6  16 FF 75                           LBRA Sub_335E         

; --------------------------------------------------------------
$33E9  17 00 9A            Sub_33E9:      LBSR Sub_3486          ; call Sub_3486
$33EC  F7 0C C1                           STB $0CC1             
$33EF  16 FF 6C                           LBRA Sub_335E         

; --------------------------------------------------------------
$33F2  17 00 91            Sub_33F2:      LBSR Sub_3486          ; call Sub_3486
$33F5  5D                                 TSTB                  
$33F6  27 02                              BEQ Sub_33FA          
$33F8  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$33FA  F7 0C BF            Sub_33FA:      STB $0CBF             
$33FD  16 FF 5E                           LBRA Sub_335E         

; --------------------------------------------------------------
$3400  17 00 83            Sub_3400:      LBSR Sub_3486          ; call Sub_3486
$3403  B6 0C BA                           LDA $0CBA             
$3406  84 4F                              ANDA #$4F             
$3408  B7 0C BA                           STA $0CBA             
$340B  FA 0C BA                           ORB $0CBA             
$340E  F7 0C BA                           STB $0CBA             
$3411  16 FF 4A                           LBRA Sub_335E         

; --------------------------------------------------------------
$3414  8D 70               Sub_3414:      BSR Sub_3486           ; call Sub_3486
$3416  5D                                 TSTB                  
$3417  27 07                              BEQ Sub_3420          
$3419  C1 80                              CMPB #$80             
$341B  27 03                              BEQ Sub_3420          
$341D  16 FF 3E            Sub_341D:      LBRA Sub_335E         
$3420  B6 0C BA            Sub_3420:      LDA $0CBA             
$3423  84 7F                              ANDA #$7F             
$3425  B7 0C BA                           STA $0CBA             
$3428  FA 0C BA                           ORB $0CBA             
$342B  F7 0C BA                           STB $0CBA             
$342E  20 ED                              BRA Sub_341D          

; --------------------------------------------------------------
$3430  A6 1E               Sub_3430:      LDA -2,X              
$3432  80 31                              SUBA #$31             
$3434  81 07                              CMPA #$07             
$3436  22 1B                              BHI Sub_3453          
$3438  C6 80                              LDB #$80              
$343A  3D                                 MUL                    ; D = A×B unsigned
$343B  10 8E 0D 3B                        LDY #$0D3B            
$343F  31 AB                              LEAY D,Y              
$3441  C6 80                              LDB #$80              
$3443  A6 80               Sub_3443:      LDA ,X+               
$3445  81 0D                              CMPA #$0D              ; compare A with CR
$3447  27 07                              BEQ Sub_3450          
$3449  A7 A0                              STA ,Y+               
$344B  5A                                 DECB                  
$344C  26 F5                              BNE Sub_3443          
$344E  20 03                              BRA Sub_3453          

; --------------------------------------------------------------
$3450  5F                  Sub_3450:      CLRB                   ; B = 0
$3451  ED A4                              STD ,Y                
$3453  16 FF 08            Sub_3453:      LBRA Sub_335E         
$3456  10 8E 13 3B         Sub_3456:      LDY #$133B            
$345A  C6 80                              LDB #$80              
$345C  A6 80               Sub_345C:      LDA ,X+               
$345E  81 0D                              CMPA #$0D              ; compare A with CR
$3460  27 EE                              BEQ Sub_3450          
$3462  A7 A0                              STA ,Y+               
$3464  5A                                 DECB                  
$3465  26 F5                              BNE Sub_345C          
$3467  16 FE F4                           LBRA Sub_335E         

; --------------------------------------------------------------
$346A  17 00 19            Sub_346A:      LBSR Sub_3486          ; call Sub_3486
$346D  5D                                 TSTB                  
$346E  27 02                              BEQ Sub_3472          
$3470  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3472  F7 0C BE            Sub_3472:      STB $0CBE             
$3475  16 FE E6                           LBRA Sub_335E         

; --------------------------------------------------------------
$3478  17 00 0B            Sub_3478:      LBSR Sub_3486          ; call Sub_3486
$347B  5D                                 TSTB                  
$347C  27 02                              BEQ Sub_3480          
$347E  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3480  F7 0C BD            Sub_3480:      STB $0CBD             
$3483  16 FE D8                           LBRA Sub_335E         

; --------------------------------------------------------------
$3486  A6 01               Sub_3486:      LDA 1,X               
$3488  81 21                              CMPA #$21              ; compare A with '!'
$348A  25 1C                              BCS Sub_34A8           ; C=1 (BLO)
$348C  A6 84                              LDA ,X                
$348E  80 30                              SUBA #$30             
$3490  81 0A                              CMPA #$0A              ; compare A with LF
$3492  25 02                              BCS Sub_3496           ; C=1 (BLO)
$3494  80 07                              SUBA #$07             
$3496  C6 10               Sub_3496:      LDB #$10              
$3498  3D                                 MUL                    ; D = A×B unsigned
$3499  A6 01                              LDA 1,X               
$349B  80 30                              SUBA #$30             
$349D  81 0A                              CMPA #$0A              ; compare A with LF
$349F  25 02                              BCS Sub_34A3           ; C=1 (BLO)
$34A1  80 07                              SUBA #$07             
$34A3  A7 01               Sub_34A3:      STA 1,X               
$34A5  EB 01                              ADDB 1,X              
$34A7  39                  Sub_34A7:      RTS                    ; return from subroutine
$34A8  A6 84               Sub_34A8:      LDA ,X                
$34AA  80 30                              SUBA #$30             
$34AC  81 0A                              CMPA #$0A              ; compare A with LF
$34AE  25 02                              BCS Sub_34B2           ; C=1 (BLO)
$34B0  80 07                              SUBA #$07             
$34B2  1F 89               Sub_34B2:      TFR A,B               
$34B4  20 F1                              BRA Sub_34A7          

; --------------------------------------------------------------
$34B6  7D 0D 38            Sub_34B6:      TST $0D38             
$34B9  26 09                              BNE Sub_34C4          
$34BB  7F 13 3B                           CLR $133B             
$34BE  7F 0C 8F                           CLR $0C8F             
$34C1  16 01 30                           LBRA Sub_35F4         

; --------------------------------------------------------------
$34C4  17 EA 8C            Sub_34C4:      LBSR Sub_1F53          ; call Sub_1F53
$34C7  CC 14 03                           LDD #$1403            
$34CA  FD 0C 9A                           STD $0C9A             
$34CD  CC 28 08                           LDD #$2808            
$34D0  FD 0C 9C                           STD $0C9C             
$34D3  17 EA 1B                           LBSR Sub_1EF1          ; call Sub_1EF1
$34D6  30 8D CF FD                        LEAX Dat_04D7,PC       ; X → Dat_04D7
$34DA  17 E8 B8                           LBSR Sub_1D95          ; call Sub_1D95
$34DD  17 F1 3E                           LBSR Sub_261E          ; call Sub_261E
$34E0  30 8D D0 1D                        LEAX Dat_0501,PC       ; X → Dat_0501
$34E4  17 E8 AE                           LBSR Sub_1D95          ; call Sub_1D95
$34E7  17 FC 14                           LBSR Sub_30FE          ; call Sub_30FE
$34EA  30 8D D0 1D                        LEAX Dat_050B,PC       ; X → Dat_050B
$34EE  17 E8 A4                           LBSR Sub_1D95          ; call Sub_1D95
$34F1  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$34F3  F7 13 BE                           STB $13BE             
$34F6  17 01 11                           LBSR Sub_360A          ; call Sub_360A
$34F9  8E 0D 11                           LDX #$0D11            
$34FC  5F                                 CLRB                   ; B = 0
$34FD  A6 80               Sub_34FD:      LDA ,X+               
$34FF  5C                                 INCB                  
$3500  C1 20                              CMPB #$20              ; compare B with ' '
$3502  22 03                              BHI Sub_3507          
$3504  4D                                 TSTA                  
$3505  26 F6                              BNE Sub_34FD          
$3507  5A                  Sub_3507:      DECB                  
$3508  26 09                              BNE Sub_3513          
$350A  7F 13 3B                           CLR $133B             
$350D  7F 0C 8F                           CLR $0C8F             
$3510  16 00 E1                           LBRA Sub_35F4         

; --------------------------------------------------------------
$3513  4F                  Sub_3513:      CLRA                   ; A = 0
$3514  1F 02                              TFR D,Y               
$3516  10 BF 0C AB                        STY $0CAB             
$351A  30 8D CD D4         Sub_351A:      LEAX Dat_02F2,PC       ; X → Dat_02F2
$351E  10 8E 00 04                        LDY #$0004            
$3522  96 38                              LDA <$38              
$3524  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3527  17 F9 66                           LBSR Sub_2E90          ; call Sub_2E90
$352A  8E 00 5A                           LDX #$005A            
$352D  17 DC 48                           LBSR Sub_1178          ; call Sub_1178
$3530  96 38                              LDA <$38              
$3532  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3534  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3537  24 09                              BCC Sub_3542           ; C=0 (BHS)
$3539  17 F9 35                           LBSR Sub_2E71          ; call Sub_2E71
$353C  25 04                              BCS Sub_3542           ; C=1 (BLO)
$353E  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$353F  31 20                              LEAY 0,Y              
$3541  04                                 FCB    $04                ; undefined opcode $04 -- not a valid 6809 instruction
$3542  86 01               Sub_3542:      LDA #$01              
$3544  97 31                              STA <$31              
$3546  17 F9 47                           LBSR Sub_2E90          ; call Sub_2E90
$3549  10 BE 0C AB                        LDY $0CAB             
$354D  8E 0D 11                           LDX #$0D11            
$3550  96 38                              LDA <$38              
$3552  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3555  17 F9 38                           LBSR Sub_2E90          ; call Sub_2E90
$3558  C6 FF                              LDB #$FF              
$355A  F7 0C AE                           STB $0CAE             
$355D  17 E8 7E            Sub_355D:      LBSR Sub_1DDE          ; call Sub_1DDE
$3560  B7 0C AD            Insn_3560:     STA $0CAD             
$3563  0D                  Sub_3563:      EQU    $3563            ; [*45] branch target 3 byte(s) inside Insn_3560 -- see [*45]
$3564  31 27                              LEAY 7,Y              
$3566  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$3567  17 F9 AC                           LBSR Sub_2F16          ; call Sub_2F16
$356A  24 62                              BCC Sub_35CE           ; C=0 (BHS)
$356C  17 F9 F0                           LBSR Sub_2F5F          ; call Sub_2F5F
$356F  25 07                              BCS Sub_3578           ; C=1 (BLO)
$3571  20 34                              BRA Sub_35A7          

; --------------------------------------------------------------
$3573  17 F8 FB            Sub_3573:      LBSR Sub_2E71          ; call Sub_2E71
$3576  25 56                              BCS Sub_35CE           ; C=1 (BLO)
$3578  86 00               Sub_3578:      LDA #$00               ; A = NUL
$357A  C6 27                              LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
$357C  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$357F  81 80                              CMPA #$80             
$3581  26 08                              BNE Sub_358B          
$3583  7F 13 3B                           CLR $133B             
$3586  7F 0C 8F                           CLR $0C8F             
$3589  20 69                              BRA Sub_35F4          

; --------------------------------------------------------------
$358B  17 E8 50            Sub_358B:      LBSR Sub_1DDE          ; call Sub_1DDE
$358E  B1 0C AD                           CMPA $0CAD            
$3591  27 D0                              BEQ Sub_3563          
$3593  7C 0C AE                           INC $0CAE             
$3596  30 8D CF 76                        LEAX Dat_0510,PC       ; X → Dat_0510
$359A  17 E7 F8                           LBSR Sub_1D95          ; call Sub_1D95
$359D  F6 0C AE                           LDB $0CAE             
$35A0  8D 68                              BSR Sub_360A           ; call Sub_360A
$35A2  F1 0D 39                           CMPB $0D39            
$35A5  25 B6                              BCS Sub_355D           ; C=1 (BLO)
$35A7  7C 13 BE            Sub_35A7:      INC $13BE             
$35AA  30 8D CF 5D                        LEAX Dat_050B,PC       ; X → Dat_050B
$35AE  17 E7 E4                           LBSR Sub_1D95          ; call Sub_1D95
$35B1  F6 13 BE                           LDB $13BE             
$35B4  8D 54                              BSR Sub_360A           ; call Sub_360A
$35B6  F6 0D 38                           LDB $0D38             
$35B9  C1 FF                              CMPB #$FF             
$35BB  10 27 FF 5B                        LBEQ Sub_351A         
$35BF  F6 13 BE                           LDB $13BE             
$35C2  F1 0D 38                           CMPB $0D38            
$35C5  10 25 FF 51                        LBCS Sub_351A         
$35C9  7F 13 3B                           CLR $133B             
$35CC  20 26                              BRA Sub_35F4          

; --------------------------------------------------------------
$35CE  86 01               Sub_35CE:      LDA #$01              
$35D0  C6 98                              LDB #$98              
$35D2  8E 3F 06                           LDX #$3F06            
$35D5  10 8E 0D 00                        LDY #$0D00            
$35D9  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$35DC  10 8E 0E 00                        LDY #$0E00            
$35E0  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$35E3  10 8E 0F 00                        LDY #$0F00            
$35E7  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$35EA  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$35EB  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$35EC  27 06                              BEQ Sub_35F4          
$35EE  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$35EF  7E 96 7C                           JMP $967C             
$35F2  97 7D                              STA <$7D              
$35F4  17 E8 3C            Sub_35F4:      LBSR Sub_1E33          ; call Sub_1E33
$35F7  96 4A                              LDA <$4A              
$35F9  10 3F 8F                           OS9 I$Close            ; path=A
$35FC  7D 13 3B                           TST $133B             
$35FF  27 03                              BEQ Sub_3604          
$3601  17 E6 66                           LBSR Sub_1C6A          ; call Sub_1C6A
$3604  17 DE 9E            Sub_3604:      LBSR Sub_14A5          ; call Sub_14A5
$3607  16 FC B3                           LBRA Sub_32BD         

; --------------------------------------------------------------
$360A  34 16               Sub_360A:      PSHS A,B,X            
$360C  8E 13 C3                           LDX #$13C3            
$360F  4F                                 CLRA                   ; A = 0
$3610  C1 64               Sub_3610:      CMPB #$64              ; compare B with 'd'
$3612  25 05                              BCS Sub_3619           ; C=1 (BLO)
$3614  C0 64                              SUBB #$64             
$3616  4C                                 INCA                  
$3617  20 F7                              BRA Sub_3610          

; --------------------------------------------------------------
$3619  8B 30               Sub_3619:      ADDA #$30             
$361B  A7 80                              STA ,X+               
$361D  4F                                 CLRA                   ; A = 0
$361E  C1 0A               Sub_361E:      CMPB #$0A              ; compare B with LF
$3620  25 05                              BCS Sub_3627           ; C=1 (BLO)
$3622  C0 0A                              SUBB #$0A             
$3624  4C                                 INCA                  
$3625  20 F7                              BRA Sub_361E          

; --------------------------------------------------------------
$3627  8B 30               Sub_3627:      ADDA #$30             
$3629  A7 80                              STA ,X+               
$362B  CB 30                              ADDB #$30             
$362D  E7 80                              STB ,X+               
$362F  8E 13 C3                           LDX #$13C3            
$3632  10 8E 00 03                        LDY #$0003            
$3636  86 01                              LDA #$01              
$3638  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$363B  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$363D  30 8D CE 74         Sub_363D:      LEAX Dat_04B5,PC       ; X → Dat_04B5
$3641  7C 0C AA                           INC $0CAA             
$3644  17 E7 4E                           LBSR Sub_1D95          ; call Sub_1D95
$3647  CC 1C 05                           LDD #$1C05            
$364A  FD 0C 9A                           STD $0C9A             
$364D  CC 19 07                           LDD #$1907            
$364E  19                  Sub_364E:      DAA                   
$364F  07                                 FCB    $07                ; undefined opcode $07 -- not a valid 6809 instruction
$3650  FD 0C 9C                           STD $0C9C             
$3653  17 E8 9B                           LBSR Sub_1EF1          ; call Sub_1EF1
$3656  30 8D D1 39                        LEAX Dat_0793,PC       ; X → Dat_0793
$365A  17 E7 38                           LBSR Sub_1D95          ; call Sub_1D95
$365D  86 04                              LDA #$04              
$365F  B7 13 BD                           STA $13BD             
$3662  D6 56                              LDB <$56              
$3664  17 E9 B8                           LBSR Sub_201F          ; call Sub_201F
$3667  17 E8 E9                           LBSR Sub_1F53          ; call Sub_1F53
$366A  30 8D CE 43                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$366E  17 E7 24                           LBSR Sub_1D95          ; call Sub_1D95
$3671  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3672  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3673  F6 0C 91                           LDB $0C91             
$3676  27 12                              BEQ Sub_368A          
$3678  C1 03                              CMPB #$03             
$367A  22 13                              BHI Sub_368F          
$367C  D7 56                              STB <$56              
$367E  C1 02                              CMPB #$02              ; compare B with CurXY
$3680  10 22 E3 5B                        LBHI Sub_19DF         
$3684  25 69                              BCS Sub_36EF           ; C=1 (BLO)
$3686  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$3687  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3688  20 65                              BRA Sub_36EF          

; --------------------------------------------------------------
$368A  D7 56               Sub_368A:      STB <$56              
$368C  16 0A F0                           LBRA Sub_417F         

; --------------------------------------------------------------
$368F  16 D7 98            Sub_368F:      LBRA Sub_0E2A         
$3692  30 8D CE 1F         Sub_3692:      LEAX Dat_04B5,PC       ; X → Dat_04B5
$3696  7F 0C AA                           CLR $0CAA             
$3699  17 E6 F9                           LBSR Sub_1D95          ; call Sub_1D95
$369C  CC 1C 05                           LDD #$1C05            
$369F  FD 0C 9A                           STD $0C9A             
$36A2  CC 19 08                           LDD #$1908            
$36A5  FD 0C 9C                           STD $0C9C             
$36A8  17 E8 46                           LBSR Sub_1EF1          ; call Sub_1EF1
$36AB  30 8D D1 55                        LEAX Dat_0804,PC       ; X → Dat_0804
$36AF  17 E6 E3                           LBSR Sub_1D95          ; call Sub_1D95
$36B2  86 05                              LDA #$05              
$36B4  B7 13 BD                           STA $13BD             
$36B7  D6 55                              LDB <$55              
$36B9  17 E9 63                           LBSR Sub_201F          ; call Sub_201F
$36BC  17 E8 94                           LBSR Sub_1F53          ; call Sub_1F53
$36BF  30 8D CD EE                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$36C3  17 E6 CF                           LBSR Sub_1D95          ; call Sub_1D95
$36C6  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$36C7  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$36C8  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$36C9  51                                 FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
$36CA  F6 0C 91                           LDB $0C91             
$36CD  27 18                              BEQ Sub_36E7          
$36CF  C1 04                              CMPB #$04             
$36D1  22 BC                              BHI Sub_368F          
$36D3  D7 55                              STB <$55              
$36D5  C1 02                              CMPB #$02              ; compare B with CurXY
$36D7  25 16                              BCS Sub_36EF           ; C=1 (BLO)
$36D9  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$36DA  51                                 FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
$36DB  C1 03                              CMPB #$03             
$36DD  25 10                              BCS Sub_36EF           ; C=1 (BLO)
$36DF  10 22 E3 D7                        LBHI Sub_1ABA         
$36E3  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$36E4  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$36E5  20 08                              BRA Sub_36EF          

; --------------------------------------------------------------
$36E7  D7 55               Sub_36E7:      STB <$55              
$36E9  16 0A 93                           LBRA Sub_417F         

; --------------------------------------------------------------
$36EC  16 D7 3B            Sub_36EC:      LBRA Sub_0E2A         
$36EF  34 36               Sub_36EF:      PSHS A,B,X,Y          
$36F1  B6 0C C5                           LDA $0CC5             
$36F4  F6 0C C4                           LDB $0CC4             
$36F7  34 06                              PSHS A,B              
$36F9  4F                                 CLRA                   ; A = 0
$36FA  B7 0C C4                           STA $0CC4             
$36FD  B7 0C C5                           STA $0CC5             
$3700  16 00 79                           LBRA Sub_377C         

; --------------------------------------------------------------
$3703  86 FF               Sub_3703:      LDA #$FF              
$3705  97 4F                              STA <$4F              
$3707  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3708  74 0F 6A                           LSR $0F6A             
$370B  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$370C  57                                 ASRB                  
$370D  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$370E  75                                 FCB    $75                ; undefined opcode $75 -- not a valid 6809 instruction
$370F  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3710  6D 0F                              TST 15,X              
$3712  5D                                 TSTB                  
$3713  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3714  A8 8E 13                           EORA [+19,PC]         
$3717  C3 96 38                           ADDD #$9638           
$371A  C6 00                              LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
$371C  34 06                              PSHS A,B              
$371E  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3721  8E 13 C3                           LDX #$13C3            
$3724  A6 88 15                           LDA 21,X              
$3727  84 0F                              ANDA #$0F             
$3729  A7 88 15                           STA 21,X              
$372C  A6 88 14                           LDA 20,X              
$372F  84 03                              ANDA #$03             
$3731  A7 88 14                           STA 20,X              
$3734  4F                                 CLRA                   ; A = 0
$3735  5F                                 CLRB                   ; B = 0
$3736  ED 88 18                           STD 24,X              
$3739  ED 04                              STD 4,X               
$373B  35 06                              PULS A,B              
$373D  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$3740  17 0E E7            Insn_3740:     LBSR Sub_462A          ; call Sub_462A
$3741  0E                  Sub_3741:      EQU    $3741            ; [*46] branch target 1 byte(s) inside Insn_3740 -- see [*46]
$3742  E7 CC 00            Insn_3742:     STB Dat_3745,PC       

Dat_3745
; ── 10 bytes  ($3745—$374E) ──
         FCB    $00               ; NUL
         FCB    $DD
         FCB    $0A               ; LF
         FCB    $CC
         FCB    $15               ; NAK erase-EOS
         FCB    $04               ; EOT
         FCB    $FD
         FCB    $0C               ; FF clear+home
         FCB    $9A
         FCB    $CC
$374F  25 09               Sub_374F:      BCS Sub_375A           ; C=1 (BLO)
$3751  FD 0C 9C                           STD $0C9C             
$3754  17 E7 9A                           LBSR Sub_1EF1          ; call Sub_1EF1
$3757  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$3758  34 36               Sub_3758:      PSHS A,B,X,Y          
$375A  17 04 6F            Sub_375A:      LBSR Sub_3BCC          ; call Sub_3BCC
$375D  96 38               Sub_375D:      LDA <$38              
$375F  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3761  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3764  24 09                              BCC Sub_376F           ; C=0 (BHS)
$3766  17 04 7C                           LBSR Sub_3BE5          ; call Sub_3BE5
$3769  81 02                              CMPA #$02              ; compare A with CurXY
$376B  25 F0                              BCS Sub_375D           ; C=1 (BLO)
$376D  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$376F  4F                  Sub_376F:      CLRA                   ; A = 0
$3770  1F 02                              TFR D,Y               
$3772  96 38                              LDA <$38              
$3774  8E 13 C3                           LDX #$13C3            
$3777  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$377A  20 DE                              BRA Sub_375A          

; --------------------------------------------------------------
$377C  17 FF 84            Sub_377C:      LBSR Sub_3703          ; call Sub_3703
$377F  30 8D CD 92                        LEAX Dat_0515,PC       ; X → Dat_0515
$3783  17 E6 0F                           LBSR Sub_1D95          ; call Sub_1D95
$3786  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3787  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3788  27 07                              BEQ Sub_3791          
$378A  30 8D CD A9                        LEAX Dat_0537,PC       ; X → Dat_0537
$378E  17 E6 04                           LBSR Sub_1D95          ; call Sub_1D95
$3791  30 8D CD C0         Sub_3791:      LEAX Dat_0555,PC       ; X → Dat_0555
$3795  17 E5 FD                           LBSR Sub_1D95          ; call Sub_1D95
$3798  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3799  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$379A  27 09                              BEQ Sub_37A5          
$379C  30 8D CD 15                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$37A0  17 E5 F2                           LBSR Sub_1D95          ; call Sub_1D95
$37A3  20 54                              BRA Sub_37F9          

; --------------------------------------------------------------
$37A5  30 8D CD DC         Sub_37A5:      LEAX Dat_0585,PC       ; X → Dat_0585
$37A9  17 E5 E9                           LBSR Sub_1D95          ; call Sub_1D95
$37AC  17 0C E3                           LBSR Sub_4492          ; call Sub_4492
$37AF  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$37B0  A8 27                              EORA 7,Y              
$37B2  12                                 NOP                   
$37B3  8E 00 AC                           LDX #$00AC            
$37B6  10 8E 00 20                        LDY #$0020            
$37BA  86 01                              LDA #$01              
$37BC  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$37BF  CC 07 04                           LDD #$0704            
$37C2  17 ED 17                           LBSR Sub_24DC          ; call Sub_24DC
$37C5  C6 1E                              LDB #$1E              
$37C7  17 E6 26                           LBSR Sub_1DF0          ; call Sub_1DF0
$37CA  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$37CB  30 10                              LEAX -16,X            
$37CD  26 01                              BNE $37D0             
$37CF  BF 30 8D                           STX $308D             
$37D2  CC B0 17                           LDD #$B017            
$37D5  E5 BE 30                           BITB [+48,PC]         
$37D8  8D CD                              BSR $37A7             
$37DA  3A                                 ABX                   
$37DB  17 E5 B7                           LBSR Sub_1D95          ; call Sub_1D95
$37DE  10 8E 06 1B                        LDY #$061B            
$37E2  8E 00 AC                           LDX #$00AC            
$37E5  A6 A4                              LDA ,Y                
$37E7  81 0D                              CMPA #$0D              ; compare A with CR
$37E9  26 08                              BNE $37F3             
$37EB  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$37EC  A8 10                              EORA -16,X            
$37EE  27 01                              BEQ $37F1             
$37F0  9E 20                              LDX <$20              
$37F2  06                                 FCB    $06                ; undefined opcode $06 -- not a valid 6809 instruction
$37F3  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$37F5  AD 9F 0C B1                        JSR [$0CB1]            ; call via indexed pointer
$37F9  7D 0C AA            Sub_37F9:      TST $0CAA             
$37FC  10 27 07 02                        LBEQ Sub_3F02         
$3800  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3801  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3802  26 2A                              BNE Sub_382E          
$3804  30 8D CD 89                        LEAX Dat_0591,PC       ; X → Dat_0591
$3808  17 E5 8A                           LBSR Sub_1D95          ; call Sub_1D95
$380B  86 01                              LDA #$01              
$380D  8E 00 AC                           LDX #$00AC            
$3810  10 8E 00 20                        LDY #$0020            
$3814  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$3817  30 8D CC 9A                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$381B  17 E5 77                           LBSR Sub_1D95          ; call Sub_1D95
$381E  86 02                              LDA #$02               ; A = CurXY
$3820  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$3822  8E 00 AC                           LDX #$00AC            
$3825  10 3F 83            Sub_3825:      OS9 I$Create           ; mode=B  name→X  → path→A
$3828  10 25 01 82                        LBCS Sub_39AE         
$382C  97 4F                              STA <$4F              
$382E  30 8D CD 87         Sub_382E:      LEAX Dat_05B9,PC       ; X → Dat_05B9
$3832  17 E5 60                           LBSR Sub_1D95          ; call Sub_1D95
$3835  30 8D CD A4                        LEAX Dat_05DD,PC       ; X → Dat_05DD
$3839  17 E5 59                           LBSR Sub_1D95          ; call Sub_1D95
$383C  30 8D CD 15                        LEAX Dat_0555,PC       ; X → Dat_0555
$3840  17 E5 52                           LBSR Sub_1D95          ; call Sub_1D95
$3843  17 06 3B            Sub_3843:      LBSR Sub_3E81          ; call Sub_3E81
$3846  17 06 50                           LBSR Sub_3E99          ; call Sub_3E99
$3849  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$384A  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$384B  27 05                              BEQ Sub_3852          
$384D  CC 00 00                           LDD #$0000            
$3850  20 06                              BRA Sub_3858          

; --------------------------------------------------------------
$3852  17 06 83            Sub_3852:      LBSR Sub_3ED8          ; call Sub_3ED8
$3855  CC 00 01                           LDD #$0001            
$3858  DD 5E               Sub_3858:      STD <$5E              
$385A  30 8D CE C8                        LEAX Dat_0726,PC       ; X → Dat_0726
$385E  17 E5 34                           LBSR Sub_1D95          ; call Sub_1D95
$3861  CC 0D 07                           LDD #$0D07            
$3864  17 EC 75                           LBSR Sub_24DC          ; call Sub_24DC
$3867  30 8D CD 82                        LEAX Dat_05ED,PC       ; X → Dat_05ED
$386B  86 01                              LDA #$01              
$386D  10 8E 00 14                        LDY #$0014            
$3871  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3874  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$3875  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$3876  C6 04                              LDB #$04              
$3878  D7 64                              STB <$64              
$387A  17 05 F4                           LBSR Sub_3E71          ; call Sub_3E71
$387D  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$387E  64 17                              LSR -9,X              
$3880  03                                 FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
$3881  4A                                 DECA                  
$3882  96 38               Sub_3882:      LDA <$38              
$3884  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3886  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3889  24 5E                              BCC Sub_38E9           ; C=0 (BHS)
$388B  17 F3 06                           LBSR Sub_2B94          ; call Sub_2B94
$388E  10 25 01 49                        LBCS Sub_39DB         
$3892  17 03 50                           LBSR Sub_3BE5          ; call Sub_3BE5
$3895  81 03                              CMPA #$03             
$3897  25 E9                              BCS Sub_3882           ; C=1 (BLO)
$3899  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$389A  64 26                              LSR 6,Y               
$389C  DD 0F                              STD <$0F              
$389E  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$389F  17 05 DB            Sub_389F:      LBSR Sub_3E7D          ; call Sub_3E7D
$38A2  17 03 27                           LBSR Sub_3BCC          ; call Sub_3BCC
$38A5  96 38               Sub_38A5:      LDA <$38              
$38A7  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$38A9  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$38AC  24 3B                              BCC Sub_38E9           ; C=0 (BHS)
$38AE  17 F2 E3                           LBSR Sub_2B94          ; call Sub_2B94
$38B1  10 25 01 26                        LBCS Sub_39DB         
$38B5  17 03 2D                           LBSR Sub_3BE5          ; call Sub_3BE5
$38B8  81 0A                              CMPA #$0A              ; compare A with LF
$38BA  25 E9                              BCS Sub_38A5           ; C=1 (BLO)
$38BC  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$38BD  5D                                 TSTB                  
$38BE  17 06 01                           LBSR Sub_3EC2          ; call Sub_3EC2
$38C1  17 E6 A7                           LBSR Sub_1F6B          ; call Sub_1F6B
$38C4  96 5D                              LDA <$5D              
$38C6  81 0A                              CMPA #$0A              ; compare A with LF
$38C8  25 D5                              BCS Sub_389F           ; C=1 (BLO)
$38CA  16 01 0E                           LBRA Sub_39DB         

; --------------------------------------------------------------
$38CD  17 05 A9            Sub_38CD:      LBSR Sub_3E79          ; call Sub_3E79
$38D0  DC 5E                              LDD <$5E              
$38D2  10 83 00 00                        CMPD #$0000           
$38D6  26 04                              BNE Sub_38DC          
$38D8  17 05 96                           LBSR Sub_3E71          ; call Sub_3E71
$38DB  4F                                 CLRA                   ; A = 0
$38DC  C3 00 01            Sub_38DC:      ADDD #$0001           
$38DF  DD 5E                              STD <$5E              
$38E1  17 05 F4                           LBSR Sub_3ED8          ; call Sub_3ED8
$38E4  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$38E5  5D                                 TSTB                  
$38E6  17 05 C8                           LBSR Sub_3EB1          ; call Sub_3EB1
$38E9  17 F2 A8            Sub_38E9:      LBSR Sub_2B94          ; call Sub_2B94
$38EC  10 25 00 EB                        LBCS Sub_39DB         
$38F0  7F 00 EF                           CLR $00EF             
$38F3  17 01 43                           LBSR Sub_3A39          ; call Sub_3A39
$38F6  34 01                              PSHS CC               
$38F8  DC 5E                              LDD <$5E              
$38FA  10 83 00 00                        CMPD #$0000           
$38FE  26 0A                              BNE Sub_390A          
$3900  7D 00 EF                           TST $00EF             
$3903  26 0B                              BNE Sub_3910          
$3905  35 01                              PULS CC               
$3907  16 00 71                           LBRA Sub_397B         

; --------------------------------------------------------------
$390A  35 01               Sub_390A:      PULS CC               
$390C  25 1C                              BCS Sub_392A           ; C=1 (BLO)
$390E  20 0B                              BRA Sub_391B          

; --------------------------------------------------------------
$3910  35 01               Sub_3910:      PULS CC               
$3912  24 B9                              BCC Sub_38CD           ; C=0 (BHS)
$3914  86 0D                              LDA #$0D               ; A = CR
$3916  97 AC                              STA <$AC              
$3918  16 00 C0            Insn_3918:     LBRA Sub_39DB         
$391B  0D                  Sub_391B:      EQU    $391B            ; [*47] branch target 3 byte(s) inside Insn_3918 -- see [*47]
$391C  6A 26                              DEC 6,Y               
$391E  1B                                 FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
$391F  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3920  6D 27                              TST 7,Y               
$3922  AA 0F                              ORA 15,X              
$3924  6D 17                              TST -9,X              
$3926  05                                 FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
$3927  51                                 FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
$3928  20 BF                              BRA Sub_38E9          

; --------------------------------------------------------------
$392A  96 5D               Sub_392A:      LDA <$5D              
$392C  81 09                              CMPA #$09             
$392E  10 22 00 A9                        LBHI Sub_39DB         
$3932  17 FE 23                           LBSR Sub_3758          ; call Sub_3758
$3935  17 05 45                           LBSR Sub_3E7D          ; call Sub_3E7D
$3938  20 AF               Insn_3938:     BRA Sub_38E9          
$393A  0D                  Sub_393A:      EQU    $393A            ; [*48] branch target 2 byte(s) inside Insn_3938 -- see [*48]
$393B  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$393C  27 3D                              BEQ Sub_397B          
$393E  17 05 3C                           LBSR Sub_3E7D          ; call Sub_3E7D
$3941  17 00 F5            Insn_3941:     LBSR Sub_3A39          ; call Sub_3A39
$3942  00                  Sub_3942:      EQU    $3942            ; [*49] branch target 1 byte(s) inside Insn_3941 -- see [*49]
$3943  F5 34 01                           BITB $3401            
$3946  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3947  6A 27                              DEC 7,Y               
$3949  AE 35                              LDX -11,Y             
$394B  01                                 FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
$394C  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$394D  6A 34               Sub_394D:      DEC -12,Y             
$394F  40                                 NEGA                  
$3950  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3951  57                                 ASRB                  
$3952  26 16                              BNE Sub_396A          
$3954  DC 66                              LDD <$66              
$3956  26 04                              BNE Sub_395C          
$3958  DC 68                              LDD <$68              
$395A  27 0E                              BEQ Sub_396A          
$395C  96 4F               Sub_395C:      LDA <$4F              
$395E  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$3960  9E 66                              LDX <$66              
$3962  10 9E 68                           LDY <$68              
$3965  1F 23                              TFR Y,U               
$3967  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$396A  35 40               Sub_396A:      PULS U                
$396C  96 4F                              LDA <$4F              
$396E  10 3F 8F                           OS9 I$Close            ; path=A
$3971  86 0D                              LDA #$0D               ; A = CR
$3973  97 AC                              STA <$AC              
$3975  17 05 01                           LBSR Sub_3E79          ; call Sub_3E79
$3978  16 FE C8            Sub_3978:      LBRA Sub_3843         
$397B  0F                  Sub_397B:      EQU    $397B            ; [*50] branch target 3 byte(s) inside Sub_3978 -- see [*50]
$397C  6A 17                              DEC -9,X              
$397E  04                                 FCB    $04                ; undefined opcode $04 -- not a valid 6809 instruction
$397F  F9 7F 0C                           ADCB $7F0C            
$3980  7F 0C AA            Sub_3980:      CLR $0CAA             
$3983  17 E5 F7                           LBSR Sub_1F7D          ; call Sub_1F7D
$3986  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3987  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3988  26 05                              BNE Sub_398F          
$398A  96 4F                              LDA <$4F              
$398C  10 3F 8F                           OS9 I$Close            ; path=A
$398F  17 DA 04            Sub_398F:      LBSR Sub_1396          ; call Sub_1396
$3992  17 E5 BE                           LBSR Sub_1F53          ; call Sub_1F53
$3995  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3996  51                                 FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
$3997  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3998  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3999  96 37                              LDA <$37              
$399B  97 4F                              STA <$4F              
$399D  2B 02                              BMI Sub_39A1          
$399F  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$39A0  57                                 ASRB                  
$39A1  35 06               Sub_39A1:      PULS A,B              
$39A3  B7 0C C5                           STA $0CC5             
$39A6  F7 0C C4                           STB $0CC4             
$39A9  35 36                              PULS A,B,X,Y          
$39AB  16 D4 7C                           LBRA Sub_0E2A         

; --------------------------------------------------------------
$39AE  86 07               Sub_39AE:      LDA #$07              
$39B0  17 E7 88                           LBSR Sub_213B          ; call Sub_213B
$39B3  34 04                              PSHS B                
$39B5  CC 0D 02                           LDD #$0D02            
$39B8  17 EB 21                           LBSR Sub_24DC          ; call Sub_24DC
$39BB  86 03                              LDA #$03              
$39BD  17 E7 7B                           LBSR Sub_213B          ; call Sub_213B
$39C0  30 8D CA F1                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$39C4  17 E3 CE                           LBSR Sub_1D95          ; call Sub_1D95
$39C7  35 04                              PULS B                
$39C9  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$39CC  8E 00 3C                           LDX #$003C            
$39CF  17 D7 A6                           LBSR Sub_1178          ; call Sub_1178
$39D2  30 8D CA DB                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$39D6  17 E3 BC                           LBSR Sub_1D95          ; call Sub_1D95
$39D9  20 B4                              BRA Sub_398F          

; --------------------------------------------------------------
$39DB  96 AC               Sub_39DB:      LDA <$AC              
$39DD  2B 12                              BMI Sub_39F1          
$39DF  81 0D                              CMPA #$0D              ; compare A with CR
$39E1  27 0E                              BEQ Sub_39F1          
$39E3  96 4F                              LDA <$4F              
$39E5  10 3F 8F                           OS9 I$Close            ; path=A
$39E8  8E 00 AC                           LDX #$00AC            
$39EB  10 3F 87                           OS9 I$Delete           ; name→X
$39EE  17 FD 67                           LBSR Sub_3758          ; call Sub_3758
$39F1  96 14               Sub_39F1:      LDA <$14              
$39F3  97 16                              STA <$16              
$39F5  DC 17                              LDD <$17              
$39F7  DD 19                              STD <$19              
$39F9  8E 13 C3                           LDX #$13C3            
$39FC  86 18                              LDA #$18              
$39FE  C6 04                              LDB #$04              
$3A00  A7 80               Sub_3A00:      STA ,X+               
$3A02  5A                                 DECB                  
$3A03  26 FB                              BNE Sub_3A00          
$3A05  86 03                              LDA #$03              
$3A07  C6 04                              LDB #$04              
$3A09  A7 80               Sub_3A09:      STA ,X+               
$3A0B  5A                                 DECB                  
$3A0C  26 FB                              BNE Sub_3A09          
$3A0E  96 38                              LDA <$38              
$3A10  10 8E 00 08                        LDY #$0008            
$3A14  8E 13 C3                           LDX #$13C3            
$3A17  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3A1A  16 FF 63                           LBRA Sub_3980         

; --------------------------------------------------------------
$3A1D  86 04               Sub_3A1D:      LDA #$04              
$3A1F  97 5A                              STA <$5A              
$3A21  16 01 73                           LBRA Sub_3B97         

; --------------------------------------------------------------
$3A24  86 03               Sub_3A24:      LDA #$03              
$3A26  97 5A                              STA <$5A              
$3A28  16 01 6C                           LBRA Sub_3B97         

; --------------------------------------------------------------
$3A2B  86 02               Sub_3A2B:      LDA #$02               ; A = CurXY
$3A2D  97 5A                              STA <$5A              
$3A2F  16 01 65                           LBRA Sub_3B97         

; --------------------------------------------------------------
$3A32  86 01               Sub_3A32:      LDA #$01              
$3A34  97 5A                              STA <$5A              
$3A36  16 01 5E                           LBRA Sub_3B97         

; --------------------------------------------------------------
$3A39  34 30               Sub_3A39:      PSHS X,Y              
$3A3B  CC 00 00                           LDD #$0000            
$3A3E  DD 58                              STD <$58              
$3A40  DD 53                              STD <$53              
$3A42  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3A43  6D 0F                              TST 15,X              
$3A45  5A                                 DECB                  
$3A46  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$3A47  6A 17                              DEC -9,X              
$3A49  01                                 FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
$3A4A  81 8E                              CMPA #$8E             
$3A4B  8E 00 EC            Sub_3A4B:      LDX #$00EC            
$3A4E  17 01 94            Sub_3A4E:      LBSR Sub_3BE5          ; call Sub_3BE5
$3A51  81 0A                              CMPA #$0A              ; compare A with LF
$3A53  10 22 FF C6                        LBHI Sub_3A1D         
$3A57  96 38                              LDA <$38              
$3A59  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3A5B  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3A5E  25 EE                              BCS Sub_3A4E           ; C=1 (BLO)
$3A60  10 8E 00 01                        LDY #$0001            
$3A64  96 38                              LDA <$38              
$3A66  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3A69  25 E3                              BCS Sub_3A4E           ; C=1 (BLO)
$3A6B  1F 20                              TFR Y,D               
$3A6D  DD 58                              STD <$58              
$3A6F  3A                                 ABX                   
$3A70  B6 00 EC                           LDA $00EC             
$3A73  81 02                              CMPA #$02              ; compare A with CurXY
$3A75  27 1E                              BEQ Sub_3A95          
$3A77  81 01                              CMPA #$01             
$3A79  27 15                              BEQ Sub_3A90          
$3A7B  81 04                              CMPA #$04             
$3A7D  10 27 01 3D                        LBEQ Sub_3BBE         
$3A81  81 18                              CMPA #$18             
$3A83  10 27 01 3E                        LBEQ Sub_3BC5         
$3A87  81 03                              CMPA #$03             
$3A89  10 27 01 38                        LBEQ Sub_3BC5         
$3A8D  16 FF BB                           LBRA Sub_3A4B         

; --------------------------------------------------------------
$3A90  CC 00 80            Sub_3A90:      LDD #$0080            
$3A93  20 03                              BRA Sub_3A98          

; --------------------------------------------------------------
$3A95  CC 04 00            Sub_3A95:      LDD #$0400            
$3A98  DD 62               Sub_3A98:      STD <$62              
$3A9A  10 8E 00 EF                        LDY #$00EF            
$3A9E  31 AB                              LEAY D,Y              
$3AA0  10 9F 5B                           STY <$5B              
$3AA3  CA 04                              ORB #$04              
$3AA5  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3AA6  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$3AA7  27 02                              BEQ Sub_3AAB          
$3AA9  CA 01                              ORB #$01              
$3AAB  DD 60               Sub_3AAB:      STD <$60              
$3AAD  17 01 1C                           LBSR Sub_3BCC          ; call Sub_3BCC
$3AB0  20 09                              BRA Sub_3ABB          

; --------------------------------------------------------------
$3AB2  17 01 30            Sub_3AB2:      LBSR Sub_3BE5          ; call Sub_3BE5
$3AB5  81 03                              CMPA #$03             
$3AB7  10 22 FF 62                        LBHI Sub_3A1D         
$3ABB  96 38               Sub_3ABB:      LDA <$38              
$3ABD  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$3ABF  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$3AC2  25 EE                              BCS Sub_3AB2           ; C=1 (BLO)
$3AC4  C1 02                              CMPB #$02              ; compare B with CurXY
$3AC6  25 EA                              BCS Sub_3AB2           ; C=1 (BLO)
$3AC8  10 8E 00 02                        LDY #$0002            
$3ACC  96 38                              LDA <$38              
$3ACE  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3AD1  1F 20                              TFR Y,D               
$3AD3  3A                                 ABX                   
$3AD4  D3 58                              ADDD <$58             
$3AD6  DD 58                              STD <$58              
$3AD8  DC 5E                              LDD <$5E              
$3ADA  F1 00 ED                           CMPB $00ED            
$3ADD  26 09                              BNE Sub_3AE8          
$3ADF  53                                 COMB                  
$3AE0  F1 00 EE                           CMPB $00EE            
$3AE3  27 0D                              BEQ Sub_3AF2          
$3AE5  16 FF 43            Sub_3AE5:      LBRA Sub_3A2B         
$3AE8  5A                  Sub_3AE8:      DECB                  
$3AE9  F1 00 ED                           CMPB $00ED            
$3AEC  26 F7                              BNE Sub_3AE5          
$3AEE  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$3AEF  6D 20                              TST 0,Y               
$3AF1  ED 17                              STD -9,X              
$3AF2  17 00 D7            Sub_3AF2:      LBSR Sub_3BCC          ; call Sub_3BCC
$3AF5  17 00 ED            Sub_3AF5:      LBSR Sub_3BE5          ; call Sub_3BE5
$3AF8  81 04                              CMPA #$04             
$3AFA  10 22 FF 1F                        LBHI Sub_3A1D         
$3AFE  96 38               Sub_3AFE:      LDA <$38              
$3B00  AD 9F 0C B3                        JSR [$0CB3]            ; call via indexed pointer
$3B04  25 EF                              BCS Sub_3AF5           ; C=1 (BLO)
$3B06  1F 20                              TFR Y,D               
$3B08  17 00 C1                           LBSR Sub_3BCC          ; call Sub_3BCC
$3B0B  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3B0C  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$3B0D  26 05                              BNE Sub_3B14          
$3B0F  17 03 2F                           LBSR Sub_3E41          ; call Sub_3E41
$3B12  20 03                              BRA Sub_3B17          

; --------------------------------------------------------------
$3B14  17 02 FE            Sub_3B14:      LBSR Sub_3E15          ; call Sub_3E15
$3B17  3A                  Sub_3B17:      ABX                   
$3B18  D3 58                              ADDD <$58             
$3B1A  DD 58                              STD <$58              
$3B1C  10 93 60                           CMPD <$60             
$3B1F  25 DD                              BCS Sub_3AFE           ; C=1 (BLO)
$3B21  9E 5B                              LDX <$5B              
$3B23  DC 53                              LDD <$53              
$3B25  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3B26  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$3B27  27 09                              BEQ Sub_3B32          
$3B29  10 A3 84                           CMPD ,X               
$3B2C  10 26 FE F4         Sub_3B2C:      LBNE Sub_3A24         
$3B30  20 04                              BRA Sub_3B36          

; --------------------------------------------------------------
$3B32  A1 84               Sub_3B32:      CMPA ,X               
$3B34  20 F6               Insn_3B34:     BRA Sub_3B2C          
$3B36  0D                  Sub_3B36:      EQU    $3B36            ; [*51] branch target 2 byte(s) inside Insn_3B34 -- see [*51]
$3B37  6D 26                              TST 6,Y               
$3B39  59                                 ROLB                  
$3B3A  DC 5E                              LDD <$5E              
$3B3C  10 83 00 00                        CMPD #$0000           
$3B40  26 07                              BNE Sub_3B49          
$3B42  17 EE D9                           LBSR Sub_2A1E          ; call Sub_2A1E
$3B45  25 50                              BCS Sub_3B97           ; C=1 (BLO)
$3B47  20 4B                              BRA Sub_3B94          

; --------------------------------------------------------------
$3B49  8E 00 EF            Sub_3B49:      LDX #$00EF            
$3B4C  10 83 00 01                        CMPD #$0001           
$3B50  26 3C                              BNE Sub_3B8E          
$3B52  DC 62                              LDD <$62              
$3B54  17 05 F8                           LBSR Sub_414F          ; call Sub_414F
$3B57  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3B58  57                                 ASRB                  
$3B59  27 33                              BEQ Sub_3B8E          
$3B5B  34 32                              PSHS A,X,Y            
$3B5D  8E 00 A9                           LDX #$00A9            
$3B60  96 95                              LDA <$95              
$3B62  A7 02                              STA 2,X               
$3B64  10 8E 00 03                        LDY #$0003            
$3B68  86 01                              LDA #$01              
$3B6A  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3B6D  30 8D CB AD                        LEAX Dat_071E,PC       ; X → Dat_071E
$3B71  10 8E 00 08                        LDY #$0008            
$3B75  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3B78  B6 0C CC                           LDA $0CCC             
$3B7B  17 E3 4E                           LBSR Sub_1ECC          ; call Sub_1ECC
$3B7E  8E 00 A9                           LDX #$00A9            
$3B81  A7 02                              STA 2,X               
$3B83  10 8E 00 03                        LDY #$0003            
$3B87  86 01                              LDA #$01              
$3B89  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3B8C  35 32                              PULS A,X,Y            
$3B8E  DC 62               Sub_3B8E:      LDD <$62              
$3B90  17 0A FE                           LBSR Sub_4691          ; call Sub_4691
$3B93  5F                                 CLRB                   ; B = 0
$3B94  35 30               Sub_3B94:      PULS X,Y              
$3B96  39                  Insn_3B96:     RTS                    ; return from subroutine
$3B97  0C                  Sub_3B97:      EQU    $3B97            ; [*52] branch target 1 byte(s) inside Insn_3B96 -- see [*52]
$3B98  5D                                 TSTB                  
$3B99  17 03 26                           LBSR Sub_3EC2          ; call Sub_3EC2
$3B9C  17 E3 CC                           LBSR Sub_1F6B          ; call Sub_1F6B
$3B9F  CC 0D 07                           LDD #$0D07            
$3BA2  17 E9 37                           LBSR Sub_24DC          ; call Sub_24DC
$3BA5  C6 14                              LDB #$14              
$3BA7  96 5A                              LDA <$5A              
$3BA9  27 10                              BEQ Sub_3BBB          
$3BAB  3D                                 MUL                    ; D = A×B unsigned
$3BAC  30 8D CA 3D                        LEAX Dat_05ED,PC       ; X → Dat_05ED
$3BB0  30 8B                              LEAX D,X              
$3BB2  86 01                              LDA #$01              
$3BB4  10 8E 00 14                        LDY #$0014            
$3BB8  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3BBB  53                  Sub_3BBB:      COMB                  
$3BBC  20 D6               Insn_3BBC:     BRA Sub_3B94          
$3BBE  0C                  Sub_3BBE:      EQU    $3BBE            ; [*53] branch target 2 byte(s) inside Insn_3BBC -- see [*53]
$3BBF  6A 17                              DEC -9,X              
$3BC1  0A                                 FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
$3BC2  67 20                              ASR 0,Y               
$3BC4  CF                                 FCB    $CF                ; undefined opcode $CF -- not a valid 6809 instruction
$3BC5  86 0A               Sub_3BC5:      LDA #$0A               ; A = LF
$3BC7  97 5D                              STA <$5D              
$3BC9  16 FE 66                           LBRA Sub_3A32         

; --------------------------------------------------------------
$3BCC  34 16               Sub_3BCC:      PSHS A,B,X            
$3BCE  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3BCF  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$3BD0  27 07                              BEQ Sub_3BD9          
$3BD2  4F                                 CLRA                   ; A = 0
$3BD3  D6 7C                              LDB <$7C              
$3BD5  DD 6B                              STD <$6B              
$3BD7  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3BD9  8E 0C A3            Sub_3BD9:      LDX #$0CA3            
$3BDC  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$3BDF  A6 05                              LDA 5,X               
$3BE1  97 6B                              STA <$6B              
$3BE3  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3BE5  34 14               Sub_3BE5:      PSHS B,X              
$3BE7  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3BE8  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$3BE9  27 10                              BEQ Sub_3BFB          
$3BEB  86 01                              LDA #$01              
$3BED  D6 7C                              LDB <$7C              
$3BEF  93 6B                              SUBD <$6B             
$3BF1  1F 98                              TFR B,A               
$3BF3  8E 00 01                           LDX #$0001            
$3BF6  17 D5 7F                           LBSR Sub_1178          ; call Sub_1178
$3BF9  35 94                              PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3BFB  8E 0C A3            Sub_3BFB:      LDX #$0CA3            
$3BFE  10 3F 15                           OS9 F$Time             ; buf→X  → 6-byte time
$3C01  A6 05               Sub_3C01:      LDA 5,X               
$3C03  8E 00 01                           LDX #$0001            
$3C06  10 3F 0A                           OS9 F$Sleep            ; ticks→X  (0=forever)
$3C09  8B 3C                              ADDA #$3C             
$3C0B  90 6B                              SUBA <$6B             
$3C0D  81 3C                              CMPA #$3C              ; compare A with '<'
$3C0F  25 02                              BCS Sub_3C13           ; C=1 (BLO)
$3C11  80 3C                              SUBA #$3C             
$3C13  35 94               Sub_3C13:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

CrcTable
; Referenced by: $3E24
; CRC-16/CCITT lookup table -- 256 entries x 2 bytes = 512 bytes
; ── 512 bytes  ($3C15—$3E14) ──
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

Sub_3C5D
         FDB    $64E6
         FDB    $74C7
         FDB    $44A4
         FDB    $5485
         FDB    $A56A

Sub_3C67
         FDB    $B54B
         FDB    $8528
         FDB    $9509
         FDB    $E5EE

Sub_3C6F
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

Sub_3C8F
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

Sub_3CA5
         FDB    $C9CC
         FDB    $D9ED
         FDB    $E98E
         FDB    $F9AF

Sub_3CAD
         FDB    $8948
         FDB    $9969
         FDB    $A90A
         FDB    $B92B
         FDB    $5AF5
         FDB    $4AD4

Sub_3CB9
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

Sub_3CD7
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

Sub_3CEB
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

Sub_3D01
         FDB    $1E51
         FDB    $0E70
         FDB    $FF9F
         FDB    $EFBE
         FDB    $DFDD
         FDB    $CFFC
         FDB    $BF1B
         FDB    $AF3A
         FDB    $9F59

Sub_3D13
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

Sub_3D29
         FDB    $30C2
         FDB    $20E3
         FDB    $5004
         FDB    $4025
         FDB    $7046

Sub_3D33
         FDB    $6067
         FDB    $83B9

Sub_3D37
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

Sub_3D5B
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

Sub_3DBD
         FDB    $8BF9
         FDB    $9BD8
         FDB    $ABBB
         FDB    $BB9A

Sub_3DC5
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
$3E15  34 36               Sub_3E15:      PSHS A,B,X,Y          
$3E17  31 8B                              LEAY D,X              
$3E19  34 20                              PSHS Y                
$3E1B  10 9E 5B                           LDY <$5B              
$3E1E  34 20                              PSHS Y                
$3E20  9C 5B                              CMPX <$5B             
$3E22  24 19                              BCC Sub_3E3D           ; C=0 (BHS)
$3E24  31 8D FD ED                        LEAY CrcTable,PC       ; Y → CrcTable
$3E28  D6 53               Sub_3E28:      LDB <$53              
$3E2A  4F                                 CLRA                   ; A = 0
$3E2B  E8 80                              EORB ,X+              
$3E2D  58                                 LSLB                  
$3E2E  49                                 ROLA                  
$3E2F  EC AB                              LDD D,Y               
$3E31  98 54                              EORA <$54             
$3E33  DD 53                              STD <$53              
$3E35  AC E4                              CMPX ,S               
$3E37  27 04                              BEQ Sub_3E3D          
$3E39  AC 62                              CMPX 2,S              
$3E3B  25 EB                              BCS Sub_3E28           ; C=1 (BLO)
$3E3D  32 64               Sub_3E3D:      LEAS 4,S              
$3E3F  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E41  34 36               Sub_3E41:      PSHS A,B,X,Y          
$3E43  31 8B                              LEAY D,X              
$3E45  34 20                              PSHS Y                
$3E47  9C 5B                              CMPX <$5B             
$3E49  27 0C                              BEQ Sub_3E57          
$3E4B  96 53                              LDA <$53              
$3E4D  AB 80               Sub_3E4D:      ADDA ,X+              
$3E4F  9C 5B                              CMPX <$5B             
$3E51  27 04                              BEQ Sub_3E57          
$3E53  AC E4                              CMPX ,S               
$3E54  E4 25               Sub_3E54:      ANDB 5,Y              
$3E56  F6 97 53                           LDB $9753             
$3E57  97 53               Sub_3E57:      STA <$53              
$3E59  32 62                              LEAS 2,S              
$3E5B  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E5D  34 32               Sub_3E5D:      PSHS A,X,Y            
$3E5F  8E 00 50                           LDX #$0050            
$3E62  96 38                              LDA <$38              
$3E64  10 8E 00 01                        LDY #$0001            
$3E68  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3E6B  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E6D  97 50               Sub_3E6D:      STA <$50              
$3E6F  20 EC                              BRA Sub_3E5D          

; --------------------------------------------------------------
$3E71  86 43               Sub_3E71:      LDA #$43               ; A = 'C'
$3E73  20 F8                              BRA Sub_3E6D          

; --------------------------------------------------------------
$3E75  86 04               Sub_3E75:      LDA #$04              
$3E77  20 F4                              BRA Sub_3E6D          

; --------------------------------------------------------------
$3E79  86 06               Sub_3E79:      LDA #$06              
$3E7B  20 F0                              BRA Sub_3E6D          

; --------------------------------------------------------------
$3E7D  86 15               Sub_3E7D:      LDA #$15              
$3E7F  20 EC                              BRA Sub_3E6D          

; --------------------------------------------------------------
$3E81  34 36               Sub_3E81:      PSHS A,B,X,Y          
$3E83  30 8D C7 CA                        LEAX Dat_0651,PC       ; X → Dat_0651
$3E87  10 8E 14 63                        LDY #$1463            
$3E8B  C6 09                              LDB #$09              
$3E8D  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$3E91  8E 14 63                           LDX #$1463            
$3E94  17 DE FE                           LBSR Sub_1D95          ; call Sub_1D95
$3E97  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3E99  34 36               Sub_3E99:      PSHS A,B,X,Y          
$3E9B  30 8D C7 BB                        LEAX Dat_065A,PC       ; X → Dat_065A
$3E9F  10 8E 14 53                        LDY #$1453            
$3EA3  C6 09                              LDB #$09              
$3EA5  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$3EA9  8E 14 53                           LDX #$1453            
$3EAC  17 DE E6                           LBSR Sub_1D95          ; call Sub_1D95
$3EAF  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3EB1  34 36               Sub_3EB1:      PSHS A,B,X,Y          
$3EB3  8E 14 53                           LDX #$1453            
$3EB6  CC 30 30                           LDD #$3030            
$3EB9  ED 05                              STD 5,X               
$3EBB  ED 07                              STD 7,X               
$3EBD  17 DE D5                           LBSR Sub_1D95          ; call Sub_1D95
$3EC0  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3EC2  34 32               Sub_3EC2:      PSHS A,X,Y            
$3EC4  8E 14 53                           LDX #$1453            
$3EC7  8D 1B                              BSR Sub_3EE4           ; call Sub_3EE4
$3EC9  17 DE C9                           LBSR Sub_1D95          ; call Sub_1D95
$3ECC  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3ECE  34 32               Sub_3ECE:      PSHS A,X,Y            
$3ED0  8E 14 63                           LDX #$1463            
$3ED3  17 DE BF                           LBSR Sub_1D95          ; call Sub_1D95
$3ED6  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3ED8  34 32               Sub_3ED8:      PSHS A,X,Y            
$3EDA  8E 14 63                           LDX #$1463            
$3EDD  8D 05                              BSR Sub_3EE4           ; call Sub_3EE4
$3EDF  17 DE B3                           LBSR Sub_1D95          ; call Sub_1D95
$3EE2  35 B2                              PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$3EE4  34 04               Sub_3EE4:      PSHS B                
$3EE6  C6 08                              LDB #$08               ; B = BS
$3EE8  8D 09               Sub_3EE8:      BSR Sub_3EF3           ; call Sub_3EF3
$3EEA  81 30                              CMPA #$30              ; compare A with '0'
$3EEC  26 03                              BNE Sub_3EF1          
$3EEE  5A                                 DECB                  
$3EEF  24 F7                              BCC Sub_3EE8           ; C=0 (BHS)
$3EF1  35 84               Sub_3EF1:      PULS B,PC              ; return from subroutine  (PULS PC = RTS)
$3EF3  A6 85               Sub_3EF3:      LDA B,X               
$3EF5  4C                                 INCA                  
$3EF6  81 39                              CMPA #$39              ; compare A with '9'
$3EF8  22 03                              BHI Sub_3EFD          
$3EFA  A7 85                              STA B,X               
$3EFC  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$3EFD  86 30               Sub_3EFD:      LDA #$30               ; A = '0'
$3EFF  A7 85                              STA B,X               
$3F01  39                  Insn_3F01:     RTS                    ; return from subroutine
$3F02  0D                  Sub_3F02:      EQU    $3F02            ; [*54] branch target 1 byte(s) inside Insn_3F01 -- see [*54]
$3F03  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3F04  27 0C                              BEQ Sub_3F12          
$3F06  17 EC EB                           LBSR Sub_2BF4          ; call Sub_2BF4
$3F08  EB 0D               Sub_3F08:      ADDB 13,X             
$3F0A  30 10                              LEAX -16,X            
$3F0C  26 FA                              BNE Sub_3F08          
$3F0E  80 17                              SUBA #$17             
$3F0F  17 ED 2E            Sub_3F0F:      LBSR Sub_2C40          ; call Sub_2C40
$3F12  30 8D C6 93         Sub_3F12:      LEAX Dat_05A9,PC       ; X → Dat_05A9
$3F16  17 DE 7C                           LBSR Sub_1D95          ; call Sub_1D95
$3F19  8E 00 AC                           LDX #$00AC            
$3F1C  86 01                              LDA #$01              
$3F1E  10 8E 00 20                        LDY #$0020            
$3F22  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$3F25  30 8D C5 8C                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$3F29  17 DE 69                           LBSR Sub_1D95          ; call Sub_1D95
$3F2C  30 8D C7 F6                        LEAX Dat_0726,PC       ; X → Dat_0726
$3F30  17 DE 62                           LBSR Sub_1D95          ; call Sub_1D95
$3F33  86 01                              LDA #$01              
$3F35  8E 00 AC                           LDX #$00AC            
$3F38  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$3F3B  24 0A                              BCC $3F47              ; C=0 (BHS)
$3F3D  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3F3E  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3F3F  10 27 FA 4C                        LBEQ Sub_398F         
$3F43  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$3F44  74 20 1B            Insn_3F44:     LSR $201B             
$3F46  1B                  Sub_3F46:      EQU    $3F46            ; [*55] branch target 2 byte(s) inside Insn_3F44 -- see [*55]
$3F47  97 4F                              STA <$4F              
$3F49  8E 00 EC                           LDX #$00EC            
$3F4C  10 8E 00 7F                        LDY #$007F            
$3F50  10 3F 89                           OS9 I$Read             ; path=A  count=Y  buf→X
$3F53  25 E8                              BCS $3F3D              ; C=1 (BLO)
$3F54  E8 1F               Sub_3F54:      EORB -1,X             
$3F56  20 17               Insn_3F56:     BRA Sub_3F6F          
$3F58  01                  Sub_3F58:      EQU    $3F58            ; [*56] branch target 2 byte(s) inside Insn_3F56 -- see [*56]
$3F59  F5 96 4F                           BITB $964F            
$3F5C  8E 00 00                           LDX #$0000            
$3F5F  10 3F 88                           OS9 I$Seek             ; path=A  mode=B  offset→X:D
$3F62  30 8D C6 53         Sub_3F62:      LEAX Dat_05B9,PC       ; X → Dat_05B9
$3F66  17 DE 2C                           LBSR Sub_1D95          ; call Sub_1D95
$3F69  30 8D C5 E8                        LEAX Dat_0555,PC       ; X → Dat_0555
$3F6D  17 DE 25                           LBSR Sub_1D95          ; call Sub_1D95
$3F6F  25 17               Sub_3F6F:      BCS Sub_3F88           ; C=1 (BLO)
$3F71  FF 0E 17                           STU $0E17             
$3F74  FF 23 0D                           STU $230D             
$3F77  57                                 ASRB                  
$3F78  27 2F                              BEQ Sub_3FA9          
$3F7A  8E 00 A9                           LDX #$00A9            
$3F7D  96 95                              LDA <$95              
$3F7F  A7 02                              STA 2,X               
$3F81  10 8E 00 03                        LDY #$0003            
$3F85  86 01                              LDA #$01              
$3F87  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3F88  3F                  Sub_3F88:      SWI                   
$3F89  8A 30                              ORA #$30              
$3F8B  8D C7                              BSR Sub_3F54           ; call Sub_3F54
$3F8D  90 10                              SUBA <$10             
$3F8F  8E 00 08                           LDX #$0008            
$3F92  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$3F95  8E 00 A9                           LDX #$00A9            
$3F98  B6 0C CC                           LDA $0CCC             
$3F9B  17 DF 2E                           LBSR Sub_1ECC          ; call Sub_1ECC
$3F9E  A7 02                              STA 2,X               
$3FA0  10 8E 00 03                        LDY #$0003            
$3FA4  86 01                              LDA #$01              
$3FA6  10 3F 8A            Insn_3FA6:     OS9 I$Write            ; path=A  count=Y  buf→X
$3FA9  0F                  Sub_3FA9:      EQU    $3FA9            ; [*57] branch target 3 byte(s) inside Insn_3FA6 -- see [*57]
$3FAA  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$3FAB  CC 00 80                           LDD #$0080            
$3FAE  DD 62                              STD <$62              
$3FB0  C3 00 04                           ADDD #$0004           
$3FB3  DD 60                              STD <$60              
$3FB5  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3FB6  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3FB7  10 26 00 FE                        LBNE Sub_40B9         
$3FBB  8E 13 C3                           LDX #$13C3            
$3FBE  17 ED F5                           LBSR Sub_2DB6          ; call Sub_2DB6
$3FC1  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3FC2  51                                 FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
$3FC3  27 0A                              BEQ Sub_3FCF          
$3FC5  CC 04 00                           LDD #$0400            
$3FC8  DD 62                              STD <$62              
$3FCA  C3 00 04                           ADDD #$0004           
$3FCD  DD 60                              STD <$60              
$3FCF  CC 00 01            Sub_3FCF:      LDD #$0001            
$3FD2  DD 5E                              STD <$5E              
$3FD4  17 FF 01                           LBSR Sub_3ED8          ; call Sub_3ED8
$3FD7  17 FE D7                           LBSR Sub_3EB1          ; call Sub_3EB1
$3FDA  17 F7 7B                           LBSR Sub_3758          ; call Sub_3758
$3FDD  17 E6 73                           LBSR Sub_2653          ; call Sub_2653
$3FE0  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$3FE1  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$3FE2  27 08                              BEQ Sub_3FEC          
$3FE4  DC 5E                              LDD <$5E              
$3FE6  10 83 00 01                        CMPD #$0001           
$3FEA  27 10                              BEQ Sub_3FFC          
$3FEC  17 EB CD            Sub_3FEC:      LBSR Sub_2BBC          ; call Sub_2BBC
$3FEF  10 25 00 C3                        LBCS Sub_40B6         
$3FF3  81 43                              CMPA #$43              ; compare A with 'C'
$3FF5  27 05                              BEQ Sub_3FFC          
$3FF7  17 E6 E1                           LBSR Sub_26DB          ; call Sub_26DB
$3FFA  20 17                              BRA Sub_4013          

; --------------------------------------------------------------
$3FFC  86 01               Sub_3FFC:      LDA #$01              
$3FFE  97 65                              STA <$65              
$4000  17 E6 D8                           LBSR Sub_26DB          ; call Sub_26DB
$4003  DC 62                              LDD <$62              
$4005  C3 00 05                           ADDD #$0005           
$4008  DD 60                              STD <$60              
$400A  20 17                              BRA Sub_4023          

; --------------------------------------------------------------
$400C  17 EB AD            Sub_400C:      LBSR Sub_2BBC          ; call Sub_2BBC
$400F  10 25 00 A3                        LBCS Sub_40B6         
$4013  81 15               Sub_4013:      CMPA #$15             
$4015  27 0C                              BEQ Sub_4023          
$4017  81 06                              CMPA #$06             
$4019  27 32                              BEQ Sub_404D          
$401B  81 18                              CMPA #$18             
$401D  10 27 00 95                        LBEQ Sub_40B6         
$4021  20 C9               Insn_4021:     BRA Sub_3FEC          
$4023  0C                  Sub_4023:      EQU    $4023            ; [*58] branch target 2 byte(s) inside Insn_4021 -- see [*58]
$4024  5D                                 TSTB                  
$4025  96 5D                              LDA <$5D              
$4027  81 09                              CMPA #$09             
$4029  10 22 00 89                        LBHI Sub_40B6         
$402D  81 01                              CMPA #$01             
$402F  26 08                              BNE Sub_4039          
$4031  DC 5E                              LDD <$5E              
$4033  10 83 00 01                        CMPD #$0001           
$4037  27 06                              BEQ Sub_403F          
$4039  17 FE 86            Sub_4039:      LBSR Sub_3EC2          ; call Sub_3EC2
$403C  17 DF 2C                           LBSR Sub_1F6B          ; call Sub_1F6B
$403F  10 9E 60            Sub_403F:      LDY <$60              
$4042  96 38                              LDA <$38              
$4044  8E 00 EC                           LDX #$00EC            
$4047  AD 9F 0C B5                        JSR [$0CB5]            ; call via indexed pointer
$404A  B5 20 BF            Insn_404A:     BITA $20BF            
$404D  0F                  Sub_404D:      EQU    $404D            ; [*59] branch target 3 byte(s) inside Insn_404A -- see [*59]
$404E  5D                                 TSTB                  
$404F  17 FE 5F                           LBSR Sub_3EB1          ; call Sub_3EB1
$4052  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$4053  6A 26                              DEC 6,Y               
$4055  3A                                 ABX                   
$4056  DC 5E                              LDD <$5E              
$4058  C3 00 01                           ADDD #$0001           
$405B  DD 5E                              STD <$5E              
$405D  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$405E  51                                 FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
$405F  27 13                              BEQ Sub_4074          
$4061  CC 04 00                           LDD #$0400            
$4064  DD 62                              STD <$62              
$4066  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$4067  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$4068  27 05                              BEQ Sub_406F          
$406A  C3 00 05                           ADDD #$0005           
$406D  20 03                              BRA Sub_4072          

; --------------------------------------------------------------
$406F  C3 00 04            Sub_406F:      ADDD #$0004           
$4072  DD 60               Sub_4072:      STD <$60              
$4074  17 FE 61            Sub_4074:      LBSR Sub_3ED8          ; call Sub_3ED8
$4077  17 E5 D9                           LBSR Sub_2653          ; call Sub_2653
$407A  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$407B  6A 26                              DEC 6,Y               
$407D  12                                 NOP                   
$407E  17 E6 5A                           LBSR Sub_26DB          ; call Sub_26DB
$4081  96 38                              LDA <$38              
$4083  8E 00 EC                           LDX #$00EC            
$4086  10 9E 60                           LDY <$60              
$4089  AD 9F 0C B5                        JSR [$0CB5]            ; call via indexed pointer
$408D  16 FF 7C                           LBRA Sub_400C         

; --------------------------------------------------------------
$4090  96 4F               Sub_4090:      LDA <$4F              
$4092  10 3F 8F                           OS9 I$Close            ; path=A
$4095  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$4096  6A 0D                              DEC 13,X              
$4098  52                                 FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
$4099  27 0C                              BEQ Sub_40A7          
$409B  17 FD D7                           LBSR Sub_3E75          ; call Sub_3E75
$409E  17 EB 1B                           LBSR Sub_2BBC          ; call Sub_2BBC
$40A1  25 13                              BCS Sub_40B6           ; C=1 (BLO)
$40A3  12                                 NOP                   
$40A4  16 FE 68                           LBRA Sub_3F0F         

; --------------------------------------------------------------
$40A7  17 FD CB            Sub_40A7:      LBSR Sub_3E75          ; call Sub_3E75
$40AA  17 EB 0F                           LBSR Sub_2BBC          ; call Sub_2BBC
$40AD  25 07                              BCS Sub_40B6           ; C=1 (BLO)
$40AF  81 06                              CMPA #$06             
$40B1  26 F4                              BNE Sub_40A7          
$40B3  16 F8 CA                           LBRA Sub_3980         

; --------------------------------------------------------------
$40B6  16 F9 38            Sub_40B6:      LBRA Sub_39F1         
$40B9  17 EB 00            Sub_40B9:      LBSR Sub_2BBC          ; call Sub_2BBC
$40BC  25 F8                              BCS Sub_40B6           ; C=1 (BLO)
$40BE  81 43                              CMPA #$43              ; compare A with 'C'
$40C0  26 F7                              BNE Sub_40B9          
$40C2  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$40C3  65                                 FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
$40C4  DC 62                              LDD <$62              
$40C6  C3 00 05                           ADDD #$0005           
$40C9  DD 60                              STD <$60              
$40CB  CC 00 00                           LDD #$0000            
$40CE  DD 5E                              STD <$5E              
$40D0  17 E5 80                           LBSR Sub_2653          ; call Sub_2653
$40D3  17 E6 05                           LBSR Sub_26DB          ; call Sub_26DB
$40D6  8E 00 EC                           LDX #$00EC            
$40D9  10 8E 13 C3                        LDY #$13C3            
$40DD  C6 86                              LDB #$86              
$40DF  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$40E3  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$40E4  74 26 10                           LSR $2610             
$40E7  CC 00 01                           LDD #$0001            
$40EA  DD 5E                              STD <$5E              
$40EC  CC 04 00                           LDD #$0400            
$40EF  DD 62                              STD <$62              
$40F1  17 E5 5F                           LBSR Sub_2653          ; call Sub_2653
$40F4  17 E5 E4                           LBSR Sub_26DB          ; call Sub_26DB
$40F7  96 38               Sub_40F7:      LDA <$38              
$40F9  8E 13 C3                           LDX #$13C3            
$40FC  10 9E 60                           LDY <$60              
$40FF  AD 9F 0C B5                        JSR [$0CB5]            ; call via indexed pointer
$4103  17 EA B6            Sub_4103:      LBSR Sub_2BBC          ; call Sub_2BBC
$4106  25 AE                              BCS Sub_40B6           ; C=1 (BLO)
$4108  81 06                              CMPA #$06             
$410A  27 14                              BEQ Sub_4120          
$410C  81 15                              CMPA #$15             
$410E  26 F3                              BNE Sub_4103          
$4110  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$4111  5D                                 TSTB                  
$4112  96 5D                              LDA <$5D              
$4114  81 09                              CMPA #$09             
$4116  22 9E                              BHI Sub_40B6          
$4118  17 FD A7                           LBSR Sub_3EC2          ; call Sub_3EC2
$411B  17 DE 4D                           LBSR Sub_1F6B          ; call Sub_1F6B
$411C  DE 4D               Sub_411C:      LDU <$4D              
$411E  20 D7               Insn_411E:     BRA Sub_40F7          
$4120  0D                  Sub_4120:      EQU    $4120            ; [*60] branch target 2 byte(s) inside Insn_411E -- see [*60]
$4121  74 10 26                           LSR $1026             
$4124  F8 69 CC                           EORB $69CC            
$4127  00                                 FCB    $00                ; undefined opcode $00 -- not a valid 6809 instruction
$4128  01                                 FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
$4129  DD 5E                              STD <$5E              
$412B  17 FD AA                           LBSR Sub_3ED8          ; call Sub_3ED8
$412E  DC 62                              LDD <$62              
$4130  C3 00 05                           ADDD #$0005           
$4133  DD 60                              STD <$60              
$4135  17 EA 84                           LBSR Sub_2BBC          ; call Sub_2BBC
$4138  10 25 FF 7A                        LBCS Sub_40B6         
$413C  81 43                              CMPA #$43              ; compare A with 'C'
$413E  26 E0                              BNE Sub_4120          
$4140  96 38                              LDA <$38              
$4142  8E 00 EC                           LDX #$00EC            
$4145  10 9E 60                           LDY <$60              
$4148  AD 9F 0C B5                        JSR [$0CB5]            ; call via indexed pointer
$414C  16 FE BD                           LBRA Sub_400C         

; --------------------------------------------------------------
$414F  34 16               Sub_414F:      PSHS A,B,X            
$4151  7D 0C C2                           TST $0CC2             
$4154  27 25                              BEQ Sub_417B          
$4156  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$4157  57                                 ASRB                  
$4158  4D                                 TSTA                  
$4159  26 03                              BNE Sub_415E          
$415B  5D                                 TSTB                  
$415C  2A 02                              BPL Sub_4160          
$415E  C6 80               Sub_415E:      LDB #$80              
$4160  A6 80               Sub_4160:      LDA ,X+               
$4162  2B 17                              BMI Sub_417B          
$4164  27 10                              BEQ Sub_4176          
$4166  81 1F                              CMPA #$1F             
$4168  22 0C                              BHI Sub_4176          
$416A  81 0D                              CMPA #$0D              ; compare A with CR
$416C  27 08                              BEQ Sub_4176          
$416E  81 0A                              CMPA #$0A              ; compare A with LF
$4170  27 04                              BEQ Sub_4176          
$4172  81 09                              CMPA #$09             
$4174  26 05                              BNE Sub_417B          
$4176  5A                  Sub_4176:      DECB                  
$4177  26 E7                              BNE Sub_4160          
$4179  35 96               Insn_4179:     PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
$417B  0F                  Sub_417B:      EQU    $417B            ; [*61] branch target 2 byte(s) inside Insn_4179 -- see [*61]
$417C  57                                 ASRB                  
$417D  35 96                              PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$417F  CC 15 04            Sub_417F:      LDD #$1504            
$4182  FD 0C 9A                           STD $0C9A             
$4185  CC 25 07                           LDD #$2507            
$4188  FD 0C 9C                           STD $0C9C             
$418B  17 DD 63                           LBSR Sub_1EF1          ; call Sub_1EF1
$418E  30 8D C3 23                        LEAX Dat_04B5,PC       ; X → Dat_04B5
$4192  17 DC 00                           LBSR Sub_1D95          ; call Sub_1D95
$4195  7D 0C AA                           TST $0CAA             
$4198  10 27 01 BE                        LBEQ Sub_435A         
$419C  30 8D C8 2D                        LEAX Dat_09CD,PC       ; X → Dat_09CD
$41A0  17 DB F2                           LBSR Sub_1D95          ; call Sub_1D95
$41A3  30 8D C3 9B                        LEAX Dat_0542,PC       ; X → Dat_0542
$41A7  17 DB EB                           LBSR Sub_1D95          ; call Sub_1D95
$41AA  30 8D C3 03                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$41AE  17 DB E4                           LBSR Sub_1D95          ; call Sub_1D95
$41B0  E4 0D               Sub_41B0:      ANDB 13,X             
$41B2  34 27                              PSHS CC,A,B,Y         
$41B4  54                                 LSRB                  
$41B5  30 8D C8 6A                        LEAX Dat_0A23,PC       ; X → Dat_0A23
$41B9  17 DB D9                           LBSR Sub_1D95          ; call Sub_1D95
$41BC  8E 00 CC                           LDX #$00CC            
$41BF  86 01                              LDA #$01              
$41C1  10 9E 2D                           LDY <$2D              
$41C4  31 3F                              LEAY -1,Y             
$41C6  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$41C9  30 8D C8 19                        LEAX Dat_09E6,PC       ; X → Dat_09E6
$41CD  17 DB C5                           LBSR Sub_1D95          ; call Sub_1D95
$41D0  17 EA 8F            Sub_41D0:      LBSR Sub_2C62          ; call Sub_2C62
$41D3  81 59               Sub_41D3:      CMPA #$59              ; compare A with 'Y'
$41D5  27 12                              BEQ Sub_41E9          
$41D7  81 0D                              CMPA #$0D              ; compare A with CR
$41D9  27 0E                              BEQ Sub_41E9          
$41DB  81 4E                              CMPA #$4E              ; compare A with 'N'
$41DD  10 27 00 A6                        LBEQ Sub_4287         
$41E1  81 05                              CMPA #$05             
$41E3  10 27 00 A0                        LBEQ Sub_4287         
$41E7  20 E7                              BRA Sub_41D0          

; --------------------------------------------------------------
$41E9  17 04 3E            Sub_41E9:      LBSR Sub_462A          ; call Sub_462A
$41EC  17 01 F6                           LBSR Sub_43E5          ; call Sub_43E5
$41EF  96 37                              LDA <$37              
$41F1  10 3F 8F                           OS9 I$Close            ; path=A
$41F4  10 25 00 9B                        LBCS Sub_4293         
$41F8  86 FF                              LDA #$FF              
$41FA  97 37                              STA <$37              
$41FC  97 4F                              STA <$4F              
$41FD  4F                  Sub_41FD:      CLRA                   ; A = 0
$41FE  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$41FF  57                                 ASRB                  
$4200  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$4201  34 0F                              PSHS CC,A,B,DP        
$4203  35 17                              PULS CC,A,B,X         
$4205  E3 9B                              ADDD [D,X]            
$4207  20 7E               Insn_4207:     BRA Sub_4287          
$4209  0D                  Sub_4209:      EQU    $4209            ; [*62] branch target 2 byte(s) inside Insn_4207 -- see [*62]
$420A  2F 26                              BLE Sub_4232          
$420C  21 30                              BRN Sub_423E          
$420E  8D C3               Sub_420E:      BSR Sub_41D3           ; call Sub_41D3
$4210  74 17 DB                           LSR $17DB             
$4213  81 C6                              CMPA #$C6             
$4215  1E 17                              EXG X,V               
$4217  DB D7                              ADDB <$D7             
$4219  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$421A  30 26                              LEAX 6,Y              
$421C  6A DC 2B                           DEC [+43,PC]          
$421F  DD 2D                              STD <$2D              
$4221  8E 06 1B                           LDX #$061B            
$4224  10 8E 00 CC                        LDY #$00CC            
$4228  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$422A  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$422E  8E 00 CC            Sub_422E:      LDX #$00CC            
$4231  A6 84                              LDA ,X                
$4232  84 81               Sub_4232:      ANDA #$81             
$4234  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$4235  27 50                              BEQ Sub_4287          
$4237  86 02                              LDA #$02               ; A = CurXY
$4239  C6 03                              LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
$423B  10 3F 83                           OS9 I$Create           ; mode=B  name→X  → path→A
$423E  24 1E               Sub_423E:      BCC Sub_425E           ; C=0 (BHS)
$4240  C1 DA                              CMPB #$DA             
$4242  26 4F                              BNE Sub_4293          
$4244  30 8D C7 E1                        LEAX Dat_0A29,PC       ; X → Dat_0A29
$4248  17 DB 4A                           LBSR Sub_1D95          ; call Sub_1D95
$424B  17 EA 14            Sub_424B:      LBSR Sub_2C62          ; call Sub_2C62
$424E  81 41                              CMPA #$41              ; compare A with 'A'
$4250  27 69                              BEQ Sub_42BB          
$4252  81 4F                              CMPA #$4F              ; compare A with 'O'
$4254  10 27 00 8A                        LBEQ Sub_42E2         
$4258  81 0D                              CMPA #$0D              ; compare A with CR
$425A  27 2B                              BEQ Sub_4287          
$425C  20 ED               Sub_425C:      BRA Sub_424B          
$425E  97 37               Sub_425E:      STA <$37              
$4260  97 4F               Insn_4260:     STA <$4F              
$4262  0C                  Sub_4262:      EQU    $4262            ; [*63] branch target 2 byte(s) inside Insn_4260 -- see [*63]
$4263  34 0C                              PSHS B,DP             
$4265  57                  Sub_4265:      ASRB                  
$4266  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$4267  33 26                              LEAU 6,Y              
$4269  1D                                 SEX                    ; sign-extend B into A
$426A  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$426B  35 17                              PULS CC,A,B,X         
$426D  E3 31                              ADDD -15,Y            
$426F  D6 1B                              LDB <$1B              
$4271  D0 19                              SUBB <$19             
$4273  4F                                 CLRA                   ; A = 0
$4274  34 06                              PSHS A,B              
$4276  96 15               Sub_4276:      LDA <$15              
$4278  27 03                              BEQ Sub_427D          
$427A  4A                                 DECA                  
$427B  90 16                              SUBA <$16             
$427D  C6 20               Sub_427D:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$427F  3D                                 MUL                    ; D = A×B unsigned
$4280  E3 E1                              ADDD ,S++             
$4282  DD 08                              STD <$08              
$4284  17 01 7C            Insn_4284:     LBSR Sub_4403          ; call Sub_4403
$4287  0F                  Sub_4287:      EQU    $4287            ; [*64] branch target 3 byte(s) inside Insn_4284 -- see [*64]
$4288  33 17                              LEAU -9,X             
$428A  DC C7                              LDD <$C7              
$428C  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$428D  2F 10                              BLE Sub_429F          
$428F  27 CB                              BEQ Sub_425C          
$4291  98 39                              EORA <$39             
$4293  86 07               Sub_4293:      LDA #$07              
$4295  17 DE A3                           LBSR Sub_213B          ; call Sub_213B
$4298  34 04                              PSHS B                
$429A  CC 0D 02                           LDD #$0D02            
$429D  17 E2 3C                           LBSR Sub_24DC          ; call Sub_24DC
$429F  3C 30               Sub_429F:      CWAI #$30             
$42A1  8D C2                              BSR Sub_4265           ; call Sub_4265
$42A3  11 17                              FCB $11,$17            ; unknown opcode $1117
$42A5  DA EE                              ORB <$EE              
$42A7  35 04                              PULS B                
$42A9  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$42AC  8E 00 3C                           LDX #$003C            
$42AF  17 CE C6                           LBSR Sub_1178          ; call Sub_1178
$42B2  30 8D C1 FB                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$42B6  17 DA DC                           LBSR Sub_1D95          ; call Sub_1D95
$42B9  20 CC                              BRA Sub_4287          

; --------------------------------------------------------------
$42BB  8E 00 CC            Sub_42BB:      LDX #$00CC            
$42BE  86 03                              LDA #$03              
$42C0  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$42C3  24 0B                              BCC Sub_42D0           ; C=0 (BHS)
$42C5  10 3F 0F                           OS9 F$PErr             ; path=A  error=B
$42C8  8E 00 3C                           LDX #$003C            
$42CB  17 CE AA                           LBSR Sub_1178          ; call Sub_1178
$42CE  20 C3                              BRA Sub_4293          

; --------------------------------------------------------------
$42D0  97 37               Sub_42D0:      STA <$37              
$42D2  97 4F                              STA <$4F              
$42D4  34 40                              PSHS U                
$42D6  C6 02                              LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
$42D8  10 3F 8D                           OS9 I$GetStt           ; path=A  subcode=B  buf→X
$42DB  10 3F 88                           OS9 I$Seek             ; path=A  mode=B  offset→X:D
$42DE  35 40                              PULS U                
$42E0  20 80                              BRA Sub_4262          

; --------------------------------------------------------------
$42E2  8E 00 CC            Sub_42E2:      LDX #$00CC            
$42E5  10 3F 87                           OS9 I$Delete           ; name→X
$42E8  16 FF 43                           LBRA Sub_422E         

; --------------------------------------------------------------
$42EB  34 36               Sub_42EB:      PSHS A,B,X,Y          
$42ED  8E 07 1A                           LDX #$071A            
$42F0  FC 0C 95                           LDD $0C95             
$42F3  17 03 9B                           LBSR Sub_4691          ; call Sub_4691
$42F6  D6 1B                              LDB <$1B              
$42F8  D0 19                              SUBB <$19             
$42FA  4F                                 CLRA                   ; A = 0
$42FB  34 06                              PSHS A,B              
$42FD  96 15                              LDA <$15              
$42FF  27 03                              BEQ Sub_4304          
$4301  4A                                 DECA                  
$4302  90 16                              SUBA <$16             
$4304  C6 20               Sub_4304:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$4306  3D                                 MUL                    ; D = A×B unsigned
$4307  E3 E1                              ADDD ,S++             
$4309  10 93 08                           CMPD <$08             
$430C  27 03                              BEQ Sub_4311          
$430E  17 00 F2                           LBSR Sub_4403          ; call Sub_4403
$4311  35 B6               Sub_4311:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
$4313  34 36               Sub_4313:      PSHS A,B,X,Y          
$4315  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$4316  33 9E 00                           LEAU [Sub_4319,PC]    
$4319  A6 80               Sub_4319:      LDA ,X+               
$431B  81 0D                              CMPA #$0D              ; compare A with CR
$431D  27 37                              BEQ Sub_4356          
$431F  81 66                              CMPA #$66              ; compare A with 'f'
$4321  27 04                              BEQ Sub_4327          
$4323  81 46                              CMPA #$46              ; compare A with 'F'
$4325  26 F2                              BNE Sub_4319          
$4327  A6 1E               Sub_4327:      LDA -2,X              
$4329  81 20                              CMPA #$20              ; compare A with ' '
$432B  27 06                              BEQ Sub_4333          
$432D  81 2D                              CMPA #$2D              ; compare A with '-'
$432F  26 E8                              BNE Sub_4319          
$4331  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$4332  33 A6                              LEAU A,Y              
$4333  A6 80               Sub_4333:      LDA ,X+               
$4335  81 3D                              CMPA #$3D              ; compare A with '='
$4337  26 E0                              BNE Sub_4319          
$4339  10 8E 00 CC                        LDY #$00CC            
$433D  5F                                 CLRB                   ; B = 0
$433E  A6 80               Sub_433E:      LDA ,X+               
$4340  A7 A0                              STA ,Y+               
$4342  5C                                 INCB                  
$4343  81 0D                              CMPA #$0D              ; compare A with CR
$4345  27 04                              BEQ Sub_434B          
$4347  C1 20                              CMPB #$20              ; compare B with ' '
$4349  25 F3                              BCS Sub_433E           ; C=1 (BLO)
$434B  4F                  Sub_434B:      CLRA                   ; A = 0
$434C  DD 2D                              STD <$2D              
$434E  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$434F  2F 7C                              BLE Sub_43CD          
$4351  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$4352  AA 17                              ORA -9,X              
$4354  FE 29 0F            Insn_4354:     LDU $290F             
$4356  0F                  Sub_4356:      EQU    $4356            ; [*65] branch target 2 byte(s) inside Insn_4354 -- see [*65]
$4357  2F 35                              BLE Sub_438E          
$4359  B6 30 8D                           LDA $308D             
$435A  30 8D C6 B0         Sub_435A:      LEAX Dat_0A0E,PC       ; X → Dat_0A0E
$435E  17 DA 34                           LBSR Sub_1D95          ; call Sub_1D95
$4361  30 8D C1 4C                        LEAX Dat_04B1,PC       ; X → Dat_04B1
$4365  17 DA 2D                           LBSR Sub_1D95          ; call Sub_1D95
$4368  30 8D C2 19                        LEAX Dat_0585,PC       ; X → Dat_0585
$436C  17 DA 26                           LBSR Sub_1D95          ; call Sub_1D95
$436F  C6 1E                              LDB #$1E              
$4371  17 DA 7C                           LBSR Sub_1DF0          ; call Sub_1DF0
$4374  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$4375  30 26                              LEAX 6,Y              
$4377  5B                                 FCB    $5B                ; undefined opcode $5B -- not a valid 6809 instruction
$4378  8E 06 1B                           LDX #$061B            
$437B  10 8E 13 C3                        LDY #$13C3            
$437F  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$4381  AD 9F 0C AF                        JSR [$0CAF]            ; call via indexed pointer
$4385  8E 13 C3                           LDX #$13C3            
$4388  A6 84                              LDA ,X                
$438A  81 0D                              CMPA #$0D              ; compare A with CR
$438C  27 45                              BEQ Sub_43D3          
$438E  86 01               Sub_438E:      LDA #$01              
$4390  10 3F 84                           OS9 I$Open             ; mode=B  name→X  → path→A
$4393  25 3E                              BCS Sub_43D3           ; C=1 (BLO)
$4395  97 39                              STA <$39              
$4397  86 01                              LDA #$01              
$4399  97 32                              STA <$32              
$439B  17 DB B5                           LBSR Sub_1F53          ; call Sub_1F53
$439E  96 39               Sub_439E:      LDA <$39              
$43A0  8E 13 C3                           LDX #$13C3            
$43A3  10 8E 00 FF                        LDY #$00FF            
$43A7  10 3F 8B                           OS9 I$ReadLn           ; path=A  max=Y  buf→X
$43AA  25 1D                              BCS Sub_43C9           ; C=1 (BLO)
$43AC  96 38                              LDA <$38              
$43AE  8E 13 C3                           LDX #$13C3            
$43B1  10 3F 8C                           OS9 I$WritLn           ; path=A  buf→X
$43B4  17 D1 ED                           LBSR Sub_15A4          ; call Sub_15A4
$43B7  24 1F                              BCC Sub_43D8           ; C=0 (BHS)
$43B9  16 CA 6E            Sub_43B9:      LBRA Sub_0E2A         
$43BC  8E 00 04            Sub_43BC:      LDX #$0004            
$43BF  17 CD B6                           LBSR Sub_1178          ; call Sub_1178
$43C2  17 D1 E3                           LBSR Sub_15A8          ; call Sub_15A8
$43C5  24 F2                              BCC Sub_43B9           ; C=0 (BHS)
$43C7  20 D5                              BRA Sub_439E          

; --------------------------------------------------------------
$43C9  96 39               Sub_43C9:      LDA <$39              
$43CB  10 3F 8F            Insn_43CB:     OS9 I$Close            ; path=A
$43CD  8F                  Sub_43CD:      EQU    $43CD            ; [*66] branch target 2 byte(s) inside Insn_43CB -- see [*66]
$43CE  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$43CF  32 16                              LEAS -10,X            
$43D0  16 CA 57            Sub_43D0:      LBRA Sub_0E2A         
$43D3  17 DB 7D            Sub_43D3:      LBSR Sub_1F53          ; call Sub_1F53
$43D6  20 F8                              BRA Sub_43D0          

; --------------------------------------------------------------
$43D8  17 E8 87            Sub_43D8:      LBSR Sub_2C62          ; call Sub_2C62
$43DB  81 03                              CMPA #$03             
$43DD  27 EA                              BEQ Sub_43C9          
$43DF  81 05                              CMPA #$05             
$43E1  27 E6                              BEQ Sub_43C9          
$43E3  20 D4                              BRA Sub_43B9          

; --------------------------------------------------------------
$43E5  34 36               Sub_43E5:      PSHS A,B,X,Y          
$43E7  8E 13 C3                           LDX #$13C3            
$43EA  CC 02 68                           LDD #$0268            
$43ED  ED 84                              STD ,X                
$43EF  CC 20 20                           LDD #$2020            
$43F2  ED 02                              STD 2,X               
$43F4  ED 04                              STD 4,X               
$43F6  ED 06               Insn_43F6:     STD 6,X               

Dat_43F7
; ── 1 bytes  ($43F7—$43F7) ──
         FCB    $06               ; $06
$43F8  96 4B               Sub_43F8:      LDA <$4B              
$43FA  10 8E 00 08                        LDY #$0008            
$43FE  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4401  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$4403  34 36               Sub_4403:      PSHS A,B,X,Y          
$4405  DD 08                              STD <$08              
$4407  44                                 LSRA                  
$4408  56                                 RORB                  
$4409  44                                 LSRA                  
$440A  56                                 RORB                  
$440B  8E 13 C3                           LDX #$13C3            
$440E  10 8E 30 30                        LDY #$3030            
$4412  10 AF 03                           STY 3,X               
$4415  10 AF 05                           STY 5,X               
$4418  10 83 03 E8         Sub_4418:      CMPD #$03E8           
$441C  25 07                              BCS Sub_4425           ; C=1 (BLO)
$441E  83 03 E8                           SUBD #$03E8           
$4421  6C 03                              INC 3,X               
$4423  20 F3                              BRA Sub_4418          

; --------------------------------------------------------------
$4425  10 83 00 64         Sub_4425:      CMPD #$0064           
$4429  25 07                              BCS Sub_4432           ; C=1 (BLO)
$442B  83 00 64                           SUBD #$0064           
$442E  6C 04                              INC 4,X               
$4430  20 F3                              BRA Sub_4425          

; --------------------------------------------------------------
$4432  C1 0A               Sub_4432:      CMPB #$0A              ; compare B with LF
$4434  25 06                              BCS Sub_443C           ; C=1 (BLO)
$4436  C0 0A                              SUBB #$0A             
$4438  6C 05                              INC 5,X               
$443A  20 F6                              BRA Sub_4432          

; --------------------------------------------------------------
$443C  CB 30               Sub_443C:      ADDB #$30             
$443E  E7 06                              STB 6,X               
$4440  C6 20                              LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
$4442  A6 03                              LDA 3,X               
$4444  81 30                              CMPA #$30              ; compare A with '0'
$4446  26 12                              BNE Sub_445A          
$4448  E7 03                              STB 3,X               
$444A  A6 04                              LDA 4,X               
$444C  81 30                              CMPA #$30              ; compare A with '0'
$444E  26 0A                              BNE Sub_445A          
$4450  E7 04                              STB 4,X               
$4452  A6 05                              LDA 5,X               
$4454  81 30                              CMPA #$30              ; compare A with '0'
$4456  26 02                              BNE Sub_445A          
$4458  E7 05                              STB 5,X               
$445A  CC 02 68            Sub_445A:      LDD #$0268            
$445D  ED 84                              STD ,X                
$445F  86 20                              LDA #$20               ; A = ' '
$4461  A7 02                              STA 2,X               
$4463  86 4B                              LDA #$4B               ; A = 'K'
$4465  A7 07                              STA 7,X               
$4467  96 4B                              LDA <$4B              
$4469  10 8E 00 08                        LDY #$0008            
$446D  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4470  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$4472  34 36               Sub_4472:      PSHS A,B,X,Y          
$4474  8E 07 1A                           LDX #$071A            
$4477  F6 0C 96                           LDB $0C96             
$447A  10 9E 10                           LDY <$10              
$447D  A6 80               Sub_447D:      LDA ,X+               
$447F  A7 A0                              STA ,Y+               
$4481  5A                                 DECB                  
$4482  10 9C 0C                           CMPY <$0C             
$4485  25 03                              BCS Sub_448A           ; C=1 (BLO)
$4487  10 9E 0E                           LDY <$0E              
$448A  5D                  Sub_448A:      TSTB                  
$448B  26 F0                              BNE Sub_447D          
$448D  10 9F 10                           STY <$10              
$4490  35 B6                              PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
$4492  34 36               Sub_4492:      PSHS A,B,X,Y          
$4494  9E 10                              LDX <$10              
$4496  A6 82               Sub_4496:      LDA ,-X               
$4498  81 2E                              CMPA #$2E              ; compare A with '.'
$449A  27 0E                              BEQ Sub_44AA          
$449C  9C 0E               Sub_449C:      CMPX <$0E             
$449E  26 02                              BNE Sub_44A2          
$44A0  9E 0C                              LDX <$0C              
$44A2  9C 10               Sub_44A2:      CMPX <$10             
$44A4  26 F0                              BNE Sub_4496          
$44A6  0F                                 FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
$44A7  A8 35                              EORA -11,Y            
$44A9  B6 A6 01                           LDA $A601             
$44AA  A6 01               Sub_44AA:      LDA 1,X               
$44AC  81 2E                              CMPA #$2E              ; compare A with '.'
$44AE  25 EC                              BCS Sub_449C           ; C=1 (BLO)
$44B0  A6 1F                              LDA -1,X              
$44B2  81 2E                              CMPA #$2E              ; compare A with '.'
$44B4  25 E6                              BCS Sub_449C           ; C=1 (BLO)
$44B6  A6 82               Sub_44B6:      LDA ,-X               
$44B8  81 30                              CMPA #$30              ; compare A with '0'
$44BA  25 06                              BCS Sub_44C2           ; C=1 (BLO)
$44BC  9C 10                              CMPX <$10             
$44BE  27 E2                              BEQ Sub_44A2          
$44C0  20 F4                              BRA Sub_44B6          

; --------------------------------------------------------------
$44C2  A6 01               Sub_44C2:      LDA 1,X               
$44C4  81 41                              CMPA #$41              ; compare A with 'A'
$44C6  25 DA                              BCS Sub_44A2           ; C=1 (BLO)
$44C8  C6 1F                              LDB #$1F              
$44CA  30 01                              LEAX 1,X              
$44CC  10 8E 00 AC                        LDY #$00AC            
$44D0  A6 80               Sub_44D0:      LDA ,X+               
$44D2  81 2E               Sub_44D2:      CMPA #$2E              ; compare A with '.'
$44D4  25 15                              BCS Sub_44EB           ; C=1 (BLO)
$44D6  A7 A0                              STA ,Y+               
$44D8  5A                                 DECB                  
$44D9  27 10                              BEQ Sub_44EB          
$44DB  9C 0C                              CMPX <$0C             
$44DD  27 06                              BEQ Sub_44E5          
$44DF  9C 10                              CMPX <$10             
$44E1  27 08                              BEQ Sub_44EB          
$44E3  20 EB                              BRA Sub_44D0          

; --------------------------------------------------------------
$44E5  A6 84               Sub_44E5:      LDA ,X                
$44E7  9E 0E                              LDX <$0E              
$44E9  20 E7                              BRA Sub_44D2          

; --------------------------------------------------------------
$44EB  86 0D               Sub_44EB:      LDA #$0D               ; A = CR
$44ED  A7 A4                              STA ,Y                
$44EF  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$44F0  A8 20                              EORA 0,Y              
$44F2  B5 0F 1D            Insn_44F2:     BITA $0F1D            
$44F3  0F                  Sub_44F3:      EQU    $44F3            ; [*67] branch target 1 byte(s) inside Insn_44F2 -- see [*67]
$44F4  1D                                 SEX                    ; sign-extend B into A
$44F5  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$44F6  7B                                 FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
$44F7  10 27 00 C2                        LBEQ Sub_45BD         
$44FB  9E 00                              LDX <$00              
$44FD  A6 80               Sub_44FD:      LDA ,X+               
$44FF  81 0D                              CMPA #$0D              ; compare A with CR
$4501  10 27 00 B8                        LBEQ Sub_45BD         
$4505  81 62                              CMPA #$62              ; compare A with 'b'
$4507  27 04                              BEQ Sub_450D          
$4509  81 42                              CMPA #$42              ; compare A with 'B'
$450B  26 F0                              BNE Sub_44FD          
$450D  A6 1E               Sub_450D:      LDA -2,X              
$450F  81 20                              CMPA #$20              ; compare A with ' '
$4511  27 04                              BEQ Sub_4517          
$4513  81 2D                              CMPA #$2D              ; compare A with '-'
$4515  26 E6                              BNE Sub_44FD          
$4517  A6 80               Sub_4517:      LDA ,X+               
$4519  81 3D                              CMPA #$3D              ; compare A with '='
$451B  26 E0                              BNE Sub_44FD          
$451D  10 8E 13 C3                        LDY #$13C3            
$4521  5F                                 CLRB                   ; B = 0
$4522  A6 80               Sub_4522:      LDA ,X+               
$4524  81 30                              CMPA #$30              ; compare A with '0'
$4526  2B 0D                              BMI Sub_4535          
$4528  81 39                              CMPA #$39              ; compare A with '9'
$452A  22 09                              BHI Sub_4535          
$452C  80 30                              SUBA #$30             
$452E  A7 A0                              STA ,Y+               
$4530  5C                                 INCB                  
$4531  C1 03                              CMPB #$03             
$4533  25 ED                              BCS Sub_4522           ; C=1 (BLO)
$4535  5D                  Sub_4535:      TSTB                  
$4536  10 27 00 83                        LBEQ Sub_45BD         
$453A  4F                                 CLRA                   ; A = 0
$453B  34 06                              PSHS A,B              
$453D  34 02                              PSHS A                
$453F  E6 A2                              LDB ,-Y               
$4541  E7 61                              STB 1,S               
$4543  A6 62                              LDA 2,S               
$4545  4A                                 DECA                  
$4546  27 31                              BEQ Sub_4579          
$4548  A7 62                              STA 2,S               
$454A  E6 A2                              LDB ,-Y               
$454C  86 0A                              LDA #$0A               ; A = LF
$454E  3D                                 MUL                    ; D = A×B unsigned
$454F  E3 E4                              ADDD ,S               
$4551  ED E4                              STD ,S                
$4553  A6 62                              LDA 2,S               
$4555  4A                                 DECA                  
$4556  27 21                              BEQ Sub_4579          
$4558  A7 62                              STA 2,S               
$455A  E6 A2                              LDB ,-Y               
$455C  86 64                              LDA #$64               ; A = 'd'
$455E  3D                                 MUL                    ; D = A×B unsigned
$455F  E3 E4                              ADDD ,S               
$4561  ED E4                              STD ,S                
$4563  A6 62                              LDA 2,S               
$4565  4A                                 DECA                  
$4566  27 11                              BEQ Sub_4579          
$4568  4F                                 CLRA                   ; A = 0
$4569  5F                                 CLRB                   ; B = 0
$456A  6D A4                              TST ,Y                
$456C  27 07                              BEQ Sub_4575          
$456E  C3 03 E8                           ADDD #$03E8           
$4571  6A A4                              DEC ,Y                
$4573  20 F5                              BRA $456A             

; --------------------------------------------------------------
$4575  E3 E1               Sub_4575:      ADDD ,S++             
$4577  20 02                              BRA Sub_457B          

; --------------------------------------------------------------
$4579  35 06               Sub_4579:      PULS A,B              
$457B  32 61               Sub_457B:      LEAS 1,S              
$457D  C3 00 07                           ADDD #$0007           
$4580  44                                 LSRA                  
$4581  56                                 RORB                  
$4582  44                                 LSRA                  
$4583  56                                 RORB                  
$4584  44                                 LSRA                  
$4585  56                                 RORB                  
$4586  4D                                 TSTA                  
$4587  26 05                              BNE Sub_458E          
$4589  5D                                 TSTB                  
$458A  10 27 00 2F                        LBEQ Sub_45BD         
$458E  1F 01               Sub_458E:      TFR D,X               
$4590  D7 15                              STB <$15              
$4592  96 7B                              LDA <$7B              
$4594  C6 CA                              LDB #$CA              
$4596  10 3F 8E                           OS9 I$SetStt           ; path=A  subcode=B  buf→X
$4599  10 25 00 20                        LBCS Sub_45BD         
$459D  1F 10                              TFR X,D               
$459F  D7 14                              STB <$14              
$45A1  D7 16                              STB <$16              
$45A3  DB 15                              ADDB <$15             
$45A5  D7 15                              STB <$15              
$45A7  D6 14                              LDB <$14              
$45A9  34 40                              PSHS U                
$45AB  17 00 73                           LBSR Sub_4621          ; call Sub_4621
$45AE  DF 17                              STU <$17              
$45B0  DF 19                              STU <$19              
$45B2  33 C9 20 00                        LEAU 8192,U           
$45B6  DF 1B                              STU <$1B              
$45B8  35 40                              PULS U                
$45BA  0C                                 FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
$45BB  1D                                 SEX                    ; sign-extend B into A
$45BC  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$45BD  DC 04               Sub_45BD:      LDD <$04              
$45BF  DD 17                              STD <$17              
$45C1  DD 19                              STD <$19              
$45C3  DC 02                              LDD <$02              
$45C5  DD 1B                              STD <$1B              
$45C7  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$45C8  9E 17               Sub_45C8:      LDX <$17              
$45CA  DC 19                              LDD <$19              
$45CC  93 17                              SUBD <$17             
$45CE  1F 02                              TFR D,Y               
$45D0  96 4F                              LDA <$4F              
$45D2  2B 19                              BMI Sub_45ED          
$45D4  B6 0C C5                           LDA $0CC5             
$45D7  27 05                              BEQ Sub_45DE          
$45D9  97 50                              STA <$50              
$45DB  17 F8 7F                           LBSR Sub_3E5D          ; call Sub_3E5D
$45DE  96 4F               Sub_45DE:      LDA <$4F              
$45E0  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$45E3  B6 0C C4                           LDA $0CC4             
$45E6  27 05                              BEQ Sub_45ED          
$45E8  97 50                              STA <$50              
$45EA  17 F8 70                           LBSR Sub_3E5D          ; call Sub_3E5D
$45ED  DC 17               Sub_45ED:      LDD <$17              
$45EF  DD 19                              STD <$19              
$45F1  16 00 9B                           LBRA Sub_468F         

; --------------------------------------------------------------
$45F4  34 76               Sub_45F4:      PSHS A,B,X,Y,U        
$45F6  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$45F7  1D                                 SEX                    ; sign-extend B into A
$45F8  27 CE                              BEQ Sub_45C8          
$45FA  96 16                              LDA <$16              
$45FC  4C                                 INCA                  
$45FD  91 15                              CMPA <$15             
$45FF  26 04                              BNE Sub_4605          
$4601  8D 27                              BSR Sub_462A           ; call Sub_462A
$4603  20 12                              BRA Sub_4617          

; --------------------------------------------------------------
$4605  97 16               Sub_4605:      STA <$16              
$4607  8D 10                              BSR Sub_4619           ; call Sub_4619
$4609  1F 89                              TFR A,B               
$460B  8D 14                              BSR Sub_4621           ; call Sub_4621
$460D  DF 17                              STU <$17              
$460F  DF 19                              STU <$19              
$4611  33 C9 20 00                        LEAU 8192,U           
$4615  DF 1B                              STU <$1B              
$4617  35 F6               Sub_4617:      PULS A,B,X,Y,U,PC      ; return from subroutine  (PULS PC = RTS)
$4619  DE 17               Sub_4619:      LDU <$17              
$461B  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$461D  10 3F 50                           OS9 $50               
$4620  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$4621  4F                  Sub_4621:      CLRA                   ; A = 0
$4622  1F 01                              TFR D,X               
$4624  C6 01                              LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
$4626  10 3F 4F                           OS9 $4F               
$4629  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$462A  34 76               Sub_462A:      PSHS A,B,X,Y,U        
$462C  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$462D  1D                                 SEX                    ; sign-extend B into A
$462E  10 27 FF 96                        LBEQ Sub_45C8         
$4632  B6 0C C5                           LDA $0CC5             
$4635  27 05                              BEQ Sub_463C          
$4637  97 50                              STA <$50              
$4639  17 F8 21                           LBSR Sub_3E5D          ; call Sub_3E5D
$463C  96 14               Sub_463C:      LDA <$14              
$463E  34 02               Sub_463E:      PSHS A                
$4640  8D D7                              BSR Sub_4619           ; call Sub_4619
$4642  1F 89                              TFR A,B               
$4644  8D DB                              BSR Sub_4621           ; call Sub_4621
$4646  A6 E4                              LDA ,S                
$4648  91 16                              CMPA <$16             
$464A  27 12                              BEQ Sub_465E          
$464C  96 4F                              LDA <$4F              
$464E  2B 09                              BMI Sub_4659          
$4650  1F 31                              TFR U,X               
$4652  10 8E 20 00                        LDY #$2000            
$4656  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4659  35 02               Sub_4659:      PULS A                
$465B  4C                                 INCA                  
$465C  20 E0                              BRA Sub_463E          

; --------------------------------------------------------------
$465E  1F 31               Sub_465E:      TFR U,X               
$4660  DC 19                              LDD <$19              
$4662  93 17                              SUBD <$17             
$4664  27 15                              BEQ Sub_467B          
$4666  1F 02                              TFR D,Y               
$4668  96 4F                              LDA <$4F              
$466A  2B 0F                              BMI Sub_467B          
$466C  96 4F                              LDA <$4F              
$466E  10 3F 8A                           OS9 I$Write            ; path=A  count=Y  buf→X
$4671  B6 0C C4                           LDA $0CC4             
$4674  27 05                              BEQ Sub_467B          
$4676  97 50                              STA <$50              
$4678  17 F7 E2                           LBSR Sub_3E5D          ; call Sub_3E5D
$467B  35 02               Sub_467B:      PULS A                
$467D  8D 9A                              BSR Sub_4619           ; call Sub_4619
$467F  D6 14                              LDB <$14              
$4681  D7 16                              STB <$16              
$4683  8D 9C                              BSR Sub_4621           ; call Sub_4621
$4685  DF 17                              STU <$17              
$4687  DF 19                              STU <$19              
$4689  33 C9 20 00                        LEAU 8192,U           
$468D  DF 1B                              STU <$1B              
$468F  35 F6               Sub_468F:      PULS A,B,X,Y,U,PC      ; return from subroutine  (PULS PC = RTS)
$4691  34 26               Sub_4691:      PSHS A,B,Y            
$4693  10 83 00 00                        CMPD #$0000           
$4697  27 5F                              BEQ Sub_46F8          
$4699  34 06                              PSHS A,B              
$469B  DC 1B               Sub_469B:      LDD <$1B              
$469D  93 19                              SUBD <$19             
$469F  34 06                              PSHS A,B              
$46A1  EC 62                              LDD 2,S               
$46A3  A3 E4                              SUBD ,S               
$46A5  25 04                              BCS Sub_46AB           ; C=1 (BLO)
$46A7  ED 62                              STD 2,S               
$46A9  20 08                              BRA Sub_46B3          

; --------------------------------------------------------------
$46AB  EC 62               Sub_46AB:      LDD 2,S               
$46AD  ED E4                              STD ,S                
$46AF  4F                                 CLRA                   ; A = 0
$46B0  5F                                 CLRB                   ; B = 0
$46B1  ED 62                              STD 2,S               
$46B3  10 9E 19            Sub_46B3:      LDY <$19              
$46B6  0D                                 FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
$46B7  57                                 ASRB                  
$46B8  27 04                              BEQ Sub_46BE          
$46BA  8D 3E                              BSR Sub_46FA           ; call Sub_46FA
$46BC  20 0A               Insn_46BC:     BRA Sub_46C8          
$46BE  0D                  Sub_46BE:      EQU    $46BE            ; [*68] branch target 2 byte(s) inside Insn_46BC -- see [*68]
$46BF  28 27                              BVC Sub_46E8          
$46C1  04                                 FCB    $04                ; undefined opcode $04 -- not a valid 6809 instruction
$46C2  8D 20                              BSR Sub_46E4           ; call Sub_46E4
$46C4  20 02                              BRA Sub_46C8          

; --------------------------------------------------------------
$46C6  8D 0E               Sub_46C6:      BSR Sub_46D6           ; call Sub_46D6
$46C8  32 62               Sub_46C8:      LEAS 2,S              
$46CA  10 9F 19                           STY <$19              
$46CD  EC E4                              LDD ,S                
$46CF  27 1B                              BEQ Sub_46EC          
$46D1  17 FF 20                           LBSR Sub_45F4          ; call Sub_45F4
$46D4  20 C5                              BRA Sub_469B          

; --------------------------------------------------------------
$46D6  A6 80               Sub_46D6:      LDA ,X+               
$46D8  A7 A0                              STA ,Y+               
$46DA  EC 62                              LDD 2,S               
$46DC  83 00 01                           SUBD #$0001           
$46DF  ED 62                              STD 2,S               
$46E1  22 F3                              BHI Sub_46D6          
$46E3  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$46E4  EC 62               Sub_46E4:      LDD 2,S               
$46E6  1E 06                              EXG D,W               
$46E8  11 38 12            Sub_46E8:      BITMD #$12             ; 6309: test MD register bits
$46EB  39                                 RTS                    ; return from subroutine

; --------------------------------------------------------------
$46EC  DC 19               Sub_46EC:      LDD <$19              
$46EE  10 93 1B                           CMPD <$1B             
$46F1  25 03                              BCS Sub_46F6           ; C=1 (BLO)
$46F3  17 FE FE                           LBSR Sub_45F4          ; call Sub_45F4
$46F6  32 62               Sub_46F6:      LEAS 2,S              
$46F8  35 A6               Sub_46F8:      PULS A,B,Y,PC          ; return from subroutine  (PULS PC = RTS)
$46FA  A6 80               Sub_46FA:      LDA ,X+               
$46FC  81 1F                              CMPA #$1F             
$46FE  22 08                              BHI Sub_4708          
$4700  81 0A                              CMPA #$0A              ; compare A with LF
$4702  27 06                              BEQ Sub_470A          
$4704  81 1A                              CMPA #$1A              ; compare A with SUB
$4706  27 02                              BEQ Sub_470A          
$4708  A7 A0               Sub_4708:      STA ,Y+               
$470A  EC 62               Sub_470A:      LDD 2,S               
$470C  83 00 01                           SUBD #$0001           
$470F  ED 62                              STD 2,S               
$4711  22 E7                              BHI Sub_46FA          
$4713  39                                 RTS                    ; return from subroutine

; ==============================================================
; ModEnd — CRC-24 appended by fixmod (not in source)
; ==============================================================
ModEnd
ModSize  EQU    ModEnd-$0000

; ══════════════════════════════════════════════════════════════
; ANALYST NOTES
; ══════════════════════════════════════════════════════════════

; [*1] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0C47 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0C46).
;      Byte $00 at $0C47 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $00 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $00 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0C47 EQU Insn_0C46+1' resolves
;      to $0C47 at assembly time. Branches to Sub_0C47
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*2] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0C5F is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0C5E).
;      Byte $0C at $0C5F is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0C5F EQU Insn_0C5E+1' resolves
;      to $0C5F at assembly time. Branches to Sub_0C5F
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*3] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0C79 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0C78).
;      Byte $0C at $0C79 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0C79 EQU Insn_0C78+1' resolves
;      to $0C79 at assembly time. Branches to Sub_0C79
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*4] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0D4A is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0D48).
;      Byte $09 at $0D4A is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $09 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $09 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0D4A EQU Insn_0D48+2' resolves
;      to $0D4A at assembly time. Branches to Sub_0D4A
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*5] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0E71 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0E70).
;      Byte $07 at $0E71 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $07 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $07 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0E71 EQU Insn_0E70+1' resolves
;      to $0E71 at assembly time. Branches to Sub_0E71
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*6] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0EB8 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0EB7).
;      Byte $0D at $0EB8 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0EB8 EQU Insn_0EB7+1' resolves
;      to $0EB8 at assembly time. Branches to Sub_0EB8
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*7] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0ED5 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0ED4).
;      Byte $0F at $0ED5 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0ED5 EQU Insn_0ED4+1' resolves
;      to $0ED5 at assembly time. Branches to Sub_0ED5
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*8] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0EE4 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0EE3).
;      Byte $0C at $0EE4 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0EE4 EQU Insn_0EE3+1' resolves
;      to $0EE4 at assembly time. Branches to Sub_0EE4
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*9] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0F95 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0F94).
;      Byte $06 at $0F95 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $06 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $06 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0F95 EQU Insn_0F94+1' resolves
;      to $0F95 at assembly time. Branches to Sub_0F95
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*10] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $0F9C is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_0F99).
;      Byte $0F at $0F9C is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_0F9C EQU Insn_0F99+3' resolves
;      to $0F9C at assembly time. Branches to Sub_0F9C
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*11] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1022 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_101F).
;      Byte $4B at $1022 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $4B is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $4B may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1022 EQU Insn_101F+3' resolves
;      to $1022 at assembly time. Branches to Sub_1022
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*12] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $102D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_102B).
;      Byte $06 at $102D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $06 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $06 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_102D EQU Insn_102B+2' resolves
;      to $102D at assembly time. Branches to Sub_102D
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*13] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $103F is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_103D).
;      Byte $05 at $103F is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $05 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $05 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_103F EQU Insn_103D+2' resolves
;      to $103F at assembly time. Branches to Sub_103F
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*14] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1045 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_1043).
;      Byte $02 at $1045 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $02 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $02 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1045 EQU Insn_1043+2' resolves
;      to $1045 at assembly time. Branches to Sub_1045
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*15] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $10FA is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_10F7).
;      Byte $0D at $10FA is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_10FA EQU Insn_10F7+3' resolves
;      to $10FA at assembly time. Branches to Sub_10FA
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*16] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1154 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_1151).
;      Byte $03 at $1154 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $03 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $03 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1154 EQU Insn_1151+3' resolves
;      to $1154 at assembly time. Branches to Sub_1154
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*17] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $122E is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_122B).
;      Byte $0D at $122E is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_122E EQU Insn_122B+3' resolves
;      to $122E at assembly time. Branches to Sub_122E
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*18] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $123E is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_123D).
;      Byte $0D at $123E is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_123E EQU Insn_123D+1' resolves
;      to $123E at assembly time. Branches to Sub_123E
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*19] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $129F is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_129C).
;      Byte $0F at $129F is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_129F EQU Insn_129C+3' resolves
;      to $129F at assembly time. Branches to Sub_129F
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*20] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $12DF is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_12DD).
;      Byte $02 at $12DF is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $02 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $02 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_12DF EQU Insn_12DD+2' resolves
;      to $12DF at assembly time. Branches to Sub_12DF
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*21] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $145E is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_145D).
;      Byte $06 at $145E is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $06 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $06 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_145E EQU Insn_145D+1' resolves
;      to $145E at assembly time. Branches to Sub_145E
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*22] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1468 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_1467).
;      Byte $06 at $1468 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $06 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $06 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1468 EQU Insn_1467+1' resolves
;      to $1468 at assembly time. Branches to Sub_1468
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*23] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1490 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_148F).
;      Byte $04 at $1490 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $04 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $04 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1490 EQU Sub_148F+1' resolves
;      to $1490 at assembly time. Branches to Sub_1490
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*24] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $160E is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_160D).
;      Byte $06 at $160E is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $06 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $06 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_160E EQU Sub_160D+1' resolves
;      to $160E at assembly time. Branches to Sub_160E
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*25] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $19AD is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_19AC).
;      Byte $0D at $19AD is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_19AD EQU Sub_19AC+1' resolves
;      to $19AD at assembly time. Branches to Sub_19AD
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*26] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $19BD is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_19BA).
;      Byte $0C at $19BD is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_19BD EQU Sub_19BA+3' resolves
;      to $19BD at assembly time. Branches to Sub_19BD
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*27] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1BDB is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_1BDA).
;      Byte $0D at $1BDB is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1BDB EQU Insn_1BDA+1' resolves
;      to $1BDB at assembly time. Branches to Sub_1BDB
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*28] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1CF9 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_1CF8).
;      Byte $38 at $1CF9 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $38 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $38 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1CF9 EQU Insn_1CF8+1' resolves
;      to $1CF9 at assembly time. Branches to Sub_1CF9
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*29] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1D16 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_1D15).
;      Byte $1B at $1D16 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $1B is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $1B may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1D16 EQU Insn_1D15+1' resolves
;      to $1D16 at assembly time. Branches to Sub_1D16
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*30] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1E22 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_1E21).
;      Byte $05 at $1E22 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $05 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $05 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_1E22 EQU Sub_1E21+1' resolves
;      to $1E22 at assembly time. Branches to Sub_1E22
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*31] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $20A3 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_20A2).
;      Byte $0C at $20A3 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_20A3 EQU Insn_20A2+1' resolves
;      to $20A3 at assembly time. Branches to Sub_20A3
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*32] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $20E8 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_20E5).
;      Byte $05 at $20E8 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $05 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $05 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_20E8 EQU Insn_20E5+3' resolves
;      to $20E8 at assembly time. Branches to Sub_20E8
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*33] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $248B is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_2488).
;      Byte $0C at $248B is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_248B EQU Insn_2488+3' resolves
;      to $248B at assembly time. Branches to Sub_248B
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*34] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $25B0 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_25AE).
;      Byte $0D at $25B0 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_25B0 EQU Sub_25AE+2' resolves
;      to $25B0 at assembly time. Branches to Sub_25B0
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*35] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $25F2 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_25F1).
;      Byte $0D at $25F2 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_25F2 EQU Insn_25F1+1' resolves
;      to $25F2 at assembly time. Branches to Sub_25F2
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*36] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $26AE is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_26AC).
;      Byte $0D at $26AE is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_26AE EQU Sub_26AC+2' resolves
;      to $26AE at assembly time. Branches to Sub_26AE
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*37] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $270D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $00 at $270D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $00 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $00 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*38] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $27AB is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_27A8).
;      Byte $0F at $27AB is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_27AB EQU Insn_27A8+3' resolves
;      to $27AB at assembly time. Branches to Sub_27AB
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*39] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $2832 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_2830).
;      Byte $0D at $2832 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_2832 EQU Sub_2830+2' resolves
;      to $2832 at assembly time. Branches to Sub_2832
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*40] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $28C7 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_28C5).
;      Byte $0F at $28C7 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_28C7 EQU Sub_28C5+2' resolves
;      to $28C7 at assembly time. Branches to Sub_28C7
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*41] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $2C92 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_2C90).
;      Byte $0D at $2C92 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_2C92 EQU Sub_2C90+2' resolves
;      to $2C92 at assembly time. Branches to Sub_2C92
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*42] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $2D87 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_2D86).
;      Byte $0D at $2D87 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_2D87 EQU Insn_2D86+1' resolves
;      to $2D87 at assembly time. Branches to Sub_2D87
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*43] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $30ED is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_30EB).
;      Byte $0C at $30ED is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_30ED EQU Insn_30EB+2' resolves
;      to $30ED at assembly time. Branches to Sub_30ED
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*44] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $314D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_314C).
;      Byte $01 at $314D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $01 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $01 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_314D EQU Insn_314C+1' resolves
;      to $314D at assembly time. Branches to Sub_314D
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*45] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3563 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3560).
;      Byte $0D at $3563 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3563 EQU Insn_3560+3' resolves
;      to $3563 at assembly time. Branches to Sub_3563
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*46] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3741 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3740).
;      Byte $0E at $3741 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0E is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0E may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3741 EQU Insn_3740+1' resolves
;      to $3741 at assembly time. Branches to Sub_3741
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*47] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $391B is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3918).
;      Byte $0D at $391B is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_391B EQU Insn_3918+3' resolves
;      to $391B at assembly time. Branches to Sub_391B
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*48] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $393A is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3938).
;      Byte $0D at $393A is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_393A EQU Insn_3938+2' resolves
;      to $393A at assembly time. Branches to Sub_393A
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*49] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3942 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3941).
;      Byte $00 at $3942 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $00 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $00 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3942 EQU Insn_3941+1' resolves
;      to $3942 at assembly time. Branches to Sub_3942
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*50] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $397B is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Sub_3978).
;      Byte $0F at $397B is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_397B EQU Sub_3978+3' resolves
;      to $397B at assembly time. Branches to Sub_397B
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*51] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3B36 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3B34).
;      Byte $0D at $3B36 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3B36 EQU Insn_3B34+2' resolves
;      to $3B36 at assembly time. Branches to Sub_3B36
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*52] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3B97 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3B96).
;      Byte $0C at $3B97 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3B97 EQU Insn_3B96+1' resolves
;      to $3B97 at assembly time. Branches to Sub_3B97
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*53] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3BBE is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3BBC).
;      Byte $0C at $3BBE is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3BBE EQU Insn_3BBC+2' resolves
;      to $3BBE at assembly time. Branches to Sub_3BBE
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*54] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3F02 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3F01).
;      Byte $0D at $3F02 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3F02 EQU Insn_3F01+1' resolves
;      to $3F02 at assembly time. Branches to Sub_3F02
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*55] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3F46 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3F44).
;      Byte $1B at $3F46 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $1B is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $1B may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3F46 EQU Insn_3F44+2' resolves
;      to $3F46 at assembly time. Branches to Sub_3F46
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*56] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3F58 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3F56).
;      Byte $01 at $3F58 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $01 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $01 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3F58 EQU Insn_3F56+2' resolves
;      to $3F58 at assembly time. Branches to Sub_3F58
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*57] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $3FA9 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_3FA6).
;      Byte $0F at $3FA9 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_3FA9 EQU Insn_3FA6+3' resolves
;      to $3FA9 at assembly time. Branches to Sub_3FA9
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*58] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $4023 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_4021).
;      Byte $0C at $4023 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_4023 EQU Insn_4021+2' resolves
;      to $4023 at assembly time. Branches to Sub_4023
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*59] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $404D is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_404A).
;      Byte $0F at $404D is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_404D EQU Insn_404A+3' resolves
;      to $404D at assembly time. Branches to Sub_404D
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*60] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $4120 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_411E).
;      Byte $0D at $4120 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_4120 EQU Insn_411E+2' resolves
;      to $4120 at assembly time. Branches to Sub_4120
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*61] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $417B is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_4179).
;      Byte $0F at $417B is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_417B EQU Insn_4179+2' resolves
;      to $417B at assembly time. Branches to Sub_417B
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*62] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $4209 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_4207).
;      Byte $0D at $4209 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_4209 EQU Insn_4207+2' resolves
;      to $4209 at assembly time. Branches to Sub_4209
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*63] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $4262 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_4260).
;      Byte $0C at $4262 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0C is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0C may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_4262 EQU Insn_4260+2' resolves
;      to $4262 at assembly time. Branches to Sub_4262
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*64] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $4287 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_4284).
;      Byte $0F at $4287 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_4287 EQU Insn_4284+3' resolves
;      to $4287 at assembly time. Branches to Sub_4287
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*65] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $4356 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_4354).
;      Byte $0F at $4356 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_4356 EQU Insn_4354+2' resolves
;      to $4356 at assembly time. Branches to Sub_4356
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*66] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $43CD is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_43CB).
;      Byte $8F at $43CD is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $8F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $8F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_43CD EQU Insn_43CB+2' resolves
;      to $43CD at assembly time. Branches to Sub_43CD
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*67] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $44F3 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_44F2).
;      Byte $0F at $44F3 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_44F3 EQU Insn_44F2+1' resolves
;      to $44F3 at assembly time. Branches to Sub_44F3
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*68] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $46BE is referenced as a branch target but falls
;      inside the operand of a preceding instruction (Insn_46BC).
;      Byte $0D at $46BE is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;      The EQU expression 'Sub_46BE EQU Insn_46BC+2' resolves
;      to $46BE at assembly time. Branches to Sub_46BE
;      will target the correct address and the assembled binary
;      WILL match the original at those branch sites.
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; ══════════════════════════════════════════════════════════════