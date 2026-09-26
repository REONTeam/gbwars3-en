include "macros/macros.inc"

; SRAM slot status, preview metadata, and gameplay-save helpers used by the
; file-select screen. The 9-character name-cache jump at $5A89 is owned by
; engine/map/map_menu.asm and is intentionally interleaved with this runtime.

section "Map SRAM Slot Metadata Runtime A", romx[$58dc], bank[$13]
MapSRAM_GetSlotStatusByte::
    push hl
    ld hl, $a007
    add l
    ld l, a
    ld a, h
    adc $00
    ld h, a
    call $0593
    ld a, $00
    call $058d
    ld a, [hl]
    call $059b
    pop hl
    ret

MapSRAM_HasAnyPrimarySlotData::
    push hl
    ld a, $00
    call MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, MapSRAM_Loc_5913
    ld a, $01
    call MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, MapSRAM_Loc_5913
    ld a, $02
    call MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, MapSRAM_Loc_5913
    xor a
    jr MapSRAM_Loc_5915
MapSRAM_Loc_5913:
    ld a, $01
MapSRAM_Loc_5915:
    pop hl
    ret
MapSRAM_SlotHasCategoryData::
    push bc
    push hl
    ld c, a
    ld a, $00
    call $058d
    call $0593
    ld a, c
    ld hl, $38d4
    call $3a93
    ld a, $0c
    call $29bc
    ld a, b
    call $3ac7
    call $059b
    pop hl
    pop bc
    ret
    push bc
    push hl
    ld c, a
    ld a, $00
    call $058d
    call $0593
    ld a, c
    ld hl, $38d4
    call $3a93
    ld a, $0c
    call $29bc
    ld a, b
    call $3adc
    ld a, c
    ld hl, $a007
    call $29bc
    res 0, [hl]
    call $059b
    pop hl
    pop bc
    ret
MapSRAM_ReadSlotMetadataByte::
    push bc
    ld b, a
    ld a, $00
    call $058d
    call $0593
    ld a, b
    ld hl, $38d4
    call $3a93
    ld b, $00
    add hl, bc
    ld a, [hl]
    call $059b
    pop bc
    ret
MapSRAM_LoadSlotPreviewHeader::
    push bc
    push de
    push hl
    push hl
    ld hl, $38d4
    call $3a93
    call $0593
    ld a, $00
    call $058d
    ld d, h
    ld e, l
    pop hl
    ld bc, $0007
    call $3b50
    call $059b
    pop hl
    pop de
    pop bc
    ret

MapSRAM_CopyCurrentPreviewHeader::
    push bc
    push de
    push hl
    ld d, h
    ld e, l
    ld hl, $c67e
    ld bc, $0007
    call $3b50
    pop hl
    pop de
    pop bc
    ret
MapSRAM_ReadSlotModeByte::
    push de
    ld hl, $38d4
    call $3a93
    ld de, $000d
    add hl, de
    call $0593
    ld a, [hl]
    call $059b
    pop de
    ret
    ld a, [$c685]
    ret
    ld [$c685], a
    ret

MapSRAM_StoreCurrentPreviewHeaderToSlot::
    push bc
    push de
    ld hl, $38d4
    call $3a93
    ld e, l
    ld d, h
    ld hl, $0007
    add hl, de
    call $0593
    ld a, $00
    call $058d
    ld a, [$c685]
    ld [hl+], a
    ld a, [$c686]
    ld [hl], a
    ld hl, $0000
    add hl, de
    ld de, $c67e
    ld bc, $0007
    call $3b50
    call $059b
    pop de
    pop bc
    ret
MapSRAM_LoadSlotMedalFlags::
    push bc
    ld c, a
    call $0593
    ld a, $00
    call $058d
    ld a, c
    ld hl, $38d4
    call $3a93
    ld a, $09
    call $29bc
    ld a, [hl+]
    ld [$cc97], a
    ld a, [hl+]
    ld [$cc98], a
    ld a, [hl+]
    ld [$cc99], a
    call $059b
    pop bc
    ret
MapSRAM_LoadSlotSummaryRow::
    push bc
    push de
    ld c, a
    call $0593
    ld a, $00
    call $058d
    ld a, c
    ld hl, $38d4
    call $3a93
    ld a, $25
    add b
    call $29bc
    ld d, [hl]
    xor a
    ld [$cc94], a
    ld a, b
    cp $00
    jr z, MapSRAM_Loc_5A5A
    cp $01
    jr z, MapSRAM_Loc_5A6A
    ld a, d
    farcall $28, MapRecord_SelectStandard
    ld a, c
    call MapSRAM_Internal_5AFC
    ld a, $3c
    ld [$cc96], a
    jr MapSRAM_Loc_5A78
