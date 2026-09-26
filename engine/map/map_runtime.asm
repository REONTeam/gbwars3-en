include "macros/macros.inc"

; Bank $28 map-selection/runtime code immediately preceding the pointer tables.
; Names below stay deliberately functional where higher-level gameplay meaning
; is not yet proven by sourced callers.

section "Map Record Runtime", romx[$4000], bank[$28]

; A = Beginner/Drill map index.
MapRecord_SelectBeginner::
    push bc
    push de
    push hl
    push af
    ld b, MAP_RECORD_CATEGORY_BEGINNER
    ld hl, MapRecordPointers_Beginner
    call MapRecord_SelectPointer
    pop af
    ld hl, wBeginnerMapFlags
    call Bitfield_Test
    jr z, .load
    ld a, [wMapRecordFlags]
    set 0, a
    ld [wMapRecordFlags], a
.load
    call MapRecord_LoadPrefix
    pop hl
    pop de
    pop bc
    ret

; A = Campaign map index.
MapRecord_SelectCampaign::
    push bc
    push de
    push hl
    push af
    ld b, MAP_RECORD_CATEGORY_CAMPAIGN
    ld hl, MapRecordPointers_Campaign
    call MapRecord_SelectPointer
    pop af
    ld c, a
    ld hl, wCampaignMapFlags
    call Bitfield_Test
    jr z, .check_secondary_flag
    ld a, [wMapRecordFlags]
    set 0, a
    ld [wMapRecordFlags], a
.check_secondary_flag
    ld a, c
    ld hl, wCampaignMapSecondaryFlags
    call Bitfield_Test
    jr z, .load
    ld a, [wMapRecordFlags]
    set 2, a
    ld [wMapRecordFlags], a
.load
    call MapRecord_LoadPrefix
    pop hl
    pop de
    pop bc
    ret

; A = Standard map index.
MapRecord_SelectStandard::
    push bc
    push de
    push hl
    push af
    ld b, MAP_RECORD_CATEGORY_STANDARD
    ld hl, MapRecordPointers_Standard
    call MapRecord_SelectPointer
    pop af
    ld hl, wStandardMapFlags
    call Bitfield_Test
    jr z, .load
    ld a, [wMapRecordFlags]
    set 0, a
    ld [wMapRecordFlags], a
.load
    call MapRecord_LoadPrefix
    pop hl
    pop de
    pop bc
    ret

; A = record index, B = category, HL = 3-byte far-pointer table.
MapRecord_SelectPointer::
    call MapRecord_ClearState
    ld d, a
    ld [wMapRecordIndex], a
    ld a, b
    ld [wMapRecordCategory], a
    ld a, d
    add a
    add d
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [hli]
    ld [wMapRecordFarPointer], a
    ld a, [hli]
    ld [wMapRecordFarPointer + 1], a
    ld a, [hli]
    ld [wMapRecordFarPointer + 2], a
    ret

; Clear the selection state, far pointer, flags and loaded 46-byte prefix.
MapRecord_ClearState::
    push af
    push bc
    push hl
    ld hl, wMapRecordFarPointer
    ld bc, $0035
    xor a
    call Memset
    pop hl
    pop bc
    pop af
    ret

; Prepare the map state selected by the current active game mode, then defer
; to the source-backed Bank $13 SRAM-slot prefix loader. The exact higher-level
; record purpose remains intentionally conservative beyond the proven storage path.
MapRuntime_LoadCurrentModeRecord::
    call MapRecord_ClearState
    push af
    ld [wMapRecordIndex], a
    ld a, [wActiveGameMode]
    ld [wMapRecordCategory], a
    pop af
    farcall MapRecord_LoadSRAMSlotPrefix
    ret

; Bank-$0B setup path surrounding a category-specific follow-up hook.
MapRuntime_PrepareSelectedMap::
    ld a, 2
    ldh [hJoyRepeatRate], a
    farcall MapRuntime_PrepareSelectedMapState
    call MapRuntime_HandleStandardIndex30Plus
    farcall $0b, MapRuntime_RunCoordinateSelectionController
    push af
    ld a, 4
    ldh [hJoyRepeatRate], a
    pop af
    ret

