include "macros/macros.inc"

; Shared scrollable-description runtime used by the Unit Reference pages.
; Text uses $01 as a line separator and $00 as the final terminator.

DEF wDescriptionDrawX                 EQU $cbc9
DEF wDescriptionLineBufferIndex       EQU $cbca
DEF wDescriptionDrawY                 EQU $cbcb
DEF wDescriptionScrollOffset          EQU $da40
DEF wDescriptionRenderedRows          EQU $da41
DEF wDescriptionLineCount             EQU $da42
DEF wDescriptionVisibleRows           EQU $da43
DEF wDescriptionLineBuffer            EQU $da44
DEF wDescriptionLineBufferTerminator  EQU $da56

section "Description Runtime", romx[$577d], bank[$32]

; HL = text stream, B = tile X, C = tile Y.
; Draw at most wDescriptionVisibleRows lines, padding each displayed line to
; 18 tiles. The caller may first advance HL with Description_ApplyScrollOffset.
Description_DrawVisibleLines::
    ld a, b
    ld [wDescriptionDrawX], a
    ld a, c
    ld [wDescriptionDrawY], a
    xor a
    ld [wDescriptionLineBufferIndex], a
    ld [wDescriptionRenderedRows], a
.next_row
    push hl
    ld hl, wDescriptionLineBuffer
    ld bc, $0012
    ld a, $20
    call MemsetWaitLCD
    pop hl
    ld a, $00
    ld [wDescriptionLineBufferTerminator], a
.parse_line
    ld a, [hli]
    cp $00
    jr z, .draw_final_row
    cp $01
    jr nz, .store_character
    jr .draw_line_break
.store_character
    ld a, [wDescriptionLineBufferIndex]
    ld c, a
    ld a, [wDescriptionDrawX]
    add c
    ld b, a
    ld a, [wDescriptionDrawY]
    ld c, a
    dec hl
    ld a, [hl]
    push hl
    push af
    ld a, [wDescriptionLineBufferIndex]
    ld c, a
    ld b, $00
    ld hl, wDescriptionLineBuffer
    add hl, bc
    pop af
    ld [hl], a
    pop hl
    ld a, [wDescriptionLineBufferIndex]
    inc a
    ld [wDescriptionLineBufferIndex], a
    inc hl
    jr .parse_line
.draw_line_break
    push hl
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [wDescriptionDrawX]
    ld b, a
    ld a, [wDescriptionDrawY]
    ld c, a
    call Vram_TilemapCoord
    ld de, wDescriptionLineBuffer
    call Vram_DrawZeroTerminatedRow
    pop hl
    xor a
    ld [wDescriptionLineBufferIndex], a
    ld a, [wDescriptionDrawY]
    inc a
    ld [wDescriptionDrawY], a
    ld a, [wDescriptionVisibleRows]
    dec a
    ld c, a
    ld a, [wDescriptionRenderedRows]
    inc a
    ld [wDescriptionRenderedRows], a
    dec a
    cp c
    jr z, .done
    jr .next_row
.draw_final_row
    push hl
    ld hl, wDescriptionLineBuffer
    ld a, [wDescriptionDrawX]
    ld b, a
    ld a, [wDescriptionDrawY]
    ld c, a
    call TextPut
    pop hl
    ret
.done
    ret

; Advance HL by the number of complete lines selected by DA40.
Description_ApplyScrollOffset::
    ld a, [wDescriptionScrollOffset]
    cp $00
    jr z, .done
    ld d, $00
.loop
    call Description_AdvanceToNextLine
    inc d
    ld a, [wDescriptionScrollOffset]
    cp d
    jr z, .done
    jr .loop
.done
    ret

Description_AdvanceToNextLine::
.loop
    ld a, [hl]
    cp $01
    jr z, .found
    inc hl
    jr .loop
.found
    inc hl
    ret

; A = unit type. Return its description pointer in HL.
Description_GetUnitText::
    add a
    ld hl, Description_Strings
    call AddAtoHL
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ret

; A = terrain/property description index. Return its description pointer in HL.
Description_GetTerrainText::
    add a
    ld hl, Description_Strings + 52 * 2
    call AddAtoHL
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ret

; HL = description stream. Count its display lines into DA42.
Description_CountLines::
    ld d, $00
.loop
    ld a, [hli]
    cp $00
    jr z, .finish
    cp $01
    jr nz, .continue
    inc d
.continue
    jr .loop
.finish
    inc d
    ld a, d
    ld [wDescriptionLineCount], a
    ret

; A = unit type.
Description_DrawUnitText::
    call Description_GetUnitText
    call Description_ApplyScrollOffset
    ld bc, $0106
    call Description_DrawVisibleLines
    ret

; A = terrain/property description index.
Description_DrawTerrainText::
    call Description_GetTerrainText
    call Description_ApplyScrollOffset
    ld bc, $0104
    call Description_DrawVisibleLines
    ret

Description_DrawGasExplanation::
    ld hl, Gas_Explanation
    call Description_ApplyScrollOffset
    ld bc, $0105
    call Description_DrawVisibleLines
    ret

Description_DrawInitiativeExplanation::
    ld hl, Initiative_Explanation
    call Description_ApplyScrollOffset
    ld bc, $0105
    call Description_DrawVisibleLines
    ret

Description_DrawPromotionExplanation::
    ld hl, Promotion_Explanation
    call Description_ApplyScrollOffset
    ld bc, $0106
    call Description_DrawVisibleLines
    ret

    assert @ == $58aa
