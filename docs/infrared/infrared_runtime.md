# Game Boy Color infrared communication runtime

the project identifies Bank `$18:$53D7+` as the Game Boy Color infrared communication subsystem. The decisive hardware evidence is repeated access to `$FF56`, the CGB infrared register, in the low-level `$58xx-$5Bxx` transport. This matches Game Boy Wars 3's IR multiplayer feature; the range is not a continuation of the battle-scene renderer.

## Source-owned ranges

- `$18:$53D7-$55F1` (**539 bytes**) — session state, link readiness, peer signature verification, one-byte comparison, and buffered send/receive API. SHA-1 `173de9e357348ad4e4631841456dd6c2dc3c3730`.
- `$18:$58B8-$5BC7` (**784 bytes**) — low-level framed transport, IR critical-I/O entry/exit, handshake, packet dispatch, frame descriptor staging, send/receive framing, and link self-test. SHA-1 `245fb6c4e1236e72a9d093edb093046a4c19431f`.

The intervening `$55F2-$58B7` region is deliberately left separate. Its code sets up a screen, renders encoded strings and status lines, and calls the protocol layer, so it is an IR user-interface/presentation layer rather than core transport. Keeping it out of the initial protocol source avoids mixing encoded text with transport semantics.

## Peer signature

`Infrared_PeerSignature` at `$54E5` is exactly nine bytes: `47 42 6F 79 57 41 52 53 33`, ASCII `GBoyWARS3`. `Infrared_VerifyPeerSignature` copies those nine bytes into WRAM bank 4, exchanges them with the remote side, and compares all nine bytes. This is a game/peer handshake marker, not an SRAM file signature.

## Session state

The high-level API consistently uses `$C614-$C618` as five bytes of IR session/result state. Their exact per-byte public contract is only partially proven, so the project intentionally does not assign pret-style `w...` names yet. The bytes distinguish normal state, link/setup state, and several error/result conditions; a later caller pass should name them from the Network/VS menu producers.

## Low-level transport

The `$58B8-$5BC7` layer drives the existing ROM0 `$12xx-$15xx` infrared primitives. It stages packet descriptors at `$C8EC-$C8F5`, dispatches received packet types through a 13-entry table at `$5944`, and chunks larger high-level transfers into `$80`-byte blocks.

The source currently keeps the instruction stream as exact byte rows at stable routine boundaries. This is deliberate: the ROM0 infrared primitives are still address-only, and converting these routines to mnemonic source before their register/flag contracts are established would encourage guessed names. The source ownership and labels are stable; mnemonic conversion can be performed without moving any bytes.
