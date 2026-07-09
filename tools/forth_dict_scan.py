#!/usr/bin/env python3
"""
forth_dict_scan.py -- Experimental Forth dictionary scanner for flames.bin

Attempts to reconstruct the Forth word list from a CoCo Forth ITC binary.
Currently produces partial results -- the exact header format for Paul
Cunningham's Bare Naked Forth needs to be confirmed before this can be
trusted fully.

Steps implemented:
  1. Parse DECB binary and build flat 64KB memory image
  2. Simulate bootstrap relocation ($0E19 -> $E000)
  3. Scan relocated kernel for word headers (fig-Forth style)
  4. Map $E0xx code field addresses from fire segment to word names

Status: experimental -- many false positives due to unknown header format.

Usage:
  python3 tools/forth_dict_scan.py wasm/flames.bin
"""

import sys

def load_decb(path):
    with open(path, 'rb') as f:
        data = f.read()
    mem = bytearray(0x10000)
    i = 0
    while i < len(data):
        bt = data[i]; i += 1
        if bt == 0xFF:
            break
        if bt == 0x00:
            length    = (data[i]<<8)|data[i+1]; i += 2
            load_addr = (data[i]<<8)|data[i+1]; i += 2
            mem[load_addr:load_addr+length] = data[i:i+length]
            i += length
    return mem

def relocate_kernel(mem):
    """Simulate bootstrap: copy $0E19-$1D4D to $E000."""
    mem[0xE000:0xEF35] = mem[0x0E19:0x0E19+0x0F35]

def scan_dict(mem, start=0xE200, end=0xEF35):
    """Scan for fig-Forth style word headers."""
    words = []
    addr = start
    while addr < end:
        length_byte = mem[addr]
        name_len = length_byte & 0x1F
        if 1 <= name_len <= 15:
            name_bytes = mem[addr+1:addr+1+name_len]
            if all(0x20 <= b <= 0x7E for b in name_bytes):
                name = bytes(name_bytes).decode('ascii')
                link = (mem[addr-2]<<8)|mem[addr-1]
                cf_addr = addr + 1 + name_len
                cf = (mem[cf_addr]<<8)|mem[cf_addr+1]
                immediate = bool(length_byte & 0x80)
                words.append({
                    'link_addr': addr-2,
                    'link':      link,
                    'name':      name,
                    'immediate': immediate,
                    'cf_addr':   cf_addr,
                    'cf':        cf,
                })
                addr = cf_addr + 2
                continue
        addr += 1
    return words

def collect_fire_refs(mem):
    """Collect unique E0xx addresses referenced from fire segment."""
    refs = set()
    for addr in range(0x2000, 0x247C, 2):
        w = (mem[addr]<<8)|mem[addr+1]
        if 0xE000 <= w <= 0xEF35:
            refs.add(w)
    return refs

if __name__ == '__main__':
    path = sys.argv[1] if len(sys.argv) > 1 else 'wasm/flames.bin'
    mem = load_decb(path)
    relocate_kernel(mem)

    words = scan_dict(mem)
    refs  = collect_fire_refs(mem)

    # Build code-field -> name map
    cf_map = {w['cf_addr']: w['name'] for w in words}

    print(f"Words found in dictionary: {len(words)}")
    print(f"Unique E0xx refs from fire segment: {len(refs)}")
    print()

    print("Fire segment word references (E0xx -> name if known):")
    for ref in sorted(refs):
        name = cf_map.get(ref, '???')
        print(f"  ${ref:04X}  {name}")

    print()
    print("NOTE: Many 'n' entries are false positives.")
    print("      Header format needs confirmation against ugufru source.")
