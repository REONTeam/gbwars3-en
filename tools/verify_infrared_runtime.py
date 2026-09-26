#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

rom = Path(sys.argv[1]).read_bytes()
src = Path('engine/infrared/infrared_runtime.asm').read_text()
base = 0x18 * 0x4000

def sl(a, b):
    return rom[base + (a - 0x4000):base + (b - 0x4000)]

checks = [
    (0x53D7, 0x55F2, '173de9e357348ad4e4631841456dd6c2dc3c3730'),
    (0x55F2, 0x58B8, '61c895ba441c0ee2ccd143957a373ea2bda8514d'),
    (0x58B8, 0x5BC8, '245fb6c4e1236e72a9d093edb093046a4c19431f'),
]
for a, b, expected in checks:
    data = sl(a, b)
    actual = hashlib.sha1(data).hexdigest()
    assert actual == expected, (hex(a), actual)

# Fixed label addresses used by the two symbolic UI pointer tables.
ui_labels = {
    'InfraredUI_StatusPreparing': 0x572C,
    'InfraredUI_StatusWaiting': 0x573B,
    'InfraredUI_StatusCommunicating': 0x5749,
    'InfraredUI_StatusConnectionFailed': 0x5758,
    'InfraredUI_StatusCommunicationError': 0x5766,
    'InfraredUI_PromptReady': 0x5812,
    'InfraredUI_PromptWaitOrCancel': 0x5830,
    'InfraredUI_PromptRestartAnyButton': 0x584E,
    'InfraredUI_PromptRestartAButton': 0x5870,
}

def section_bytes(start_marker, end_marker=None):
    body = src.split(start_marker, 1)[1]
    if end_marker is not None:
        body = body.split(end_marker, 1)[0]
    out = bytearray()
    for line in body.splitlines():
        code = line.split(';', 1)[0].strip()
        if code.startswith('db '):
            for token in code[3:].split(','):
                token = token.strip()
                if token.startswith('$'):
                    out.append(int(token[1:], 16))
        elif code.startswith('dw '):
            for token in code[3:].split(','):
                token = token.strip()
                if token.startswith('$'):
                    value = int(token[1:], 16)
                else:
                    value = ui_labels[token]
                out += bytes((value & 0xFF, value >> 8))
    return bytes(out)

owned_session = section_bytes(
    'section "Infrared Session and Transfer API"',
    'section "Infrared Interface and Connection UI"',
)
owned_ui = section_bytes(
    'section "Infrared Interface and Connection UI"',
    'section "Infrared Low-Level Framed Transport"',
)
owned_transport = section_bytes('section "Infrared Low-Level Framed Transport"')
assert owned_session == sl(0x53D7, 0x55F2), (len(owned_session), 0x55F2 - 0x53D7)
assert owned_ui == sl(0x55F2, 0x58B8), (len(owned_ui), 0x58B8 - 0x55F2)
assert owned_transport == sl(0x58B8, 0x5BC8), (len(owned_transport), 0x5BC8 - 0x58B8)

required = [
    'Infrared_ResetSessionState', 'Infrared_StartSession', 'Infrared_CheckSessionHealth',
    'Infrared_VerifyPeerSignature', 'Infrared_PeerSignature', 'Infrared_SendBuffer',
    'Infrared_ReceiveBuffer', 'InfraredUI_Initialize',
    'InfraredUI_PositioningInstructionLine1', 'InfraredUI_PositioningInstructionLine2',
    'InfraredUI_DrawConnectionStatus', 'InfraredUI_ConnectionStatusPointers',
    'InfraredUI_StatusPreparing', 'InfraredUI_StatusWaiting',
    'InfraredUI_StatusCommunicating', 'InfraredUI_StatusConnectionFailed',
    'InfraredUI_StatusCommunicationError', 'InfraredUI_DrawPrompt',
    'InfraredUI_PromptPointers', 'InfraredUI_PromptReady',
    'InfraredUI_PromptWaitOrCancel', 'InfraredUI_PromptRestartAnyButton',
    'InfraredUI_PromptRestartAButton', 'InfraredUI_LoadPromptGraphics',
    'Infrared_LinkHandshake', 'Infrared_DispatchPacketType',
    'Infrared_ReceivePacketPayload', 'Infrared_SendPacketPayload',
    'Infrared_ExchangeFrame', 'Infrared_LinkSelfTest', 'Infrared_SetTransferDescriptor',
    'Infrared_ReceiveFrame', 'Infrared_WaitFrameReady', 'Infrared_SendFrame',
]
for label in required:
    assert label + '::' in src, label

assert 'dw InfraredUI_StatusPreparing' in src
assert 'dw InfraredUI_PromptReady' in src
assert '"GBoyWARS3"' in src
assert src.count('romx[$55f2], bank[$18]') == 1
assert src.count('romx[$58b8], bank[$18]') == 1

print('[ok] infrared session API $53D7-$55F1: 539 bytes, SHA-1 173de9e357348ad4e4631841456dd6c2dc3c3730')
print('[ok] infrared interface/UI $55F2-$58B7: 710 bytes, SHA-1 61c895ba441c0ee2ccd143957a373ea2bda8514d')
print('[ok] infrared framed transport $58B8-$5BC7: 784 bytes, SHA-1 245fb6c4e1236e72a9d093edb093046a4c19431f')
