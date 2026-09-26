include "macros/macros.inc"
include "constants/presentation_constants.inc"

; Result-presentation services used by the selected-map transition controller.
; The three public entries are selected by the already-proven resolution type:
; HQ loss, force/scenario defeat, and the common Yield/turn-limit path.
;
; These routines primarily stage side/palette state, build advanced-sprite
; effects, and run the result presentation. Lower-level Bank-$1A/$27 helper
; identities remain conservative unless already source-backed elsewhere.

section "Map Result Presentation Services", romx[$6089], bank[$1a]

MapResult_PresentHQLoss::
    ld [wPresentationParam1],a
    cp $00
    jr z,.loc_6092
    jr .loc_6096
.loc_6092:
    ld a,$01
    jr .loc_6098
.loc_6096:
    ld a,$00
.loc_6098:
    ld [wSpritePaletteVariant],a
    xor a
    ld [wPresentationParam0],a
    xor a ; PRESENTATION_SEQUENCE_HQ_LOSS / property-capture-complete sequence
    call Presentation_RunSequenceByIndex
    ret
MapResult_PresentForceDefeat::
    ld [wSpritePaletteVariant],a
    cp $00
    jr z,.loc_60ad
    jr .loc_60b6
.loc_60ad:
    ld a,$00
    ld [wPresentationParam1],a
    ld a,$01
    jr .loc_60bf
.loc_60b6:
    ld a,$01
    ld [wPresentationParam1],a
    ld a,$00
    jr .loc_60bf
.loc_60bf:
    ld [wPresentationParam0],a
    farcall $17, AdvancedSprite_Reset
    farcall $27, Presentation_ResetDisplayState
    ld a,[wPresentationParam0]
    ld b,a
    xor a
    call CampaignBackground_LoadInset4
    ld a,$2b
    call Audio_PlayMusic
    call FadeFromWhite8
    ld de,$001e
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jp c,.loc_6258
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[$c4a0]
    cp $00
    jr z,.loc_60f8
    ld a,$00
    jr .loc_60fa
.loc_60f8:
    ld a,$01
.loc_60fa:
    ld [wSpritePaletteVariant],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$5a
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$5870
    farcall $17, AdvancedSprite_Add
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld a,$1e
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$5a
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$5870
    farcall $17, AdvancedSprite_Add
    ld a,$3d
    call Audio_PlaySFX
    ld de,$0078
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jp c,.loc_6258
    ld de,$005a
    ld bc,$0000
    ld a,$00
    farcall $31, Presentation_WaitWithAlternatingPalette
    jp c,.loc_6258
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[$c4a0]
    cp $00
    jr z,.loc_61b4
    ld a,$00
    jr .loc_61b6
.loc_61b4:
    ld a,$01
.loc_61b6:
    ld [wSpritePaletteVariant],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$73
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$43
    ld [wAdvancedSpriteCallback],a
    ld a,$8f
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$b070
    farcall $17, AdvancedSprite_Add
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$73
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$43
    ld [wAdvancedSpriteCallback],a
    ld a,$8f
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$e070
    farcall $17, AdvancedSprite_Add
    ld a,$3d
    call Audio_PlaySFX
    ld de,$00b4
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,.loc_6258
.loc_6258:
    call Audio_StopSFX
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret
MapResult_PresentTurnLimitOrYield::
    ld [wSpritePaletteVariant],a
    farcall $17, AdvancedSprite_Reset
    farcall $27, Presentation_ResetDisplayState
    ld a,[$c4a0]
    ld b,a
    xor a
    call CampaignBackground_LoadInset4
    ld a,$2b
    call Audio_PlayMusic
    call FadeFromWhite8
    ld de,$001e
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jp c,.loc_6375
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$5870
    farcall $17, AdvancedSprite_Add
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$1c
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$d8
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld a,$1e
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$f0
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$80
    ld hl,$3a70
    farcall $17, AdvancedSprite_Add
    ld a,$98
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$5870
    farcall $17, AdvancedSprite_Add
    ld a,$d8
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld a,$1e
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$f0
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$80
    ld hl,$7570
    farcall $17, AdvancedSprite_Add
    ld de,$00b4
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,.loc_6375
.loc_6375:
    call Audio_StopSFX
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

    assert @ == $6380
