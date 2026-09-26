include "macros/macros.inc"
include "constants/unit_constants.inc"

; Ten user-map SRAM slots. Each two-byte entry stores the SRAM bank followed
; by the high byte of the slot base address; every slot begins at xx00.
section "Map SRAM Slot Locations", rom0[$391c]
MapSRAMSlotLocations::
    db $07, HIGH($a000)
    db $07, HIGH($b000)
    db $08, HIGH($a000)
    db $08, HIGH($b000)
    db $09, HIGH($a000)
    db $09, HIGH($b000)
    db $0a, HIGH($a000)
    db $0a, HIGH($b000)
    db $0b, HIGH($a000)
    db $0b, HIGH($b000)

; Validate the seven-byte Game Boy Wars 3 SRAM signature at bank 0:$A000.
; Returns A = 0 when valid, A = 1 on the first mismatch.
section "SRAM Signature Check", rom0[$3930]
SRAM_CheckSignature::
    ld a, 0
    call SwitchSRAMBank
    call SRAM_Enable
    ld hl, $a000
    ld a, [hli]
    cp $47
    jr nz, .invalid
    ld a, [hli]
    cp $42
    jr nz, .invalid
    ld a, [hli]
    cp $57
    jr nz, .invalid
    ld a, [hli]
    cp $33
    jr nz, .invalid
    ld a, [hli]
    cp $00
    jr nz, .invalid
    ld a, [hli]
    cp $09
    jr nz, .invalid
    ld a, [hli]
    cp $14
    jr nz, .invalid
    xor a
    jr .done
.invalid
    ld a, 1
.done
    ret

; Write the same seven-byte signature to bank 0:$A000.
section "SRAM Signature Write", rom0[$3964]
SRAM_WriteSignature::
    ld a, 0
    call SwitchSRAMBank
    call SRAM_Enable
    ld hl, $a000
    ld a, $47
    ld [hli], a
    ld a, $42
    ld [hli], a
    ld a, $57
    ld [hli], a
    ld a, $33
    ld [hli], a
    ld a, $00
    ld [hli], a
    ld a, $09
    ld [hli], a
    ld a, $14
    ld [hli], a
    call SRAM_Disable
    ret

    assert @ == $3988

; Erase every 8 KiB external-RAM bank used by the cartridge, recreate the
; GBW3 SRAM signature, restore the retail FF-filled default block, and reset
; the network-registration backing state. This is the destructive operation
; used by the hidden startup absolute-erasure prompt.
section "SRAM Absolute Erase", rom0[$3988]
SRAM_EraseAllAndReinitialize::
    call SRAM_Enable
    ld d, 0
.bank_loop
    ld a, d
    call SwitchSRAMBank
    ld hl, $a000
    ld bc, $2000
    xor a
    call Memset
    inc d
    ld a, d
    cp $10
    jr nz, .bank_loop

    call SRAM_WriteSignature
    call SRAM_Enable
    ld a, 0
    call SwitchSRAMBank
    ld hl, $a012
    ld bc, $003c
    ld a, $ff
    call Memset
    call SRAM_Disable
    farcall $19, NetworkPersistent_ResetAndInitialize
    ld a, 0
    call SwitchSRAMBank
    call SRAM_Disable
    ret

    assert @ == $39c7

; A = user-map SRAM slot index (0-9).
; Load the same 46-byte map prefix used by ROM-backed records into the shared
; wMapRecord* buffer. The final flag bit is retained exactly as retail; its
; higher-level meaning remains intentionally unnamed until its writer/consumer
; path is fully sourced.
section "Map SRAM Record Loader", romx[$5dcc], bank[$13]
MapRecord_LoadSRAMSlotPrefix::
    push af
    add a
    ld hl, MapSRAMSlotLocations
    call AddAtoHL
    call SRAM_Enable
    ld a, [hli]
    call SwitchSRAMBank
    ld [wMapRecordFarPointer], a
    xor a
    ld [wMapRecordFarPointer + 1], a
    ld e, a
    ld a, [hli]
    ld [wMapRecordFarPointer + 2], a
    ld d, a

    ld hl, wMapRecordBuffer
    ld bc, $0020
    call Memcpy
    ld hl, wMapRecordName
    ld bc, MAP_RECORD_NAME_SIZE
    call Memcpy
    ld hl, wMapRecordFields
    ld bc, $0006
    call Memcpy

    ld a, 0
    call SwitchSRAMBank

    pop af
    ld hl, $a00f
    call Bitfield_Test
    jr z, .clear_flag
    xor a
    set 1, a
    jr .store_flag
