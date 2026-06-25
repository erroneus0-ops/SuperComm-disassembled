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
