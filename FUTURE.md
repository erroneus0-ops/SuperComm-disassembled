# Future Work and Open Questions

Items deferred during development. Revisit when the time is right.

---

## cocotools — makedsk disk geometry options

Currently `makedsk` always creates a standard 35-track, single-sided,
double-density RS-DOS image. The `toolshed` `dskini` command supports:

    -3       35 track (default)
    -4       40 track
    -8       80 track
    -h<num>  HDB-DOS drives
    -n<name> HDB-DOS disk name
    -s       "skitzo" disk

These should be exposed via `makedsk` options when disk tooling is expanded.

---

## What is a "skitzo" disk?

The name suggests a disk that implements more than one directory format
simultaneously on the same physical media. Likely used for software that
needed to be accessible from multiple operating systems — for example,
both RS-DOS and OS-9 from the same floppy, or RS-DOS and PC-DOS.
Seen on commercial CoCo software that offered both DECB and OS-9 versions.

Confirm the exact format and document it when OS-9 disk support is added.

---

## cocotools — OS-9 support

Currently not implemented:
- OS-9 module format output (`OUTPUT_OS9`)
- `MOD` / `EMOD` directives
- RBF disk image format

The assembler pipeline has `OUTPUT_OS9` defined and scaffolded in
`lwasm_types.py` but the emit functions and output writer are stubs.

---

## cocotools — makedsk update mode

Currently `makedsk` always creates a blank disk from scratch.
A future `--update` flag could open an existing disk image and
add or replace individual files without disturbing others.

---

## Book — VDG timing tricks and mid-frame mode switching

The VDG's color mode (green vs orange) can be switched mid-frame by
writing to the PIA at precisely timed intervals during the horizontal
blanking period. This allows both color modes to appear on screen
simultaneously in different regions.

Dragonfire (the game) took this to the extreme: switching modes up to
five times per scanline, producing 8 colors on a 4-color mode.
It does not work correctly on the CoCo 3 due to GIME timing differences.

This technique is worth a dedicated chapter or section once the book
covers direct hardware register access and interrupt timing.

---

## Book — Blinking cursor BLINKKY vs custom implementation

`HELLO.ASM` currently uses `JSR BLINKKY` at `$A1B1` for cursor blink
during the wait-for-key loop. This address is ROM-version dependent.

Need to:
1. Test `$A1B1` against all available ROM versions
2. If unstable: implement custom blink using `SYNC` + POLCAT polling loop
3. The custom implementation introduces a fourth loop pattern (interrupt-
   counted) distinct from count-controlled, sentinel-controlled, and
   value-controlled loops already in the program

---

## Book — Animated cursor using VDG semigraphics

VDG values $80-$FF produce semigraphics block patterns rather than text
characters. Cycling through a carefully chosen sequence of these values
produces an animated "slinky" cursor effect — more interesting than a
simple on/off blink.

Example sequence discovered (1-based index as printed, actual VDG value = $7F+index):
  Index:  14,   6,   2,   3,  11,  15,  11,   3,   2,   6
  VDG:  $8D, $85, $81, $82, $8A, $8E, $8A, $82, $81, $85

This would be "fun with this" level 3, building on:
  1. BLINKKY ROM routine (current)
  2. Our own blink using POLCAT + counter toggle
  3. Animated slinky cursor using semigraphics sequence

Also introduces the semigraphics character range ($80-$FF) which has
not appeared in the book yet.

---

## cocotools — makedsk disk image management

Currently makedsk always creates a blank disk from scratch.
Future operations to implement (mirroring DECB.EXE functionality):

  makedsk -a FILE IMAGE.DSK    Add file to existing image; prompt if exists
  makedsk -k FILE IMAGE.DSK    Kill (delete) a file from image (DECB uses KILL)
  makedsk --overwrite          Create/overwrite without prompt (already done)

Reference: translate decb.exe faithfully as was done with lwasm.
This would give us a complete DECB toolchain in Python.

---

## Book -- Slinky cursor: bit manipulation animation

The assembly version of the slinky cursor will NOT use a lookup table.
Instead it will progressively AND/OR bits on the character byte to cycle
through semigraphics patterns and character set transitions.

The character byte encodes both the shape and the color set relationship,
so masking and combining bits produces the animation frames naturally.
No table needed -- the arithmetic drives the animation.

This makes a perfect introduction to AND/OR in a visual context:
each bit operation produces an immediately visible change on screen.
The reader can see exactly what each instruction does.

The BASIC proof-of-concept used:
  DATA 14,6,2,3,11,15,11,3,2,6  (1-based index, VDG = 127+val)
  Actual VDG values: $8D,$85,$81,$82,$8A,$8E,$8A,$82,$81,$85

The assembly version will derive these values through bit operations
rather than storing them in a FCB table.

---

## Housekeeping
- Clean up old/stale project files and folders in the repo (supercomm21, supercomm22-restored, etc.)
- Reconcile analyst_json_tutorial.md and analyst_markup_reference.md into one authoritative document
- Document missing directives in markup reference: /rename-label/, /bss/, /remove-comment/, /remove-line-comment/, /region/
- Ch03 draft not yet started

## 6809 Optimization Techniques (collected from community)

### Keyboard scan loop -- carry flag as state carrier
Source: CoCo Discord #assembly channel

Standard approach (29 cycles/loop): separate COMB/LSLB/BNE for column advance.

Optimized (25 cycles/loop, 3 bytes smaller): COMA sets carry as a side effect
of inverting the keyboard read. ROL on the memory-mapped PIA register pulls
that carry bit in directly as the next column strobe -- no separate shift
register needed. The carry flag carries state between two unrelated
operations for free.

```asm
        lda     #%11111110      ; start reading column 0
        sta     PIA0SideBDataRegister_FF02

loop    lda     PIA0SideADataRegister_FF00
        ora     #%10000000
        coma                    ; sets carry as side effect
        sta     ,x+             ; doesn't affect carry
        rol     PIA0SideBDataRegister_FF02
        bcs     loop            ; if carry set, not done
```

Worth a "tricks and idioms" reference section later, possibly its own
chapter or appendix once the core teaching chapters are done.
