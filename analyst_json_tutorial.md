# Analyst's Guide: Annotating a Disassembly

## Overview

The disassembler produces generalized output from the binary alone. The analyst
refines that output by adding directives directly to the `appname_proj.asm` file.
When ready, a script reads those directives and updates the project JSON. The next
disassembly run reflects all changes.

The analyst never edits the JSON file directly.

---

## The workflow

**Work stage** (repeat as needed):

```
binary + appname_proj.json
        ↓
    disassembler
        ↓
appname_proj.asm          ← analyst adds directives here
        ↓
edits_to_json.py          ← reads directives, updates appname_proj.json
        ↓
    repeat
```

**Product stage** (when satisfied):

```
appname_proj.asm
        ↓
strip_listing.py → appname_clean.asm
        ↓
assembler → appname_assembled.bin
        ↓
compare_bins.py ← original binary   (must match)
```

---

## Directive syntax

All directives begin with `/` in column 1. They are invisible to the assembler —
`strip_listing.py` removes them before assembly. Directives remain in the proj.asm
until the analyst regenerates from the disassembler, at which point they are
replaced by the clean output that the updated JSON now drives.

---

### Assign a label

```
/label/ ShowSplash
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC
```

Assigns the name `ShowSplash` to address `$0BCC`. All references to that address
throughout the listing — branch targets, "Referenced by" comments, LEAX targets —
will use `ShowSplash` on the next disassembly run.

Applying `/label/` to an address that already has a name replaces it. All
references update automatically.

---

### Add a block comment

```
/comment/
Displays the SuperComm splash screen.
Part of Init — loads Dat_006F into X then calls WriteBlock.
/end-comment/
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC
```

Adds comment lines above the address on the next disassembly run.

---

### Override an inline comment

```
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC  /; load splash block into X/
```

The `/; ... /` at the end of a listing line replaces the auto-generated inline
comment for that address.

---

### Substitute disassembler output

Replaces one or more lines of disassembler output with analyst-supplied content:

```
Dat_006F
; Referenced by: $0BCC
/replace/
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
/with/
         FDB    Dat_006Fend-Dat_006F-2  ; byte count of display content (excl. this word)
/end-replace/
         FCB    $0C               ; FF clear+home
         ...
```

The `/replace/` block contains the exact lines as the disassembler produced them.
The `/with/` block contains the analyst's replacement. The script records the
substitution in the JSON; the disassembler applies it on future runs.

---

### Mark a data region end

```
         FCC    "Dave Philipsen"
/end-label/

Dat_00C6
```

The `/end-label/` directive marks the current position as the end of the preceding
named data region. On future disassembly runs a `Dat_006Fend` label is emitted at
this address, enabling length arithmetic such as `Dat_006Fend-Dat_006F-2`.

Place `/end-label/` after the last line of the data block, before the next label.

---

### Declare a data region format

```
Dat_006F
/format/ writeblock
```

Sets the rendering format for the named data region immediately above. Known
formats: `auto`, `fdb`, `raw`, `writeblock`, `iwrite`.

---

### Add a data region comment

```
Dat_006F
/region-comment/
Splash screen display block — passed to WriteBlock.
First word is byte count of display content (excl. this word).
/end-region-comment/
```

Adds a descriptive comment block above the data region on future disassembly runs.

---

### Declare a routine boundary

```
/routine/ Init
$0A71  9F 00                              STX <$00
         ...
$0BFF  39                                 RTS
/routine-end/ Init
```

**`/routine/`** — place immediately before the first instruction of the routine.
Assigns `Init` as the label for that address.

**`/routine-end/`** — place immediately after the last instruction of the routine.
The last instruction may be `RTS`, `PULS ...,PC`, a tail-call `LBRA`, or any other
exit form — the analyst decides, not the script.

**Effect:** All anonymous auto-generated labels (`Sub_XXXX`, `Dat_XXXX`) within
the routine boundary are renamed `Init_01`, `Init_02`, etc. in address order.
Analyst-assigned labels within the range are left untouched.