.clear_flag
    xor a
.store_flag
    ld [wMapRecordFlags], a
    call SRAM_Disable
    ret

    assert @ == $5e1e
; B = source user-map slot (0-9), C = destination user-map slot (0-9).
; Copy the complete fixed 4 KiB slot through WRAM bank 5 staging.
section "Map SRAM Slot Copy", romx[$5e1e], bank[$13]
MapSRAM_CopySlot::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af

    ld a, MAP_SRAM_STAGING_WRAM_BANK
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, b
    ld b, MAP_SRAM_STAGING_WRAM_BANK
    call MapSRAM_LoadSlotToWRAMBank

    ld a, c
    ld b, MAP_SRAM_STAGING_WRAM_BANK
    call MapSRAM_SaveSlotFromWRAMBank

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

; A = user-map SRAM slot index (0-9). Clear its presence bit in SRAM bank 0.
section "Map SRAM Slot Presence Clear", romx[$5e3f], bank[$13]
MapSRAM_ClearSlotPresent::
    push bc
    ld b, a
    call SRAM_Enable
    xor a
    call SwitchSRAMBank
    ld hl, MAP_SRAM_SLOT_PRESENT_BITS
    ld a, b
    call Bitfield_Clear
    call SRAM_Disable
    pop bc
    ret

; A = user-map SRAM slot index (0-9), B = WRAM bank.
; Copy the complete 4 KiB SRAM slot to B:$D000.
section "Map SRAM Slot Load to WRAM", romx[$5e55], bank[$13]
MapSRAM_LoadSlotToWRAMBank::
    push bc
    push de
    ld c, a
    ldh a, [hWRAMBank]
    push af
    call SRAM_Enable

    ld a, b
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, c
    add a
    ld hl, MapSRAMSlotLocations
    call AddAtoHL
    ld a, [hli]
    call SwitchSRAMBank
    ld d, [hl]
    ld e, LOW($a000)
    ld hl, MAP_SRAM_STAGING_ADDR
    ld bc, MAP_SRAM_SLOT_SIZE
    call Memcpy

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; A = user-map SRAM slot index (0-9), B = WRAM bank.
; Copy B:$D000 to the complete 4 KiB SRAM slot, then mark the slot present.
section "Map SRAM Slot Save from WRAM", romx[$5e83], bank[$13]
MapSRAM_SaveSlotFromWRAMBank::
    push bc
    push de
    ld c, a
    ldh a, [hWRAMBank]
    push af
    call SRAM_Enable

    ld a, b
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    push bc
    ld a, c
    add a
    ld hl, MapSRAMSlotLocations
    call AddAtoHL
    ld a, [hli]
    call SwitchSRAMBank
    ld h, [hl]
    ld l, LOW($a000)
    ld de, MAP_SRAM_STAGING_ADDR
    ld bc, MAP_SRAM_SLOT_SIZE
    call Memcpy

    pop bc
    ld a, 0
    call SwitchSRAMBank
    ld hl, MAP_SRAM_SLOT_PRESENT_BITS
    ld a, c
    call Bitfield_Set
    call SRAM_Disable

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

    assert @ == $5ec2


; A = user-map slot index. Serialize the current editor/runtime state into the
; selected fixed 4 KiB SRAM slot. This routine is kept intentionally
; conservative: the individual runtime buffers are named only by storage role
; until their game semantics are corroborated by their own consumers.
section "Map SRAM Slot Serializer", romx[$5ec2], bank[$13]
MapSRAM_SerializeSlot::
    ld b, a
    ld a, 0
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, b
    ld hl, MapSRAM_MetadataAddressTable
    call WordTable_Get
    ld a, $0c
    call AddAtoHL
    ld a, [wActiveGameMode]
    call Bitfield_Set
    ld a, b
    call $5b2d
    ld a, [hli]
    call SwitchSRAMBank
    ld h, [hl]
    ld l, $00
