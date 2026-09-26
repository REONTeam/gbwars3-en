include "macros/macros.inc"

; reset the five-byte map/setup scratch block used by the early
; Bank-$0B setup frontend. The exact higher-level roles of $CA9A-$CA9E remain
; structural until later producer/consumer families are source-backed.
; Ownership stops at $763D, which is independently reused.

section "Map setup scratch reset", romx[$762b], bank[$0b]

MapSetup_ResetRuntimeScratchToFF::
    ld a, $ff
    ld [$ca9a], a
    ld [$ca9b], a
    ld [$ca9c], a
    ld [$ca9d], a
    ld [$ca9e], a
    ret

    assert @ == $763d
