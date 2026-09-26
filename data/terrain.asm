include "macros/macros.inc"
include "constants/bank_ends.inc"
include "charmaps/char_unit.inc"


; Convert a raw map-grid terrain byte to the Terrain_Name_Strings pointer-table
; index. The ROM0 lookup table also captures side/neutral property variants.
section "Terrain Name Index", romx[$4707], bank[$0b]
Terrain_GetNameIndex::
    push hl
    ld hl, TerrainNameIndexByMapTile
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hl]
    pop hl
    ret

    assert @ == $4714

; Raw map-cell accessors. B/C are map X/Y coordinates. Bank 1 stores the
; terrain byte plus two high status bits; bank 2 stores the overlay byte plus
; one high status bit. These helpers preserve the caller's active WRAM bank.
section "Map Tile Runtime Helpers", romx[$4714], bank[$0b]

MapTile_ReadBank1AtCoordinates::
    push bc
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld b, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop bc
    ret

MapTile_ReadBank2AtCoordinates::
    push bc
    ldh a, [hWRAMBank]
    push af
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld b, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop bc
    ret

; A = complete byte to store in the selected map plane.
MapTile_WriteBank1AtCoordinates::
    push bc
    push de
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld [hl], d
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

MapTile_WriteBank2AtCoordinates::
    push bc
    push de
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld [hl], d
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; Return only the six-bit base/raw terrain ID from the bank-1 map byte.
MapTile_GetBaseIdAtCoordinates::
    call MapTile_ReadBank1AtCoordinates
    and $3f
    ret

; A = six-bit base/raw terrain ID. Preserve bank-1 status bits 6-7.
MapTile_SetBaseIdAtCoordinates::
    push bc
    push de
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld a, [hl]
    and $c0
    or d
    ld [hl], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; Return the low seven bits of the bank-2 overlay byte.
MapTile_GetOverlayIdAtCoordinates::
    call MapTile_ReadBank2AtCoordinates
    and $7f
    ret

; A = complete bank-2 overlay byte.
MapTile_SetOverlayByteAtCoordinates::
    call MapTile_WriteBank2AtCoordinates
    ret

; A selects one of three map-cell status bits:
;   0 -> bank 2 bit 7
;   1 -> bank 1 bit 6
;   2 -> bank 1 bit 7
; Nonzero selectors are converted to the bank-1 mask by two RRC operations.
MapTile_SetFlagAtCoordinates::
    and a
    jr z, .bank2_bit7
    push de
    ld e, a
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    rrc e
    rrc e
    ld a, [hl]
    or e
    ld [hl], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    ret
.bank2_bit7
    call MapTile_SetBank2Flag7AtCoordinates
    ret

MapTile_ClearFlagsAtCoordinates::
    and a
    jr z, .bank2_bit7
    push de
    cpl
    rrca
    rrca
    ld e, a
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld a, [hl]
    and e
    ld [hl], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    ret
.bank2_bit7
    call MapTile_ClearBank2Flag7AtCoordinates
    ret

; Clear all three status bits while preserving the six-bit base terrain ID.
MapTile_ClearAllFlagsAtCoordinates::
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    ld a, [hl]
    and $3f
    ld [hl], a
    call MapTile_ClearBank2Flag7AtCoordinates
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

MapTile_SetBank2Flag7AtCoordinates::
    ldh a, [hWRAMBank]
    push af
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    set 7, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

MapTile_ClearBank2Flag7AtCoordinates::
    ldh a, [hWRAMBank]
    push af
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call MapGridCoord
    res 7, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $4822

setcharmap unit
section "Property_Name_Strings", romx[$599c], bank[$0c]
Property_Name_Strings::
    dw .headquarters
    dw .headquarters
    dw .city
    dw .cityRuins
    dw .factory
    dw .factoryRuins
    dw .airport
    dw .airportRuins
    dw .airportTemporary
    dw .port
    dw .portRuins
    dw Property_Name_Strings_comTower

.headquarters
    ;text "シュト"
    text "HQ"
    done

.city
    ;text "トシ"
    text "CITY"
    done

.cityRuins
    ;text "ホウカイトシ"
    text "CITY R"
    done

.factory
    ;text "コウジョウ"
    text "BASE"
    done

.factoryRuins
    ;text "ホウカイコウジョウ"
    text "BASE R"
    done

.airport
    ;text "クウコウ"
    text "AIRPORT"
    done

.airportRuins
    ;text "ホウカイクウコウ"
    text "AIRPORT R"
    done

.airportTemporary
    ;text "カンイクウコウ"
    text "RUNWAY"
    done

.port
    ;text "ミナト"
    text "PORT"
    done

.portRuins
    ;text "ホウカイミナト"
    text "PORT R"
    done

    section_end $59fb

