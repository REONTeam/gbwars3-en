include "macros/macros.inc"

; Bank $31 battle/presentation resource immediately after the UnitData layout table.
; $4A4A-$50F9 is structurally exact: 16x13 tilemap, matching attribute map, and 81 2bpp tiles.
; $50FA-$5452 is the adjacent executable runtime. Public/internal boundaries are retained conservatively
; until more callers prove player-facing identities. $5453 begins the next independently-called family.

section "Battle Scene Bank31 Layout Resource", romx[$4a4a], bank[$31]
AttractScene0Tilemap::
BattleSceneBank31LayoutTilemap::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $3b, $3c, $3d, $00, $00, $18, $19, $00, $02, $03, $00, $00
    db $00, $00, $00, $00, $31, $32, $33, $34, $3e, $3f, $40, $00, $00, $1a, $1b, $00
    db $04, $05, $00, $00, $00, $00, $00, $00, $35, $36, $37, $38, $00, $00, $00, $00
    db $00, $00, $00, $06, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $39, $3a
    db $00, $00, $00, $00, $00, $00, $00, $08, $09, $00, $00, $1c, $1d, $00, $00, $00
    db $00, $00, $00, $00, $41, $42, $43, $44, $00, $00, $0a, $0b, $0c, $00, $00, $1e
    db $1f, $20, $00, $00, $00, $00, $24, $00, $45, $46, $47, $48, $49, $00, $0d, $0e
    db $00, $00, $00, $00, $21, $22, $00, $25, $26, $27, $28, $00, $4a, $4b, $4c, $4d
    db $00, $0f, $10, $11, $00, $00, $00, $00, $00, $00, $29, $2a, $2b, $2c, $2d, $00
    db $00, $00, $00, $00, $00, $12, $13, $14, $00, $00, $00, $00, $00, $00, $00, $00
    db $2e, $2f, $30, $00, $00, $00, $00, $00, $15, $16, $17, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
AttractScene0Attributes::
    db $00, $00, $00, $00, $00, $00, $00, $00
BattleSceneBank31LayoutAttributes::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $00
    db $00, $00, $00, $00, $02, $02, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04
    db $04, $04, $04, $00, $00, $00, $00, $00, $02, $02, $00, $00, $00, $00, $00, $00
    db $04, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $03, $03, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $04, $04, $00, $00, $00, $00, $00, $00, $00, $03
    db $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04
    db $00, $00, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $04, $04, $04, $04, $00, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $04, $04, $04, $00, $03, $03, $03, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
