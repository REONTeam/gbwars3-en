include "macros/macros.inc"

; Incremental map-scroll and map-cursor presentation runtime.  The strip queue
; helpers stage the tile range consumed by BasicMapTileUpdate, while the
; completed-scroll helper commits the corresponding viewport origin and SCX/SCY
; change.  The cursor helpers keep absolute map coordinates, viewport-relative
; offsets, and the sprite-object position synchronized.

section "Map strip queue and scroll commit", romx[$4551], bank[$0b]

; Queue the horizontal row exposed by vertical map movement.  Hex-row parity
; requires one extra tile and a one-column-left start on odd rows.
MapTileUpdate_QueueHorizontalStrip::
    push de
    ld d, $0a
    ld a, c
    and $01
    jr z, MapTileUpdate_QueueVerticalStrip.queue
    dec b
    inc d
    jr MapTileUpdate_QueueVerticalStrip.queue

; Queue the nine-tile vertical column exposed by horizontal map movement.
MapTileUpdate_QueueVerticalStrip::
    push de
    ld d, $09

.queue
    ld a, d
    ldh [hMapTileUpdateCount], a
    ld a, b
    ldh [hMapTileUpdateX], a
    ld a, c
    ldh [hMapTileUpdateY], a
    ldh a, [hMapTileUpdateFlags]
    set 7, a
    ldh [hMapTileUpdateFlags], a
    pop de
    ret

    assert @ == $4571

; Apply the direction staged in hMapTileUpdateFlags once the incremental strip
; update reaches its commit phase.  Bits 0/1 move the viewport X origin left or
; right; bits 2/3 move Y up or down.  SCX/SCY mirror the resulting origin in
; 16-pixel map-cell units.
MapTileUpdate_CommitCompletedScroll::
    ldh a, [hMapTileUpdateFlags]
    bit 6, a
    ret z

    bit 0, a
    jr nz, .move_left
    bit 1, a
    jr nz, .move_right
    bit 2, a
    jr nz, .move_up
    bit 3, a
    jr nz, .move_down
    ret

.move_left
    ld a, [wMapViewportOriginX]
    dec a
    ld [wMapViewportOriginX], a
    jr .update_x_scroll

.move_right
    ld a, [wMapViewportOriginX]
    inc a
    ld [wMapViewportOriginX], a

.update_x_scroll
    and $0f
    swap a
    ldh [hSCX], a
    ldh [rSCX], a
    jr .clear_update_flags

.move_up
    ld a, [wMapViewportOriginY]
    dec a
    ld [wMapViewportOriginY], a
    jr .update_y_scroll

.move_down
    res 3, a
    ldh [hMapTileUpdateFlags], a
    ld a, [wMapViewportOriginY]
    inc a
    ld [wMapViewportOriginY], a

.update_y_scroll
    and $0f
    swap a
    ldh [hSCY], a
    ldh [rSCY], a

.clear_update_flags
    xor a
    ldh [hMapTileUpdateFlags], a
    ret

    assert @ == $45c1

section "Map cursor coordinate presentation", romx[$45c1], bank[$0b]

; Rebuild the cursor's absolute map coordinate from viewport origin plus its
; relative on-screen offsets, then reposition its sprite.
MapCursor_UpdateAbsoluteCoordinates::
    ld a, [wMapCursorOffsetX]
    ld b, a
    ld a, [wMapViewportOriginX]
    add b
    ld [wMapActionTargetX], a

    ld a, [wMapCursorOffsetY]
    ld b, a
    ld a, [wMapViewportOriginY]
    add b
    ld [wMapActionTargetY], a
    jr MapCursor_UpdateSpritePosition

; Set the cursor to absolute map coordinates B/C when those coordinates are not
; above/left of the current viewport.  The relative offsets are retained for
; scroll-driven refreshes.
MapCursor_SetMapCoordinates::
    push de
    ld a, [wMapViewportOriginX]
    ld d, a
    ld a, b
    sub d
    jr c, .done
    ld d, a

    ld a, [wMapViewportOriginY]
    ld e, a
    ld a, c
    sub e
    jr c, .done

    ld [wMapCursorOffsetY], a
    ld a, d
    ld [wMapCursorOffsetX], a
    ld a, b
    ld [wMapActionTargetX], a
    ld a, c
    ld [wMapActionTargetY], a
    call MapCursor_UpdateSpritePosition

