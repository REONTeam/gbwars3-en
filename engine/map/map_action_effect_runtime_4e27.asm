include "macros/macros.inc"
include "constants/unit_constants.inc"

; Shared map-combat effect runtime. This family ties direct-battle HP-delta
; prediction, battle casualty cleanup, animated unit destruction, BOMB/area-
; attack target selection, and the map effect sprite resources together.
;
; The scratch bytes at $C99B/$CCDE/$CCDF are named only for their BOMB-target
; lifetime here; other callers may reuse the same storage for unrelated work.

DEF wBombTargetRangeState EQU $c99b
DEF wBombOriginX          EQU $ccde
DEF wBombOriginY          EQU $ccdf
DEF wMapInteractionInputState EQU $ca91
DEF SPRITE_ANIMATION_DELAY EQU 11

section "Battle HP Delta Packing", romx[$4e27], bank[$0c]
Battle_CalculatePackedHPDamage::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    call $464f
    ld a, [$dbcc]
    ld b, a
    ld a, [$dbcb]
    sub b
    swap a
    ld c, a
    ld a, [$dbe1]
    ld b, a
    ld a, [$dbe0]
    sub b
    or c
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    pop de
    pop bc
    ret
    assert @ == $4e53

section "Map Action Effect Graphics Loader", romx[$4e53], bank[$0c]
MapActionEffect_LoadGraphics::
    db $3e, $01, $e0, $83, $e0, $4f, $11, $c6, $53, $21, $00, $80, $01, $50, $02, $cd
    db $59, $3b, $c9
MapActionEffect_LoadPalettes::
    db $c5, $d5, $af, $e0, $b1, $3e, $0d, $06, $02, $0e, $0c, $21, $16, $56, $cd, $d9
    db $06, $01, $60, $00, $cd, $03, $07, $af, $cb, $c7, $e0, $b1, $d1, $c1, $c9
    assert @ == $4e85

section "Battle Casualty Cleanup", romx[$4e85], bank[$0c]
Battle_ResolveDestroyedParticipants::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$dbd3]
    and a
    jr nz, $4ea2
    ld a, [$dbd0]
    ld b, a
    ld a, [$dbd1]
    ld c, a
    ld a, [$dbc8]
    call $4ecb
    ld a, [$dbe8]
    and a
    jr nz, $4ec5
    ld a, [$dbc9]
    ld c, $00
    farcall UnitRecord_GetByte
    srl a
    farcall CampaignStats_GetIndexedPointer
    ld a, [$dbe5]
    ld b, a
    ld a, [$dbe6]
    ld c, a
    ld a, [$dbc9]
    call $4ecb
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $4ecb

section "Animated Map Unit Destruction", romx[$4ecb], bank[$0c]
Unit_DestroyWithMapAnimation::
    push de
    push af
    push bc
    push bc
    ld c, $00
    farcall UnitRecord_GetByte
    ld d, a
    pop bc
    farcall MapTile_ClearAllFlagsAtCoordinates
    push bc
    ld a, d
    farcall UnitSelection_InitializeCoordinateInteractionState
    ld d, $28
    call $04d2
    farcall UnitSelection_AdvanceCoordinateInteractionPhase
    farcall UnitSelection_AdvanceCoordinateInteractionPhase
    farcall UnitSelection_AdvanceCoordinateInteractionPhase
    dec d
    jr nz, $4ee3
    farcall UnitSelection_RefreshCoordinateInteractionState
    pop bc
    push bc
    xor a
    farcall MapTile_SetOverlayByteAtCoordinates
    farcall MapTile_ClearAllFlagsAtCoordinates
    farcall Bank0B_MapSetup_43D1
    call $4e66
    pop bc
    ld de, $539a
    call $5259
    ld a, $10
    call $3844
    call $3056
    call $04d2
    ld a, [$c998]
    ld b, $0b
    call $2e9a
    cp $ff
    jr nz, $4f17
    ld a, [$c998]
    call $2e1f
    call $3056
    pop bc
    pop af
    farcall Unit_DeleteWithCarriedAtCoordinates
    pop de
    ret
    assert @ == $4f3a

