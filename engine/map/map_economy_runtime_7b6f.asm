include "macros/macros.inc"

DEF MAP_GOLD_DISPLAY_MAX EQU 99999
DEF MAP_GOLD_DISPLAY_MAX_LOW EQU LOW(MAP_GOLD_DISPLAY_MAX)
DEF MAP_GOLD_DISPLAY_MAX_MID EQU HIGH(MAP_GOLD_DISPLAY_MAX)
DEF MAP_MATERIALS_MAX EQU 999
DEF MAP_ECONOMY_ANALYSIS_RECORD_COUNT EQU 100
DEF MAP_ECONOMY_ANALYSIS_RECORD_SIZE EQU 3
DEF MAP_ECONOMY_ANALYSIS_UNUSED EQU $ff

; Add DE to the current phase side's 24-bit Gold balance. Retail keeps the
; ordinary gameplay range capped at 99,999 by clamping the low two bytes once
; the high byte becomes nonzero and the low word reaches $869F.
section "Map economy Gold and Materials runtime", romx[$7b6f], bank[$0b]
MapEconomy_AddCurrentSideGold::
    push bc
    push hl
    call MapEconomy_GetCurrentSideGoldPointer
    ld a, [hl]
    add e
    ld [hli], a
    ld c, a
    ld a, [hl]
    adc d
    ld [hli], a
    ld b, a
    ld a, [hl]
    adc $00
    ld [hld], a
    and a
    jr z, .done
    ld a, b
    cp MAP_GOLD_DISPLAY_MAX_MID
    jr c, .done
    jr nz, .clamp
    ld a, c
    cp MAP_GOLD_DISPLAY_MAX_LOW
    jr c, .done
.clamp
    ld a, MAP_GOLD_DISPLAY_MAX_MID
    ld [hld], a
    ld a, MAP_GOLD_DISPLAY_MAX_LOW
    ld [hl], a
.done
    pop hl
    pop bc
    ret

    assert @ == $7b98

; Subtract DE from current-side Gold. If the 24-bit subtraction underflows,
; restore the original balance and return carry set. Carry is clear on success.
MapEconomy_TrySubtractCurrentSideGold::
    push bc
    push hl
    call MapEconomy_GetCurrentSideGoldPointer
    ld a, [hl]
    sub e
    ld [hli], a
    ld a, [hl]
    sbc d
    ld [hli], a
    ld a, [hl]
    sbc $00
    ld [hl], a
    jr nc, .done
    call MapEconomy_AddCurrentSideGold
    scf
.done
    pop hl
    pop bc
    ret

    assert @ == $7bb0

; Compare the current side's 24-bit Gold balance against unsigned DE.
; Carry set means balance < DE; carry clear means balance >= DE.
MapEconomy_CheckCurrentSideGoldAtLeastDE::
    push bc
    push hl
    call MapEconomy_GetCurrentSideGoldPointer
    inc hl
    inc hl
    ld a, [hld]
    and a
    jr nz, .enough
    ld a, [hld]
    cp d
    jr c, .insufficient
    jr nz, .enough
    ld a, [hl]
    cp e
    jr c, .insufficient
.enough
    scf
    ccf
    jr .done
.insufficient
    scf
.done
    pop hl
    pop bc
    ret

    assert @ == $7bcd

; Return HL pointing at the three-byte little-endian Gold balance for the
; current phase side.
MapEconomy_GetCurrentSideGoldPointer::
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    ld l, a
    add a
    add l
    ld hl, wMapSide0Gold
    call AddAtoHL
    ret

    assert @ == $7bdc

; Return current-side Materials as a 16-bit value in HL.
MapEconomy_GetCurrentSideMaterials::
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    rlca
    ld hl, wMapSide0Materials
    call AddAtoHL
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

    assert @ == $7bec

; Add DE to current-side Materials and clamp the stored value to 999.
MapEconomy_AddCurrentSideMaterials::
    push de
    push hl
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    rlca
    ld hl, wMapSide0Materials
    call AddAtoHL
    push hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    add hl, de
    ld d, h
    ld e, l
    ld hl, MAP_MATERIALS_MAX
    call Math_CompareHLToDE
    jr c, .store
    ld de, MAP_MATERIALS_MAX
.store
    pop hl
    ld [hl], e
    inc hl
    ld [hl], d
    pop hl
    pop de
    ret

    assert @ == $7c13

