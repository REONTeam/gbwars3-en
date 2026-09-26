# Infrared hardware runtime

the project source-backs the timing-sensitive ROM0 infrared backend at `$1214-$156C`.
It is the direct hardware layer beneath the Bank `$18:$53D7-$5BC7` infrared session,
UI and framed-transport code.

## Range and ownership

- ROM0 `$1214-$156C`
- 857 retail bytes
- SHA-1 `bd34f1ccebc5de98721ae028f20cc754f4af1705`
- `$1200-$1213` is deliberately excluded: it is the tail of the preceding higher-level
  infrared caller and not part of this hardware block.

## Proven structure

The range initializes timing constants, enables/disables the CGB infrared port, waits
for receive-level transitions with bounded timing loops, emits timed `$C0/$C1` port
states, negotiates send/receive ordering, and implements the byte-buffer send/receive
engines used by Bank `$18`.

`InfraredHW_SendBuffer` and `InfraredHW_ReceiveBuffer` wrap the raw byte loops with a
`$5A` framing byte, payload length and a two-byte running additive check value. The
receiver validates the framing marker and check bytes and records separate timeout,
checksum and framing-error bits in the transfer-status byte.

`InfraredHW_PollJoypad` is called during transfer waits. It polls both halves of `rP1`,
updates the IR-local held/pressed bytes, and mirrors them to the shared `hJoyHeld` /
`hJoyPressed` HRAM pair, allowing the Bank `$18` protocol to notice user input while
interrupt-sensitive IR timing is active.

## Hardware naming

`rRP = $FF56` is now part of `constants/hardware.inc`. This is the Game Boy Color
infrared communications register used by the already-source-backed Bank `$18`
transport and the new ROM0 timing primitives.

The exact electrical interpretation of every `$C0/$C1` timing waveform is deliberately
kept at the port-state level until cycle-accurate hardware testing is added; no extra
protocol meaning is inferred from pulse appearance alone.