AttractScene0GraphicsWindow::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
BattleSceneBank31LayoutTiles::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $00, $0f, $00, $1c, $03, $33, $0f, $6f, $1f, $6f, $1f, $df, $3f, $df, $3f
    db $c0, $00, $f0, $00, $38, $c0, $cc, $f0, $f6, $f8, $f6, $f8, $fb, $fc, $fb, $fc
    db $df, $3f, $df, $3f, $6f, $1f, $6f, $1f, $33, $0f, $1c, $03, $0f, $00, $00, $00
    db $fb, $fc, $fb, $fc, $f6, $f8, $f6, $f8, $cc, $f0, $38, $c0, $f0, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $60, $00, $f0, $00, $f8, $00, $f8, $00, $f0, $00, $60, $00
    db $00, $00, $07, $00, $0f, $00, $1f, $00, $3f, $00, $3f, $00, $3f, $00, $1f, $00
    db $00, $00, $00, $00, $80, $00, $c0, $00, $e0, $00, $e0, $00, $e0, $00, $c0, $00
    db $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $07, $00, $0f, $00, $0f
    db $0f, $00, $07, $00, $00, $00, $00, $f8, $00, $fc, $00, $fe, $00, $ff, $00, $ff
    db $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $0f, $00, $0f, $00, $0f, $00, $07, $00, $03, $00, $01, $00, $00, $7f, $7f
    db $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fc, $00, $f8, $00, $00, $80, $80
    db $00, $00, $01, $01, $03, $03, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8
    db $07, $07, $07, $07, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $00, $00, $00, $00
    db $f8, $f8, $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $03, $07, $07, $0f, $0f
    db $00, $00, $00, $00, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $e0, $e0, $f0, $f0, $f8, $f8, $fc, $fc, $fe, $fe, $ff, $ff
    db $30, $00, $2c, $10, $1e, $0c, $19, $0e, $09, $07, $07, $03, $07, $03, $1e, $03
    db $00, $00, $1f, $00, $21, $1e, $a2, $1c, $c4, $b8, $e8, $d0, $38, $e0, $50, $a0
    db $25, $1a, $42, $3d, $4f, $30, $50, $20, $60, $00, $00, $00, $00, $00, $00, $00
    db $30, $c0, $9c, $60, $f4, $08, $28, $10, $30, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00
    db $03, $01, $07, $01, $0f, $06, $0f, $00, $1b, $0c, $34, $18, $78, $20, $e0, $00
    db $fc, $c0, $fb, $7c, $3e, $ff, $bf, $5f, $df, $2f, $7f, $0f, $1b, $0e, $3b, $1e
    db $00, $00, $00, $00, $80, $00, $40, $80, $c0, $80, $e0, $c0, $f0, $e0, $18, $e0
    db $31, $1e, $33, $1e, $35, $1e, $32, $1c, $16, $0c, $14, $08, $1c, $08, $18, $00
    db $fc, $00, $12, $0c, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $0d, $02, $79, $06
    db $00, $00, $00, $00, $07, $00, $0f, $07, $1f, $0a, $7f, $03, $e3, $1d, $1e, $01
    db $00, $00, $00, $00, $00, $00, $80, $00, $c0, $80, $e1, $c0, $f3, $e1, $ff, $f3
    db $0f, $00, $37, $0e, $5a, $3d, $a4, $7b, $ca, $75, $d1, $ee, $a5, $da, $52, $ad
    db $e6, $18, $9a, $64, $2c, $d0, $b4, $48, $4c, $b0, $68, $90, $90, $60, $60, $80
    db $00, $00, $00, $00, $01, $00, $07, $01, $01, $00, $00, $00, $00, $00, $00, $00
    db $0c, $03, $03, $00, $f0, $00, $ff, $f0, $cf, $3f, $30, $0f, $0e, $01, $03, $00
    db $3e, $e7, $1f, $ec, $be, $7f, $ff, $7f, $ff, $7f, $7f, $bf, $fe, $3f, $dc, $3f
    db $8d, $72, $2d, $d2, $32, $cc, $4c, $b0, $f0, $80, $e0, $c0, $f0, $e0, $78, $f0
    db $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $20, $1f, $10, $0f, $0e, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3c, $d8, $3e, $cc, $9f, $66, $ef, $13, $7a, $05, $34, $03, $12, $01, $11, $00
    db $00, $00, $00, $00, $f8, $00, $f8, $f0, $30, $e0, $10, $e0, $20, $c0, $c0, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $18, $07, $77, $0f, $cf, $3f
    db $00, $00, $01, $00, $0f, $00, $18, $07, $e1, $1f, $03, $ff, $c7, $ff, $ff, $ff
    db $01, $00, $ff, $00, $00, $ff, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ef, $ff
    db $ff, $00, $00, $ff, $07, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $71, $0f, $1c, $03, $07, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $3c, $ff, $01, $fe, $ff, $00, $00, $00, $00, $00, $00, $00
    db $83, $ff, $03, $ff, $f0, $0f, $98, $07, $0f, $00, $00, $00, $00, $00, $00, $00
    db $e7, $ff, $83, $ff, $03, $ff, $00, $ff, $f8, $07, $1c, $03, $1f, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $03, $00, $0c, $03, $18, $07, $1f, $00, $00, $00
    db $00, $00, $0f, $00, $78, $07, $c1, $3f, $1f, $ff, $3e, $ff, $c0, $3f, $7f, $00
    db $00, $00, $00, $00, $fc, $00, $ff, $00, $03, $fc, $e0, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $7c, $80, $07, $f8, $e0, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $00, $1e, $e0
    db $ff, $ff, $ff, $ff, $ff, $ff, $f8, $ff, $e0, $ff, $01, $fe, $ff, $00, $1c, $00
    db $f9, $ff, $ff, $ff, $0f, $ff, $07, $ff, $e0, $1f, $bf, $00, $00, $00, $00, $00
    db $c3, $fc, $fd, $fe, $81, $fc, $7f, $80, $c0, $00, $80, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $f8, $00, $0f, $f0, $e0, $ff, $f0, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $e0, $00, $7f, $80, $00, $ff, $80, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $fc, $00, $0f, $f0, $c1, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $8f, $00, $db, $04
    db $ff, $ff, $ff, $ff, $f8, $ff, $f0, $ff, $f0, $ff, $c0, $ff, $c0, $ff, $fc, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $21, $ff, $00, $ff, $00, $ff, $ff, $00, $01, $fe
    db $e0, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $7c, $ff, $30, $ff, $8f, $70, $f0, $00
    db $70, $8f, $0f, $ff, $ff, $ff, $83, $ff, $78, $87, $8f, $00, $80, $00, $00, $00
    db $60, $80, $38, $c0, $cc, $f0, $e6, $f8, $07, $f8, $cc, $30, $78, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01, $ff, $f8, $07, $0f, $00, $00, $00
    db $fc, $ff, $fe, $ff, $ff, $ff, $f8, $ff, $e0, $fe, $07, $f0, $98, $00, $f0, $00
    db $ff, $00, $00, $ff, $fe, $ff, $00, $ff, $ff, $00, $8c, $00, $00, $00, $00, $00
    db $80, $00, $c0, $00, $70, $80, $1c, $e0, $b0, $00, $e0, $00, $00, $00, $00, $00
