include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main

; Shared state used by the late phase-result controller at Bank $27:$7E5F.
; The controller stores the side that offered surrender in $DC6A and uses
; $DC69 as the two-choice prompt cursor/result byte.
DEF wMapSurrenderPromptChoice EQU $dc69
DEF wMapSurrenderingSide EQU $dc6a

section "Map Surrender Resolution Prompt Setup", romx[$7cb7], bank[$27]

; Build the modal surrender-resolution prompt. wMapSurrenderingSide selects
; which army-name prefix is inserted above the common question text.
MapSurrenderPrompt_Setup::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals

    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ldh [hWX], a
    ldh [hWY], a
    call Vram_ClearBGTilemapBothBanks

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets

    ld bc, $0104
    ld de, $120a
    farcall UIWindow_DrawFrameAndClearInteriorAttributes

    ld hl, MapSurrenderPrompt_Question
    ld bc, $0407
    call TextPrint

    ld a, [wMapSurrenderingSide]
    cp $00
    jr z, .redStar
    cp $01
    jr z, .whiteMoon

.redStar
    ld hl, MapSurrenderPrompt_RedStarArmyOffered
    jr .drawArmy

.whiteMoon
    ld hl, MapSurrenderPrompt_WhiteMoonArmyOffered

.drawArmy
    call CoordTextPut

    ld a, $01
    ld [wMapSurrenderPromptChoice], a
    ld bc, $070b
    farcall Gfx_DrawTwoChoiceHighlightSecond
    ret

MapSurrenderPrompt_RedStarArmyOffered::
    coord_text 4, 6, "レッドスターぐんが  "

MapSurrenderPrompt_WhiteMoonArmyOffered::
    coord_text 4, 6, "ホワイトムーンぐんが "

MapSurrenderPrompt_Question::
    text "こうふくしました。   "
    line "せんとうを       "
    line "しゅうりょうしますか? "
    done

    assert @ == $7d5c

section "Map Surrender Resolution Outcome", romx[$7d5c], bank[$27]

; A = 0 when the surrender is rejected/ignored; nonzero when accepted.
; The common body is drawn first and the two army-name fragments are then
; inserted according to wMapSurrenderingSide.
MapSurrenderPrompt_DrawOutcome::
    cp $00
    jr z, .rejected
    cp $01
    jr z, .accepted

.accepted
    ld hl, MapSurrenderPrompt_AcceptedText
    ld bc, $0407
    call TextPrint

    ld a, [wMapSurrenderingSide]
    cp $00
    jr z, .acceptedRedStar
    jr .acceptedWhiteMoon

.acceptedWhiteMoon
    ld bc, $0406
    ld hl, MapSurrenderPrompt_WhiteMoonArmyIs
    call TextPut
    ld bc, $0408
    ld hl, MapSurrenderPrompt_RedStarArmyPossessive
    call TextPut
    ret

.acceptedRedStar
    ld bc, $0406
    ld hl, MapSurrenderPrompt_RedStarArmyIs
    call TextPut
    ld bc, $0408
    ld hl, MapSurrenderPrompt_WhiteMoonArmyPossessive
    call TextPut
    ret

.rejected
    ld hl, MapSurrenderPrompt_RejectedText
    ld bc, $0307
    call TextPrint

    ld a, [wMapSurrenderingSide]
    cp $00
    jr z, .rejectedRedStar
    jr .rejectedWhiteMoon

.rejectedRedStar
    ld bc, $0306
    ld hl, MapSurrenderPrompt_RedStarArmyPossessive
    call TextPut
    ret

.rejectedWhiteMoon
    ld bc, $0306
    ld hl, MapSurrenderPrompt_WhiteMoonArmyPossessive
    call TextPut
    ret

MapSurrenderPrompt_AcceptedText::
    text "こうふくしました。     "
    line "              "
    line "しょうりになります。    "
    done

MapSurrenderPrompt_RejectedText::
    text "こうふくをむししました。   "
    line "せんとうをぞっこうします。  "
    line "               "
    line "               "
    done

MapSurrenderPrompt_WhiteMoonArmyIs::
    text "ホワイトムーンぐんは "
    done

MapSurrenderPrompt_RedStarArmyIs::
    text "レッドスターぐんは  "
    done

MapSurrenderPrompt_WhiteMoonArmyPossessive::
    text "ホワイトムーンぐんの "
    done

MapSurrenderPrompt_RedStarArmyPossessive::
    text "レッドスターぐんの  "
    done

    assert @ == $7e5f