MapSRAM_Loc_5A5A:
    ld a, d
    farcall $28, MapRecord_SelectBeginner
    ld a, c
    call MapSRAM_Internal_5ABB
    ld a, $10
    ld [$cc96], a
    jr MapSRAM_Loc_5A78
MapSRAM_Loc_5A6A:
    ld a, d
    farcall $28, MapRecord_SelectCampaign
    ld a, c
    call MapSRAM_Internal_5ADB
    ld a, $2d
    ld [$cc96], a
MapSRAM_Loc_5A78:
    call MapMenu_CacheSelectedMapName
    call MapSRAM_Internal_5AA2
    ld a, $00
    call $058d
    call $059b
    pop de
    pop bc
    ret
section "Map SRAM Slot Metadata Runtime B", romx[$5a8c], bank[$13]
    db $41, $ca ; orphaned immediate bytes after the $5A89 name-cache jump
    ld hl, $cc89
    ld bc, $0008
    call $3b50
    xor a
    ld [hl+], a
    ld a, [$ca1f]
    ld [$cc92], a
    pop de
    pop bc
    ret
MapSRAM_Internal_5AA2:
    ld a, $ff
    ld [$cc93], a
    ld a, c
    call MapSRAM_SlotHasCategoryData
    ret z
    call $0593
    ld a, c
    ld de, $0004
    call MapSRAM_Internal_5B48
    ld a, [hl]
    ld [$cc93], a
    ret
MapSRAM_Internal_5ABB:
    push bc
    push de
    ld hl, $38d4
    call $3a93
    ld de, $000f
    add hl, de
    ld a, $10
    call MapSRAM_Internal_5B1D
    ld [$cc95], a
    cp $10
    jr nz, MapSRAM_Loc_5AD8
    ld hl, $cc94
    set 0, [hl]
MapSRAM_Loc_5AD8:
    pop de
    pop bc
    ret
MapSRAM_Internal_5ADB:
    push bc
    push de
    ld hl, $38d4
    call $3a93
    push hl
    ld de, $0011
    add hl, de
    ld a, $2d
    call MapSRAM_Internal_5B1D
    ld [$cc95], a
    pop hl
    ld de, $0028
    add hl, de
    ld a, [hl]
    ld [$cc94], a
    pop de
    pop bc
    ret
MapSRAM_Internal_5AFC:
    push bc
    push de
    ld hl, $38d4
    call $3a93
    push hl
    ld de, $0017
    add hl, de
    ld a, $3c
    call MapSRAM_Internal_5B1D
    ld [$cc95], a
    pop hl
    ld de, $0029
    add hl, de
    ld a, [hl]
    ld [$cc94], a
    pop de
    pop bc
    ret
MapSRAM_Internal_5B1D:
    ld b, a
    ld c, $00
MapSRAM_Loc_5B20:
    ld a, b
    dec a
    call $3ac7
    jr z, MapSRAM_Loc_5B28
    inc c
MapSRAM_Loc_5B28:
    dec b
    jr nz, MapSRAM_Loc_5B20
    ld a, c
    ret
MapSRAM_Internal_5B2D:
    push bc
    ld b, a
    ld a, [$c62f]
    ld c, a
    call MapSRAM_GetCategoryLocationEntry
    pop bc
    ret
MapSRAM_GetCategoryLocationEntry::
    push bc
    ld a, b
    add a
    add a
    add b
    add c
    add a
    ld c, a
    ld b, $00
    ld hl, $38e0
    add hl, bc
    pop bc
    ret
MapSRAM_Internal_5B48:
    ld c, a
    add a
    add a
    add c
    add b
    add a
    ld hl, $38e0
    call $29bc
    ld a, [hl+]
    call $058d
    ld h, [hl]
    ld l, $00
    add hl, de
    ret
MapSRAM_Internal_5B5D:
    cp $03
    jr nc, MapSRAM_Loc_5B67
    ld [$a00d], a
    ld [$cc9b], a
MapSRAM_Loc_5B67:
    ret

MapSRAM_ResetNewSlotState::
    push af
    ld hl, $c67e
    ld bc, $0200
    xor a
    call $3b79
    ld a, $20
    ld [$c67e], a
    ld a, $3d
    ld [$c685], a
    ld a, $01
    ld [$c686], a
    xor a
    ld hl, $c69d
    call $3ad1
    pop af
    call MapSRAM_Internal_5C15
    ret
