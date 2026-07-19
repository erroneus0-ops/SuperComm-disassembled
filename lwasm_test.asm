; lwasm_test.asm — minimal 6809 test for lwasm compatibility
; Tests: PC-relative LEAX/LEAY, PULS PC (not PCR), branches, OS9

        org     $0000

Start
        leax    DataBlock,pcr       ; PC-relative — should assemble correctly
        leay    DataBlock,pcr       ; PC-relative — should assemble correctly
        lbsr    Sub1
        rts

Sub1
        pshs    u,y,x,a,b
        lda     ,x+
        cmpa    #$0D
        beq     Done
        sta     ,y+
Done
        puls    a,b,x,y,pc          ; PC as register in PULS — NOT pcr

DataBlock
        fdb     DataEnd-DataBlock-2
        fcc     "Hello"
DataEnd

        end     Start
