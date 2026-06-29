# Analyst Markup Reference — Working Examples

All directives begin with `/` in column 1. They are consumed by `markup.py`
and stored in the project JSON. The disassembler applies them on the next run.
The stripped clean.asm never contains directives.

---

## 1. `/label/` — Assign a meaningful name to an address

### Disassembler output (before):
```
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                           LBSR WriteBlock
```

### With markup:
```
/label/ ShowSplash
$0BCC  30 8D F4 9F                        LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                           LBSR WriteBlock
```

### Expected outcome (after disassembler regeneration):
```
ShowSplash
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC       ; X → Dat_006F
$0BD0  17 0F 30                      LBSR WriteBlock
```
All other references to `$0BCC` in the listing — branch targets, "Referenced by"
comments — will also read `ShowSplash`.

---

## 2. `/comment/` `/end-comment/` — Block comment above an address

### Disassembler output (before):
```
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC
$0BD0  17 0F 30                      LBSR WriteBlock
```

### With markup:
```
/comment/
Displays the SuperComm splash screen.
Part of Init — loads Dat_006F into X then calls WriteBlock.
/end-comment/
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC
$0BD0  17 0F 30                      LBSR WriteBlock
```

### Expected outcome:
```
; Displays the SuperComm splash screen.
; Part of Init — loads Dat_006F into X then calls WriteBlock.
ShowSplash
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC
$0BD0  17 0F 30                      LBSR WriteBlock
```

---

## 3. `/; comment/` — Override inline comment on a listing line

### Disassembler output (before):
```
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC       ; X → Dat_006F
```

### With markup:
```
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC  /; load splash block into X/
```

### Expected outcome:
```
$0BCC  30 8D F4 9F    ShowSplash:    LEAX Dat_006F,PC       ; load splash block into X
```
Replaces the auto-generated comment with the analyst's text.

---

## 4. `/replace/` `/with/` `/end-replace/` — Substitute disassembler output

The byte count of the `/replace/` block and the `/with/` block must match.
A mismatch is detected and the substitution is rejected with a warning.

### Disassembler output (before):
```
Dat_006F
; Referenced by: $0BCC
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
         FCB    $0C               ; FF clear+home
         FCC    "Hello World"
```

### With markup:
```
Dat_006F
; Referenced by: $0BCC
/replace/
         FCB    $00               ; NUL
         FCB    $55               ; 'U'
/with/
         FDB    Dat_006Fend-Dat_006F-2  ; byte count of display content
/end-replace/
         FCB    $0C               ; FF clear+home
         FCC    "Hello World"
```

### Expected outcome:
```
Dat_006F
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2  ; byte count of display content
         FCB    $0C               ; FF clear+home
         FCC    "Hello World"
```
The two `FCB` lines ($00, $55 = 2 bytes) are replaced by a single `FDB`
(also 2 bytes). Assembles to identical binary.

---

## 5. `/end-label/` — Emit a `<label>end` marker at this position

Placed after the last line of a data block. The engine emits `<label>end`
at the boundary between this block and the next label. No address resolution
needed — the engine uses the natural span boundary.

### Disassembler output (before):
```
Dat_006F
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2  ; byte count
         FCB    $0C               ; FF clear+home
         FCC    "Hello World"

Dat_00C6
```

### With markup:
```
Dat_006F
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2  ; byte count
         FCB    $0C               ; FF clear+home
         FCC    "Hello World"
/end-label/

Dat_00C6
```

### Expected outcome:
```
Dat_006F
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2  ; byte count
         FCB    $0C               ; FF clear+home
         FCC    "Hello World"
Dat_006Fend

Dat_00C6
```
`Dat_006Fend` is now a valid label. `Dat_006Fend-Dat_006F-2` assembles
to the correct byte count of the display content.

---

## 6. `/format/` — Set rendering format for a data region

Must appear immediately after the data region's label line.

### Disassembler output (before):
```
CrcTable
; Referenced by: $2BC0
         FCB    $10,$21,$00,$00,$20,$42,$00,$00
         FCB    $40,$84,$00,$00,$81,$08,$00,$00
         ...
```

### With markup:
```
CrcTable
/format/ fdb 8
; Referenced by: $2BC0
         FCB    $10,$21,$00,$00 ...
```

### Expected outcome:
```
CrcTable
; Referenced by: $2BC0
         FDB    $1021,$0000,$2042,$3063,$4084,$50A5,$60C6,$70E7
         FDB    $8108,$9129,$A14A,$B16B,$C18C,$D1AD,$E1CE,$F1EF
         ...
```

### Hexdump example:
```
MysteryData
/format/ hexdump
```

### Expected outcome:
```
MysteryData
; Referenced by: Sub_1234
         FDB    $87CD,$45C5,$000D,$1181,$A80A,$7120,$0053,$7570   ; ..E.....q .Sup
         FDB    $6572,$436F,$6DED,$0150,$526F,$6772,$616D,$2062   ; erCom..Program b
         ...
```

