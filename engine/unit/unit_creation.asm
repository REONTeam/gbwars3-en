include "macros/macros.inc"
include "constants/bank_ends.inc"
include "charmaps/char_unit.inc"
include "charmaps/char_main.inc"

setcharmap unit
section "UnitCreation_Menu", romx[$5a0d], bank[$0b]
UnitCreation_DrawMenuLabels::
    ld a, $07
    call Vram_ClearPanelRowsBothBanks
    ld a, [$c9ca]
    and a
    jr nz, .use_call_prompt

    ld hl, UnitCreation_Create
    jr .draw_labels

.use_call_prompt:
    ld hl, UnitCreation_Call

.draw_labels:
    lb bc, 1, 32
    call TextPut
    ld hl, UnitCreation_Gold
    lb bc, 4, 35
    call TextPut
    ld hl, UnitCreation_Material
    lb bc, 12, 35
    call TextPut
    ld hl, UnitCreation_Movement
    lb bc, 1, 37
    call TextPut
    ld hl, UnitCreation_Gas
    lb bc, 1, 38
    call TextPut
    ld hl, UnitCreation_Separator
    lb bc, 1, 36
    call TextPut
    call VBlankFIFO_WaitEmpty
    ret

UnitCreation_Create:
    ;text "どのユニットをせいさんしますか"
    text "DEPLOY WHICH UNIT?"
    done

UnitCreation_Call:
    ;text "どのユニットをよびますか"
    text "CALL WHICH UNIT?"
    done

UnitCreation_Gold:  ; $b1 is the Gold Icon
    db $b1, "-   00"
    done

UnitCreation_Material:  ; $b2 is the Material Icon
    db $b2, "-"
    done

UnitCreation_Movement:  ; $af is the Gold Icon
    db $af, "  :"
    done

UnitCreation_Gas:  ; $b0 is the Gas Icon
    db $b0, "  :"
    done

    section_end $5a9c

section fragment "bank0b_end", romx[bank0b_end_addr], bank[$0b]
UnitCreation_Separator:
    text "___________________"
    done