section fragment "Property_Name_Strings_Fragment", romx[bank0c_end_addrA], bank[$0c]
Property_Name_Strings_comTower:
    ;text "ツウシントウ"
    text "COM TOWER"
    done


; Classify a raw base map-tile ID relative to the current phase side.
; $01-$16 are the paired side-owned property ranges, $17-$1F are neutral
; properties/ruins, and $20+ are non-property terrain. The two side-owned
; ranges swap current/opposing meaning with phase parity.
section "Map Tile Phase Ownership Classification", romx[$7cf7], bank[$0b]
MapTile_GetPhaseOwnershipClass::
MapTile_ClassifyOwnershipForCurrentPhase::
    push hl
    cp MAP_TERRAIN_PLAIN
    jr nc, .non_property
    cp MAP_TILE_NEUTRAL_PROPERTY_FIRST
    jr nc, .neutral_property
    cp MAP_TILE_SIDE1_PROPERTY_FIRST
    jr nc, .side1_range
    ld hl, wMapPhaseNumber
    bit 0, [hl]
    jr z, .current_property
    jr .opposing_property
.side1_range
    ld hl, wMapPhaseNumber
    bit 0, [hl]
    jr z, .opposing_property
.current_property
    ld a, MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY
    jr .done
.opposing_property
    ld a, MAP_TILE_PHASE_CLASS_OPPOSING_PROPERTY
    jr .done
.neutral_property
    ld a, MAP_TILE_PHASE_CLASS_NEUTRAL_PROPERTY
    jr .done
.non_property
    ld a, MAP_TILE_PHASE_CLASS_NON_PROPERTY
.done
    pop hl
    ret

    assert @ == $7d24

section fragment "Terrain_Name_Strings", romx[$4f90], bank[$0f]
Terrain_Name_Strings::
    dw .headquarters
    dw .headquarters
    dw .city
    dw .cityRuins
    dw .factory
    dw .factoryRuins
    dw .airport
    dw .airportRuins
    dw .airportTemporary
    dw .port
    dw .portRuins
    dw .comTower
    dw .plain
    dw .road
    dw .bridge1
    dw .bridge2
    dw Terrain_Name_Strings_mountain
    dw Terrain_Name_Strings_wood
    dw Terrain_Name_Strings_wasteland
    dw Terrain_Name_Strings_desert
    dw Terrain_Name_Strings_river
    dw Terrain_Name_Strings_sea
    dw Terrain_Name_Strings_shoal
    
; 9 Character limit, could potentially modify the two menus that display terrain names to free up 4 more characters.
; Alternatively, if each name is padded out to 13 characters, then they'll clear the extra 4 tiles when drawn.
.headquarters:
    ;text "シュト"
    text "HQ"
    done

.city:
    ;text "トシ"
    text "CITY"
    done

.cityRuins:
    ;text "ホウカイトシ"
    text "CITY R" ; City Ruins
    done

.factory:
    ;text "コウジョウ"
    text "BASE"
    done

.factoryRuins:
    ;text "ホウカイコウジョウ"
    text "BASE R" ; Base Ruins
    done

.airport:
    ;text "クウコウ"
    text "AIRPORT"
    done

.airportRuins:
    ;text "ホウカイクウコウ"
    text "AIRPORT R" ; Airport Ruins
    done

.airportTemporary:
    ;text "カンイクウコウ"
    text "RUNWAY" ; Temp Airport
    done

.port:
    ;text "ミナト"
    text "PORT"
    done

.portRuins:
    ;text "ホウカイミナト"
    text "PORT R"
    done

.comTower:
    ;text "ツウシントウ"
    text "COM TOWER"
    done

.plain:
    ;text "ヘイチ"
    text "PLAIN"
    done

.road:
    ;text "ドウロ"
    text "ROAD"
    done

.bridge1:
    ;text "ハシ"
    text "BRIDGE"
    done

.bridge2:
    ;text "ハシ"
    text "BRIDGE"
    done

    section_end $502b

section fragment "Terrain_Name_Strings_Fragment", romx[bank0f_end_addr], bank[$0f]
Terrain_Name_Strings_mountain:
    ;text "ヤマ"
    text "MOUNTAIN"
    done

Terrain_Name_Strings_wood:
    ;text "モリ"
    text "WOOD"
    done

Terrain_Name_Strings_wasteland:
    ;text "アレチ"
    text "WASTELAND"
    done

Terrain_Name_Strings_desert:
    ;text "サバク"
    text "DESERT"
    done

Terrain_Name_Strings_river:
    ;text "カワ"
    text "RIVER"
    done

Terrain_Name_Strings_sea:
    ;text "ウミ"
    text "SEA"
    done

Terrain_Name_Strings_shoal:
    ;text "アサセ"
    text "SHOAL"
    done
