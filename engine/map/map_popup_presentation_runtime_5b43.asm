include "macros/macros.inc"
include "constants/unit_constants.inc"

; Shared map-coordinate sprite presentation used by unit creation/removal,
; HP transfer, signed HP-change popups, maximum-flank feedback and rank-up.
; Scratch $C9A9-$C9AD is lifetime-local to this presentation family.
DEF wMapPopupSpriteObjectId EQU $c9a9
DEF wMapPopupParam0         EQU $c9aa
DEF wMapPopupParam1         EQU $c9ab
DEF wMapPopupDirection      EQU $c9ac
DEF wMapPopupMagnitude      EQU $c9ad

section "Map Popup Palette Setup", romx[$5b43], bank[$0c]
MapPopup_LoadObjPalettes::
    db $c5, $d5, $af, $e0, $b1, $3e, $0d, $cd, $bc, $06, $cd, $fe, $06, $cd, $d2, $04
    db $af, $cb, $c7, $e0, $b1, $d1, $c1, $c9
MapUnitTransition_BeginDeployment::
    db $c5, $d5, $cd, $a9, $5b, $11, $d8, $5f, $cd, $c8, $5b, $cd, $ff, $5b, $d1, $c1
    db $c9
MapUnitTransition_EndDeployment::
    db $d5, $11, $0e, $60, $cd, $e6, $5b, $d1, $c9
MapUnitTransition_BeginCreation::
    db $c5, $d5, $cd, $a9, $5b, $11, $e9, $5f, $cd, $c8, $5b, $cd, $ff, $5b, $d1, $c1
    db $c9
MapUnitTransition_EndCreation::
    db $d5, $11, $1f, $60, $cd, $e6, $5b, $d1, $c9
MapUnitTransition_BeginRemoval::
    db $c5, $d5, $cd, $a9, $5b, $11, $c7, $5f, $cd, $c8, $5b, $cd, $ff, $5b, $d1, $c1
    db $c9
MapUnitTransition_EndRemoval::
    db $d5, $11, $fd, $5f, $cd, $e6, $5b, $d1, $c9
MapUnitTransition_LoadResources:
    db $c5, $d5, $06, $01, $21, $0f, $61, $cd, $43, $5b, $3e, $01, $e0, $83, $e0, $4f
    db $11, $3f, $60, $21, $00, $83, $01, $d0, $00, $cd, $59, $3b, $d1, $c1, $c9
MapUnitTransition_CreateSprite:
    db $c5, $3e, $20, $0e, $98, $06, $0c, $cd, $e8, $2d, $ea, $a9, $c9, $06, $05, $fa
    db $a9, $c9, $cd, $c9, $2e, $c1, $fa, $a9, $c9, $ef, $0c, $73, $52, $c9
MapUnitTransition_SetAnimationAndFinish:
    db $c5, $d5, $fa, $a9, $c9, $06, $0c, $cd, $e8, $2e, $cd, $ff, $5b, $fa, $a9, $c9
    db $cd, $1f, $2e, $cd, $56, $30, $d1, $c1, $c9
MapPopup_WaitAnimationEnd:
    db $c5, $cd, $56, $30, $cd, $d2, $04, $fa, $a9, $c9, $06, $0b, $cd, $9a, $2e, $fe
    db $ff, $20, $ee, $c1, $c9
MapPopup_WaitFrames::
    db $c5, $d5, $f5, $cd, $56, $30, $cd, $a2, $05, $f1, $3d, $20, $f5, $d1, $c1, $c9
    assert @ == $5c24

section "Unit HP Transfer Map Presentation", romx[$5c24], bank[$0c]
UnitHPTransfer_PresentTransfer::
    push bc
    push de
    ld a, [$c9ad]
    and a
    jr z, $5c66
    call $5cc8
    ld b, $01
    ld hl, $636d
    call $5b43
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c9ad]
    call $5c8a
    ld hl, $8300
    ld bc, $0040
    call $3b59
    ld a, [$c9aa]
    ld c, $01
    farcall UnitRecord_GetWord
    ld b, e
    ld c, d
    call $5c69
    call $5cfe
    ld a, [$c9a9]
    call $2e1f
    call $3056
    pop de
    pop bc
    ret
UnitHPTransfer_CreateSprite:
    push bc
    ld a, $20
    ld c, $98
    ld b, $0c
    ld de, $6128
    call $2de8
    ld [$c9a9], a
    ld b, $05
    ld a, [$c9a9]
    call $2ec9
    pop bc
    ld a, [$c9a9]
    farcall MapAI_PositionAreaAttackEffectSprite
    ret
