# cocotools

A Python toolkit for writing, assembling, and packaging 6809 assembly programs
for the TRS-80 Color Computer. No external dependencies. Python 3.8 or later.

---

## What It Does

`cocotools` covers the workflow from source file to something you can load into
an emulator or transfer to real hardware:

1. **Assemble** a `.ASM` source file into a binary
2. **Inspect** a DECB `.BIN` file to see its load address, size, and exec address
3. **Package** binaries and other files into a CoCo-format `.DSK` disk image
4. **List** the contents of an existing `.DSK` image

### Current limitations

Output formats are currently limited to **DECB** (Color BASIC binary, `.BIN`)
and **raw** (flat binary, no header). OS-9 module format is not yet supported.
Disk images use the standard 35-track, single-sided, double-density format
that RS-DOS understands. RBF (OS-9 disk format) is not yet supported.

---

## Installation

No installation needed. Clone the repository and run from the root:

```
git clone https://github.com/erroneus0-ops/SuperComm-disassembled
cd SuperComm-disassembled
python cocotools.py --help
```

---

## Commands

### assemble

Assemble a 6809 source file.

```
python cocotools.py assemble SOURCE.ASM
python cocotools.py assemble SOURCE.ASM -o OUTPUT.BIN
python cocotools.py assemble SOURCE.ASM --format raw -o OUTPUT.BIN
```

The default output filename is the source filename with `.BIN` extension.
The default format is `decb` — a DECB binary with preamble and postamble
headers that Color BASIC's `LOADM` command understands.

Use `--format raw` for a flat binary with no headers, useful when you need
the code at a known address without any wrapper.

**Example output:**

```
  assembled: HELLO.ASM
  output:    HELLO.BIN  (85 bytes)
  segment:   load=$3F00  size=75 bytes
  exec:      $3F00
```

The assembler supports all 6809 instructions and the common directives:

| Directive | Purpose |
|-----------|---------|
| `ORG`     | Set assembly address |
| `EQU`     | Define a named constant |
| `FCB`     | Form constant byte(s) |
| `FDB`     | Form constant word(s) (16-bit) |
| `FCC`     | Form character string |
| `RMB`     | Reserve memory bytes |
| `SETDP`   | Set direct page register value |
| `INCLUDE` | Include another source file |
| `END`     | End of assembly, optionally with exec address |

---

### binfo

Inspect a DECB `.BIN` file.

```
python cocotools.py binfo FILE.BIN
python cocotools.py binfo FILE.BIN --hex
```

Shows the load address, byte count, and exec address of each segment in the
file. Use `--hex` for a full hex dump of the code.

**Example output:**

```
DECB binary: HELLO.BIN  (85 bytes total)
  segment 1: load=$3F00  size=75  end=$3F4A
  exec:       $3F00
```

**With --hex:**

```
DECB binary: HELLO.BIN  (85 bytes total)
  segment 1: load=$3F00  size=75  end=$3F4A
  exec:       $3F00

  [3F00]
    3F00  BD A9 28 8E 04 EA 31 8D  00 37 C6 06 A6 A0 81 20  ..(...1..7......
    3F10  27 06 84 3F 8A 40 20 02  86 20 A7 80 5A 26 EF CC  '..?.@ .. ..Z&..
    ...
```

---

### makedsk

Build a CoCo RS-DOS `.DSK` image from one or more files.

```
python cocotools.py makedsk OUTPUT.DSK FILE1.BIN FILE2.BAS
python cocotools.py makedsk GAME.DSK GAME.BIN LOADER.BAS README.TXT
```

Files are added to a blank 35-track RS-DOS disk image. The CoCo filename is
taken from the source filename (uppercase, truncated to 8 characters). The
file type is inferred from the extension:

| Extension | CoCo type |
|-----------|-----------|
| `.BIN`    | Machine language (ML) |
| `.BAS`    | BASIC |
| `.DAT`    | Data |
| `.TXT`    | Text |

**Example output:**

```
  added: HELLO.BIN  (85 bytes, type=2)
  added: LOADER.BAS  (512 bytes, type=0)
  written: GAME.DSK  (161280 bytes)
```

Load the resulting `.DSK` file into XRoar or another CoCo emulator. In
Color BASIC, use `LOADM"HELLO"` to load a machine language binary, or
`LOAD"LOADER"` to load a BASIC program.

---

### dskls

List the files in an existing `.DSK` image.

```
python cocotools.py dskls IMAGE.DSK
```

**Example output:**

```
IMAGE.DSK:
  NAME      EXT  TYPE   SIZE
  HELLO     BIN  ML     85
  LOADER    BAS  BASIC  512
```

---

## Typical Workflow

```
# 1. Write your program
#    (edit HELLO.ASM in your text editor)

# 2. Assemble it
python cocotools.py assemble HELLO.ASM

# 3. Check what was produced
python cocotools.py binfo HELLO.BIN

# 4. Package it onto a disk image
python cocotools.py makedsk HELLO.DSK HELLO.BIN

# 5. Load the disk image into XRoar and run it
#    LOADM"HELLO":EXEC
```

---

## DECB Binary Format

A DECB `.BIN` file contains one or more segments, each with a 5-byte preamble,
followed by a 5-byte postamble at the end:

```
Preamble (per segment):
  $00          marker
  hi(len)      length of this segment, high byte
  lo(len)      length of this segment, low byte
  hi(addr)     load address, high byte
  lo(addr)     load address, low byte
  [data...]    the code or data bytes

Postamble:
  $FF          marker
  $00 $00      always zero
  hi(exec)     exec address, high byte
  lo(exec)     exec address, low byte
```

This is the format Color BASIC's `LOADM` command expects, and what XRoar
loads when you use its file menu.

---

## OS-9 Support

Not yet implemented. OS-9 module format output, the `MOD`/`EMOD` directives,
and RBF disk image support are planned for a future release.

---

## Source and License

Part of the SuperComm disassembly and CoCo book project.
https://github.com/erroneus0-ops/SuperComm-disassembled

The assembler pipeline is a faithful Python translation of lwasm from the
LWTools suite by William Astle, used under GPL v3.
http://lwtools.projects.l-w.ca/
