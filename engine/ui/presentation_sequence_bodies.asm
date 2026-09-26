include "macros/macros.inc"
include "constants/presentation_constants.inc"

; Bank $1A presentation-sequence bodies selected by Presentation_RunSequenceByIndex.
; This range is executable code except for the three compact lookup tables at
; $46C8-$46F4. Advanced-sprite callback bodies are kept as explicit mnemonic
; source even when reached only through staged callback pointers.

section "Presentation Sequence Bodies", romx[$45d0], bank[$1a]

PresentationSequence_PropertyCaptureComplete::
PresentationSequence_HQLoss::
    call PresentationRuntime_47B5
    jp c,PresentationRuntime_467E
    ld de,$00b4
    ld bc,$0000
    ld a,$01
    farcall $31, Presentation_WaitWithAlternatingPaletteSlow
    jp c,PresentationRuntime_467E
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
    ld a,$43
    ld [wAdvancedSpriteCallback],a
    ld a,$8f
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PropertyPresentation_GetPointerB
    farcall $17, AdvancedSprite_Add
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$98
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$43
    ld [wAdvancedSpriteCallback],a
    ld a,$8f
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PropertyPresentation_GetPointerB
    farcall $17, AdvancedSprite_Add
    ld de,$005a
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_467E
PresentationRuntime_467E:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PropertyPresentation_GetTimingByte::
    push bc
    ld a,[wPresentationParam0]
    ld b,$00
    ld c,a
    ld hl,PropertyPresentation_TimingTable
    add hl,bc
    ld a,[hl]
    pop bc
    ret

PropertyPresentation_GetPointerA::
    push bc
    push de
    ld a,[wPresentationParam0]
    ld b,$02
    call MultiplyAByB
    ld bc,PropertyPresentation_PointerTableA
    add hl,bc
    ld a,[hli]
    ld c,a
    ld a,[hl]
    ld b,a
    ld h,b
    ld l,c
    pop de
    pop bc
    ret

PropertyPresentation_GetPointerB::
    push bc
    push de
    ld a,[wPresentationParam0]
    ld b,$02
    call MultiplyAByB
    ld bc,PropertyPresentation_PointerTableB
    add hl,bc
    ld a,[hli]
    ld c,a
    ld a,[hl]
    ld b,a
    ld h,b
    ld l,c
    pop de
    pop bc
    ret

PropertyPresentation_TimingTable::
    db $5a, $69, $5a, $41, $64, $64, $5a, $5a, $5a
PropertyPresentation_PointerTableA::
    dw $b070, $b068, $b068, $a868, $b068, $b068, $b068, $b068, $b068
PropertyPresentation_PointerTableB::
    dw $5870, $4868, $5868, $6068, $4868, $4868, $5868, $5868, $5868

PresentationSequence_PropertyCaptureProgress::
    call PresentationRuntime_47B5
    jp c,PresentationRuntime_47A7
    ld de,$00b4
    ld bc,$0000
    xor a
    farcall $31, Presentation_WaitWithAlternatingPaletteSlow
    jp c,PresentationRuntime_47A7
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$98
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    call PropertyPresentation_GetTimingByte
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PropertyPresentation_GetPointerB
    farcall $17, AdvancedSprite_Add
    ld a,$3d
    call Audio_PlaySFX
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$98
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld a,$1e
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    call PropertyPresentation_GetTimingByte
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PropertyPresentation_GetPointerB
    farcall $17, AdvancedSprite_Add
    ld de,$0096
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_47A7
PresentationRuntime_47A7:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_47B5:
    ld a,[wPresentationParam1]
    ld b,a
    ld a,[wPresentationParam0]
    call CampaignBackground_LoadInset4
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
    call PropertyPresentation_GetTimingByte
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PropertyPresentation_GetPointerA
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
    call PropertyPresentation_GetTimingByte
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PropertyPresentation_GetPointerA
    farcall $17, AdvancedSprite_Add
    ld a,$3d
    call Audio_PlaySFX
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_4857
    ld a,$2b
    call Audio_PlayMusic
PresentationRuntime_4857:
    call FadeFromWhite8
    ld de,$00d2
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr nc,PresentationRuntime_4869
    scf
    jr PresentationRuntime_486E

PresentationRuntime_4869:
    ld a,$3c
    call Audio_PlaySFX
PresentationRuntime_486E:
    ret

PresentationSequence_TerrainTransformation::
    ld a,[wPresentationParam1]
    ld b,a
    ld a,[wPresentationParam0]
    call CampaignBackground_LoadInset4
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$92
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$78
    ld [wAdvancedSpriteDuration],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$8070
    farcall $17, AdvancedSprite_Add
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$05
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$2e
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$43
    ld [wAdvancedSpriteCallback],a
    ld a,$b8
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$80
    ld hl,$5070
    farcall $17, AdvancedSprite_Add
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_490E
    ld a,$28
    call Audio_PlayMusic