MapSRAM_SerializeAtBase::
    push hl
    ld a, [wMapViewportOriginX]
    ld [hli], a
    ld a, [wMapViewportOriginY]
    ld [hli], a
    ld a, [wMapCursorOffsetX]
    ld [hli], a
    ld a, [wMapCursorOffsetY]
    ld [hli], a
    ld a, [wMapPhaseNumber]
    ld [hli], a
    ld a, [wMapSide0Gold]
    ld [hli], a
    ld a, [wMapSide0Gold + 1]
    ld [hli], a
    ld a, [wMapSide0Gold + 2]
    ld [hli], a
    ld a, [wMapSide1Gold]
    ld [hli], a
    ld a, [wMapSide1Gold + 1]
    ld [hli], a
    ld a, [wMapSide1Gold + 2]
    ld [hli], a
    ld a, [wMapSide0Materials]
    ld [hli], a
    ld a, [wMapSide0Materials + 1]
    ld [hli], a
    ld a, [wMapSide1Materials]
    ld [hli], a
    ld a, [wMapSide1Materials + 1]
    ld [hli], a
    call .pack_wram3_records
    call .copy_wram1_block
    push hl
    call MapSRAM_SerializeMapGrid
    ld a, $ff
    ld [hli], a
    pop de
    call MapSRAM_WriteStreamMetadata
    pop hl
    push hl
    call SRAM_Enable
    ld de, $0f1a
    add hl, de
    ld de, $c8b3
    ld bc, $0008
    call Memcpy
    pop hl
    ld de, $0f18
    add hl, de
    ld a, [wActiveGameMode]
    ld [hli], a
    ld a, [$c883]
    ld [hli], a
    ld a, h
    and $f0
    ld h, a
    ld l, $00
    call $621b
    call SRAM_Disable
    ret

.pack_wram3_records
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $d000
    ld c, UNIT_RECORD_COUNT
.loop_records
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    swap a
    ld b, a
    inc de
    ld a, [de]
    or b
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    swap a
    ld b, a
    inc de
    ld a, [de]
    or b
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    inc de
    ld a, [de]
    ld [hli], a
    ; Offsets 12-15 are runtime-only and are not serialized. Offset 11 was
    ; copied immediately above. Advance to the next 16-byte live record.
    rept UNIT_RECORD_NEXT_AFTER_OFFSET11_ADVANCE
        inc de
    endr
    dec c
    jr nz, .loop_records
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

.copy_wram1_block
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $dd80
    ld bc, $012d
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

MapSRAM_SerializeMapGrid::
.copy_map_grid
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $c885
    ld bc, $002e
    call Memcpy
    ld de, $d000
    ld c, $00
.row
    ld b, $00
    push de
.column
    ld a, [de]
    ld [hli], a
    inc de
    inc b
    ld a, [$c8b1]
    cp b
    jr nz, .column
    pop de
    ld a, e
    add $40
    ld e, a
    ld a, d
    adc $00
    ld d, a
    inc c
    ld a, [$c8b2]
    cp c
    jr nz, .row
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; Retail helper retained at $5FFD-$6038. It scans the WRAM-bank-2
; 64-byte-stride map plane and appends (x, y, value) triples for nonzero cells.
; No sourced caller currently reaches this entry, so keep it local/structural.
MapSRAM_SerializeSparseGridRecords::
.copy_nonzero_wram2_grid_records
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $d000
    ld c, $00
.row_sparse
    ld b, $00
    push de
.column_sparse
    ld a, [de]
    and a
    jr z, .skip_sparse
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    ld [hli], a
.skip_sparse
    inc b
    inc de
    ld a, [$c8b1]
    cp b
    jr nz, .column_sparse
    pop de
    ld a, e
    add $40
    ld e, a
    ld a, d
    adc $00
    ld d, a
    inc c
    ld a, [$c8b2]
    cp c
    jr nz, .row_sparse
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

