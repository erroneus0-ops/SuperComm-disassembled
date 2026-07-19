  1  POLCAT    EQU     $A000
  2  CHROUT    EQU     $A002
  3  CLRSCR    EQU     $A928
  4  CURPOS    EQU     $0088
  5  SCREEN    EQU     $0400
  6  COLS      EQU     32
  7  HELLO_POS EQU     SCREEN+(7*COLS)+10
  8  WORLD_POS EQU     SCREEN+(7*COLS)+16
  9  EXIT_POS  EQU     SCREEN+(13*COLS)+0
 10            ORG     0
 11  Start
 12            JSR     CLRSCR
 13            LDX     #HELLO_POS
 14            LEAY    Hello,PCR
 15            LDB     #6
 16  WriteHello
 17            LDA     ,Y+
 18            CMPA    #' '
 19            BEQ     WriteSpace
 20            ANDA    #$3F
 21            ORA     #$40
 22            BRA     StoreChar
 23  WriteSpace
 24            LDA     #$60
 25  StoreChar
 26            STA     ,X+
 27            DECB
 28            BNE     WriteHello
 29            LDD     #WORLD_POS
 30            STD     <CURPOS
 31            LEAX    World,PCR
 32            BSR     PrintStr
 33            LDD     #EXIT_POS
 34            STD     <CURPOS
 35  WaitKey
 36            JSR     [POLCAT]
 37            BEQ     WaitKey
 38            RTS
 39  PrintStr
 40            LDA     ,X+
 41            BEQ     PrintDone
 42            JSR     [CHROUT]
 43            BRA     PrintStr
 44  PrintDone
 45            RTS
 46  Hello     FCC     "HELLO "
 47  Hello_end
 48  HelloLen  EQU     Hello_end-Hello
 49  World     FCC     "WORLD!"
 50  World_end
 51  WorldLen  EQU     World_end-World
 52            FCB     0
 53  ProgramEnd EQU    *
 54  CodeSize  EQU     ProgramEnd-Start
 55            END     Start
