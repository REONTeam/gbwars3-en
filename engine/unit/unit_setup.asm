include "macros/macros.inc"
include "constants/unit_constants.inc"

; Clear the 100 live UnitRecord slots (100 * 16 bytes) in WRAM bank 3 and
; reset the two per-side live-unit counters used by map setup.
section "Unit Record Table Reset", romx[$4000], bank[$12]

UnitRecords_ClearAllAndCounts::
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld hl, $d000
    ld bc, 100 * UNIT_RECORD_SIZE
    xor a
    call Memset
    xor a
    ld [wUnitCountBySide], a
    ld [wUnitCountBySide + 1], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $4020

; Small UnitData/WRAM-record helpers used by the map-placement path.
section "Unit Record Access Helpers", romx[$4020], bank[$12]

; A = encoded unit/side byte. The low bit identifies the side; the remaining
; bits select a UnitData entry after shifting right once.
; Returns HL = UnitData definition pointer.
UnitData_GetDefinitionPointer::
    srl a
    ld hl, UnitData
    call WordTable_Get
    ret

; A = unit-record index (0-99). Returns HL = WRAM bank 3 16-byte record.
; See constants/unit_constants.inc for the proven live-record offsets.
UnitRecord_GetAddress::
    push de
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $d000
    add hl, de
    pop de
    ret

; A = encoded unit/side byte, C = byte offset in its UnitData definition.
; Returns A = selected definition byte.
UnitData_GetByte::
    push bc
    push hl
    call UnitData_GetDefinitionPointer
    ld b, 0
    add hl, bc
    ld a, [hl]
    pop hl
    pop bc
    ret

; A = encoded unit/side byte, C = low-byte offset of a little-endian word.
; Returns DE = selected definition word. A is preserved between the two reads.
UnitData_GetWord::
    push af
    call UnitData_GetByte
    ld e, a
    pop af
    inc c
    call UnitData_GetByte
    ld d, a
    ret

    assert @ == $404f

; A = encoded unit/side byte. Copies the fixed 10-byte UnitData display name to
; wUnitNameBuffer and appends a zero terminator.
section "Unit Record Runtime Helpers", romx[$404f], bank[$12]

UnitData_CopyNameToBuffer::
    push bc
    push de
    push hl
    call UnitData_GetDefinitionPointer
    ld d, h
    ld e, l
    ld hl, wUnitNameBuffer
    ld bc, UNIT_DATA_NAME_LENGTH
    call Memcpy
    xor a
    ld [hl], a
    pop hl
    pop de
    pop bc
    ret

; A = live unit index, C = record offset. Returns A = selected byte.
UnitRecord_GetByte::
    push bc
    push hl
    ld b, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    call UnitRecord_GetAddress
    ld b, 0
    add hl, bc
    ld b, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop hl
    pop bc
    ret

; A = live unit index, C = record offset. Returns DE = selected little-endian word.
UnitRecord_GetWord::
    push bc
    push hl
    ld h, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, h
    call UnitRecord_GetAddress
    ld b, 0
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop bc
    ret

; A = live unit index, C = record offset, B = new byte.
UnitRecord_SetByte::
    push hl
    ld l, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    push bc
    ld a, l
    call UnitRecord_GetAddress
    ld b, 0
    add hl, bc
    pop bc
    ld [hl], b
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    ret

; A = live unit index, C = record offset, DE = new little-endian word.
UnitRecord_SetWord::
    push bc
    push hl
    ld h, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, h
    call UnitRecord_GetAddress
    ld b, 0
    add hl, bc
    ld [hl], e
    inc hl
    ld [hl], d
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop bc
    ret

; Add experience to a live unit, clamping at the maximum S-rank threshold.
; A = live unit index, HL = experience to add.
UnitRecord_AddExperienceClamped::
    push bc
    push de
    ld b, a
    ld c, UNIT_RECORD_EXPERIENCE_OFFSET
    call UnitRecord_GetWord
    add hl, de
    ld de, UNIT_EXPERIENCE_MAX
    call Math_CompareHLToDE
    jr c, .store
    ld d, h
    ld e, l
.store
    ld a, b
    call UnitRecord_SetWord
    pop de
    pop bc
    ret

; Convert a live unit's experience total to its rank index.
; A = live unit index. Returns A = UNIT_RANK_D through UNIT_RANK_S.
UnitRecord_GetExperienceRank::
    push bc
    push de
    ld c, UNIT_RECORD_EXPERIENCE_OFFSET
    call UnitRecord_GetWord
    ld bc, UNIT_EXPERIENCE_PER_RANK
    call Math_DivideDEByBC
    ld a, e
    pop de
    pop bc
    ret

; Copy one complete 16-byte live unit record to/from the shared scratch buffer.
; A = live unit index.
UnitRecord_CopyToScratch::
    push bc
    push de
    push hl
    ld b, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    call UnitRecord_GetAddress
    ld d, h
    ld e, l
    ld hl, wUnitRecordScratch
    ld bc, UNIT_RECORD_SIZE
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

UnitRecord_CopyFromScratch::
    push bc
    push de
    push hl
    ld b, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    call UnitRecord_GetAddress
    ld de, wUnitRecordScratch
    ld bc, UNIT_RECORD_SIZE
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

; B/C = X/Y. Returns A = first occupied unit at those coordinates whose
; carried flag is clear, or $FF if none is found.
UnitRecord_FindPrimaryAtCoordinates::
Unit_FindAtCoordinates::
    push bc
    push de
    push hl
    ld d, b
    ld e, c
    ld b, 0
.loop
    ld a, b
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    and a
    jr z, .next
    ld a, b
    ld c, UNIT_RECORD_X_OFFSET
    call UnitRecord_GetByte
    cp d
    jr nz, .next
    ld a, b
    ld c, UNIT_RECORD_Y_OFFSET
    call UnitRecord_GetByte
    cp e
    jr nz, .next
    ld a, b
    ld c, UNIT_RECORD_STATUS_OFFSET
    call UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .found
