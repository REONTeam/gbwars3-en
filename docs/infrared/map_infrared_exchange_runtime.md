# Map infrared exchange runtime

Bank `$0C:$6983-$6B43` is the map/Versus frontend around the ROM0 infrared
controller. It connects selected-map state, saved-map slots, and the controller's
shared `$C61C-$C622` transfer descriptor.

## Live battle exchange

`MapInfrared_InitializeBattleState` derives the first transfer owner from the
active phase side and marks the selected map as an infrared battle.

`MapInfrared_RunInitialStateExchange` performs the initial send-first or
receive-first exchange selected by the Versus frontend. Subsequent END/RECV
selected-map commands use `MapInfrared_ExchangeTurnState`, which alternates the
send/receive owner only after a successful transfer.

Every live-map transfer uses a 4 KiB buffer at WRAM bank 7 `$D000`. Before send,
the active map is serialized through SRAM bank `$0D` and copied into that
buffer. After receive, the buffer is copied back through SRAM bank `$0D`,
deserialized into the active map, and the derived unit counts, tile/HQ counts,
and map economy are rebuilt.

## Saved-map transfer

`MapInfrared_SendSelectedMap` loads the chosen map slot into WRAM bank 7 and
transmits it. `MapInfrared_ReceiveSelectedMap` receives into the same transfer
buffer and commits it to the destination saved-map slot only after success.

The ROM0 controller ABI is staged as:

- `wInfraredPeerCompareByte`: exchange phase (`0`, `1`, or selected-map `2`);
- `wInfraredTransferDirection`: `0` send, `1` receive;
- `wInfraredTransferBufferAddress`: `$D000`;
- `wInfraredTransferBufferBank`: `7`;
- transfer length: `$1000` bytes.
