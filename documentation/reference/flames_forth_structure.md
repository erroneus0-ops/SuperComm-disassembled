# flames.bin — Forth Binary Structure Analysis

## Memory Map (post-relocation)

| Range | Content |
|-------|---------|
| `$0E00-$0E18` | Bootstrap stub (25 bytes) — ORCC, SAM all-RAM, copy kernel, JMP |
| `$0E19-$1D4D` | Forth kernel at load address (copied to $E000 at runtime) |
| `$2000-$247B` | Fire simulation colon definitions (threaded lists) |
| `$E000-$E012` | Primitive word machine code (after relocation) |
| `$E013-$E08x` | Jump table — 66 two-byte entries pointing to word bodies |
| `$E2xx-$E5xx` | Primitive word bodies in 6809 machine code |
| `$E4xx+`      | Hardware access primitives (PIA, keyboard, joystick) |

## Structure

### Bootstrap ($0E00)
```
ORCC #$50           ; disable interrupts
STA $FFDF           ; SAM all-RAM
LDX #$0E19          ; source (kernel load address)
LDY #$E000          ; destination (execution address)
... copy loop ...
JMP $E8C5           ; Forth cold start
```

### Jump Table ($E013)
66 two-byte entries. Each entry is a slot address that the threaded
code uses directly. Each slot contains the address of the primitive
word's machine code body.

```
$E013 -> $E2A3   ; primitive 0
$E015 -> $E2AA   ; primitive 1
$E017 -> $E2B3   ; primitive 2
...
```

### Primitive Word Bodies ($E2xx-$E5xx)
Each primitive is 6809 machine code ending with `JMP [,Y]` (`$6E $B4`).
The JMP [,Y] is the ITC inner interpreter dispatch — it reads the next
word address from the instruction pointer (Y) and dispatches to it.

**No name strings are present in primitive word bodies.** Names exist
only in source code. A Forth decompiler requires the source vocabulary
to annotate jump table entries.

### Fire Simulation ($2000-$247C)
Colon definitions stored as threaded lists of jump table addresses.
Inline literal values appear as raw 2-byte values mixed with addresses.

Example (first few entries at $2000):
```
$2000: $21BE   ; literal value pushed to stack
$2002: $E000   ; jump table slot 0
$2004: $E015   ; jump table slot 1
...
```

## Key Instruction
`JMP [,Y]` (`$6E $B4`) — the Forth ITC inner interpreter.
Appears at the end of every primitive word. Dereferences Y to get
the address of the next word's machine code and jumps to it.

## Decompilation Status
- Jump table: **fully mapped** (66 entries, all targets identified)
- Primitive names: **unknown** (not in binary, need source)
- Fire word bodies: **identified** (35 unique word references)
- Fire word names: **unknown** (not in binary, need source)

## Next Steps
To decompile the fire simulation to Forth source:
1. Obtain Paul Cunningham's Bare Naked Forth source
2. Map jump table slot -> word name from source vocabulary
3. Walk each fire segment threaded list, substituting names for slots
4. Recognize inline literals by address range (non-E0xx values)

## Tools
- `tools/forth_dict_scan.py` — experimental scanner (partial results)
- `documentation/reference/flames_disasm.asm` — full 6809 disassembly
- `wasm/flames.dasm` — working disassembly with analyst markup support