PresentationRuntime_490E:
    ld de,$0001
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    call FadeFromWhite8
    call Sprite_Update
    ld a,$3b
    call Audio_PlaySFX
    ld de,$00f0
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_492F
PresentationRuntime_492F:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_493D:
    ld a,[wPresentationParam0]
    call PresentationRuntime_5042
    cp $00
    jr z,PresentationRuntime_4953
    cp $01
    jr z,PresentationRuntime_4966
    cp $02
    jr z,PresentationRuntime_496A
    cp $02
    jr z,PresentationRuntime_4953
PresentationRuntime_4953:
    ld a,[wPresentationParam0]
    cp $05
    jr z,PresentationRuntime_495E
    cp $06
    jr z,PresentationRuntime_4962
PresentationRuntime_495E:
    ld a,$11
    jr PresentationRuntime_496C

PresentationRuntime_4962:
    ld a,$12
    jr PresentationRuntime_496C

PresentationRuntime_4966:
    ld a,$0a
    jr PresentationRuntime_496C

PresentationRuntime_496A:
    ld a,$10
PresentationRuntime_496C:
    push af
    ld a,[wSpritePaletteVariant]
    ld b,a
    pop af
    call CampaignBackground_LoadInset4
    ret

PresentationCallback_4976:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,$40
    ld [wAdvancedSpriteCallback],a
    ld a,$00
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$31
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$9d
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    xor a
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_49B4:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_49EC)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_49EC)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$5a
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_DisableAutoAnimation
    xor a
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_49EC:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4A33)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4A33)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    ld a,[wPresentationParam1]
    cp $0f
    jr c,PresentationRuntime_4A27
    jr PresentationRuntime_4A2B

PresentationRuntime_4A27:
    ld a,$37
    jr PresentationRuntime_4A2D

PresentationRuntime_4A2B:
    ld a,$38
PresentationRuntime_4A2D:
    ld [wAdvancedSpriteActivationSfx],a
    jp ROMBankCall_Return

PresentationCallback_4A33:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$78
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationRuntime_4A5F:
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    ld a,[wPresentationParam0]
    call PresentationRuntime_5042
    cp $00
    jr z,PresentationRuntime_4A83
    cp $01
    jp z,PresentationRuntime_4B13
    cp $02
    jp z,PresentationRuntime_4B35
    cp $03
    jr z,PresentationRuntime_4AEB
PresentationRuntime_4A83:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8800
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$97
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,[wPresentationParam1]
    cp $04
    jr c,PresentationRuntime_4AB9
    ld a,$42
    ld [wAdvancedSpriteCallback],a
    ld a,$9f
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    jr PresentationRuntime_4AC5

PresentationRuntime_4AB9:
    ld a,$41
    ld [wAdvancedSpriteCallback],a
    ld a,$f3
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
PresentationRuntime_4AC5:
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,[wPresentationParam1]
    call PresentationRuntime_5042
    cp $03
    jr nz,PresentationRuntime_4ADA
    ld a,$78
    jr PresentationRuntime_4ADC

PresentationRuntime_4ADA:
    ld a,$3c
PresentationRuntime_4ADC:
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$c0
    ld hl,$4870
    farcall $17, AdvancedSprite_Add
    jp PresentationRuntime_4B55

PresentationRuntime_4AEB:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$01
    ld [wAdvancedSpriteDuration],a
    ld a,$5e
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$00
    ld hl,$2858
    farcall $17, AdvancedSprite_Add
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_DisableAutoAnimation
    jr PresentationRuntime_4B55

PresentationRuntime_4B13:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$01
    ld [wAdvancedSpriteDuration],a
    ld a,$5e
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$00
    ld hl,$5048
    farcall $17, AdvancedSprite_Add
    jr PresentationRuntime_4B55

PresentationRuntime_4B35:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$01
    ld [wAdvancedSpriteDuration],a
    ld a,$5e
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$00
    ld hl,$5070
    farcall $17, AdvancedSprite_Add
PresentationRuntime_4B55:
    ret

PresentationCallback_4B56:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4B89)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4B89)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$5a
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$4f
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_4B89:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4BC0)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4BC0)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,SFX_CONFIRM
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_4BC0:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$96
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_4BEB:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4C1E)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4C1E)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_4C1E:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4C51)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4C51)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$45
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_4C51:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4C89)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4C89)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,SFX_CONFIRM
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$46
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_4C89:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4CBA)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4CBA)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_4CBA:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$fe
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$32
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wPresentationUnitAnimationIDScratch]
    inc a
    ld [wPresentationUnitAnimationIDScratch],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jp ROMBankCall_Return

PresentationCallback_4CF6:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4D20)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4D20)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$32
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_4D20:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$40
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4D4A)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4D4A)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$30
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_4D4A:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4D9B)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4D9B)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$aa
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wPresentationParam1]
    cp $21
    jr z,PresentationRuntime_4D89
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jr PresentationRuntime_4D98

PresentationRuntime_4D89:
    ld a,$16
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
PresentationRuntime_4D98:
    jp ROMBankCall_Return

