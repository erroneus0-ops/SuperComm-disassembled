# dis6809_os9 — OS-9 6809/6309 Disassembler
## User Manual and Project File Reference

---

## Overview

The disassembler is a two-file system:

| File | Purpose |
|------|---------|
| `dis6809_os9_engine.py` | Generalized engine — knows 6809/6309 instructions, OS-9 syscalls, windowing. Knows nothing about any specific binary. |
| `dis_project.py` | Driver — loads a project JSON file, runs the engine, writes annotated ASM output. |
| `mymodule.json` | Project file — all binary-specific knowledge. The persistent artifact of your analysis work. |

The workflow is iterative:

```
1. dis_project.py --init mymodule.json   # create scaffold
2. dis_project.py mymodule.json          # first draft output
3. Read output, identify structures       # human analysis
4. Edit mymodule.json                    # add labels, comments, regions
5. dis_project.py mymodule.json          # regenerate with new knowledge
6. Repeat from 3
```

---

## Command Line Usage

```bash
# Generate disassembly
python3 dis_project.py mymodule.json

# Create scaffold project file for a new binary
python3 dis_project.py mymodule.json --init

# Show classification statistics without generating output
python3 dis_project.py mymodule.json --stats

# Pull auto-generated labels into the project file for renaming
python3 dis_project.py mymodule.json --update-labels
```

---

## How the Engine Works

### Pass 1 — Recursive Descent Classification

The engine starts from the declared execution entry point and traces
every reachable code path, recording what each address is used for:

- **`LBSR`/`BSR`/`BRA`/`Bcc`/`JMP`/`JSR` target** → classified `CODE`
- **`LEAX`/`LEAY`/`LEAS`/`LEAU n,PC` target** → classified `DATA`
- **Pre-exec region** (between module name and entry point) → always `DATA`

If an address has both CODE and DATA references, CODE wins (it is a
subroutine whose address is also loaded, common with signal handlers).

**Why recursive descent instead of linear scan:**
A linear scan processes every byte sequentially, including bytes inside
data tables. Table bytes that happen to look like branch instructions
generate false CODE references contaminating the classification.
Recursive descent only processes bytes reachable from actual entry points.

**Cross-references:**
Every data label also records which code addresses point to it via LEA
instructions. These appear in the output as `; Referenced by:` comments.
This is the primary tool for determining a data region's format — go
look at the referencing subroutine and see how it uses the pointer.

### Pass 2 — Span-Based Output

Labels are sorted by address. Each consecutive pair defines a span:

- **DATA span** → emitted as FCB/FDB/FCC/FCS using content heuristics
- **CODE span** → disassembled as instructions

Bytes not reached by any branch/call are unlabeled and fall into the
surrounding span's kind.

### Data Heuristics (auto mode)

Within a DATA span, the engine applies these rules in order:

1. `$0D $0A` after printable ASCII → `FDB $0D0A  ; CRLF`
2. `$1B` followed by known windowing command → decoded ESC sequence
3. `$02 rr cc` → `FCB CurXY,$xx,$xx  ; CurXY(row=N,col=N)`
4. Byte with high bit set and printable low 7 bits → `FCS "x"`
5. Control byte (`< $20`) → named constant (`FCB FF`, `FCB CR`, etc.)
6. Run of same control byte ≥ 3 → grouped (`FCB BS,BS,BS,BS  ; BS×4`)
7. Two or more consecutive printable ASCII bytes → `FCC "string"`
8. Single printable ASCII byte → `FCB $xx  ; 'x'`
9. Other → `FCB $xx`

**The engine cannot automatically detect FORMAT B block structure.**
When you see `FCB $00` followed by `FCB $55 ; 'U'` and the
`; Referenced by:` comment points to a `WriteBlock`-style routine
(one that does `LDY ,X++` then `OS9 I$Write`), those two bytes are
actually `FDB $0055` — a 16-bit count word. Use a `data_regions` entry
with `"format": "fdb"` to override.

---

## Project File Reference

The project file is a JSON document. All fields are optional except
`binary`. Comments are not valid JSON — use `module_notes` for
documentation.

### Top-level structure

```json
{
  "binary":         "path/to/module_binary",
  "output":         "path/to/output.asm",
  "cpu":            "6809",
  "entry":          null,
  "module_notes":   [],
  "custom_equates": [],
  "labels":         {},
  "bss":            {},
  "data_regions":   [],
  "line_comments":  {},
  "block_comments": {}
}
```

---

### `binary` *(string, required)*

