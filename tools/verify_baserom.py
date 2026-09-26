#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import sys
from pathlib import Path

EXPECTED_SIZE = 0x100000
EXPECTED_SHA1 = "61e08f96261b5f85c65c70db5464b4298f9f2cf8"
EXPECTED_SHA256 = "ba5e14c23e20ea9003482239ceac6c77bec19b3fcae61fd2863e11c06b345e5e"
EXPECTED_TITLE_FIELD = b"GB WARS3\x00\x00\x00BWWJ"
EXPECTED_CGB_FLAG = 0xC0
EXPECTED_CART_TYPE = 0x1B
EXPECTED_ROM_SIZE_CODE = 0x05
EXPECTED_RAM_SIZE_CODE = 0x04


def fail(message: str) -> None:
    raise SystemExit(f"baserom verification failed: {message}")


def main() -> None:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "baserom.gbc")
    if not path.is_file():
        fail(f"missing {path}; provide an unmodified Japanese retail Game Boy Wars 3 ROM")

    data = path.read_bytes()
    if len(data) != EXPECTED_SIZE:
        fail(f"size is {len(data)} bytes, expected {EXPECTED_SIZE}")

    sha1 = hashlib.sha1(data).hexdigest()
    sha256 = hashlib.sha256(data).hexdigest()
    if sha1 != EXPECTED_SHA1 or sha256 != EXPECTED_SHA256:
        fail(
            "ROM hash does not match the supported Japanese retail dump\n"
            f"  SHA-1:   {sha1}\n"
            f"  SHA-256: {sha256}"
        )

    title_field = data[0x134:0x143]
    if title_field != EXPECTED_TITLE_FIELD:
        fail(f"unexpected title/manufacturer field: {title_field!r}")
    checks = {
        0x143: ("CGB flag", EXPECTED_CGB_FLAG),
        0x147: ("cartridge type", EXPECTED_CART_TYPE),
        0x148: ("ROM size code", EXPECTED_ROM_SIZE_CODE),
        0x149: ("RAM size code", EXPECTED_RAM_SIZE_CODE),
    }
    for offset, (label, expected) in checks.items():
        if data[offset] != expected:
            fail(f"{label} is ${data[offset]:02X}, expected ${expected:02X}")

    print("baserom.gbc: supported Japanese retail ROM [ok]")
    print(f"  SHA-1:   {sha1}")
    print(f"  SHA-256: {sha256}")


if __name__ == "__main__":
    main()
