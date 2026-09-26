include "macros/macros.inc"

; Validate the ten user-created map slots. Present slots whose serialized-body
; checksum no longer matches are removed from the presence bitfield and reported
; through the shared recovery notice as EDIT DATA 1-10.
section "Map SRAM Editor Slot Validation", romx[$5d54], bank[$13]
MapSRAM_ValidateEditorSaveSlots::
    push bc
    ld b, $00
.loop
    call SRAM_Enable
    ld a, $00
    call SwitchSRAMBank
    ld a, b
    ld hl, $a00f
    call Bitfield_Test
    call SRAM_Disable
    jr z, .next

    ld a, b
    call MapSRAM_VerifyEditorMapSlotChecksum
    jr z, .next

    call SRAM_Enable
    ld a, $00
    call SwitchSRAMBank
    ld a, b
    ld hl, $a00f
    call Bitfield_Clear
    call SRAM_Disable

    ld a, b
    add $07
    farcall MapSave_ShowSlotRecoveryNotice

.next
    inc b
    ld a, b
    cp $0a
    jr nz, .loop
    pop bc
    ret

; A = editor slot index. The user-map record stores its serialized body length
; at +2/+3, body bytes at +$20, and the low-byte additive checksum at +4.
; Returns Z when the checksum matches.
MapSRAM_VerifyEditorMapSlotChecksum::
    push bc
    push de
    push hl

    add a
    ld hl, MapSRAMSlotLocations
    call AddAtoHL
    call SRAM_Enable
    ld a, [hl+]
    call SwitchSRAMBank
    ld d, [hl]
    ld e, $00

    push de
    ld hl, $0002
    add hl, de
    ld c, [hl]
    inc hl
    ld b, [hl]
    pop hl

    push hl
    ld de, $0020
    add hl, de
    ld d, $00
.sum_loop
    ld a, [hl+]
    add d
    ld d, a
    dec bc
    ld a, b
    or c
    jr nz, .sum_loop

    pop hl
    ld a, d
    ld bc, $0004
    add hl, bc
    cp [hl]
    call SRAM_Disable

    pop hl
    pop de
    pop bc
    ret

    assert @ == $5dcc
