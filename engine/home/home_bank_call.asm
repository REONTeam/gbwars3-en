include "macros/macros.inc"

; Execute the routine at HL from ROM bank B. The banked target returns by
; jumping to ROMBankCall_Return, which restores the caller's previous bank.
section "ROM Bank Call Trampoline", rom0[$0280]

ROMBankCall::
    ldh a, [hROMBank]
    push af
    ld a, b
    ldh [hROMBank], a
    ld [$2000], a
    jp hl

ROMBankCall_Return::
    pop af
    ldh [hROMBank], a
    ld [$2000], a
    ret

assert @ == $0291