.next
    inc b
    ld a, b
    cp UNIT_RECORD_COUNT
    jr nz, .loop
    ld a, $ff
    jr .done
.found
    ld a, b
.done
    pop hl
    pop de
    pop bc
    ret

; A = carrier/parent live-unit index, B/C = destination X/Y.
; Every carried child whose parent index matches A inherits the supplied
; coordinates. Children that themselves carry units recurse first, preserving
; nested transport chains.
Unit_MoveCarriedChildrenToCoordinates::
    push bc
    push de
    push hl
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, 0
.loop
    ld a, e
    call UnitRecord_GetAddress
    ld a, [hl]
    and a
    jr z, .next
    ld a, UNIT_RECORD_STATUS_OFFSET
    call AddAtoHL
    ld a, [hl]
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .next
    ld a, e
    call UnitRecord_GetAddress
    ld a, UNIT_RECORD_CARRIER_INDEX_OFFSET
    call AddAtoHL
    ld a, [hl]
    cp d
    jr nz, .next
    ld a, e
    call UnitRecord_GetAddress
    ld a, UNIT_RECORD_CARRIED_COUNT_OFFSET
    call AddAtoHL
    ld a, [hl]
    and a
    jr z, .write_coordinates
    ld a, e
    call Unit_MoveCarriedChildrenToCoordinates
.write_coordinates
    ld a, e
    call UnitRecord_GetAddress
    ld a, UNIT_RECORD_X_OFFSET
    call AddAtoHL
    ld [hl], b
    inc hl
    ld [hl], c
.next
    inc e
    ld a, e
    cp UNIT_RECORD_COUNT
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

    assert @ == $41e3

; Initial-unit placement consumer used by MapData_LoadBody.
; Input tuple: B = X/position byte, C = Y/position byte,
; A = encoded unit type + side (bit 0 selects the 50-record side pool).
section "Map Initial Unit Placement", romx[$41e3], bank[$12]

MapUnit_CreateInitial::
    push bc
    push de
    push hl
    ld d, a
    and $01
    call Unit_FindFreeSlotForSide
    cp $ff
    jr z, .done
    call Unit_InitRecordFromDefinition
.done
    pop hl
    pop de
    pop bc
    ret

; A = free record index, D = encoded unit/side, B/C = placement bytes.
; Initializes the proven type/side, X, Y, HP, fuel and ammo fields in the
; 16-byte WRAM bank 3 record. Unknown bytes retain conservative treatment.
Unit_InitRecordFromDefinition::
    push af
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ld [hli], a
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    xor a
    ld [hli], a
    ld a, d
    ld c, UNIT_DATA_MAX_HP_OFFSET
    call UnitData_GetByte
    ld [hli], a
    xor a
    ld [hli], a
    ld [hli], a
    push hl
    ld a, d
    ld c, UNIT_DATA_MAX_FUEL_OFFSET
    call UnitData_GetByte
    pop hl
    ld [hli], a
    push hl
    ld a, d
    ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET
    call UnitData_GetByte
    pop hl
    ld [hli], a
    push hl
    ld a, d
    ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET
    call UnitData_GetByte
    pop hl
    ld [hli], a
    xor a
    ld [hli], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    and $01
    ld hl, wUnitCountBySide
    call AddAtoHL
    inc [hl]
    pop af
    ret

    assert @ == $4241

; A = encoded unit/side byte. Increment the side-specific 16-bit built-unit
; counter unless it has already reached the retail $FFFF saturation sentinel.
section "Unit Built Counter", romx[$4241], bank[$12]

Unit_IncrementBuiltCountForEncodedSide::
    push af
    push de
    and $01
    add a
    ld hl, wUnitBuiltCountSide0
    call AddAtoHL
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, e
    and d
    cp $ff
    jr z, .done
    inc de
    ld [hl], d
    dec hl
    ld [hl], e
.done
    pop de
    pop af
    ret

    assert @ == $425c

section "Unit Record Deletion", romx[$425c], bank[$12]

; A = live unit index. Deletes that unit plus every carried unit occupying the
; same coordinates. Carried units are identified by status byte $03 bit 0.
Unit_DeleteWithCarriedAtCoordinates::
    push bc
    push de
    push hl
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ld c, UNIT_RECORD_X_OFFSET
    call UnitRecord_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_Y_OFFSET
    call UnitRecord_GetByte
    ld c, a
    ld a, d
    call Unit_DeleteRecord
    ld e, 0
.loop
    push bc
    ld a, e
    ld c, UNIT_RECORD_X_OFFSET
    call UnitRecord_GetByte
    pop bc
    cp b
    jr nz, .next
    push bc
    ld a, e
    ld c, UNIT_RECORD_Y_OFFSET
    call UnitRecord_GetByte
    pop bc
    cp c
    jr nz, .next
    push bc
    ld a, e
    ld c, UNIT_RECORD_STATUS_OFFSET
    call UnitRecord_GetByte
    pop bc
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .next
    ld a, e
    call Unit_DeleteRecord
.next
    inc e
    ld a, e
    cp UNIT_RECORD_COUNT
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

; A = live unit index. Decrements that side's live-unit count, clears the
; complete 16-byte record, then increments that side's lost-unit counter unless the counter is the
; retail $FFFF sentinel.
Unit_DeleteRecord::
    push bc
    push de
    push hl
    ld b, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    ld hl, wUnitCountBySide
    cp UNITS_PER_SIDE
    jr c, .count_selected
    inc hl
.count_selected
    push bc
    dec [hl]
    call UnitRecord_GetAddress
    xor a
    ld bc, UNIT_RECORD_SIZE
    call Memset
    pop bc
    ld hl, wUnitLostCountSide0
    ld a, b
    cp UNITS_PER_SIDE
    jr c, .deletion_counter_selected
    ld hl, wUnitLostCountSide1
