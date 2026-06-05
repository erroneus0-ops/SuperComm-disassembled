import sys

a = open(sys.argv[1], 'rb').read()
b = open(sys.argv[2], 'rb').read()

print(f"Assembled: {len(a)} bytes, last 8: {a[-8:].hex()}")
print(f"Original:  {len(b)} bytes, last 8: {b[-8:].hex()}")
print()

diffs = [(i,x,y) for i,(x,y) in enumerate(zip(a,b)) if x!=y]
print(f"Total differing bytes in common length: {len(diffs)}")
for i,x,y in diffs[:20]:
    print(f"  offset {hex(i):8s}: assembled={hex(x):4s} original={hex(y)}")

if len(a) != len(b):
    shorter = min(len(a), len(b))
    print(f"\nExtra bytes in original [{shorter}:{len(b)}]: {b[shorter:].hex()}")