Path to the OS-9 module binary file.

```json
"binary": "/home/user/supercomm22"
```

---

### `output` *(string)*

Path for the generated ASM file. Default: `binary + ".asm"`.

```json
"output": "/home/user/supercomm22.asm"
```

---

### `cpu` *(string)*

Target CPU. Controls whether 6309-specific instructions are decoded.

```json
"cpu": "6809"    // default — 6809 only
"cpu": "6309"    // Hitachi HD6309 superset
```

The 6309 is a strict superset of the 6809. All 6809 binaries run
unchanged on a 6309. Set this to `"6309"` only when you know the binary
was compiled specifically for the 6309 (uses W, V, Q registers, TFM,
MULD, DIVQ, bit-manipulation instructions, or native mode via LDMD).

NitrOS-9 itself is 6309-optimized. Most CoCo user programs are 6809.

---

### `entry` *(hex string or null)*

Override the execution entry point read from the module header.
Use when the header is damaged or for non-standard module types.

```json
"entry": "08CD"    // force entry at $08CD
"entry": null      // use header value (default)
```

---

### `module_notes` *(array of strings)*

Free-form notes about the module. Appear in the output file header
as comment lines. Use for author, version history, key design notes,
known bugs, hardware dependencies, etc.

```json
"module_notes": [
  "SuperComm v2.2 — OS-9 Level II terminal program",
  "Author: Dave Philipsen  Copyright (c) 1988, 1989",
  "",
  "Stores all user config directly in the module body.",
  "CrcUpdate ($254E) reseals the module after each change."
]
```

---

### `custom_equates` *(array of strings)*

Additional EQU lines appended after the standard OS-9 equates block.
Use for BSS variable declarations, application-specific constants,
or any equates needed by the assembler.

Each string is emitted as-is on its own line.

```json
"custom_equates": [
  "; ── BSS Variables ──────────────────────",
  "BSS.TermMode  EQU    51   ; terminal mode (28 refs)",
  "BSS.EchoFlag  EQU    70   ; echo on/off",
  "BSS.IoBuf     EQU    6613 ; I/O ring buffer base"
]
```

---

### `labels` *(object: hex_addr → name)*

Named labels for specific addresses. Keys are **4-digit hex strings**
(no `$` prefix). Values are valid assembler label names.

Addresses in the code section are assumed CODE unless they fall within
a declared `data_regions` entry.

```json
"labels": {
  "08CD": "Init",
  "1431": "WriteBlock",
  "0CD5": "SigIntercept",
  "254E": "CrcUpdate",
  "3C0F": "CrcTable"
}
```

**Naming conventions used in this project:**
- Subroutines: `CamelCase` descriptive names (`WriteBlock`, `OpenCommPort`)
- Data tables: `CamelCase` describing content (`BaudMenu`, `CrcTable`)
- Unknown subroutines: `Sub_XXXX` (auto-generated, rename when identified)
- Unknown data: `Dat_XXXX` (auto-generated, rename when identified)
- BSS variables: `BSS.Name` prefix (defined in `bss`, used in `custom_equates`)

**Workflow:** Run `--update-labels` to pull all auto-generated labels
into the JSON. Then rename them one by one as you identify their purpose.

---

### `bss` *(object: decimal_offset → name)*

BSS variable names for U-indexed memory accesses. Keys are **decimal
integers** (not hex). Values are valid assembler names, conventionally
prefixed with `BSS.`.

When a U-indexed instruction like `LDA 51,U` is decoded and offset 51
is in this map, the output becomes `LDA BSS.TermMode,U`.

```json
"bss": {
  "2":    "BSS.ParamStr",
  "6":    "BSS.RxBufPtr",
  "8":    "BSS.TxBufPtr",
  "51":   "BSS.TermMode",
  "3660": "BSS.CommPtr",
  "6613": "BSS.IoBuf"
}
```

**How to identify BSS variables:**
1. Note frequently accessed U-indexed offsets in the output (`LDA 51,U`)
2. Trace what the code does with values at each offset
3. Name based on purpose and add to `bss`
4. Add matching EQU lines to `custom_equates` for assembler compatibility

**Important:** BSS offset 0 is typically the BSS base pointer itself.
On OS-9 entry: U = BSS base, X = parameter string, DP = BSS high byte.

---

### `data_regions` *(array of objects)*

Explicitly declare data regions within the code section. The engine's
auto-classification handles most cases, but some regions need manual
declaration:

- Tables referenced only through computed addresses (not direct LEAX)
- Regions where auto-classification produces incorrect results
- Known FORMAT B blocks where you want FDB count-word formatting

Each entry:

```json
{
  "start":   "3C0F",
  "end":     "3E0F",
  "label":   "CrcTable",
  "comment": "CRC-16/CCITT lookup table — 256 entries × 2 bytes",
  "format":  "fdb"
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `start` | yes | First address of region (hex string) |
| `end` | yes | First address AFTER region (exclusive, hex string) |
| `label` | yes | Label name for the start of the region |
| `comment` | no | Comment line(s) emitted after the label |
| `format` | no | `"auto"` (default), `"fdb"`, or `"raw"` |

**Format values:**

- `"auto"` — SCF/windowing heuristics (FCC for strings, named control bytes, etc.)
- `"fdb"` — every 2 bytes emitted as `FDB $xxxx` — use for numeric word tables (CRC tables, jump tables, timer constants)
- `"raw"` — every byte as `FCB $xx` — use for binary data with no structure

**Identifying FORMAT B regions:**
When `; Referenced by: SubXXXX` points to a routine that does
`LDY ,X++` followed by `OS9 I$Write`, that data region is a
FORMAT B block. The first two bytes are a 16-bit count word.
Declaring the region with `"format": "fdb"` is partially correct
but doesn't decode the structure. Future enhancement: `"format_b"`.

---

### `line_comments` *(object: hex_addr → string)*

Comments added to (or appended to) specific instruction lines.
Keys are hex addresses. Values are comment strings (no leading `;`).

```json
"line_comments": {
  "0F39": "patch baud rate config into module pre-exec data",
  "254E": "recalculate and rewrite module CRC after config change",
  "096E": "register SigIntercept as F$Icpt signal handler"
}
```

If the engine already generates a comment for that instruction (e.g.
an OS9 syscall description), the project comment is appended in
brackets: `; OS9 description  [your comment]`.

**Use cases:**
- Annotate the 25 config-patch sites (`STD ,X`) in SuperComm
- Note which subroutine a specific `LBSR` is calling before it's labeled
- Flag suspicious or interesting instructions during analysis

---

### `block_comments` *(object: hex_addr → array of strings)*

Multi-line comment block emitted **before** the instruction or label
at that address. Each string in the array becomes one comment line.

```json
"block_comments": {
  "08CD": [
    "================================================================",
    "Init — program entry point",
    "On OS-9 entry: U=BSS base  X=param string  DP=BSS high byte",
    "Y=top of memory  S=top of stack  D=user/task IDs",
    "================================================================"
  ],
  "1431": [
    "WriteBlock — write a count-prefixed display block to STDOUT",
    "  LEAX  DataLabel,PC    ; X → FDB count-word / data payload",
    "  LBSR  WriteBlock      ; LDY [X]++  then  OS9 I$Write path=1",
    "106 callers use this entry point."
  ]
}
```

**Use cases:**
- Document subroutine entry points with calling convention
- Explain a complex algorithm before its first instruction
- Mark the boundaries of major functional sections

---

## Analysis Workflow — Step by Step

### Starting a new binary

```bash
# 1. Create minimal project file
echo '{"binary": "mybinary"}' > mybinary.json
python3 dis_project.py mybinary.json --init

# 2. First pass — read the stats
python3 dis_project.py mybinary.json --stats

# 3. Generate first draft
python3 dis_project.py mybinary.json

