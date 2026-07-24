# SuperComm Project Overview — July 2026

## What this project is

A complete disassembly and reconstruction of **SuperComm**, a CoCo communications program. The disassembly work is the anchor, but the project has grown into three interrelated things:

1. **A reference documentation site** — 6809 instruction set reference with HTML pages for every opcode group, light/dark mode, print CSS, indexed addressing postbyte reference
2. **A WASM toolchain** — William Astle's lwasm assembler + toolshed disk tools compiled to WebAssembly, callable from Python via Node.js
3. **A book in progress** — teaching 6809 assembly through the lens of the SuperComm source

---

## Repository structure

```
SuperComm-disassembled/
├── documentation/
│   ├── generate.py          -- generates all HTML from JSON opcodes data
│   ├── opcodes/             -- JSON files, one per instruction group
│   └── html/                -- generated HTML (committed, served via GitHub Pages)
├── wasm/
│   ├── lwasm/               -- lwasm assembler WASM (GREEN)
│   ├── toolshed/            -- toolshed monolith WASM (GREEN, cecb rebuild pending)
│   ├── makewav/             -- makewav cassette tool WASM (GREEN)
│   ├── lst2cmt/             -- listing to MAME comments WASM (GREEN)
│   ├── ar2/                 -- OS-9 archive manager WASM (GREEN)
│   ├── tocgen/              -- Sierra AGI TOC generator WASM (GREEN)
│   └── makewav/reference/   -- reference files: bin2cas.pl, nyan-dragon.wav
├── cocotools_wasm/          -- Python wrappers for all WASM tools
│   ├── lwasm.py             -- assemble .ASM → .BIN
│   ├── toolshed.py          -- DECB/OS9/CECB disk operations
│   ├── makewav.py           -- binary → WAV/CAS cassette
│   ├── lst2cmt.py           -- listing → debugger comments
│   ├── ar2.py               -- OS-9 archive operations
│   └── tocgen.py            -- Sierra AGI TOC
├── .github/workflows/       -- GitHub Actions: one workflow per WASM tool
├── documentation/book/      -- book chapter source files
├── JOURNAL.md               -- project decisions and observations
├── FUTURE.md                -- planned work
├── PROJECT_OVERVIEW.md      -- this file
└── CLAUDE_MANIFESTO.md      -- standing instructions for Claude instances
```

---

## WASM toolchain status

| Tool | Status | Size | Notes |
|------|--------|------|-------|
| lwasm | ✅ GREEN | 167KB | lwtools 4.24/4.25, assembles 6809 |
| toolshed | 🔄 REBUILDING | 103KB | DECB+OS9+CECB monolith, ts_cecb_run being added |
| makewav | ✅ GREEN | 56KB | 9600Hz default, makewav_run_args |
| lst2cmt | ✅ GREEN | 26KB | lwasm listing → MAME/XRoar XML |
| ar2 | ✅ GREEN | 27KB | OS-9 archive manager |
| tocgen | ✅ GREEN | 51KB | Sierra AGI (niche) |

**Toolshed** is currently rebuilding with `ts_cecb_run` — a general-purpose CECB command runner
that passes arguments directly to cecbcopy/cecbbulkerase/cecbdir. The previous approach
reconstructed argv manually and got argument semantics wrong (gap flag, address format).

---

## Proven workflows (end-to-end tested)

**Assemble → DSK → XRoar:**
```
python cocotools_wasm\lwasm.py HELLO.ASM -o HELLO.BIN
python cocotools_wasm\toolshed.py dskini BLANK.DSK
python cocotools_wasm\toolshed.py copy HELLO.BIN BLANK.DSK,HELLO.BIN:0
# Mount BLANK.DSK in XRoar → LOADM"HELLO" → EXEC
```

**Assemble → WAV cassette → XRoar:**
```
python cocotools_wasm\makewav.py -r -n HELLO -o hello.wav HELLO.BIN
# XRoar: load hello.wav as tape → CLOADM"HELLO",&H3F00 → EXEC &H3F00
# Note: HELLO.BIN loads to $0000 (ORG 0) so address override needed
```

