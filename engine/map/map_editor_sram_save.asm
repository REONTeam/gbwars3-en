include "macros/macros.inc"

; Save the current Map Editor map into one of the ten user-map SRAM slots.
; A = user-map slot index (0-9). The caller has already validated the two HQs
; and staged the editor map dimensions used by the shared serializer helpers.
section "Map Editor SRAM Save", romx[$5cfe], bank[$13]

MapEditor_SaveCurrentMapToSRAM::
    push bc
    push de
    push hl
    ld b, a
    push bc
    call SRAM_Enable
    ld a, b
    add a, a
    ld hl, MapSRAMSlotLocations
    call AddAtoHL
    ld a, [hli]
    call SwitchSRAMBank
    ld h, [hl]
    ld l, 0
    push hl
    call MapSRAM_SerializeMapGrid
    call MapSRAM_SerializeSparseGridRecords
    ld a, $ff
    ld [hli], a
    pop de
    call MapSRAM_WriteStreamMetadata
    pop bc
    ld a, 0
    call SwitchSRAMBank
    ld a, b
    ld hl, $a00f
    call Bitfield_Set
    call SRAM_Disable
    pop hl
    pop de
    pop bc
    ret

    assert @ == $5d37