A `Initend` label is emitted at the `/routine-end/` address.

---

## Running the script

```
python3 edits_to_json.py appname_proj.asm
```

The JSON file is inferred from the ASM filename. Or specify it explicitly:

```
python3 edits_to_json.py appname_proj.asm appname_proj.json
```

The script is safe to run multiple times. Applying the same directive twice
updates the JSON entry rather than duplicating it.

After running the script, regenerate the disassembly to see the changes:

```
python3 dis_project.py appname_proj.json
```

---

## A complete example

Starting from this disassembler output:

```asm
Dat_006F
; Referenced by: $0BCC
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.2"
         FCB    CurXY,$24,$23     ; CurXY(row=4,col=3)
         FCC    "Copyright (c)"
         FCB    CurXY,$23,$24     ; CurXY(row=3,col=4)
         FCC    "1988, 1989, 1992"
         FCB    CurXY,$26,$26     ; CurXY(row=6,col=6)
         FCC    "written by"
         FCB    CurXY,$24,$27     ; CurXY(row=4,col=7)
         FCC    "Dave Philipsen"

Dat_00C6
...
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                           LBSR WriteBlock
```

The analyst adds directives:

```asm
Dat_006F
; Referenced by: $0BCC
/region-comment/
Splash screen display block — passed to WriteBlock.
First word is byte count of display content, not including itself.
/end-region-comment/
/replace/
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
/with/
         FDB    Dat_006Fend-Dat_006F-2  ; byte count of display content
/end-replace/
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.2"
         FCB    CurXY,$24,$23     ; CurXY(row=4,col=3)
         FCC    "Copyright (c)"
         FCB    CurXY,$23,$24     ; CurXY(row=3,col=4)
         FCC    "1988, 1989, 1992"
         FCB    CurXY,$26,$26     ; CurXY(row=6,col=6)
         FCC    "written by"
         FCB    CurXY,$24,$27     ; CurXY(row=4,col=7)
         FCC    "Dave Philipsen"
/end-label/

Dat_00C6
...
/label/ ShowSplash
/comment/
Part of Init. Displays the SuperComm splash screen.
X is loaded with the Dat_006F display block, then WriteBlock is called.
/end-comment/
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC  /; load splash block into X/
$0BD0  17 0F 30                           LBSR WriteBlock
```

Run the script:

```
python3 edits_to_json.py supercomm22_proj.asm
```

Regenerate:

```
python3 dis_project.py supercomm22_proj.json
```

The next disassembly run produces:

```asm
Dat_006F
; Referenced by: ShowSplash
; Splash screen display block — passed to WriteBlock.
; First word is byte count of display content, not including itself.
         FDB    Dat_006Fend-Dat_006F-2  ; byte count of display content
         FCB    $0C               ; FF clear+home
         FCB    CurXY,$23,$21     ; CurXY(row=3,col=1)
         FCC    "SuperComm   v2.2"
         ...
         FCC    "Dave Philipsen"
Dat_006Fend

Dat_00C6
...
; Part of Init. Displays the SuperComm splash screen.
; X is loaded with the Dat_006F display block, then WriteBlock is called.
ShowSplash
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC       ; load splash block into X
$0BD0  17 0F 30                      LBSR WriteBlock
```

---

## Appendix: JSON field reference

The following fields in `appname_proj.json` are managed by `edits_to_json.py`.
This is provided for reference only — the analyst does not edit these directly.

| Field | Type | Purpose |
|-------|------|---------|
| `labels` | `{"HHHH": "Name"}` | Address-to-name mappings |
| `block_comments` | `{"HHHH": ["line1","line2"]}` | Comments above an address |
| `line_comments` | `{"HHHH": "text"}` | Inline comment override |
| `substitutions` | `{"HHHH": {replace_lines, with}}` | Output substitutions |
| `data_regions` | `[{start, end, label, format, comment, end_label}]` | Data region declarations |
| `routines` | `[{name, start, end}]` | Routine boundary declarations |