section "Unit Action Bomb Target Controller", romx[$4f3a], bank[$0c]
UnitAction_RunBombTargetSelection::
    ld c, $00
    farcall UnitRecord_GetByte
    srl a
    cp $2d
    jr z, $4f5a
    cp $33
    jr z, $4f5a
    call $5029
    and a
    jp z, $5002
    farcall MapCursor_UseNormalAnimation
    ld a, $ff
    jp $5028
UnitAction_BombRunRangedSelector:
    xor a
    ld [$c99b], a
    farcall MapCursor_UseAnimation3
UnitAction_BombSelectionLoop:
    farcall MapControl_UpdateInteractionInputState
    call $4f87
    ld a, [$ca91]
    bit 4, a
    jr nz, $4fc1
    bit 5, a
    jr nz, $4fc7
    bit 6, a
    jr nz, $4fcd
    bit 7, a
    jr nz, $4fd3
    bit 0, a
    jr nz, $4fd9
    bit 1, a
    jp nz, $5011
    jr $4f62
UnitAction_UpdateBombTargetRangeCursor:
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    ld a, [$ccde]
    ld d, a
    ld a, [$ccdf]
    ld e, a
    farcall BANK_0B, Bank0B_Entry_291D
    cp $03
    jr c, $4fa3
    cp $08
    jr c, $4fb1
UnitAction_BombRangeInvalid:
    ld a, [$c99b]
    and a
    ret z
    farcall MapCursor_UseAnimation3
    xor a
    ld [$c99b], a
    ret
UnitAction_BombRangeValid:
    ld a, [$c99b]
    cp $01
    ret z
    farcall MapCursor_UseAnimation2
    ld a, $01
    ld [$c99b], a
    ret
UnitAction_BombMoveRight:
    farcall MapControl_AdvanceHorizontalMapPosition
    jr $4f62
UnitAction_BombMoveLeft:
    farcall MapControl_RetreatHorizontalMapPosition
    jr $4f62
UnitAction_BombMoveDown:
    farcall MapControl_RetreatVerticalMapPosition
    jr $4f62
UnitAction_BombMoveUp:
    farcall MapControl_AdvanceVerticalMapPosition
    jr $4f62
UnitAction_BombPressA:
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    ld a, [$ccde]
    ld d, a
    ld a, [$ccdf]
    ld e, a
    farcall BANK_0B, Bank0B_Entry_291D
    cp $03
    jr c, $5009
    cp $08
    jr nc, $5009
    ld a, $0a
    call $3844
    call $5029
    cp $ff
    jp z, $4f5a
UnitAction_BombConfirmed:
    farcall MapCursor_UseNormalAnimation
    xor a
    jr $5028
UnitAction_BombInvalidSelection:
    ld a, $03
    call $3844
    jp $4f62
UnitAction_BombPressB:
    call $4fa3
    farcall MapCursor_UseNormalAnimation
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    farcall MapControl_PanToCoordinates
    ld a, $ff
    jr $5028
UnitAction_BombDone:
    ret
UnitAction_ConfirmBombTarget:
    farcall MapCursor_UseAnimation4
    call $05a2
    call $3056
    ldh a, [$ff91]
    bit 0, a
    jr nz, $5048
    bit 1, a
    jr nz, $503f
    jr $502d
    ld a, $0c
    call $3844
    ld a, $ff
    jr $504e
    ld a, $0a
    call $3844
    xor a
    ret
    assert @ == $504f

section "Map Action Effect OAM Frames", romx[$52a6], bank[$0c]
MapActionEffectFrame_52A6::
    db $01, $fd, $fc, $00, $01