UnitHPTransfer_GetGraphicsPointer:
    dec a
    swap a
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    ld d, h
    ld e, l
    ld hl, $612d
    add hl, de
    ld d, h
    ld e, l
    ret
UnitHPTransfer_PreparePresentation::
    ld a, [$cce1]
    ld b, a
    ld a, [$c942]
    sub b
    jr nc, $5cb8
    cpl
    inc a
    ld [$c9ad], a
    ld a, [$c9d8]
    ld [$c9aa], a
    ld a, [$c941]
    ld [$c9ab], a
    jr $5cc7
    ld [$c9ad], a
    ld a, [$c941]
    ld [$c9aa], a
    ld a, [$c9d8]
    ld [$c9ab], a
    ret
UnitHPTransfer_ResolveDirection:
    ld e, $00
    push de
    ld a, [$c9aa]
    ld c, $01
    farcall UnitRecord_GetWord
    ld b, e
    ld c, d
    pop de
    call $28d9
    push bc
    push de
    ld a, [$c9ab]
    ld c, $01
    farcall UnitRecord_GetWord
    ld h, e
    ld l, d
    pop de
    pop bc
    ld a, b
    cp h
    jr nz, $5cf3
    ld a, c
    cp l
    jr nz, $5cf3
    jr $5cf9
    inc e
    ld a, e
    cp $06
    jr nz, $5cca
    ld a, e
    ld [$c9ac], a
    ret
UnitHPTransfer_AnimateSprite:
    ld a, [$c9ac]
    add a, a
    ld hl, $5d32
    call $29bc
    ld d, [hl]
    inc hl
    ld e, [hl]
    ld b, $09
    push bc
    ld a, $03
    call $5c14
    ld a, [$c9a9]
    ld b, $01
    call $2e9a
    add a, e
    ld c, a
    ld a, [$c9a9]
    ld b, $02
    call $2e9a
    add a, d
    ld b, a
    ld a, [$c9a9]
    call $2eae
    pop bc
    dec b
    jr nz, $5d0d
    ret
UnitHPTransferStepVectors:
    rst $38
    cp $01
    cp $fe
    nop
    ld [bc], a
    nop
    rst $38
    ld [bc], a
    db $01, $02
    assert @ == $5d3e

section "Signed Map HP Change Presentation", romx[$5d3e], bank[$0c]
MapHPChange_PresentSignedDelta::
    push bc
    push de
    and a
    jr z, $5d91
    push bc
    ld [$c9aa], a
    ld b, $02
    ld hl, $64f5
    call $5b43
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $6435
    ld hl, $8300
    ld bc, $00c0
    call $3b59
    ld a, [$c9aa]
    call $5d94
    ld a, $20
    ld c, $98
    ld b, $0c
    call $2de8
    ld [$c9a9], a
    ld b, $05
    ld a, [$c9a9]
    call $2ec9
    pop bc
    ld a, [$c9a9]
    call $5ecc
    call $5dbb
    ld a, [$c9a9]
    call $2e1f
    call $3056
    call $04d2
    pop de
    pop bc
    ret
MapHPChange_GetAnimation:
    bit 7, a
    jr nz, $5da1
    dec a
    ld hl, $5dab
    call $3a93
    jr $5da8
    cpl
    ld hl, $5db3
    call $3a93
    ld d, h
    ld e, l
    ret
MapHPChangePositiveAnimationPointers:
    db $fd, $63, $02, $64, $07, $64, $0c, $64
MapHPChangeNegativeAnimationPointers:
    db $11, $64, $16, $64, $1b, $64, $20, $64
MapPopup_AnimateVerticalBounce:
    ld a, [$c9a9]
    ld b, $01
    call $2e9a
    sub $04
    ld c, a
    ld a, [$c9a9]
    ld b, $01
    call $2e87
    xor a
    ld [$c9ab], a
    ld b, $0b
    ld a, $01
    call $5c14
    push bc
    ld a, [$c9a9]
    ld b, $01
    call $2e9a
    ld b, a
    call $5dff
    ld a, b
    sub h
    ld c, a
    ld a, [$c9a9]
    ld b, $01
    call $2e87
    pop bc
    ld hl, $c9ab
    inc [hl]
    dec b
    jr nz, $5dd4
    ld a, $06
    call $5c14
    ret
