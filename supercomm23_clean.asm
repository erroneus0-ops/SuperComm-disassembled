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
; Disassembly:  supercomm23
; Module:       SuperComm
; Type:         program  ($11)
; Size:         $4717  (18199 bytes)
; Entry:        $0BB2
; BSS:          $2000  (8192 bytes)
; CRC-24:       $63F8C2
;
; SuperComm v2.3 (16550 UART variant) â€” OS-9 Level II terminal program
; Author: Dave Philipsen  Copyright (c) 1988, 1989
; '92/3 updates by Randy K. Wilson
; 
; New in v2.3 vs v2.2 (+338 bytes total):
;   + Support for 16550 UART hardware (hardware FIFO buffering)
;     The 16550 was likely used in Dave Philipsen's dual-port RS-232
;     hardware modification to the Tandy Deluxe RS-232 pak.
;     The 16550's 16-byte FIFO dramatically reduces missed bytes at
;     high baud rates compared to the 6551 ACIA in the stock pak.
;   + Credit string updated: 'updated by Randy K. Wilson' ('92/3)
;   + Splash screen updated (2 fewer bytes: $53=83 vs $55=85)
;   + 321 bytes of new pre-exec display/config data
;   + Only 17 bytes of new executable code
;   + Init routine completely restructured from v2.2
;     v2.2 Init: STX ,U  (BSS-relative addressing)
;     v2.3 Init: STX <$00 (direct page addressing â€” different convention)
; 
; Same config-patch-and-reseal CRC design as v2.1/v2.2.
; New pre-exec data: 'White  B' at $0ADF suggests new colour/mode options.
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
         FCS    "["
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
         FCC    "ATH"
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
         FCB    ESC,W.OWEnd      ; Overlay Window End
         FCB    ESC,W.OWEnd      ; Overlay Window End

Dat_03F0
; Referenced by: $1FC8, $20CC
         FCB    BS,BS,BS,BS,BS,BS  ; BS×6
         FCB    BS,BS,BS,BS,BS,BS  ; BS×6

Dat_03FC
; Referenced by: $1920
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
; Referenced by: $0D34, $0DF3, $12EB, $37D0
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $0C               ; FF clear+home
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $04               ; EOT
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $0B               ; VT cursor-up

Dat_048D
; Referenced by: Sub_1D76, $2877
         FCC    "/"
         FCS    "W"

Dat_048F
; Referenced by: $1539, $1D27, Sub_283E
         FCB    ESC,W.DWEnd      ; Device Window End
         FCB    ESC,W.DWSet,$02,$00,$01,$50,$17,$07,$02,$02   ; Device Window Set

Dat_049B
; Referenced by: $28C9
         FCB    ESC,W.DWEnd      ; Device Window End

Dat_049D
; Referenced by: $1D81
         FCB    ESC,W.DWSet,$00,$00,$00,$50,$01,$03,$04,$0C   ; Device Window Set

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
         FCB    $00               ; NUL
         FCB    CurXY,$05,$21     ; CurXY(row=-27,col=1)

Dat_04B5
; Referenced by: $0D3B, $1317, $19F5, $1B29, $1BF6, $1DC6, $1FA3, $20A9, $214F, $223F, $2561, $2ACF, Sub_2C17, $2FDE, $3099, $3155, Sub_363D, Sub_3692, $379C, $3817, $39C0, $3F25, $418E, $42A0
         FCB    $00               ; NUL
         FCB    CurXY,$05,$20     ; CurXY(row=-27,col=0)

Dat_04B9
; Referenced by: $2A0F
         FCB    $1F               ; $1F
         FCC    "  "
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
; Referenced by: Sub_34EA, $35AA
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
         FCB    $00               ; NUL
         FCB    $11               ; DC1/XON
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
; Referenced by: Sub_382E, $3F62
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
         FCC    "                    Transfer Aborted    Wrong Block Number  Block Check "
         FCC    "Failed  Time Out            "

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
         FCC    "110   300   600   1200  2400  4800  9600  19200 38400 57600 76800 115200"
         FCC    "                        "
         FCB    $00               ; NUL
         FCB    $06               ; $06
         FCB    ESC,W.CWArea,$01,$02,$04,$09  ; CPX=1 CPY=2 SZX=4 SZY=9

Dat_06E1
; Referenced by: $3209
         FCB    BS,BS,BS  ; BS×3
         FCC    "   "

Dat_06E7
; Referenced by: $204B
         FCB    $0C               ; FF clear+home
         FCB    LF,LF,LF,LF,LF,LF  ; LF×6
         FCB    LF,LF,LF,LF  ; LF×4

Dat_06F2
; Referenced by: $2054, $3197
         FCC    "==>"

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
         FCB    CurXY,$30,$21     ; CurXY(row=16,col=1)
         FCC    "ASCII"

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
         FCS    "3"
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

Dat_0915
; Referenced by: $2184
         FCB    $00               ; NUL
         FCB    $9D
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
         FCB    $00               ; NUL
         FCB    $04               ; EOT
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
         FCC    "+++"
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
         FCC    " Mark"

Dat_0A93
; Referenced by: $1455, $247E
         FCC    "Space"

Dat_0A98
; Referenced by: Insn_2488
         FCC    " Even"

Dat_0A9D
; Referenced by: $2492
         FCC    " Odd "

Dat_0AA2
; Referenced by: Sub_2498
         FCC    " None"
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
         FCC    "White  Blue   Black  Green  Red    Yellow MagentaCyan   "

Dat_0B17
; Referenced by: $290A
         FCB    CurXY,$20,$20     ; CurXY(row=0,col=0)
         FCC    "    "

Dat_0B1E
; Referenced by: $28B8, $2D38
         FCB    CurXY,$20,$20     ; CurXY(row=0,col=0)
         FCC    "Conf"
         FCB    ESC,W.CWArea,$00,$01,$50,$02  ; CPX=0 CPY=1 SZX=80 SZY=2

Dat_0B2B
; Referenced by: $2B54, $2DD9
         FCB    $00               ; NUL
         FCB    $0F               ; SI cursor-left
         FCC    "B@"
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $86
         FCS    " "
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    $27               ; '''
         FCB    $10               ; $10
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    $03               ; ETX
         FCS    "h"
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
         FCC    "                    "

Dat_0B92
; Referenced by: $0CB6
         FCC    "/dd"
         FCB    $0D               ; CR
         FCC    "                            "

; ==============================================================
; Code section  $0BB2—$4713  (15202 bytes)
; ==============================================================

; Init â€” program entry point (v2.3 restructured from v2.2)
; v2.2 used STX ,U (BSS-relative); v2.3 uses STX <$00 (direct page)
; On OS-9 entry: U=BSS base  X=param string  DP=BSS high byte
; Init â€” program entry point (v2.3 restructured from v2.2)
; v2.2 used STX ,U (BSS-relative); v2.3 uses STX <$00 (direct page)
; On OS-9 entry: U=BSS base  X=param string  DP=BSS high byte
Init:          STX <$00              
	LEAX -3,X             
	STX <$02              
	LDX #$0012            
Sub_0BBB:      CLR ,X+               
	CMPX <$02             
	BCS *-4  ; C=1 (BLO)
	LDX <$00              
	LEAX -128,X           
	STX <$02              
	LEAS -1,S             
	LDX #$16D3            
	STX <$04              
	STX <$06              
	LEAX -1,X             
	STX <$0C              
	LDX #$14D3            
	STX <$0E              
	STX <$10              
	LDD #$0000            
	STD <$0A              
	LDX <$00              
	LDA #$20               ; A = ' '
	STA -1,X              
Sub_0BE7:      LDA ,X+               
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
Sub_0BFB:      LEAX Dat_0386,PCR          ; X → Dat_0386
Sub_0BFF:      LDY #$003A            
	LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
Sub_0C05:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+7
	STA ,Y+               
	DECB                  
	BNE *-9
Sub_0C10:      STA ,Y+               
	LDA #$FF              
	STA <$37              
	STA <$4F              
	LDX #$00EC            
Insn_0C1A:     LDD Dat_0C1D          

Dat_0C1D
; ── 71 bytes  ($0C1D—$0C63) ──
         FCB    $00               ; NUL
         FCS    "]"
         FCB    $12               ; $12
         FCS    "m"
         FCB    $84
         FCS    "m"
         FCB    CurXY,$ED,$04     ; CurXY(row=205,col=-28)
         FCS    "g"
         FCB    $06               ; $06
         FCB    $1F               ; $1F
         FCB    $10               ; $10
         FCB    $8E
         FCB    $00               ; NUL
         FCB    $7C               ; '|'
         FCB    $10               ; $10
         FCB    $8E
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCC    "4@"
         FCS    "N"
         FCB    $00               ; NUL
         FCB    $28               ; '('
         FCB    $10               ; $10
         FCB    $3F               ; '?'
         FCB    $1B               ; ESC windowing cmd
         FCC    "5@"
         FCB    $0D               ; CR
         FCC    "(&"
         FCB    $14               ; DC4 erase-EOL
         FCS    "L"
         FCB    $00               ; NUL
         FCS    "l"
         FCB    $10               ; $10
         FCB    $8E
         FCB    $00               ; NUL
         FCB    $01               ; SOH
         FCB    $8E
         FCB    $00               ; NUL
         FCC    ":4@"
         FCS    "N"
         FCB    $00               ; NUL
         FCB    $28               ; '('
         FCB    $10               ; $10
         FCB    $3F               ; '?'
         FCB    $1B               ; ESC windowing cmd
         FCC    "5@4"
         FCB    $80
         FCB    $0D               ; CR
         FCC    "('"
         FCB    $12               ; $12
         FCS    "L"
         FCB    $22               ; '"'
         FCB    $0E               ; SO cursor-right
         FCS    "c"
         FCS    "d"
         FCS    "}"
         FCB    $0C               ; FF clear+home
         FCS    "/"
         FCS    "L"
         FCB    $22               ; '"'
         FCB    $15               ; NAK erase-EOS
Sub_0C64:      ADDD ,S++             
	STD $0CB1             
	BRA *+18
         FCB    $CC,$21,$FE,$E3,$E4,$FD,$0C,$AF,$CC,$22,$06,$E3,$E1,$FD,$0C,$B1  ; unreachable padding
Sub_0C7B:      LBSR Sub_14DF          ; call Sub_14DF
	LBCS Sub_1107         
Sub_0C7F:      BCS *+6  ; C=1 (BLO)
	BITA #$17             
	LDY #$1025            
Sub_0C85:      LBCS Sub_1107         
	LDA #$01              
	STA <$70              
	LDX #$0001            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDA #$01              
	LDB #$92              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+49  ; C=1 (BLO)
	TFR X,D               
	STB $0C91             
	ORA $0C91             
	STA <$70              
	LEAX Dat_0B5B,PCR          ; X → Dat_0B5B
	LDY #$0CBA            
	LDB #$4D               ; B = 'M'
	JSR [$0CAF]            ; call via indexed pointer
	LDA #$03              
	LEAX Dat_0B92,PCR          ; X → Dat_0B92
	OS9 I$ChgDir           ; mode=B  name→X
	LEAX Dat_0392,PCR          ; X → Dat_0392
	LDY #$0080            
	LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
	JSR [$0CAF]            ; call via indexed pointer
Sub_0CCB:      LBSR Sub_1E63          ; call Sub_1E63
	LBSR Sub_1ED7          ; call Sub_1ED7
	LBSR Sub_1E4C          ; call Sub_1E4C
	LEAX Dat_110A,PCR          ; X → Dat_110A
	OS9 F$Icpt             ; handler→X  data→U
	LEAX Dat_038C,PCR          ; X → Dat_038C
	LDA #$03              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+54  ; C=1 (BLO)
	STA <$7B              
	LDB #$81              
	LDY #$0001            
	LDX #$003C            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	BCS *+31  ; C=1 (BLO)
	LDA <$7B              
	LDY #$0800            
	LDX #$0800            
	LDB #$80              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+15  ; C=1 (BLO)
	CMPX #$0800           
	BCC *+10  ; C=0 (BHS)
	CMPY #$0800           
	BCC *+4  ; C=0 (BHS)
	BRA *+9

; --------------------------------------------------------------
Sub_0D13:      LDA <$7B              
	OS9 I$Close            ; path=A
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
Sub_0D1A:      LDX #$051C            
	STX <$71              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	STB $0D38             
	CLRA                   ; A = 0
	LDB #$07              
	STB $0CB9             
	LDB #$14              
	STA $0D39             
	LDD #$1B32             ; D=ESC+'2'  → W.FColor: Foreground Color
	STD <$A9              
	LEAX Dat_0484,PCR          ; X → Dat_0484
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$1A04            
	STD $0C9A             
Insn_0D48:     LDD #$1609            
Sub_0D4A:      EQU    Insn_0D48+2      ; [*1] branch target 2 byte(s) inside Insn_0D48 — see [*1]
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_0078,PCR          ; X → Dat_0078
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_1D76          ; call Sub_1D76
	LDX #$001C            
	LBSR Sub_1178          ; call Sub_1178
	LDD #$3210            
	STD $0C9A             
	LDD #$1304            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_00CD,PCR          ; X → Dat_00CD
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_3BCC          ; call Sub_3BCC
Sub_0D7A:      CLRA                   ; A = 0
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$0A              ; compare A with LF
	BCS *-13  ; C=1 (BLO)
	BRA *+5

; --------------------------------------------------------------
Sub_0D8B:      LBSR Sub_2C62          ; call Sub_2C62
Sub_0D8E:      LBSR Sub_1F53          ; call Sub_1F53
	LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$03              
	LDX #$003A            
	OS9 I$Open             ; mode=B  name→X  → path→A
	LBCS Sub_1107         
	STA <$38              
	LDB #$D2              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+5  ; C=0 (BHS)
	CLRA                   ; A = 0
	BRA *+19

; --------------------------------------------------------------
Sub_0DB3:      ANDA #$0F             
	STA $0CB9             
	STX $0CB7             
	TFR X,D               
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	BVS *+95
	BEQ *+4
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	BVS *-121
Sub_0DC4:      BITA #$01             
	PSHS PC               
	BNE *+9
	LDD #$0353            
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	TFR Y,D               
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
Sub_0DD1:      LDD #$0349            
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	TFR ?,U               
	ANDB ?$FD             
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	SUBD $B60C            
	STA $8502             
	BNE *+9
	LDD #$0375            
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	EXG Y,D               
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
Sub_0DE9:      LDD #$036C            
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	EXG ?,U               
	CMPB ?$FD             
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	BITA $308D            
	LDB $8D17             
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	ADDA <$17             
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
	ADDA #$17             
	TFR D,A               
	LBSR Sub_44F3          ; call Sub_44F3
	LBSR Sub_4313          ; call Sub_4313
	LDD #$0101            
	STD $0C9E             
	LBSR Sub_2C92          ; call Sub_2C92
	LBSR Sub_1529          ; call Sub_1529
	LBSR Sub_14A5          ; call Sub_14A5
	LDA #$00               ; A = NUL
	LEAX Dat_0337,PCR          ; X → Dat_0337
	STX <$77              
Sub_0E1D:      LDX #$061B            
	LDY #$0001            
	OS9 I$Read             ; path=A  count=Y  buf→X
	LBRA Sub_173F         

; --------------------------------------------------------------
Sub_0E2A:      LDX #$00EC            
	LDA <$38              
	JSR [$0CB3]            ; call via indexed pointer
	LBCC Sub_11E0         
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAS -16,X            
	BNE *+55
	CLR $8E00             
	FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
	LBSR Sub_1178          ; call Sub_1178
	LBSR Sub_15A4          ; call Sub_15A4
	BCS *-28  ; C=1 (BLO)
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	TSTA                  
	LBNE Sub_2919         
	LBRA Sub_1733         

; --------------------------------------------------------------
Sub_0E51:      LDX #$00EC            
	LDY #$071A            
	LDB $0C96             
Sub_0E5B:      LDA ,X+               
	ANDA #$7F             
	CMPA #$20              ; compare A with ' '
	BCS *+11  ; C=1 (BLO)
	LBSR Sub_15B0          ; call Sub_15B0
Sub_0E66:      STA ,Y+               
Sub_0E68:      DECB                  
	BNE *-14
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_0E6C:      CMPA #$08              ; compare A with BS
	BNE *+7
Insn_0E70:     LBSR Sub_15C7          ; call Sub_15C7
Sub_0E71:      EQU    Insn_0E70+1      ; [*2] branch target 1 byte(s) inside Insn_0E70 — see [*2]
	LSRB                  
	BRA *-13

; --------------------------------------------------------------
Sub_0E75:      CMPA #$0D              ; compare A with CR
	BNE *+22
	LBSR Sub_15DC          ; call Sub_15DC
	TST $0CBD             
	BEQ *-25
	LBSR Sub_15E3          ; call Sub_15E3
	INC $0C96             
	STA ,Y+               
	LDA #$0A               ; A = LF
	BRA *-37

; --------------------------------------------------------------
Sub_0E8D:      CMPA #$0C              ; compare A with FF
	BNE *+7
	LBSR Sub_15F3          ; call Sub_15F3
	BRA *-46

; --------------------------------------------------------------
Sub_0E96:      CMPA #$07             
	BEQ *-50
	CMPA #$0A              ; compare A with LF
	BNE *+7
	LBSR Sub_15E3          ; call Sub_15E3
	BRA *-59

; --------------------------------------------------------------
Sub_0EA3:      CMPA #$09             
	BNE *+4
	BSR *+100  ; call Sub_0F0B
Sub_0EA9:      DEC $0C96             
	BRA *-68

; --------------------------------------------------------------
Sub_0EAE:      LDX #$00EC            
	LDY #$071A            
	LDB $0C96             
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	JMP 11,Y              
	SEX                    ; sign-extend B into A
	LBNE $0F82            
	LDA ,X+               
	CMPA #$20              ; compare A with ' '
	BCS *+36  ; C=1 (BLO)
	CMPA #$80             
	BCS *+4  ; C=1 (BLO)
	LDA #$2A               ; A = '*'
	LBSR Sub_15B0          ; call Sub_15B0
	STA ,Y+               
	DECB                  
	BNE *-26
	RTS                    ; return from subroutine
         FCB    $0F,$6E,$20,$F6,$A6,$80,$81,$5B,$26,$F6,$86,$01,$97,$6E,$7A,$0C,$96,$20,$E9,$81,$08,$27,$37,$81,$0D,$27,$43,$81,$0A,$27,$53,$81,$0C,$27,$54,$81,$07,$27,$D0,$81,$1B,$27,$52,$81,$09,$26,$02,$8D,$05,$7A,$0C,$96,$20,$C6  ; unreachable padding
Sub_0F0B:      PSHS A,B              
	LDD $0C9E             
	CMPA #$48              ; compare A with 'H'
	BHI *+15
	ADDA #$08             
	ANDA #$F8             
	INCA                  
	STA $0C9E             
	DECA                  
	DECB                  
	LBSR Sub_24DC          ; call Sub_24DC
Sub_0F21:      PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)
         FCB    $34,$02,$B6,$0C,$9E,$81,$01,$35,$02,$27,$D8,$17,$06,$96,$20,$9C,$17,$06,$A6,$7D,$0C,$BD,$27,$94,$17,$06,$A5,$7C,$0C,$96,$A7,$A0,$86,$0A,$20,$88,$17,$06,$99,$20,$83,$17,$06,$A4,$16,$FF,$7D,$86,$FF,$97,$6E,$B7,$0C,$6D,$34,$20,$10,$8E,$0C,$6D,$10,$BF,$0C,$8D,$7F,$0C,$6D,$7F,$0C,$6E,$B7,$0C,$6F,$35,$20,$8D,$06,$7A,$0C,$96,$16,$FF,$5B,$34,$20,$10,$8E,$0B,$1A,$10,$BF,$0C,$98,$35,$A0,$34,$20,$10,$BE,$0C,$98,$A6,$80,$A7,$A0,$10,$BF,$0C,$98,$35,$20,$81,$40,$22,$06,$7A,$0C,$96,$16,$FF,$35,$0F,$6E,$B7,$0C,$97,$7A,$0C,$96,$8D,$D0,$34,$24,$10,$BE,$0C,$8D,$86,$FF,$A7,$A4,$10,$8E,$0C,$6D,$10,$BF,$0C,$8D,$10,$BE,$0C,$98,$A6,$A0,$81,$40,$22,$40,$81,$3A,$25,$04,$C6,$FE,$20,$19,$80,$30,$B7,$0C,$91,$A6,$A0,$81,$39,$22,$26,$80,$30,$B7,$0C,$92,$B6,$0C,$91,$C6,$0A,$3D,$FB,$0C,$92,$34,$20,$10,$BE,$0C,$8D,$E7,$A0,$C6,$FF,$E7,$A4,$E7,$21,$E7,$22,$10,$BF,$0C,$8D,$35,$20,$20,$C1,$31,$3F,$F6,$0C,$91,$20,$E1,$35,$24,$B6,$0C,$97,$81,$6D,$27,$4B,$81,$4A,$10,$27,$02,$C6,$81,$66,$10,$27,$06,$17,$81,$48,$10,$27,$06,$11,$81,$43,$10,$27,$06,$4B,$81,$44,$10,$27,$06,$7D,$81,$41,$10,$27,$06,$99,$81,$42,$10,$27,$06,$B5,$81,$73,$10,$27,$05,$C5,$81,$75,$10,$27,$05,$CC,$81,$4B,$10,$27,$02,$AF,$81,$4C,$10,$27,$06,$BC,$81,$4D,$10,$27,$06,$BC,$16,$FE,$7B,$34,$16,$8E,$0C,$6D,$A6,$84,$81,$FF,$27,$51,$A6,$80,$81,$FF,$27,$16,$81,$00,$27,$47,$81,$01,$27,$F2,$81,$08,$25,$0F,$81,$26,$25,$13,$81,$30,$25,$23,$20,$E4,$35,$16,$16,$FE,$4F,$34,$10,$30,$8D,$F3,$84,$20,$4E,$D6,$70,$C1,$02,$27,$D1,$81,$1E,$25,$CD,$80,$1E,$34,$10,$30,$8D,$F3,$98,$20,$3A,$D6,$70,$C1,$02,$27,$BD,$81,$28,$25,$B9,$80,$28,$34,$10,$30,$8D,$F3,$AC,$20,$26,$34,$10,$30,$8D,$F3,$46,$E6,$1F,$A6,$80,$A7,$A0,$7C,$0C,$96,$5A,$26,$F6,$B6,$0C,$C7,$17,$0E,$02,$A7,$3A,$B6,$0C,$C8,$17,$0D,$FA,$A7,$3D,$35,$10,$20,$89,$C6,$05,$3D,$30,$85,$17,$01,$E8,$35,$10,$16,$FF,$7C  ; unreachable padding
Sub_10E5:      LDA <$4B              
	OS9 I$Close            ; path=A
	LBSR Sub_1529          ; call Sub_1529
	LBSR Sub_1537          ; call Sub_1537
	LBSR Sub_159C          ; call Sub_159C
	LDA <$7B              
	BEQ *+5
Insn_10F7:     OS9 I$Close            ; path=A
Sub_10FA:      EQU    Insn_10F7+3      ; [*3] branch target 3 byte(s) inside Insn_10F7 — see [*3]
	PSHS CC,A,B,Y         
	FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
	LBSR Sub_462A          ; call Sub_462A
	LDA <$37              
	OS9 I$Close            ; path=A
	CLRB                   ; B = 0
Sub_1107:      OS9 F$Exit             ; status=B

Dat_110A
; Referenced by: $0CD4
; ── 6 bytes  ($110A—$110F) ──
         FCS    "A"
         FCB    $80
         FCB    $26               ; '&'
         FCB    CurXY,$0C,$7C     ; CurXY(row=-20,col=92)
Sub_1110:      RTI                    ; return from interrupt
         FCB    $10,$8E,$00,$80,$C6,$D0,$10,$3F,$8D,$39,$C6,$01,$10,$3F,$8D,$25,$0D,$34,$02,$4F,$5D,$2B,$08  ; unreachable padding
Sub_1128:      TFR D,Y               
	PULS A                
	OS9 I$Read             ; path=A  count=Y  buf→X
Sub_112F:      RTS                    ; return from subroutine
Sub_1130:      LDB #$80              
	BRA *-10
         FCB    $34,$04,$C6,$D1,$10,$3F,$8E,$35,$84,$10,$3F,$8A,$35,$80,$34,$32,$8E,$00,$A9,$B6,$0C,$CB,$17,$0D,$7F,$A7,$02,$96,$4B,$10,$8E,$00  ; unreachable padding
Sub_1154:      EQU    $1154            ; [*4] undefined opcode at $1154 — see [*4]
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$0080            
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$00A9            
	LDA $0CC9             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 2,X               
	LDA <$4B              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1178:      PSHS Y                
	LDY <$12              
	LEAY 1,Y              
	STY <$12              
	PSHS A                
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	JMP $270D             
	LDA <$7D              
	CMPA <$7C             
	BEQ *+9
	BSR *+19
	INCA                  
	STA <$7D              
	BRA *-9
         FCB    $35,$02,$10,$3F,$0A,$8C,$00,$00,$26,$E3,$35,$A0,$34,$36,$8E,$00,$80,$C6,$0A,$8D,$0B,$4D,$2A,$28,$5A,$5A,$C1,$04,$25,$22,$20,$F3,$A6,$85,$81,$39,$27,$04,$4C,$A7,$85,$39,$86,$30,$A7,$85,$5A,$A6,$85,$81,$35,$27,$04,$4C,$A7,$85,$39,$86,$30,$A7,$85,$86,$FF,$39,$96,$4B,$10,$8E,$00,$0B,$10,$3F,$8A,$35,$B6  ; unreachable padding
Sub_11E0:      STY $0C95             
	CMPY #$0000           
	BEQ *+59
	TST $0CC3             
	BNE *+5
	LBSR Sub_1267          ; call Sub_1267
Sub_11F2:      LDA $0C8F             
	BEQ *+15
	CMPA #$05             
	BNE *+8
	CLRA                   ; A = 0
	STA $0C8F             
	BRA *+5

; --------------------------------------------------------------
Sub_1201:      LBSR Sub_277A          ; call Sub_277A
Sub_1204:      BSR *+67  ; call Sub_1247
	LDA #$01              
	LDX #$071A            
	LDY $0C95             
	CMPY #$0000           
	BEQ *+16
	OS9 I$Write            ; path=A  count=Y  buf→X
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	PSHS CC,A,B,Y         
	FCB    $07                ; undefined opcode $07 -- not a valid 6809 instruction
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	PULS CC,A,B,Y         
	FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
	LBSR Sub_42EB          ; call Sub_42EB
Sub_1223:      LBSR Sub_4472          ; call Sub_4472
	TST $0C90             
	BEQ *+5
Insn_122B:     LBSR Sub_27D4          ; call Sub_27D4
Sub_122E:      EQU    Insn_122B+3      ; [*5] branch target 3 byte(s) inside Insn_122B — see [*5]
	ROR $2A0C             
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	ROR $7D0C             
	ORA -16,X             
	BEQ *+10
	CLR $1607             
Insn_123D:     CMPA 13,X             
Sub_123E:      EQU    Insn_123D+1      ; [*6] branch target 1 byte(s) inside Insn_123D — see [*6]
	LEAS -16,X            
	BEQ *-3
Sub_1242:      ADDB $FF16            
	ADDB $E3B6            
Sub_1247:      LDA $0CBB             
	BEQ *+14
	CMPA #$01             
	LBEQ Sub_0E51         
	CMPA #$02              ; compare A with CurXY
	LBEQ Sub_0EAE         
Sub_1258:      LDX #$00EC            
	LDY #$071A            
	LDB $0C96             
	JSR [$0CAF]            ; call via indexed pointer
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1267:      PSHS A,B,X,Y          
	LDB $0C96             
	LDY <$77              
	LDX #$00EC            
Sub_1272:      TSTB                  
	BEQ *+49
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	ROR $270C             
	LDA ,X                
	CMPA #$30              ; compare A with '0'
	BEQ *+61
	CMPA #$31              ; compare A with '1'
	BEQ *+62
	BRA *+13
         FCB    $A6,$80,$84,$7F,$5A,$0F,$7A,$A1,$A4,$27,$16  ; unreachable padding
Sub_1290:      LEAY Dat_0337,PCR          ; Y → Dat_0337
	STY <$77              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	DEC $2604             
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
Insn_129C:     DEC $20ED             
Sub_129F:      EQU    Insn_129C+3      ; [*7] branch target 3 byte(s) inside Insn_129C — see [*7]
	DEC $5D26             
	CMPB -11,Y            
Sub_12A4:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $31,$21,$10,$9F,$77,$6D,$A4,$26,$F0,$0C,$76,$31,$8D,$F0,$82,$10,$9F,$77,$20,$B8  ; unreachable padding
Sub_12BA:      INC $0CAA             
	BRA *+5

; --------------------------------------------------------------
Sub_12BF:      CLR $0CAA             
Sub_12C2:      LDA #$FF              
	STA <$76              
	BRA *-34
         FCB    $E6,$01,$30,$02,$A6,$80,$A7,$A0,$7C,$0C,$96,$5A,$26,$F6,$39,$34,$16,$8E,$0C,$6D,$A6,$84,$81,$02,$27,$09,$30,$8D,$F1,$A4,$8D,$E0,$16,$FD,$92,$30,$8D,$F1,$95,$8D,$D7,$17,$02,$FF,$20,$F2,$34,$16,$30,$8D,$F1,$8B,$8D,$CA,$16,$FD,$7C  ; unreachable padding
Sub_1301:      LDD #$1A01            
	STD $0C9A             
	LDD #$340E            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_010A,PCR          ; X → Dat_010A
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
Sub_131E:      LBSR Sub_2C62          ; call Sub_2C62
	CMPA #$20              ; compare A with ' '
	BEQ *+81
	CMPA #$05             
	BEQ *+77
	CMPA #$0C              ; compare A with FF
	BNE *+6
	LDA #$1C              
	BRA *+57

; --------------------------------------------------------------
Sub_1331:      CMPA #$0A              ; compare A with LF
	BNE *+6
	LDA #$1A               ; A = SUB
	BRA *+55

; --------------------------------------------------------------
Sub_1339:      LDB Dat_0B4B          
	LEAX Dat_0B4C,PCR          ; X → Dat_0B4C
Sub_1341:      CMPA ,X+              
	BEQ *+7
	DECB                  
	BNE *-5
	BRA *-42

; --------------------------------------------------------------
Sub_134A:      ADDA #$A0             
	PSHS A                
	LDA #$04              
Sub_1350:      STA <$4E              
	LEAX Dat_03EA,PCR          ; X → Dat_03EA
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A                
	STA $061B             
	LBRA Sub_1748         

; --------------------------------------------------------------
Sub_1368:      PSHS A                
	LDA #$09              
	BRA *-28

; --------------------------------------------------------------
Sub_136E:      PSHS A                
	LDA #$11               ; A = XON
	BRA *-34

; --------------------------------------------------------------
Sub_1374:      LEAX Dat_03EA,PCR          ; X → Dat_03EA
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_1E33          ; call Sub_1E33
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LBRA Sub_0E2A         
         FCB    $34,$36,$96,$38,$C6,$00,$8E,$0C,$3B,$10,$3F,$8D,$35,$B6  ; unreachable padding
Sub_1396:      PSHS A,B,X,Y          
	LDX #$0C3B            
	LDB $0CBA             
	STB 21,X              
	LDB 20,X              
	ANDB #$0F             
	ORB $0CC1             
	STB 20,X              
	LDB $0CC4             
	STB 24,X              
	LDB $0CC5             
	STB 25,X              
	LDB $0CC6             
	STB 4,X               
	LDB $0CBE             
	STB 5,X               
	CLR 7,X               
	LEAX 9,X              
	LDB #$0A               ; B = SS.DevNm  (GetStt/SetStt subcode)
	CLR ,X+               
	DECB                  
	BNE *-3
	LDA <$38              
	CMPA #$03             
	LBLS $14A3            
	LDX #$0C3B            
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDX #$00A2            
	LDD #$025A            
	STD ,X                
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	STB 2,X               
	LDY #$0003            
	LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA $0CBA             
	ANDA #$0F             
	LDB #$06               ; B = SS.EOF  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	LEAX Dat_0679,PCR          ; X → Dat_0679
	LEAX B,X              
	LDY #$0006            
	LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB #$62               ; B = 'b'
	LDX #$00A2            
	STB 1,X               
	LDA <$4B              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB $0CBA             
	BITB #$20             
	BNE *+6
	LDB #$38               ; B = '8'
	BRA *+4
         FCB    $C6,$37,$8E,$00,$50,$E7,$84,$10,$8E,$00,$01,$10,$3F,$8A,$C6,$64,$8E,$00,$A2,$E7,$01,$10,$8E,$00,$03,$96,$4B,$10,$3F,$8A,$B6,$0C,$C1,$84,$E0,$81,$A0,$26,$06,$30,$8D,$F6,$40,$20,$22,$81,$E0,$26,$06,$30,$8D,$F6,$3A,$20,$18,$81,$60,$26,$06,$30,$8D,$F6,$36,$20,$0E,$81,$20,$26,$06,$30,$8D,$F6,$31,$20,$04,$30,$8D,$F6,$30,$96,$4B,$10,$8E,$00,$01,$10,$3F,$8A,$C6,$66,$8E,$00,$A2,$E7,$01,$96,$4B,$10,$8E,$00,$03,$10,$3F,$8A,$F6,$0C,$BA,$2A,$04,$C6,$32,$20,$02,$C6,$31,$8E,$00,$50,$E7,$84,$10,$8E,$00,$01,$10,$3F,$8A,$35,$B6  ; unreachable padding
Sub_14A5:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDY #$0C19            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	JSR [$0CB1]            ; call via indexed pointer
	LDX #$13C3            
	CLR 4,X               
	LDA $0CBD             
	STA 5,X               
	CLR 7,X               
	LDA $13BF             
	STA 12,X              
	LDA $13C2             
	STA 15,X              
	LDA $13C0             
	STA 16,X              
	LDA $13C1             
	STA 17,X              
	LDA #$01              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_14DF:      PSHS A,B,X            
	LDA #$00               ; A = NUL
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	LDX #$0C19            
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDA 20,X              
	BPL *+54
	LDA #$01              
	LDB #$96              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	STA <$9A              
	STB <$9B              
	TFR X,D               
	STB <$9C              
	LDX #$0C5D            
	LDA #$01              
	LDB #$91              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDA #$01              
	LDB #$26               ; B = SS.FSig  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	TFR X,D               
	STB <$8B              
	TFR Y,D               
	STB <$8C              
	LDA #$01              
	LDB #$93              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	STA <$8D              
	CLRB                   ; B = 0
Sub_1522:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1524:      COMB                  
	LDB #$B7              
	BRA *-5

; --------------------------------------------------------------
Sub_1529:      PSHS A,B,X            
	LDA #$00               ; A = NUL
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	LDX #$0C19            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1537:      PSHS A,B,X,Y          
	LEAY Dat_048F,PCR          ; Y → Dat_048F
	LDB #$10              
	LDX #$13C3            
	JSR [$0CB1]            ; call via indexed pointer
	LDX #$13C3            
	LDA <$8D              
	STA 4,X               
	CLRA                   ; A = 0
	STA 6,X               
	LDA <$8B              
	STA 7,X               
	LDA <$8C              
	STA 8,X               
	LDA <$9A              
	STA 9,X               
	LDA <$9B              
	STA 10,X              
	LDA <$9C              
	STA 11,X              
	LDY #$000C            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDX #$0C5D            
	LDA #$01              
	LDB #$91              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDX #$13C3            
	LDD #$1B21             ; D=ESC+'!'  → W.Select: Select window
	STD ,X                
	LDA #$01              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_159C:      LEAX Dat_03CD,PCR          ; X → Dat_03CD
	LBSR Sub_1D95          ; call Sub_1D95
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_15A4:      LDA #$00               ; A = NUL
	BRA *+4
         FCB    $96,$38  ; unreachable padding
Sub_15AA:      LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_15B0:      PSHS A,B              
	LDD $0C9E             
	INCA                  
	CMPA <$9D             
	BLS *+10
	LDA #$01              
	INCB                  
	CMPB <$9E             
	BLS *+3
	DECB                  
Sub_15C2:      STD $0C9E             
	PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_15C7:      PSHS A,B              
	LDD $0C9E             
	DECA                  
	BNE *+10
	LDA <$9D              
	DECB                  
	BNE *+5
	LDD #$0101            
Sub_15D7:      STD $0C9E             
	PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_15DC:      CLR $0C9E             
	INC $0C9E             
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_15E3:      PSHS A,B              
	LDD $0C9E             
	INCB                  
	CMPB <$9E             
	BLS *+3
	DECB                  
Sub_15EE:      STD $0C9E             
	PULS A,B,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_15F3:      CLR $0C9E             
	CLR $0C9F             
	INC $0C9E             
	INC $0C9F             
	RTS                    ; return from subroutine
         FCB    $34,$06,$FC,$0C,$9E,$FD,$0C,$A0,$35,$06,$16,$F8,$C4,$34,$06,$86,$02,$A7,$A0,$FC,$0C,$A0,$FD,$0C,$9E,$8B,$1F,$CB,$1F,$A7,$A0,$E7,$A0,$F6,$0C,$96,$CB,$03,$F7,$0C,$96,$35,$06,$16,$F8,$A3,$34,$16,$8E,$0C,$6D,$86,$02,$A7,$A0,$A6,$01,$27,$0C,$81,$FE,$26,$04,$A6,$02,$27,$04,$91,$9D,$23,$02,$86,$01,$B7,$0C,$9E,$8B,$1F,$A7,$A0,$A6,$84,$27,$04,$91,$9E,$23,$02,$86,$01,$B7,$0C,$9F,$8B,$1F,$A7,$A0,$F6,$0C,$96,$CB,$03,$F7,$0C,$96,$35,$16,$16,$F8,$63,$34,$16,$8E,$0C,$6D,$A6,$84,$91,$9D,$24,$03,$4D,$26,$02,$86,$01,$BB,$0C,$9E,$91,$9D,$23,$02,$96,$9D,$B7,$0C,$9E,$C6,$02,$E7,$A0,$FC,$0C,$9E,$8B,$1F,$CB,$1F,$A7,$A0,$E7,$A0,$F6,$0C,$96,$CB,$03,$F7,$0C,$96,$35,$16,$16,$F8,$2B,$34,$16,$8E,$0C,$6D,$A6,$84,$91,$9D,$24,$03,$4D,$26,$02,$86,$01,$B7,$0C,$91,$B6,$0C,$9E,$B0,$0C,$91,$2E,$02,$86,$01,$B7,$0C,$9E,$20,$C2,$34,$16,$8E,$0C,$6D,$A6,$84,$91,$9E,$24,$03,$4D,$26,$02,$86,$01,$B7,$0C,$91,$B6,$0C,$9F,$B0,$0C,$91,$2E,$02,$86,$01,$B7,$0C,$9F,$20,$A0,$34,$16,$8E,$0C,$6D,$A6,$84,$91,$9E,$24,$03,$4D,$26,$02,$86,$01,$BB,$0C,$9F,$91,$9E,$23,$02,$96,$9E,$B7,$0C,$9F,$16,$FF,$81,$34,$16,$C6,$30,$20,$04,$34,$16,$C6,$31,$B6,$0C,$6D,$27,$16,$2A,$02,$86,$01,$34,$02,$86,$1F,$ED,$A1,$7C,$0C,$96,$7C,$0C,$96,$6A,$E4,$26,$F4,$35,$02,$35,$16,$16,$F7,$9E  ; unreachable padding
Sub_1733:      LDA #$00               ; A = NUL
	LDY #$0001            
	LDX #$061B            
	OS9 I$Read             ; path=A  count=Y  buf→X
Sub_173F:      LDA #$00               ; A = NUL
	LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	STA <$4E              
Sub_1748:      TFR A,B               
	LDA $061B             
	CLR $061B             
	BITB #$07             
	LBEQ Sub_18B1         
	LDB $0CBB             
	CMPB #$02              ; compare B with CurXY
	LBNE Sub_1804         
	LDB <$4E              
	BITB #$06             
	LBEQ Sub_1804         
	BITB #$78             
	LBEQ Sub_1804         
	CMPA #$8C             
	BNE *+6
	LDA #$41               ; A = 'A'
	BRA *+58

; --------------------------------------------------------------
Sub_1775:      CMPA #$8A             
	BNE *+6
	LDA #$42               ; A = 'B'
	BRA *+50

; --------------------------------------------------------------
Sub_177D:      CMPA #$88             
	BNE *+6
	LDA #$44               ; A = 'D'
	BRA *+42

; --------------------------------------------------------------
Sub_1785:      CMPA #$89             
	BNE *+6
	LDA #$43               ; A = 'C'
	BRA *+34

; --------------------------------------------------------------
Sub_178D:      CMPA #$13              ; compare A with XOFF
	BNE *+6
	LDA #$48               ; A = 'H'
	BRA *+26

; --------------------------------------------------------------
Sub_1795:      CMPA #$12             
	BNE *+6
	LDA #$4B               ; A = 'K'
	BRA *+18

; --------------------------------------------------------------
Sub_179D:      CMPA #$10             
	BNE *+6
	LDA #$50               ; A = 'P'
	BRA *+10

; --------------------------------------------------------------
Sub_17A5:      CMPA #$11              ; compare A with XON
	LBNE Sub_1804         
	LDA #$40               ; A = '@'
Sub_17AD:      LDX #$04FC            
	STA 2,X               
	PSHS A                
	LDD #$1B5B             ; D=ESC+$5B
	STD ,X                
	LDA <$38              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A                
	TST $0CBC             
	LBEQ Sub_0E2A         
	CMPA #$41              ; compare A with 'A'
	BNE *+6
	LDA #$09              
	BRA *+34

; --------------------------------------------------------------
Sub_17D3:      CMPA #$42              ; compare A with 'B'
	BNE *+6
	LDA #$0A               ; A = LF
	BRA *+26

; --------------------------------------------------------------
Sub_17DB:      CMPA #$43              ; compare A with 'C'
	BNE *+6
	LDA #$06              
	BRA *+18

; --------------------------------------------------------------
Sub_17E3:      CMPA #$44              ; compare A with 'D'
	BNE *+6
	LDA #$08               ; A = BS
	BRA *+10

; --------------------------------------------------------------
Sub_17EB:      CMPA #$48              ; compare A with 'H'
	LBNE Sub_0E2A         
	LDA #$01              
Sub_17F3:      LDX #$04FC            
Sub_17F5:      LDD $A784             
Sub_17F7:      ANDA #$86             
	FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_1804:      LDB <$4E              
	BITB #$04             
	LBEQ Sub_1897         
	CMPA #$F1             
	LBEQ Sub_1D9E         
	CMPA #$E8             
	LBEQ Sub_1BDB         
	CMPA #$AF             
	LBEQ Sub_1301         
	CMPA #$E1             
	LBEQ Sub_2FFA         
	CMPA #$E2             
	BNE *+5
	LBSR Sub_1FA1          ; call Sub_1FA1
Sub_182B:      CMPA #$E9             
	BNE *+5
	LBRA Sub_19AD         

; --------------------------------------------------------------
Sub_1832:      CMPA #$F4             
	BNE *+5
	LBSR Sub_20A7          ; call Sub_20A7
Sub_1839:      CMPA #$F5             
	BNE *+5
	LBSR Sub_2FBF          ; call Sub_2FBF
Sub_1840:      CMPA #$E3             
	BNE *+5
	LBSR Sub_212D          ; call Sub_212D
Sub_1847:      CMPA #$EC             
	BNE *+5
	LBSR Sub_214D          ; call Sub_214D
Sub_184E:      CMPA #$85             
	BNE *+5
	LBSR Sub_1F88          ; call Sub_1F88
Sub_1855:      CMPA #$F2             
	LBEQ Sub_191E         
	CMPA #$F3             
	LBEQ Sub_192F         
	CMPA #$8A             
	LBEQ Sub_363D         
	CMPA #$8C             
	LBEQ Sub_3692         
	CMPA #$EF             
	BNE *+5
	LBSR Sub_223D          ; call Sub_223D
Sub_1874:      CMPA #$ED             
	BNE *+5
	LBSR Sub_25A4          ; call Sub_25A4
Sub_187B:      CMPA #$E4             
	BNE *+5
	LBSR Sub_24F8          ; call Sub_24F8
Sub_1882:      CMPA #$FA             
	BNE *+5
	LBSR Sub_2830          ; call Sub_2830
Sub_1889:      CMPA #$B1             
	BCS *+44  ; C=1 (BLO)
	CMPA #$B8             
	BHI *+40
	LBSR Sub_1C71          ; call Sub_1C71
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_1897:      BITB #$78             
	BEQ *+24
	CMPA #$1A              ; compare A with SUB
	LBEQ Sub_363D         
	CMPA #$1C             
	LBEQ Sub_3692         
	CMPA #$18             
	LBNE Sub_0E2A         
	LDA #$7F              
	BRA *+8

; --------------------------------------------------------------
Sub_18B1:      CMPA #$B1             
	LBEQ Sub_1301         
Sub_18B7:      CMPA #$7F             
	BHI *+98
	STA $04FC             
	TST $0CBF             
	BEQ *+16
	LDA #$01              
	LDB #$98              
	LDX #$2801            
	LDY #$0900            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
Sub_18D1:      LDY #$0001            
	LDX #$04FC            
	LDA ,X                
	CMPA #$0D              ; compare A with CR
	BNE *+13
	TST $0CBE             
	BEQ *+8
	LDA #$0A               ; A = LF
	STA 1,X               
	LEAY 1,Y              
Sub_18E9:      LDA <$38              
	OS9 I$Write            ; path=A  count=Y  buf→X
	TST $04FC             
	BMI *+42
	LDA $0CBC             
	BEQ *+37
	TST $0CBD             
	BEQ *+20
	LDA $04FC             
	CMPA #$0D              ; compare A with CR
	BNE *+13
	LDA #$0A               ; A = LF
	STA $04FD             
	LDY #$0002            
	BRA *+6

; --------------------------------------------------------------
Sub_190F:      LDY #$0001            
Sub_1913:      LDX #$04FC            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_191B:      LBRA Sub_0E2A         
Sub_191E:      PSHS A,X,Y            
	LEAX Dat_03FC,PCR          ; X → Dat_03FC
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_1ED7          ; call Sub_1ED7
	PULS A,X,Y            
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_192F:      PSHS U                
	LBSR Sub_1529          ; call Sub_1529
	LDB #$13               ; B = XOFF
	LEAY Dat_03D8,PCR          ; Y → Dat_03D8
	LDX #$13C3            
	JSR [$0CB1]            ; call via indexed pointer
	LDX #$13C3            
	LDA <$9D              
	STA 5,X               
	LDA <$9E              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	TSTA                  
	BEQ *+4
	SUBA #$03             
Sub_1950:      STA 6,X               
	LDA $0CC7             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 7,X               
	LDA $0CC8             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 8,X               
	LDA #$01              
	LDY #$0009            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAU Dat_02FB,PCR          ; U → Dat_02FB
	LEAX Dat_02F6,PCR          ; X → Dat_02F6
	CLRB                   ; B = 0
	LDA #$11               ; A = XON
	OS9 F$Fork             ; module→D:X  args→Y  size=D
	PULS U                
	BCS *+19  ; C=1 (BLO)
	STA <$7F              
Sub_197F:      LDX #$0001            
	LBSR Sub_1178          ; call Sub_1178
	OS9 F$Wait             ; → wait for child; status→D
	BCS *+6  ; C=1 (BLO)
	CMPA <$7F             
	BNE *-13
Sub_198E:      LDA #$01              
	LEAX Dat_03EC,PCR          ; X → Dat_03EC
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_14A5          ; call Sub_14A5
	LBRA Sub_0E2A         
         FCB    $A6,$80,$A7,$A0,$81,$20,$27,$03,$5A,$26,$F5,$39  ; unreachable padding
Sub_19AD:      EQU    $19AD            ; [*8] undefined opcode at $19AD — see [*8]
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	BEQ *+11
	LDA <$7E              
	BEQ *+10
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	JMP $17F7             
	EORA #$16             
Sub_19BA:      LBRA Sub_0E2A         
Sub_19BD:      EQU    Sub_19BA+3       ; [*9] branch target 3 byte(s) inside Sub_19BA — see [*9]
	JMP $308D             
	ADCB ?$CF             
	LDY #$0080            
	LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
	JSR [$0CAF]            ; call via indexed pointer
	LDX #$0080            
	LDY #$000B            
	LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA <$7C              
	STA <$7D              
	BRA *-35

; --------------------------------------------------------------
Sub_19DF:      LDD #$0802            
	STD $0C9A             
	LDD #$400A            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_030D,PCR          ; X → Dat_030D
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$13C3            
	LDA #$01              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDX #$13C3            
	LDA #$01              
	STA 5,X               
	CLR 7,X               
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDA #$00               ; A = NUL
	OS9 I$Dup              ; path=A  → new path→A
	STA <$79              
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA <$38              
	OS9 I$Dup              ; path=A  → new path→A
	PSHS U                
	LEAU Dat_02FF,PCR          ; U → Dat_02FF
	LEAX Dat_02FC,PCR          ; X → Dat_02FC
	LDY #$000E            
	CLRB                   ; B = 0
	LDA #$11               ; A = XON
	OS9 F$Fork             ; module→D:X  args→Y  size=D
	PULS U                
	PSHS CC               
	STA <$7F              
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA <$79              
	OS9 I$Dup              ; path=A  → new path→A
	LDA <$79              
	OS9 I$Close            ; path=A
	PULS CC               
	BCS *+87  ; C=1 (BLO)
Sub_1A52:      LDX #$0001            
	LBSR Sub_1178          ; call Sub_1178
	LDA #$00               ; A = NUL
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+52  ; C=1 (BLO)
	CLRA                   ; A = 0
	CMPB #$00              ; compare B with NUL
	BEQ *+47
	TFR D,Y               
	LDX #$13C3            
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDA $13C3             
	CMPA #$05             
	BNE *+32
	LBSR Sub_1BD1          ; call Sub_1BD1
	LDX #$002D            
	LBSR Sub_1178          ; call Sub_1178
	LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+34  ; C=1 (BLO)
	TFR D,Y               
	LDX #$13C3            
	LDA <$38              
	OS9 I$Read             ; path=A  count=Y  buf→X
	BRA *+22

; --------------------------------------------------------------
Sub_1A93:      OS9 F$Wait             ; → wait for child; status→D
	BCS *+17  ; C=1 (BLO)
	CMPA <$7F             
	BNE *-72
	TSTB                  
	BEQ *+7
	LBSR Sub_2C62          ; call Sub_2C62
	BRA *+5

; --------------------------------------------------------------
Sub_1AA4:      LBSR Sub_1F7D          ; call Sub_1F7D
Sub_1AA7:      LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_14A5          ; call Sub_14A5
	LBSR Sub_1E33          ; call Sub_1E33
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_1ABA:      LDD #$0802            
	STD $0C9A             
	LDD #$400A            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_034E,PCR          ; X → Dat_034E
	LBSR Sub_1D95          ; call Sub_1D95
	LDY #$071A            
	STY <$53              
	LEAX Dat_033F,PCR          ; X → Dat_033F
Sub_1ADB:      LDA ,X+               
	BEQ *+6
	STA ,Y+               
	BRA *-6

; --------------------------------------------------------------
Sub_1AE3:      LDA #$20               ; A = ' '
	STA ,Y+               
Sub_1AE7:      LEAX Dat_0585,PCR          ; X → Dat_0585
	PSHS Y                
	LBSR Sub_1D95          ; call Sub_1D95
	PULS Y                
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LBSR Sub_1DF0          ; call Sub_1DF0
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAX -16,X            
	BNE *+2
Sub_1AFC:      LDX $8E06             
	FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
	LDB $002C             
	CMPB #$01             
	BEQ *+15
Sub_1B07:      LDA ,X+               
	STA ,Y+               
	DECB                  
	BNE *-5
	LDA #$20               ; A = ' '
	STA -1,Y              
	BRA *-43

; --------------------------------------------------------------
Sub_1B14:      LDA #$0D               ; A = CR
	STA ,Y+               
	TFR Y,D               
	SUBD <$53             
	STD <$53              
	CMPD #$0007           
	LBCS Sub_1BBE         
	LBSR Sub_212D          ; call Sub_212D
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$13C3            
	LDA #$01              
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDA #$01              
	LDX #$13C3            
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	STA 5,X               
	CLR 7,X               
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDA #$00               ; A = NUL
	OS9 I$Dup              ; path=A  → new path→A
	STA <$79              
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA <$38              
	OS9 I$Dup              ; path=A  → new path→A
	LDY <$53              
	PSHS U                
	LDU #$071A            
	LEAX Dat_033C,PCR          ; X → Dat_033C
	CLRB                   ; B = 0
	LDA #$11               ; A = XON
	OS9 F$Fork             ; module→D:X  args→Y  size=D
	PULS U                
	PSHS CC               
	STA <$7F              
	LDA #$00               ; A = NUL
	OS9 I$Close            ; path=A
	LDA <$79              
	OS9 I$Dup              ; path=A  → new path→A
	LDA <$79              
	OS9 I$Close            ; path=A
	PULS CC               
	BCS *+60  ; C=1 (BLO)
Sub_1B84:      LDX #$0001            
	LBSR Sub_1178          ; call Sub_1178
	LDA #$00               ; A = NUL
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *+25  ; C=1 (BLO)
	CLRA                   ; A = 0
	CMPB #$00              ; compare B with NUL
	BEQ *+20
	TFR D,Y               
	LDX #$13C3            
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDA $13C3             
	CMPA #$05             
	BNE *+5
	LBSR Sub_1BD1          ; call Sub_1BD1
Sub_1BAA:      OS9 F$Wait             ; → wait for child; status→D
	BCS *+17  ; C=1 (BLO)
	CMPA <$7F             
	BNE *-45
	TSTB                  
	BEQ *+7
	LBSR Sub_2C62          ; call Sub_2C62
	BRA *+5

; --------------------------------------------------------------
Sub_1BBB:      LBSR Sub_1F7D          ; call Sub_1F7D
Sub_1BBE:      LBSR Sub_1F53          ; call Sub_1F53
	LBSR Sub_14A5          ; call Sub_14A5
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
Sub_1BCB:      LBSR Sub_1E33          ; call Sub_1E33
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_1BD1:      LDA <$7F              
	CLRB                   ; B = 0
	OS9 F$Send             ; pid=A  signal=B
	OS9 F$Wait             ; → wait for child; status→D
Insn_1BDA:     RTS                    ; return from subroutine
Sub_1BDB:      EQU    Insn_1BDA+1      ; [*10] branch target 1 byte(s) inside Insn_1BDA — see [*10]
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	BEQ *+7
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	JMP $17F5             
	FCB    $5E                ; undefined opcode $5E -- not a valid 6809 instruction
Sub_1BE4:      CLR $0C8F             
	LDD #$2105            
	STD $0C9A             
	LDD #$0E03            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_0375,PCR          ; X → Dat_0375
	LBSR Sub_1D95          ; call Sub_1D95
	TST $0CC0             
	BNE *+45
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	BVS *+41
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LDA <$38              
	LDB #$2B               ; B = SS.CtlSg  (GetStt/SetStt subcode)
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
Sub_1C13:      LDX #$8E00            
	CWAI #$17             
	BITB $5E20            
	FCB    $41                ; undefined opcode $41 -- not a valid 6809 instruction
	LDX <$20              
	LDB 2,X               
	ANDB #$FE             
	STB 2,X               
	LDX #$003C            
	LBSR Sub_1178          ; call Sub_1178
	LDX <$20              
	LDB 2,X               
	ORB #$01              
	STB 2,X               
	BRA *+43

; --------------------------------------------------------------
Sub_1C33:      BVS *-104
Sub_1C34:      LDA <$38              
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
Sub_1C38:      LEAX Dat_0A7F,PCR          ; X → Dat_0A7F
Sub_1C3B:      COMA                  
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$000C            
	LBSR Sub_1178          ; call Sub_1178
	DECB                  
	BNE *-18
	LDX #$0080            
	LBSR Sub_1178          ; call Sub_1178
	LEAX Dat_02F2,PCR          ; X → Dat_02F2
	LDY #$0004            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_1C6A:      PSHS A,B,X,Y          
	LDX #$133B            
	BRA *+14

; --------------------------------------------------------------
Sub_1C71:      PSHS A,B,X,Y          
	SUBA #$B1             
	LDB #$80              
	MUL                    ; D = A×B unsigned
	LDX #$0D3B            
	LEAX D,X              
	PSHS X                
	CLRB                   ; B = 0
	LDA ,X+               
	INCB                  
	CMPB #$80             
	BHI *+6
	CMPA #$0D              ; compare A with CR
	BNE *-9
	DECB                  
	CLRA                   ; A = 0
	PULS X                
	TSTB                  
	BEQ *+14
	LDA ,X+               
	DECB                  
	CMPA #$5C              ; compare A with '\'
	BEQ *+21
	BSR *+48
	TSTB                  
	BNE *-10
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $34,$10,$8E,$00,$1E,$17,$F4,$D0,$35,$10,$20,$EF,$A6,$80,$5A,$81,$5E,$27,$12,$81,$2A,$27,$E9,$81,$5C,$27,$06,$81,$2B,$27,$1C,$80,$40,$8D,$06,$20,$D6,$86,$1B,$20,$F8,$34,$32,$8E,$13,$C3,$A7,$84,$10,$8E,$00,$01,$96,$38,$10,$3F,$8A,$35,$B2,$34,$36,$8E,$13,$C3,$10,$3F,$15,$8E,$13,$C3,$EC,$01,$34,$02,$8D,$19,$ED,$03,$86,$5F,$A7,$02,$35,$04,$8D,$0F,$ED,$84,$96,$38,$10,$8E,$00,$05,$10,$3F,$8A,$35,$36,$20,$96,$86,$30,$CB,$30,$C1,$3A,$25,$05,$4C,$C0,$0A,$20,$F7,$39  ; unreachable padding
Sub_1D13:      PSHS A,X,Y            
	LDD #$1B24             ; D=ESC+'$'  → W.DWEnd: Device Window End
	STD $13C3             
	LDA #$01              
	LDY #$0002            
	LDX #$13C3            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAY Dat_048F,PCR          ; Y → Dat_048F
	LDX #$13C3            
	LDB #$0C               ; B = FF
	JSR [$0CB1]            ; call via indexed pointer
	LDX #$13C3            
	LEAX 2,X              
	LDA #$1E              
Sub_1D3B:      STA $0C91             
	STA 6,X               
	STA <$9E              
	LDY #$000A            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	BCS *+18  ; C=1 (BLO)
	LDA 5,X               
	STA <$9D              
	LDA 6,X               
	STA <$9E              
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
Sub_1D5B:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1D5D:      LDA $0C91             
	DECA                  
	PSHS X                
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	PULS X                
	CMPA #$0A              ; compare A with LF
	BHI *+7
	COMB                  
	LDB #$C3              
	BRA *-23

; --------------------------------------------------------------
Sub_1D74:      BRA *-57
Sub_1D76:      LEAX Dat_048D,PCR          ; X → Dat_048D
	LDA #$02               ; A = CurXY
	OS9 I$Open             ; mode=B  name→X  → path→A
	STA <$4B              
	LEAX Dat_049D,PCR          ; X → Dat_049D
	LDY #$000A            
	LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1D95:      LDA #$01              
Sub_1D97:      LDY ,X++              
	OS9 I$Write            ; path=A  count=Y  buf→X
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1D9E:      BSR *+17  ; call Sub_1DAF
	CMPA #$79              ; compare A with 'y'
	LBEQ Sub_10E5         
	CMPA #$59              ; compare A with 'Y'
	LBEQ Sub_10E5         
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_1DAF:      PSHS Y                
	LDD #$1D04            
	STD $0C9A             
	LDD #$1603            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_04BF,PCR          ; X → Dat_04BF
	BSR *-47  ; call Sub_1D95
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	BSR *-53  ; call Sub_1D95
	LBSR Sub_2C5A          ; call Sub_2C5A
	PSHS A                
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	BSR *-64  ; call Sub_1D95
	LBSR Sub_1F53          ; call Sub_1F53
	PULS A                
	PULS Y,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1DDE:      PSHS B,X              
	LDX #$0CA3            
	OS9 F$Time             ; buf→X  → 6-byte time
	LDA 5,X               
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1DF0:      PSHS A,B,X,Y          
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	BMI *+17
	BGE *+17
	LEAX ?$8E             
	FCB    $06                ; undefined opcode $06 -- not a valid 6809 instruction
	FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
Sub_1DFB:      LBSR Sub_2C5A          ; call Sub_2C5A
	CMPA #$2D              ; compare A with '-'
	BLS *+15
	TSTB                  
	BEQ *-8
Sub_1E04:      LDB $A780             
Sub_1E06:      SUBA #$5A             
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	BGE *+25
	FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
	BGT *+34
	LDD ,X++              
Sub_1E0F:      CMPA #$08              ; compare A with BS
	BNE *+16
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	BGE *+41
	ANDB -4,U             
	FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
	BGE *+50
	TFR X,?               
	FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
	ANDCC #$20             ; clr CC: C,V,Z,N,I,F,E
Insn_1E20:     ORB <$81              
Sub_1E21:      CMPA #$05             
Sub_1E22:      EQU    Sub_1E21+1       ; [*11] branch target 1 byte(s) inside Sub_1E21 — see [*11]
	BNE *+6
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	LEAX 0,Y              
	FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
Sub_1E29:      CMPA #$0D              ; compare A with CR
	BNE *-48
	STA ,X                
Sub_1E2E:      ANDA #$0C             
	BGE *+55
	LDA $8600             
Sub_1E33:      LDA #$00               ; A = NUL
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+3  ; C=0 (BHS)
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1E3D:      TSTB                  
	BEQ *+13
	CLRA                   ; A = 0
	TFR D,Y               
	LDX #$13C3            
	LDA #$00               ; A = NUL
	OS9 I$Read             ; path=A  count=Y  buf→X
Sub_1E4B:      RTS                    ; return from subroutine
Sub_1E4C:      PSHS A,B,X            
	LDB #$08               ; B = BS
	LDX #$0D3B            
	LDA #$0D               ; A = CR
	STA ,X                
	STA 1,X               
	LEAX 128,X            
	DECB                  
	BNE *-9
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
         FCB    $39  ; unreachable padding
Sub_1E63:      LDA <$70              
	CMPA #$02              ; compare A with CurXY
Sub_1E67:      BNE *+8
	LEAY Dat_039D,PCR          ; Y → Dat_039D
	BRA *+37

; --------------------------------------------------------------
Sub_1E6F:      TST $0CBB             
	BNE *+28
	LEAY Dat_03BD,PCR          ; Y → Dat_03BD
	LDD #$0001            
	STD <$8E              
	LDD #$0203            
	STD <$90              
	LDD #$0405            
	STD <$92              
	LDD #$0607            
	STD <$94              
	BRA *+26

; --------------------------------------------------------------
Sub_1E8E:      LEAY Dat_03AD,PCR          ; Y → Dat_03AD
Sub_1E92:      LDD #$0704            
	STD <$8E              
	LDD #$0002            
	STD <$90              
	LDD #$0103            
	STD <$92              
	LDD #$0506            
	STD <$94              
Sub_1EA6:      LDX #$13C3            
	LDD #$1B31             ; D=ESC+$31
	STD ,X                
	CLRA                   ; A = 0
Sub_1EAF:      LDB A,Y               
	PSHS A,Y              
	STD 2,X               
	LDY #$0004            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,Y              
	INCA                  
	CMPA #$10             
	BCS *-20  ; C=1 (BLO)
	LBSR Sub_2D87          ; call Sub_2D87
	LBSR Sub_2D08          ; call Sub_2D08
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_1ECC:      PSHS B,X              
	LDX #$008E            
	LDB A,X               
	TFR B,A               
	PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1ED7:      PSHS A,X              
	LDA $0CC7             
	BSR *-16  ; call Sub_1ECC
	LBSR Sub_2588          ; call Sub_2588
	LDA $0CC8             
	BSR *-24  ; call Sub_1ECC
	LBSR Sub_257C          ; call Sub_257C
	LDA $0090             
	LBSR Sub_2582          ; call Sub_2582
	PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1EF1:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
	STD ,X                
	LDA #$01              
	STA 2,X               
	LDD $0C9A             
	ADDA #$01             
	ADDB #$01             
	STD 3,X               
	LDD $0C9C             
	STD 5,X               
	LDA $0CCE             
	LBSR Sub_1ECC          ; call Sub_1ECC
	TFR A,B               
	CLRA                   ; A = 0
	STD 7,X               
	LDA #$01              
	LDY #$0009            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDD #$1B22             ; D=ESC+'"'  → W.OWSet: Overlay Window Set
	STD ,X                
	LDA #$01              
	STA 2,X               
	LDD $0C9A             
	STD 3,X               
	LDD $0C9C             
	STD 5,X               
	LDA $0CCC             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 7,X               
	LDA $0CCD             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 8,X               
	LDA #$0C               ; A = FF
	STA 9,X               
	LDA #$01              
	LDY #$000A            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1F53:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDD #$1B23             ; D=ESC+'#'  → W.OWEnd: Overlay Window End
	STD ,X                
	LDA #$01              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1F6B:      PSHS A,B,X,Y          
	LDX #$1003            
	LDY #$0EA0            
Sub_1F74:      LDA #$01              
	LDB #$98              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_1F7D:      PSHS A,B,X,Y          
	LDX #$3F03            
	LDY #$0FD1            
	BRA *-18

; --------------------------------------------------------------
Sub_1F88:      PSHS A,B,X            
	LDB #$1D              
	LDA <$38              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	BCC *+14  ; C=0 (BHS)
	LDX <$20              
	LDA 2,X               
	ORA #$0C              
	STA 2,X               
	ANDA <$F3             
	STA 2,X               
Sub_1F9F:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_1FA1:      PSHS A,B,X,Y          
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$1E03            
	STD $0C9A             
	LDD #$1203            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_0663,PCR          ; X → Dat_0663
	LBSR Sub_1D95          ; call Sub_1D95
	LDB $0CBA             
	ANDB #$0F             
Sub_1FC5:      STB $0C91             
	LEAX Dat_03F0,PCR          ; X → Dat_03F0
	LDY #$0006            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_0679,PCR          ; X → Dat_0679
	LDA #$06              
	LDB $0C91             
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	LDA #$01              
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_1FEA:      LBSR Sub_2C5A          ; call Sub_2C5A
	CMPA #$0D              ; compare A with CR
	BEQ *+22
	CMPA #$05             
	BEQ *+18
	CMPA #$20              ; compare A with ' '
	BNE *-13
	LDB $0C91             
	INCB                  
	CMPB $0CB9            
	BLS *-59
	CLRB                   ; B = 0
	BRA *-62

; --------------------------------------------------------------
Sub_2005:      LDB $0CBA             
	ANDB #$F0             
	ORB $0C91             
	STB $0CBA             
	LBSR Sub_1F53          ; call Sub_1F53
	LBSR Sub_1396          ; call Sub_1396
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_201F:      PSHS A,X,Y            
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LDA ?$F7              
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	CMPA <$8E             
	SYNC                   ; wait for interrupt
	ADDD #$CC1B           
	BCS *-17  ; C=1 (BLO)
	ANDA #$CC             
	FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
	FCB    $02                ; undefined opcode $02 -- not a valid 6809 instruction
	STD 2,X               
	LDA #$04              
	LDB $13BD             
	INCB                  
	STD 4,X               
	LDA #$01              
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDB $0C91             
Sub_2047:      CLRA                   ; A = 0
	INCB                  
	TFR D,Y               
	LEAX Dat_06E7,PCR          ; X → Dat_06E7
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_06F2,PCR          ; X → Dat_06F2
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_205F:      LBSR Sub_2C62          ; call Sub_2C62
	ANDA #$7F             
	CMPA #$0A              ; compare A with LF
	BEQ *+20
	CMPA #$0C              ; compare A with FF
	BEQ *+31
	CMPA #$20              ; compare A with ' '
	BEQ *+39
	CMPA #$05             
	BEQ *+40
	CMPA #$0D              ; compare A with CR
	BEQ *+45
	BRA *-25

; --------------------------------------------------------------
Sub_207A:      LDB $0C91             
	INCB                  
	CMPB $13BD            
	BCS *+3  ; C=1 (BLO)
	CLRB                   ; B = 0
Sub_2084:      STB $0C91             
	BRA *-64

; --------------------------------------------------------------
Sub_2089:      LDB $0C91             
	DECB                  
	BPL *+6
	LDB $13BD             
Sub_2090:      SYNC                   ; wait for interrupt
	JSR $5A20             
Sub_2093:      BRA *-15
Sub_2095:      LDB $0C91             
Sub_2098:      PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_209A:      LDB $13BD             
	INCB                  
	STB $0C91             
Insn_20A1:      BRA *-9
Sub_20A3:      EQU    Insn_20A2+1      ; [*12] branch target 1 byte(s) inside Insn_20A2 — see [*12]
	LDA 0,Y               
	LDU -12,Y             
Sub_20A7:      PSHS A,B,X,Y          
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$1C03            
	STD $0C9A             
	LDD #$1703            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_06F5,PCR          ; X → Dat_06F5
	LBSR Sub_1D95          ; call Sub_1D95
	LDB $0CBB             
Sub_20C9:      STB $0C91             
	LEAX Dat_03F0,PCR          ; X → Dat_03F0
	LDA #$01              
	LDY #$0005            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_070F,PCR          ; X → Dat_070F
	LDA #$05              
	LDB $0C91             
	MUL                    ; D = A×B unsigned
	LEAX D,X              
Insn_20E5:     LDY #$0005            
Sub_20E8:      EQU    Insn_20E5+3      ; [*13] branch target 3 byte(s) inside Insn_20E5 — see [*13]
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_20EE:      LBSR Sub_2C5A          ; call Sub_2C5A
	CMPA #$0D              ; compare A with CR
	BEQ *+23
	CMPA #$05             
	BEQ *+19
	CMPA #$20              ; compare A with ' '
	BNE *-13
	INC $0C91             
	LDB $0C91             
	CMPB #$03             
	BNE *-60
	CLRB                   ; B = 0
	BRA *-63

; --------------------------------------------------------------
Sub_210A:      LDB $0C91             
	STB $0CBB             
	LBSR Sub_1E63          ; call Sub_1E63
	LBSR Sub_1F53          ; call Sub_1F53
	LBSR Sub_1ED7          ; call Sub_1ED7
	BSR *+20  ; call Sub_212D
	LBSR Sub_15F3          ; call Sub_15F3
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	TSTA                  
	BEQ *+4
	BSR *+20  ; call Sub_2136
Sub_2124:      LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_212D:      PSHS A                
	LDA #$0C               ; A = FF
	LBSR Sub_213B          ; call Sub_213B
	PULS A,PC              ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2136:      PSHS A,B,X,Y          
	LBRA Sub_28B5         

; --------------------------------------------------------------
Sub_213B:      PSHS A,B,X,Y          
	LDX #$002A            
	STA ,X                
	LDY #$0001            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_214D:      PSHS A,B,X,Y          
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$0CCC            
	LDD ,X                
	PSHS A,B              
	LDA 2,X               
	PSHS A                
	LDD #$0001            
	STD ,X                
	LDA #$06              
	STA 2,X               
	LDD #$1903            
	STD $0C9A             
	LDD #$210D            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LDX #$0CCC            
	PULS A                
	STA 2,X               
	PULS A,B              
	STD ,X                
	LEAX Dat_0915,PCR          ; X → Dat_0915
	LBSR Sub_1D95          ; call Sub_1D95
	CLRB                   ; B = 0
Sub_218C:      LBSR Sub_221A          ; call Sub_221A
	INCB                  
	CMPB #$0A              ; compare B with LF
	BNE *-6
	LDA #$0A               ; A = LF
	STA $13BD             
	CLRB                   ; B = 0
Sub_219A:      LBSR Sub_201F          ; call Sub_201F
	LDX #$13C3            
	LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
	STD ,X                
	LDD #$0000            
	STD 2,X               
	LDD #$210D            
	STD 4,X               
	LDY #$0006            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LDA -16,X             
	BNE *+2
Sub_21BD:      ORCC #$F6              ; set CC: V,Z,I,H,F,E
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	CMPA <$C1             
	FCB    $09                ; undefined opcode $09 -- not a valid 6809 instruction
	LBHI Sub_21D8         
	LDX #$0CC7            
	LDA B,X               
	INCA                  
	CMPA #$08              ; compare A with BS
	BCS *+3  ; C=1 (BLO)
	CLRA                   ; A = 0
Sub_21D2:      STA B,X               
	BSR *+70  ; call Sub_221A
	BRA *-60

; --------------------------------------------------------------
Sub_21D8:      LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$13C3            
	LDD #$1B32             ; D=ESC+'2'  → W.FColor: Foreground Color
	STD ,X                
	INCB                  
	STD 3,X               
	INCB                  
	STD 6,X               
	LDA $0CC7             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 2,X               
	LDA $0CC8             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 5,X               
	LDA $0090             
	STA 8,X               
	LDA #$0C               ; A = FF
	STA 9,X               
	LDY #$000A            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_2D87          ; call Sub_2D87
	LBSR Sub_2D08          ; call Sub_2D08
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_221A:      PSHS A,B,X,Y          
	INCB                  
	INCB                  
	LDA #$15              
	LBSR Sub_24DC          ; call Sub_24DC
	LDA 1,S               
	LDX #$0CC7            
	LDB A,X               
	LEAX Dat_0ADF,PCR          ; X → Dat_0ADF
	LDA #$07              
	MUL                    ; D = A×B unsigned
	ABX                   
	LDA #$01              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_223D:      PSHS A,B,X,Y          
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$1F03            
	STD $0C9A             
	LDD #$160E            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_0880,PCR          ; X → Dat_0880
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_23D2          ; call Sub_23D2
	LBSR Sub_23FD          ; call Sub_23FD
	LBSR Sub_240C          ; call Sub_240C
	LBSR Sub_23EE          ; call Sub_23EE
	LBSR Sub_24C2          ; call Sub_24C2
	LBSR Sub_2463          ; call Sub_2463
	LBSR Sub_24A7          ; call Sub_24A7
	LBSR Sub_241B          ; call Sub_241B
	LBSR Sub_242A          ; call Sub_242A
	LBSR Sub_2439          ; call Sub_2439
	LBSR Sub_2448          ; call Sub_2448
	LDA #$0B              
	STA $13BD             
	CLRB                   ; B = 0
Sub_2283:      LBSR Sub_201F          ; call Sub_201F
	LDX #$13C3            
	LDD #$1B25             ; D=ESC+'%'  → W.CWArea: Change Working Area
	STD ,X                
	LDD #$0000            
	STD 2,X               
	LDD #$160E            
	STD 4,X               
	LDY #$0006            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LDA -16,X             
	BNE *+3
	TFR ?,?               
Sub_22A7:      LDB $0C91             
	CMPB #$0A              ; compare B with LF
	LBHI Sub_23C6         
	CMPB #$00              ; compare B with NUL
	BNE *+15
	LDA $0CBC             
	BNE *+7
	INC $0CBC             
	BRA *+5

; --------------------------------------------------------------
Sub_22BE:      CLR $0CBC             
Sub_22C1:      LBSR Sub_23D2          ; call Sub_23D2
	CMPB #$03             
	BNE *+15
	LDA $0CBF             
	BNE *+7
	INC $0CBF             
	BRA *+5

; --------------------------------------------------------------
Sub_22D2:      CLR $0CBF             
Sub_22D5:      LBSR Sub_23EE          ; call Sub_23EE
	CMPB #$07             
	BNE *+15
	LDA $0CC6             
	BNE *+7
	INC $0CC6             
	BRA *+5

; --------------------------------------------------------------
Sub_22E6:      CLR $0CC6             
Sub_22E9:      LBSR Sub_241B          ; call Sub_241B
	LBSR Sub_1396          ; call Sub_1396
	CMPB #$05             
	BNE *+38
	LDA $0CC1             
	ANDA #$E0             
	CMPA #$00              ; compare A with NUL
	BEQ *+34
	CMPA #$E0             
	BEQ *+34
	ADDA #$40             
Sub_2302:      PSHS B                
	LDB $0CC1             
	ANDB #$1F             
	STB $0CC1             
	PULS B                
	ORA $0CC1             
	STA $0CC1             
	LBSR Sub_1396          ; call Sub_1396
Sub_2317:      LBSR Sub_2463          ; call Sub_2463
	BRA *+9

; --------------------------------------------------------------
Sub_231C:      ADDA #$20             
	BRA *-28

; --------------------------------------------------------------
Sub_2320:      CLRA                   ; A = 0
	BRA *-31

; --------------------------------------------------------------
Sub_2323:      CMPB #$06             
	BNE *+22
	LDA $0CBA             
	BPL *+6
	ANDA #$7F             
	BRA *+4

; --------------------------------------------------------------
Sub_2330:      ORA #$80              
Sub_2332:      STA $0CBA             
	LBSR Sub_1396          ; call Sub_1396
	LBSR Sub_24A7          ; call Sub_24A7
Sub_233B:      CMPB #$04             
	BNE *+24
	LDA $0CBA             
	BITA #$20             
	BEQ *+6
	ANDA #$DF             
	BRA *+4

; --------------------------------------------------------------
Sub_234A:      ORA #$20              
Sub_234C:      STA $0CBA             
	LBSR Sub_1396          ; call Sub_1396
	LBSR Sub_24C2          ; call Sub_24C2
Sub_2355:      CMPB #$01             
	BNE *+15
	LDA $0CBD             
	BNE *+7
	INC $0CBD             
	BRA *+5

; --------------------------------------------------------------
Sub_2363:      CLR $0CBD             
Sub_2366:      LBSR Sub_23FD          ; call Sub_23FD
	CMPB #$02              ; compare B with CurXY
	BNE *+18
	LDA $0CBE             
	BNE *+7
	INC $0CBE             
	BRA *+8

; --------------------------------------------------------------
Sub_2377:      CLR $0CBE             
	LBSR Sub_1396          ; call Sub_1396
Sub_237D:      LBSR Sub_240C          ; call Sub_240C
	CMPB #$08              ; compare B with BS
	BNE *+15
	TST $0CC0             
	BNE *+7
	INC $0CC0             
	BRA *+5

; --------------------------------------------------------------
Sub_238E:      CLR $0CC0             
Sub_2391:      LBSR Sub_2448          ; call Sub_2448
	CMPB #$09             
	BNE *+15
	TST $0CC3             
	BNE *+7
	INC $0CC3             
	BRA *+5

; --------------------------------------------------------------
Sub_23A2:      CLR $0CC3             
Sub_23A5:      LBSR Sub_2439          ; call Sub_2439
	CMPB #$0A              ; compare B with LF
	BNE *+15
	TST $0CC2             
	BNE *+7
	INC $0CC2             
	BRA *+5

; --------------------------------------------------------------
Sub_23B6:      CLR $0CC2             
Sub_23B9:      LBSR Sub_242A          ; call Sub_242A
	CMPB #$0A              ; compare B with LF
	BHI *+8
	LDB $0C91             
	LBRA Sub_2283         

; --------------------------------------------------------------
Sub_23C6:      LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_23D2:      PSHS A,B,X            
	LDD #$1102            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CBC             
	BNE *+11
Sub_23DF:      LEAX Dat_0A83,PCR          ; X → Dat_0A83
Sub_23E3:      LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_23E8:      LEAX Dat_0A89,PCR          ; X → Dat_0A89
	BRA *-9

; --------------------------------------------------------------
Sub_23EE:      PSHS A,B,X            
	LDD #$1105            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CBF             
	BNE *-17
	BRA *-28

; --------------------------------------------------------------
Sub_23FD:      PSHS A,B,X            
	LDD #$1103            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CBD             
	BNE *-32
	BRA *-43

; --------------------------------------------------------------
Sub_240C:      PSHS A,B,X            
	LDD #$1104            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CBE             
	BNE *-47
	BRA *-58

; --------------------------------------------------------------
Sub_241B:      PSHS A,B,X            
	LDD #$1109            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CC6             
	BNE *-62
	BRA *-73

; --------------------------------------------------------------
Sub_242A:      PSHS A,B,X            
	LDD #$110C            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CC2             
	BNE *-77
	BRA *-88

; --------------------------------------------------------------
Sub_2439:      PSHS A,B,X            
	LDD #$110B            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CC3             
	BEQ *-92
	BRA *-103

; --------------------------------------------------------------
Sub_2448:      PSHS A,B,X            
	LDD #$110A            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CC0             
	BNE *+9
	LEAX Dat_0A77,PCR          ; X → Dat_0A77
	LBRA Sub_23E3         

; --------------------------------------------------------------
Sub_245C:      LEAX Dat_0A7D,PCR          ; X → Dat_0A7D
	LBRA Sub_23E3         

; --------------------------------------------------------------
Sub_2463:      PSHS A,B,X,Y          
	LDD #$1007            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CC1             
	ANDA #$E0             
	CMPA #$A0             
	BNE *+8
	LEAX Dat_0A8E,PCR          ; X → Dat_0A8E
	BRA *+36

; --------------------------------------------------------------
Sub_247A:      CMPA #$E0             
	BNE *+8
	LEAX Dat_0A93,PCR          ; X → Dat_0A93
	BRA *+26

; --------------------------------------------------------------
Sub_2484:      CMPA #$60              ; compare A with '`'
	BNE *+8
Insn_2488:     LEAX Dat_0A98,PCR          ; X → Dat_0A98
Sub_248B:      EQU    Insn_2488+3      ; [*14] branch target 3 byte(s) inside Insn_2488 — see [*14]
	BRA *+16

; --------------------------------------------------------------
Sub_248E:      CMPA #$20              ; compare A with ' '
	BNE *+8
	LEAX Dat_0A9D,PCR          ; X → Dat_0A9D
	BRA *+6

; --------------------------------------------------------------
Sub_2498:      LEAX Dat_0AA2,PCR          ; X → Dat_0AA2
Sub_249C:      LDA #$01              
	LDY #$0005            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_24A7:      PSHS A,B,X            
	LDD #$1208            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CBA             
	BPL *+9
	LDA #$32               ; A = '2'
	LBSR Sub_213B          ; call Sub_213B
	BRA *+7

; --------------------------------------------------------------
Sub_24BB:      LDA #$31               ; A = '1'
	LBSR Sub_213B          ; call Sub_213B
Sub_24C0:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_24C2:      PSHS A,B,X            
	LDD #$1206            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA $0CBA             
	BITA #$20             
	BNE *+6
	LDA #$38               ; A = '8'
	BRA *+4

; --------------------------------------------------------------
Sub_24D5:      LDA #$37               ; A = '7'
Sub_24D7:      LBSR Sub_213B          ; call Sub_213B
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_24DC:      PSHS A,B,X,Y          
	LDX #$00A2            
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
Sub_24F8:      PSHS A,B,X,Y          
	LDD #$1504            
	STD $0C9A             
	LDD #$2507            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_0542,PCR          ; X → Dat_0542
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$0102            
	BSR *-55  ; call Sub_24DC
	LDA #$01              
	LDX #$0CF1            
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LDB #$1F              
	LEAX -6784,PC,PCR         
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_1DF0          ; call Sub_1DF0
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAX 6,Y              
Sub_252F:      BNE *+32
	LDA $061B             
	CMPA #$0D              ; compare A with CR
	BEQ *+25
	LDA #$03              
	LDX #$061B            
	OS9 I$ChgDir           ; mode=B  name→X
	BCS *+20  ; C=1 (BLO)
	LDX #$061B            
	LDY #$0CF1            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	JSR [$0CAF]            ; call via indexed pointer
Sub_254F:      LBSR Sub_1F53          ; call Sub_1F53
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2554:      LDA #$07              
	LBSR Sub_213B          ; call Sub_213B
	PSHS B                
	LDD #$0D02            
	LBSR Sub_24DC          ; call Sub_24DC
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	PULS B                
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_1178          ; call Sub_1178
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	BRA *-43

; --------------------------------------------------------------
Sub_257C:      PSHS A,B,X,Y          
	LDB #$33               ; B = '3'
	BRA *+12

; --------------------------------------------------------------
Sub_2582:      PSHS A,B,X,Y          
	LDB #$34               ; B = '4'
	BRA *+6

; --------------------------------------------------------------
Sub_2588:      PSHS A,B,X,Y          
	LDB #$32               ; B = '2'
Sub_258C:      LDX #$13C3            
	STA 2,X               
	LDA #$1B               ; A = ESC
	STD ,X                
	LDA #$01              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $20,$18  ; unreachable padding
Sub_25A2:      BRA *+24
Sub_25A4:      PSHS A,B              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
Sub_25A7:      PULS CC,A,B,Y         
	FCB    $06                ; undefined opcode $06 -- not a valid 6809 instruction
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	PULS CC,B,DP,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $F4,$35,$86,$0D,$34,$27,$FA,$0C,$35,$8D,$E8,$20,$F4  ; unreachable padding
Sub_25BA:      PSHS A,B,X,Y          
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	PULS A,B,Y            
	BVC *+51
	BSR *-26  ; call Sub_25A7
	STA ?$8E              
	SYNC                   ; wait for interrupt
	ADDD #$3410           
	LDB #$0C               ; B = FF
	JSR [$0CB1]            ; call via indexed pointer
	PULS X                
	LDA $0CCB             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 7,X               
	LDA $0CC9             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 11,X              
	LDA <$4B              
	LBSR Sub_1D97          ; call Sub_1D97
Sub_25E6:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $31,$8D,$E4,$72,$8E,$13,$C3,$34,$10,$C6  ; unreachable padding
Sub_25F2:      EQU    $25F2            ; [*15] undefined opcode at $25F2 — see [*15]
	JSR [$0CB1]            ; call via indexed pointer
	PULS X                
	LDA $0CC9             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 9,X               
	LDA <$4B              
	LBSR Sub_1D97          ; call Sub_1D97
	LDB <$1B              
	SUBB <$19             
	CLRA                   ; A = 0
	PSHS A,B              
	LDA <$15              
	BEQ *+5
	DECA                  
	SUBA <$16             
Sub_2614:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	ADDD ,S++             
	LBSR Sub_4403          ; call Sub_4403
	BRA *-54

; --------------------------------------------------------------
Sub_261E:      PSHS A,B,X,Y          
	LDX <$A0              
	CLRB                   ; B = 0
Sub_2623:      LDA ,X+               
	INCB                  
	CMPB #$1E             
	BHI *+9
	TSTA                  
	BMI *+6
	CMPA #$2E              ; compare A with '.'
	BNE *-12
Sub_2631:      ADDB #$08             
	LDX #$13C3            
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
Sub_2653:      PSHS A,B,X,Y          
	LDD <$5E              
	BNE *+4
	BRA *+85

; --------------------------------------------------------------
Sub_265B:      LDX #$00EF            
	LDY <$62              
	LDA <$4F              
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCC *+10  ; C=0 (BHS)
	LDY #$0000            
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	DEC 0,Y               
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
Sub_2670:      CMPY <$62             
	BEQ *+25
	TFR Y,D               
	LDX #$00EF            
	LEAX D,X              
	PSHS A,B              
	LDD <$62              
	SUBD ,S++             
	TFR D,Y               
	LDA #$1A               ; A = SUB
Sub_2686:      STA ,X+               
	LEAY -1,Y             
	BNE *-4
Sub_268C:      LDX #$00EC            
	LDD <$5E              
	STB 1,X               
	COMB                  
	STB 2,X               
	LDD <$5E              
	BEQ *+10
	LDD <$62              
	CMPD #$0080           
	BNE *+8
Sub_26A2:      LDA #$01              
	STA ,X                
	BRA *+6

; --------------------------------------------------------------
Sub_26A8:      LDA #$02               ; A = CurXY
	STA ,X                
Sub_26AC:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_26AE:      EQU    Sub_26AC+2       ; [*16] branch target 2 byte(s) inside Sub_26AC — see [*16]
	LSR $270C             
	LDX #$00EF            
	LDB #$80              
Sub_26B7:      CLR ,X+               
	DECB                  
	BNE *-3
	BRA *-48
         FCB    $8E,$00,$EF,$10,$8E,$00,$AC,$C6,$20,$A6,$A0,$27,$09,$81,$0D,$27,$05,$A7,$80,$5A,$26,$F3,$6F,$80,$17,$06,$DD,$20,$B1  ; unreachable padding
Sub_26DB:      PSHS A,B,X,Y          
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	COMB                  
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LSRB                  
	LDX #$00EF            
	LDD <$62              
	LEAY D,X              
	STY <$5B              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	BNE *+13
	LBSR Sub_3E41          ; call Sub_3E41
	LEAX D,X              
	LDA <$53              
	STA ,X                
Sub_26F8:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_26FA:      LBSR Sub_3E15          ; call Sub_3E15
	LEAX D,X              
	LDD <$53              
	STD ,X                
	BRA *-11

; --------------------------------------------------------------
Sub_2705:      PSHS A,B,X,Y          
	LDX #$113B            
	LDY #$0200            
Sub_270D:      EQU    $270D            ; [*17] undefined opcode at $270D — see [*17]
Sub_270E:      CLR ,X+               
	LEAY -1,Y             
	BNE *-4
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2716:      LDA -2,X              
	SUBA #$31             
	CMPA #$03             
	BHI *+85
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LDY #$123B            
	LEAY D,Y              
	LDB #$40               ; B = '@'
Sub_2729:      LDA ,X+               
	DECB                  
	CMPA #$0D              ; compare A with CR
	BEQ *+7
	STA ,Y+               
	TSTB                  
	BNE *-10
Sub_2735:      LDA #$0D               ; A = CR
	STA ,Y                
	BRA *+56

; --------------------------------------------------------------
Sub_273B:      LDA -2,X              
	SUBA #$31             
	CMPA #$03             
	BHI *+48
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LDY #$113B            
	LEAY D,Y              
	LDA #$01              
	STA $0C8F             
	PSHS X                
	LDX #$113B            
	STX $13BB             
	PULS X                
	LDB #$40               ; B = '@'
	LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+13
	CMPA #$5C              ; compare A with '\'
	BEQ *+15
	STA ,Y+               
	DECB                  
	BNE *-13
	BRA *+5
         FCB    $5F,$E7,$A4  ; unreachable padding
Sub_2771:      LBRA Sub_335E         
         FCB    $A6,$80,$80,$40,$20,$ED  ; unreachable padding
Sub_277A:      PSHS A,B,X,Y          
	LDB $0C96             
	LDY $13BB             
	LDA ,X+               
	ANDA #$7F             
	DECB                  
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	DEC $A1A4             
	BEQ *+38
	LDA $0C8F             
	DECA                  
	PSHS B                
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LDY #$113B            
	LEAY D,Y              
	STY $13BB             
	PULS B                
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	DEC $2604             
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
Insn_27A8:     DEC $20DF             
Sub_27AB:      EQU    Insn_27A8+3      ; [*18] branch target 3 byte(s) inside Insn_27A8 — see [*18]
	DEC $5D26             
	ADDD <$35             
	LDA $3121             
Sub_27B2:      LEAY 1,Y              
	STY $13BB             
	TST ,Y                
	BNE *-15
	LDA $0C8F             
	INC $0C8F             
	INC $0C90             
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LDY #$113B            
	LEAY D,Y              
	STY $13BB             
	BRA *-34

; --------------------------------------------------------------
Sub_27D4:      PSHS A,B,X,Y          
	CLR $0C90             
	LDA $0C8F             
	SUBA #$02             
	LDB #$40               ; B = '@'
	MUL                    ; D = A×B unsigned
	LDX #$123B            
	LEAX D,X              
	PSHS X                
	CLRB                   ; B = 0
	LDA ,X+               
	INCB                  
	CMPB #$40              ; compare B with '@'
	BHI *+6
	CMPA #$0D              ; compare A with CR
	BNE *-9
	DECB                  
	CLRA                   ; A = 0
	PULS X                
	TSTB                  
	BEQ *+15
	LDA ,X+               
	DECB                  
	CMPA #$5C              ; compare A with '\'
	BEQ *+22
	LBSR $1CC9            
	TSTB                  
	BNE *-11
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $34,$10,$8E,$00,$1E,$17,$E9,$66,$35,$10,$20,$EF,$A6,$80,$5A,$81,$5E,$27,$0F,$81,$2A,$27,$E9,$81,$5C,$27,$02,$80,$40,$17,$F4,$9F,$20,$D9,$86,$1B,$20,$F7  ; unreachable padding
Sub_2830:      PSHS A,B,X,Y          
Sub_2832:      EQU    Sub_2830+2       ; [*19] branch target 2 byte(s) inside Sub_2830 — see [*19]
	TSTA                  
	LBNE Sub_28C7         
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	TSTA                  
	BSR *+4  ; call Sub_283E
	BRA *+17

; --------------------------------------------------------------
Sub_283E:      LEAX Dat_048F,PCR          ; X → Dat_048F
	LDY #$13C3            
	LDB #$0C               ; B = FF
	JSR [$0CAF]            ; call via indexed pointer
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_284D:      LDX #$13C3            
	LDA <$9D              
	LDB <$9E              
	SUBB #$03             
	STD 7,X               
	LDA #$FF              
	STA 4,X               
	LDA $0CC7             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 9,X               
	LDA $0CC8             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 10,X              
	LDA #$01              
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA #$02               ; A = CurXY
	LEAX Dat_048D,PCR          ; X → Dat_048D
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *-76  ; C=1 (BLO)
	STA <$4C              
	LDX #$13C3            
	LEAX 2,X              
	CLR 2,X               
	LDA <$9E              
	SUBA #$02             
	STA 4,X               
	LDA #$03              
	STA 6,X               
	LDA $0CCF             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 7,X               
	LDA $0CD0             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 8,X               
	LDA <$4C              
	LDY #$0009            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDX #$13C3            
Sub_28B5:      LBSR Sub_2A0D          ; call Sub_2A0D
	LEAX Dat_0B1E,PCR          ; X → Dat_0B1E
	LDA <$4B              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_28C5:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_28C7:      EQU    Sub_28C5+2       ; [*20] branch target 2 byte(s) inside Sub_28C5 — see [*20]
	TSTA                  
	LEAX Dat_049B,PCR          ; X → Dat_049B
	LDA <$4C              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA <$4C              
	OS9 I$Close            ; path=A
	LBSR Sub_283E          ; call Sub_283E
	LDX #$13C3            
	LDA <$9D              
	LDB <$9E              
	STD 7,X               
	LDA #$FF              
	STA 4,X               
	LDA $0CC7             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 9,X               
	LDA $0CC8             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 10,X              
	LDA #$01              
	LDY #$000B            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$0002            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LEAX Dat_0B17,PCR          ; X → Dat_0B17
	LDA <$4B              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *-82

; --------------------------------------------------------------
Sub_2919:      LDA #$00               ; A = NUL
	LDY #$0001            
	LDX #$061B            
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDX <$71              
	LDA $061B             
	CMPA #$8C             
	LBHI Sub_173F         
	CMPA #$7F             
	LBHI Sub_2A1B         
	CMPA #$18             
	BNE *+6
	LDA #$7F              
	BRA *+58

; --------------------------------------------------------------
Sub_293E:      CMPA #$1A              ; compare A with SUB
	LBEQ Sub_173F         
	CMPA #$1C             
	LBEQ Sub_173F         
	CMPA #$0A              ; compare A with LF
	LBEQ Sub_2A1B         
	CMPA #$0C              ; compare A with FF
	LBEQ Sub_2A1B         
	CMPA #$09             
	LBEQ Sub_2A1B         
	CMPA #$08              ; compare A with BS
	BNE *+14
	LDB <$73              
	BEQ *+35
	LEAX -1,X             
	STX <$71              
	FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
	COM $2014             
Sub_296C:      LDB <$73              
	CMPB #$FD             
	BCS *+6  ; C=1 (BLO)
	CMPA #$0D              ; compare A with CR
	BNE *+17
Sub_2976:      STA ,X+               
	STX <$71              
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	COM $810D             
	BEQ *+26
	BSR *+70  ; call Sub_29C6
	LBRA Sub_2A1B         

; --------------------------------------------------------------
Sub_2985:      LDA #$07              
	LDX #$13C3            
	STA ,X                
	LDA #$01              
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_2A1B         

; --------------------------------------------------------------
Sub_2998:      LDA #$0A               ; A = LF
	STA ,X+               
	LDB <$73              
	TST $0CBE             
	BEQ *+3
	INCB                  
Sub_29A4:      CLRA                   ; A = 0
	TFR D,Y               
	LDA <$38              
	LDX #$051C            
	OS9 I$Write            ; path=A  count=Y  buf→X
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	COM $8E05             
	ANDCC #$9F             ; clr CC: H,F
	FCB    $71                ; undefined opcode $71 -- not a valid 6809 instruction
	LDA #$0D               ; A = CR
	STA $061B             
	BSR *+11  ; call Sub_29C6
	LDA #$0A               ; A = LF
	STA $061B             
	BSR *+4  ; call Sub_29C6
	BRA *+87

; --------------------------------------------------------------
Sub_29C6:      LDA $061B             
	CMPA #$0D              ; compare A with CR
	BNE *+22
	LDD #$200D            
	STD $13C3             
	LDX #$13C3            
	LDA <$4C              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *+45

; --------------------------------------------------------------
Sub_29E1:      CMPA #$08              ; compare A with BS
	BNE *+20
	LDD #$2008            
	STD $13C3             
	LDX #$13C3            
	LDA <$4C              
	LDY #$0002            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_29F7:      LDX #$061B            
	LDY #$0001            
	LDA <$4C              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA $061B             
	CMPA #$0D              ; compare A with CR
	BEQ *+4
	BSR *+3  ; call Sub_2A0D
Sub_2A0C:      RTS                    ; return from subroutine
Sub_2A0D:      LDA <$4C              
	LEAX Dat_04B9,PCR          ; X → Dat_04B9
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_2A1B:      LBRA Sub_0E2A         
Sub_2A1E:      PSHS A,B,X,Y          
	LDX #$00EF            
	PSHS X                
	TST ,X+               
	BNE *-2
	LEAX -1,X             
	PSHS X                
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	STA A,Y               
Sub_2A2F:      LDA ,-X               
	CMPX 2,S              
	BCS *+48  ; C=1 (BLO)
	CMPA #$41              ; compare A with 'A'
	BCS *+18  ; C=1 (BLO)
	CMPA #$5A              ; compare A with 'Z'
	BLS *-12
	CMPA #$61              ; compare A with 'a'
	BCS *+26  ; C=1 (BLO)
	CMPA #$7A              ; compare A with 'z'
	BHI *+28
Sub_2A44:      ORCC #$97              ; set CC: C,V,Z,I,E
	STA 0,Y               
	LDB ,X++              
Sub_2A49:      CMPA #$39              ; compare A with '9'
	BHI *+14
	CMPA #$30              ; compare A with '0'
	BCC *-32  ; C=0 (BHS)
	CMPA #$2E              ; compare A with '.'
	BEQ *-36
	CMPA #$2F              ; compare A with '/'
	BEQ *+12
Sub_2A59:      LDA #$5F               ; A = '_'
	STA ,X                
	BRA *-46

; --------------------------------------------------------------
Sub_2A5F:      CMPA #$5C              ; compare A with '\'
	BNE *-8
Sub_2A63:      LEAX 1,X              
	LDA ,X                
	BEQ *+20
	CMPA #$0D              ; compare A with CR
	BEQ *+16
	CMPA #$41              ; compare A with 'A'
	BCS *+6  ; C=1 (BLO)
	CMPA #$5F              ; compare A with '_'
	BNE *+8
Sub_2A75:      LEAX -1,X             
	LDA #$78               ; A = 'x'
	STA ,X                
Sub_2A7B:      STX 2,S               
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	STA 6,Y               
	FCB    $14                ; undefined opcode $14 -- not a valid 6809 instruction
Sub_2A81:      LDA ,X+               
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
Sub_2A95:      LDY #$00AC            
	LDX 2,S               
	LDD ,S++              
	SUBD ,S++             
	TSTB                  
	BEQ *+14
	CMPB #$1D             
	BLS *+4
	LDB #$1D              
Sub_2AA8:      JSR [$0CAF]            ; call via indexed pointer
	LEAX 1,X              
Sub_2AAE:      LDA #$0D               ; A = CR
	STA ,Y                
	BSR *+105  ; call Sub_2B1B
	LEAX Dat_0591,PCR          ; X → Dat_0591
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$00AC            
	LDA ,X                
	BEQ *+46
	CMPA #$0D              ; compare A with CR
	BEQ *+42
	LDA #$01              
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDD <$68              
	BNE *+32
	LDD <$66              
	BNE *+28
Sub_2ADE:      LDX #$00AC            
	LDA #$02               ; A = CurXY
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	OS9 I$Create           ; mode=B  name→X  → path→A
	BCS *+6  ; C=1 (BLO)
	STA <$4F              
Sub_2AEC:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2AEE:      LDA #$FF              
	STA <$4F              
	LDA #$0A               ; A = LF
	STA <$5D              
	BRA *-10

; --------------------------------------------------------------
Sub_2AF8:      LEAX Dat_059D,PCR          ; X → Dat_059D
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$13C4            
	LDY #$0007            
Sub_2B06:      LDA ,X                
	CMPA #$30              ; compare A with '0'
	BNE *+10
	LEAX 1,X              
	LEAY -1,Y             
	BEQ *-50
	BRA *-12

; --------------------------------------------------------------
Sub_2B14:      LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	BRA *-59

; --------------------------------------------------------------
Sub_2B1B:      PSHS A,B,X,Y          
	LDD #$0000            
	STD <$66              
	STD <$68              
	LDB #$08               ; B = BS
Sub_2B26:      LDA ,X+               
	CMPA #$20              ; compare A with ' '
	BEQ *+10
	TSTA                  
	BEQ *+7
	DECB                  
	BNE *-10
	BRA *+46

; --------------------------------------------------------------
Sub_2B34:      LDY #$13CA            
	LEAX -1,X             
	LDB #$08               ; B = BS
Sub_2B3C:      LDA ,-X               
	BEQ *+9
	STA ,-Y               
	DECB                  
	CMPB #$01             
	BNE *-9
Sub_2B47:      LDA #$30               ; A = '0'
Sub_2B49:      STA ,-Y               
	DECB                  
	CMPB #$01             
	BNE *-5
	LDY #$13C3            
	LEAX Dat_0B2B,PCR          ; X → Dat_0B2B
	CLRB                   ; B = 0
Sub_2B59:      BSR *+9  ; call Sub_2B62
	INCB                  
	CMPB #$08              ; compare B with BS
	BNE *-5
Sub_2B60:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2B62:      PSHS B,X              
	LDA #$04              
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	LDB ,S                
	LDA B,Y               
	SUBA #$30             
	TFR A,B               
	BEQ *+33
Sub_2B73:      PSHS B                
	LDB 3,X               
	ADDB <$69             
	STB <$69              
	LDA 2,X               
	ADCA <$68             
	STA <$68              
	LDB 1,X               
	ADCB <$67             
	STB <$67              
	LDA ,X                
	ADCA <$66             
	STA <$66              
	PULS B                
	DECB                  
	BNE *-29
Sub_2B92:      PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)
Sub_2B94:      PSHS A,B,X,Y          
	LBSR Sub_15A4          ; call Sub_15A4
	BCS *+29  ; C=1 (BLO)
	CLRA                   ; A = 0
	TFR D,Y               
	LDX #$061B            
	LDA #$00               ; A = NUL
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *+16  ; C=1 (BLO)
	TFR Y,D               
	LDX #$061B            
Sub_2BAD:      LDA ,X+               
	CMPA #$05             
	BEQ *+8
	DECB                  
	BNE *-7
Sub_2BB6:      CLRB                   ; B = 0
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2BB9:      COMB                  
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2BBC:      PSHS B,X,Y            
	LBSR Sub_3BCC          ; call Sub_3BCC
Sub_2BC1:      BSR *-45  ; call Sub_2B94
	BCS *+43  ; C=1 (BLO)
	LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$3B              ; compare A with ';'
	BCS *-18  ; C=1 (BLO)
	BRA *+25

; --------------------------------------------------------------
Sub_2BD7:      LDY #$0001            
	LDA <$38              
	LDX #$04FC            
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *+14  ; C=1 (BLO)
	LDA $04FC             
	CLR $04FC             
	CLRB                   ; B = 0
	PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2BEE:      COMB                  
	PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
         FCB    $4F,$20,$F7  ; unreachable padding
Sub_2BF4:      PSHS A,B,X,Y          
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	CLRB                   ; B = 0
	LDX #$071A            
Sub_2C01:      PSHS B,X              
	BSR *+29  ; call Sub_2C20
	PULS B,X              
	LDA $061B             
	CMPA #$0D              ; compare A with CR
	BEQ *+11
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAX 6,Y              
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
	INCB                  
	CMPB #$20              ; compare B with ' '
	BNE *-20
Sub_2C17:      LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2C20:      LDA #$20               ; A = ' '
	MUL                    ; D = A×B unsigned
	LEAX D,X              
	PSHS X                
	LEAX Dat_0585,PCR          ; X → Dat_0585
	LBSR Sub_1D95          ; call Sub_1D95
	LDB #$1E              
	LBSR Sub_1DF0          ; call Sub_1DF0
	PULS X                
	LDY #$061B            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	JSR [$0CB1]            ; call via indexed pointer
	RTS                    ; return from subroutine
         FCB    $34,$36,$D6,$75,$86,$20,$3D,$8E,$07,$1A,$30,$8B,$10,$8E,$00,$AC,$C6,$20,$AD,$9F,$0C,$AF,$0C,$75,$35,$B6  ; unreachable padding
Sub_2C5A:      PSHS B,X,Y            
	LDA #$01              
	STA <$36              
	BRA *+6

; --------------------------------------------------------------
Sub_2C62:      PSHS B,X,Y            
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	PSHU CC,A,B,X         
Sub_2C66:      LBSR Sub_15A4          ; call Sub_15A4
	BCC *+10  ; C=0 (BHS)
	LDX #$0003            
	LBSR Sub_1178          ; call Sub_1178
	BRA *-11

; --------------------------------------------------------------
Sub_2C73:      TSTB                  
	BEQ *-14
	LDX #$002A            
	LDY #$0001            
	LDA #$00               ; A = NUL
	OS9 I$Read             ; path=A  count=Y  buf→X
	LDA ,X                
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	PSHU A,B,Y            
	FCB    $08                ; undefined opcode $08 -- not a valid 6809 instruction
	ANDA #$7F             
Sub_2C8A:      CMPA #$60              ; compare A with '`'
	BCS *+4  ; C=1 (BLO)
	SUBA #$20             
Sub_2C90:      PULS B,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_2C92:      EQU    Sub_2C90+2       ; [*21] branch target 2 byte(s) inside Sub_2C90 — see [*21]
	BVS *+40
	FCB    $3E                ; undefined opcode $3E -- not a valid 6809 instruction
	LDX #$0C3B            
	LDD 27,X              
	ADDD #$0004           
	STD <$22              
	LDA #$01              
	LDX #$071A            
	OS9 F$GPrDsc           ; pid=A  buf→X
	LEAX 64,X             
	STX $0C91             
	TFR X,D               
	LDX <$22              
	LDY #$0002            
	PSHS U                
	LDU #$13C3            
Sub_2CBB:      ADDD #$103F           
	FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
	LDX $13C3             
	LEAX 36,X             
	LDD $0C91             
	LDY #$0002            
	LDU #$0020            
	OS9 F$CpyMem           ; src→X  dst→Y  count=D
	PULS U                
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_2CD5:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDD #$0253            
	STD ,X                
	LDA #$20               ; A = ' '
	STA 2,X               
	LDY #$0003            
	LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$003A            
	CLRB                   ; B = 0
Sub_2CF0:      LDA ,X+               
	INCB                  
	CMPA #$21              ; compare A with '!'
	BCS *+6  ; C=1 (BLO)
	CMPB #$05             
	BCS *-9  ; C=1 (BLO)
Sub_2CFB:      LDX #$003A            
	CLRA                   ; A = 0
	TFR D,Y               
	LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2D08:      LEAY Dat_04A7,PCR          ; Y → Dat_04A7
	LDX #$13C3            
	PSHS X                
	LDB #$07              
	JSR [$0CB1]            ; call via indexed pointer
	PULS X                
	LDA $0CCA             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 5,X               
	LDA $0CC9             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 2,X               
	LDA <$4B              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	TSTA                  
	BEQ *+15
	LDA <$4B              
	LEAX Dat_0B1E,PCR          ; X → Dat_0B1E
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2D43:      LEAY Dat_00F2,PCR          ; Y → Dat_00F2
	LDX #$13C3            
	LDB #$18              
	JSR [$0CB1]            ; call via indexed pointer
	LDX #$13C3            
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	BVC *+41
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
	LDA #$61               ; A = 'a'
	STA 19,X              
	LDA <$4B              
	LBSR Sub_1D97          ; call Sub_1D97
	LBSR Sub_2CD5          ; call Sub_2CD5
	LBSR Sub_25A2          ; call Sub_25A2
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $38                ; undefined opcode $38 -- not a valid 6809 instruction
	BEQ *+5
	LBSR Sub_1396          ; call Sub_1396
Sub_2D6E:      LDA <$7B              
	BEQ *+18
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	JMP $270D             
	LDX #$0080            
	LDY #$000B            
Sub_2D7D:      LDA <$4B              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2D82:      RTS                    ; return from subroutine
         FCB    $17,$E3,$BC,$39  ; unreachable padding
Sub_2D87:      EQU    $2D87            ; [*22] undefined opcode at $2D87 — see [*22]
	TSTA                  
	BEQ *+44
	LEAY Dat_04A7,PCR          ; Y → Dat_04A7
	LDX #$13C3            
	PSHS X                
	LDB #$07              
	JSR [$0CB1]            ; call via indexed pointer
	PULS X                
	LDA $0CD0             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 5,X               
	LDA $0CCF             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 2,X               
	LDA <$4C              
	LDY #$0007            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2DB5:      RTS                    ; return from subroutine
Sub_2DB6:      PSHS A,B,X,Y          
	LDA <$4F              
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
	PSHS U                
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	TFR U,Y               
	PULS U                
	BCS *+9  ; C=1 (BLO)
	STX <$66              
	STY <$68              
	BRA *+11

; --------------------------------------------------------------
Sub_2DCE:      LDD #$0000            
	STD <$66              
	STD <$68              
	BRA *+67

; --------------------------------------------------------------
Sub_2DD7:      LDX 2,S               
	LEAY Dat_0B2B,PCR          ; Y → Dat_0B2B
	PSHS X                
	LDA #$30               ; A = '0'
	LDB #$07              
Sub_2DE3:      STA ,X+               
	DECB                  
	BNE *-3
	PULS X                
	CLRB                   ; B = 0
Sub_2DEB:      PSHS A,B,X,Y          
	BSR *+45  ; call Sub_2E1A
	PULS A,B,X,Y          
	INCB                  
	CMPB #$08              ; compare B with BS
	BNE *-9
	PSHS X                
	LEAX Dat_059D,PCR          ; X → Dat_059D
	LBSR Sub_1D95          ; call Sub_1D95
	PULS X                
	LDY #$0007            
Sub_2E05:      LDA ,X                
	CMPA #$30              ; compare A with '0'
	BNE *+10
	LEAX 1,X              
	LEAY -1,Y             
	BEQ *+9
	BRA *-12

; --------------------------------------------------------------
Sub_2E13:      LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_2E18:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2E1A:      LEAX B,X              
	LDA #$04              
	MUL                    ; D = A×B unsigned
	LEAY D,Y              
Sub_2E21:      LDD ,Y                
	CMPD <$66             
	BHI *+44
	BCS *+9  ; C=1 (BLO)
	LDD 2,Y               
	CMPD <$68             
	BHI *+35
Sub_2E31:      LDD <$66              
	BNE *+6
	LDD <$68              
	BEQ *+27
Sub_2E39:      INC ,X                
	LDD <$68              
	SUBD 2,Y              
	STD <$68              
	BCC *+9  ; C=0 (BHS)
	LDD <$66              
	SUBD #$0001           
	STD <$66              
Sub_2E4A:      LDD <$66              
	SUBD ,Y               
	STD <$66              
	BRA *-47

; --------------------------------------------------------------
Sub_2E52:      RTS                    ; return from subroutine
         FCB    $A6,$80,$A7,$A0,$5A,$26,$F9,$39,$A6,$A0,$A7,$80,$5A,$26,$F9,$39,$4F,$1E,$06,$11,$38,$12,$39,$4F,$1E,$06,$11,$38,$21,$39  ; unreachable padding
Sub_2E71:      PSHS A,X              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	BVS *+41
	FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
	LDA <$38              
	LDB #$28               ; B = SS.EnRTS  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	TFR B,A               
	BRA *+6
         FCB    $9E,$20,$A6,$01  ; unreachable padding
Sub_2E86:      ANDA #$20             
	BEQ *+5
	CLRB                   ; B = 0
Sub_2E8B:      PULS A,X,PC            ; return from subroutine  (PULS PC = RTS)
Sub_2E8D:      COMB                  
	BRA *-3

; --------------------------------------------------------------
Sub_2E90:      PSHS A,B,X            
	LDX #$0003            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	LDA <$38              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
Sub_2E9D:      SWI $8D               
	BCS *+27  ; C=1 (BLO)
	LDX #$0015            
	LBSR Sub_1178          ; call Sub_1178
	LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	CLRA                   ; A = 0
	TFR D,Y               
	LDX #$13C3            
	LDA <$38              
	OS9 I$Read             ; path=A  count=Y  buf→X
	CLRB                   ; B = 0
Sub_2EBA:      PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_2EBC:      LDB #$10              
Sub_2EBE:      LDA ,X+               
	DECB                  
	BNE *+6
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_2EC5:      BRA *+63
Sub_2EC7:      CMPA #$30              ; compare A with '0'
	BCS *-11  ; C=1 (BLO)
	CMPA #$39              ; compare A with '9'
	BHI *-15
	TFR X,Y               
	LEAY -1,Y             
Sub_2ED3:      LDA ,X+               
	CMPA #$30              ; compare A with '0'
	BCS *+8  ; C=1 (BLO)
	CMPA #$39              ; compare A with '9'
	BHI *+4
	BRA *-10

; --------------------------------------------------------------
Sub_2EDF:      LEAX -1,X             
	LDD #$2020            
	STD ,X                
	LDA #$A0              
	STA 4,Y               
	LEAX Dat_0679,PCR          ; X → Dat_0679
	CLRB                   ; B = 0
Sub_2EEF:      PSHS B,X,Y            
	LDB #$06               ; B = SS.EOF  (GetStt/SetStt subcode)
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	PULS B,X,Y            
	BCC *+12  ; C=0 (BHS)
	LEAX 6,X              
	INCB                  
	CMPB $0CB9            
	BLS *-17
	BRA *+19

; --------------------------------------------------------------
Sub_2F04:      LDA $0CBA             
	ANDA #$F0             
	STA $0CBA             
	ORB $0CBA             
	STB $0CBA             
	LBSR Sub_1396          ; call Sub_1396
Sub_2F15:      RTS                    ; return from subroutine
Sub_2F16:      PSHS A,B,X,Y          
	LBSR Sub_2E90          ; call Sub_2E90
	BCS *+65  ; C=1 (BLO)
	STY $0C95             
	LDX #$13C3            
	LDB $0C96             
	SUBB #$07             
Sub_2F29:      PSHS B,X              
	LEAY Dat_02E7,PCR          ; Y → Dat_02E7
	LDB #$07              
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	PULS B,X              
	BCC *+9  ; C=0 (BHS)
	LEAX 1,X              
	DECB                  
	BNE *-18
	BRA *+31

; --------------------------------------------------------------
Sub_2F3F:      LDB $0CBA             
	ANDB #$0F             
	CMPB #$04             
	BHI *+5
	LBSR Sub_2EBC          ; call Sub_2EBC
Sub_2F4B:      LDB $0C96             
	LDX #$13C3            
	LDY #$00EC            
	JSR [$0CAF]            ; call via indexed pointer
	CLRB                   ; B = 0
Sub_2F5A:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2F5C:      COMB                  
	BRA *-3

; --------------------------------------------------------------
Sub_2F5F:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDB #$0E              
Sub_2F66:      PSHS B,X              
	LEAY Dat_02EE,PCR          ; Y → Dat_02EE
	LDB #$04              
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	PULS B,X              
	BCC *+9  ; C=0 (BHS)
	LEAX 1,X              
	DECB                  
	BNE *-18
	BRA *+2

; --------------------------------------------------------------
Sub_2F7C:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_2F7E:      PSHS A,B,X,Y,U        
	LEAX Dat_0000,PCR         
	LDY 2,X               
	STX <$24              
	LEAY -3,Y             
	STY <$26              
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
	LEAX Dat_000D,PCR          ; X → Dat_000D
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+15  ; C=1 (BLO)
	LDX <$24              
	LDY <$26              
	LEAY 3,Y              
	OS9 I$Write            ; path=A  count=Y  buf→X
	OS9 I$Close            ; path=A
Sub_2FBE:      RTS                    ; return from subroutine
Sub_2FBF:      PSHS A,B,X,Y          
	LEAX Dat_0B5B,PCR          ; X → Dat_0B5B
	LDY #$0CBA            
	LDB #$4D               ; B = 'M'
	JSR [$0CB1]            ; call via indexed pointer
	LDD #$1603            
	STD $0C9C             
	LDD #$1D04            
	STD $0C9A             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_09B4,PCR          ; X → Dat_09B4
	LBSR Sub_1D95          ; call Sub_1D95
	BSR *-110  ; call Sub_2F7E
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_1F53          ; call Sub_1F53
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_2FFA:      PSHS A,B,X,Y          
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	BEQ *+21
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	JMP $308D             
	ADDD <$8C             
	LDY #$0080            
	LDB #$0B               ; B = SS.FD  (GetStt/SetStt subcode)
	JSR [$0CAF]            ; call via indexed pointer
	LBSR $1142            
Sub_3013:      LBSR Sub_462A          ; call Sub_462A
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	TSTA                  
	BEQ *+5
	LBSR Sub_2830          ; call Sub_2830
Sub_301D:      LDD #$0000            
	STD <$0A              
	LDX #$16D3            
	STX <$A0              
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	CLR -9,X              
	CMPB $01CC            
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
	FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
	STD $0C9A             
	LDD #$4411            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LDA #$81              
	LEAX Dat_0B72,PCR          ; X → Dat_0B72
	OS9 I$Open             ; mode=B  name→X  → path→A
	LBCS Sub_30C2         
	STA <$4A              
	PSHS U                
	LDX #$0000            
	LDU #$0040            
	OS9 I$Seek             ; path=A  mode=B  offset→X:D
	PULS U                
	BCS *+107  ; C=1 (BLO)
Sub_3059:      LDA <$4A              
	LDY #$0020            
	LDX #$13C3            
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCC *+8  ; C=0 (BHS)
	CMPB #$D3             
	BNE *+89
	BRA *+17

; --------------------------------------------------------------
Sub_306D:      LBSR Sub_3216          ; call Sub_3216
	BCS *+4  ; C=1 (BLO)
	BSR *+91  ; call Sub_30CD
Sub_3074:      LDA <$6F              
	CMPA #$1D             
	BHI *+4
	BRA *-33

; --------------------------------------------------------------
Sub_307C:      LDA <$6F              
	STA $0CA2             
	LDA <$4A              
	OS9 I$Close            ; path=A
	LBSR Sub_3153          ; call Sub_3153
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	STX <$27              
	LBRA $487C            

; --------------------------------------------------------------
Sub_308D:      LBSR Sub_1E4C          ; call Sub_1E4C
	LDD #$0000            
	STD $133B             
	LBSR Sub_212D          ; call Sub_212D
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_3248          ; call Sub_3248
	LBSR Sub_1F53          ; call Sub_1F53
	LBSR Sub_1E63          ; call Sub_1E63
	LBSR Sub_1ED7          ; call Sub_1ED7
	LBSR Sub_212D          ; call Sub_212D
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y          
	LDY $0C95             
	LDX #$00EC            
	LBRA $11E4            

; --------------------------------------------------------------
Sub_30C2:      OS9 F$PErr             ; path=A  error=B
	LDX #$0078            
	LBSR Sub_1178          ; call Sub_1178
	BRA *-40

; --------------------------------------------------------------
Sub_30CD:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDY <$A0              
	LDB #$1E              
Sub_30D7:      LDA ,X+               
	DECB                  
	TSTA                  
	BPL *+13
	SUBA #$80             
	STA ,Y+               
	LDD #$0A0D            
	STD ,Y                
	BRA *+7

; --------------------------------------------------------------
Sub_30E8:      STA ,Y+               
	TSTB                  
Insn_30EB:      BNE *-20
Sub_30ED:      EQU    Insn_30EB+2      ; [*23] branch target 2 byte(s) inside Insn_30EB — see [*23]
	CLR +14989,PC         
	FCB    $0B                ; undefined opcode $0B -- not a valid 6809 instruction
	LDY <$A0              
	LEAY 32,Y             
	STY <$A0              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_30FE:      PSHS A,B,X,Y          
	LDX <$A0              
	LDY #$13C3            
	LDB #$1E              
Sub_3108:      LDA ,X+               
	DECB                  
	CMPA #$5F              ; compare A with '_'
	BNE *+4
	LDA #$20               ; A = ' '
Sub_3111:      CMPA #$2E              ; compare A with '.'
	BNE *+5
	LDA #$0D               ; A = CR
	CLRB                   ; B = 0
Sub_3118:      STA ,Y+               
	TSTB                  
	BNE *-19
	LDA #$01              
	LDY #$001E            
	LDX #$13C3            
	OS9 I$WritLn           ; path=A  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
         FCB    $34,$36,$8E,$13,$C3,$D6,$6F,$C1,$0F,$22,$04,$86,$24,$20,$04,$86,$45,$C0,$0F,$A7,$01,$86,$02,$A7,$84,$CB,$20,$E7,$02,$10,$8E,$00,$03,$86,$01,$10,$3F,$8A,$35,$B6  ; unreachable padding
Sub_3153:      PSHS A,B,X,Y          
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$01              
	STA <$9F              
Sub_3160:      LDX #$13C3            
	CMPA $0CA2            
	BLS *+7
	LDA $0CA2             
	STA <$9F              
Sub_316D:      CMPA #$0F             
	BHI *+6
	ADDA #$20             
	BRA *+4

; --------------------------------------------------------------
Sub_3175:      ADDA #$11             
Sub_3177:      STA 2,X               
	LDA <$9F              
	CMPA #$0F             
	BHI *+6
	LDA #$21               ; A = '!'
	BRA *+4

; --------------------------------------------------------------
Sub_3183:      LDA #$42               ; A = 'B'
Sub_3185:      STA 1,X               
	LDA #$02               ; A = CurXY
	STA ,X                
	LBSR Sub_3205          ; call Sub_3205
	LDA #$01              
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_06F2,PCR          ; X → Dat_06F2
	LDY #$0003            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_31A2:      LBSR Sub_2C62          ; call Sub_2C62
	CMPA #$08              ; compare A with BS
	BNE *+16
Sub_31A9:      LDA <$9F              
	CMPA #$0F             
	BHI *+6
	ADDA #$0F             
	BRA *+4

; --------------------------------------------------------------
Sub_31B3:      SUBA #$0F             
Sub_31B5:      BRA *+75
Sub_31B7:      CMPA #$09             
	BNE *+4
	BRA *-18

; --------------------------------------------------------------
Sub_31BD:      CMPA #$0C              ; compare A with FF
	BNE *+21
	LDA <$9F              
	CMPA #$01             
	BEQ *+8
	SUBA #$01             
	STA <$9F              
	BRA *+53

; --------------------------------------------------------------
Sub_31CD:      LDA $0CA2             
	STA <$9F              
	BRA *+46

; --------------------------------------------------------------
Sub_31D4:      CMPA #$0A              ; compare A with LF
	BNE *+21
	LDA <$9F              
	CMPA $0CA2            
	BEQ *+8
	ADDA #$01             
	STA <$9F              
	BRA *+29

; --------------------------------------------------------------
Sub_31E5:      LDA #$01              
	STA <$9F              
	BRA *+23

; --------------------------------------------------------------
Sub_31EB:      CMPA #$0D              ; compare A with CR
	BNE *+11
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_31F8:      CMPA #$05             
	BNE *-88
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	STX <$20              
	STU ?$97              
Sub_3200:      STA <$9F              
	LBRA Sub_3160         

; --------------------------------------------------------------
Sub_3205:      PSHS A,X,Y            
	LDA #$01              
	LEAX Dat_06E1,PCR          ; X → Dat_06E1
	LDY #$0006            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3216:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDA ,X                
	BEQ *+40
	LDB #$1B               ; B = ESC
Sub_3221:      LDA ,X+               
	DECB                  
	CMPA #$2E              ; compare A with '.'
	BEQ *+7
Sub_3228:      TSTB                  
	BNE *-8
	BRA *+26

; --------------------------------------------------------------
Sub_322D:      LDA ,X+               
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
Sub_3243:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_3245:      COMB                  
	BRA *-3

; --------------------------------------------------------------
Sub_3248:      PSHS A,B,X,Y          
	LDA <$9F              
	DECA                  
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	LDX #$16D3            
	LEAX D,X              
	STX <$A0              
	PSHS X                
	LDX #$13C3            
	LEAY Dat_0B72,PCR          ; Y → Dat_0B72
Sub_3260:      LDA ,Y+               
	BMI *+6
	STA ,X+               
	BRA *-6

; --------------------------------------------------------------
Sub_3268:      SUBA #$80             
	LDB #$2F               ; B = '/'
	STD ,X++              
	TFR X,Y               
	PULS X                
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
Sub_3274:      LDA ,X+               
	BMI *+9
	STA ,Y+               
	DECB                  
	BNE *-7
	BRA *+4

; --------------------------------------------------------------
Sub_327F:      STA ,Y+               
Sub_3281:      LDX #$13C3            
	LDA #$01              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+54  ; C=1 (BLO)
	STA <$4A              
	LBSR Sub_2705          ; call Sub_2705
	LDA #$01              
	STA $0D38             
	LDA #$1E              
	STA $0D39             
Sub_329A:      LDA <$4A              
	LDX #$13C3            
	LDY #$0050            
	OS9 I$ReadLn           ; path=A  max=Y  buf→X
	BCC *+8  ; C=0 (BHS)
	CMPB #$D3             
	BNE *+21
	BRA *+6

; --------------------------------------------------------------
Sub_32AE:      BSR *+22  ; call Sub_32C4
	BRA *-22

; --------------------------------------------------------------
Sub_32B2:      LDA <$4A              
	OS9 I$Close            ; path=A
	LBSR Sub_1396          ; call Sub_1396
	LBRA Sub_34B6         

; --------------------------------------------------------------
Sub_32BD:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_32BF:      OS9 F$PErr             ; path=A  error=B
	BRA *-5

; --------------------------------------------------------------
Sub_32C4:      PSHS A,B,X,Y          
	CLRA                   ; A = 0
	LEAY Dat_0730,PCR          ; Y → Dat_0730
Sub_32CB:      LDX #$13C3            
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	INCA                  
	OS9 F$CmpNam           ; name→X  len=Y  name2→D
	LEAY 3,Y              
	BCC *+6  ; C=0 (BHS)
	CMPA #$20              ; compare A with ' '
	BCS *-15  ; C=1 (BLO)
Sub_32DC:      CMPA #$1F             
	BHI *+128
	LEAX 3,X              
	LDB ,X+               
	CMPB #$3D              ; compare B with '='
	BNE *+120
	CMPA #$01             
	BEQ *+118
	CMPA #$02              ; compare A with CurXY
	LBEQ Sub_3379         
	CMPA #$03             
	LBEQ Sub_338E         
	CMPA #$04             
	LBEQ Sub_339B         
	CMPA #$05             
	LBEQ Sub_33A8         
	CMPA #$06             
	LBEQ Sub_33B6         
	CMPA #$07             
	LBEQ Sub_33C6         
	CMPA #$08              ; compare A with BS
	LBEQ Sub_33CE         
	CMPA #$09             
	LBEQ Sub_33D7         
	CMPA #$0A              ; compare A with LF
	LBEQ Sub_33E0         
	CMPA #$0B             
	LBEQ Sub_33E9         
	CMPA #$0C              ; compare A with FF
	LBEQ Sub_33F2         
	CMPA #$0D              ; compare A with CR
	LBEQ Sub_3400         
	CMPA #$0E             
	LBEQ Sub_3414         
	CMPA #$16             
	LBLS Sub_3430         
	CMPA #$17             
	LBEQ Sub_3456         
	CMPA #$1B              ; compare A with ESC
	LBLS Sub_273B         
	CMPA #$1F             
	LBLS Sub_2716         
	CMPA #$20              ; compare A with ' '
	LBEQ Sub_346A         
	CMPA #$21              ; compare A with '!'
	LBEQ Sub_3478         
Sub_335E:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_3360:      LDY #$0D11            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
Sub_3366:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+9
	STA ,Y+               
	DECB                  
	BNE *-9
	BRA *+6

; --------------------------------------------------------------
Sub_3373:      STA ,Y+               
	CLR ,Y+               
Sub_3377:      BRA *-25
Sub_3379:      LBSR Sub_3486          ; call Sub_3486
	ANDB #$0F             
	LDA $0CBA             
	ANDA #$F0             
	STA $0CBA             
	ORB $0CBA             
	STB $0CBA             
	BRA *-46

; --------------------------------------------------------------
Sub_338E:      LBSR Sub_3486          ; call Sub_3486
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_3396:      STB $0CBC             
	BRA *-59

; --------------------------------------------------------------
Sub_339B:      LBSR Sub_3486          ; call Sub_3486
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_33A3:      STB $0CC6             
	BRA *-72

; --------------------------------------------------------------
Sub_33A8:      LBSR Sub_3486          ; call Sub_3486
	CMPB #$03             
	BCS *+4  ; C=1 (BLO)
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
Sub_33B1:      STB $0CBB             
	BRA *-86

; --------------------------------------------------------------
Sub_33B6:      LBSR Sub_3486          ; call Sub_3486
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_33BE:      STB $0CBD             
	STB $0CBE             
	BRA *-102

; --------------------------------------------------------------
Sub_33C6:      LBSR Sub_3486          ; call Sub_3486
	STB $0CC4             
	BRA *-110

; --------------------------------------------------------------
Sub_33CE:      LBSR Sub_3486          ; call Sub_3486
	STB $0CC5             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_33D7:      LBSR Sub_3486          ; call Sub_3486
	STB $0D38             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_33E0:      LBSR Sub_3486          ; call Sub_3486
	STB $0D39             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_33E9:      LBSR Sub_3486          ; call Sub_3486
	STB $0CC1             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_33F2:      LBSR Sub_3486          ; call Sub_3486
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_33FA:      STB $0CBF             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_3400:      LBSR Sub_3486          ; call Sub_3486
	LDA $0CBA             
	ANDA #$4F             
	STA $0CBA             
	ORB $0CBA             
	STB $0CBA             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_3414:      BSR *+114  ; call Sub_3486
	TSTB                  
	BEQ *+9
	CMPB #$80             
	BEQ *+5
Sub_341D:      LBRA Sub_335E         
Sub_3420:      LDA $0CBA             
	ANDA #$7F             
	STA $0CBA             
	ORB $0CBA             
	STB $0CBA             
	BRA *-17

; --------------------------------------------------------------
Sub_3430:      LDA -2,X              
	SUBA #$31             
	CMPA #$07             
	BHI *+29
	LDB #$80              
	MUL                    ; D = A×B unsigned
	LDY #$0D3B            
	LEAY D,Y              
	LDB #$80              
Sub_3443:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+9
	STA ,Y+               
	DECB                  
	BNE *-9
	BRA *+5

; --------------------------------------------------------------
Sub_3450:      CLRB                   ; B = 0
	STD ,Y                
Sub_3453:      LBRA Sub_335E         
Sub_3456:      LDY #$133B            
	LDB #$80              
Sub_345C:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *-16
	STA ,Y+               
	DECB                  
	BNE *-9
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_346A:      LBSR Sub_3486          ; call Sub_3486
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_3472:      STB $0CBE             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_3478:      LBSR Sub_3486          ; call Sub_3486
	TSTB                  
	BEQ *+4
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
Sub_3480:      STB $0CBD             
	LBRA Sub_335E         

; --------------------------------------------------------------
Sub_3486:      LDA 1,X               
	CMPA #$21              ; compare A with '!'
	BCS *+30  ; C=1 (BLO)
	LDA ,X                
	SUBA #$30             
	CMPA #$0A              ; compare A with LF
	BCS *+4  ; C=1 (BLO)
	SUBA #$07             
Sub_3496:      LDB #$10              
	MUL                    ; D = A×B unsigned
	LDA 1,X               
	SUBA #$30             
	CMPA #$0A              ; compare A with LF
	BCS *+4  ; C=1 (BLO)
	SUBA #$07             
Sub_34A3:      STA 1,X               
	ADDB 1,X              
Sub_34A7:      RTS                    ; return from subroutine
Sub_34A8:      LDA ,X                
	SUBA #$30             
	CMPA #$0A              ; compare A with LF
	BCS *+4  ; C=1 (BLO)
	SUBA #$07             
Sub_34B2:      TFR A,B               
	BRA *-13

; --------------------------------------------------------------
Sub_34B6:      TST $0D38             
	BNE *+11
	CLR $133B             
	CLR $0C8F             
	LBRA Sub_35F4         

; --------------------------------------------------------------
Sub_34C4:      LBSR Sub_1F53          ; call Sub_1F53
	LDD #$1403            
	STD $0C9A             
	LDD #$2808            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_04D7,PCR          ; X → Dat_04D7
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_261E          ; call Sub_261E
	LEAX Dat_0501,PCR          ; X → Dat_0501
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_30FE          ; call Sub_30FE
Sub_34EA:      LEAX Dat_050B,PCR          ; X → Dat_050B
	LBSR Sub_1D95          ; call Sub_1D95
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	STB $13BE             
	LBSR Sub_360A          ; call Sub_360A
	LDX #$0D11            
	CLRB                   ; B = 0
Sub_34FD:      LDA ,X+               
	INCB                  
	CMPB #$20              ; compare B with ' '
	BHI *+5
	TSTA                  
	BNE *-8
Sub_3507:      DECB                  
	BNE *+11
	CLR $133B             
	CLR $0C8F             
	LBRA Sub_35F4         

; --------------------------------------------------------------
Sub_3513:      CLRA                   ; A = 0
	TFR D,Y               
	STY $0CAB             
Sub_351A:      LEAX Dat_02F2,PCR          ; X → Dat_02F2
	LDY #$0004            
	LDA <$38              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_2E90          ; call Sub_2E90
	LDX #$005A            
	LBSR Sub_1178          ; call Sub_1178
	LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_2E71          ; call Sub_2E71
	BCS *+6  ; C=1 (BLO)
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LEAY 0,Y              
	FCB    $04                ; undefined opcode $04 -- not a valid 6809 instruction
Sub_3542:      LDA #$01              
	STA <$31              
	LBSR Sub_2E90          ; call Sub_2E90
	LDY $0CAB             
	LDX #$0D11            
	LDA <$38              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBSR Sub_2E90          ; call Sub_2E90
	LDB #$FF              
	STB $0CAE             
Sub_355D:      LBSR Sub_1DDE          ; call Sub_1DDE
Insn_3560:     STA $0CAD             
Sub_3563:      EQU    Insn_3560+3      ; [*24] branch target 3 byte(s) inside Insn_3560 — see [*24]
	LEAY 7,Y              
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	LBSR Sub_2F16          ; call Sub_2F16
	BCC *+100  ; C=0 (BHS)
	LBSR Sub_2F5F          ; call Sub_2F5F
	BCS *+9  ; C=1 (BLO)
	BRA *+54
         FCB    $17,$F8,$FB,$25,$56  ; unreachable padding
Sub_3578:      LDA #$00               ; A = NUL
	LDB #$27               ; B = SS.Sign  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	CMPA #$80             
	BNE *+10
	CLR $133B             
	CLR $0C8F             
	BRA *+107

; --------------------------------------------------------------
Sub_358B:      LBSR Sub_1DDE          ; call Sub_1DDE
	CMPA $0CAD            
	BEQ *-46
	INC $0CAE             
	LEAX Dat_0510,PCR          ; X → Dat_0510
	LBSR Sub_1D95          ; call Sub_1D95
	LDB $0CAE             
	BSR *+106  ; call Sub_360A
	CMPB $0D39            
	BCS *-72  ; C=1 (BLO)
Sub_35A7:      INC $13BE             
	LEAX Dat_050B,PCR          ; X → Dat_050B
	LBSR Sub_1D95          ; call Sub_1D95
	LDB $13BE             
	BSR *+86  ; call Sub_360A
	LDB $0D38             
	CMPB #$FF             
	LBEQ Sub_351A         
	LDB $13BE             
	CMPB $0D38            
	LBCS Sub_351A         
	CLR $133B             
	BRA *+40

; --------------------------------------------------------------
Sub_35CE:      LDA #$01              
	LDB #$98              
	LDX #$3F06            
	LDY #$0D00            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDY #$0E00            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LDY #$0F00            
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	BEQ *+8
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	JMP $967C             
	STA <$7D              
Sub_35F4:      LBSR Sub_1E33          ; call Sub_1E33
	LDA <$4A              
	OS9 I$Close            ; path=A
	TST $133B             
	BEQ *+5
	LBSR Sub_1C6A          ; call Sub_1C6A
Sub_3604:      LBSR Sub_14A5          ; call Sub_14A5
	LBRA Sub_32BD         

; --------------------------------------------------------------
Sub_360A:      PSHS A,B,X            
	LDX #$13C3            
	CLRA                   ; A = 0
Sub_3610:      CMPB #$64              ; compare B with 'd'
	BCS *+7  ; C=1 (BLO)
	SUBB #$64             
	INCA                  
	BRA *-7

; --------------------------------------------------------------
Sub_3619:      ADDA #$30             
	STA ,X+               
	CLRA                   ; A = 0
Sub_361E:      CMPB #$0A              ; compare B with LF
	BCS *+7  ; C=1 (BLO)
	SUBB #$0A             
	INCA                  
	BRA *-7

; --------------------------------------------------------------
Sub_3627:      ADDA #$30             
	STA ,X+               
	ADDB #$30             
	STB ,X+               
	LDX #$13C3            
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_363D:      LEAX Dat_04B5,PCR          ; X → Dat_04B5
	INC $0CAA             
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$1C05            
	STD $0C9A             
	LDD #$1907            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_0793,PCR          ; X → Dat_0793
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$04              
	STA $13BD             
	LDB <$56              
	LBSR Sub_201F          ; call Sub_201F
	LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	LDB $0C91             
	BEQ *+20
	CMPB #$03             
	BHI *+21
	STB <$56              
	CMPB #$02              ; compare B with CurXY
	LBHI Sub_19DF         
	BCS *+107  ; C=1 (BLO)
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BRA *+103

; --------------------------------------------------------------
Sub_368A:      STB <$56              
	LBRA Sub_417F         

; --------------------------------------------------------------
Sub_368F:      LBRA Sub_0E2A         
Sub_3692:      LEAX Dat_04B5,PCR          ; X → Dat_04B5
	CLR $0CAA             
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$1C05            
	STD $0C9A             
	LDD #$1908            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_0804,PCR          ; X → Dat_0804
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$05              
	STA $13BD             
	LDB <$55              
	LBSR Sub_201F          ; call Sub_201F
	LBSR Sub_1F53          ; call Sub_1F53
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
	LDB $0C91             
	BEQ *+26
	CMPB #$04             
	BHI *-66
	STB <$55              
	CMPB #$02              ; compare B with CurXY
	BCS *+24  ; C=1 (BLO)
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
	CMPB #$03             
	BCS *+18  ; C=1 (BLO)
	LBHI Sub_1ABA         
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BRA *+10

; --------------------------------------------------------------
Sub_36E7:      STB <$55              
	LBRA Sub_417F         
         FCB    $16,$D7,$3B  ; unreachable padding
Sub_36EF:      PSHS A,B,X,Y          
	LDA $0CC5             
	LDB $0CC4             
	PSHS A,B              
	CLRA                   ; A = 0
	STA $0CC4             
	STA $0CC5             
	LBRA Sub_377C         

; --------------------------------------------------------------
Sub_3703:      LDA #$FF              
	STA <$4F              
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LSR $0F6A             
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	ASRB                  
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $75                ; undefined opcode $75 -- not a valid 6809 instruction
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	TST 15,X              
	TSTB                  
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	EORA ?$8E             
	SYNC                   ; wait for interrupt
	ADDD #$9638           
	LDB #$00               ; B = SS.Opt  (GetStt/SetStt subcode)
	PSHS A,B              
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	LDX #$13C3            
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
Insn_3740:     LBSR Sub_462A          ; call Sub_462A
Sub_3741:      EQU    Insn_3740+1      ; [*25] branch target 1 byte(s) inside Insn_3740 — see [*25]
Insn_3742:     STB Dat_3745          

Dat_3745
; ── 19 bytes  ($3745—$3757) ──
         FCB    $00               ; NUL
         FCS    "]"
         FCB    $0A               ; LF
         FCS    "L"
         FCB    $15               ; NAK erase-EOS
         FCB    $04               ; EOT
         FCS    "}"
         FCB    $0C               ; FF clear+home
         FCB    $9A
         FCS    "L"
         FCB    $25               ; '%'
         FCB    $09               ; HT
         FCS    "}"
         FCB    $0C               ; FF clear+home
         FCB    $9C
         FCB    $17               ; ETB delete-line
         FCS    "g"
         FCB    $9A
         FCB    $39               ; '9'
Sub_3758:      PSHS A,B,X,Y          
Sub_375A:      LBSR Sub_3BCC          ; call Sub_3BCC
Sub_375D:      LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+11  ; C=0 (BHS)
	LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$02              ; compare A with CurXY
	BCS *-14  ; C=1 (BLO)
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_376F:      CLRA                   ; A = 0
	TFR D,Y               
	LDA <$38              
	LDX #$13C3            
	OS9 I$Read             ; path=A  count=Y  buf→X
	BRA *-32

; --------------------------------------------------------------
Sub_377C:      LBSR Sub_3703          ; call Sub_3703
	LEAX Dat_0515,PCR          ; X → Dat_0515
	LBSR Sub_1D95          ; call Sub_1D95
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BEQ *+9
	LEAX Dat_0537,PCR          ; X → Dat_0537
	LBSR Sub_1D95          ; call Sub_1D95
Sub_3791:      LEAX Dat_0555,PCR          ; X → Dat_0555
	LBSR Sub_1D95          ; call Sub_1D95
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BEQ *+11
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	BRA *+86

; --------------------------------------------------------------
Sub_37A5:      LEAX Dat_0585,PCR          ; X → Dat_0585
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_4492          ; call Sub_4492
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	EORA 7,Y              
	NOP                   
	LDX #$00AC            
	LDY #$0020            
	LDA #$01              
	OS9 I$WritLn           ; path=A  buf→X
	LDD #$0704            
	LBSR Sub_24DC          ; call Sub_24DC
	LDB #$1E              
	LBSR Sub_1DF0          ; call Sub_1DF0
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAX -16,X            
	BNE *+3
	STX $308D             
	LDD #$B017            
	BITB ?$BE             
	LEAX Dat_0515,PCR          ; X → Dat_0515
	LBSR Sub_1D95          ; call Sub_1D95
	LDY #$061B            
	LDX #$00AC            
	LDA ,Y                
	CMPA #$0D              ; compare A with CR
	BNE *+10
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	EORA -16,X            
	BEQ *+3
	LDX <$20              
	FCB    $06                ; undefined opcode $06 -- not a valid 6809 instruction
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	JSR [$0CB1]            ; call via indexed pointer
Sub_37F9:      TST $0CAA             
	LBEQ Sub_3F02         
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BNE *+44
	LEAX Dat_0591,PCR          ; X → Dat_0591
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$01              
	LDX #$00AC            
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$02               ; A = CurXY
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	LDX #$00AC            
Sub_3825:      OS9 I$Create           ; mode=B  name→X  → path→A
	LBCS Sub_39AE         
	STA <$4F              
Sub_382E:      LEAX Dat_05B9,PCR          ; X → Dat_05B9
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_05DD,PCR          ; X → Dat_05DD
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_0555,PCR          ; X → Dat_0555
	LBSR Sub_1D95          ; call Sub_1D95
	LBSR Sub_3E81          ; call Sub_3E81
	LBSR Sub_3E99          ; call Sub_3E99
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BEQ *+7
	LDD #$0000            
	BRA *+8

; --------------------------------------------------------------
Sub_3852:      LBSR Sub_3ED8          ; call Sub_3ED8
	LDD #$0001            
Sub_3858:      STD <$5E              
	LEAX Dat_0726,PCR          ; X → Dat_0726
	LBSR Sub_1D95          ; call Sub_1D95
	LDD #$0D07            
	LBSR Sub_24DC          ; call Sub_24DC
	LEAX Dat_05ED,PCR          ; X → Dat_05ED
	LDA #$01              
	LDY #$0014            
	OS9 I$Write            ; path=A  count=Y  buf→X
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	LDB #$04              
	STB <$64              
	LBSR Sub_3E71          ; call Sub_3E71
	FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
	LSR -9,X              
	FCB    $03                ; undefined opcode $03 -- not a valid 6809 instruction
	DECA                  
Sub_3882:      LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+96  ; C=0 (BHS)
	LBSR Sub_2B94          ; call Sub_2B94
	LBCS Sub_39DB         
	LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$03             
	BCS *-21  ; C=1 (BLO)
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LSR 6,Y               
	STD <$0F              
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
Sub_389F:      LBSR Sub_3E7D          ; call Sub_3E7D
	LBSR Sub_3BCC          ; call Sub_3BCC
Sub_38A5:      LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCC *+61  ; C=0 (BHS)
	LBSR Sub_2B94          ; call Sub_2B94
	LBCS Sub_39DB         
	LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$0A              ; compare A with LF
	BCS *-21  ; C=1 (BLO)
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	TSTB                  
	LBSR Sub_3EC2          ; call Sub_3EC2
	LBSR Sub_1F6B          ; call Sub_1F6B
	LDA <$5D              
	CMPA #$0A              ; compare A with LF
	BCS *-41  ; C=1 (BLO)
	LBRA Sub_39DB         

; --------------------------------------------------------------
Sub_38CD:      LBSR Sub_3E79          ; call Sub_3E79
	LDD <$5E              
	CMPD #$0000           
	BNE *+6
	LBSR Sub_3E71          ; call Sub_3E71
	CLRA                   ; A = 0
Sub_38DC:      ADDD #$0001           
	STD <$5E              
	LBSR Sub_3ED8          ; call Sub_3ED8
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	TSTB                  
	LBSR Sub_3EB1          ; call Sub_3EB1
Sub_38E9:      LBSR Sub_2B94          ; call Sub_2B94
	LBCS Sub_39DB         
	CLR $00EF             
	LBSR Sub_3A39          ; call Sub_3A39
	PSHS CC               
	LDD <$5E              
	CMPD #$0000           
	BNE *+12
	TST $00EF             
	BNE *+13
	PULS CC               
	LBRA Sub_397B         

; --------------------------------------------------------------
Sub_390A:      PULS CC               
	BCS *+30  ; C=1 (BLO)
	BRA *+13

; --------------------------------------------------------------
Sub_3910:      PULS CC               
	BCC *-69  ; C=0 (BHS)
	LDA #$0D               ; A = CR
	STA <$AC              
Insn_3918:     LBRA Sub_39DB         
Sub_391B:      EQU    Insn_3918+3      ; [*26] branch target 3 byte(s) inside Insn_3918 — see [*26]
	DEC 6,Y               
	FCB    $1B                ; undefined opcode $1B -- not a valid 6809 instruction
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	TST 7,Y               
	ORA 15,X              
	TST -9,X              
	FCB    $05                ; undefined opcode $05 -- not a valid 6809 instruction
	FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
	BRA *-63

; --------------------------------------------------------------
Sub_392A:      LDA <$5D              
	CMPA #$09             
	LBHI Sub_39DB         
	LBSR Sub_3758          ; call Sub_3758
	LBSR Sub_3E7D          ; call Sub_3E7D
	BRA *-79
         FCB    $0D,$52,$27,$3D,$17,$05,$3C,$17,$00,$F5,$34,$01,$0D,$6A,$27,$AE,$35,$01,$0F,$6A,$34,$40,$0D,$57,$26,$16,$DC,$66,$26,$04,$DC,$68,$27,$0E,$96,$4F,$C6,$02,$9E,$66,$10,$9E,$68,$1F,$23,$10,$3F,$8E,$35,$40,$96,$4F,$10,$3F,$8F,$86,$0D,$97,$AC,$17,$05,$01,$16,$FE,$C8  ; unreachable padding
Sub_397B:      EQU    $397B            ; [*27] undefined opcode at $397B — see [*27]
	DEC -9,X              
	FCB    $04                ; undefined opcode $04 -- not a valid 6809 instruction
	ADCB $7F0C            
Sub_3980:      CLR $0CAA             
	LBSR Sub_1F7D          ; call Sub_1F7D
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BNE *+7
	LDA <$4F              
	OS9 I$Close            ; path=A
Sub_398F:      LBSR Sub_1396          ; call Sub_1396
	LBSR Sub_1F53          ; call Sub_1F53
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	LDA <$37              
	STA <$4F              
	BMI *+4
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	ASRB                  
Sub_39A1:      PULS A,B              
	STA $0CC5             
	STB $0CC4             
	PULS A,B,X,Y          
	LBRA Sub_0E2A         

; --------------------------------------------------------------
Sub_39AE:      LDA #$07              
	LBSR Sub_213B          ; call Sub_213B
	PSHS B                
	LDD #$0D02            
	LBSR Sub_24DC          ; call Sub_24DC
	LDA #$03              
	LBSR Sub_213B          ; call Sub_213B
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	PULS B                
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_1178          ; call Sub_1178
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	BRA *-74

; --------------------------------------------------------------
Sub_39DB:      LDA <$AC              
	BMI *+20
	CMPA #$0D              ; compare A with CR
	BEQ *+16
	LDA <$4F              
	OS9 I$Close            ; path=A
	LDX #$00AC            
	OS9 I$Delete           ; name→X
	LBSR Sub_3758          ; call Sub_3758
Sub_39F1:      LDA <$14              
	STA <$16              
	LDD <$17              
	STD <$19              
	LDX #$13C3            
	LDA #$18              
	LDB #$04              
Sub_3A00:      STA ,X+               
	DECB                  
	BNE *-3
	LDA #$03              
	LDB #$04              
Sub_3A09:      STA ,X+               
	DECB                  
	BNE *-3
	LDA <$38              
	LDY #$0008            
	LDX #$13C3            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LBRA Sub_3980         

; --------------------------------------------------------------
Sub_3A1D:      LDA #$04              
	STA <$5A              
	LBRA Sub_3B97         

; --------------------------------------------------------------
Sub_3A24:      LDA #$03              
	STA <$5A              
	LBRA Sub_3B97         

; --------------------------------------------------------------
Sub_3A2B:      LDA #$02               ; A = CurXY
	STA <$5A              
	LBRA Sub_3B97         

; --------------------------------------------------------------
Sub_3A32:      LDA #$01              
	STA <$5A              
	LBRA Sub_3B97         

; --------------------------------------------------------------
Sub_3A39:      PSHS X,Y              
	LDD #$0000            
	STD <$58              
	STD <$53              
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	TST 15,X              
	DECB                  
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	DEC -9,X              
	FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
	CMPA #$8E             
Sub_3A4B:      LDX #$00EC            
Sub_3A4E:      LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$0A              ; compare A with LF
	LBHI Sub_3A1D         
	LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *-16  ; C=1 (BLO)
	LDY #$0001            
	LDA <$38              
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *-27  ; C=1 (BLO)
	TFR Y,D               
	STD <$58              
	ABX                   
	LDA $00EC             
	CMPA #$02              ; compare A with CurXY
	BEQ *+32
	CMPA #$01             
	BEQ *+23
	CMPA #$04             
	LBEQ Sub_3BBE         
	CMPA #$18             
	LBEQ Sub_3BC5         
	CMPA #$03             
	LBEQ Sub_3BC5         
	LBRA Sub_3A4B         

; --------------------------------------------------------------
Sub_3A90:      LDD #$0080            
	BRA *+5

; --------------------------------------------------------------
Sub_3A95:      LDD #$0400            
Sub_3A98:      STD <$62              
	LDY #$00EF            
	LEAY D,Y              
	STY <$5B              
	ORB #$04              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	BEQ *+4
	ORB #$01              
Sub_3AAB:      STD <$60              
	LBSR Sub_3BCC          ; call Sub_3BCC
	BRA *+11

; --------------------------------------------------------------
Sub_3AB2:      LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$03             
	LBHI Sub_3A1D         
Sub_3ABB:      LDA <$38              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	BCS *-16  ; C=1 (BLO)
	CMPB #$02              ; compare B with CurXY
	BCS *-20  ; C=1 (BLO)
	LDY #$0002            
	LDA <$38              
	OS9 I$Read             ; path=A  count=Y  buf→X
	TFR Y,D               
	ABX                   
	ADDD <$58             
	STD <$58              
	LDD <$5E              
	CMPB $00ED            
	BNE *+11
	COMB                  
	CMPB $00EE            
	BEQ *+15
Sub_3AE5:      LBRA Sub_3A2B         
Sub_3AE8:      DECB                  
	CMPB $00ED            
	BNE *-7
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	TST 0,Y               
	STD -9,X              
Sub_3AF2:      LBSR Sub_3BCC          ; call Sub_3BCC
Sub_3AF5:      LBSR Sub_3BE5          ; call Sub_3BE5
	CMPA #$04             
	LBHI Sub_3A1D         
Sub_3AFE:      LDA <$38              
	JSR [$0CB3]            ; call via indexed pointer
	BCS *-15  ; C=1 (BLO)
	TFR Y,D               
	LBSR Sub_3BCC          ; call Sub_3BCC
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	BNE *+7
	LBSR Sub_3E41          ; call Sub_3E41
	BRA *+5

; --------------------------------------------------------------
Sub_3B14:      LBSR Sub_3E15          ; call Sub_3E15
Sub_3B17:      ABX                   
	ADDD <$58             
	STD <$58              
	CMPD <$60             
	BCS *-33  ; C=1 (BLO)
	LDX <$5B              
	LDD <$53              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	BEQ *+11
	CMPD ,X               
Sub_3B2C:      LBNE Sub_3A24         
	BRA *+6

; --------------------------------------------------------------
Sub_3B32:      CMPA ,X               
Insn_3B34:      BRA *-8
Sub_3B36:      EQU    Insn_3B34+2      ; [*28] branch target 2 byte(s) inside Insn_3B34 — see [*28]
	TST 6,Y               
	ROLB                  
	LDD <$5E              
	CMPD #$0000           
	BNE *+9
	LBSR Sub_2A1E          ; call Sub_2A1E
	BCS *+82  ; C=1 (BLO)
	BRA *+77

; --------------------------------------------------------------
Sub_3B49:      LDX #$00EF            
	CMPD #$0001           
	BNE *+62
	LDD <$62              
	LBSR Sub_414F          ; call Sub_414F
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	ASRB                  
	BEQ *+53
	PSHS A,X,Y            
	LDX #$00A9            
	LDA <$95              
	STA 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_071E,PCR          ; X → Dat_071E
	LDY #$0008            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA $0CCC             
	LBSR Sub_1ECC          ; call Sub_1ECC
	LDX #$00A9            
	STA 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y            
Sub_3B8E:      LDD <$62              
	LBSR Sub_4691          ; call Sub_4691
	CLRB                   ; B = 0
Sub_3B94:      PULS X,Y              
Insn_3B96:     RTS                    ; return from subroutine
Sub_3B97:      EQU    Insn_3B96+1      ; [*29] branch target 1 byte(s) inside Insn_3B96 — see [*29]
	TSTB                  
	LBSR Sub_3EC2          ; call Sub_3EC2
	LBSR Sub_1F6B          ; call Sub_1F6B
	LDD #$0D07            
	LBSR Sub_24DC          ; call Sub_24DC
	LDB #$14              
	LDA <$5A              
	BEQ *+18
	MUL                    ; D = A×B unsigned
	LEAX Dat_05ED,PCR          ; X → Dat_05ED
	LEAX D,X              
	LDA #$01              
	LDY #$0014            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_3BBB:      COMB                  
Insn_3BBC:      BRA *-40
Sub_3BBE:      EQU    Insn_3BBC+2      ; [*30] branch target 2 byte(s) inside Insn_3BBC — see [*30]
	DEC -9,X              
	FCB    $0A                ; undefined opcode $0A -- not a valid 6809 instruction
	ASR 0,Y               
	FCB    $CF                ; undefined opcode $CF -- not a valid 6809 instruction
Sub_3BC5:      LDA #$0A               ; A = LF
	STA <$5D              
	LBRA Sub_3A32         

; --------------------------------------------------------------
Sub_3BCC:      PSHS A,B,X            
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	BEQ *+9
	CLRA                   ; A = 0
	LDB <$7C              
	STD <$6B              
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3BD9:      LDX #$0CA3            
	OS9 F$Time             ; buf→X  → 6-byte time
	LDA 5,X               
	STA <$6B              
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3BE5:      PSHS B,X              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	BEQ *+18
	LDA #$01              
	LDB <$7C              
	SUBD <$6B             
	TFR B,A               
	LDX #$0001            
	LBSR Sub_1178          ; call Sub_1178
	PULS B,X,PC            ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3BFB:      LDX #$0CA3            
	OS9 F$Time             ; buf→X  → 6-byte time
	LDA 5,X               
	LDX #$0001            
	OS9 F$Sleep            ; ticks→X  (0=forever)
	ADDA #$3C             
	SUBA <$6B             
	CMPA #$3C              ; compare A with '<'

CrcTable
; CRC-16/CCITT lookup table â€” 256 entries x 2 bytes = 512 bytes
; ── 4 bytes  ($3C0F—$3C12) ──
         FDB    $2502
         FDB    $803C

Dat_3C13
; ── 2 bytes  ($3C13—$3C14) ──
         FCB    $35               ; '5'
         FCB    $94

Dat_3C15
; Referenced by: $3E24
; ── 512 bytes  ($3C15—$3E14) ──
         FCB    $00               ; NUL
         FCB    $00               ; NUL
         FCB    $10               ; $10
         FCC    "! B0c@"
         FCB    $84
         FCC    "P"
         FCS    "%"
         FCC    "`"
         FCS    "F"
         FCC    "p"
         FCS    "g"
         FCB    $81
         FCB    $08               ; BS
         FCB    $91
         FCC    ")"
         FCS    "!"
         FCC    "J"
         FCS    "1"
         FCC    "k"
         FCS    "A"
         FCB    $8C
         FCS    "Q"
         FCS    "-"
         FCS    "a"
         FCS    "N"
         FCS    "q"
         FCS    "o"
         FCB    $12               ; $12
         FCB    $31               ; '1'
         FCB    CurXY,$10,$32     ; CurXY(row=-16,col=18)
         FCB    $22
         FCS    "5"
         FCB    $42               ; 'B'
         FCB    $94
         FCC    "r"
         FCS    "w"
         FCC    "b"
         FCS    "V"
         FCB    $93
         FCB    $39               ; '9'
         FCB    $83
         FCB    $18               ; CAN erase-BOL
         FCS    "3"
         FCC    "{"
         FCS    "#"
         FCC    "Z"
         FCS    "S"
         FCS    "="
         FCS    "C"
         FCB    $9C
         FCS    "s"
         FCS    ""
         FCS    "c"
         FCS    "^"
         FCC    "$b4C"
         FCB    $04               ; EOT
         FCB    $20               ; ' '
         FCB    $14               ; DC4 erase-EOL
         FCB    $01               ; SOH
         FCC    "d"
         FCS    "f"
         FCC    "t"
         FCS    "G"
         FCC    "D"
         FCS    "$"
         FCB    $54               ; 'T'
         FCB    $85
         FCS    "%"
         FCC    "j"
         FCS    "5"
         FCB    $4B               ; 'K'
         FCB    $85
         FCB    $28               ; '('
         FCB    $95
         FCB    $09               ; HT
         FCS    "e"
         FCS    "n"
         FCS    "u"
         FCS    "O"
         FCS    "E"
         FCS    ","
         FCS    "U"
         FCB    $8D
         FCC    "6S&r"
         FCB    $16               ; SYN insert-line
         FCB    $11               ; DC1/XON
         FCB    $06               ; $06
         FCC    "0v"
         FCS    "W"
         FCC    "f"
         FCS    "v"
         FCB    $56               ; 'V'
         FCB    $95
         FCC    "F"
         FCS    "4"
         FCS    "7"
         FCC    "["
         FCS    "'"
         FCB    $7A               ; 'z'
         FCB    $97
         FCB    $19               ; EM home
         FCB    $87
         FCC    "8"
         FCS    "w"
         FCS    "_"
         FCS    "g"
         FCS    "~"
         FCS    "W"
         FCB    $9D
         FCS    "G"
         FCS    "<"
         FCC    "H"
         FCS    "D"
         FCC    "X"
         FCS    "e"
         FCB    $68               ; 'h'
         FCB    $86
         FCC    "x"
         FCS    "'"
         FCB    $08               ; BS
         FCB    $40               ; '@'
         FCB    $18               ; CAN erase-BOL
         FCC    "a("
         FCB    CurXY,$38,$23     ; CurXY(row=24,col=3)
         FCS    "I"
         FCS    "L"
         FCS    "Y"
         FCS    "m"
         FCS    "i"
         FCB    $8E
         FCS    "y"
         FCS    "/"
         FCB    $89
         FCB    $48               ; 'H'
         FCB    $99
         FCC    "i"
         FCS    ")"
         FCB    $0A               ; LF
         FCS    "9"
         FCC    "+Z"
         FCS    "u"
         FCC    "J"
         FCS    "T"
         FCC    "z"
         FCS    "7"
         FCB    $6A               ; 'j'
         FCB    $96
         FCB    $1A               ; SUB clear+home
         FCB    $71               ; 'q'
         FCB    $0A               ; LF
         FCC    "P:3*"
         FCB    $12               ; $12
         FCS    "["
         FCS    "}"
         FCS    "K"
         FCS    "\"
         FCS    "{"
         FCS    "?"
         FCS    "k"
         FCB    $9E
         FCB    $9B
         FCB    $79               ; 'y'
         FCB    $8B
         FCC    "X"
         FCS    ";"
         FCC    ";"
         FCS    "+"
         FCB    $1A               ; SUB clear+home
         FCC    "l"
         FCS    "&"
         FCB    $7C               ; '|'
         FCB    $87
         FCC    "L"
         FCS    "d"
         FCC    "\"
         FCS    "E"
         FCB    $22
         FCB    $03               ; ETX
         FCB    $0C               ; FF clear+home
         FCB    $60               ; '`'
         FCB    $1C               ; $1C
         FCC    "A"
         FCS    "m"
         FCS    "."
         FCS    "}"
         FCB    $8F
         FCS    "M"
         FCS    "l"
         FCS    "]"
         FCS    "M"
         FCS    "-"
         FCC    "*"
         FCS    "="
         FCB    $0B               ; VT cursor-up
         FCB    $8D
         FCB    $68               ; 'h'
         FCB    $9D
         FCC    "I~"
         FCB    $97
         FCC    "n"
         FCS    "6"
         FCC    "^"
         FCS    "U"
         FCC    "N"
         FCS    "t"
         FCB    $3E               ; '>'
         FCB    $13               ; DC3/XOFF
         FCC    ".2"
         FCB    $1E               ; $1E
         FCB    $51               ; 'Q'
         FCB    $0E               ; SO cursor-right
         FCB    $70               ; 'p'
         FCS    ""
         FCB    $9F
         FCS    "o"
         FCS    ">"
         FCS    "_"
         FCS    "]"
         FCS    "O"
         FCS    "|"
         FCS    "?"
         FCB    $1B               ; ESC windowing cmd
         FCS    "/"
         FCB    $3A               ; ':'
         FCB    $9F
         FCB    $59               ; 'Y'
         FCB    $8F
         FCB    $78               ; 'x'
         FCB    $91
         FCB    $88
         FCB    $81
         FCS    ")"
         FCS    "1"
         FCS    "J"
         FCS    "!"
         FCS    "k"
         FCS    "Q"
         FCB    $0C               ; FF clear+home
         FCS    "A"
         FCC    "-"
         FCS    "q"
         FCC    "N"
         FCS    "a"
         FCB    $6F               ; 'o'
         FCB    $10               ; $10
         FCB    $80
         FCB    $00               ; NUL
         FCS    "!"
         FCC    "0"
         FCS    "B"
         FCC    " "
         FCS    "c"
         FCB    $50               ; 'P'
         FCB    $04               ; EOT
         FCC    "@%pF`g"
         FCB    $83
         FCS    "9"
         FCB    $93
         FCB    $98
         FCS    "#"
         FCS    "{"
         FCS    "3"
         FCS    "Z"
         FCS    "C"
         FCC    "="
         FCS    "S"
         FCB    $1C               ; $1C
         FCS    "c"
         FCB    $7F
         FCS    "s"
         FCB    $5E               ; '^'
         FCB    CurXY,$B1,$12     ; CurXY(row=145,col=-14)
         FCB    $90
         FCB    $22
         FCS    "s"
         FCC    "2"
         FCS    "R"
         FCC    "B5R"
         FCB    $14               ; DC4 erase-EOL
         FCC    "bwrV"
         FCS    "5"
         FCS    "j"
         FCS    "%"
         FCS    "K"
         FCB    $95
         FCS    "("
         FCB    $85
         FCB    $89
         FCS    "u"
         FCC    "n"
         FCS    "e"
         FCC    "O"
         FCS    "U"
         FCC    ","
         FCS    "E"
         FCB    $0D               ; CR
         FCC    "4"
         FCS    "b"
         FCC    "$"
         FCS    "C"
         FCB    $14               ; DC4 erase-EOL
         FCS    " "
         FCB    $04               ; EOT
         FCB    $81
         FCC    "tfdGT$D"
         FCB    $05               ; $05
         FCS    "'"
         FCS    "["
         FCS    "7"
         FCS    "z"
         FCB    $87
         FCB    $99
         FCB    $97
         FCS    "8"
         FCS    "g"
         FCC    "_"
         FCS    "w"
         FCC    "~"
         FCS    "G"
         FCB    $1D               ; $1D
         FCS    "W"
         FCC    "<&"
         FCS    "S"
         FCC    "6"
         FCS    "r"
         FCB    $06               ; $06
         FCB    $91
         FCB    $16               ; SYN insert-line
         FCS    "0"
         FCC    "fWvvF"
         FCB    $15               ; NAK erase-EOS
         FCC    "V4"
         FCS    "Y"
         FCC    "L"
         FCS    "I"
         FCC    "m"
         FCS    "y"
         FCB    $0E               ; SO cursor-right
         FCS    "i"
         FCB    $2F               ; '/'
         FCB    $99
         FCS    "H"
         FCB    $89
         FCS    "i"
         FCS    "9"
         FCB    $8A
         FCS    ")"
         FCS    "+"
         FCC    "XDHex"
         FCB    $06               ; $06
         FCC    "h'"
         FCB    $18               ; CAN erase-BOL
         FCS    "@"
         FCB    $08               ; BS
         FCS    "a"
         FCB    $38               ; '8'
         FCB    $82
         FCC    "("
         FCS    "#"
         FCS    "K"
         FCC    "}"
         FCS    "["
         FCC    "\"
         FCS    "k"
         FCC    "?"
         FCS    "{"
         FCB    $1E               ; $1E
         FCB    $8B
         FCS    "y"
         FCB    $9B
         FCS    "X"
         FCS    "+"
         FCS    ";"
         FCS    ";"
         FCB    $9A
         FCC    "JuZTj7z"
         FCB    $16               ; SYN insert-line
         FCB    $0A               ; LF
         FCS    "q"
         FCB    $1A               ; SUB clear+home
         FCS    "P"
         FCC    "*"
         FCS    "3"
         FCB    $3A               ; ':'
         FCB    $92
         FCS    "}"
         FCC    "."
         FCS    "m"
         FCB    $0F               ; SI cursor-left
         FCS    "]"
         FCC    "l"
         FCS    "M"
         FCC    "M"
         FCS    "="
         FCS    "*"
         FCS    "-"
         FCB    $8B
         FCB    $9D
         FCS    "h"
         FCB    $8D
         FCS    "I"
         FCC    "|&l"
         FCB    $07               ; BEL
         FCC    "\dLE<"
         FCB    $22
         FCB    $2C               ; ','
         FCB    $83
         FCB    $1C               ; $1C
         FCS    "`"
         FCB    $0C               ; FF clear+home
         FCS    "A"
         FCS    "o"
         FCB    $1F               ; $1F
         FCS    ""
         FCC    ">"
         FCS    "O"
         FCC    "]"
         FCS    "_"
         FCC    "|"
         FCS    "/"
         FCB    $9B
         FCS    "?"
         FCS    ":"
         FCB    $8F
         FCS    "Y"
         FCB    $9F
         FCS    "x"
         FCB    $6E               ; 'n'
         FCB    $17               ; ETB delete-line
         FCC    "~6NU^t."
         FCB    $93
         FCC    ">"
         FCS    "2"
         FCB    $0E               ; SO cursor-right
         FCS    "Q"
         FCB    $1E               ; $1E
         FCS    "p"
Sub_3E15:      PSHS A,B,X,Y          
	LEAY D,X              
	PSHS Y                
	LDY <$5B              
	PSHS Y                
	CMPX <$5B             
	BCC *+27  ; C=0 (BHS)
	LEAY Dat_3C15,PCR          ; Y → Dat_3C15
Sub_3E28:      LDB <$53              
	CLRA                   ; A = 0
	EORB ,X+              
	LSLB                  
	ROLA                  
	LDD D,Y               
	EORA <$54             
	STD <$53              
	CMPX ,S               
	BEQ *+6
	CMPX 2,S              
	BCS *-19  ; C=1 (BLO)
Sub_3E3D:      LEAS 4,S              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E41:      PSHS A,B,X,Y          
	LEAY D,X              
	PSHS Y                
	CMPX <$5B             
	BEQ *+14
	LDA <$53              
Sub_3E4D:      ADDA ,X+              
	CMPX <$5B             
	BEQ *+6
	CMPX ,S               
	BCS *-8  ; C=1 (BLO)
Sub_3E57:      STA <$53              
	LEAS 2,S              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E5D:      PSHS A,X,Y            
	LDX #$0050            
	LDA <$38              
	LDY #$0001            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E6D:      STA <$50              
	BRA *-18

; --------------------------------------------------------------
Sub_3E71:      LDA #$43               ; A = 'C'
	BRA *-6
         FCB    $86,$04,$20,$F4  ; unreachable padding
Sub_3E79:      LDA #$06              
	BRA *-14

; --------------------------------------------------------------
Sub_3E7D:      LDA #$15              
	BRA *-18

; --------------------------------------------------------------
Sub_3E81:      PSHS A,B,X,Y          
	LEAX Dat_0651,PCR          ; X → Dat_0651
	LDY #$1463            
	LDB #$09              
	JSR [$0CAF]            ; call via indexed pointer
	LDX #$1463            
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3E99:      PSHS A,B,X,Y          
	LEAX Dat_065A,PCR          ; X → Dat_065A
	LDY #$1453            
	LDB #$09              
	JSR [$0CAF]            ; call via indexed pointer
	LDX #$1453            
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3EB1:      PSHS A,B,X,Y          
	LDX #$1453            
	LDD #$3030            
	STD 5,X               
	STD 7,X               
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3EC2:      PSHS A,X,Y            
	LDX #$1453            
	BSR *+29  ; call Sub_3EE4
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)
         FCB    $34,$32,$8E,$14,$63,$17,$DE,$BF,$35,$B2  ; unreachable padding
Sub_3ED8:      PSHS A,X,Y            
	LDX #$1463            
	BSR *+7  ; call Sub_3EE4
	LBSR Sub_1D95          ; call Sub_1D95
	PULS A,X,Y,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_3EE4:      PSHS B                
	LDB #$08               ; B = BS
Sub_3EE8:      BSR *+11  ; call Sub_3EF3
	CMPA #$30              ; compare A with '0'
	BNE *+5
	DECB                  
	BCC *-7  ; C=0 (BHS)
Sub_3EF1:      PULS B,PC              ; return from subroutine  (PULS PC = RTS)
Sub_3EF3:      LDA B,X               
	INCA                  
	CMPA #$39              ; compare A with '9'
	BHI *+5
	STA B,X               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_3EFD:      LDA #$30               ; A = '0'
	STA B,X               
Insn_3F01:     RTS                    ; return from subroutine
Sub_3F02:      EQU    Insn_3F01+1      ; [*31] branch target 1 byte(s) inside Insn_3F01 — see [*31]
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BEQ *+14
	LBSR Sub_2BF4          ; call Sub_2BF4
Sub_3F08:      ADDB 13,X             
	LEAX -16,X            
	BNE *-4
	SUBA #$17             
	STD 14,Y              
Sub_3F12:      LEAX Dat_05A9,PCR          ; X → Dat_05A9
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$00AC            
	LDA #$01              
	LDY #$0020            
	OS9 I$WritLn           ; path=A  buf→X
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_0726,PCR          ; X → Dat_0726
	LBSR Sub_1D95          ; call Sub_1D95
	LDA #$01              
	LDX #$00AC            
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCC *+12  ; C=0 (BHS)
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	LBEQ Sub_398F         
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
Insn_3F44:     LSR $201B             
Sub_3F46:      EQU    Insn_3F44+2      ; [*32] branch target 2 byte(s) inside Insn_3F44 — see [*32]
	STA <$4F              
	LDX #$00EC            
	LDY #$007F            
	OS9 I$Read             ; path=A  count=Y  buf→X
	BCS *-22  ; C=1 (BLO)
Sub_3F54:      EORB -1,X             
	BRA *+25
         FCB    $01,$F5,$96,$4F,$8E,$00,$00,$10,$3F,$88,$30,$8D,$C6,$53,$17,$DE,$2C,$30,$8D,$C5,$E8,$17,$DE  ; unreachable padding
Sub_3F6F:      BCS *+25  ; C=1 (BLO)
	STU $0E17             
	STU $230D             
	ASRB                  
	BEQ *+49
	LDX #$00A9            
	LDA <$95              
	STA 2,X               
	LDY #$0003            
	LDA #$01              
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_3F88:      SWI $8A               
	LEAX Dat_071E,PCR          ; X → Dat_071E
	LDY #$0008            
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDX #$00A9            
	LDA $0CCC             
	LBSR Sub_1ECC          ; call Sub_1ECC
	STA 2,X               
	LDY #$0003            
	LDA #$01              
Insn_3FA6:     OS9 I$Write            ; path=A  count=Y  buf→X
Sub_3FA9:      EQU    Insn_3FA6+3      ; [*33] branch target 3 byte(s) inside Insn_3FA6 — see [*33]
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	LDD #$0080            
	STD <$62              
	ADDD #$0004           
	STD <$60              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	LBNE Sub_40B9         
	LDX #$13C3            
	LBSR Sub_2DB6          ; call Sub_2DB6
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
	BEQ *+12
	LDD #$0400            
	STD <$62              
	ADDD #$0004           
	STD <$60              
Sub_3FCF:      LDD #$0001            
	STD <$5E              
	LBSR Sub_3ED8          ; call Sub_3ED8
	LBSR Sub_3EB1          ; call Sub_3EB1
	LBSR Sub_3758          ; call Sub_3758
	LBSR Sub_2653          ; call Sub_2653
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $52                ; undefined opcode $52 -- not a valid 6809 instruction
	BEQ *+10
	LDD <$5E              
	CMPD #$0001           
	BEQ *+18
Sub_3FEC:      LBSR Sub_2BBC          ; call Sub_2BBC
	LBCS Sub_40B6         
	CMPA #$43              ; compare A with 'C'
	BEQ *+7
	LBSR Sub_26DB          ; call Sub_26DB
	BRA *+25

; --------------------------------------------------------------
Sub_3FFC:      LDA #$01              
	STA <$65              
	LBSR Sub_26DB          ; call Sub_26DB
	LDD <$62              
	ADDD #$0005           
	STD <$60              
	BRA *+25

; --------------------------------------------------------------
Sub_400C:      LBSR Sub_2BBC          ; call Sub_2BBC
	LBCS Sub_40B6         
Sub_4013:      CMPA #$15             
	BEQ *+14
	CMPA #$06             
	BEQ *+52
	CMPA #$18             
	LBEQ Sub_40B6         
Insn_4021:      BRA *-53
Sub_4023:      EQU    Insn_4021+2      ; [*34] branch target 2 byte(s) inside Insn_4021 — see [*34]
	TSTB                  
	LDA <$5D              
	CMPA #$09             
	LBHI Sub_40B6         
	CMPA #$01             
	BNE *+10
	LDD <$5E              
	CMPD #$0001           
	BEQ *+8
Sub_4039:      LBSR Sub_3EC2          ; call Sub_3EC2
	LBSR Sub_1F6B          ; call Sub_1F6B
Sub_403F:      LDY <$60              
	LDA <$38              
	LDX #$00EC            
	JSR [$0CB5]            ; call via indexed pointer
Insn_404A:     BITA $20BF            
Sub_404D:      EQU    Insn_404A+3      ; [*35] branch target 3 byte(s) inside Insn_404A — see [*35]
	TSTB                  
	LBSR Sub_3EB1          ; call Sub_3EB1
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	DEC 6,Y               
	ABX                   
	LDD <$5E              
	ADDD #$0001           
	STD <$5E              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $51                ; undefined opcode $51 -- not a valid 6809 instruction
	BEQ *+21
	LDD #$0400            
	STD <$62              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	BEQ *+7
	ADDD #$0005           
	BRA *+5

; --------------------------------------------------------------
Sub_406F:      ADDD #$0004           
Sub_4072:      STD <$60              
Sub_4074:      LBSR Sub_3ED8          ; call Sub_3ED8
	LBSR Sub_2653          ; call Sub_2653
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	DEC 6,Y               
	NOP                   
	LBSR Sub_26DB          ; call Sub_26DB
	LDA <$38              
	LDX #$00EC            
	LDY <$60              
	JSR [$0CB5]            ; call via indexed pointer
	LBRA Sub_400C         
         FCB    $96,$4F,$10,$3F,$8F,$0F,$6A,$0D,$52,$27,$0C,$17,$FD,$D7,$17,$EB,$1B,$25,$13,$12,$16,$FE,$68,$17,$FD,$CB,$17,$EB,$0F,$25,$07,$81,$06,$26,$F4,$16,$F8,$CA  ; unreachable padding
Sub_40B6:      LBRA Sub_39F1         
Sub_40B9:      LBSR Sub_2BBC          ; call Sub_2BBC
	BCS *-6  ; C=1 (BLO)
	CMPA #$43              ; compare A with 'C'
	BNE *-7
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	FCB    $65                ; undefined opcode $65 -- not a valid 6809 instruction
	LDD <$62              
	ADDD #$0005           
	STD <$60              
	LDD #$0000            
	STD <$5E              
	LBSR Sub_2653          ; call Sub_2653
	LBSR Sub_26DB          ; call Sub_26DB
	LDX #$00EC            
	LDY #$13C3            
	LDB #$86              
	JSR [$0CAF]            ; call via indexed pointer
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LSR $2610             
	LDD #$0001            
	STD <$5E              
	LDD #$0400            
	STD <$62              
	LBSR Sub_2653          ; call Sub_2653
	LBSR Sub_26DB          ; call Sub_26DB
Sub_40F7:      LDA <$38              
	LDX #$13C3            
	LDY <$60              
	JSR [$0CB5]            ; call via indexed pointer
Sub_4103:      LBSR Sub_2BBC          ; call Sub_2BBC
	BCS *-80  ; C=1 (BLO)
	CMPA #$06             
	BEQ *+22
	CMPA #$15             
	BNE *-11
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	TSTB                  
	LDA <$5D              
	CMPA #$09             
	BHI *-96
	LBSR Sub_3EC2          ; call Sub_3EC2
	LBSR Sub_1F6B          ; call Sub_1F6B
Insn_411E:      BRA *-39
Sub_4120:      EQU    Insn_411E+2      ; [*36] branch target 2 byte(s) inside Insn_411E — see [*36]
	LSR $1026             
	EORB $69CC            
	FCB    $00                ; undefined opcode $00 -- not a valid 6809 instruction
	FCB    $01                ; undefined opcode $01 -- not a valid 6809 instruction
	STD <$5E              
	LBSR Sub_3ED8          ; call Sub_3ED8
	LDD <$62              
	ADDD #$0005           
	STD <$60              
	LBSR Sub_2BBC          ; call Sub_2BBC
	LBCS Sub_40B6         
	CMPA #$43              ; compare A with 'C'
	BNE *-30
	LDA <$38              
	LDX #$00EC            
	LDY <$60              
	JSR [$0CB5]            ; call via indexed pointer
	LBRA Sub_400C         

; --------------------------------------------------------------
Sub_414F:      PSHS A,B,X            
	TST $0CC2             
	BEQ *+39
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	ASRB                  
	TSTA                  
	BNE *+5
	TSTB                  
	BPL *+4
Sub_415E:      LDB #$80              
Sub_4160:      LDA ,X+               
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
Sub_4176:      DECB                  
	BNE *-23
Insn_4179:     PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)
Sub_417B:      EQU    Insn_4179+2      ; [*37] branch target 2 byte(s) inside Insn_4179 — see [*37]
	ASRB                  
	PULS A,B,X,PC          ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_417F:      LDD #$1504            
	STD $0C9A             
	LDD #$2507            
	STD $0C9C             
	LBSR Sub_1EF1          ; call Sub_1EF1
	LEAX Dat_04B5,PCR          ; X → Dat_04B5
	LBSR Sub_1D95          ; call Sub_1D95
	TST $0CAA             
	LBEQ Sub_435A         
	LEAX Dat_09CD,PCR          ; X → Dat_09CD
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_0542,PCR          ; X → Dat_0542
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	PSHS CC,A,B,Y         
	LSRB                  
	LEAX Dat_0A23,PCR          ; X → Dat_0A23
	LBSR Sub_1D95          ; call Sub_1D95
	LDX #$00CC            
	LDA #$01              
	LDY <$2D              
	LEAY -1,Y             
	OS9 I$Write            ; path=A  count=Y  buf→X
	LEAX Dat_09E6,PCR          ; X → Dat_09E6
	LBSR Sub_1D95          ; call Sub_1D95
Sub_41D0:      LBSR Sub_2C62          ; call Sub_2C62
	CMPA #$59              ; compare A with 'Y'
	BEQ *+20
	CMPA #$0D              ; compare A with CR
	BEQ *+16
	CMPA #$4E              ; compare A with 'N'
	LBEQ Sub_4287         
	CMPA #$05             
	LBEQ Sub_4287         
	BRA *-23

; --------------------------------------------------------------
Sub_41E9:      LBSR Sub_462A          ; call Sub_462A
	LBSR Sub_43E5          ; call Sub_43E5
	LDA <$37              
	OS9 I$Close            ; path=A
	LBCS Sub_4293         
	LDA #$FF              
	STA <$37              
	STA <$4F              
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	ASRB                  
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	PSHS CC,A,B,DP        
	PULS CC,A,B,X         
	ADDD ?$9B             
	BRA *+128
         FCB    $0D,$2F,$26,$21,$30,$8D,$C3,$74,$17,$DB,$81,$C6,$1E,$17,$DB,$D7,$0D,$30,$26,$6A,$DC,$2B,$DD,$2D,$8E,$06,$1B,$10,$8E,$00,$CC,$C6,$20,$AD,$9F,$0C,$AF  ; unreachable padding
Sub_422E:      LDX #$00CC            
	LDA ,X                
	CMPA #$0D              ; compare A with CR
	BEQ *+82
	LDA #$02               ; A = CurXY
	LDB #$03               ; B = SS.Reset  (GetStt/SetStt subcode)
	OS9 I$Create           ; mode=B  name→X  → path→A
	BCC *+32  ; C=0 (BHS)
	CMPB #$DA             
	BNE *+81
	LEAX Dat_0A29,PCR          ; X → Dat_0A29
	LBSR Sub_1D95          ; call Sub_1D95
Sub_424B:      LBSR Sub_2C62          ; call Sub_2C62
	CMPA #$41              ; compare A with 'A'
	BEQ *+107
	CMPA #$4F              ; compare A with 'O'
	LBEQ Sub_42E2         
	CMPA #$0D              ; compare A with CR
	BEQ *+45
Sub_425C:      BRA *-17
Sub_425E:      STA <$37              
Insn_4260:     STA <$4F              
Sub_4262:      EQU    Insn_4260+2      ; [*38] branch target 2 byte(s) inside Insn_4260 — see [*38]
	PSHS B,DP             
Sub_4265:      ASRB                  
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAU 6,Y              
	SEX                    ; sign-extend B into A
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	PULS CC,A,B,X         
	ADDD -15,Y            
	LDB <$1B              
	SUBB <$19             
	CLRA                   ; A = 0
	PSHS A,B              
Sub_4276:      LDA <$15              
	BEQ *+5
	DECA                  
	SUBA <$16             
Sub_427D:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	ADDD ,S++             
	STD <$08              
Insn_4284:     LBSR Sub_4403          ; call Sub_4403
Sub_4287:      EQU    Insn_4284+3      ; [*39] branch target 3 byte(s) inside Insn_4284 — see [*39]
	LEAU -9,X             
	LDD <$C7              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	BLE *+18
	BEQ *-51
	EORA <$39             
Sub_4293:      LDA #$07              
	LBSR Sub_213B          ; call Sub_213B
	PSHS B                
	LDD #$0D02            
	LBSR Sub_24DC          ; call Sub_24DC
Sub_429F:      CWAI #$30             
	BSR *-60  ; call Sub_4265
	1117?                 
	ORB <$EE              
	PULS B                
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_1178          ; call Sub_1178
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	BRA *-50

; --------------------------------------------------------------
Sub_42BB:      LDX #$00CC            
	LDA #$03              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCC *+13  ; C=0 (BHS)
	OS9 F$PErr             ; path=A  error=B
	LDX #$003C            
	LBSR Sub_1178          ; call Sub_1178
	BRA *-59

; --------------------------------------------------------------
Sub_42D0:      STA <$37              
	STA <$4F              
	PSHS U                
	LDB #$02               ; B = SS.Size  (GetStt/SetStt subcode)
	OS9 I$GetStt           ; path=A  subcode=B  buf→X
	OS9 I$Seek             ; path=A  mode=B  offset→X:D
	PULS U                
	BRA *-126

; --------------------------------------------------------------
Sub_42E2:      LDX #$00CC            
	OS9 I$Delete           ; name→X
	LBRA Sub_422E         

; --------------------------------------------------------------
Sub_42EB:      PSHS A,B,X,Y          
	LDX #$071A            
	LDD $0C95             
	LBSR Sub_4691          ; call Sub_4691
	LDB <$1B              
	SUBB <$19             
	CLRA                   ; A = 0
	PSHS A,B              
	LDA <$15              
	BEQ *+5
	DECA                  
	SUBA <$16             
Sub_4304:      LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	MUL                    ; D = A×B unsigned
	ADDD ,S++             
	CMPD <$08             
	BEQ *+5
	LBSR Sub_4403          ; call Sub_4403
Sub_4311:      PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)
Sub_4313:      PSHS A,B,X,Y          
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LEAU ?$9E             
	FCB    $00                ; undefined opcode $00 -- not a valid 6809 instruction
Sub_4319:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	BEQ *+57
	CMPA #$66              ; compare A with 'f'
	BEQ *+6
	CMPA #$46              ; compare A with 'F'
	BNE *-12
Sub_4327:      LDA -2,X              
	CMPA #$20              ; compare A with ' '
	BEQ *+8
	CMPA #$2D              ; compare A with '-'
	BNE *-22
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	LEAU A,Y              
Sub_4333:      LDA ,X+               
	CMPA #$3D              ; compare A with '='
	BNE *-30
	LDY #$00CC            
	CLRB                   ; B = 0
Sub_433E:      LDA ,X+               
	STA ,Y+               
	INCB                  
	CMPA #$0D              ; compare A with CR
	BEQ *+6
	CMPB #$20              ; compare B with ' '
	BCS *-11  ; C=1 (BLO)
Sub_434B:      CLRA                   ; A = 0
	STD <$2D              
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	BLE *+126
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	ORA -9,X              
Insn_4354:     LDU $290F             
Sub_4356:      EQU    Insn_4354+2      ; [*40] branch target 2 byte(s) inside Insn_4354 — see [*40]
	BLE *+55
	LDA $308D             
Sub_435A:      LEAX Dat_0A0E,PCR          ; X → Dat_0A0E
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_04B1,PCR          ; X → Dat_04B1
	LBSR Sub_1D95          ; call Sub_1D95
	LEAX Dat_0585,PCR          ; X → Dat_0585
	LBSR Sub_1D95          ; call Sub_1D95
	LDB #$1E              
	LBSR Sub_1DF0          ; call Sub_1DF0
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	LEAX 6,Y              
	FCB    $5B                ; undefined opcode $5B -- not a valid 6809 instruction
	LDX #$061B            
	LDY #$13C3            
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	JSR [$0CAF]            ; call via indexed pointer
	LDX #$13C3            
	LDA ,X                
	CMPA #$0D              ; compare A with CR
	BEQ *+71
Sub_438E:      LDA #$01              
	OS9 I$Open             ; mode=B  name→X  → path→A
	BCS *+64  ; C=1 (BLO)
	STA <$39              
	LDA #$01              
	STA <$32              
	LBSR Sub_1F53          ; call Sub_1F53
	LDA <$39              
	LDX #$13C3            
	LDY #$00FF            
	OS9 I$ReadLn           ; path=A  max=Y  buf→X
	BCS *+31  ; C=1 (BLO)
	LDA <$38              
	LDX #$13C3            
	OS9 I$WritLn           ; path=A  buf→X
	LBSR Sub_15A4          ; call Sub_15A4
	BCC *+33  ; C=0 (BHS)
Sub_43B9:      LBRA Sub_0E2A         
         FCB    $8E,$00,$04,$17,$CD,$B6,$17,$D1,$E3,$24,$F2,$20,$D5  ; unreachable padding
Sub_43C9:      LDA <$39              
Insn_43CB:     OS9 I$Close            ; path=A
Sub_43CD:      EQU    Insn_43CB+2      ; [*41] branch target 2 byte(s) inside Insn_43CB — see [*41]
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	LEAS -10,X            
Sub_43D0:      LBRA Sub_0E2A         
Sub_43D3:      LBSR Sub_1F53          ; call Sub_1F53
	BRA *-6

; --------------------------------------------------------------
Sub_43D8:      LBSR Sub_2C62          ; call Sub_2C62
	CMPA #$03             
	BEQ *-20
	CMPA #$05             
	BEQ *-24
	BRA *-42

; --------------------------------------------------------------
Sub_43E5:      PSHS A,B,X,Y          
	LDX #$13C3            
	LDD #$0268            
	STD ,X                
	LDD #$2020            
	STD 2,X               
	STD 4,X               
Insn_43F6:     STD 6,X               

Dat_43F7
; ── 12 bytes  ($43F7—$4402) ──
         FCB    $06               ; $06
         FCB    $96
         FCB    $4B               ; 'K'
         FCB    $10               ; $10
         FCB    $8E
         FCB    $00               ; NUL
         FCB    $08               ; BS
         FCB    $10               ; $10
         FCB    $3F               ; '?'
         FCB    $8A
         FCC    "5"
         FCS    "6"
Sub_4403:      PSHS A,B,X,Y          
	STD <$08              
	LSRA                  
	RORB                  
	LSRA                  
	RORB                  
	LDX #$13C3            
	LDY #$3030            
	STY 3,X               
	STY 5,X               
Sub_4418:      CMPD #$03E8           
	BCS *+9  ; C=1 (BLO)
	SUBD #$03E8           
	INC 3,X               
	BRA *-11

; --------------------------------------------------------------
Sub_4425:      CMPD #$0064           
	BCS *+9  ; C=1 (BLO)
	SUBD #$0064           
	INC 4,X               
	BRA *-11

; --------------------------------------------------------------
Sub_4432:      CMPB #$0A              ; compare B with LF
	BCS *+8  ; C=1 (BLO)
	SUBB #$0A             
	INC 5,X               
	BRA *-8

; --------------------------------------------------------------
Sub_443C:      ADDB #$30             
	STB 6,X               
	LDB #$20               ; B = SS.ScSiz  (GetStt/SetStt subcode)
	LDA 3,X               
	CMPA #$30              ; compare A with '0'
	BNE *+20
	STB 3,X               
	LDA 4,X               
	CMPA #$30              ; compare A with '0'
	BNE *+12
	STB 4,X               
	LDA 5,X               
	CMPA #$30              ; compare A with '0'
	BNE *+4
	STB 5,X               
Sub_445A:      LDD #$0268            
	STD ,X                
	LDA #$20               ; A = ' '
	STA 2,X               
	LDA #$4B               ; A = 'K'
	STA 7,X               
	LDA <$4B              
	LDY #$0008            
	OS9 I$Write            ; path=A  count=Y  buf→X
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_4472:      PSHS A,B,X,Y          
	LDX #$071A            
	LDB $0C96             
	LDY <$10              
Sub_447D:      LDA ,X+               
	STA ,Y+               
	DECB                  
	CMPY <$0C             
	BCS *+5  ; C=1 (BLO)
	LDY <$0E              
Sub_448A:      TSTB                  
	BNE *-14
	STY <$10              
	PULS A,B,X,Y,PC        ; return from subroutine  (PULS PC = RTS)

; --------------------------------------------------------------
Sub_4492:      PSHS A,B,X,Y          
	LDX <$10              
Sub_4496:      LDA ,-X               
	CMPA #$2E              ; compare A with '.'
	BEQ *+16
Sub_449C:      CMPX <$0E             
	BNE *+4
	LDX <$0C              
Sub_44A2:      CMPX <$10             
	BNE *-14
	FCB    $0F                ; undefined opcode $0F -- not a valid 6809 instruction
	EORA -11,Y            
	LDA $A601             
Sub_44AA:      LDA 1,X               
	CMPA #$2E              ; compare A with '.'
	BCS *-18  ; C=1 (BLO)
	LDA -1,X              
	CMPA #$2E              ; compare A with '.'
	BCS *-24  ; C=1 (BLO)
Sub_44B6:      LDA ,-X               
	CMPA #$30              ; compare A with '0'
	BCS *+8  ; C=1 (BLO)
	CMPX <$10             
	BEQ *-28
	BRA *-10

; --------------------------------------------------------------
Sub_44C2:      LDA 1,X               
	CMPA #$41              ; compare A with 'A'
	BCS *-36  ; C=1 (BLO)
	LDB #$1F              
	LEAX 1,X              
	LDY #$00AC            
Sub_44D0:      LDA ,X+               
Sub_44D2:      CMPA #$2E              ; compare A with '.'
	BCS *+23  ; C=1 (BLO)
	STA ,Y+               
	DECB                  
	BEQ *+18
	CMPX <$0C             
	BEQ *+8
	CMPX <$10             
	BEQ *+10
	BRA *-19

; --------------------------------------------------------------
Sub_44E5:      LDA ,X                
	LDX <$0E              
	BRA *-23

; --------------------------------------------------------------
Sub_44EB:      LDA #$0D               ; A = CR
	STA ,Y                
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	EORA 0,Y              
Insn_44F2:     BITA $0F1D            
Sub_44F3:      EQU    Insn_44F2+1      ; [*42] branch target 1 byte(s) inside Insn_44F2 — see [*42]
	SEX                    ; sign-extend B into A
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	FCB    $7B                ; undefined opcode $7B -- not a valid 6809 instruction
	LBEQ Sub_45BD         
	LDX <$00              
Sub_44FD:      LDA ,X+               
	CMPA #$0D              ; compare A with CR
	LBEQ Sub_45BD         
	CMPA #$62              ; compare A with 'b'
	BEQ *+6
	CMPA #$42              ; compare A with 'B'
	BNE *-14
Sub_450D:      LDA -2,X              
	CMPA #$20              ; compare A with ' '
	BEQ *+6
	CMPA #$2D              ; compare A with '-'
	BNE *-24
Sub_4517:      LDA ,X+               
	CMPA #$3D              ; compare A with '='
	BNE *-30
	LDY #$13C3            
	CLRB                   ; B = 0
Sub_4522:      LDA ,X+               
	CMPA #$30              ; compare A with '0'
	BMI *+15
	CMPA #$39              ; compare A with '9'
	BHI *+11
	SUBA #$30             
	STA ,Y+               
	INCB                  
	CMPB #$03             
	BCS *-17  ; C=1 (BLO)
Sub_4535:      TSTB                  
	LBEQ Sub_45BD         
	CLRA                   ; A = 0
	PSHS A,B              
	PSHS A                
	LDB ,-Y               
	STB 1,S               
	LDA 2,S               
	DECA                  
	BEQ *+51
	STA 2,S               
	LDB ,-Y               
	LDA #$0A               ; A = LF
	MUL                    ; D = A×B unsigned
	ADDD ,S               
	STD ,S                
	LDA 2,S               
	DECA                  
	BEQ *+35
	STA 2,S               
	LDB ,-Y               
	LDA #$64               ; A = 'd'
	MUL                    ; D = A×B unsigned
	ADDD ,S               
	STD ,S                
	LDA 2,S               
	DECA                  
	BEQ *+19
	CLRA                   ; A = 0
	CLRB                   ; B = 0
	TST ,Y                
	BEQ *+9
	ADDD #$03E8           
	DEC ,Y                
	BRA *-9

; --------------------------------------------------------------
Sub_4575:      ADDD ,S++             
	BRA *+4

; --------------------------------------------------------------
Sub_4579:      PULS A,B              
Sub_457B:      LEAS 1,S              
	ADDD #$0007           
	LSRA                  
	RORB                  
	LSRA                  
	RORB                  
	LSRA                  
	RORB                  
	TSTA                  
	BNE *+7
	TSTB                  
	LBEQ Sub_45BD         
Sub_458E:      TFR D,X               
	STB <$15              
	LDA <$7B              
	LDB #$CA              
	OS9 I$SetStt           ; path=A  subcode=B  buf→X
	LBCS Sub_45BD         
	TFR X,D               
	STB <$14              
	STB <$16              
	ADDB <$15             
	STB <$15              
	LDB <$14              
	PSHS U                
	LBSR Sub_4621          ; call Sub_4621
	STU <$17              
	STU <$19              
	LEAU 8192,U           
	STU <$1B              
	PULS U                
	FCB    $0C                ; undefined opcode $0C -- not a valid 6809 instruction
	SEX                    ; sign-extend B into A
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_45BD:      LDD <$04              
	STD <$17              
	STD <$19              
	LDD <$02              
	STD <$1B              
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_45C8:      LDX <$17              
	LDD <$19              
	SUBD <$17             
	TFR D,Y               
	LDA <$4F              
	BMI *+27
	LDA $0CC5             
	BEQ *+7
	STA <$50              
	LBSR Sub_3E5D          ; call Sub_3E5D
Sub_45DE:      LDA <$4F              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA $0CC4             
	BEQ *+7
	STA <$50              
	LBSR Sub_3E5D          ; call Sub_3E5D
Sub_45ED:      LDD <$17              
	STD <$19              
	LBRA Sub_468F         

; --------------------------------------------------------------
Sub_45F4:      PSHS A,B,X,Y,U        
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	SEX                    ; sign-extend B into A
	BEQ *-48
	LDA <$16              
	INCA                  
	CMPA <$15             
	BNE *+6
	BSR *+41  ; call Sub_462A
	BRA *+20

; --------------------------------------------------------------
Sub_4605:      STA <$16              
	BSR *+18  ; call Sub_4619
	TFR A,B               
	BSR *+22  ; call Sub_4621
	STU <$17              
	STU <$19              
	LEAU 8192,U           
	STU <$1B              
Sub_4617:      PULS A,B,X,Y,U,PC      ; return from subroutine  (PULS PC = RTS)
Sub_4619:      LDU <$17              
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 $50               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_4621:      CLRA                   ; A = 0
	TFR D,X               
	LDB #$01               ; B = SS.Ready  (GetStt/SetStt subcode)
	OS9 $4F               
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_462A:      PSHS A,B,X,Y,U        
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	SEX                    ; sign-extend B into A
	LBEQ Sub_45C8         
	LDA $0CC5             
	BEQ *+7
	STA <$50              
	LBSR Sub_3E5D          ; call Sub_3E5D
Sub_463C:      LDA <$14              
Sub_463E:      PSHS A                
	BSR *-39  ; call Sub_4619
	TFR A,B               
	BSR *-35  ; call Sub_4621
	LDA ,S                
	CMPA <$16             
	BEQ *+20
	LDA <$4F              
	BMI *+11
	TFR U,X               
	LDY #$2000            
	OS9 I$Write            ; path=A  count=Y  buf→X
Sub_4659:      PULS A                
	INCA                  
	BRA *-30

; --------------------------------------------------------------
Sub_465E:      TFR U,X               
	LDD <$19              
	SUBD <$17             
	BEQ *+23
	TFR D,Y               
	LDA <$4F              
	BMI *+17
	LDA <$4F              
	OS9 I$Write            ; path=A  count=Y  buf→X
	LDA $0CC4             
	BEQ *+7
	STA <$50              
	LBSR Sub_3E5D          ; call Sub_3E5D
Sub_467B:      PULS A                
	BSR *-100  ; call Sub_4619
	LDB <$14              
	STB <$16              
	BSR *-98  ; call Sub_4621
	STU <$17              
	STU <$19              
	LEAU 8192,U           
	STU <$1B              
Sub_468F:      PULS A,B,X,Y,U,PC      ; return from subroutine  (PULS PC = RTS)
Sub_4691:      PSHS A,B,Y            
	CMPD #$0000           
	BEQ *+97
	PSHS A,B              
Sub_469B:      LDD <$1B              
	SUBD <$19             
	PSHS A,B              
	LDD 2,S               
	SUBD ,S               
	BCS *+6  ; C=1 (BLO)
	STD 2,S               
	BRA *+10

; --------------------------------------------------------------
Sub_46AB:      LDD 2,S               
	STD ,S                
	CLRA                   ; A = 0
	CLRB                   ; B = 0
	STD 2,S               
Sub_46B3:      LDY <$19              
	FCB    $0D                ; undefined opcode $0D -- not a valid 6809 instruction
	ASRB                  
	BEQ *+6
	BSR *+64  ; call Sub_46FA
Insn_46BC:      BRA *+12
Sub_46BE:      EQU    Insn_46BC+2      ; [*43] branch target 2 byte(s) inside Insn_46BC — see [*43]
	BVC *+41
	FCB    $04                ; undefined opcode $04 -- not a valid 6809 instruction
	BSR *+34  ; call Sub_46E4
	BRA *+4
         FCB    $8D,$0E  ; unreachable padding
Sub_46C8:      LEAS 2,S              
	STY <$19              
	LDD ,S                
	BEQ *+29
	LBSR Sub_45F4          ; call Sub_45F4
	BRA *-57
         FCB    $A6,$80,$A7,$A0,$EC,$62,$83,$00,$01,$ED,$62,$22,$F3,$39  ; unreachable padding
Sub_46E4:      LDD 2,S               
	EXG D,?               
Sub_46E8:      1138?                 
	NOP                   
	RTS                    ; return from subroutine

; --------------------------------------------------------------
Sub_46EC:      LDD <$19              
	CMPD <$1B             
	BCS *+5  ; C=1 (BLO)
	LBSR Sub_45F4          ; call Sub_45F4
Sub_46F6:      LEAS 2,S              
Sub_46F8:      PULS A,B,Y,PC          ; return from subroutine  (PULS PC = RTS)
Sub_46FA:      LDA ,X+               
	CMPA #$1F             
	BHI *+10
	CMPA #$0A              ; compare A with LF
	BEQ *+8
	CMPA #$1A              ; compare A with SUB
	BEQ *+4
Sub_4708:      STA ,Y+               
Sub_470A:      LDD 2,S               
	SUBD #$0001           
	STD 2,S               
	BHI *-23
	RTS                    ; return from subroutine

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

; [*2] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*3] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*4] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $1154 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $03 at $1154 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $03 is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $03 may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*5] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*6] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*7] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*8] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $19AD is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $0D at $19AD is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*9] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*10] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*11] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*12] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*13] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*14] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*15] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $25F2 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $0D at $25F2 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*16] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*17] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*18] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*19] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*20] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*21] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*22] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $2D87 is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $0D at $2D87 is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0D is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0D may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*23] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*24] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*25] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*26] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*27] UNRESOLVABLE DISASSEMBLY CONDITION
; ──────────────────────────────────────────────────────────────
;      $397B is referenced as a branch target but falls
;      inside the operand of a preceding instruction (unknown).
;      Byte $0F at $397B is not a valid 6809 opcode.
;
;      On 6809 / 6309-emulation mode: $0F is a harmless undefined
;      opcode — execution falls through to the next instruction.
;      On 6309 native mode: $0F may be interpreted as a 6309
;      instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.
;
;
;      Probable cause: the branch target address is off by one byte
;      (a bug in the original code, or a deliberate overlapping-code trick).

; [*28] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*29] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*30] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*31] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*32] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*33] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*34] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*35] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*36] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*37] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*38] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*39] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*40] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*41] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*42] UNRESOLVABLE DISASSEMBLY CONDITION
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

; [*43] UNRESOLVABLE DISASSEMBLY CONDITION
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