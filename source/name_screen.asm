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
    ;ld bc, $0305
    ;ld de, $0d07
    ld bc, $0205
    ld de, $0f07
    farcall $10, $6901
    ldh a, [$83]
    push af
    ld a, $01
    ldh [$83], a
    ldh [$4f], a
    xor a
    ;ld bc, $0406
    ;ld de, $0b05
    ld bc, $0306
    ld de, $0d05
    farcall $15, $6ad3
    pop af
    ldh [$83], a
    ldh [$4f], a
    ;ld bc, $0507
    ld bc, $0407
    ld hl, NameScreen_ConfirmText
    call $3353
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
