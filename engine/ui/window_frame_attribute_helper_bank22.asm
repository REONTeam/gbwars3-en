include "macros/macros.inc"

; Draw a normal framed window, then clear the attribute bytes across its
; interior. BC is the outer-frame tile coordinate and DE is the outer width /
; height. The helper preserves the caller's VRAM bank.
section "Bank22 Window Frame Attribute Helper", romx[$6247], bank[$22]

UIWindow_DrawFrameAndClearInteriorAttributes::
    push bc
    push de
    farcall UIWindow_DrawFrame
    pop de
    pop bc

    ; Exclude the one-tile frame on each edge before clearing attributes.
    inc b
    inc c
    ld a, d
    sub $02
    ld d, a
    ld a, e
    sub $02
    ld e, a

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

    assert @ == $626d