PresentationCallback_4D9B:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4DD4)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4DD4)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$01
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jp ROMBankCall_Return

PresentationCallback_4DD4:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4E28)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4E28)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$a0
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wPresentationParam1]
    cp $21
    jr z,PresentationRuntime_4E15
    ld a,[wUnitSpriteAnimationID]
    dec a
    dec a
    dec a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jr PresentationRuntime_4E15

PresentationRuntime_4E15:
    ld a,[wPresentationParam1]
    cp $21
    jr nz,PresentationRuntime_4E20
    ld a,$46
    jr PresentationRuntime_4E22

PresentationRuntime_4E20:
    ld a,$47
PresentationRuntime_4E22:
    ld [wAdvancedSpriteActivationSfx],a
    jp ROMBankCall_Return

PresentationCallback_4E28:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4E6C)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4E6C)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wPresentationParam1]
    cp $21
    jr z,PresentationRuntime_4E69
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
PresentationRuntime_4E69:
    jp ROMBankCall_Return

PresentationCallback_4E6C:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4E97)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4E97)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$05
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_4E97:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$fe
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$42
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationRuntime_4EBC:
    ld a,[wPresentationParam1]
    call PresentationRuntime_5042
    cp $00
    jr z,PresentationRuntime_4ED5
    cp $01
    jp z,PresentationRuntime_4FD5
    cp $02
    jp z,PresentationRuntime_500C
    cp $03
    jp z,PresentationRuntime_4F81
PresentationRuntime_4ED5:
    ld a,[wPresentationParam1]
    cp $04
    jr c,PresentationRuntime_4F35
    ld a,[wUnitSpriteAnimationID]
    inc a
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,HIGH(PresentationCallback_49B4)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_49B4)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$5a
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$b070
    ld a,[wPresentationParam1]
    cp $0f
    jr c,PresentationRuntime_4F25
    jr PresentationRuntime_4F29

PresentationRuntime_4F25:
    ld a,$37
    jr PresentationRuntime_4F2B

PresentationRuntime_4F29:
    ld a,$38
PresentationRuntime_4F2B:
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jp PresentationRuntime_5041

PresentationRuntime_4F35:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8800
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,HIGH(PresentationCallback_4976)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4976)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$c0
    ld hl,$b870
    ld a,$3a
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jp PresentationRuntime_5041

PresentationRuntime_4F81:
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_4CF6)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4CF6)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$35
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$8818
    ld a,[wPresentationParam1]
    cp $21
    jr nz,PresentationRuntime_4FCA
    ld a,$58
    jr PresentationRuntime_4FCC

PresentationRuntime_4FCA:
    ld a,$4b
PresentationRuntime_4FCC:
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jr PresentationRuntime_5041

PresentationRuntime_4FD5:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,HIGH(PresentationCallback_4BEB)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4BEB)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$5a
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$c054
    ld a,$44
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jr PresentationRuntime_5041

PresentationRuntime_500C:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,HIGH(PresentationCallback_4B56)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_4B56)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$d2
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$c072
    farcall $17, AdvancedSprite_Add
PresentationRuntime_5041:
    ret

PresentationRuntime_5042:
    cp $1d
    jr c,PresentationRuntime_5058
    cp $21
    jr c,PresentationRuntime_505A
    jr z,PresentationRuntime_5060
    cp $27
    jr c,PresentationRuntime_505A
    cp $2c
    jr c,PresentationRuntime_5060
    cp $34
    jr c,PresentationRuntime_505D
PresentationRuntime_5058:
    xor a
    ret

PresentationRuntime_505A:
    ld a,$01
    ret

PresentationRuntime_505D:
    ld a,$02
    ret

PresentationRuntime_5060:
    ld a,$03
    ret

PresentationSequence_Supply::
    call PresentationRuntime_493D
    ld a,[wPresentationParam1]
    call PresentationRuntime_5042
    cp $01
    jr z,PresentationRuntime_5072
    jr PresentationRuntime_508C

PresentationRuntime_5072:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam1]
    call UnitSprite_LoadDefinition
    ld a,[wUnitSpriteAnimationID]
    ld [wPresentationUnitAnimationIDScratch],a
    call PresentationRuntime_4EBC
    call PresentationRuntime_4A5F
    jr PresentationRuntime_509E

PresentationRuntime_508C:
    call PresentationRuntime_4A5F
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam1]
    call UnitSprite_LoadDefinition
    call PresentationRuntime_4EBC
PresentationRuntime_509E:
    ld de,$0001
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_50B4
    ld a,$25
    call Audio_PlayMusic
PresentationRuntime_50B4:
    call FadeFromWhite8
    ld a,[wPresentationParam1]
    call PresentationRuntime_5042
    cp $00
    jr z,PresentationRuntime_50CD
    cp $01
    jr z,PresentationRuntime_50F7
    cp $02
    jr z,PresentationRuntime_50DB
    cp $03
    jr z,PresentationRuntime_50E9
