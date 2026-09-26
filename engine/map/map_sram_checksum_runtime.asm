include "macros/macros.inc"

; Validate the six saved-map records. A record whose primary 510-byte checksum
; or any present 4094-byte category payload checksum disagrees is invalidated.
section "Map SRAM Checksum Runtime", romx[$6165], bank[$13]
MapSRAM_ValidateStoredSlots::
    push bc
    push de
    push hl
    ld d, $00
.loop
    ld a, d
    call MapSRAM_GetSlotStatusByte
    and a
    jr z, .next
    ld a, d
    call MapSRAM_ValidateSlotAndCategories
    jr z, .next
    ld a, d
    call MapSRAM_InvalidateCorruptSlot
.next
    inc d
    ld a, d
    cp $06
    jr nz, .loop
    pop hl
    pop de
    pop bc
    ret

MapSRAM_ValidateSlotAndCategories:
    push bc
    push de
    ld c, a
    call MapSRAM_VerifySlotChecksum
    jr nz, .invalid
    ld b, $00
.category_loop
    ld a, c
    call MapSRAM_SlotHasCategoryData
    jr z, .next_category
    push bc
    ld a, c
    ld c, b
    ld b, a
    call MapSRAM_VerifyCategoryChecksum
    pop bc
    jr nz, .invalid
.next_category
    inc b
    ld a, b
    cp $03
    jr nz, .category_loop
.invalid
    pop de
    pop bc
    ret

MapSRAM_InvalidateCorruptSlot:
    push bc
    push de
    ld c, a
    ld b, $00
    call SRAM_Enable
    ld a, $00
    call SwitchSRAMBank
    ld hl, $a007
    add hl, bc
    res 0, [hl]
    ld a, c
    add $00
    farcall $14, MapSave_ShowSlotRecoveryNotice
    ld a, c
    cp $03
    jr nz, .done
    xor a
    ld [$a00e], a
.done
    call SRAM_Disable
    pop de
    pop bc
    ret

; A = slot index. Store the additive checksum of the first $1FE bytes in the
; final two bytes of the slot's $200-byte primary metadata record.
MapSRAM_WriteSlotChecksum::
    push bc
    push de
    push hl
    ld b, a
    call SRAM_Enable
    ld a, $00
    call SwitchSRAMBank
    ld a, b
    call MapSRAM_CalculateSlotChecksum
    ld de, $01fe
    add hl, de
    ld [hl], c
    inc hl
    ld [hl], b
    call SRAM_Disable
    pop hl
    pop de
    pop bc
    ret

MapSRAM_CalculateSlotChecksum:
    ld hl, $38d4
    call WordTable_Get
    ld de, $01fe
    call Checksum16
    ret

; A = slot index. Returns Z when the stored primary-record checksum matches.
MapSRAM_VerifySlotChecksum:
    push bc
    push de
    ld b, a
    call SRAM_Enable
    ld a, $00
    call SwitchSRAMBank
    ld a, b
    call MapSRAM_CalculateSlotChecksum
    ld de, $01fe
    add hl, de
    ld a, [hl+]
    cp c
    jr nz, .done
    ld a, [hl]
    cp b
.done
    call SRAM_Disable
    pop de
    pop bc
    ret

; HL = base of a $1000-byte category payload. Store its additive checksum in
; the final two bytes.
MapSRAM_WriteCategoryChecksum::
    push bc
    push de
    push hl
    ld de, $0ffe
    call Checksum16
    ld de, $0ffe
    add hl, de
    ld [hl], c
    inc hl
    ld [hl], b
    pop hl
    pop de
    pop bc
    ret

; B = slot index, C = category index. Returns HL = category base and BC = the
; checksum of the first $0FFE bytes.
MapSRAM_CalculateCategoryChecksum:
    push de
    call MapSRAM_GetCategoryLocationEntry
    ld a, [hl+]
    call SwitchSRAMBank
    ld h, [hl]
    ld l, $00
    ld de, $0ffe
    call Checksum16
    pop de
    ret

; B = slot index, C = category index. Returns Z when the stored checksum matches.
MapSRAM_VerifyCategoryChecksum:
    call SRAM_Enable
    call MapSRAM_CalculateCategoryChecksum
    ld de, $0ffe
    add hl, de
    ld a, [hl+]
    cp c
    jr nz, .done
    ld a, [hl]
    cp b
.done
    call SRAM_Disable
    ret

    assert @ == $6256
