include "macros/macros.inc"

; Property capture/development state stored in WRAM bank 1. Each active record
; is three bytes: state value, X, Y. The table has 100 slots; $FF in the state
; field marks an unused record. B/C select map coordinates for the accessors.
;
; Terrain-name classes index a 12-entry pair table. The first byte is the base
; state installed after an ownership/property transition; the second is the
; maximum state used when clamping development progress.

DEF PROPERTY_STATE_RECORD_CAPACITY EQU 100
DEF PROPERTY_STATE_RECORD_SIZE     EQU 3

section "Property State Runtime", romx[$5883], bank[$0c]

; B/C = map coordinates.
; Returns A = current state, or $FF when no record exists.
PropertyState_GetAtCoordinates::
    call PropertyState_FindRecordAtCoordinates
    ret

; A = state value, B/C = map coordinates. No-op when no record exists.
PropertyState_SetAtCoordinates::
    push de
    push hl
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call PropertyState_FindRecordAtCoordinates
    cp $ff
    jr z, .restore_bank
    ld [hl], d
.restore_bank
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    ret

; A = TerrainNameIndexByMapTile class. Returns its maximum property-state value.
PropertyState_GetMaximumForTerrainClass::
    push hl
    add a, a
    ld hl, PropertyState_BaseAndMaximumByTerrainClass
    call AddAtoHL
    inc hl
    ld a, [hl]
    pop hl
    ret

; A = TerrainNameIndexByMapTile class. Returns its base property-state value.
PropertyState_GetBaseForTerrainClass::
    push hl
    add a, a
    ld hl, PropertyState_BaseAndMaximumByTerrainClass
    call AddAtoHL
    ld a, [hl]
    pop hl
    ret

; Compare the current record state at B/C with the maximum for the terrain
; currently occupying B/C. Returns flags from maximum - current; Z means the
; property is already at its maximum state.
PropertyState_CompareCurrentToTerrainMaximum::
    call PropertyState_GetAtCoordinates
    call PropertyState_CompareValueToTerrainMaximum
    ret

; A = state value, B/C = map coordinates. Returns flags from maximum - value
; and leaves A equal to the terrain-class maximum.
PropertyState_CompareValueToTerrainMaximum:
    push de
    ld d, a
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    farcall $0b, Terrain_GetNameIndex
    call PropertyState_GetMaximumForTerrainClass
    cp d
    pop de
    ret

; A = signed delta, B/C = map coordinates. Add the delta to the current record,
; clamp it to 0..terrain maximum, store it, and return the resulting value.
; Missing records ($FF) are left unchanged and return $FF.
PropertyState_ApplySignedDeltaAtCoordinates:
    push bc
    push de
    ld d, a
    call PropertyState_GetAtCoordinates
    cp $ff
    jr z, .done
    add a, d
    ld d, a
    bit 7, d
    jr nz, .clamp_zero
    call PropertyState_CompareValueToTerrainMaximum
    jr c, .store
    ld a, d
    jr .store
.clamp_zero
    xor a
.store
    push af
    call PropertyState_SetAtCoordinates
    pop af
.done
    pop de
    pop bc
    ret

; A = signed state delta, B/C = map coordinates. Apply the state change, then
; animate the visible state one point at a time through the sourced shared meter.
; Returns A = final state.
PropertyState_ApplyDeltaWithPresentation::
    push de
    ld e, a
    call PropertyStateMeter_Setup
    ld a, e
    call PropertyState_GetAtCoordinates
    ld d, a
    ld a, e
    call PropertyState_ApplySignedDeltaAtCoordinates
    ld e, a
.loop
    push bc
    push de
    call Joypad_Update
    call Joypad_Update
    pop de
    pop bc
    ld a, d
    cp e
    jr z, .finish
    jr c, .increment_display
    dec d
    jr .render_step
.increment_display
    inc d
.render_step
    ld a, d
    call PropertyStateMeter_DrawValue
    ld a, $02
    call Audio_PlaySFX
    jr .loop
.finish
    farcall $0b, LCDScanlineTransition_Reset
    farcall $0b, MapCursor_Show
    ld a, e
    pop de
    ret

; Internal scan used by the state getter/setter. B/C = coordinates.
; Returns A = state or $FF. When found, HL points at the record's state byte.
PropertyState_FindRecordAtCoordinates::
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld hl, wMapPropertyStateRecords
    ld e, $00
.loop
    ld d, [hl]
    inc hl
    ld a, [hli]
    cp b
    jr nz, .advance_from_x
    ld a, [hli]
    cp c
    jr nz, .next
    dec hl
    dec hl
    dec hl
    jr .found
.advance_from_x
    inc hl
.next
    inc e
    ld a, e
    cp PROPERTY_STATE_RECORD_CAPACITY
    jr nz, .loop
    ld d, $ff
.found
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    pop de
    ret

; B/C = coordinates. Returns the 0-99 record index, or $FF if absent.
PropertyState_FindRecordIndexAtCoordinates::
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld hl, wMapPropertyStateRecords
    ld e, $00
.loop
    ld a, [hli]
    ld d, [hl]
    inc hl
    ld a, [hli]
    cp c
    jr nz, .next
    ld a, d
    cp b
    jr z, .found
.next
    inc e
    ld a, e
    cp PROPERTY_STATE_RECORD_CAPACITY
    jr nz, .loop
    ld e, $ff
.found
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, e
    pop de
    ret

PropertyState_BaseAndMaximumByTerrainClass::
    db $00, $00
    db $14, $28
    db $0a, $1e
    db $00, $0a
    db $0a, $1e
    db $00, $0a
    db $0a, $1e
    db $00, $0a
    db $0a, $14
    db $0a, $1e
    db $00, $0a
    db $0a, $1e

    assert @ == $599c