MapActionEffectFrame_52AB::
    db $04, $f5, $03, $02, $00, $f5, $fb, $01, $00, $fd, $03, $04, $01, $fd, $fb, $03
    db $01
MapActionEffectFrame_52BC::
    db $0b, $ff, $ff, $0f, $01, $ff, $f7, $0e, $01, $f7, $07, $0d, $01, $f7, $ff, $0c
    db $01, $f7, $f7, $0b, $01, $ef, $07, $0a, $00, $ef, $ff, $09, $00, $ef, $f7, $08
    db $00, $e7, $07, $07, $00, $e7, $ff, $06, $00, $e7, $f7, $05, $00
MapActionEffectFrame_52E9::
    db $07, $f6, $00, $24, $20, $f6, $f8, $24, $00, $f1, $ff, $14, $00, $f1, $f7, $13
    db $00, $e9, $07, $12, $00, $e9, $ff, $11, $00, $e9, $f7, $10, $00
MapActionEffectFrame_5306::
    db $03, $ec, $07, $17, $00, $ec, $ff, $16, $00, $ec, $f7, $15, $00
MapActionEffectFrame_5313::
    db $03, $ec, $07, $17, $00, $ec, $ff, $16, $00, $ec, $f7, $15, $00
MapActionEffectFrame_5320::
    db $01, $fc, $fc, $18, $00
MapActionEffectFrame_5325::
    db $04, $f4, $00, $19, $20, $fc, $00, $1a, $20, $f4, $f8, $19, $00, $fc, $f8, $1a
    db $00
MapActionEffectFrame_5336::
    db $06, $f0, $00, $1b, $20, $f8, $00, $1c, $20, $00, $00, $1d, $20, $f0, $f8, $1b
    db $00, $f8, $f8, $1c, $00, $00, $f8, $1d, $00
MapActionEffectFrame_534F::
    db $06, $f0, $00, $1e, $20, $f8, $00, $1f, $20, $00, $00, $20, $20, $f0, $f8, $1e
    db $00, $f8, $f8, $1f, $00, $00, $f8, $20, $00
MapActionEffectFrame_5368::
    db $06, $f0, $00, $21, $20, $f8, $00, $22, $20, $00, $00, $23, $20, $f0, $f8, $21
    db $00, $f8, $f8, $22, $00, $00, $f8, $23, $00
MapActionEffectFrame_5381::
    db $06, $f0, $00, $21, $20, $f8, $00, $22, $20, $00, $00, $23, $20, $f0, $f8, $21
    db $00, $f8, $f8, $22, $00, $00, $f8, $23, $00
    assert @ == $539a

section "Map Action Effect Animation Streams", romx[$539a], bank[$0c]
MapActionEffect_UnitDestroyedAnimation::
    db $a6, $52, $05, $ab, $52, $04, $bc, $52, $08, $e9, $52, $06, $06, $53, $04, $13
    db $53, $ff, $00, $00
MapActionEffect_AreaAttackAnimation::
    db $20, $53, $04, $25, $53, $03, $36, $53, $03, $4f, $53, $07, $68, $53, $05, $81
    db $53, $ff, $00, $00
MapActionEffectAnimationPointers::
    db $9a, $53, $ae, $53
    assert @ == $53c6

