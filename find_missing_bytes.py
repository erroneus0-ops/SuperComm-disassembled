#!/usr/bin/env python3
"""
Find missing bytes by doing sequence alignment between assembled and original binary.
Uses a sliding window to detect insertion points.
"""
import sys

def find_gaps(assembled_path, original_path, window=16):
    a = open(assembled_path, 'rb').read()[:-3]  # strip CRC
    b = open(original_path, 'rb').read()[:-3]   # strip CRC
    
    print(f"Assembled: {len(a)} bytes")
    print(f"Original:  {len(b)} bytes")
    print(f"Difference: {len(b)-len(a)} bytes missing from assembled")
    print()
    
    ai = 0  # position in assembled
    bi = 0  # position in original
    gaps = []
    
    while ai < len(a) and bi < len(b):
        if a[ai] == b[bi]:
            ai += 1
            bi += 1
        else:
            # Look ahead to determine if this is an insertion in original
            # Try skipping 1-8 bytes in original
            found = False
            for skip in range(1, 9):
                if bi + skip < len(b) and ai + window <= len(a) and bi + skip + window <= len(b):
                    if a[ai:ai+window] == b[bi+skip:bi+skip+window]:
                        # Found alignment after skipping 'skip' bytes in original
                        missing = b[bi:bi+skip]
                        gaps.append((ai, bi, missing))
                        print(f"Gap at assembled offset {hex(ai)}, original offset {hex(bi)}:")
                        print(f"  Missing {skip} byte(s): {missing.hex()}")
                        ctx_before = b[max(0,bi-4):bi]
                        ctx_after  = b[bi+skip:bi+skip+4]
                        print(f"  Context: ...{ctx_before.hex()} [{missing.hex()}] {ctx_after.hex()}...")
                        print()
                        bi += skip
                        found = True
                        break
            if not found:
                # Not a simple insertion — just advance both
                ai += 1
                bi += 1
    
    print(f"Total gaps found: {len(gaps)}")
    print(f"Total missing bytes: {sum(len(g[2]) for g in gaps)}")
    return gaps

if __name__ == '__main__':
    find_gaps(sys.argv[1], sys.argv[2])