; Subtract DE from current-side Materials. Callers establish affordability
; before entering this writer, so the retail routine does not perform an
; underflow check here.
MapEconomy_SubtractCurrentSideMaterials::
    push hl
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    rlca
    ld hl, wMapSide0Materials
    call AddAtoHL
    push hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call Math_SubtractDEFromHL
    ld d, h
    ld e, l
    pop hl
    ld [hl], e
    inc hl
    ld [hl], d
    pop hl
    ret

    assert @ == $7c2f

; Rebuild both sides' income fields from the persisted 100-entry map analysis
; record array in WRAM bank 1. Gold-producing property classes retain the full
; accumulated record value; Base/Factory-class material income is halved.
MapEconomy_RecalculateIncome::
    push de

    ld de, .side0_gold_tiles
    call MapEconomy_SumAnalysisRecordsForTileSet
    ld a, [wMapEconomyAnalysisTotal]
    ld [wMapSide0GoldIncomeDiv10], a
    ld a, [wMapEconomyAnalysisTotal + 1]
    ld [wMapSide0GoldIncomeDiv10 + 1], a

    ld de, .side1_gold_tiles
    call MapEconomy_SumAnalysisRecordsForTileSet
    ld a, [wMapEconomyAnalysisTotal]
    ld [wMapSide1GoldIncomeDiv10], a
    ld a, [wMapEconomyAnalysisTotal + 1]
    ld [wMapSide1GoldIncomeDiv10 + 1], a

    ld de, .side0_material_tiles
    call MapEconomy_SumAnalysisRecordsForTileSet
    ld a, [wMapEconomyAnalysisTotal]
    ld l, a
    ld a, [wMapEconomyAnalysisTotal + 1]
    ld h, a
    srl h
    rr l
    ld a, l
    ld [wMapSide0MaterialsIncome], a
    ld a, h
    ld [wMapSide0MaterialsIncome + 1], a

    ld de, .side1_material_tiles
    call MapEconomy_SumAnalysisRecordsForTileSet
    ld a, [wMapEconomyAnalysisTotal]
    ld l, a
    ld a, [wMapEconomyAnalysisTotal + 1]
    ld h, a
    srl h
    rr l
    ld a, l
    ld [wMapSide1MaterialsIncome], a
    ld a, h
    ld [wMapSide1MaterialsIncome + 1], a

    pop de
    ret

.side0_gold_tiles
    db 4
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_HQ - 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_CITY - 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_AIRPORT - 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_PORT - 1
.side1_gold_tiles
    db 4
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_HQ - 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_CITY - 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_AIRPORT - 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_PORT - 1
.side0_material_tiles
    db 1
    db MAP_TILE_SIDE0_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_BASE - 1
.side1_material_tiles
    db 1
    db MAP_TILE_SIDE1_PROPERTY_FIRST + MAP_PROPERTY_OFFSET_BASE - 1

    assert @ == $7c98

; DE points to a count-prefixed raw-tile-ID set. Scan the 100 persisted
; three-byte records at WRAM-bank-1 $DD81. Active records contribute their
; first-byte value when the terrain at their B/C coordinate matches the set.
MapEconomy_SumAnalysisRecordsForTileSet::
    push bc
    xor a
    ld [wMapEconomyAnalysisTotal], a
    ld [wMapEconomyAnalysisTotal + 1], a
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld hl, wMapEconomyAnalysisRecords
    ld c, MAP_ECONOMY_ANALYSIS_RECORD_COUNT
.loop
    push bc
    ld a, [hli]
    ld [wMapEconomyAnalysisRecordValue], a
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    cp MAP_ECONOMY_ANALYSIS_UNUSED
    jr z, .next
    push hl
    call MapTile_GetBaseIdAtCoordinates
    call MapEconomy_AccumulateRecordForTileSet
    pop hl
.next
    pop bc
    dec c
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop bc
    ret

    assert @ == $7cce

; A is the current record's raw terrain ID and DE points at a count-prefixed
; accepted-ID set. If matched, add the staged record value into the 16-bit
; analysis total.
MapEconomy_AccumulateRecordForTileSet::
    push bc
    push de
    ld b, a
    ld a, [de]
    ld c, a
    inc de
.loop
    ld a, [de]
    inc de
    cp b
    jr z, .matched
    dec c
    jr nz, .loop
    jr .done
.matched
    ld a, [wMapEconomyAnalysisTotal]
    ld l, a
    ld a, [wMapEconomyAnalysisTotal + 1]
    ld h, a
    ld a, [wMapEconomyAnalysisRecordValue]
    call AddAtoHL
    ld a, l
    ld [wMapEconomyAnalysisTotal], a
    ld a, h
    ld [wMapEconomyAnalysisTotal + 1], a
.done
    pop de
    pop bc
    ret

    assert @ == $7cf7
