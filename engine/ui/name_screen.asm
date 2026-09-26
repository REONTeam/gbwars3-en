include "macros/macros.inc"
include "constants/bank_ends.inc"
include "charmaps/char_main.inc"

section "NameScreen_ConfirmDialog", romx[$546d], bank[$14]
NameScreen_ConfirmDialog:
    ld a, [$cc3c]
    call SpriteObject_Hide
    call Sprite_Update
    call DelayFrame
    xor a
    ld [$cc40], a
    ;lb bc, 3, 5
    ;lb de, 13, 7
    lb bc, 2, 5
    lb de, 15, 7
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ;lb bc, 4, 6
    ;lb de, 11, 5
    lb bc, 3, 6
    lb de, 13, 5
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ;lb bc, 5, 7
    lb bc, 4, 7
    ld hl, NameScreen_ConfirmText
    call TextPut
    call $54d8
    ret
    assert @ <= $56ee, "Name confirmation dialog overlaps confirmation text"

section "NameScreen_ConfirmText", romx[$56ee], bank[$14]
;NameScreen_ConfirmText:
    ;text "これでいいですか?"
    ;done

    section_end $56f8

section fragment "bank14_end", romx[bank14_end_addr], bank[$14]
NameScreen_ConfirmText:
    text "IS THIS OK?"
    done