PresentationRuntime_50CD:
    ld de,$0122
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5103
    jr PresentationRuntime_5103

PresentationRuntime_50DB:
    ld de,$012c
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5103
    jr PresentationRuntime_5103

PresentationRuntime_50E9:
    ld de,$028a
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5103
    jr PresentationRuntime_5103

PresentationRuntime_50F7:
    ld de,$00ff
    ld bc,$fe00
    jr c,PresentationRuntime_5103
    farcall $27, Presentation_WaitFramesOrCancel
PresentationRuntime_5103:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_5111:
    ld a,[wPresentationParam1]
    cp $0d
    jr z,PresentationRuntime_512C
    cp $0e
    jr z,PresentationRuntime_512C
    cp $2a
    jr z,PresentationRuntime_512C
    cp $2b
    jr z,PresentationRuntime_512C
    cp $25
    jr z,PresentationRuntime_512E
    cp $30
    jr z,PresentationRuntime_5131
PresentationRuntime_512C:
    xor a
    ret

PresentationRuntime_512E:
    ld a,$01
    ret

PresentationRuntime_5131:
    ld a,$02
    ret

PresentationRuntime_5134:
    call PresentationRuntime_5111
    cp $00
    jr z,PresentationRuntime_5143
    cp $01
    jr z,PresentationRuntime_514F
    cp $02
    jr z,PresentationRuntime_5165
PresentationRuntime_5143:
    ld a,$09
    push af
    ld a,[wSpritePaletteVariant]
    ld b,a
    pop af
    call CampaignBackground_LoadInset4Duplicate
    ret

PresentationRuntime_514F:
    ld a,$0b
    push af
    ld a,[wSpritePaletteVariant]
    ld b,a
    pop af
    call CampaignBackground_LoadInset4Duplicate
    ld bc,$0f07
    ld de,$0506
    farcall $15, Gfx_SetTileRectPriority
    ret

PresentationRuntime_5165:
    ld a,$0c
    push af
    ld a,[wSpritePaletteVariant]
    ld b,a
    pop af
    call CampaignBackground_LoadInset4Duplicate
    ld bc,$0f07
    ld de,$0506
    farcall $15, Gfx_SetTileRectPriority
    ret

PresentationCallback_517B:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_51AC)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_51AC)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$02
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_51AC:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$7d
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_51D7:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$fe
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_520A)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_520A)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$02
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_520A:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_523D)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_523D)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$04
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_523D:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld [wAdvancedSpriteDuration],a
    ld a,$08
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationRuntime_526B:
    ld a,[wPresentationParam0]
    cp $04
    jr c,PresentationRuntime_52D4
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    ld a,[wUnitSpriteAnimationID]
    inc a
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_517B)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_517B)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$4068
    ld a,[wPresentationParam0]
    cp $0f
    jr c,PresentationRuntime_52C4
    jr PresentationRuntime_52C8

PresentationRuntime_52C4:
    ld a,$41
    jr PresentationRuntime_52CA

PresentationRuntime_52C8:
    ld a,$42
PresentationRuntime_52CA:
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jp PresentationRuntime_5386

PresentationRuntime_52D4:
    ld a,[wPresentationParam1]
    cp $25
    jr z,PresentationRuntime_5332
    cp $30
    jr z,PresentationRuntime_5332
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$93
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_51D7)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_51D7)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$50
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$00
    ld hl,$a068
    ld a,$43
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jp PresentationRuntime_5386

PresentationRuntime_5332:
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    ld a,[wUnitSpriteAnimationID]
    add a,$05
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_517B)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_517B)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$4868
    ld a,$43
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jr PresentationRuntime_5386

PresentationRuntime_5386:
    ret

PresentationCallback_5387:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_53BE)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_53BE)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$28
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    ld a,$41
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_53BE:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_53E8:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_541B)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_541B)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$98
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    ld a,$47
    ld [wAdvancedSpriteActivationSfx],a
    jp ROMBankCall_Return

PresentationCallback_541B:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5455)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5455)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wUnitSpriteAnimationID]
    inc a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jp ROMBankCall_Return

PresentationCallback_5455:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5480)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5480)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$05
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5480:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$fe
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$42
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationRuntime_54A5:
    ld a,[wPresentationParam1]
    cp $07
    jr z,PresentationRuntime_54CB
    cp $08
    jr z,PresentationRuntime_54CB
    cp $0d
    jr z,PresentationRuntime_54CB
    cp $0e
    jr z,PresentationRuntime_54CB
    cp $17
    jr z,PresentationRuntime_54CB
    cp $18
    jr z,PresentationRuntime_54CB
    cp $2a
    jr z,PresentationRuntime_5513
    cp $2b
    jr z,PresentationRuntime_5513
    jp PresentationRuntime_5559

PresentationRuntime_54CB:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam1]
    call UnitSprite_LoadDefinition
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5387)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5387)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$78
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$3064
    farcall $17, AdvancedSprite_Add
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_DisableAutoAnimation
    jr PresentationRuntime_5559

