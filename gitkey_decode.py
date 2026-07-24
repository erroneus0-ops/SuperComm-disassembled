#!/usr/bin/env python3
"""
gitkey_decode.py -- Git token de-obfuscator (decoder)

PURPOSE:
    Recovers the original GitHub token from a scrambled string
    produced by gitkey.py. Use this in scripts that need the token
    at runtime without storing it in plaintext.

HOW IT WORKS (reverse of gitkey.py):
    1. Base64 decode the scrambled string back to bytes
    2. Reverse the byte sequence (undo the reversal)
    3. Rotate bits of each byte RIGHT by 3 (undo the left rotation)
    4. XOR each byte with the same position-based key (XOR is its own inverse)
    5. Decode UTF-8 bytes back to string

USAGE IN A SCRIPT:
    from gitkey_decode import decode
    token = decode("your_scrambled_string_here")
    # use token in git operations

STANDALONE:
    python gitkey_decode.py "scrambled_string"
    (prints the recovered token -- be careful where you run this)
"""

import base64
import sys

# Must match gitkey.py exactly
XOR_KEYS = [7, 13, 31, 37, 41, 53, 59, 67, 71, 79, 83, 89, 97, 101, 103]


def rotate_bits_right(byte, n):
    """Rotate the bits of a single byte right by n positions.
    
    This is the inverse of rotate_bits_left(byte, n).
    Example: rotate_bits_right(0b00001100, 3) -> 0b10000001
    """
    n = n % 8
    return ((byte >> n) | (byte << (8 - n))) & 0xFF


def decode(scrambled: str) -> str:
    """Recover the original token from a scrambled string.
    
    Steps (reverse of scramble()):
        1. Base64 decode
        2. Reverse byte order
        3. Rotate bits right by 3 (inverse of left rotation)
        4. XOR with same position-based key (XOR is self-inverse: a^b^b = a)
        5. Decode UTF-8
    """
    # Step 1: Base64 decode
    raw = base64.b64decode(scrambled.encode('ascii'))
    
    # Step 2: Unreverse
    unreversed = bytes(reversed(raw))
    
    # Step 3: Rotate bits right by 3 (undo the left rotation)
    unrotated = bytes(rotate_bits_right(b, 3) for b in unreversed)
    
    # Step 4: XOR with same keys (XOR is its own inverse)
    unxored = bytes(
        b ^ XOR_KEYS[i % len(XOR_KEYS)]
        for i, b in enumerate(unrotated)
    )
    
    # Step 5: Decode UTF-8
    return unxored.decode('utf-8')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python gitkey_decode.py <scrambled_token>")
        sys.exit(1)
    
    scrambled = sys.argv[1].strip()
    try:
        token = decode(scrambled)
        print(token)
    except Exception as e:
        print(f"ERROR: Could not decode: {e}", file=sys.stderr)
        sys.exit(1)
