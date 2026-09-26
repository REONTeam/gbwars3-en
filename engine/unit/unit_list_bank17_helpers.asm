include "macros/macros.inc"

; Bank $17 Unit List work-buffer and sprite helpers.
;
; Both Unit List record buffers contain 50 fixed five-byte entries.  The first
; buffer is rebuilt from live unit records and is the authoritative filtered
; list used by the controller.  The second buffer is a staging/copy buffer used
; by the filter/category transforms in the Bank $18 Unit List runtime.
DEF wUnitListFilteredRecords EQU $da5a
DEF wUnitListStagingRecords  EQU $db54
DEF UNIT_LIST_WORK_RECORD_SIZE EQU 5

section "Unit List Bank17 Helpers", romx[$7346], bank[$17]

; A = filtered-record index.  Returns HL = &wUnitListFilteredRecords[A].
UnitList_GetFilteredRecordPointer::
    ld b, UNIT_LIST_WORK_RECORD_SIZE
    call MultiplyAByB
    ld b, h
    ld c, l
    ld hl, wUnitListFilteredRecords
    add hl, bc
    ret

; A = staging-record index.  Returns HL = &wUnitListStagingRecords[A].
UnitList_GetStagingRecordPointer::
    ld b, UNIT_LIST_WORK_RECORD_SIZE
    call MultiplyAByB
    ld b, h
    ld c, l
    ld hl, wUnitListStagingRecords
    add hl, bc
    ret

; Clear the Unit List tile/attribute row selected by A.  The row begins at
; tilemap coordinate (2, 4 + A*2); the small 2x2 block and the adjoining 16x1
; strip are cleared in both VRAM banks.
UnitList_ClearDisplayRow::
    ld bc, $0204
    add a, a
    add a, c
    ld c, a

    push bc
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld de, $0202
    farcall Gfx_TilemapFill

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    push bc
    xor a
    ld de, $0202
    farcall Gfx_TilemapFill

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    push bc
    xor a
    ld de, $1001
    farcall Gfx_TilemapFill

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    xor a
    ld de, $1001
    farcall Gfx_TilemapFill
    ret

; Synchronize the Unit List scroll-arrow sprites with the current row/page.
; $DC54 is hidden on the first visible row and shown once upward scrolling is
; possible. $DC55 is shown while another row exists below the six-row window.
; $DC5B is the selected visible row and $DC66 the filtered-entry count.
UnitList_UpdateScrollArrowVisibility::
    ld a, [$dc5b]
    cp $00
    jr nz, .show_primary
    ld a, [$dc54]
    call SpriteObject_Hide
    jr .update_secondary
.show_primary:
    ld a, [$dc54]
    call SpriteObject_Show

.update_secondary:
    ld a, [$dc5b]
    inc a
    add a, $06
    ld c, a
    ld a, [$dc66]
    cp c
    jr nc, .show_secondary
    ld a, [$dc55]
    call SpriteObject_Hide
    jr .done
.show_secondary:
    ld a, [$dc55]
    call SpriteObject_Show
.done:
    ret

    assert @ == $73d4, "Unit List Bank $17 helper boundary moved"

section "Bank17 Tail Padding", romx[$73d4], bank[$17]
    ds $8000 - $73d4, $ff
    assert @ == $8000, "Bank $17 tail padding moved"
