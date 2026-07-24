#!/usr/bin/env python3
"""
gitkey.py -- Git token obfuscator (encoder)

PURPOSE:
    Scrambles a GitHub personal access token so it doesn't appear in plaintext
    in scripts or config files. This is NOT real encryption -- it's obfuscation.
    Anyone with this script and the scrambled output can recover the token.
    Use environment variables or a credential manager for real security.

HOW IT WORKS:
    1. XOR each byte of the token with a key derived from its position
    2. Rotate the bits of each byte (shift left by 3, wrap around)
    3. Reverse the entire byte sequence
    4. Base64 encode the result so it's safe to store as text

USAGE:
    python gitkey.py
    (paste your token when prompted, copy the scrambled output)

OUTPUT:
    A scrambled string to store in your scripts instead of the raw token.
    Use gitkey_decode.py to recover the original token at runtime.
"""

import base64
import sys

# XOR key sequence -- just some primes, doesn't need to be secret
# since the algorithm itself isn't secret
XOR_KEYS = [7, 13, 31, 37, 41, 53, 59, 67, 71, 79, 83, 89, 97, 101, 103]


def rotate_bits_left(byte, n):
    """Rotate the bits of a single byte left by n positions.
    
    Example: rotate_bits_left(0b10000001, 3) -> 0b00001100
    The bits that fall off the left end wrap around to the right.
    """
    n = n % 8  # byte has 8 bits
    return ((byte << n) | (byte >> (8 - n))) & 0xFF


def scramble(token: str) -> str:
    """Scramble a token string into an obfuscated base64 string.
    
    Steps:
        1. Encode token to bytes (UTF-8)
        2. XOR each byte with a cycling key based on position
        3. Rotate each byte's bits left by 3
        4. Reverse the byte order
        5. Base64 encode for safe text storage
    """
    data = token.encode('utf-8')
    
    # Step 2: XOR with position-based key
    xored = bytes(
        b ^ XOR_KEYS[i % len(XOR_KEYS)]
        for i, b in enumerate(data)
    )
    
    # Step 3: Rotate bits left by 3
    rotated = bytes(rotate_bits_left(b, 3) for b in xored)
    
    # Step 4: Reverse byte order
    reversed_bytes = bytes(reversed(rotated))
    
    # Step 5: Base64 encode
    return base64.b64encode(reversed_bytes).decode('ascii')


if __name__ == '__main__':
    print("Git token obfuscator")
    print("=" * 40)
    print("Paste your GitHub personal access token:")
    token = input().strip()
    
    if not token:
        print("ERROR: No token provided")
        sys.exit(1)
    
    scrambled = scramble(token)
    print()
    print("Scrambled token (store this in your scripts):")
    print(scrambled)
    print()
    print("Use gitkey_decode.py to recover the token at runtime.")
    print("DO NOT commit the original token to git.")
