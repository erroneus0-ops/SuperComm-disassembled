#!/usr/bin/env python3
"""
Assemble Hello World 6809 program and create a CoCo DSK image.
The binary is position-independent code suitable for VARPTR loading.
"""

# ================================================================
# Hand-assemble the Hello World program
# PIC — assembled at base 0, will run wherever BASIC puts it
# ================================================================

# ROM addresses
POLCAT = 0xA000
CHROUT = 0xA002
CLRSCR = 0xA928
CURPOS = 0x88       # direct page cursor position register

# Screen layout
SCREEN   = 0x0400
COLS     = 32
HELLO_ROW = 7
HELLO_COL = 10
WORLD_ROW = 7
WORLD_COL = 16
EXIT_ROW  = 13
EXIT_COL  = 0

HELLO_POS = SCREEN + (HELLO_ROW * COLS) + HELLO_COL   # $04EA
WORLD_POS = SCREEN + (WORLD_ROW * COLS) + WORLD_COL   # $04F0
EXIT_POS  = SCREEN + (EXIT_ROW  * COLS) + EXIT_COL    # $0560

code = bytearray()

def b(*args):
    for a in args:
        code.append(a & 0xFF)

def w(val):
    code.append((val >> 8) & 0xFF)
    code.append(val & 0xFF)

def s8(val):
    """Signed 8-bit offset"""
    if val < 0: val += 256
    return val & 0xFF

# We'll use forward reference patching
patches = {}  # name -> (patch_offset, instr_end)
labels  = {}  # name -> offset

def here():
    return len(code)

def patch_all():
    for name, (patch_off, instr_end) in patches.items():
        if name not in labels:
            raise ValueError(f"Unresolved label: {name}")
        target = labels[name]
        rel = target - instr_end
        if -128 <= rel <= 127:
            code[patch_off] = s8(rel)
        else:
            raise ValueError(f"Branch out of range to {name}: {rel}")

# ── Start ────────────────────────────────────────────────────
labels['Start'] = here()

# JSR CLRSCR  -- $BD xxxx  (extended JSR)
b(0xBD); w(CLRSCR)

# ── Write "HELLO " inverted to screen memory ─────────────────
# LDX #HELLO_POS
b(0x8E); w(HELLO_POS)

# LEAY Hello,PCR
# We need to know offset to Hello data — forward ref, patch later
b(0x31, 0x8D)  # LEAY offset16,PCR
patches['leay_hello'] = (here(), here() + 2)
w(0x0000)  # placeholder

# LDB #6
b(0xC6, 6)

# WriteHello:
labels['WriteHello'] = here()

# LDA ,Y+
b(0xA6, 0xA0)

# CMPA #$20  (space?)
b(0x81, 0x20)

# BEQ WriteSpace
b(0x27)
patches['beq_writespace'] = (here(), here() + 1)
b(0x00)

# ANDA #$3F
b(0x84, 0x3F)

# ORA #$40
b(0x8A, 0x40)

# BRA StoreChar
b(0x20)
patches['bra_storechar'] = (here(), here() + 1)
b(0x00)

# WriteSpace:
labels['WriteSpace'] = here()

# LDA #$60  (VDG space)
b(0x86, 0x60)

# StoreChar:
labels['StoreChar'] = here()

# STA ,X+
b(0xA7, 0x80)

# DECB
b(0x5A)

# BNE WriteHello
b(0x26)
patches['bne_writehello'] = (here(), here() + 1)
b(0x00)

# ── Position cursor for WORLD! ───────────────────────────────
# LDD #WORLD_POS
b(0xCC); w(WORLD_POS)

# STD <CURPOS
b(0xDD, CURPOS)

# ── Call PrintStr for "WORLD!" ───────────────────────────────
# LEAX World,PCR
b(0x30, 0x8D)
patches['leax_world'] = (here(), here() + 2)
w(0x0000)

# BSR PrintStr
b(0x8D)
patches['bsr_printstr'] = (here(), here() + 1)
b(0x00)

# ── Position cursor for clean exit ───────────────────────────
# LDD #EXIT_POS
b(0xCC); w(EXIT_POS)

# STD <CURPOS
b(0xDD, CURPOS)

# ── Wait for keypress ────────────────────────────────────────
labels['WaitKey'] = here()

# JSR [POLCAT]  -- $9D xxxx extended indirect
b(0xAD, 0x9F); w(POLCAT)

# BEQ WaitKey
b(0x27)
patches['beq_waitkey'] = (here(), here() + 1)
b(0x00)

# ── Return to BASIC ──────────────────────────────────────────
b(0x39)  # RTS

# ── PrintStr subroutine ──────────────────────────────────────
labels['PrintStr'] = here()

labels['PrintLoop'] = here()
# LDA ,X+
b(0xA6, 0x80)

# BEQ PrintDone
b(0x27)
patches['beq_printdone'] = (here(), here() + 1)
b(0x00)

# JSR [CHROUT]
b(0xAD, 0x9F); w(CHROUT)

# BRA PrintLoop
b(0x20)
patches['bra_printloop'] = (here(), here() + 1)
b(0x00)

labels['PrintDone'] = here()
b(0x39)  # RTS

# ── String data ──────────────────────────────────────────────
labels['Hello'] = here()
for c in b"HELLO ":
    code.append(c)

labels['World'] = here()
for c in b"WORLD!":
    code.append(c)
code.append(0)  # null terminator

# ── Resolve forward references ───────────────────────────────

# Branch patches (8-bit relative)
def patch_branch(name, target_label):
    patch_off, instr_end = patches[name]
    target = labels[target_label]
    rel = target - instr_end
    code[patch_off] = s8(rel)

