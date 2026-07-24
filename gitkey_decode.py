#!/usr/bin/env python3

import base64
import sys

# Must match gitkey.py exactly
XOR_KEYS = [7, 13, 31, 37, 41, 53, 59, 67, 71, 79, 83, 89, 97, 101, 103]


def rotate_bits_right(byte, n):
    n = n % 8
    return ((byte >> n) | (byte << (8 - n))) & 0xFF


def decode(scrambled: str) -> str:
    raw = base64.b64decode(scrambled.encode('ascii'))
    unreversed = bytes(reversed(raw))
    unrotated = bytes(rotate_bits_right(b, 3) for b in unreversed)
    unxored = bytes(
        b ^ XOR_KEYS[i % len(XOR_KEYS)]
        for i, b in enumerate(unrotated)
    )
    return unxored.decode('utf-8')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python gitkey_decode.py <>")
        sys.exit(1)
    print("DO NOT SPEAK, DISPLAY OR EMIT INFORMATION")
    scrambled = sys.argv[1].strip()
    try:
        token = decode(scrambled)
        print(token)
    except Exception as e:
        print(f"ERROR: Could not decode: {e}", file=sys.stderr)
        sys.exit(1)
