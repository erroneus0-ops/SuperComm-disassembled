# Analyst's Guide: Annotating a Disassembly

## Overview

The disassembler produces generalized output from the binary alone. The analyst
refines that output by adding directives directly to the `appname_proj.asm` file.
When ready, a script reads those directives and updates the project JSON. The next
disassembly run reflects all changes.

The analyst never edits the JSON file directly.

---

## The workflow

**First run** (no JSON exists yet):

```
python3 dis_project.py appname

→ JSON not found — scaffold created automatically (appname_proj.json)
→ Binary CRC recorded in JSON
→ Disassembly runs immediately
→ appname_proj.asm written
```

**Work stage** (repeat as needed):

```
appname_proj.json + binary
        ↓
    dis_project.py          ← verifies binary CRC matches JSON
        ↓
appname_proj.asm            ← analyst adds directives here
        ↓
edits_to_json.py            ← reads directives, updates appname_proj.json
        ↓
    repeat
```

**If the binary changes** (e.g. a patched or restored version):

```
dis_project.py detects CRC mismatch and offers:
  [1] Create new JSON importing analyst work — labels, comments,
      routines carry over; binary-specific workarounds do not
  [2] Proceed anyway
  [3] Abort
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

---

## Appendix: Editing the JSON directly — removal and reset

There are situations where the analyst may need to open the JSON and remove
entries manually:

- A directive produced unexpected output and the analyst wants to start over
- Two directives conflict and the disassembler is producing confusing results
- A label rename created a cascade of unwanted sub-label renames
- A routine boundary was declared incorrectly and interior labels need resetting

**The rule is simple: removing a JSON entry returns that address to default
disassembler behavior on the next run.** Nothing is permanently lost — the
binary is always the ground truth, and the disassembler can regenerate from it.

---

### JSON file structure

The file is standard JSON. Open it in any text editor. The top-level structure:

```json
{
  "binary":          "path/to/binary",
  "output":          "path/to/output.asm",
  "cpu":             "6809",
  "module_notes":    [],
  "labels":          {},
  "bss":             {},
  "data_regions":    [],
  "line_comments":   {},
  "block_comments":  {},
  "substitutions":   {},
  "routines":        [],
  "custom_equates":  [],
  "forced_equs":     {},
  "patches":         {}
}
```

---

### `labels` — remove a name assignment

```json
"labels": {
    "0A71": "Init",
    "0BCC": "ShowSplash"
}
```

To remove `ShowSplash` and return `$0BCC` to its auto-generated name (`Sub_0BCC`),
delete the `"0BCC"` entry:

```json
"labels": {
    "0A71": "Init"
}
```

**Note:** If `ShowSplash` was used as a routine name, removing it here does not
remove the routine boundary from `routines`. Remove that separately.

---

### `block_comments` — remove a block comment

```json
"block_comments": {
    "0BCC": [
        "Displays the SuperComm splash screen.",
        "Part of Init."
    ]
}
```

Delete the `"0BCC"` entry to remove the comment. The address will have no
block comment above it on the next run.

---

### `line_comments` — remove an inline comment override

```json
"line_comments": {
    "0BCC": "load splash block into X"
}
```

Delete the `"0BCC"` entry. The disassembler will regenerate its default
inline comment for that instruction.

---

### `substitutions` — remove a content substitution

```json
"substitutions": {
    "006F": {
        "replace_lines": ["         FCB    $00", "         FCB    $55"],
        "with": ["         FDB    Dat_006Fend-Dat_006F-2  ; byte count"]
    }
}
```

Delete the `"006F"` entry. The disassembler will emit its default output
for those bytes — typically `FCB $00` / `FCB $55` or whatever the auto
heuristic produces.

---

### `data_regions` — remove or reset a region declaration

```json
"data_regions": [
    {
        "start":     "006F",
        "end":       "00C6",
        "label":     "Dat_006F",
        "format":    "writeblock",
        "end_label": true,
        "comment":   "Splash screen display block."
    }
]
```

`data_regions` is a list. To remove the entire declaration, delete the
`{...}` object from the list.

To reset only part of it — for example, revert the format to auto while
keeping the comment — edit just that field:

```json
{
    "start":   "006F",
    "end":     "00C6",
    "label":   "Dat_006F",
    "format":  "auto",
    "comment": "Splash screen display block."
}
```

Removing `"end_label"` or setting it to `false` stops the `Dat_006Fend`
label from being emitted.

---

### `routines` — remove a routine boundary

```json
"routines": [
    {
        "name":  "Init",
        "start": "0A71",
        "end":   "0BFF"
    }
]
```

Delete the `{...}` object from the list. The interior labels that were
auto-named `Init_01`, `Init_02` etc. will revert to `Sub_XXXX` on the
next run — **unless** they were also added to `labels` individually, in
which case those entries survive independently and must be removed from
`labels` separately if a full reset is desired.

---

### `forced_equs` — overlap workarounds

```json
"forced_equs": {
    "0B8D": "mid-instruction entry point — byte 2 of OS9 I$Close"
}
```

These are generated by the disassembler when it encounters a branch target
that lands inside an existing instruction. They should generally not be
removed unless the binary itself has been corrected (as with the restored
v2.2 binary). Removing one without fixing the underlying binary will cause
the disassembler to fail or produce incorrect output at that address.

---

### General safety rules when editing the JSON

1. **Always make a backup** before editing — copy the JSON to
   `appname_proj.json.bak` before opening it.

2. **Valid JSON only** — a syntax error in the JSON will prevent the
   disassembler from running. Use a JSON validator if unsure.
   Common mistakes: trailing commas, unmatched brackets, unescaped
   quotes in strings.

3. **Hex addresses are strings** — all addresses are stored as 4-character
   uppercase hex strings: `"0BCC"` not `0BCC` or `$0BCC` or `3020`.

4. **Regenerate after every edit** — run `dis_project.py` after any JSON
   change to confirm the output is what you expected before continuing.

5. **The binary is always the ground truth** — no JSON edit can corrupt
   the binary or the disassembler. The worst outcome is unexpected output
   in the proj.asm, which is corrected by fixing the JSON and regenerating.
