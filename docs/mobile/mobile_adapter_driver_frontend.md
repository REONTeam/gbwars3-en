# Mobile Adapter driver front-end (the project)

the project begins the Bank `$30` Mobile Adapter GB library conversion at its public ABI boundary rather than at an arbitrary bank offset.

## Source-owned range

`engine/mobile/mobile_adapter_driver.asm` owns Bank `$30:$4000-$4114` (277 bytes, retail SHA-1 `a98c76ccd5836e5e92e80dfd6f5bb1d68704dec5`). The next handler begins at `$4115` and is intentionally left for later work.

The range contains four small library copy/reset helpers, `MobileAdapter_DriverDispatch` at `$4030`, the request-handler pointer table at `$4070`, shared request-channel preparation at `$40B4`, and the local handler selected by request type `$30` at `$40DC`.

## Dispatcher ABI

The ROM0 fixed-bank bridge writes an even-valued request type to `$D188` and enters Bank `$30:$4030`. The driver uses that request byte directly as the byte offset into a word-address table. Consequently request `$00` selects the first word, `$02` the second word, and so on.

The table contains 34 words covering offsets `$00-$42`. The ROM0 `MobileAdapter_CommandTypeTable` only exposes a subset of those values to its caller; `$3E/$40/$42` are therefore retained as internal request IDs until their producers are sourced.

the project adds `constants/mobile_adapter_constants.inc` and rewrites the ROM0 command-type table to use those shared request constants without changing any bytes.

## Naming policy

The request IDs are deliberately named by numeric value (`MOBILE_ADAPTER_REQUEST_XX`) rather than inventing command semantics. Each handler should receive a gameplay/protocol name only after its own state changes, packet format, or higher-level callers establish that role.

The Bank `$30:$56CC` serial-service and `$58E4` LCD/timer-service entry anchors remain symbol-only for now and are the other two authoritative public boundaries for later Mobile passes.