.deletion_counter_selected
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, e
    and d
    cp $ff
    jr z, .done
    inc de
    ld [hl], d
    dec hl
    ld [hl], e
.done
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

    assert @ == $42f6

section "Unit Free-Slot Search", romx[$42f6], bank[$12]

; A = side bit (0/1). Returns A = first free record index in that side's
; 50-record pool, or $FF when all 50 records are occupied.
Unit_FindFreeSlotForSide::
    push bc
    ld hl, $d000
    ld b, 0
    and a
    jr z, .selected_pool
    ld hl, $d320
    ld b, UNITS_PER_SIDE
.selected_pool
    ld c, 0
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
.loop
    ld a, [hl]
    and a
    jr z, .found
    ld a, UNIT_RECORD_SIZE
    call AddAtoHL
    inc c
    ld a, c
    cp UNITS_PER_SIDE
    jr nz, .loop
    ld c, $ff
.found
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, c
    add b
    pop bc
    ret

    assert @ == $4329

section "Unit Definition Pair Filters", romx[$4329], bank[$12]

; A and B are encoded unit/side bytes. Tests whether A's carrying/load class
; matches one of B's three accepted carried/load classes. A zero carrying type
; is not a loadable class; otherwise Z is set on a matching carrier slot.
; This is the Bank $12 loading-compatibility helper documented by the ROM map.
UnitData_CheckLoadingCompatibility::
    push bc
    push de
    ld c, UNIT_DATA_CARRYING_TYPE_OFFSET
    call UnitData_GetByte
    cp 0
    jr z, .done
    ld d, a
    ld a, b
    ld c, UNIT_DATA_CARRIED_TYPE1_OFFSET
    call UnitData_GetByte
    cp d
    jr z, .done
    ld a, b
    ld c, UNIT_DATA_CARRIED_TYPE2_OFFSET
    call UnitData_GetByte
    cp d
    jr z, .done
    ld a, b
    ld c, UNIT_DATA_CARRIED_TYPE3_OFFSET
    call UnitData_GetByte
    cp d
.done
    pop de
    pop bc
    ret

; A = recipient encoded unit/side byte, B = candidate supplier encoded
; unit/side byte. Returns A = 0 when the supplier is compatible, A = 1
; otherwise. The sourced $450A caller proves this is the adjacent resupply
; filter: ground units accept the supply-truck family, air units use the
; refueling-plane path with movement-profile exceptions, surface naval units
; accept the supply tanker, and submarines reject adjacent resupply.
Unit_CanReceiveSupplyFrom::
    push bc
    push de
    ld d, a
    srl b
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    call UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr z, .air
    cp UNIT_TARGET_CLASS_SEA
    jr z, .sea
    cp UNIT_TARGET_CLASS_SUBMARINE
    jr z, .reject

    ld a, d
    srl a
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .reject
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .reject
.ground_special
    ld a, b
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .allow
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .allow
    jr .reject

.air
    ld a, d
    srl a
    cp UNIT_TYPE_BOMBER
    jr z, .reject
    cp UNIT_TYPE_MERCENARY_BOMBER
    jr z, .reject
    cp UNIT_TYPE_TRANSPORT_PLANE
    jr z, .reject
    cp UNIT_TYPE_REFUELING_PLANE
    jr z, .reject
    ld a, d
    ld c, UNIT_DATA_MOVEMENT_PROFILE_OFFSET
    call UnitData_GetByte
    cp MOVEMENT_PROFILE_10
    jr z, .ground_special
    cp MOVEMENT_PROFILE_09
    jr z, .ground_special
    ld a, b
    cp UNIT_TYPE_REFUELING_PLANE
    jr z, .allow
    jr .reject

.sea
    ld a, d
    srl a
    cp UNIT_TYPE_SUPPLY_TANKER
    jr z, .reject
    ld a, b
    cp UNIT_TYPE_SUPPLY_TANKER
    jr nz, .reject
.allow
    xor a
    jr .done
.reject
    ld a, 1
.done
    pop de
    pop bc
    ret

    assert @ == $43b9

section "Carried Unit Child List", romx[$43b9], bank[$12]

; A = carrier/parent live-unit index. Rebuilds a compact list of every live
; record whose carried flag is set and whose carrier index equals A.
Unit_BuildCarriedChildList::
    push bc
    push de
    push hl
    ld [wUnitQuerySubjectIndex], a
    xor a
    ld [wCarriedUnitListCount], a
    ld d, 0
.loop
    ld a, d
    ld c, UNIT_RECORD_STATUS_OFFSET
    call UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr z, .next
    ld a, d
    ld c, UNIT_RECORD_CARRIER_INDEX_OFFSET
    call UnitRecord_GetByte
    ld c, a
    ld a, [wUnitQuerySubjectIndex]
    cp c
    jr nz, .next
    ld hl, wCarriedUnitList
    ld a, [wCarriedUnitListCount]
    call AddAtoHL
    ld [hl], d
    ld hl, wCarriedUnitListCount
    inc [hl]
.next
    inc d
    ld a, d
    cp UNIT_RECORD_COUNT
    jr nz, .loop
    pop hl
    pop de
    pop bc
    ret

    assert @ == $43f4

section "Unit Purchase and Promotion Runtime", romx[$43f4], bank[$12]

; A = property/facility class. Rebuilds wBuyableUnitList from one or two
; contiguous UnitData type ranges selected by the retail property class.
UnitPurchase_BuildPropertyUnitList::
    push bc
    push de
    push hl
    ld b, a
    xor a
    ld [wBuyableUnitCount], a
    ld a, b
    cp 4
    jr z, .class4
    cp 6
    jr z, .class6
    cp 9
    jr z, .class9
    ld b, 1
    ld c, 3
    call UnitPurchase_AppendAvailableTypeRange
    ld b, 7
    ld c, $16
    call UnitPurchase_AppendAvailableTypeRange
    jr .done
