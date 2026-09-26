include "macros/macros.inc"

; Confirmation pane used when starting a new file in an occupied slot.
section "File Slot Confirmation Runtime", romx[$59a8], bank[$14]
FileSlotConfirm_Open::
    ld bc, $0103
    ld de, $1204
    farcall UIWindowStack_PushAndDrawAnimated

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0204
    ld de, $1002
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, [$c62a]
    inc a
    ld d, $01
    ld bc, $0304
    call $31f5
    ld bc, $0404
    ld hl, FileSlotConfirm_FileText
    call TextPut
    ld bc, $0305
    ld hl, FileSlotConfirm_OverwriteText
    call TextPut
    call FileSlotConfirm_DrawNoSelected
    xor a
    ld [$cc73], a
    ret

FileSlotConfirm_FileText:
    db $79, $eb, $2d, $c0, $60, $69, $6c, $73, $00
FileSlotConfirm_OverwriteText:
    db $61, $70, $87, $6c, $68, $7a, $94, $82, $7f, $6d, $00

FileSlotConfirm_DrawYesSelected::
    ld bc, $0d04
    ld a, $0f
    ld de, $0201
    ld h, $6b
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0f04
    ld a, $08
    ld de, $0101
    ld h, $6d
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $1004
    ld a, $08
    ld de, $0201
    ld h, $6e
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret

FileSlotConfirm_DrawNoSelected::
    ld bc, $0d04
    ld a, $08
    ld de, $0201
    ld h, $6b
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0f04
    ld a, $08
    ld de, $0101
    ld h, $6d
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $1004
    ld a, $0f
    ld de, $0201
    ld h, $6e
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret

    assert @ == $5a5b
