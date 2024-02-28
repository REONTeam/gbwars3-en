include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"

section "NameScreen_ConfirmDialog", romx[$546d], bank[$14]
NameScreen_ConfirmDialog:
    ld a, [$cc3c]
    call $2f5f
    call $3056
    call $04d2
    xor a
    ld [$cc40], a
    ;lb bc, 3, 5
    ;lb de, 13, 7
    lb bc, 2, 5
    lb de, 15, 7
    farcall $10, $6901
    ldh a, [$83]
    push af
    ld a, $01
    ldh [$83], a
    ldh [$4f], a
    xor a
    ;lb bc, 4, 6
    ;lb de, 11, 5
    lb bc, 3, 6
    lb de, 13, 5
    farcall Gfx_TilemapFill
    pop af
    ldh [$83], a
    ldh [$4f], a
    ;lb bc, 5, 7
    lb bc, 4, 7
    ld hl, NameScreen_ConfirmText
    call TextPut
    call $54d8
    ret

section "NameScreen_ConfirmText", romx[$56ee], bank[$14]
;NameScreen_ConfirmText:
    ;text "これでいいですか?"
    ;done

    section_end $56f8

section fragment "bank14_end", romx[bank14_end_addr], bank[$14]
NameScreen_ConfirmText:
    text "IS THIS OK?"
    done