; Only applies to category 2 (Standard) and record indices >= 30.
MapRuntime_HandleStandardIndex30Plus::
    ld a, [wActiveGameMode]
    cp GAME_MODE_STANDARD
    ret nz
    ld a, [wMapRecordIndex]
    cp 30
    ret c
    ld hl, wMapSide1HQCoordinates
    ld a, [hli]
    ld b, a
    ld c, [hl]
    farcall $0b, MapViewport_CenterOnCoordinates
    ret

; Return a 0-7 tier derived from groups of flags in the Standard-map bitfield.
; The exact gameplay meaning of the tier remains intentionally unnamed.
MapRuntime_GetStandardFlagTier::
    ld hl, wStandardMapFlags
    ld e, 7
    ld b, 45
    ld c, 58
    call MapRuntime_AreFlagRangeSet
    jr nz, .done
    dec e
    ld a, 44
    call Bitfield_Test
    jr nz, .done
    dec e
    ld b, 30
    ld c, 43
    call MapRuntime_AreFlagRangeSet
    jr nz, .done
    dec e
    ld a, 29
    call Bitfield_Test
    jr nz, .done
    dec e
    ld b, 15
    ld c, 28
    call MapRuntime_AreFlagRangeSet
    jr nz, .done
    dec e
    ld a, 14
    call Bitfield_Test
    jr nz, .done
    dec e
    ld b, 0
    ld c, 13
    call MapRuntime_AreFlagRangeSet
    jr nz, .done
    dec e
.done
    ld a, e
    ret

; Return 1 when Beginner-map flags 0-14 are all set, otherwise 0.
MapRuntime_AreBeginnerFlags0To14Set::
    push bc
    ld hl, wBeginnerMapFlags
    ld b, 0
    ld c, 15
    call MapRuntime_AreFlagRangeSet
    jr z, .clear
    ld a, 1
    jr .done
.clear
    xor a
.done
    pop bc
    ret

; Test all bits in [B, C) against the bitfield at HL.
; Returns NZ only if every tested bit is set.
MapRuntime_AreFlagRangeSet::
.loop
    ld a, b
    call Bitfield_Test
    ret z
    ld a, b
    inc b
    cp c
    jr nz, .loop
    ld a, 1
    and a
    ret

; Two-byte Campaign lookup table. The first byte is the map-specific day limit;
; the second byte remains structurally named until an independent consumer closes it.
MapRuntime_GetCampaignDayLimit::
MapRuntime_GetCampaignTableByte0:: ; compatibility alias
    add a
    ld hl, MapRuntime_CampaignTable
    call AddAtoHL
    ld a, [hl]
    ret

MapRuntime_GetCampaignTableByte1::
    add a
    ld hl, MapRuntime_CampaignTable
    call AddAtoHL
    inc hl
    ld a, [hl]
    ret

MapRuntime_CampaignTable:
    db $1e, $1e, $1e, $1e, $1e, $0d, $1e, $0f, $1e, $10
    db $1e, $0f, $1e, $0f, $1e, $1e, $1e, $1e, $20, $20
    db $20, $0e, $20, $20, $20, $11, $20, $10, $20, $10
    db $20, $12, $20, $13, $20, $14, $22, $12, $22, $22
    db $22, $13, $22, $16, $22, $22, $22, $13, $22, $16
    db $22, $16, $22, $22, $24, $16, $24, $13, $24, $11
    db $24, $14, $24, $13, $24, $11, $24, $17, $24, $18
    db $24, $11, $26, $14, $26, $26, $26, $11, $26, $14
    db $26, $26, $26, $11, $26, $14, $28, $13, $28, $11

; One-byte Beginner map day-limit table.
MapRuntime_GetBeginnerDayLimit::
MapRuntime_GetBeginnerTableValue:: ; compatibility alias
    ld hl, MapRuntime_BeginnerTable
    call AddAtoHL
    ld a, [hl]
    ret

MapRuntime_BeginnerTable:
    db $04, $02, $04, $03, $04, $01, $02, $03
    db $04, $04, $02, $01, $01, $01, $01, $01

    assert @ == $41dc
