include "macros/macros.inc"

DEF SPRITE_TRANSITION_FIELD_Y EQU $01
DEF SPRITE_TRANSITION_FIELD_X EQU $02

; Shared blocking sprite exit transitions used by Unit List, Versus, map-menu,
; battle, and network presentation paths.
;
; Both entries take a sprite-object ID in A, disable that object's automatic
; animation, play the shared transition SFX, and keep the normal joypad/sprite/
; common-UI animation services running while moving the object ten pixels per
; frame.  The first moves right; the second moves down.

section "Sprite Exit Transition Runtime", romx[$5cd0], bank[$15]

; Slide sprite A to the right until its X coordinate reaches the off-screen
; cutoff.  The final candidate at/after $D0 is not committed.
SpriteTransition_SlideRightOffscreen::
    ld [wSpriteTransitionRightObject], a
    ld a, [wSpriteTransitionRightObject]
    call SpriteObject_DisableAutoAnimation
    ld a, [wSpriteTransitionRightObject]
    ld b, SPRITE_TRANSITION_FIELD_Y
    call SpriteObject_GetField
    ld [wSpriteTransitionRightY], a
    ld a, [wSpriteTransitionRightObject]
    ld b, SPRITE_TRANSITION_FIELD_X
    call SpriteObject_GetField
    ld [wSpriteTransitionRightX], a
    call Audio_StopSFX
    ld a, SFX_SPRITE_EXIT
    call Audio_PlaySFX

.loop
    call Joypad_Update
    call Sprite_Update
    ld a, [wCommonAnimatedTileDestination]
    farcall Gfx_UpdateCommonAnimatedTile
    ld a, [wSpriteTransitionRightX]
    add $0a
    cp $d0
    jr nc, .done
    ld [wSpriteTransitionRightX], a
    ld b, a
    ld a, [wSpriteTransitionRightY]
    ld c, a
    ld a, [wSpriteTransitionRightObject]
    call SpriteObject_SetPosition
    jr .loop

.done
    ret

assert @ == $5d1e

; Slide sprite A downward until its Y coordinate reaches the off-screen cutoff.
; The final candidate at/after $B8 is not committed.
SpriteTransition_SlideDownOffscreen::
    ld [wSpriteTransitionDownObject], a
    ld a, [wSpriteTransitionDownObject]
    call SpriteObject_DisableAutoAnimation
    ld a, [wSpriteTransitionDownObject]
    ld b, SPRITE_TRANSITION_FIELD_Y
    call SpriteObject_GetField
    ld [wSpriteTransitionDownY], a
    ld a, [wSpriteTransitionDownObject]
    ld b, SPRITE_TRANSITION_FIELD_X
    call SpriteObject_GetField
    ld [wSpriteTransitionDownX], a
    call Audio_StopSFX
    ld a, SFX_SPRITE_EXIT
    call Audio_PlaySFX

.loop
    call Joypad_Update
    call Sprite_Update
    ld a, [wCommonAnimatedTileDestination]
    farcall Gfx_UpdateCommonAnimatedTile
    ld a, [wSpriteTransitionDownY]
    add $0a
    cp $b8
    jr nc, .done
    ld [wSpriteTransitionDownY], a
    ld a, [wSpriteTransitionDownX]
    ld b, a
    ld a, [wSpriteTransitionDownY]
    ld c, a
    ld a, [wSpriteTransitionDownObject]
    call SpriteObject_SetPosition
    jr .loop

.done
    ret

assert @ == $5d6f
