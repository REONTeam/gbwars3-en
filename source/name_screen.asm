include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"

section "NameScreen_code547d", romx[$547d], bank[$14]
    ;ld bc, $0305
    ;ld de, $0d07
    ld bc, $0205
    ld de, $0f07

section "NameScreen_code5491", romx[$5491], bank[$14]
    ;ld bc, $0406
    ;ld de, $0b05
    ld bc, $0306
    ld de, $0d05

section "NameScreen_code54a0", romx[$54a0], bank[$14]
    ;ld bc, $0507
    ld bc, $0407
    ld hl, NameScreen_ConfirmText
    call $3353

section "NameScreen_ConfirmText", romx[$56ee], bank[$14]
;NameScreen_ConfirmText:
    ;text "これでいいですか?"
    ;done

    section_end $56f8

section fragment "bank14_end", romx[bank14_end_addr], bank[$14]
NameScreen_ConfirmText:
    text "IS THIS OK?"
    done
