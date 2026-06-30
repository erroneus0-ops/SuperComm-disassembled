# Chapter 3: The Number Guessing Game

Before this book existed, before any of these tools existed for me, there was a
machine called the COMTRAN TEN. The Navy used it to teach digital electronics —
not programming, but the relationship between code and hardware: what each
instruction does to the signals, what the clock coordinates, what you should see
at each test point when things are working and when they are not. The instruction
set was the vocabulary of the machine, not a creative tool.

At some point, within the manual I had the instruction repertoire in front of me
and a serial terminal connected to the machine. I wrote a guessing game. Not
because anyone asked me to — because I could see that I could.

I had no assembler. I wrote it out with labels and symbolic names, the way you
would in assembly language, then resolved the addresses by hand and translated
everything to hex. One pass to write it, one pass to get the addresses right, one
pass to produce the bytes. It worked.

That process — writing symbolic code first, then becoming your own assembler — is
exactly what an assembler program does for you now. The difference is speed and
the absence of arithmetic errors. The process is the same.

---
