include "macros/macros.inc"
include "constants/unit_constants.inc"

; Move-selection status overlay.  UnitAction_RunMove snapshots the selected
; UnitRecord's HP and fuel into the overlay scratch values before calling the
; public initializer at $7763.  The initializer creates a static overlay sprite
; plus two two-digit values, positions them for the current map presentation
; mode, and switches the corresponding digit pair to OBJ palette 1 when the
; value is below the game's warning thresholds (HP < 4, fuel < 21).
;
; $775F-$7762 is a four-byte structural record immediately before the public
; initializer.  No direct consumer has yet been proven, so it remains named
; data rather than being folded into the runtime routine.

section "Unit move status overlay leading data", romx[$775f], bank[$0b]
UnitMoveStatusOverlay_Data775F:
    db $01, $1f, $01, $00
    assert @ == $7763

section "Unit move status overlay runtime", romx[$7763], bank[$0b]

UnitMoveStatusOverlay_Init::
    ld a, [wUnitMoveStatusOverlayResource]
    cp $ff
    ret nz

    push bc
    push hl
    ld de, UnitMoveStatusOverlay_Animation
    ld b, $0b
    ld c, $00
    ld a, $20
    call SpriteObject_Create
    ld [wUnitMoveStatusOverlayResource], a

    ld bc, $0000
    ld hl, wUnitMoveStatusHPDigitResources
    ld a, [wUnitMoveStatusHP]
    call UnitMoveStatusOverlay_CreateDigitPair

    ld bc, $0000
    ld hl, wUnitMoveStatusFuelDigitResources
    ld a, [wUnitMoveStatusFuel]
    call UnitMoveStatusOverlay_CreateDigitPair

    ld a, [wMapCursorOffsetX]
    cp $05
    jr c, .position_mode_below_5
    call UnitMoveStatusOverlay_PositionMode5Plus
    jr .check_hp_warning
.position_mode_below_5
    call UnitMoveStatusOverlay_PositionModeBelow5

.check_hp_warning
    ld a, [wUnitMoveStatusHP]
    cp UNIT_MOVE_STATUS_HP_WARNING_THRESHOLD
    jr nc, .check_fuel_warning
    ld hl, wUnitMoveStatusHPDigitResources
    ld a, UNIT_MOVE_STATUS_WARNING_PALETTE
    call UnitMoveStatusOverlay_SetDigitPairPalette

.check_fuel_warning
    ld a, [wUnitMoveStatusFuel]
    cp UNIT_MOVE_STATUS_FUEL_WARNING_THRESHOLD
    jr nc, .done
    ld hl, wUnitMoveStatusFuelDigitResources
    ld a, UNIT_MOVE_STATUS_WARNING_PALETTE
    call UnitMoveStatusOverlay_SetDigitPairPalette
.done
    pop hl
    pop bc
    ret

    assert @ == $77c2

section "Unit move status overlay teardown", romx[$77c2], bank[$0b]

UnitMoveStatusOverlay_Clear::
    ld a, [wUnitMoveStatusOverlayResource]
    cp $ff
    ret z
    call SpriteObject_Destroy
    ld a, $ff
    ld [wUnitMoveStatusOverlayResource], a
    ld hl, wUnitMoveStatusHPDigitResources
    call UnitMoveStatusOverlay_DestroyDigitPair
    ld hl, wUnitMoveStatusFuelDigitResources
    call UnitMoveStatusOverlay_DestroyDigitPair
    ret

    assert @ == $77dd

section "Unit move status overlay positions", romx[$77dd], bank[$0b]

; Presentation used while $C98F is below 5.
UnitMoveStatusOverlay_PositionModeBelow5::
    ld a, [wUnitMoveStatusOverlayResource]
    cp $ff
    ret z
    ld bc, $7018
    call SpriteObject_SetPosition
    ld hl, wUnitMoveStatusHPDigitResources
    ld bc, $8820
    call UnitMoveStatusOverlay_PositionDigitPair
    ld hl, wUnitMoveStatusFuelDigitResources
    ld bc, $8828
    call UnitMoveStatusOverlay_PositionDigitPair
    ret

    assert @ == $77fc

; Presentation used while $C98F is 5 or greater.
UnitMoveStatusOverlay_PositionMode5Plus::
    ld a, [wUnitMoveStatusOverlayResource]
    cp $ff
    ret z
    ld bc, $1018
    call SpriteObject_SetPosition
    ld hl, wUnitMoveStatusHPDigitResources
    ld bc, $2820
    call UnitMoveStatusOverlay_PositionDigitPair
    ld hl, wUnitMoveStatusFuelDigitResources
    ld bc, $2828
    call UnitMoveStatusOverlay_PositionDigitPair
    ret

    assert @ == $781b

; Static 20-sprite frame used as the overlay's background/labels.
; Record shape is y, x, tile, OBJ attributes.
MACRO unit_move_status_oam
    db \1, \2, \3, \4
ENDM