MapPopup_GetVerticalBounceStep:
    ld a, [$c9ab]
    ld hl, $5e0b
    call $29bc
    ld a, [hl]
    ld h, a
    ret
MapPopupVerticalBounceSteps:
    ld bc, $0101
    ld bc, $ff00
    rst $38
    nop
    ld bc, $0101
    assert @ == $5e16

section "Maximum Flank Marker Presentation", romx[$5e16], bank[$0c]
Battle_PresentMaximumFlankMarker::
    push bc
    push de
    push bc
    ld b, $01
    ld hl, $66b3
    call $5b43
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $6573
    ld hl, $8300
    ld bc, $0140
    call $3b59
    ld a, $20
    ld c, $98
    ld b, $0c
    ld de, $6559
    call $2de8
    ld [$c9a9], a
    ld b, $05
    ld a, [$c9a9]
    call $2ec9
    pop bc
    ld a, [$c9a9]
    call $5ecc
    call $3878
    and a
    jr nz, $5e51
    ld a, $07
    call $3844
    call $5dbb
    call $5bff
    ld a, [$c9a9]
    call $2e1f
    call $3056
    call $04d2
    pop de
    pop bc
    ret
    assert @ == $5e71

section "Unit Rank Up Presentation", romx[$5e71], bank[$0c]
UnitRank_PresentIncreaseAtCoordinates::
    db $c5, $d5, $c5, $06, $01, $21, $b3, $66, $cd, $43, $5b, $3e, $01, $e0, $83, $e0
    db $4f, $11, $73, $65, $21, $00, $83, $01, $40, $01, $cd, $59, $3b, $3e, $20, $0e
    db $98, $06, $0c, $11, $64, $65, $cd, $e8, $2d, $ea, $a9, $c9, $06, $05, $fa, $a9
    db $c9, $cd, $c9, $2e, $c1, $fa, $a9, $c9, $cd, $cc, $5e, $cd, $78, $38, $a7, $20
    db $fa, $3e, $07, $cd, $44, $38, $cd, $bb, $5d, $cd, $ff, $5b, $fa, $a9, $c9, $cd
    db $1f, $2e, $cd, $56, $30, $cd, $d2, $04, $d1, $c1, $c9
MapPopup_PositionAtCoordinates::
    db $c5, $d5, $67, $fa, $8b, $c9, $57, $78, $92, $38, $2d, $57, $fa, $8c, $c9, $5f
    db $79, $93, $38, $24, $5f, $7a, $cb, $37, $c6, $10, $57, $7b, $cb, $37, $c6, $18
    db $5f, $79, $e6, $01, $28, $04, $7a, $c6, $08, $57, $79, $a7, $20, $04, $7b, $c6
    db $08, $5f, $42, $4b, $7c, $cd, $ae, $2e, $d1, $c1, $c9
    assert @ == $5f07

section "Map Unit Transition Sprite Frames", romx[$5f07], bank[$0c]
    db $04, $00, $00, $00, $60, $00, $f8, $00, $40, $f8, $00, $00, $20, $f8, $f8, $00
    db $00, $04, $00, $00, $01, $60, $00, $f8, $01, $40, $f8, $00, $01, $20, $f8, $f8
    db $01, $00, $04, $00, $00, $02, $60, $00, $f8, $02, $40, $f8, $00, $02, $20, $f8
    db $f8, $02, $00, $04, $00, $00, $03, $00, $00, $f8, $03, $00, $f8, $00, $03, $00
    db $f8, $f8, $03, $00, $04, $00, $00, $04, $60, $00, $f8, $04, $40, $f8, $00, $04
    db $20, $f8, $f8, $04, $00, $04, $00, $00, $05, $60, $00, $f8, $05, $40, $f8, $00
    db $05, $20, $f8, $f8, $05, $00, $01, $fa, $fa, $05, $00, $04, $00, $00, $07, $20
    db $f8, $00, $06, $20, $00, $f8, $07, $00, $f8, $f8, $06, $00, $04, $00, $00, $09
    db $20, $f8, $00, $08, $20, $00, $f8, $09, $00, $f8, $f8, $08, $00, $04, $00, $00
    db $0b, $20, $f8, $00, $0a, $20, $00, $f8, $0b, $00, $f8, $f8, $0a, $00, $04, $00
    db $00, $0b, $20, $00, $f8, $0b, $00, $f8, $00, $0c, $20, $f8, $f8, $0c, $00, $04
    db $00, $00, $0b, $20, $00, $f8, $0b, $00, $f8, $00, $0b, $60, $f8, $f8, $0b, $40