AttractScene0Palettes::
    db $e0, $7f, $a9, $35, $91, $52, $ff, $7f, $00, $00, $8c, $31, $d3, $5a, $ff, $7f
    db $e0, $7f, $e7, $7f, $f5, $73, $ff, $63, $e0, $7f, $ea, $7f, $ed, $7f, $f2, $7f
    db $e0, $7f, $ee, $7f, $f7, $7f, $ff, $7f, $f0, $03, $e0, $03, $e0, $43, $e0, $7f
    db $00, $7e, $00, $7c, $10, $7c, $1f, $7c, $1f, $40, $10, $42, $18, $63, $ff, $7f
    assert @ == $50fa

section "Battle Scene Bank31 Runtime 50FA", romx[$50fa], bank[$31]
BattleSceneBank31Runtime_50FA::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$db54], a
    ld [$db55], a
    ld [$db56], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $5113

section "Battle Scene Bank31 Runtime 5113", romx[$5113], bank[$31]
BattleSceneBank31Runtime_5113::
    call $53b6
    cp $ff
    jr z, $513a
    ld [$c4df], a
    ld a, [$c4df]
    farcall MapRecord_SelectBeginner
    ld a, [$c4df]
    ld b, $01
    farcall MapBriefing_OpenModal
    cp $ff
    jr z, $5113
    farcall MapRuntime_PrepareSelectedMap
    cp $ff
    jr z, $511d
    xor a
    ret
    assert @ == $513b

section "Battle Scene Bank31 Runtime 513B", romx[$513b], bank[$31]
BattleSceneBank31Runtime_513B::
    ld a, [$db54]
    ld b, $18
    call $2995
    ld a, l
    add a, $40
    ld c, a
    ld b, $18
    ld a, [$db55]
    call $2eae
    ret
    assert @ == $5150