.class4
    ld b, 1
    ld c, $1c
    call UnitPurchase_AppendAvailableTypeRange
    jr .done
.class6
    ld b, $1d
    ld c, $0f
    call UnitPurchase_AppendAvailableTypeRange
    jr .done
.class9
    ld b, $2c
    ld c, 8
    call UnitPurchase_AppendAvailableTypeRange
.done
    pop hl
    pop de
    pop bc
    ret

; B = first UnitData type, C = number of consecutive types to test.
; Appends each type accepted by UnitPurchase_CheckBuyable.
UnitPurchase_AppendAvailableTypeRange::
    ld hl, wBuyableUnitList
    ld a, [wBuyableUnitCount]
    call AddAtoHL
    ld d, h
    ld e, l
.loop
    ld a, b
    call UnitPurchase_CheckBuyable
    cp UNIT_PURCHASE_FILTER_ALLOWED
    jr nz, .next
    ld a, b
    ld [de], a
    inc de
    ld a, [wBuyableUnitCount]
    inc a
    ld [wBuyableUnitCount], a
.next
    inc b
    dec c
    jr nz, .loop
    ret

; Install the fixed five-entry special/mercenary purchase list.
UnitPurchase_AppendMercenaryTypeRange::
    ld hl, wBuyableUnitList
    ld a, 3
    ld [hli], a
    ld a, $12
    ld [hli], a
    ld a, $1c
    ld [hli], a
    ld a, $24
    ld [hli], a
    ld a, $2d
    ld [hli], a
    ld a, 5
    ld [wBuyableUnitCount], a
    ret

; A = UnitData type index. Returns A = 0 when the type's bit is set in the
; source-backed buyable-type bitfield, otherwise A = 2.
UnitPurchase_CheckBuyable::
    push bc
    ld hl, UnitPurchase_BuyableTypeData
    call Bitfield_Test
    jr nz, UnitPurchase_CheckAllowedList.allowed
    ld a, UNIT_PURCHASE_FILTER_BLOCKED
    jr UnitPurchase_CheckAllowedList.done

; B = UnitData type index. This is a retail continuation entry that shares
; UnitPurchase_CheckBuyable's saved-BC epilogue; do not CALL it independently.
UnitPurchase_CheckAllowedList::
    ld a, [wUnitPurchaseAllowedListSelector]
    call UnitPurchase_GetAllowedListBit
    jr nz, .allowed
    ld a, UNIT_PURCHASE_FILTER_BLOCKED
    jr .done
.allowed
    ld a, UNIT_PURCHASE_FILTER_ALLOWED
.done
    pop bc
    ret

; A = allowed-list pointer-table index, B = UnitData type index.
; Returns A = selected bitfield byte AND bit mask; Z means not present.
UnitPurchase_GetAllowedListBit::
    ld hl, UnitPurchase_AllowedListPointers
    call WordTable_Get
    ld a, b
    call Bitfield_Test
    ret

; A = live unit index. Only S-rank units can promote. Returns A = encoded
; promoted type/side, or 0 when no promotion is available.
UnitPromotion_GetEligibleEncodedType::
    push bc
    ld b, a
    call UnitRecord_GetExperienceRank
    cp UNIT_RANK_S
    jr nz, .not_eligible
    ld a, b
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    ld c, a
    srl a
    call UnitPromotion_GetPromotedType
    add a
    ld b, a
    ld a, c
    and UNIT_TYPE_SIDE_MASK
    add b
    jr .done
.not_eligible
    xor a
.done
    pop bc
    ret

; A = UnitData type index. Returns promoted UnitData type from the 52-byte
; source-backed promotion mapping.
UnitPromotion_GetPromotedType::
    ld hl, UnitPromotionTypeTable
    call AddAtoHL
    ld a, [hl]
    ret

; A = live unit index. If eligible, applies the promoted encoded type, clears
; experience, and refills fuel / both ammunition fields from the promoted
; UnitData definition.
UnitPromotion_Apply::
    push bc
    push de
    ld d, a
    call UnitPromotion_GetEligibleEncodedType
    and a
    jr z, .done
    ld e, a
    farcall CampaignStats_MarkProcuredUnit

    ld a, d
    ld b, e
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_SetByte

    push de
    ld a, d
    ld c, UNIT_RECORD_EXPERIENCE_OFFSET
    ld de, 0
    call UnitRecord_SetWord
    pop de

    ld a, e
    ld c, UNIT_DATA_MAX_FUEL_OFFSET
    call UnitData_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_FUEL_OFFSET
    call UnitRecord_SetByte

    ld a, e
    ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET
    call UnitData_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_WEAPON1_AMMO_OFFSET
    call UnitRecord_SetByte

    ld a, e
    ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET
    call UnitData_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_WEAPON2_AMMO_OFFSET
    call UnitRecord_SetByte
.done
    pop de
    pop bc
    ret

    assert @ == $450a

section "Adjacent Supply Unit List", romx[$450a], bank[$12]