PresentationRuntime_5513:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam1]
    call UnitSprite_LoadDefinition
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_53E8)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_53E8)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$05
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$3068
    farcall $17, AdvancedSprite_Add
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_DisableAutoAnimation
PresentationRuntime_5559:
    ret

PresentationSequence_Load::
    call PresentationRuntime_5134
    call PresentationRuntime_54A5
    call PresentationRuntime_526B
    ld de,$0001
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_5579
    ld a,$24
    call Audio_PlayMusic
PresentationRuntime_5579:
    call FadeFromWhite8
    ld a,[wPresentationParam1]
    cp $2a
    jr z,PresentationRuntime_5595
    cp $2b
    jr z,PresentationRuntime_5595
    ld de,$0096
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_55A1
    jr PresentationRuntime_55A1

PresentationRuntime_5595:
    ld de,$00f0
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_55A1
PresentationRuntime_55A1:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_55AF:
    ld a,[wPresentationParam1]
    cp $07
    jr z,PresentationRuntime_55D5
    cp $08
    jr z,PresentationRuntime_55D5
    cp $0d
    jr z,PresentationRuntime_55D5
    cp $0e
    jr z,PresentationRuntime_55D5
    cp $17
    jr z,PresentationRuntime_55D5
    cp $18
    jr z,PresentationRuntime_55D5
    cp $2a
    jr z,PresentationRuntime_562C
    cp $2b
    jr z,PresentationRuntime_562C
    jp PresentationRuntime_567F

PresentationRuntime_55D5:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam1]
    call UnitSprite_LoadDefinition
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,$41
    ld [wAdvancedSpriteCallback],a
    ld a,$cb
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$87
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$b864
    ld a,[wPresentationParam1]
    cp $0f
    jr c,PresentationRuntime_561D
    jr PresentationRuntime_5621

PresentationRuntime_561D:
    ld a,$51
    jr PresentationRuntime_5623

PresentationRuntime_5621:
    ld a,$52
PresentationRuntime_5623:
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jr PresentationRuntime_567F

PresentationRuntime_562C:
    ld a,$01
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam1]
    call UnitSprite_LoadDefinition
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,$40
    ld [wAdvancedSpriteCallback],a
    ld a,$e6
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$27
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$80
    ld hl,$3008
    ld a,[wPresentationParam1]
    cp $21
    jr nz,PresentationRuntime_5676
    ld a,$58
    jr PresentationRuntime_5678

PresentationRuntime_5676:
    ld a,$4b
PresentationRuntime_5678:
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
PresentationRuntime_567F:
    ret

PresentationCallback_5680:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_56B1)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_56B1)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$02
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_56B1:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$d2
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_56DD:
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5710)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5710)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$04
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_5710:
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$02
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5743)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5743)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$02
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationCallback_5743:
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld [wAdvancedSpriteDuration],a
    ld a,$50
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    jp ROMBankCall_Return

PresentationRuntime_576C:
    ld a,[wPresentationParam0]
    cp $04
    jr c,PresentationRuntime_57F1
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5680)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5680)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$76
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$9868
    farcall $17, AdvancedSprite_Add
    ld a,[wPresentationParam1]
    cp $25
    jr z,PresentationRuntime_57BF
    jr PresentationRuntime_57D8

PresentationRuntime_57BF:
    call PresentationRuntime_5AC7
    cp $00
    jr z,PresentationRuntime_57C8
    jr PresentationRuntime_57D0

PresentationRuntime_57C8:
    ld a,$49
    call Audio_PlaySFX
    jp PresentationRuntime_589D

PresentationRuntime_57D0:
    ld a,$4a
    call Audio_PlaySFX
    jp PresentationRuntime_589D

PresentationRuntime_57D8:
    call PresentationRuntime_5AC7
    cp $00
    jr z,PresentationRuntime_57E1
    jr PresentationRuntime_57E9

PresentationRuntime_57E1:
    ld a,$51
    call Audio_PlaySFX
    jp PresentationRuntime_589D

PresentationRuntime_57E9:
    ld a,$52
    call Audio_PlaySFX
    jp PresentationRuntime_589D

PresentationRuntime_57F1:
    ld a,[wPresentationParam1]
    cp $25
    jr z,PresentationRuntime_5853
    cp $30
    jr z,PresentationRuntime_5853
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0d
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$98
    farcall $1a, SpriteAnimation_GetFarPointer
    xor a
    ld [wAdvancedSpriteDelay],a
    ld a,$be
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_56DD)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_56DD)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$08
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$00
    ld hl,$4a5c
    ld a,$48
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jp PresentationRuntime_589D

PresentationRuntime_5853:
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5680)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5680)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$50
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$9068
    ld a,$48
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    jr PresentationRuntime_589D

PresentationRuntime_589D:
    ret

PresentationSequence_CarriedChildMove::
    call PresentationRuntime_5134
    call PresentationRuntime_55AF
    call PresentationRuntime_576C
    ld de,$0001
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_58BD
    ld a,$23
    call Audio_PlayMusic