section "Battle Scene Bank31 Runtime 5150", romx[$5150], bank[$31]
BattleSceneBank31Runtime_5150::
    call $04f3
    call $34ce
    call $2d7c
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call $0618
    call $0f02
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $76e2
    ld hl, $9000
    ld bc, $0260
    farcall BANK_15, Bank15_Entry_3B50
    ld a, $00
    ld b, $08
    ld hl, $7942
    ld c, $15
    call $06d9
    call $06af
    call $06f2
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $4efb
    ld hl, $9260
    ld bc, $0140
    farcall BANK_15, Bank15_Entry_3B50
    ld de, $7697
    ld hl, $93a0
    ld bc, $0010
    farcall BANK_27, Bank27_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0a
    ld bc, $0501
    ld de, $0a02
    ld h, $26
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0d11
    ld de, $0101
    ld h, $21
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0e11
    ld de, $0301
    ld h, $22
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0204
    ld de, $100d
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$db55], a
    call $513b
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call $2de8
    ld bc, $5832
    call $2eae
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call $2de8
    ld bc, $5896
    call $2eae
    ret
    assert @ == $5234

section "Battle Scene Bank31 Runtime 5234", romx[$5234], bank[$31]
BattleSceneBank31Runtime_5234::
    ld a, $03
    ld b, a
    ld a, [$db59]
    ld c, a
    ld a, [$db57]
    inc a
    ld d, $02
    call $3237
    ret
    assert @ == $5245

section "Battle Scene Bank31 Runtime 5245", romx[$5245], bank[$31]
BattleSceneBank31Runtime_5245::
    ld b, $05
    ld a, [$db59]
    ld c, a
    ld hl, $ca1d
    ld a, $00
    call $3ac7
    jr z, $5274
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $25
    call $34ed
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $08
    call $34ed
    pop af
    ld [$ffcb], a
    jr $5291
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    xor a
    call $34ed
    pop bc
    ld a, $01
    ld [$ffcb], a
    xor a
    call $34ed
    pop af
    ld [$ffcb], a
    jr $5291
    ret
    assert @ == $5292

section "Battle Scene Bank31 Runtime 5292", romx[$5292], bank[$31]
BattleSceneBank31Runtime_5292::
    ld hl, $db4b
    ld bc, $0009
    ld a, $00
    call $3b84
    ld hl, $ca1a
    ld bc, $0027
    add hl, bc
    ld d, h
    ld e, l
    ld bc, $0008
    ld hl, $db4b
    call $3b59
    ld a, [$db59]
    ld c, a
    ld b, $07
    ld hl, $db4b
    call $3353
    ret
    assert @ == $52bc

section "Battle Scene Bank31 Runtime 52BC", romx[$52bc], bank[$31]
BattleSceneBank31Runtime_52BC::
    ld b, $0c
    ld a, [$db59]
    inc a
    ld c, a
    push bc
    ld a, [$ca4d]
    ld d, $02
    call $31f5
    pop bc
    inc b
    inc b
    push bc
    ld hl, $52e2
    call $3353
    pop bc
    ld b, $0f
    ld a, [$ca4e]
    ld d, $02
    call $31f5
    ret
    db $19, $00
    assert @ == $52e4

section "Battle Scene Bank31 Runtime 52E4", romx[$52e4], bank[$31]
BattleSceneBank31Runtime_52E4::
    ld a, [$db57]
    farcall MapRecord_SelectBeginner
    call $5234
    call $5245
    call $5292
    call $52bc
    ld a, [$db59]
    add a, $03
    ld [$db59], a
    ret
    assert @ == $5300

section "Battle Scene Bank31 Runtime 5300", romx[$5300], bank[$31]
BattleSceneBank31Runtime_5300::
    ld a, $05
    ld [$db59], a
    ld a, [$db56]
    ld [$db57], a
    xor a
    ld [$db58], a
    ld a, [$db58]
    cp $04
    jr z, $532e
    call $52e4
    ld a, [$db57]
    inc a
    cp $10
    jr nz, $5322
    xor a
    ld [$db57], a
    ld a, [$db58]
    inc a
    ld [$db58], a
    jr $530f
    ret
    assert @ == $532f