MapUnitTransitionAnimationRemovalBegin:
    db $07, $5f, $01, $18, $5f, $01, $29, $5f, $01, $3a, $5f, $01, $3a, $5f, $ff, $00
    db $00
MapUnitTransitionAnimationDeploymentBegin:
    db $6d, $5f, $01, $5c, $5f, $01, $4b, $5f, $01, $3a, $5f, $01, $3a, $5f, $ff, $00
    db $00
MapUnitTransitionAnimationCreationBegin:
    db $b6, $5f, $03, $a5, $5f, $02, $94, $5f, $02, $83, $5f, $02, $72, $5f, $03, $72
    db $5f, $ff, $00, $00
MapUnitTransitionAnimationRemovalEnd:
    db $3a, $5f, $01, $4b, $5f, $01, $5c, $5f, $01, $6d, $5f, $01, $6d, $5f, $ff, $00
    db $00
MapUnitTransitionAnimationDeploymentEnd:
    db $3a, $5f, $01, $29, $5f, $01, $18, $5f, $01, $07, $5f, $01, $07, $5f, $ff, $00
    db $00
MapUnitTransitionAnimationCreationEnd:
    db $72, $5f, $03, $83, $5f, $02, $94, $5f, $02, $a5, $5f, $02, $b6, $5f, $03, $b6
    db $5f, $ff, $00, $00
MapUnitTransitionAnimationPointers:
    db $c7, $5f, $d8, $5f, $e9, $5f, $fd, $5f, $0e, $60, $1f, $60
    assert @ == $603f

section "Map Unit Transition Graphics", romx[$603f], bank[$0c]
    db $ff, $00, $ff, $00, $c0, $00, $c0, $00, $c0, $00, $c0, $00, $c0, $00, $c0, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $fc, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00
    db $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $c0, $7f
    db $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00
    db $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $80, $00, $80, $00, $80, $00, $ff, $00
    db $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $c0, $7f, $ff, $00, $80, $00
    db $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $ff, $00
    db $ff, $00, $ff, $00, $c0, $7f, $ff, $00, $80, $00, $80, $00, $80, $00, $80, $00
    assert @ == $610f

section "Map Unit Transition Palette", romx[$610f], bank[$0c]
    db $d2, $3e, $00, $00, $94, $52, $39, $67
    assert @ == $6117

section "Unit HP Transfer Sprite Resources", romx[$6117], bank[$0c]
UnitHPTransferFrame:
    db $04, $00, $00, $03, $00, $00, $f8, $02, $00, $f8, $00, $01, $00, $f8, $f8, $00
    db $00
UnitHPTransferAnimation:
    db $17, $61, $ff, $00, $00
    assert @ == $612d

section "Unit HP Transfer Graphics", romx[$612d], bank[$0c]
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3e, $07, $7c, $3f, $7e, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $7c, $e0, $7e, $fc, $7e, $fc
    db $3e, $1f, $1e, $0f, $1e, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $7c, $f8, $78, $f0, $78, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3e, $07, $7d, $3f, $7f, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $9e, $fc, $3e, $fc
    db $3e, $1f, $1c, $0f, $1c, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $7c, $f8, $f8, $f0, $18, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3e, $07, $7d, $3f, $7f, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $9e, $fc, $3e, $fc
    db $3f, $1f, $1d, $0f, $1e, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $9c, $f8, $98, $f0, $38, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3f, $07, $7e, $3f, $7d, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $3e, $fc, $3e, $fc
    db $3b, $1f, $18, $0f, $1f, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $3c, $f8, $18, $f0, $38, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3c, $07, $7c, $3f, $7c, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $fe, $fc, $3e, $fc
    db $3f, $1f, $1f, $0f, $1c, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $9c, $f8, $98, $f0, $38, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3c, $07, $79, $3f, $78, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $fe, $fc, $3e, $fc
    db $39, $1f, $19, $0f, $1c, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $9c, $f8, $98, $f0, $38, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3c, $07, $7f, $3f, $7e, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $3e, $fc, $7e, $fc
    db $3e, $1f, $1e, $0f, $1e, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $7c, $f8, $78, $f0, $78, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3c, $07, $79, $3f, $7c, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $9e, $fc, $3e, $fc
    db $39, $1f, $19, $0f, $1c, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $9c, $f8, $98, $f0, $38, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    db $00, $00, $01, $00, $03, $01, $03, $01, $07, $03, $3c, $07, $79, $3f, $79, $3f
    db $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $c0, $3c, $e0, $9e, $fc, $9e, $fc
    db $3c, $1f, $1f, $0f, $1c, $0f, $3f, $1f, $3f, $1e, $3e, $18, $18, $00, $00, $00
    db $1c, $f8, $98, $f0, $38, $f0, $fc, $f8, $fc, $78, $7c, $18, $18, $00, $00, $00
    assert @ == $636d

