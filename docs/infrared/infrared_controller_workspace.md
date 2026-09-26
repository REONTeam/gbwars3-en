# Infrared controller WRAM lifetime aliases

the project types the nine-byte scratch window at `$C61A-$C622` used by the ROM0 infrared feature controller.
These are **lifetime-scoped aliases**, not global ownership claims: retail callers in later Bank `$25/$33` code reuse the same physical WRAM after the infrared feature is no longer active.

## IR controller view

- `$C61A` `wInfraredControllerState` — current controller state. The local state table covers states 0-8; terminal/result states `$13/$14` are returned by the dispatcher.
- `$C61B` `wInfraredSessionSelector` — byte returned by the session-start path and consumed by State 00. Its deeper physical-link meaning remains conservative.
- `$C61C` `wInfraredPeerCompareByte` — local byte passed to the one-byte peer comparison path.
- `$C61D` `wInfraredTransferDirection` — transfer direction selector. `0` chooses the Bank `$18` send path; nonzero chooses receive.
- `$C61E-$C61F` `wInfraredTransferBufferAddress` — 16-bit transfer buffer address.
- `$C620` `wInfraredTransferLengthLo` — low byte of transfer length on entry. After a leading partial chunk is handled, the controller reuses this byte as the progress-display step counter beginning at 4.
- `$C621` `wInfraredTransferLengthHi` — count of full 256-byte transfer chunks remaining after the low-byte tail.
- `$C622` `wInfraredTransferBufferBank` — ROM/WRAM bank value forwarded in `B` to the Bank `$18` buffered send/receive API.

The unusual reuse of `$C620` is byte-proven by `InfraredController_TransferChunks`; the source deliberately documents both lifetimes rather than inventing a second physical variable.
