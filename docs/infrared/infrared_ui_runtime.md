# Infrared interface / connection UI

the project source-backs physical Bank `$18:$55F2-$58B7` (**710 bytes**, SHA-1 `61c895ba441c0ee2ccd143957a373ea2bda8514d`) as the user-facing layer between the high-level infrared session API (`$53D7-$55F1`) and low-level framed transport (`$58B8-$5BC7`).

## Proven layout

- `$55F2-$56AF` — `InfraredUI_Initialize`, screen/tilemap/palette setup.
- `$56B0-$56D3` — two positioning instruction lines. Through the project's existing main character map they read: point the infrared-port triangle marks toward each other and bring the systems close together.
- `$56D4-$5721` — `InfraredUI_DrawConnectionStatus`.
- `$5722-$572B` — five symbolic 16-bit status pointers.
- `$572C-$5777` — Preparing, Waiting, Communicating, Connection failed, Communication error.
- `$5778-$5809` — `InfraredUI_DrawPrompt`, a two-line prompt renderer.
- `$580A-$5811` — four symbolic 16-bit prompt pointers.
- `$5812-$588F` — Ready/press A; wait with A-to-cancel; restart and press any button; restart and press A.
- `$5890-$58B7` — `InfraredUI_LoadPromptGraphics`.

The names above are backed by decoding the exact retail bytes with the already-present `charmaps/char_main.inc` mapping. The byte payload remains Japanese retail verification data in this module; no translated/custom English asset is overwritten or replaced.

## Runtime structure

Both renderers stage text through WRAM around `$DB5A`, switch WRAM bank state temporarily, pad/terminate their scratch lines, and call the existing text/tilemap helpers. This gives the complete `$53D7-$5BC7` infrared feature a clean three-layer source organization: session/transfer API, connection UI, framed transport.