section "Unit HP Transfer Palette", romx[$636d], bank[$0c]
    db $d2, $3e, $46, $00, $20, $00, $ff, $03
    assert @ == $6375

section "Map HP Change Sprite Frames", romx[$6375], bank[$0c]
    db $04, $00, $00, $03, $00, $00, $f8, $02, $00, $f8, $00, $01, $00, $f8, $f8, $00
    db $00, $04, $00, $00, $07, $00, $00, $f8, $02, $00, $f8, $00, $05, $00, $f8, $f8
    db $00, $00, $04, $00, $00, $09, $00, $00, $f8, $02, $00, $f8, $00, $08, $00, $f8
    db $f8, $00, $00, $04, $00, $00, $0b, $00, $00, $f8, $02, $00, $f8, $00, $0a, $00
    db $f8, $f8, $00, $00, $04, $00, $00, $03, $01, $00, $f8, $06, $01, $f8, $00, $01
    db $01, $f8, $f8, $04, $01, $04, $00, $00, $07, $01, $00, $f8, $06, $01, $f8, $00
    db $05, $01, $f8, $f8, $04, $01, $04, $00, $00, $09, $01, $00, $f8, $06, $01, $f8
    db $00, $08, $01, $f8, $f8, $04, $01, $04, $00, $00, $0b, $01, $00, $f8, $06, $01
    db $f8, $00, $0a, $01, $f8, $f8, $04, $01
MapHPChangeAnimationPlus1:
    db $75, $63, $ff, $00, $00
MapHPChangeAnimationPlus2:
    db $86, $63, $ff, $00, $00
MapHPChangeAnimationPlus3:
    db $97, $63, $ff, $00, $00
MapHPChangeAnimationPlus4:
    db $a8, $63, $ff, $00, $00
MapHPChangeAnimationMinus1:
    db $b9, $63, $ff, $00, $00
MapHPChangeAnimationMinus2:
    db $ca, $63, $ff, $00, $00
MapHPChangeAnimationMinus3:
    db $db, $63, $ff, $00, $00
MapHPChangeAnimationMinus4:
    db $ec, $63, $ff, $00, $00
MapHPChangeAnimationPointers:
    db $fd, $63, $02, $64, $07, $64, $0c, $64, $11, $64, $16, $64, $1b, $64, $20, $64
    assert @ == $6435

section "Map HP Change Graphics", romx[$6435], bank[$0c]
    db $0f, $00, $30, $0f, $40, $3f, $80, $7f, $80, $7f, $88, $7f, $88, $7f, $be, $7f
    db $f0, $00, $0c, $f0, $02, $fc, $01, $fe, $31, $fe, $71, $fe, $31, $fe, $31, $fe
    db $88, $7f, $88, $7f, $40, $3f, $30, $0f, $0f, $00, $02, $01, $03, $00, $00, $00
    db $31, $fe, $31, $fe, $02, $fc, $0c, $f0, $30, $c0, $40, $80, $80, $00, $00, $00
    db $0f, $00, $30, $0f, $40, $3f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $be, $7f
    db $f0, $00, $0c, $f0, $02, $fc, $01, $fe, $39, $fe, $4d, $fe, $19, $fe, $31, $fe
    db $80, $7f, $80, $7f, $40, $3f, $30, $0f, $0f, $00, $02, $01, $03, $00, $00, $00
    db $61, $fe, $7d, $fe, $02, $fc, $0c, $f0, $30, $c0, $40, $80, $80, $00, $00, $00
    db $f0, $00, $0c, $f0, $02, $fc, $01, $fe, $39, $fe, $4d, $fe, $19, $fe, $0d, $fe
    db $4d, $fe, $39, $fe, $02, $fc, $0c, $f0, $30, $c0, $40, $80, $80, $00, $00, $00
    db $f0, $00, $0c, $f0, $02, $fc, $01, $fe, $19, $fe, $39, $fe, $59, $fe, $99, $fe
    db $fd, $fe, $19, $fe, $02, $fc, $0c, $f0, $30, $c0, $40, $80, $80, $00, $00, $00
    assert @ == $64f5

