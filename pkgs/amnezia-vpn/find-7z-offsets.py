#!/usr/bin/env python3
"""Print the byte offsets of every 7z archive signature inside a file.

Qt Installer Framework `.run` installers are an ELF launcher with a series of
7z archives appended. Locating the archives is the same trick the AUR
`amneziavpn-bin` package performs with `binwalk -qe -y=7zip`, done here without
the extra dependency so the derivation stays small and deterministic.
"""
import sys

SIGNATURE = b"7z\xbc\xaf\x27\x1c"

with open(sys.argv[1], "rb") as fh:
    data = fh.read()

offsets = []
pos = 0
while True:
    found = data.find(SIGNATURE, pos)
    if found < 0:
        break
    offsets.append(found)
    pos = found + 1

print(" ".join(str(o) for o in offsets))