# 4. Pull auto-labels into JSON for renaming
python3 dis_project.py mybinary.json --update-labels
```

### Reading the output

**Interpreting `; Referenced by:`**
Every data label shows which code addresses point to it. This is your
primary tool for understanding data format:

- Points to a routine doing `LDY ,X++ / OS9 I$Write` → FORMAT B block
  (first 2 bytes = count word, rest = display data)
- Points to a routine doing `LEAY label,PC` then scanning → string table
- Points to `Init` → BSS initialization data or default config
- Multiple callers → shared data table (baud menu, terminal type menu, etc.)

**When auto-classification is wrong**
If you see garbled instructions that look like data (e.g. a `LBRN $5C57`
appearing in what should be a CRC table), the recursive descent found a
false CODE reference. Add a `data_regions` entry to force the correct
classification.

**Renaming labels**
Auto-generated labels follow the pattern `Sub_XXXX` (code) and
`Dat_XXXX` (data). As you identify each one, rename it in the JSON:

```json
"labels": {
  "1431": "WriteBlock",    // was Sub_1431
  "3C0F": "CrcTable"       // was Dat_3C0F
}
```

Regenerate after each meaningful batch of renames.

### Understanding data structures

The most common OS-9 SuperComm data pattern is **FORMAT B**:

```
FDB  $00nn        ; count = nn bytes follow
FCB  ...          ; nn bytes of SCF/windowing data
...
FDB  $0000        ; end of block list (count = 0)
```

The engine emits this as individual FCB lines because it cannot
automatically detect the FORMAT B structure. When you recognize the
pattern (via `; Referenced by:` pointing to a WriteBlock-style caller),
you can note it in a `block_comments` entry and use `"format": "fdb"`
in `data_regions` to at least emit the count words correctly.

### 6309 binaries

If the binary uses 6309 instructions, set `"cpu": "6309"` in the
project file. The engine then attempts 6309 decoding for any opcode
that would otherwise produce `???`.

6309-specific instructions to watch for:
- `TFM R+,R+` — block memory transfer (replaces loops)
- `MULD` / `DIVD` / `DIVQ` — multiply/divide
- `AIM` / `OIM` / `EIM` / `TIM` — direct-page bit manipulation
- `LDW` / `STW` — load/store W register (E:F pair)
- `LDMD #1` — switch to native mode (faster timing)

NitrOS-9 kernel and drivers use 6309 instructions extensively.
Most user-level programs (like SuperComm) are 6809 for compatibility.

---

## OS-9 Module Structure Reference

```
$0000  FDB  $87CD          ; sync bytes
$0002  FDB  module_size    ; total module size including CRC
$0004  FDB  name_offset    ; offset to module name string
$0006  FCB  type           ; module type ($11 = program)
$0007  FCB  language       ; $01=6809 obj, $11=6309 obj, $81=OS9 data
$0008  FCB  attr_parity    ; attributes + header parity byte
$0009  FDB  exec_offset    ; entry point offset from module start
$000B  FDB  bss_size       ; BSS data area size in bytes
$000D  ...                 ; module name (OS-9 FCS, hi-bit terminated)
       ...                 ; pre-exec data region (display data, config)
       ...                 ; code section
       ...                 ; module end
       FCB  crc_hi         ; CRC-24 appended by fixmod (not in source)
       FCB  crc_mid
       FCB  crc_lo
```

**Module name:** OS-9 FCS string starting at `name_offset`. The last
byte has its high bit set. Example: `SuperComm` = `$53 $75 $70 $65 $72
$43 $6F $6D $ED` where `$ED` = `'m' | $80`.

**Pre-exec region:** Everything between the module name end and the
execution entry point is data — display strings, config tables, menus.
It is never executable code.

**BSS:** The OS-9 kernel allocates `bss_size` bytes of zeroed RAM when
the program loads. On entry, U = BSS base address. The program accesses
BSS variables as `offset,U` (indexed from U).

**CRC-24:** The last 3 bytes of the module are the CRC-24, calculated
over bytes $0000 through module_end-3. In source code these bytes are
omitted — the `fixmod` utility (or equivalent Python script) appends them.
SuperComm recalculates and rewrites its own CRC at runtime after patching
config values into the pre-exec data (`CrcUpdate` routine).

---

## Assembling with lwasm

```bash
lwasm --format=raw --output=mybinary.bin mybinary.asm

# Append CRC-24 (required for OS-9 to accept the module)
python3 fixmod.py mybinary.bin

# Compare with original
python3 compare_bins.py mybinary.bin original_binary
```

**Known lwasm compatibility:**
- `FCB`, `FDB`, `FCC`, `FCS`, `FCN` — all supported ✓
- `EQU` — supported ✓  
- `OS9 F$xxx` / `OS9 I$xxx` — supported natively ✓
- `FDB $87CD` for sync bytes — supported ✓
- Labels at column 0, instructions indented — correct format ✓

**Not needed:** `SYNC` directive (was replaced with `FDB $87CD`).

---

## File Summary

| File | Description |
|------|-------------|
| `dis6809_os9_engine.py` | Disassembler engine — do not edit |
| `dis_project.py` | Driver script — do not edit |
| `mymodule.json` | **Your project file — edit this** |
| `mymodule.asm` | Generated output — do not edit (regenerate) |
| `compare_bins.py` | Binary comparison utility |
| `ASSEMBLE.md` | Assembly instructions |

---

*dis6809_os9 — built interactively with Claude (Anthropic), 2026*
*Reference binary: SuperComm v2.1/v2.2/v2.3 by Dave Philipsen (1988–1993)*
