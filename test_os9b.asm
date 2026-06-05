I$Close  EQU   $8F

         ORG   $0B8C
Insn_test
         OS9   I$Close
TestEQU  EQU   Insn_test+1
         CLR   $72,U