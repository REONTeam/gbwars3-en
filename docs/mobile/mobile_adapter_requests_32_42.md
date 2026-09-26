# Mobile Adapter requests $32-$42 dispatcher tail (the project)

the project owns physical Bank `$30:$548F-$56CB` (573 retail bytes), ending exactly before the exported serial-service entry at `$56CC`. This closes the final unsourced destinations in the 34-entry even-valued SDK request table.

The fixed dispatcher boundaries are request `$3A` at `$548F`, internal request `$42` at `$5543`, request `$32` at `$5544`, request `$34` at `$5599`, request `$3C` at `$5617`, and request `$36` at `$5634`. Internal `$42` is a single `NOP` byte and deliberately falls through into request `$32`.

Request `$32` has a behavior-backed wire-protocol identity: it emits `$97`, which is `MOBILE_COMMAND_TELEPHONE_STATUS | $80`, before entering the established common packet-transfer path. This does not collapse the SDK request namespace into the wire-command namespace, so the request number remains explicit in the canonical source label.

Request `$36` is a reset-style driver path. After validating the expected driver state, it clears a small state pair, calls the local reset/flag helper at `$568D`, calls the existing shared front-end helper, then clears exactly `$0452` bytes starting at `$D000`. This is the same complete Mobile driver workspace size established by request `$02`. The helper family at `$5656-$568C` rebuilds/reset-status words and a pointer-relative state byte; `$568D-$56CB` normalizes serial/control flags and mirrors reset state through `$D347/$D348`.

Requests `$3A`, `$34`, and `$3C` remain deliberately numeric. `$3A` is a bounded buffer/descriptor continuation using the shared `$D1xx/$D2xx` workspace; `$34` participates in received command/status handling around values including `$92/$A3/$A4/$9F`; `$3C` is a compact state-control entry that stages internal state `$28`. None currently proves a narrow public API name.

With this tranche, Bank `$30:$4000-$56CB` is continuously source-owned. The next natural boundary is the exported serial-service entry at `$56CC`; subsequent work should split that interrupt-driven packet service and its send/receive/checksum helpers before continuing to `$58E4`.
