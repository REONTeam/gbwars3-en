include "macros/macros.inc"

; Alternate two-byte unit sprite definitions used by the Bank $1A presentation
; sequence runtime. The record format matches the ordinary unit sprite table:
; graphics-group ID followed by animation ID.

section "Presentation Unit Sprite Lookup", romx[$45a5], bank[$1a]

PresentationUnitSprite_LoadDefinition::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ld b, $02
    call MultiplyAByB
    ld bc, PresentationUnitSpriteDefinitions
    add hl, bc
    ld a, [hl+]
    push hl
    ld hl, $8000
    call SpriteGroup_LoadGraphicsAndPalettes
    pop hl
    ld a, [hl]
    ld [wUnitSpriteAnimationID], a
    farcall $1a, SpriteAnimation_GetFarPointer
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $45d0

section "Presentation Unit Sprite Definitions", romx[$6380], bank[$1a]

PresentationUnitSpriteDefinitions::
    db $00, $00 ;  0
    db $00, $00 ;  1
    db $00, $00 ;  2
    db $0d, $98 ;  3
    db $00, $00 ;  4
    db $00, $00 ;  5
    db $05, $38 ;  6
    db $00, $00 ;  7
    db $06, $40 ;  8
    db $00, $00 ;  9
    db $07, $48 ; 10
    db $00, $00 ; 11
    db $07, $50 ; 12
    db $00, $00 ; 13
    db $08, $58 ; 14
    db $00, $00 ; 15
    db $09, $60 ; 16
    db $00, $00 ; 17
    db $09, $68 ; 18
    db $00, $00 ; 19
    db $0a, $70 ; 20
    db $00, $00 ; 21
    db $0b, $78 ; 22
    db $00, $00 ; 23
    db $0b, $80 ; 24
    db $00, $00 ; 25
    db $0c, $88 ; 26
    db $00, $00 ; 27
    db $0c, $90 ; 28
    db $00, $00 ; 29
    db $00, $00 ; 30
    db $10, $a2 ; 31
    db $00, $00 ; 32
    db $00, $00 ; 33
    db $10, $a3 ; 34
    db $00, $00 ; 35
    db $10, $a4 ; 36
    db $00, $00 ; 37
    db $00, $00 ; 38
    db $00, $00 ; 39
    db $01, $11 ; 40
    db $00, $00 ; 41
    db $00, $00 ; 42
    db $00, $08 ; 43
    db $03, $1c ; 44
    db $0f, $a0 ; 45
    db $00, $00 ; 46
    db $00, $00 ; 47
    db $00, $00 ; 48
    db $00, $00 ; 49
    db $00, $00 ; 50
    db $0f, $a1 ; 51

    assert @ == $63e8