section "Battle Scene Bank31 Runtime 532F", romx[$532f], bank[$31]
BattleSceneBank31Runtime_532F::
    ld a, [$db56]
    dec a
    cp $ff
    jr nz, $5339
    ld a, $0f
    ld [$db56], a
    call $5300
    ret
    assert @ == $5340

section "Battle Scene Bank31 Runtime 5340", romx[$5340], bank[$31]
BattleSceneBank31Runtime_5340::
    ld a, [$db56]
    inc a
    cp $10
    jr nz, $5349
    xor a
    ld [$db56], a
    call $5300
    ret
    assert @ == $5350

section "Battle Scene Bank31 Runtime 5350", romx[$5350], bank[$31]
BattleSceneBank31Runtime_5350::
    ld a, [$db54]
    dec a
    cp $ff
    jr nz, $535c
    call $532f
    xor a
    ld [$db54], a
    call $513b
    ret
    assert @ == $5363

section "Battle Scene Bank31 Runtime 5363", romx[$5363], bank[$31]
BattleSceneBank31Runtime_5363::
    ld a, [$db54]
    inc a
    cp $04
    jr nz, $5370
    call $5340
    ld a, $03
    ld [$db54], a
    call $513b
    ret
    assert @ == $5377

section "Battle Scene Bank31 Runtime 5377", romx[$5377], bank[$31]
BattleSceneBank31Runtime_5377::
    ld a, [$db54]
    ld c, a
    ld a, [$db56]
    add a, c
    ld c, a
    ld a, $0f
    cp c
    jr c, $5387
    jr $5393
    ld a, c
    push af
    ld a, $0f
    inc a
    ld c, a
    pop af
    sub c
    ld c, a
    xor a
    add a, c
    ld c, a
    ld a, c
    ret
    db $cd, $77, $53, $fe, $0f, $38, $02, $18, $09, $f5, $3e, $02, $cd, $44, $38, $f1
    db $37, $c9, $ef, $28, $35, $41, $fe, $01, $28, $ef, $3e, $03, $cd, $44, $38, $af
    db $c9
    assert @ == $53b6

section "Battle Scene Bank31 Runtime 53B6", romx[$53b6], bank[$31]
BattleSceneBank31Runtime_53B6::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    call $5150
    call $5300
    call $3537
    ld a, $02
    call $3816
    call $081d
    assert @ == $53d0

section "Battle Scene Bank31 Runtime 53D0", romx[$53d0], bank[$31]
BattleSceneBank31Runtime_53D0::
    call $05a2
    call $3056
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, $53f7
    ld a, [$db55]
    farcall SpriteTransition_SlideRightOffscreen
    call $5377
    farcall MapRecord_SelectBeginner
    call $5377
    jr $5422
    db $18, $28
    bit 1, a
    jr z, $5405
    ld a, $0c
    call $3844
    ld a, $ff
    jp $5422
    bit 6, a
    jr z, $5413
    ld a, $01
    call $3844
    call $5350
    jr $53d0
    bit 7, a
    jr z, $541f
    ld a, $01
    call $3844
    call $5363
    jp $53d0
    assert @ == $5422

section "Battle Scene Bank31 Runtime 5422", romx[$5422], bank[$31]
BattleSceneBank31Runtime_5422::
    push af
    call $07b4
    pop af
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ret
    assert @ == $542f

section "Battle Scene Bank31 Runtime 542F", romx[$542f], bank[$31]
BattleSceneBank31Runtime_542F::
    ld hl, $a138
    ld de, $1900
    call $39c7
    ld a, c
    ret
    assert @ == $543a

section "Battle Scene Bank31 Runtime 543A", romx[$543a], bank[$31]
BattleSceneBank31Runtime_543A::
    ld a, $0e
    call $058d
    call $0593
    call $542f
    ld [$ba65], a
    call $059b
    ret
    assert @ == $544c

section "Battle Scene Bank31 Runtime 544C", romx[$544c], bank[$31]
BattleSceneBank31Runtime_544C::
    call $542f
    ld [$ba65], a
    ret
    assert @ == $5453