; Write map header body-length and checksum metadata for the serialized body.
; The checksum is the low byte of the sum of every body byte, including $FF.
MapSRAM_WriteStreamMetadata::
.write_stream_metadata
    push bc
    push de
    push hl
    push de
    call Math_SubtractDEFromHL
    ld de, MAP_RECORD_BODY_OFFSET
    call Math_SubtractDEFromHL
    pop de
    push de
    push hl
    ld b, h
    ld c, l
    ld hl, MAP_RECORD_BODY_OFFSET
    add hl, de
    xor a
    ld [wMapChecksumScratch], a
.checksum_loop
    ld a, [wMapChecksumScratch]
    add [hl]
    ld [wMapChecksumScratch], a
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .checksum_loop
    pop hl
    pop de
    inc de
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    inc de
    ld a, [wMapChecksumScratch]
    ld [de], a
    pop hl
    pop de
    pop bc
    ret

    assert @ == $6072

; A = user-map slot index. Restore the fixed editor/runtime regions from the
; selected 4 KiB SRAM slot, then hand the serialized map body to the common
; ROM0 map-body loader. This is the exact inverse of MapSRAM_SerializeSlot.
section "Map SRAM Slot Deserializer", romx[$6072], bank[$13]
MapSRAM_DeserializeSlot::
    call $5b2d
    ld a, [hli]
    call SwitchSRAMBank
    ld [wMapDataBank], a
    ld h, [hl]
    ld l, $00
    push hl
    ld bc, $0524
    add hl, bc
    ld a, l
    ld [wMapDataPointer], a
    ld a, h
    ld [wMapDataPointer + 1], a
    pop hl
    call SRAM_Enable
MapSRAM_DeserializeAtBase::
    push hl

    ld a, [hli]
    ld [wMapViewportOriginX], a
    ld a, [hli]
    ld [wMapViewportOriginY], a
    ld a, [hli]
    ld [wMapCursorOffsetX], a
    ld a, [hli]
    ld [wMapCursorOffsetY], a
    ld a, [hli]
    ld [wMapPhaseNumber], a
    ld a, [hli]
    ld [wMapSide0Gold], a
    ld a, [hli]
    ld [wMapSide0Gold + 1], a
    ld a, [hli]
    ld [wMapSide0Gold + 2], a
    ld a, [hli]
    ld [wMapSide1Gold], a
    ld a, [hli]
    ld [wMapSide1Gold + 1], a
    ld a, [hli]
    ld [wMapSide1Gold + 2], a
    ld a, [hli]
    ld [wMapSide0Materials], a
    ld a, [hli]
    ld [wMapSide0Materials + 1], a
    ld a, [hli]
    ld [wMapSide1Materials], a
    ld a, [hli]
    ld [wMapSide1Materials + 1], a

    call .unpack_wram3_records
    call .restore_wram1_block
    call .restore_map_body

    pop hl
    push hl
    call SRAM_Enable
    ld de, $0f1a
    add hl, de
    ld d, h
    ld e, l
    ld hl, $c8b3
    ld bc, $0008
    call Memcpy

    pop hl
    ld de, $0f18
    add hl, de
    ld a, [hli]
    ld a, [hli]
    ld [$c883], a
    call SRAM_Disable
    ret

.unpack_wram3_records
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $d000
    ld c, UNIT_RECORD_COUNT
.loop_records
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld b, a
    swap a
    and $0f
    ld [de], a
    inc de
    ld a, b
    and $0f
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld b, a
    swap a
    and $0f
    ld [de], a
    inc de
    ld a, b
    and $0f
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    ; Offsets 12-15 are runtime-only and remain untouched by SRAM restore.
    rept UNIT_RECORD_NEXT_AFTER_OFFSET11_ADVANCE
        inc de
    endr
    dec c
    jr nz, .loop_records
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

.restore_wram1_block
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld d, h
    ld e, l
    ld hl, $dd80
    ld bc, $012d
    call Memcpy
    ld h, d
    ld l, e
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

.restore_map_body
    call MapData_LoadBody
    ret

    assert @ == $6165