section "Map Action Effect Graphics", romx[$53c6], bank[$0c]
MapActionEffectGraphics::
    db $04, $3c, $3a, $46, $7d, $83, $79, $87, $42, $7e, $3c, $3c, $00, $00, $00, $00
    db $01, $3f, $7e, $01, $ff, $00, $ff, $00, $7e, $81, $80, $ff, $73, $7f, $0c, $0c
    db $00, $00, $80, $80, $40, $c0, $40, $c0, $40, $c0, $c0, $c0, $80, $80, $00, $00
    db $0c, $00, $1e, $21, $3f, $40, $3f, $40, $1e, $21, $00, $1e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $7f, $80, $7f, $80
    db $00, $f0, $e4, $1c, $d3, $2f, $f9, $07, $f8, $07, $f4, $0b, $fc, $03, $f8, $07
    db $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $c0, $c0, $60, $e0, $e0, $e0
    db $ff, $80, $ad, $d2, $52, $6d, $60, $7f, $38, $3f, $1e, $1f, $0f, $07, $11, $01
    db $d0, $2f, $b0, $4f, $c4, $3f, $01, $ff, $2b, $ff, $9f, $ff, $fe, $fc, $f1, $f0
    db $60, $e0, $e0, $e0, $c0, $c0, $c0, $c0, $80, $80, $00, $00, $00, $00, $00, $00
    db $17, $00, $18, $00, $26, $00, $21, $00, $19, $01, $04, $03, $03, $00, $03, $03
    db $fd, $e0, $e3, $20, $0c, $e0, $f0, $00, $f3, $f0, $04, $f8, $f8, $00, $f8, $f8
    db $00, $00, $00, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $03, $07, $08, $07, $08, $01, $06, $00, $01, $00, $00, $00, $00, $00, $00
    db $00, $fc, $18, $e6, $f8, $06, $f0, $0c, $00, $f0, $00, $00, $00, $00, $00, $00
    db $00, $00, $03, $00, $3f, $00, $4f, $10, $9f, $00, $9f, $20, $87, $38, $78, $07
    db $00, $e0, $e0, $18, $f3, $0e, $f9, $07, $fd, $03, $fc, $03, $fc, $03, $07, $f8
    db $00, $00, $00, $00, $80, $00, $40, $00, $20, $00, $a0, $80, $a0, $80, $c0, $00
    db $1f, $18, $17, $1f, $0c, $0f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $07, $fb, $ff, $06, $fe, $18, $f8, $e0, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $01, $01, $04, $07, $63, $7c, $04, $07, $01, $01, $00, $00, $00, $00
    db $e0, $e0, $10, $f0, $e4, $1c, $f8, $07, $e4, $1c, $10, $f0, $e0, $e0, $00, $00
    db $00, $00, $00, $00, $00, $00, $60, $e0, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $18, $18, $24, $3c, $5a, $66, $5a, $66, $24, $3c, $18, $18, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01, $00, $01, $02, $01, $02
    db $03, $00, $03, $04, $0f, $08, $13, $1c, $11, $1e, $08, $0f, $04, $07, $03, $03
    db $00, $00, $00, $01, $00, $01, $01, $00, $01, $02, $01, $02, $01, $02, $03, $00
    db $03, $00, $03, $00, $03, $00, $03, $00, $03, $04, $0f, $08, $0f, $08, $17, $18
    db $13, $1c, $08, $0f, $04, $07, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $01, $02, $03, $04, $03, $04, $31, $02, $4b, $32, $37, $7a, $0a, $0d
    db $04, $07, $1f, $00, $2b, $1a, $51, $30, $21, $60, $41, $40, $01, $00, $01, $02
    db $03, $04, $09, $0e, $0c, $0f, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $00, $04, $00, $00, $00, $08, $00, $00, $00, $04, $00, $01, $20, $60
    db $c0, $40, $80, $00, $00, $00, $10, $10, $10, $30, $30, $10, $41, $21, $44, $24
    db $50, $30, $00, $40, $10, $10, $04, $04, $01, $01, $00, $00, $00, $00, $00, $00
    db $05, $00, $10, $00, $40, $00, $00, $00, $80, $00, $00, $00, $20, $00, $0a, $00
    assert @ == $5616

section "Map Action Effect Palettes", romx[$5616], bank[$0c]
MapActionEffectPalettes::
    db $b5, $3a, $ff, $7f, $3f, $03, $9e, $01, $b5, $3a, $ff, $7f, $f7, $5e, $ef, $3d
    assert @ == $5626