section "Map HP Change Palettes", romx[$64f5], bank[$0c]
MapHPChangePalettes::
    db $cd, $36, $00, $00, $79, $7f, $c0, $54, $10, $3b, $00, $00, $df, $62, $0f, $00
    assert @ == $6505

section "Map Status Marker Sprite Resources", romx[$6505], bank[$0c]
    db $04, $00, $00, $03, $00, $00, $f8, $02, $00, $f8, $00, $01, $00, $f8, $f8, $00
    db $00, $04, $00, $00, $07, $00, $00, $f8, $06, $00, $f8, $00, $05, $00, $f8, $f8
    db $04, $00, $04, $00, $00, $0b, $00, $00, $f8, $0a, $00, $f8, $00, $09, $00, $f8
    db $f8, $08, $00
UnitRankUpFrame1:
    db $08, $ff, $08, $13, $00, $ff, $00, $12, $00, $ff, $f8, $11, $00, $ff, $f0, $10
    db $00, $f7, $08, $0f, $00, $f7, $00, $0e, $00, $f7, $f8, $0d, $00, $f7, $f0, $0c
    db $00
MaximumFlankMarkerAnimation:
    db $05, $65, $05, $16, $65, $0f, $16, $65, $ff, $00, $00
UnitRankUpAnimation:
    db $27, $65, $05, $38, $65, $0f, $38, $65, $ff, $00, $00
MapStatusMarkerAnimationPointers:
    db $59, $65, $64, $65
    assert @ == $6573

section "Map Status Marker Graphics", romx[$6573], bank[$0c]
    db $00, $00, $00, $00, $00, $00, $06, $00, $05, $02, $1c, $03, $10, $0f, $08, $07
    db $00, $00, $00, $00, $30, $00, $50, $20, $90, $60, $1c, $e0, $04, $f8, $08, $f0
    db $08, $07, $10, $0f, $20, $1f, $3c, $03, $05, $02, $02, $00, $00, $00, $00, $00
    db $10, $e0, $08, $f0, $04, $f8, $9c, $60, $50, $20, $30, $00, $00, $00, $00, $00
    db $00, $00, $0c, $00, $0a, $04, $09, $06, $79, $06, $43, $3d, $23, $1d, $13, $0d
    db $18, $00, $28, $10, $48, $30, $88, $70, $cf, $30, $e1, $de, $e2, $dc, $e4, $d8
    db $11, $0e, $21, $1e, $41, $3e, $81, $7e, $f8, $07, $09, $06, $0a, $04, $0c, $00
    db $c8, $b0, $c4, $38, $c2, $bc, $c1, $3e, $8f, $70, $48, $30, $28, $10, $18, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $10, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f8, $00, $04, $f8
    db $20, $1f, $20, $1f, $20, $1f, $21, $1e, $23, $1c, $10, $0f, $0f, $00, $00, $00
    db $c2, $3c, $e2, $1c, $a2, $5c, $82, $7c, $02, $fc, $04, $f8, $78, $80, $80, $00
    db $07, $00, $18, $07, $20, $1f, $40, $3f, $4c, $33, $4c, $33, $4c, $33, $4c, $33
    db $ff, $00, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $d9, $26, $d9, $26, $71, $8e
    db $ff, $00, $00, $ff, $00, $ff, $00, $ff, $b7, $48, $b6, $49, $b6, $49, $b7, $48
    db $f0, $00, $0c, $f0, $02, $fc, $01, $fe, $99, $66, $d9, $26, $d9, $26, $81, $7e
    db $4f, $30, $40, $3f, $20, $1f, $18, $07, $07, $00, $00, $00, $00, $00, $00, $00
    db $20, $df, $00, $ff, $00, $ff, $00, $ff, $fe, $01, $01, $00, $01, $00, $00, $00
    db $e6, $19, $00, $ff, $00, $ff, $00, $ff, $3f, $c0, $40, $80, $40, $80, $80, $00
    db $19, $e6, $01, $fe, $02, $fc, $0c, $f0, $f0, $00, $00, $00, $00, $00, $00, $00
    assert @ == $66b3

section "Map Status Marker Palette", romx[$66b3], bank[$0c]
    db $d2, $3e, $00, $00, $ff, $7f, $3e, $16
    assert @ == $66bb