PresentationRuntime_58BD:
    call FadeFromWhite8
    ld a,[wPresentationParam1]
    cp $2a
    jr z,PresentationRuntime_58D9
    cp $2b
    jr z,PresentationRuntime_58D9
    ld de,$0168
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_58E5
    jr PresentationRuntime_58E5

PresentationRuntime_58D9:
    ld de,$013b
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_58E5
PresentationRuntime_58E5:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_58F3:
    call PresentationRuntime_5AD5
    cp $00
    jr nz,PresentationRuntime_5905
    ld a,[wSpritePaletteVariant]
    ld b,a
    ld a,$0e
    call CampaignBackground_LoadInset4
    jr PresentationRuntime_5912

PresentationRuntime_5905:
    ld a,$f4
    ldh [hSCX],a
    ld a,[wSpritePaletteVariant]
    ld b,a
    ld a,$0d
    call CampaignBackground_LoadInset4
PresentationRuntime_5912:
    ret

PresentationSequence_CarriedChildMoveSpecialCarrier::
    call PresentationRuntime_58F3
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    call PresentationRuntime_5AD5
    cp $00
    jr nz,PresentationRuntime_592E
    call PresentationRuntime_598F
    jr PresentationRuntime_5931

PresentationRuntime_592E:
    call PresentationRuntime_5A95
PresentationRuntime_5931:
    farcall $17, AdvancedSprite_Add
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_5941
    ld a,$23
    call Audio_PlayMusic
PresentationRuntime_5941:
    ld de,$0001
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    call FadeFromWhite8
    call DelayFrame
    call Sprite_Update
    call PresentationRuntime_5AD5
    cp $00
    jr nz,PresentationRuntime_5969
    ld de,$0100
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5981
    jr PresentationRuntime_5981

PresentationRuntime_5969:
    ld de,$003c
    ld bc,$ff00
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5981
    ld de,$00f0
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5981
PresentationRuntime_5981:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_598F:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5AEC)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5AEC)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$98
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$7058
    ld a,[wPresentationParam0]
    cp $21
    jr z,PresentationRuntime_59C8
    ld a,$54
    jr PresentationRuntime_59C9

PresentationRuntime_59C8:
    xor a
PresentationRuntime_59C9:
    ld [wAdvancedSpriteActivationSfx],a
    ret

PresentationCallback_59CD:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5A0B)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5A0B)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    ld a,$66
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_5A0B:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5A44)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5A44)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jp ROMBankCall_Return

PresentationCallback_5A44:
    ld a,$fd
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5A70)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5A70)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$0f
    ld [wAdvancedSpriteDuration + 1],a
    ld a,$46
    call Audio_PlaySFX
    jp ROMBankCall_Return

PresentationCallback_5A70:
    ld a,$fd
    ld [wAdvancedSpriteVelocityX],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$28
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationRuntime_5A95:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    xor a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_59CD)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_59CD)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$5458
    ret

PresentationRuntime_5AC7:
    ld a,[wPresentationParam0]
    cp $0f
    jr c,PresentationRuntime_5AD0
    jr PresentationRuntime_5AD2

PresentationRuntime_5AD0:
    xor a
    ret

PresentationRuntime_5AD2:
    ld a,$01
    ret

PresentationRuntime_5AD5:
    ld a,[wPresentationParam0]
    cp $21
    jr c,PresentationRuntime_5AE7
    jr z,PresentationRuntime_5AE4
    cp $27
    jr c,PresentationRuntime_5AE7
    jr PresentationRuntime_5AE4

PresentationRuntime_5AE4:
    xor a
    jr PresentationRuntime_5AEB

PresentationRuntime_5AE7:
    ld a,$01
    jr PresentationRuntime_5AEB

PresentationRuntime_5AEB:
    ret

PresentationCallback_5AEC:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5B32)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5B32)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wUnitSpriteAnimationID]
    inc a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    ld a,[wPresentationParam0]
    cp $21
    jr z,PresentationRuntime_5B2A
    xor a
    jr PresentationRuntime_5B2C

PresentationRuntime_5B2A:
    ld a,$46
PresentationRuntime_5B2C:
    ld [wAdvancedSpriteActivationSfx],a
    jp ROMBankCall_Return

PresentationCallback_5B32:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5B5A)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5B5A)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$08
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5B5A:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$fe
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld [wAdvancedSpriteDuration],a
    ld a,$42
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationRuntime_5B78:
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,$01
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5BBA)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5BBA)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$35
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$7000
    ld a,[wPresentationParam0]
    cp $21
    jr z,PresentationRuntime_5BB4
    ld a,$4b
    jr PresentationRuntime_5BB6

PresentationRuntime_5BB4:
    ld a,$58
PresentationRuntime_5BB6:
    ld [wAdvancedSpriteActivationSfx],a
    ret