UnitMoveStatusOverlay_Metasprite:
    db 20
    unit_move_status_oam $00, $00, $ab, $00
    unit_move_status_oam $00, $08, $ac, $00
    unit_move_status_oam $00, $10, $ac, $00
    unit_move_status_oam $00, $18, $ac, $00
    unit_move_status_oam $00, $20, $ac, $00
    unit_move_status_oam $00, $28, $ab, $20
    unit_move_status_oam $08, $00, $ad, $00
    unit_move_status_oam $08, $08, $ae, $00
    unit_move_status_oam $08, $10, $a7, $00
    unit_move_status_oam $08, $28, $ad, $20
    unit_move_status_oam $10, $00, $ad, $00
    unit_move_status_oam $10, $08, $b0, $00
    unit_move_status_oam $10, $10, $a7, $00
    unit_move_status_oam $10, $28, $ad, $20
    unit_move_status_oam $18, $00, $ab, $40
    unit_move_status_oam $18, $08, $ac, $40
    unit_move_status_oam $18, $10, $ac, $40
    unit_move_status_oam $18, $18, $ac, $40
    unit_move_status_oam $18, $20, $ac, $40
    unit_move_status_oam $18, $28, $ab, $60

    assert @ == $786c

; Single-frame animation descriptor consumed by SpriteObject_Create.
UnitMoveStatusOverlay_Animation:
    dw UnitMoveStatusOverlay_Metasprite
    db $ff, $00

    assert @ == $7870

section "Unit move status overlay digit resources", romx[$7870], bank[$0b]

; A = byte value, HL = two-byte destination for the created tens/ones sprite
; object IDs. The generic ROM0 helper converts A to packed BCD first.
UnitMoveStatusOverlay_CreateDigitPair::
    push bc
    push de
    push bc
    push hl
    call Number_ByteToPackedBCD
    push af
    swap a
    call .create_digit
    pop af
    call .create_digit
    pop hl
    pop bc
    call UnitMoveStatusOverlay_PositionDigitPair
    pop de
    pop bc
    ret

.create_digit
    and $0f
    push hl
    ld hl, UnitMoveStatusOverlay_DigitAnimationPointers
    call WordTable_Get
    ld d, h
    ld e, l
    ld b, $0b
    ld c, $00
    ld a, $20
    call SpriteObject_Create
    pop hl
    ld [hli], a
    ret

    assert @ == $78a0

; Each decimal digit has a one-sprite metasprite and a one-frame animation
; descriptor. The created sprite-object IDs are stored as a consecutive pair.
UnitMoveStatusOverlay_DigitAnimationPointers:
    dw .digit0_animation
    dw .digit1_animation
    dw .digit2_animation
    dw .digit3_animation
    dw .digit4_animation
    dw .digit5_animation
    dw .digit6_animation
    dw .digit7_animation
    dw .digit8_animation
    dw .digit9_animation

.digit0_metasprite:
    db 1
    unit_move_status_oam $00, $00, $81, $00
.digit1_metasprite:
    db 1
    unit_move_status_oam $00, $00, $82, $00
.digit2_metasprite:
    db 1
    unit_move_status_oam $00, $00, $83, $00
.digit3_metasprite:
    db 1
    unit_move_status_oam $00, $00, $84, $00
.digit4_metasprite:
    db 1
    unit_move_status_oam $00, $00, $85, $00
.digit5_metasprite:
    db 1
    unit_move_status_oam $00, $00, $86, $00
.digit6_metasprite:
    db 1
    unit_move_status_oam $00, $00, $87, $00
.digit7_metasprite:
    db 1
    unit_move_status_oam $00, $00, $88, $00
.digit8_metasprite:
    db 1
    unit_move_status_oam $00, $00, $89, $00
.digit9_metasprite:
    db 1
    unit_move_status_oam $00, $00, $8a, $00

.digit0_animation:
    dw .digit0_metasprite
    db $ff
.digit1_animation:
    dw .digit1_metasprite
    db $ff
.digit2_animation:
    dw .digit2_metasprite
    db $ff
.digit3_animation:
    dw .digit3_metasprite
    db $ff
.digit4_animation:
    dw .digit4_metasprite
    db $ff
.digit5_animation:
    dw .digit5_metasprite
    db $ff
.digit6_animation:
    dw .digit6_metasprite
    db $ff
.digit7_animation:
    dw .digit7_metasprite
    db $ff
.digit8_animation:
    dw .digit8_metasprite
    db $ff
.digit9_animation:
    dw .digit9_metasprite
    db $ff

    assert @ == $7904

UnitMoveStatusOverlay_DestroyDigitPair::
    ld a, [hli]
    call SpriteObject_Destroy
    ld a, [hli]
    call SpriteObject_Destroy
    ret

    assert @ == $790d

; BC = first digit position; second digit is placed eight pixels to the right.
UnitMoveStatusOverlay_PositionDigitPair::
    push bc
    ld a, [hli]
    call SpriteObject_SetPosition
    ld a, b
    add $08
    ld b, a
    ld a, [hl]
    call SpriteObject_SetPosition
    pop bc
    ret

    assert @ == $791c

; A = CGB OBJ palette number, HL = two consecutive digit sprite-object IDs.
UnitMoveStatusOverlay_SetDigitPairPalette::
    push bc
    ld b, a
    ld a, [hli]
    push bc
    call SpriteObject_SetPalette
    pop bc
    ld a, [hl]
    call SpriteObject_SetPalette
    pop bc
    ret

    assert @ == $792a