.done
    pop de
    ret

; Convert viewport-relative hex coordinates to sprite pixels.  Odd map rows are
; offset eight pixels horizontally.
MapCursor_UpdateSpritePosition::
    ld a, [wMapCursorOffsetX]
    swap a
    add $10
    ld b, a
    ld a, [wMapCursorOffsetY]
    swap a
    add $18
    ld c, a
    ld a, [wMapActionTargetY]
    and $01
    jr z, .position
    ld a, b
    add $08
    ld b, a
.position
    ld a, [wMapCursorSpriteObjectId]
    call SpriteObject_SetPosition
    ret

    assert @ == $4621

section "Map cursor graphics and sprite lifetime", romx[$4621], bank[$0b]

; Load the tile graphics used by the map interaction cursor into VRAM bank 0.
MapCursor_LoadGraphics::
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $1aa4
    ld hl, $8600
    ld bc, $01b0
    call $3b59
    ret

; Create the normal map-interaction cursor sprite.
MapCursor_Create::
    ld a, $20
    ld c, $30
    ld b, $0b
    ld de, $1a59
    call SpriteObject_Create
    ld [wMapCursorSpriteObjectId], a
    ld b, $02
    call SpriteObject_SetPalette
    xor a
    ld [wMapCursorSpriteVariant], a
    ret

MapCursor_Destroy::
    ld a, [wMapCursorSpriteObjectId]
    call SpriteObject_Destroy
    ret

; Switch between the normal cursor animation and the highlighted form used when
; Unit Creation is currently legal on the selected property.
MapCursor_UpdatePropertyEligibilityAppearance::
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    ld a, [wMapCursorSpriteVariant]
    and a
    jr nz, .currently_highlighted

    call UnitCreation_GetEligiblePropertyTypeNearHQ
    and a
    jr z, .done
    call MapCursor_UseEligiblePropertyAnimation
    ld a, $01
    ld [wMapCursorSpriteVariant], a
    jr .done

.currently_highlighted
    call UnitCreation_GetEligiblePropertyTypeNearHQ
    and a
    jr nz, .done
    call MapCursor_UseNormalAnimation
    xor a
    ld [wMapCursorSpriteVariant], a
.done
    ret

MapCursor_UseNormalAnimation::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $0b
    ld de, $1a59
    call SpriteObject_SetAnimation
    ret

MapCursor_UseEligiblePropertyAnimation::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $0b
    ld de, $1a61
    call SpriteObject_SetAnimation
    ret

; Alternate cursor animations used by other map interaction states.  Exact
; player-facing identities remain intentionally structural until their callers
; are source-owned.
MapCursor_UseAnimation2::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $0b
    ld de, $1a69
    call SpriteObject_SetAnimation
    ret

MapCursor_UseAnimation3::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $0b
    ld de, $1a6e
    call SpriteObject_SetAnimation
    ret

MapCursor_UseAnimation4::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $0b
    ld de, $1a8a
    call SpriteObject_SetAnimation
    ret

MapCursor_SetPalette2::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $02
    call SpriteObject_SetPalette
    ret

MapCursor_SetPalette3::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $03
    call SpriteObject_SetPalette
    ret

MapCursor_SetPalette4::
    ld a, [wMapCursorSpriteObjectId]
    ld b, $04
    call SpriteObject_SetPalette
    ret

; Create the fixed-position alternate cursor resource used by the adjacent map
; presentation path.
MapCursor_CreateFixedVariant::
    ld a, $20
    ld c, $30
    ld b, $0b
    ld de, $1a82
    call SpriteObject_Create
    ld [wMapCursorSpriteObjectId], a
    ld b, $02
    call SpriteObject_SetPalette
    ld a, [wMapCursorSpriteObjectId]
    ld bc, $585c
    call SpriteObject_SetPosition
    xor a
    ld [wMapCursorSpriteVariant], a
    ret

MapCursor_Show::
    ld a, [wMapCursorSpriteObjectId]
    call SpriteObject_Show
    ret

MapCursor_Hide::
    ld a, [wMapCursorSpriteObjectId]
    call SpriteObject_Hide
    ret

    assert @ == $4707