### Text format example:
```
HelpText
/format/ text
```

### Expected outcome:
```
HelpText
; Referenced by: Sub_024C
         FCB    $0A ; LF
         FCC    "dir [-opts] [path/patt] [-opts]"
         FCB    $0D ; CR
         FCC    "opts: x - use current exec dir"
         FCB    $0D ; CR
         FCC    "      s - one entry/line"
         FCB    $0D ; CR
```

Known formats:
- `auto`       — default heuristics (FCC strings, FCS keyword tables, CurXY, etc.)
- `fdb`        — every 2 bytes as FDB (lookup tables, word arrays)
- `fdb N`      — every 2 bytes as FDB, N entries per line (e.g. `fdb 8`)
- `raw`        — every byte as FCB $xx (binary data, no interpretation)
- `hexdump`    — FDB pairs, 8 per line, with ASCII comment column (like hexdump output)
- `hexdump N`  — hexdump with N FDB entries per line (e.g. `hexdump 4`)
- `writeblock` — first word as self-describing FDB length, remainder as auto
- `text`       — printable ASCII runs as FCC strings, control/non-printable bytes as FCB

**Notes:**
- `fdb` and `hexdump` emit a plain `FCB` for an odd trailing byte, with a console
  warning from `markup.py` if the region size is odd.
- `hexdump` ASCII column shows printable characters as-is, dots for non-printable.
  No FCS high-bit translation.
- `text` is the right choice for human-readable string data: help text, error messages,
  display templates. Emits `FCC "string"` for each printable run, `FCB $0D ; CR` etc.
  for control bytes. Double-quote characters in the string are emitted as `FCB $22`.

---

## 7. `/region-comment/` `/end-region-comment/` — Descriptive comment for a data region

Must appear immediately after the data region's label line.

### Disassembler output (before):
```
Dat_006F
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2
         FCB    $0C
         FCC    "Hello World"
Dat_006Fend
```

### With markup:
```
Dat_006F
/region-comment/
Splash screen display block — passed to WriteBlock.
First word is byte count of display content (excl. this word).
/end-region-comment/
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2
```

### Expected outcome:
```
Dat_006F
; Splash screen display block — passed to WriteBlock.
; First word is byte count of display content (excl. this word).
; Referenced by: $0BCC
         FDB    Dat_006Fend-Dat_006F-2
```

---

## 8. `/routine/` `/routine-end/` — Declare a routine boundary

Assigns a name to the routine entry point and renames all anonymous
auto-generated labels within the boundary to `RoutineName_01`,
`RoutineName_02`, etc. in address order. Analyst-assigned labels
are left untouched.

**`/routine/`** — place immediately before the first instruction.
**`/routine-end/`** — place immediately after the last instruction.

### Disassembler output (before):
```
$0C2A  10 8E 00 01         Sub_0C2A:      LDY #$0001
$0C2E  A6 80               Sub_0C2E:      LDA ,X+
$0C30  27 06                              BEQ Sub_0C38
$0C32  A7 A0                              STA ,Y+
$0C34  31 1F                              LEAY -1,Y
$0C36  20 F6                              BRA Sub_0C2E
$0C38  39                  Sub_0C38:      RTS
```

### With markup:
```
/routine/ CopyString
$0C2A  10 8E 00 01         Sub_0C2A:      LDY #$0001
$0C2E  A6 80               Sub_0C2E:      LDA ,X+
$0C30  27 06                              BEQ Sub_0C38
$0C32  A7 A0                              STA ,Y+
$0C34  31 1F                              LEAY -1,Y
$0C36  20 F6                              BRA Sub_0C2E
$0C38  39                  Sub_0C38:      RTS
/routine-end/ CopyString
```

### Expected outcome:
```
CopyString
$0C2A  10 8E 00 01    CopyString:    LDY #$0001
$0C2E  A6 80          CopyString_01: LDA ,X+
$0C30  27 06                         BEQ CopyString_02
$0C32  A7 A0                         STA ,Y+
$0C34  31 1F                         LEAY -1,Y
$0C36  20 F6                         BRA CopyString_01
$0C38  39             CopyString_02: RTS
CopyStringend
```
Anonymous `Sub_XXXX` labels renamed to `CopyString_01`, `CopyString_02`.
All branch references updated throughout the listing.

---

## Command sequence reminder

```
; 1. Add directives to proj.asm and save
; 2. Process directives into JSON:
python markup.py appname_proj.asm appname_proj.json

; 3. Regenerate disassembly:
python dis6x09.py --source appname --proj appname_proj.json

; 4. When ready to test assembly (product stage):
python strip_listing.py appname_proj.asm appname_clean.asm
python asm6809.py appname_clean.asm appname_assembled.bin
python compare_bins.py appname appname_assembled.bin
```
