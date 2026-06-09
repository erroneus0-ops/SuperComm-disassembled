# Analyst's Guide: Refining Disassembly Output via the JSON Project File

## Overview

The disassembler produces generalized output from the binary alone. The JSON project
file is where the analyst adds program-specific knowledge — meaningful label names,
data region formats, comments, and structural annotations. The disassembler never
modifies the binary interpretation; it only refines how that interpretation is presented.

The pipeline is:

```
binary → disassembler → proj.asm  (generalized output)
                            ↓
                    analyst edits JSON
                            ↓
                binary → disassembler → proj.asm  (refined output)
                            ↓
                    strip_listing.py → clean.asm
                            ↓
                    assembler → binary  (must match original)
```

---

## Case Study: Dat_006F — the SuperComm Splash Screen block

### What the disassembler produces (before analyst work):

```asm
Dat_006F
; Referenced by: $0BCC
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.2"
         ...
         FCC    "Dave Philipsen"

Dat_00C6
...
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                           LBSR WriteBlock
```

### What the analyst knows:

1. `$0BCC` is the entry point of the splash screen display routine
2. The first two bytes (`$00 $55`) are a 16-bit length word — the byte count of the
   display content that follows (not including the length word itself)
3. `$55` = 85 = `Dat_00C6 - Dat_006F - 2` — exactly the display content byte count
4. The length word format is used by `WriteBlock` — a custom display subroutine

### What the analyst wants the output to look like:

```asm
Dat_006F
; Referenced by: ShowSplash
; Splash screen display block — passed to WriteBlock at ShowSplash+$04
         FDB    Dat_00C6-Dat_006F-2  ; byte count of display content (excl. this word)
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.2"
         ...
         FCC    "Dave Philipsen"

Dat_00C6
...
ShowSplash
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                           LBSR WriteBlock
```

---

## JSON Edits Required

Open `supercomm22.json` and make the following additions:

### 1. Name the code label at `$0BCC`

Add to the `"labels"` section:

```json
"labels": {
    "0A71": "Init",
    "0BCC": "ShowSplash"
}
```

**Effect:** "Referenced by: $0BCC" becomes "Referenced by: ShowSplash" in the data
region header. When all callers are named, no raw addresses appear in "Referenced by"
lines.

---

### 2. Declare `Dat_006F` as an analyst-formatted data region

Add to the `"data_regions"` array:

```json
{
    "start": "006F",
    "end":   "00C6",
    "label": "Dat_006F",
    "end_label": true,
    "comment": "Splash screen display block — passed to WriteBlock at ShowSplash+$04\nFirst word is byte count of display content (excl. this word): Dat_00C6-Dat_006F-2",
    "format": "writeblock"
}
```

**Fields explained:**

| Field | Purpose |
|-------|---------|
| `"start"` | Address of first byte of the region (hex, no `$`) |
| `"end"` | Address of first byte AFTER the region — matches the next label |
| `"label"` | Label name to assign. If blank, uses auto-generated name |
| `"end_label": true` | Instructs the disassembler to emit a `Dat_006Fend` label at the end address, enabling `end-start` arithmetic in the source |
| `"comment"` | Block comment emitted above the region. Use `\n` for multiple lines |
| `"format"` | Rendering format. See format options below |

---

### 3. Format options for `"format"`

| Value | Description |
|-------|-------------|
| `"auto"` | Default — disassembler chooses FCC/FCS/FCB/CurXY heuristically |
| `"fdb"` | Emit every 2-byte pair as FDB — used for lookup tables |
| `"raw"` | Emit every byte as FCB $xx — used for binary/non-text data |
| `"writeblock"` | *(to be implemented)* First word as `FDB end-start-2`, remainder as `auto` |

> **Note:** `"writeblock"` format is a program-specific convention for `WriteBlock`
> calls. It is not the same as the OS9 `I$Write` format (which uses the full block
> size including the length word). The analyst declares which regions use it;
> the disassembler cannot auto-detect it from the binary alone.

---

### 4. Add a `line_comment` override for the FDB line

If you want a specific comment on the length word line, add to `"line_comments"`:

```json
"line_comments": {
    "006F": "byte count of display content (excl. this word)"
}
```

**Effect:** The FDB line will read:
```asm
         FDB    Dat_00C6-Dat_006F-2  ; byte count of display content (excl. this word)
```

---

### 5. The `end_label` convention

When `"end_label": true` is set on a data region, the disassembler emits a label
at the end address in the form `<label>end`:

```asm
Dat_006F
         FDB    Dat_006Fend-Dat_006F-2
         ...display content...
Dat_006Fend          ; ← auto-generated when end_label: true
```

This enables self-describing length arithmetic throughout the source. The analyst
never hardcodes a byte count; the assembler always computes the correct value.

**Rule:** Any named data region that has a length word as its first field should
have `"end_label": true` set in the JSON.

---

### 6. The `block_comments` field

For multi-line comments above any address (code or data):

```json
"block_comments": {
    "0BCC": [
        "Display the SuperComm splash screen.",
        "X → Dat_006F (display block), calls WriteBlock to render via I$Write."
    ]
}
```

**Effect:**
```asm
; Display the SuperComm splash screen.
; X → Dat_006F (display block), calls WriteBlock to render via I$Write.
ShowSplash
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC
```

---

## Summary: Full JSON additions for this case

```json
"labels": {
    "0A71": "Init",
    "0BCC": "ShowSplash"
},

"data_regions": [
    {
        "start":     "006F",
        "end":       "00C6",
        "label":     "Dat_006F",
        "end_label": true,
        "comment":   "Splash screen display block — passed to WriteBlock at ShowSplash+$04\nFirst word is byte count of display content (excl. this word): Dat_00C6-Dat_006F-2",
        "format":    "writeblock"
    }
],

"block_comments": {
    "0BCC": [
        "Display the SuperComm splash screen.",
        "X → Dat_006F (display block), calls WriteBlock to render via I$Write."
    ]
},

"line_comments": {
    "006F": "byte count of display content (excl. this word)"
}
```

---

## What still requires analyst judgment

The disassembler cannot determine from the binary alone:

- Whether `$00 $55` is a length word or two independent bytes
- Whether the calling convention is `WriteBlock` vs `I$Write` vs something else
- What a subroutine does (only where it's called from)
- Whether a data region is a splash screen, an error message, or a lookup table

These distinctions live in the JSON. The JSON is the analyst's contribution —
the program-specific layer that transforms a correct disassembly into an
intelligible one.

---

## Implementation note: `end_label` and `writeblock` format

These two features (`end_label: true` and `format: "writeblock"`) are not yet
implemented in the engine. They are the next items for the development backlog.
The tutorial describes the intended interface; the implementation follows.
