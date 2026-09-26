#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'baserom.gbc'
rom = ROM.read_bytes()
SRC = ROOT / 'engine/map/ai/map_ai_transport_route_planning.asm'
src = SRC.read_text()

BANK = 0x0D
START = 0x5DB5
END = 0x6183
EXPECTED_SHA1 = 'a37db795d68edb333278eb70f6fa3a6af9c590c8'

off = BANK * 0x4000 + (START - 0x4000)
retail = rom[off:off + END - START]
assert hashlib.sha1(retail).hexdigest() == EXPECTED_SHA1

# The module deliberately remains byte-row exact while status bits 4-5 are
# still only structurally typed. Reconstruct its emitted db stream directly.
vals = []
for line in src.splitlines():
    code = line.split(';', 1)[0]
    if re.match(r'\s*db\s', code, re.I):
        vals.extend(int(x, 16) for x in re.findall(r'\$([0-9a-fA-F]{2})', code))
got = bytes(vals)
assert got == retail, f'source bytes differ: {len(got)} vs {len(retail)}'

required = {
    'MapAI_TestTransportPlanningCellAvailable': 0x5DB5,
    'MapAI_BuildTransportSearchBounds': 0x5DE7,
    'MapAI_TryTransportSupportAction': 0x5E28,
    'MapAI_TestTransportUnitTerrainCompatibility': 0x5E75,
    'MapAI_UpdateTransportUnitRouteStatus': 0x5EC6,
    'MapAI_RunAirTransportRouting': 0x5F0C,
    'MapAI_ProcessAirTransportUnit': 0x5F3E,
    'MapAI_UpdateAirTransportRouteState': 0x5F74,
    'MapAI_RunTransportShipRouting': 0x6005,
    'MapAI_ProcessTransportShip': 0x602D,
    'MapAI_UpdateTransportShipRouteState': 0x6063,
    'MapAI_GetTransportPortCandidateCoordinates': 0x60D7,
    'MapAI_RouteTransportShipTowardApproach': 0x60E0,
    'MapAI_FindNearestCompatibleTransportUnit': 0x60FA,
}
for name in required:
    assert f'{name}::' in src, name
assert 'assert @ == $6183' in src

bank = rom[BANK*0x4000:(BANK+1)*0x4000]
def at(addr, hexbytes):
    data = bytes.fromhex(hexbytes)
    i = addr - 0x4000
    assert bank[i:i+len(data)] == data, f'pattern mismatch at ${addr:04X}'

# Air transport scan: decoded unit types $25/$2A/$2B are Transport Plane,
# Transport Helicopter, and Transport Helicopter S.
at(0x5F1D, 'cb3ffe25280afe2a2806fe2b2802')
# Sea transport scan: decoded unit type $30 is Transport Ship.
at(0x6016, 'cb3ffe302003')
# The sea path consumes the current source nearest-Port and opposing-HQ-region pairs.
at(0x60D7, 'fa9cde47fa9dde4fc9')
at(0x60E0, 'fa9ede47fa9fde4f')
# Both route-state writers preserve all status bits except bits 4-5.
at(0x5FDB, 'fae0cce6cfb0eae0cc')
at(0x60C6, 'fae0cce6cfb0eae0cc')

# the current source inherited boundary correction: $6183 is the LDH opcode, $6184 its
# operand. The bridge planner must therefore start at $6183.
planner = (ROOT/'engine/map/ai/map_ai_bridge_attack_planning.asm').read_text()
assert 'romx[$6183]' in planner
assert re.search(r'MapAI_PlanBridgeConstruction::\s*\n\s*db\s+\$f0,\s*\$82', planner)
bridge = rom[BANK*0x4000 + (0x6183-0x4000):BANK*0x4000 + (0x6325-0x4000)]
assert hashlib.sha1(bridge).hexdigest() == '44b3b5a151a5f74d884d623ae3d7a0ddf16f17e9'

print(f'[ok] the current source transport route planning: {len(retail)} retail bytes exact, sha1 {EXPECTED_SHA1}')
print('[ok] air/sea transport identities, current source route-coordinate consumers, and $6183 bridge boundary locked')