; A = live unit index. Scans the six neighboring hexes and records same-side
; occupied units that have weapon-1 ammunition and pass the UnitData pair
; filter above. The candidate unit IDs observed by that filter are the retail
; supply truck, refueling plane, and supply tanker families, establishing this
; as the adjacent resupply-source list used by later action logic.
Unit_BuildAdjacentSupplyList::
    push bc
    push de
    push hl
    ld [wUnitQuerySubjectIndex], a
    xor a
    ld [wAdjacentSupplyUnitCount], a
    ld a, [wUnitQuerySubjectIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    and a
    jr z, .done
    ld [wUnitQuerySubjectTypeSide], a
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    call UnitData_GetByte
    cp UNIT_TARGET_CLASS_SUBMARINE
    jr z, .done
    ld a, [wUnitQuerySubjectIndex]
    ld c, UNIT_RECORD_X_OFFSET
    call UnitRecord_GetWord
    ld b, e
    ld c, d
    ld e, 0
.direction_loop
    push bc
    push de
    push de
    call HexGrid_GetNeighborCoord
    pop de
    jr c, .next_direction
    call Unit_FindAtCoordinates
    cp $ff
    jr z, .next_direction
    ld d, a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    ld b, a
    and $01
    ld c, a
    ld a, [wUnitQuerySubjectTypeSide]
    and $01
    cp c
    jr nz, .next_direction
    ld a, d
    ld c, UNIT_RECORD_WEAPON1_AMMO_OFFSET
    call UnitRecord_GetByte
    and a
    jr z, .next_direction
    ld a, [wUnitQuerySubjectTypeSide]
    call Unit_CanReceiveSupplyFrom
    and a
    jr nz, .next_direction
    ld a, [wAdjacentSupplyUnitCount]
    ld hl, wAdjacentSupplyUnitList
    call AddAtoHL
    ld [hl], d
    ld hl, wAdjacentSupplyUnitCount
    inc [hl]
.next_direction
    pop de
    pop bc
    inc e
    ld a, e
    cp 6
    jr nz, .direction_loop
.done
    pop hl
    pop de
    pop bc
    ret

    assert @ == $4585

section "Unit Status Flag Maintenance", romx[$4585], bank[$12]

; A = live unit index. Marks the unit as having ended its turn while preserving
; all other live-record status bits.
Unit_SetEndTurnFlag::
    push bc
    push de
    ld d, a
    ld c, UNIT_RECORD_STATUS_OFFSET
    call UnitRecord_GetByte
    set UNIT_RECORD_STATUS_END_TURN_F, a
    ld b, a
    ld a, d
    call UnitRecord_SetByte
    pop de
    pop bc
    ret

; A = side index (0/1). Clears the end-turn flag on every occupied unit in that
; side's 50-record pool, then invokes the existing Bank $0B coordinate helper
; for each affected unit exactly as retail does.
Unit_ClearEndTurnFlagsForSide::
    push bc
    push de
    push hl
    ld d, 0
    and a
    jr nz, .side1
    jr .pool_selected
.side1
    ld d, UNITS_PER_SIDE
.pool_selected
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, UNITS_PER_SIDE
.loop
    ld a, d
    call UnitRecord_GetAddress
    ld a, [hl]
    and a
    jr z, .next
    ld a, d
    call UnitRecord_GetAddress
    ld bc, UNIT_RECORD_STATUS_OFFSET
    add hl, bc
    ld a, [hl]
    res UNIT_RECORD_STATUS_END_TURN_F, a
    ld [hl], a
    ld a, d
    call UnitRecord_GetAddress
    ld bc, UNIT_RECORD_X_OFFSET
    add hl, bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld a, 2
    farcall $0b, MapTile_ClearFlagsAtCoordinates
.next
    inc d
    dec e
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

; A = side index (0/1). Clears the supplied-this-turn flag on every occupied
; unit in that side's live-unit pool.
Unit_ClearSupplyFlagsForSide::
    push bc
    push de
    push hl
    ld d, 0
    and a
    jr nz, .side1
    jr .pool_selected
.side1
    ld d, UNITS_PER_SIDE
.pool_selected
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, UNITS_PER_SIDE
.loop
    ld a, d
    call UnitRecord_GetAddress
    ld a, [hl]
    and a
    jr z, .next
    ld a, d
    call UnitRecord_GetAddress
    ld bc, UNIT_RECORD_STATUS_OFFSET
    add hl, bc
    ld a, [hl]
    res UNIT_RECORD_STATUS_SUPPLIED_F, a
    ld [hl], a
.next
    inc d
    dec e
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

; A = side index (0/1). Returns A = the number of occupied records marked as
; supplied this turn in that side's 50-unit pool.
Unit_CountSuppliedForSide::
    push bc
    push de
    push hl
    ld d, 0
    and a
    jr nz, .side1
    jr .pool_selected
.side1
    ld d, UNITS_PER_SIDE
.pool_selected
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, UNITS_PER_SIDE
    ld b, 0
.loop
    ld a, d
    call UnitRecord_GetAddress
    ld a, [hl]
    and a
    jr z, .next
    ld a, d
    call UnitRecord_GetAddress
    ld a, UNIT_RECORD_STATUS_OFFSET
    call AddAtoHL
    ld a, [hl]
    bit UNIT_RECORD_STATUS_SUPPLIED_F, a
    jr z, .next
    inc b
.next
    inc d
    dec e
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop hl
    pop de
    pop bc
    ret

    assert @ == $4656

; Terrain/property compatibility used by the action runtime before applying
; automatic resupply or repair. A = live unit index, B = encoded unit/side.
; Both services require a current-phase property. Ground families use the
; current HQ/city/base set (construction/supply trucks exclude city), naval
; families use ports, and aircraft differ deliberately: resupply accepts both
; Airport and Runway while repair accepts Airport only. Return A = 0 when the
; current terrain supports the service, $FF otherwise.
section "Unit Terrain Service Compatibility", romx[$4656], bank[$12]

Unit_CanResupplyAtCurrentTerrain::
    push bc
    push de
    ld d, b
    push de
    ld c, UNIT_RECORD_X_OFFSET
    call UnitRecord_GetWord
    ld b, e
    ld c, d
    pop de
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld b, a
    farcall $0b, MapTile_ClassifyOwnershipForCurrentPhase
    cp MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY
    jr nz, .blocked
    ld a, b
    farcall $0b, Terrain_GetNameIndex
    ld b, a
    ld a, d
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    call UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr z, .air
    cp UNIT_TARGET_CLASS_SEA
    jr z, .naval
    cp UNIT_TARGET_CLASS_SUBMARINE
    jr z, .naval
    ld a, d
    srl a
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr z, .ground_service_vehicle
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .ground_service_vehicle
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .ground_service_vehicle
    ld a, b
    cp MOVEMENT_TERRAIN_HQ_1
    jr z, .allowed
    cp MOVEMENT_TERRAIN_CITY
    jr z, .allowed
    cp MOVEMENT_TERRAIN_BASE
    jr z, .allowed
    jr .blocked
.ground_service_vehicle
    ld a, b
    cp MOVEMENT_TERRAIN_HQ_1
    jr z, .allowed
    cp MOVEMENT_TERRAIN_BASE
    jr z, .allowed
    jr .blocked
.air
    ld a, b
    cp MOVEMENT_TERRAIN_AIRPORT
    jr z, .allowed
    cp MOVEMENT_TERRAIN_RUNWAY
    jr z, .allowed
    jr .blocked
.naval
    ld a, b
    cp MOVEMENT_TERRAIN_PORT
    jr z, .allowed
.blocked
    ld a, $ff
    jr .done
.allowed
    xor a
.done
    pop de
    pop bc
    ret

Unit_CanRepairAtCurrentTerrain::
    push bc
    push de
    ld d, b
    push de
    ld c, UNIT_RECORD_X_OFFSET
    call UnitRecord_GetWord
    ld b, e
    ld c, d
    pop de
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld b, a
    ld a, d
    call Unit_CanRepairOnMapTile
    pop de
    pop bc
    ret

; A = encoded unit/side, B = raw base map-tile ID. Return A = 0 when that
; tile can repair the unit, $FF otherwise. This is also used by AI coordinate
; evaluation for hypothetical destination tiles.
Unit_CanRepairOnMapTile::
    push bc
    push de
    ld d, a
    ld a, b
    farcall $0b, MapTile_ClassifyOwnershipForCurrentPhase
    cp MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY
    jr nz, .blocked
    ld a, b
    farcall $0b, Terrain_GetNameIndex
    ld b, a
    ld a, d
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    call UnitData_GetByte
    cp UNIT_TARGET_CLASS_AIR
    jr z, .air
    cp UNIT_TARGET_CLASS_SEA
    jr z, .naval
    cp UNIT_TARGET_CLASS_SUBMARINE
    jr z, .naval
    ld a, d
    srl a
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr z, .ground_service_vehicle
    cp UNIT_TYPE_SUPPLY_TRUCK
    jr z, .ground_service_vehicle
    cp UNIT_TYPE_SUPPLY_TRUCK_S
    jr z, .ground_service_vehicle
    ld a, b
    cp MOVEMENT_TERRAIN_HQ_1
    jr z, .allowed
    cp MOVEMENT_TERRAIN_CITY
    jr z, .allowed
    cp MOVEMENT_TERRAIN_BASE
    jr z, .allowed
    jr .blocked
.ground_service_vehicle
    ld a, b
    cp MOVEMENT_TERRAIN_HQ_1
    jr z, .allowed
    cp MOVEMENT_TERRAIN_BASE
    jr z, .allowed
    jr .blocked
.air
    ld a, b
    cp MOVEMENT_TERRAIN_AIRPORT
    jr z, .allowed
    jr .blocked
.naval
    ld a, b
    cp MOVEMENT_TERRAIN_PORT
    jr z, .allowed
.blocked
    ld a, $ff
    jr .done
.allowed
    xor a
.done
    pop de
    pop bc
    ret

    assert @ == $4741

section "Unit Refill And HP Helpers", romx[$4741], bank[$12]

; A = live unit index. Restore fuel to the UnitData maximum.
Unit_RefillFuelFromDefinition::
    push bc
    push de
    ld d, a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    ld c, UNIT_DATA_MAX_FUEL_OFFSET
    call UnitData_GetByte
    ld b, a
    ld c, UNIT_RECORD_FUEL_OFFSET
    ld a, d
    call UnitRecord_SetByte
    pop de
    pop bc
    ret

; A = live unit index. Restore both ammunition counters from UnitData.
Unit_RefillAmmoFromDefinition::
    push bc
    push de
    ld d, a
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    ld e, a
    ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET
    call UnitData_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_WEAPON1_AMMO_OFFSET
    call UnitRecord_SetByte
    ld a, e
    ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET
    call UnitData_GetByte
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_WEAPON2_AMMO_OFFSET
    call UnitRecord_SetByte
    pop de
    pop bc
    ret

; A = live unit index, B = HP amount to add. Clamp at the UnitData maximum HP.
Unit_AddHPClampedToMax::
    push bc
    push de
    ld d, a
    ld c, UNIT_RECORD_HP_OFFSET
    call UnitRecord_GetByte
    add a, b
    ld b, a
    ld a, d
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    ld c, UNIT_DATA_MAX_HP_OFFSET
    call UnitData_GetByte
    cp b
    jr nc, .store
    ld b, a
.store
    ld a, d
    ld c, UNIT_RECORD_HP_OFFSET
    call UnitRecord_SetByte
    pop de
    pop bc
    ret

    assert @ == $479f

section "Movement Cost Runtime", romx[$479f], bank[$12]

; A = MovementData profile index, B = Terrain_Name_Strings / movement-column index.
; Returns A = raw movement cost for that profile/terrain class. Values are stored
; in sixteenths; zero is used by profiles for terrain they cannot traverse.
MovementData_GetCost::
    push hl
    ld hl, MovementData
    call WordTable_Get
    ld a, b
    call AddAtoHL
    ld a, [hl]
    pop hl
    ret

; A = MovementData profile index. Build the 52-entry raw-map-tile movement-cost
; cache at wMovementCostByMapTile. Terrain_GetNameIndex collapses side/property
; variants to the 23 MovementData columns before each cost is fetched.
MovementData_BuildMapTileCosts::
    push bc
    push de
    ld d, a
    ld e, 0
.loop
    push de
    ld a, e
    farcall $0b, Terrain_GetNameIndex
    ld b, a
    ld a, d
    call MovementData_GetCost
    ld d, 0
    ld hl, wMovementCostByMapTile
    add hl, de
    ld [hl], a
    pop de
    inc e
    ld a, e
    cp $34
    jr nz, .loop
    pop de
    pop bc
    ret

    assert @ == $47ce


section "Reserve Unit Storage", romx[$47ce], bank[$12]

; Store the 50 side-0 live-unit slots in the compact reserve-unit buffer.
; Empty slots remain zero. Occupied entries are four bytes: encoded type/side,
; the little-endian experience total, and $FF. DataCrystal identifies
; $C6A8+ as reserve-unit state, matching the restore path below.
ReserveUnits_SaveSide0::
    push bc
    push de
    ld hl, wReserveUnitList
    ld bc, UNITS_PER_SIDE * 4
    xor a
    call Memset
    ld hl, wReserveUnitList
    ld e, 0
.loop
    push de
    ld a, e
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    and a
    jr z, .next
    ld [hli], a
    ld a, e
    ld c, UNIT_RECORD_EXPERIENCE_OFFSET
    call UnitRecord_GetWord
    ld [hl], e
    inc hl
    ld [hl], d
    inc hl
    ld a, $ff
    ld [hli], a
.next
    pop de
    inc e
    ld a, e
    cp UNITS_PER_SIDE
    jr nz, .loop
    pop de
    pop bc
    ret

; Restore occupied reserve entries into side-0 live-unit slots. New records are
; created off-map at $FF,$FF, marked with the reserve status bit, and have their
; saved experience total restored. Empty reserve entries are skipped.
ReserveUnits_RestoreSide0::
    push bc
    push de
    ld hl, wReserveUnitList
    ld e, 0
.loop
    push de
    push hl
    ld a, [hli]
    and a
    jr z, .next
    ld bc, $ffff
    call MapUnit_CreateInitial
    push af
    ld c, UNIT_RECORD_STATUS_OFFSET
    ld b, 0
    set UNIT_RECORD_STATUS_RESERVE_F, b
    call UnitRecord_SetByte
    pop af
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    ld c, UNIT_RECORD_EXPERIENCE_OFFSET
    call UnitRecord_SetWord
.next
    pop hl
    pop de
    inc hl
    inc hl
    inc hl
    inc hl
    inc e
    ld a, e
    cp UNITS_PER_SIDE
    jr nz, .loop
    pop de
    pop bc
    ret

    assert @ == $4837

; Weapon summary / temporary-unit-list runtime. Byte-authoritatively sourced
; from the Japanese retail ROM in . The adjacent purchase data at
; $497F-$4A42 remains data-owned separately below.
section "Unit Weapon Summary Runtime", romx[$4837], bank[$12]

; A = encoded unit type/side, C = UnitData weapon-slot offset.
; Copies the selected WeaponData 8-byte display name to wUnitNameBuffer and
; appends a zero terminator.
UnitWeapon_CopyNameToBuffer::
    push bc
    push de
    push hl
    call UnitData_GetByte
    ld hl, WeaponData
    call WordTable_Get
    ld d, h
    ld e, l
    ld hl, wUnitNameBuffer
    ld bc, WEAPON_DATA_NAME_LENGTH
    call Memcpy
    ld a, 0
    ld [hli], a
    pop hl
    pop de
    pop bc
    ret

; A = WeaponData index, C = byte offset. Returns A = selected definition byte.
WeaponData_GetByte::
    push bc
    ld hl, WeaponData
    call WordTable_Get
    ld b, 0
    add hl, bc
    ld a, [hli]
    pop bc
    ret

; A = live unit index. Builds the two 14-byte weapon-summary records at
; wUnitWeaponSummaryBuffer from UnitData, WeaponData and live ammo state.
UnitWeapon_BuildSummary::
    push bc
    push de
    push hl
    ld [wUnitQuerySubjectIndex], a

    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    call UnitRecord_GetByte
    ld [wUnitQuerySubjectTypeSide], a

    ; Weapon slot 1.
    ld a, [wUnitQuerySubjectTypeSide]
    ld c, UNIT_DATA_WEAPON1_OFFSET
    call UnitData_GetByte
    ld [wUnitWeaponSummary0WeaponID], a

    ld a, [wUnitQuerySubjectTypeSide]
    ld c, UNIT_DATA_WEAPON1_OFFSET
    call UnitWeapon_CopyNameToBuffer
    ld hl, wUnitWeaponSummary0Name
    ld de, wUnitNameBuffer
    ld bc, UNIT_WEAPON_SUMMARY_NAME_SIZE
    call Memcpy

    ld a, [wUnitWeaponSummary0WeaponID]
    ld c, WEAPON_DATA_MIN_RANGE_OFFSET
    call WeaponData_GetByte
    ld [wUnitWeaponSummary0MinRange], a
    ld a, [hli]
    ld [wUnitWeaponSummary0MaxRange], a

    ld a, [wUnitQuerySubjectIndex]
    ld c, UNIT_RECORD_WEAPON1_AMMO_OFFSET
    call UnitRecord_GetByte
    ld [wUnitWeaponSummary0CurrentAmmo], a

    ld a, [wUnitQuerySubjectTypeSide]
    ld c, UNIT_DATA_WEAPON1_AMMO_OFFSET
    call UnitData_GetByte
    ld [wUnitWeaponSummary0MaxAmmo], a

    ; Weapon slot 2.
    ld a, [wUnitQuerySubjectTypeSide]
    ld c, UNIT_DATA_WEAPON2_OFFSET
    call UnitData_GetByte
    ld [wUnitWeaponSummary1WeaponID], a

    ld a, [wUnitQuerySubjectTypeSide]
    ld c, UNIT_DATA_WEAPON2_OFFSET
    call UnitWeapon_CopyNameToBuffer
    ld hl, wUnitWeaponSummary1Name
    ld de, wUnitNameBuffer
    ld bc, UNIT_WEAPON_SUMMARY_NAME_SIZE
    call Memcpy

    ld a, [wUnitWeaponSummary1WeaponID]
    ld c, WEAPON_DATA_MIN_RANGE_OFFSET
    call WeaponData_GetByte
    ld [wUnitWeaponSummary1MinRange], a
    ld a, [hli]
    ld [wUnitWeaponSummary1MaxRange], a

    ld a, [wUnitQuerySubjectIndex]
    ld c, UNIT_RECORD_WEAPON2_AMMO_OFFSET
    call UnitRecord_GetByte
    ld [wUnitWeaponSummary1CurrentAmmo], a

    ld a, [wUnitQuerySubjectTypeSide]
    ld c, UNIT_DATA_WEAPON2_AMMO_OFFSET
    call UnitData_GetByte
    ld [wUnitWeaponSummary1MaxAmmo], a

    pop hl
    pop de
    pop bc
    ret

; A = encoded unit type/side, B = WeaponData index.
; Returns A = that weapon's attack value for the unit's five-way target class.
UnitWeapon_GetAttackValue::
    push bc
    ld c, UNIT_DATA_TARGET_CLASS_OFFSET
    call UnitData_GetByte
    add WEAPON_DATA_ATTACK_ARMORED_OFFSET
    ld c, a
    ld a, b
    call WeaponData_GetByte
    pop bc
    ret

    assert @ == $490b

section "Temporary Unit List Runtime", romx[$490b], bank[$12]

; Clears the 50 x 16-byte WRAM-bank-3 temporary unit-list workspace.
UnitListScratch_Clear::
    push bc
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld hl, wUnitListScratch
    ld bc, UNIT_LIST_SCRATCH_SIZE
    call Memset
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop bc
    ret

; A = source live-unit index, B = destination scratch-record index.
; Copies one complete 16-byte live record into the temporary list.
UnitListScratch_CopyUnit::
    push bc
    push de
    ld l, a
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, l
    call UnitRecord_GetAddress
    ld d, h
    ld e, l
    ld a, b
    call UnitListScratch_GetRecordPointer
    ld bc, UNIT_RECORD_SIZE
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; A = scratch-record index. Returns HL = record pointer in wUnitListScratch.
UnitListScratch_GetRecordPointer::
    push de
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, wUnitListScratch
    add hl, de
    pop de
    ret

; A = side index. Copies that side's complete 50-record live-unit pool into
; the temporary list.
UnitListScratch_CopySide::
    and a
    jr nz, .side1
    ld hl, $d000
    jr .copy
.side1
    ld hl, $d320
.copy
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, wUnitListScratch
    ld bc, UNIT_LIST_SCRATCH_SIZE
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

    assert @ == $497f

section "Unit Purchase And Promotion Data", romx[$497f], bank[$12]

; Seven-byte purchase-category bitfield/reference payload. Its individual bit
; semantics remain conservative until the $447D consumer is sourced.
UnitPurchase_BuyableTypeData::
    db $b6, $aa, $aa, $6a, $eb, $d6, $07

; Sixteen pointer slots select fifteen distinct seven-byte cumulative allowed-
; unit bitfields. Slots 0 and 1 intentionally share the first record.
UnitPurchase_AllowedListPointers::
    dw UnitPurchase_AllowedList01
    dw UnitPurchase_AllowedList01
    dw UnitPurchase_AllowedList02
    dw UnitPurchase_AllowedList03
    dw UnitPurchase_AllowedList04
    dw UnitPurchase_AllowedList05
    dw UnitPurchase_AllowedList06
    dw UnitPurchase_AllowedList07
    dw UnitPurchase_AllowedList08
    dw UnitPurchase_AllowedList09
    dw UnitPurchase_AllowedList10
    dw UnitPurchase_AllowedList11
    dw UnitPurchase_AllowedList12
    dw UnitPurchase_AllowedList13
    dw UnitPurchase_AllowedList14
    dw UnitPurchase_AllowedList15

    assert @ == $49a6

UnitPurchase_AllowedList01:: db $02, $02, $00, $00, $00, $00, $00
UnitPurchase_AllowedList02:: db $82, $2a, $00, $00, $00, $00, $00
UnitPurchase_AllowedList03:: db $a6, $2a, $20, $02, $00, $00, $00
UnitPurchase_AllowedList04:: db $a6, $aa, $a0, $0a, $00, $00, $00
UnitPurchase_AllowedList05:: db $a6, $aa, $a2, $0a, $00, $04, $00
UnitPurchase_AllowedList06:: db $b6, $aa, $a2, $0a, $00, $04, $00
UnitPurchase_AllowedList07:: db $b6, $aa, $aa, $0a, $80, $04, $00
UnitPurchase_AllowedList08:: db $b6, $aa, $aa, $4a, $80, $04, $00
UnitPurchase_AllowedList09:: db $b6, $aa, $aa, $4a, $a2, $04, $00
UnitPurchase_AllowedList10:: db $b6, $aa, $aa, $6a, $ab, $04, $00
UnitPurchase_AllowedList11:: db $b6, $aa, $aa, $6a, $eb, $04, $00
UnitPurchase_AllowedList12:: db $b6, $aa, $aa, $6a, $eb, $84, $01
UnitPurchase_AllowedList13:: db $b6, $aa, $aa, $6a, $eb, $d4, $01
UnitPurchase_AllowedList14:: db $b6, $aa, $aa, $6a, $eb, $d6, $05
UnitPurchase_AllowedList15:: db $b6, $aa, $aa, $6a, $eb, $d6, $07

    assert @ == $4a0f

; One promotion-result unit-type byte for each non-DUMMY UnitData definition.
UnitPromotionTypeTable::
    db $00, $00, $00, $00, $00, $06, $00, $08
    db $00, $0a, $00, $0c, $00, $0e, $00, $10
    db $00, $00, $00, $14, $00, $16, $00, $18
    db $00, $1a, $00, $00, $00, $1f, $00, $00
    db $22, $00, $00, $00, $00, $00, $28, $00
    db $00, $2b, $00, $00, $00, $00, $00, $00
    db $00, $00, $33, $00

    assert @ == $4a43
