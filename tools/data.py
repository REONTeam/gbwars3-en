#!/usr/bin/env python3

from sys import argv

bank = int(argv[1], 0)
addr = int(argv[2], 0)
size = int(argv[3], 0)
out = argv[4]

pos = bank * 0x4000 + addr % 0x4000

rom = open("baserom.gbc", "rb")
rom.seek(pos)
open(out, "wb").write(rom.read(size))
