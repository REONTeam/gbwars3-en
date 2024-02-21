#!/usr/bin/env python3

from sys import argv
from translate import translate, charmap_unit

def dump(str):
    return ", ".join("$%02x" % x for x in data)
    # return translate(charmap_unit, data)

bank = int(argv[1], 0)
addr = int(argv[2], 0)
nums = int(argv[3], 0)
size = int(argv[4], 0)

rom = open("baserom.gbc", "rb").read()

pos = bank * 0x4000 + addr % 0x4000

labels = {}
for x in range(nums):
    loc = pos + x * 2
    addr = int.from_bytes(rom[loc:loc+2], 'little')
    addr_pos = bank * 0x4000 + addr % 0x4000
    name = "._%04x" % addr
    labels[addr_pos] = name
    print("    dw", name)

pos += nums * 2
data = []
def commit():
    global data
    if data:
        print("    db", dump(data))
    data = []
for x in range(size):
    if pos + x in labels:
        commit()
        print()
        print("%s:" % labels[pos + x])
        data.append(rom[pos + x])
    else:
        data.append(rom[pos + x])
commit()
