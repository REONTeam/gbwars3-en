; Copy a banked ROM range into the caller-selected destination while preserving
; the currently mapped ROM bank. The source bank is supplied through
; wFarCopySourceBank; DE/BC/HL are consumed by MemcpyWaitLCD.

section "Banked ROM Copy", rom0[$0150]

FarCopy_ToVRAM::
    ldh a, [hROMBank]
    push af
    ld a, [wFarCopySourceBank]
    ld a, a
    ldh [hROMBank], a
    ld [$2000], a
    call MemcpyWaitLCD
    pop af
    ldh [hROMBank], a
    ld [$2000], a
    ret

    assert @ == $0166
