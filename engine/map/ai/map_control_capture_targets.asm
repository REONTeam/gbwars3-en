include "macros/macros.inc"

; Capture-target classification used by the Bank $0D map-control analysis.
; These helpers are in physical Bank $0B and operate on the low-six-bit raw
; map tile ID returned by MapTile_GetBaseIdAtCoordinates / the ROM0 grid reader.

; The phase-ownership classifier at $0B:$7CF7 is emitted by data/terrain.asm.
; MapTile_GetPhaseOwnershipClass is a canonical alias there; this module owns only
; the capture-target filter below.

section "Map Control Capture Target Filter", romx[$7d33], bank[$0b]

; A = raw map tile ID.
; Returns A = 0 only for a property that is a valid capture target for the
; active side: an opposing-side property or an intact neutral property.
; Returns A = 1 for active-side properties, ordinary terrain, and the four
; neutral ruined-property variants. This inverted result is the retail
; contract consumed by MapControl_RebuildCaptureTargetMask.
MapControl_IsCaptureTargetRejected::
    cp MAP_TILE_NEUTRAL_CITY_RUINS
    jr z, .reject
    cp MAP_TILE_NEUTRAL_BASE_RUINS
    jr z, .reject
    cp MAP_TILE_NEUTRAL_AIRPORT_RUINS
    jr z, .reject
    cp MAP_TILE_NEUTRAL_PORT_RUINS
    jr z, .reject

    call MapTile_GetPhaseOwnershipClass
    cp 0
    jr z, .reject
    cp 3
    jr z, .reject
    xor a
    jr .done

.reject
    ld a, 1
.done
    ret

    assert @ == $7d54
