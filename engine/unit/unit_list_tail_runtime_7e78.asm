include "macros/macros.inc"

; Bank $18 Unit List tail closure.
; The 64-byte lookup table and final $FF bank padding remain data. Executable
; helpers are mnemonic. UnitList_Count at $7F5C-$7F61 remains separately owned.

section "Unit List Tail Data Runtime", romx[$7e78], bank[$18]
UnitList_FilterLookupTable::
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f

UnitList_EncodeDisplayValue::
.loop:
    ld a, [hl]
    cp $00
    jr z, .done
    cp $51
    jr c, .below51
    cp $51
    jr z, .value51
    cp $80
    jr z, .value80
    cp $8b
    jr c, .below8b
    cp $a5
    jr c, .belowA5
    cp $a5
    jr z, .valueA5
    cp $a6
    jr z, .valueA6
    cp $a7
    jr z, .valueA7OrOther
.valueA7OrOther:
    ld a, $2d
    jr .store
.valueA6:
    ld a, $2f
    jr .store
.valueA5:
    ld a, $02
    jr .store
.below51:
    add a, $af
    jr .store
.value51:
    ld a, $2d
    jr .store
.value80:
    sub $60
    jr .store
.below8b:
    sub $51
    jr .store
.belowA5:
    sub $4a
    jr .store
.store:
    ld [hl], a
    inc hl
    jr .loop
.done:
    ret

UnitList_RebuildFilteredDisplayBuffer::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld hl, $da5a
    ld bc, $00fa
    xor a
    call $3b79
    ld hl, $da5a
    ld d, $32
    ld e, $00
    ld a, [$c633]
    and $01
    jr z, .sideOffsetReady
    ld e, $32
.sideOffsetReady:
.loop:
    ld a, e
    ld c, $00
    farcall $12, UnitRecord_GetByte
    and a
    jr z, .next
    call UnitList_AppendFilteredRecordFields
.next:
    inc e
    dec d
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

UnitList_AppendFilteredRecordFields::
    ld [hli], a
    ld a, e
    ld c, $04
    farcall $12, UnitRecord_GetByte
    ld [hli], a
    ld a, e
    ld c, $07
    farcall $12, UnitRecord_GetByte
    ld [hli], a
    ld a, e
    farcall $12, UnitRecord_GetExperienceRank
    ld [hli], a
    ld a, e
    ld [hli], a
    ret

    assert @ == $7f5c, "Unit List tail boundary moved"

section "Unit List Tail Runtime End", romx[$7f62], bank[$18]
UnitList_UpdateCountAndFilteredRows::
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    farcall $12, UnitListScratch_Clear
    ld b, $00
    ld a, [$dc66]
    ld c, a
.loop:
    ld a, b
    call UnitList_GetFilteredEntryValue
    farcall $12, UnitListScratch_CopyUnit
    inc b
    dec c
    jr nz, .loop
    ld a, [$c633]
    and $01
    push af
    farcall $12, UnitListScratch_CopySide
    pop af
    call UnitList_ProcessFilteredEntries
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

UnitList_ProcessFilteredEntries::
    push bc
    push de
    ld b, $00
    and a
    jr z, .sideOffsetReady
    ld b, $32
.sideOffsetReady:
    ld a, [$dc66]
    ld c, a
.loop:
    push bc
    ld a, b
    ld c, $03
    farcall $12, UnitRecord_GetByte
    bit 0, a
    jr z, .next
    ld a, b
    ld c, $06
    farcall $12, UnitRecord_GetByte
    cp $32
    jr nc, .upperHalf
    call UnitList_FindMatchingFilteredEntry
    jr .dispatch
.upperHalf:
    call UnitList_FindMatchingFilteredEntry
    add a, $32
.dispatch:
    ld l, a
    ld a, b
    ld b, l
    farcall $12, UnitRecord_SetByte
.next:
    pop bc
    inc b
    dec c
    jr nz, .loop
    pop de
    pop bc
    ret

UnitList_GetFilteredEntryValue::
    push bc
    push de
    farcall UnitList_GetFilteredRecordPointer
    ld de, $0004
    add hl, de
    ld a, [hl]
    pop de
    pop bc
    ret

UnitList_FindMatchingFilteredEntry::
    push bc
    push de
    ld d, a
    ld a, [$dc66]
    ld c, a
    ld b, $00
.loop:
    ld a, b
    call UnitList_GetFilteredEntryValue
    cp d
    jr z, .found
    inc b
    dec c
    jr nz, .loop
.found:
    ld a, b
    pop de
    pop bc
    ret

    db $ff, $ff, $ff, $ff
    assert @ == $8000, "Unit List tail boundary moved"
