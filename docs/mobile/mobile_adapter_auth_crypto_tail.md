# Mobile Adapter authentication/crypto tail (the project)

the project closes physical Bank `$30` from the project boundary at `$743E` through the end of the bank. Executable/structured content ends at `$7F3F`; `$7F40-$7FFF` is exactly 192 bytes of retail `$FF` padding. Combined with the regression suite, **the complete 16 KiB physical Bank `$30:$4000-$7FFF` is now source-owned**.

## Late protocol states and configuration helpers

`$743E` is a shared transfer-window staging helper reached by earlier HTTP/body states. The protocol dispatcher at `$6198+` selects `$7487` for state values `$1E/$2C`, `$74D5` for `$25-$27`, `$7DFE` for `$28`, `$7EAE` for `$29`, `$7EE9` for `$2A`, `$762E` for `$2D`, and `$75E2` for `$2E`. These state labels remain numeric where the exact public SDK operation is broader than the directly observed packet/state effect.

The `$75A7` helper is behavior-backed as packed telephone-number formatting: it reads high/low nibbles from eight bytes, emits ASCII digits, maps nibble `$A` to `#`, nibble `$B` to `*`, and treats `$F` as termination/padding. State `$2E` contains a `$9A` transaction (`MOBILE_COMMAND_WRITE_CONFIGURATION_DATA | $80`), tying this late family back to the configuration-data path without forcing unsupported names onto every state.

## GB00 authentication, MD5 and Base64

The `$76xx-$7Dxx` family is the Mobile web-authentication codec layer. `$7A11` contains the literal prefix `Authorization: GB00 name="`. The hash implementation is independently identifiable as MD5 from multiple exact fingerprints:

- `$7B3A-$7B49` is the standard MD5 IV, little-endian: `67452301`, `EFCDAB89`, `98BADCFE`, `10325476`.
- `$7B4A-$7C49` contains all 64 standard MD5 K constants, beginning `D76AA478, E8C7B756, 242070DB, C1BDCEEE` and ending `EB86D391`.
- `$7A2C-$7B2B` is a 64-record operation schedule carrying the MD5 message-word/function/rotation sequencing.
- `$79C7/$79D1/$79DB/$79E4/$79EE/$79FC` are four-byte AND, OR, NOT, XOR, add-with-carry and rotate-left primitives used by the round engine.
- `$76F0` stages the standard working state and `$770D` drives the transform loop through the round operation at `$78C5`.

`$7C4A` is a conventional Base64 encoder: it groups source bytes in threes, emits four six-bit characters and applies `=` padding. `$7D03` maps values `0-63` to `A-Z`, `a-z`, `0-9`, `+`, `/`. `$7D22` is the inverse decoder and `$7DB6` maps Base64 ASCII back to six-bit values. These routines are used adjacent to the GB00 Authorization construction path, providing a stronger interpretation than a generic binary/text codec label.

## Verification boundary

The new source reconstructs `$30:$743E-$7FFF` byte-for-byte (**3,010 bytes**, SHA-1 `2faac0cb03c3a903b39d78e92137a212912a7e6d`). The whole physical Bank `$30` hash is `21dd297ef78a093dab18ce9f4da65ff42fc562c9`. `tools/verify_mobile_adapter_auth_crypto_tail.py` checks the complete byte range, the MD5 IV/K-table fingerprints, the GB00 Authorization prefix, Base64 alphabet branches, the major routine boundaries and the `$FF` bank padding.
