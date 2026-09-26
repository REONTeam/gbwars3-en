#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
SRC = ROOT / "engine/unit/unit_hp_transfer.asm"
SYM = ROOT / "symbols.asm"
START, END = 0x4DF2, 0x4F82
SHA1 = "a4afeefc52b1f4f445c4c786d620d03f79800d00"

expected_aliases = {
    "wUnitTransferTargetUnitID": 0xC941,
    "wUnitTransferSourceHP": 0xC942,
    "wUnitTransferTargetHP": 0xC943,
    "wUnitTransferMaxHP": 0xC944,
}

text = SRC.read_text(encoding="utf-8")
syms = SYM.read_text(encoding="utf-8")

for name, address in expected_aliases.items():
    if not re.search(rf"^{name}\s+equ\s+\${address:04x}\s*$", syms, re.M | re.I):
        raise SystemExit(f"[fail] missing alias {name} = ${address:04X}")
    if name not in text:
        raise SystemExit(f"[fail] {name} not used in HP-transfer source")

code_without_comments = "\n".join(line.split(";", 1)[0] for line in text.splitlines()).lower()
for raw in ["$c941", "$c942", "$c943", "$c944"]:
    if raw in code_without_comments:
        raise SystemExit(f"[fail] raw Unit HP-transfer scratch literal remains: {raw}")
if re.search(r"(?m)^\s*db\s+", code_without_comments):
    raise SystemExit("[fail] raw db data remains in Unit HP-transfer runtime source")

required = [
    "UnitHPTransfer_Run::",
    "UnitHPTransfer_SelectTarget::",
    "UnitHPTransfer_LoadTarget::",
    "call UnitHPTransfer_BuildEligibleAdjacentTargetList",
    "call UnitHPTransfer_SelectTarget",
    "farcall $12, UnitRecord_GetByte",
    "farcall $12, UnitData_GetByte",
    "farcall $25, UnitStatus_RunController",
    "call UnitAction_FinalizeActiveUnitActionState",
    "farcall $12, Unit_SetEndTurnFlag",
    "farcall $12, UnitRecord_SetByte",
    "farcall $12, Unit_DeleteWithCarriedAtCoordinates",
    "call UnitSelection_RefreshLiveUnitMapPresentation",
    "call MapCursor_Show",
    "call MapCursor_SetMapCoordinates",
    "call MapControl_UpdateInteractionInputState",
    "call UnitMoveStatusOverlay_Clear",
    "call UnitMoveStatusOverlay_Init",
    "ld c, UNIT_RECORD_HP_OFFSET",
    "ld c, UNIT_RECORD_FUEL_OFFSET",
    "assert @ == $4f82",
]
for needle in required:
    if needle not in text:
        raise SystemExit(f"[fail] HP-transfer source missing: {needle}")

# Lightweight layout audit for this source file. This is intentionally strict
# about the instruction forms used here so accidental one-byte shifts are
# caught even on systems where RGBDS has not yet been bootstrapped.
def source_layout(source: str):
    address = START
    labels = {}
    scope = ""
    for lineno, raw_line in enumerate(source.splitlines(), 1):
        line = raw_line.split(";", 1)[0].strip()
        if not line or line.startswith(("include ", "DEF ", "section ", "assert ")):
            continue
        if line.endswith("::"):
            name = line[:-2]
            scope = name
            labels[name] = address
            continue
        if re.fullmatch(r"\.[A-Za-z0-9_]+", line):
            labels[f"{scope}{line}"] = address
            continue
        if line.startswith("farcall "):
            address += 4
            continue
        op = line.split()[0].lower()
        if op in {"call", "jp"}:
            address += 3
        elif op == "jr":
            address += 2
        elif op in {"bit", "res", "set", "srl", "sla", "sra", "swap", "rl", "rr", "rlc", "rrc"}:
            address += 2
        elif op == "ldh":
            address += 2
        elif op == "ld":
            operands = line[2:].strip()
            if "," not in operands:
                raise SystemExit(f"[fail] line {lineno}: malformed ld: {line}")
            dst, src = [part.strip() for part in operands.split(",", 1)]
            if dst in {"bc", "de", "hl", "sp"} and src != "hl":
                address += 3
            elif dst.startswith("[") or src.startswith("["):
                mem = dst if dst.startswith("[") else src
                if mem.lower() in {"[hl]", "[hli]", "[hld]", "[bc]", "[de]"}:
                    address += 1
                else:
                    address += 3
            elif dst in {"a", "b", "c", "d", "e", "h", "l"} and src not in {"a", "b", "c", "d", "e", "h", "l"}:
                address += 2
            else:
                address += 1
        elif op == "cp":
            operand = line[2:].strip()
            address += 1 if operand in {"a", "b", "c", "d", "e", "h", "l", "[hl]"} else 2
        elif op in {"ret", "push", "pop", "xor", "and", "or", "add", "sub", "inc", "dec", "scf", "ccf", "cpl", "nop", "halt", "di", "ei"}:
            address += 1
        else:
            raise SystemExit(f"[fail] line {lineno}: unsupported layout-audit instruction: {line}")
    return address, labels

end_address, labels = source_layout(text)
expected_labels = {
    "UnitHPTransfer_Run": 0x4DF2,
    "UnitHPTransfer_Run.commit": 0x4E3D,
    "UnitHPTransfer_Run.source_survives": 0x4E8F,
    "UnitHPTransfer_Run.target_survives": 0x4EBB,
    "UnitHPTransfer_Run.success": 0x4EC1,
    "UnitHPTransfer_Run.finish": 0x4EC2,
    "UnitHPTransfer_SelectTarget": 0x4EC8,
    "UnitHPTransfer_SelectTarget.input_loop": 0x4EDE,
    "UnitHPTransfer_SelectTarget.previous": 0x4EF6,
    "UnitHPTransfer_SelectTarget.next": 0x4F04,
    "UnitHPTransfer_SelectTarget.store_selection": 0x4F10,
    "UnitHPTransfer_SelectTarget.confirm": 0x4F20,
    "UnitHPTransfer_SelectTarget.cancel": 0x4F2A,
    "UnitHPTransfer_SelectTarget.finish": 0x4F37,
    "UnitHPTransfer_LoadTarget": 0x4F4E,
}
for label, expected in expected_labels.items():
    got = labels.get(label)
    if got != expected:
        raise SystemExit(f"[fail] {label} at {got!r}, expected ${expected:04X}")
if end_address != END:
    raise SystemExit(f"[fail] HP-transfer source ends at ${end_address:04X}, expected ${END:04X}")

if ROM.exists():
    rom = ROM.read_bytes()
    off = 0x0B * 0x4000 + (START - 0x4000)
    retail = rom[off:off + (END - START)]
    digest = hashlib.sha1(retail).hexdigest()
    if digest != SHA1:
        raise SystemExit(f"[fail] ROM hash mismatch: {digest}, expected {SHA1}")
    print(f"[ok] Unit HP transfer retail fingerprint: Bank $0B:${START:04X}-${END-1:04X}, {len(retail)} bytes, SHA-1 {digest}")
else:
    print("[skip] baserom absent; retail HP-transfer fingerprint not checked")

print("[ok] UnitHPTransfer_Run/SelectTarget/LoadTarget are mnemonic source with exact $4DF2/$4EC8/$4F4E/$4F82 layout")
print("[ok] target selection, Bank-$25 HP redistribution UI, source/target HP commit, zero-HP deletion, cursor restoration, and overlay lifecycle are symbolically integrated")