PresentationCallback_5BBA:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$80
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5BFC)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5BFC)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$32
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wPresentationParam0]
    cp $21
    jr z,PresentationRuntime_5BF9
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
PresentationRuntime_5BF9:
    jp ROMBankCall_Return

PresentationCallback_5BFC:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$40
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5C26)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5C26)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$30
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5C26:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5C77)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5C77)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$98
    ld [wAdvancedSpriteDuration + 1],a
    ld a,[wPresentationParam0]
    cp $21
    jr z,PresentationRuntime_5C65
    ld a,[wUnitSpriteAnimationID]
    inc a
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
    jr PresentationRuntime_5C74

PresentationRuntime_5C65:
    ld a,$16
    ld [wUnitSpriteAnimationID],a
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,[wAdvancedSpriteSlot]
    call SpriteObject_SetAnimation
PresentationRuntime_5C74:
    jp ROMBankCall_Return

PresentationCallback_5C77:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationRuntime_5C99:
    ld a,$60
    ldh [hSCX],a
    xor a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$00
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$28
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5CD8)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5CD8)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$14
    ld [wAdvancedSpriteDuration + 1],a
    ld hl,$a04a
    ld a,$58
    ld [wAdvancedSpriteActivationSfx],a
    ret

PresentationCallback_5CD8:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld a,$24
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5D03)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5D03)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$50
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5D03:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$00
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5D2F)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5D2F)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$28
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5D2F:
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$80
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,HIGH(PresentationCallback_5D54)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5D54)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5D54:
    xor a
    ld a,$ff
    ld [wAdvancedSpriteVelocityX],a
    ld a,$c0
    ld [wAdvancedSpriteVelocityX + 1],a
    ld a,HIGH(PresentationCallback_5D7A)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5D7A)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5D7A:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5D9C:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld a,$20
    ld [wAdvancedSpriteVelocityX + 1],a
    xor a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld a,HIGH(PresentationCallback_5DC7)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_5DC7)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$1e
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationCallback_5DC7:
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityX + 1],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteVelocityY + 1],a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    jp ROMBankCall_Return

PresentationSequence_LoadSpecialCarrier::
    ld de,$001e
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5E73
    call PresentationRuntime_58F3
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call UnitSprite_LoadDefinition
    call PresentationRuntime_5AD5
    cp $00
    jr nz,PresentationRuntime_5E17
    ld a,[wUnitSpriteAnimationID]
    inc a
    farcall $1a, SpriteAnimation_GetFarPointer
    call PresentationRuntime_5B78
    jr PresentationRuntime_5E21

PresentationRuntime_5E17:
    ld a,[wUnitSpriteAnimationID]
    farcall $1a, SpriteAnimation_GetFarPointer
    call PresentationRuntime_5C99
PresentationRuntime_5E21:
    farcall $17, AdvancedSprite_Add
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_5E31
    ld a,$24
    call Audio_PlayMusic
PresentationRuntime_5E31:
    call FadeFromWhite8
    call DelayFrame
    call Sprite_Update
    call PresentationRuntime_5AD5
    cp $00
    jr nz,PresentationRuntime_5E4F
    ld de,$011d
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5E73
    jr PresentationRuntime_5E73

PresentationRuntime_5E4F:
    ld de,$0014
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5E73
    ld de,$0050
    ld bc,$ff00
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5E73
    ld de,$0082
    ld bc,$0000
    farcall $27, Presentation_WaitFramesOrCancel
    jr c,PresentationRuntime_5E73
PresentationRuntime_5E73:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    farcall $17, AdvancedSprite_Reset
    ret

PresentationRuntime_5E81:
    ld a,[wPresentationParam0]
    cp $1d
    jr c,PresentationRuntime_5E8E
    cp $2c
    jr c,PresentationRuntime_5E90
    jr PresentationRuntime_5E93

PresentationRuntime_5E8E:
    xor a
    ret

PresentationRuntime_5E90:
    ld a,$01
    ret

PresentationRuntime_5E93:
    ld a,$02
    ret

PresentationSequence_8::
    ld a,[wSpritePaletteVariant]
    ld b,a
    ld a,$0f
    call CampaignBackground_LoadInset4
    farcall $17, AdvancedSprite_Reset
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
    ld a,$00
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteDelay],a
    ld a,$20
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$48
    ld [wAdvancedSpriteDuration],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    ld hl,$a066
    ld a,$3a
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    ld a,[wMapControlForceStateMode]
    cp $00
    jr z,PresentationRuntime_5EF7
    ld a,$27
    call Audio_PlayMusic