**CECB cassette (rebuild pending):**
```
python cocotools_wasm\toolshed.py cecbbulkerase HELLO.CAS
# ts_cecb_run will allow: cecb "copy -2 -n -d0x3F00 -e0x3F00 /in.bin /out.cas,HELLO"
# Data block not writing correctly yet -- ts_cecb_run rebuild in progress
```

---

## Documentation site

**URL:** https://erroneus0-ops.github.io/SuperComm-disassembled/

**Status:** Live, generated from `documentation/generate.py` + JSON opcode files.

**Recent work on indexed addressing postbyte page:**
- `I` symbol (amber) marks bit 4 where indirect mode is available
- Description column first, then bit columns 7-0, then Direct/Indirect examples
- OR derive table: grey headers, orange OR result row, `-` for don't-care bits
- Pointer Register table: individual bit columns, orange bit-7, register column
- Encoding examples table: correct proportions, bytes as single code block
- Light/dark mode auto-switching (`@media prefers-color-scheme`)
- `--pb-tint` CSS variable highlights indexed addressing rows
- Print CSS: headings stay with their tables, no orphaned titles
- Visited link color lighter in dark mode (`--accent-visited`)

---

## Book status

| Chapter | Status | Notes |
|---------|--------|-------|
| ch01 humble beginnings | Draft | HELLO.ASM example, basic load/exec |
| stack return demo | Draft | print_retaddr.bin example at $3F00 |
| postbyte/indexed | Reference page done | Book chapter to follow |
| CC register | Planned | |
| bit-wise math | Planned | "direction costs one bit" framing |
| TFR/EXG activities | Draft | May move location |

**Key book decisions:**
- Postbyte table uses conventional 5/8/16-bit field widths (construction context)
- ±bit notation reserved for bit-math chapter (operational context)
- `[,R+]` and `[,-R]` indirect restriction applies to ALL registers (hardware constraint, not S-specific)
- SWI2 is the OS-9 system call instruction (not SWI or SWI3)
- "direction costs one bit" — key framing for signed offset discussion

---

## Cassette investigation status

- **makewav WAV** — works at 9600Hz (matched from XRoar's own CSAVEM output)
- **CECB CAS** — bulkerase creates correct empty CAS; copy data block not writing yet
- **bin2cas.pl** — Ciaran's perl script in `wasm/makewav/reference/`, multi-segment not supported yet
- **Key finding** — XRoar expects 9600Hz sample rate
- **Ciaran question pending** — cassette timing, WAV format details
- **HELLO.BIN** — loads to $0000 (ORG 0, position-independent), needs address override for cassette
- **print_retaddr.bin** — loads to $3F00, good test binary for cassette

---

## Pending items (see also FUTURE.md)

1. **CECB cassette fix** — ts_cecb_run rebuild pending, test cecb copy with native args
2. **lwcc WASM** — William Astle's own C→6809 compiler (7185 lines), same build pattern as lwasm
3. **lwlink WASM** — linker for multi-file assembly projects
4. **Local Python server** — serve page + file API for local directory mapping
5. **XRoar page integration** — wire lwasm + toolshed into browser workflow
6. **CodeMirror editor** — embedded code editor for browser-based assembly
7. **Virtual filesystem mapping** — NODEFS (Node.js) or File System Access API (browser)
8. **decb.py, os9.py, cecb.py** — individual command wrappers mirroring native tool interface
9. **toolshed version** — ts_version() baked in via -DTOOLSHED_VERSION at build time
10. **PDF layout pass** — when content stable

---

## Standing instructions for next Claude

Read these files in order:
1. `CLAUDE_MANIFESTO.md` — standing instructions and policies
2. `JOURNAL.md` — key decisions and observations
3. `FUTURE.md` — planned work
4. This file — current state

**Key reminders:**
- Always `git pull` before making changes
- `git pull --rebase` before push (all workflows do this now)
- The WASM is truth — Python wrappers are validated against WASM output
- Push back on Daniel's ideas when warranted — it's in the manifesto
- Write things down when they matter — journal and FUTURE.md
- Cassette via DSK is reliable; cassette via tape is Ciaran's domain
- HELLO.BIN ORG 0 — position independent, needs load address override
- print_retaddr.bin at $3F00 — use this for cassette tests