MapSRAM_SaveGameplayToSlot::
    push bc
    ld b, a
    ld a, [$cc9b]
    call MapSRAM_Internal_5BBB
    ld a, b
    call MapSRAM_Internal_5C15
    ld a, [$cc9a]
    cp $00
    jr z, MapSRAM_Loc_5BA7
    push bc
    ld a, b
    call MapSRAM_SerializeSlot
    pop bc
MapSRAM_Loc_5BA7:
    ld a, b
    call MapSRAM_WriteSlotChecksum
    pop bc
    ret
MapSRAM_SaveActiveMapToSlot::
MapSRAM_Internal_5BAD: ; compatibility alias
    push af
    call MapSRAM_Internal_5C15
    pop af
    push af
    call MapSRAM_SerializeSlot
    pop af
    call MapSRAM_WriteSlotChecksum
    ret
MapSRAM_Internal_5BBB:
    push bc
    cp b
    jr z, MapSRAM_Loc_5BCE
    ld c, $00
    call MapSRAM_Internal_5BD0
    ld c, $01
    call MapSRAM_Internal_5BD0
    ld c, $02
    call MapSRAM_Internal_5BD0
MapSRAM_Loc_5BCE:
    pop bc
    ret
MapSRAM_Internal_5BD0:
    push af
    push bc
    push de
    ld e, a
    call $0593
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [rSVBK], a
    push bc
    ld b, e
    call MapSRAM_GetCategoryLocationEntry
    ld a, [hl+]
    call $058d
    ld d, [hl]
    ld e, $00
    ld hl, $d000
    ld bc, $1000
    call $3b50
    pop bc
    call MapSRAM_GetCategoryLocationEntry
    ld a, [hl+]
    call $058d
    ld h, [hl]
    ld l, $00
    ld de, $d000
    ld bc, $1000
    call $3b50
    call $059b
    pop af
    ldh [$ff82], a
    ldh [rSVBK], a
    pop de
    pop bc
    pop af
    ret
MapSRAM_Internal_5C15:
    push bc
    push de
    push hl
    push af
    ld hl, $38d4
    call $3a93
    call $0593
    ld a, $00
    call $058d
    ld a, [$c62f]
    ld [$c68c], a
    ld de, $c67e
    ld bc, $0200
    call $3b50
    pop af
    call MapSRAM_Internal_5C61
    call MapSRAM_Internal_5B5D
    call MapSRAM_Internal_5CCC
    ld c, a
    ld b, $00
    ld hl, $a007
    add hl, bc
    set 0, [hl]
    ld hl, $38d4
    call $3a93
    ld a, $0c
    call $29bc
    ld a, [$c62f]
    call $3adc
    call $059b
    pop hl
    pop de
    pop bc
    ret
MapSRAM_Internal_5C61:
    push af
    push bc
    push de
    cp $03
    jr nc, MapSRAM_Loc_5C77
    ld de, $c695
    ld hl, $aa97
    ld c, $08
MapSRAM_Loc_5C70:
    ld a, [de]
    inc de
    or [hl]
    ld [hl+], a
    dec c
    jr nz, MapSRAM_Loc_5C70
MapSRAM_Loc_5C77:
    pop de
    pop bc
    pop af
    ret
MapSRAM_LoadSlotStateBlock::
    push bc
    push de
    push hl
    push af
    ld hl, $38d4
    call $3a93
    ld d, h
    ld e, l
    call $0593
    ld a, $00
    call $058d
    ld hl, $c67e
    ld bc, $0200
    call $3b50
    pop af
    call MapSRAM_Internal_5B5D
    call $059b
    pop hl
    pop de
    pop bc
    ret
    push bc
    push de
    push hl
    ld a, [$c62f]
    cp $03
    jr nc, MapSRAM_Loc_5CC8
    ld a, $03
    call MapSRAM_Internal_5BAD
    call $0593
    ld a, $00
    call $058d
    ld a, $01
    ld [$a00e], a
    ld a, [$cc9b]
    ld [$a011], a
    call $059b
MapSRAM_Loc_5CC8:
    pop hl
    pop de
    pop bc
    ret
MapSRAM_Internal_5CCC:
    push af
    ld a, [$c62f]
    cp $03
    jr nc, MapSRAM_Loc_5CE2
    xor a
    ld [$a00e], a
    ld c, $03
    ld b, $00
    ld hl, $a007
    add hl, bc
    res 0, [hl]
MapSRAM_Loc_5CE2:
    pop af
    ret

MapSRAM_LoadResumeSlot::
    ld a, $03
    call MapSRAM_LoadSlotStateBlock
    call $0593
    ld a, $00
    call $058d
    ld a, [$a011]
    ld [$cc9b], a
    ld a, [$a68e]
    call $059b
    ret