patch_branch('beq_writespace', 'WriteSpace')
patch_branch('bra_storechar',  'StoreChar')
patch_branch('bne_writehello', 'WriteHello')
patch_branch('bsr_printstr',   'PrintStr')
patch_branch('beq_waitkey',    'WaitKey')
patch_branch('beq_printdone',  'PrintDone')
patch_branch('bra_printloop',  'PrintLoop')

# PC-relative 16-bit patches (LEAY/LEAX n,PCR)
def patch_pcr16(name, target_label):
    patch_off, instr_end = patches[name]
    target = labels[target_label]
    rel = target - instr_end
    code[patch_off]   = (rel >> 8) & 0xFF
    code[patch_off+1] = rel & 0xFF

patch_pcr16('leay_hello', 'Hello')
patch_pcr16('leax_world', 'World')

print(f"Program size: {len(code)} bytes")
print(f"Labels:")
for name, off in sorted(labels.items(), key=lambda x: x[1]):
    print(f"  {name:20s} ${off:04X}  ({off})")
print()
print("Hex dump:")
for i in range(0, len(code), 16):
    chunk = code[i:i+16]
    hex_part = ' '.join(f'{b:02X}' for b in chunk)
    asc_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
    print(f"  {i:04X}  {hex_part:<47}  {asc_part}")

# ================================================================
# Create CoCo DECB binary (.bin) file
# Format: $00 type $05 = ML, followed by blocks
# Block: $00 = data block, length(1), load_addr(2), data
# End:   $FF, 0, exec_addr(2)
# ================================================================

LOAD_ADDR = 0x3F00  # safe area below BASIC program space
EXEC_ADDR = LOAD_ADDR

binfile = bytearray()
# Preamble: type $00 = binary, length, load address
binfile += bytes([0x00])                    # block type: data
binfile += bytes([len(code) & 0xFF])        # length (assumes < 256)
binfile += bytes([(LOAD_ADDR >> 8) & 0xFF, LOAD_ADDR & 0xFF])  # load addr
binfile += code
# Postamble
binfile += bytes([0xFF, 0x00])              # end block type, length=0
binfile += bytes([(EXEC_ADDR >> 8) & 0xFF, EXEC_ADDR & 0xFF])  # exec addr

print(f"\nBinary file size: {len(binfile)} bytes")
open('/home/claude/HELLO.BIN', 'wb').write(binfile)
print("Written: /home/claude/HELLO.BIN")

# ================================================================
# Create CoCo DSK image (35 tracks, 18 sectors, 256 bytes/sector)
# Standard CoCo single-sided single-density format
# ================================================================

TRACKS   = 35
SECTORS  = 18
SECSIZE  = 256
DISKSIZE = TRACKS * SECTORS * SECSIZE  # 161280 bytes

disk = bytearray(DISKSIZE)

def sector_offset(track, sector):
    """sector is 1-based"""
    return (track * SECTORS + (sector - 1)) * SECSIZE

# ── Track 17 Sector 3: Directory ────────────────────────────
# Simple FAT: one file entry
# CoCo disk directory entry format (32 bytes):
#   0-7:  filename (padded with spaces)
#   8-10: extension (padded with spaces)
#   11:   file type (0=basic, 1=data, 2=ML, 3=text)
#   12:   ASCII flag (0=binary, 0xFF=ascii)
#   13:   first granule
#   14-15: bytes in last sector

filename = b'HELLO   '   # 8 bytes
ext      = b'BIN'        # 3 bytes
filetype = 2             # machine language
ascii_f  = 0             # binary
first_gran = 0
bytes_last = len(binfile) % SECSIZE or SECSIZE

dir_entry = bytearray(32)
dir_entry[0:8]   = filename
dir_entry[8:11]  = ext
dir_entry[11]    = filetype
dir_entry[12]    = ascii_f
dir_entry[13]    = first_gran
dir_entry[14]    = (bytes_last >> 8) & 0xFF
dir_entry[15]    = bytes_last & 0xFF

dir_off = sector_offset(17, 3)
disk[dir_off:dir_off+32] = dir_entry
# Fill rest of directory with $FF (empty)
for i in range(32, SECSIZE):
    disk[dir_off + i] = 0xFF

# ── Track 17 Sector 2: FAT ──────────────────────────────────
# Granule allocation table: 68 granules (35 tracks * 2 - 2)
# Each byte: $FF=free, $C0-$C8=last granule (sectors used), 
#            $00-$43=next granule number
fat_off = sector_offset(17, 2)
fat = bytearray([0xFF] * 256)

# Granule 0 = track 0, first 9 sectors — use for our file
# File needs ceil(len(binfile)/2304) granules
import math
gran_size = 9 * SECSIZE  # 2304 bytes per granule
grans_needed = math.ceil(len(binfile) / gran_size)

for g in range(grans_needed - 1):
    fat[g] = g + 1  # chain to next granule
# Last granule
secs_used = math.ceil(len(binfile) / SECSIZE) % 9 or 9
fat[grans_needed - 1] = 0xC0 | secs_used  # last granule marker

disk[fat_off:fat_off+256] = fat

# ── Write file data starting at granule 0 ───────────────────
# Granule 0 = track 0, sectors 1-9
file_off = sector_offset(0, 1)
disk[file_off:file_off+len(binfile)] = binfile

open('/home/claude/HELLO.DSK', 'wb').write(disk)
print(f"Written: /home/claude/HELLO.DSK ({len(disk)} bytes)")
print(f"\nTo use in emulator:")
print(f"  Insert HELLO.DSK as drive 0")
print(f"  LOADM \"HELLO.BIN\"")
print(f"  EXEC")