PresentationRuntime_5EF7:
    call FadeFromWhite8
    ld de,$0068
    ld bc,$0000
    farcall $27, Presentation_WaitFrames
    farcall $17, AdvancedSprite_Reset
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$0e
    ld hl,$8000
    call SpriteGroup_LoadGraphicsAndPalettes
    ld a,$9f
    farcall $1a, SpriteAnimation_GetFarPointer
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    xor a
    ld [wAdvancedSpriteVelocityX],a
    ld [wAdvancedSpriteVelocityY],a
    ld [wAdvancedSpriteDelay],a
    ld [wAdvancedSpriteDelay + 1],a
    ld [wAdvancedSpriteDuration],a
    ld a,$38
    ld [wAdvancedSpriteDuration + 1],a
    ld c,$00
    ld hl,$5038
    ld a,$5c
    ld [wAdvancedSpriteActivationSfx],a
    farcall $17, AdvancedSprite_Add
    ld de,$0060
    ld bc,$0000
    farcall $27, Presentation_WaitFrames
    call FadeToWhite8
    ld b,$01
    ld a,$05
    farcall $19, NetworkRuntime_StageSelectorPairAndRun
    cp $ff
    jp z,PresentationRuntime_6035
    ld a,[$c4a6]
    cp $01
    jr z,PresentationRuntime_5F76
    ld a,[$cbde]
    cp $01
    jp z,PresentationRuntime_6035
    ld a,[$cbdd]
    cp $01
    jp z,PresentationRuntime_6031
PresentationRuntime_5F76:
    ld a,$27
    call Audio_PlayMusic
    farcall $27, Presentation_ResetDisplayState
    call FadeToWhite8
    call LCD_Disable
    farcall $17, AdvancedSprite_Reset
    call PresentationRuntime_5E81
    cp $00
    jr z,PresentationRuntime_5F98
    cp $01
    jr z,PresentationRuntime_5F9C
    cp $02
    jr z,PresentationRuntime_5FA0
PresentationRuntime_5F98:
    ld a,$13
    jr PresentationRuntime_5FA2

PresentationRuntime_5F9C:
    ld a,$0a
    jr PresentationRuntime_5FA2

PresentationRuntime_5FA0:
    ld a,$10
PresentationRuntime_5FA2:
    push af
    ld a,[wSpritePaletteVariant]
    ld b,a
    pop af
    call CampaignBackground_LoadInset4
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,[wPresentationParam0]
    call PresentationUnitSprite_LoadDefinition
    ld a,$01
    ld [wAdvancedSpriteVelocityX],a
    ld a,$00
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteDelay],a
    ld a,$20
    ld [wAdvancedSpriteDelay + 1],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$4a
    ld [wAdvancedSpriteDuration + 1],a
    ld a,HIGH(PresentationCallback_6044)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_6044)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    ld c,$00
    call PresentationRuntime_5E81
    cp $00
    jr z,PresentationRuntime_5FF3
    cp $01
    jr z,PresentationRuntime_5FF8
    cp $02
    jr z,PresentationRuntime_5FFD
PresentationRuntime_5FF3:
    ld hl,$0070
    jr z,PresentationRuntime_6002
PresentationRuntime_5FF8:
    ld hl,$0050
    jr z,PresentationRuntime_6002
PresentationRuntime_5FFD:
    ld hl,$0070
    jr z,PresentationRuntime_6002
PresentationRuntime_6002:
    farcall $17, AdvancedSprite_Add
    call FadeFromWhite8
    call PresentationRuntime_5E81
    cp $00
    jr z,PresentationRuntime_6018
    cp $01
    jr z,PresentationRuntime_601D
    cp $02
    jr z,PresentationRuntime_6022
PresentationRuntime_6018:
    ld bc,$0200
    jr PresentationRuntime_6027

PresentationRuntime_601D:
    ld bc,$0500
    jr PresentationRuntime_6027

PresentationRuntime_6022:
    ld bc,$0200
    jr PresentationRuntime_6027

PresentationRuntime_6027:
    ld de,$00d8
    farcall $27, Presentation_WaitFrames
    xor a
    jr PresentationRuntime_6037

PresentationRuntime_6031:
    ld a,$01
    jr PresentationRuntime_6037

PresentationRuntime_6035:
    ld a,$ff
PresentationRuntime_6037:
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    farcall $17, AdvancedSprite_Reset
    pop af
    ret

PresentationCallback_6044:
    ld a,$00
    ld [wAdvancedSpriteVelocityX],a
    ld a,$00
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    ld a,HIGH(PresentationCallback_6069)
    ld [wAdvancedSpriteCallback],a
    ld a,LOW(PresentationCallback_6069)
    ld [wAdvancedSpriteCallback + 1],a
    ld a,$1a
    ld [wAdvancedSpriteCallbackBank],a
    jp ROMBankCall_Return

PresentationCallback_6069:
    ld a,$03
    ld [wAdvancedSpriteVelocityX],a
    ld a,$00
    ld [wAdvancedSpriteVelocityY],a
    xor a
    ld [wAdvancedSpriteDuration],a
    ld a,$3c
    ld [wAdvancedSpriteDuration + 1],a
    xor a
    ld [wAdvancedSpriteCallback],a
    ld [wAdvancedSpriteCallback + 1],a
    ld [wAdvancedSpriteCallbackBank],a
    jp ROMBankCall_Return

assert @ == $6089
