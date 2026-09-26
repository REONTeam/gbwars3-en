include "macros/macros.inc"
include "charmaps/char_main.inc"
setcharmap main

; Hardware-gated startup presentation. The Game Boy boot ROM leaves $11 in A
; on CGB hardware. Other model IDs receive the permanent Color-only warning.
section "Startup Hardware Presentation", romx[$4000], bank[$10]

Startup_RunHardwarePresentation::
    cp $11
    jr z, .cgb
    jp Startup_ShowColorRequiredScreen
.cgb
    farcall MobileSystemGB_ShowLogo
    xor a
    ldh [rLCDC], a
    call Startup_ResetPresentationVRAMAndPalettes
    call Startup_LoadPresentationAssets
    ld a, $80
    ldh [rLCDC], a
    ld bc, $0078
    call Startup_PresentationBusyDelay
    xor a
    ret

; Clear the Bank-1 BG map/attributes and install the first startup palette
; preset. This intentionally manipulates rVBK directly, matching retail.
Startup_ResetPresentationVRAMAndPalettes::
    ld a, 1
    ldh [rVBK], a
    ld hl, $9800
    xor a
    ld bc, $0800
.clear
    ld [hli], a
    dec c
    jr nz, .clear
    dec b
    jr nz, .clear
    xor a
    ldh [rVBK], a
    ld bc, $0f7f
    ld de, $58e4
    jp Startup_ProgramPresentationPalettes

; Alternate palette preset retained as an independent retail entry.
Startup_SetPresentationPalettePresetB::
    ld bc, $5ef7
    ld de, $3def
    jp Startup_ProgramPresentationPalettes

; Program matching BG/OBJ startup palettes through auto-incrementing CGB
; palette RAM ports. BC and DE supply the two non-white color pairs.
Startup_ProgramPresentationPalettes::
    ld a, $80
    ldh [rBGPI], a
    ld hl, rBGPD
    call .write_four
    ld a, $80
    ldh [rOBPI], a
    ld hl, rOBPD
.write_four
    ld a, 4
.loop
    ld [hl], $ff
    ld [hl], $7f
    ld [hl], c
    ld [hl], b
    ld [hl], e
    ld [hl], d
    ld [hl], 0
    ld [hl], 0
    ld [hl], $ff
    ld [hl], $7f
    ld [hl], e
    ld [hl], d
    ld [hl], c
    ld [hl], b
    ld [hl], 0
    ld [hl], 0
    dec a
    jr nz, .loop
    ret

; Alternate presentation entry used by another startup/display caller. Wait for
; the VBlank region, disable LCD output, load the same assets, then show them
; with the DMG-compatible BGP value $F0 for the fixed delay.
Startup_ShowPresentationAlternate::
.wait_ly
    ldh a, [rLY]
    cp $92
    jr c, .wait_ly
    xor a
    ldh [rLCDC], a
    call Startup_LoadPresentationAssets
    ld a, $f0
    ldh [rBGP], a
    ld a, $81
    ldh [rLCDC], a
    ld bc, $0078
    call Startup_PresentationBusyDelay
    ret

; Copy the HUDSON startup presentation. The visible map references 122 real
; tiles (0-$79); retail copies 126 tile slots, so the final four unused slots
; deliberately spill into the first $40 bytes of the following tilemap.
Startup_LoadPresentationAssets::
    ld de, HudsonLogo_Graphics
    ld hl, $9000
    ld bc, $07e0
    call Memcpy
    ld de, HudsonLogo_Tilemap
    ld hl, $9800
    ld bc, $0400
    call Memcpy
    ret

; Retail timing loop. The three NOPs are deliberate and byte-significant.
Startup_PresentationBusyDelay::
.outer
    ld de, $06d6
.inner
    nop
    nop
    nop
    dec de
    ld a, d
    or e
    jr nz, .inner
    dec bc
    ld a, b
    or c
    jr nz, .outer
    ret

; Non-CGB lockout. Build the warning screen with the common Bank-1 font,
; display it, then halt forever. This is intentionally non-returning.
Startup_ShowColorRequiredScreen::
    di
    ldh a, [rLCDC]
    bit 7, a
    jr z, .lcd_off
.wait_ly
    ldh a, [rLY]
    cp $92
    jr c, .wait_ly
.lcd_off
    xor a
    ldh [rLCDC], a
    ldh [rSCX], a
    ldh [rSCY], a
    ld hl, $9800
    ld bc, $0800
    ld a, $20
    call Memset
    farcall SharedGraphics_LoadMainFontBG
    call Startup_LoadColorRequiredMessage
    xor a
    ldh [rWY], a
    ldh [rWX], a
    ld a, $0c
    ldh [rBGP], a
    ld a, $81
    ldh [rLCDC], a
.halt_forever
    halt
    nop
    nop
    nop
    jr .halt_forever

; Five compact records: destination tilemap address, byte count, tile/text data.
Startup_LoadColorRequiredMessage::
    ld c, 5
    ld b, 0
.loop
    push bc
    ld e, b
    sla e
    ld d, 0
    ld hl, Startup_ColorRequiredRecordPointers
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, [de]
    ld l, a
    inc de
    ld a, [de]
    ld h, a
    inc de
    ld a, [de]
    ld c, a
    ld b, 0
    inc de
    call Memcpy
    pop bc
    inc b
    dec c
    jr nz, .loop
    ret

Startup_ColorRequiredRecordPointers::
    dw .line1, .blank, .line2, .line3, .line4
.line1
    dw $9884
    db 11
    db "ゲームボーイウォーズ3"
.blank
    dw $98a5
    db 10
    db "          "
.line2
    dw $9905
    db 10
    db "このカートリッジは,"
.line3
    dw $9942
    db 16
    db "ゲームボーイカラーせんようです。"
.line4
    dw $9980
    db 20
    db "ゲームボーイカラーで,しようしてください"

    assert @ == $4175

section "Hudson Logo Graphics", romx[$4175], bank[$10]
HudsonLogo_Graphics::
    INCBIN "gfx/startup/hudson_logo.2bpp"
    assert @ == $4915

; The startup loader copies one contiguous $400-byte span beginning here.
; Physical ROM ownership is intentionally shared after $4B54: $4B55-$4C58
; is the palette-fade engine, while $4C59-$4DBF is the map-save medal-detail
; renderer plus its tile/attribute payload. HudsonLogo_Tilemap remains the
; runtime base pointer for the original contiguous copy, but those aliased
; bytes are sourced by their executable/data owners instead of duplicated here.
section "Hudson Logo Tilemap Prefix", romx[$4915], bank[$10]
HudsonLogo_Tilemap::
    INCBIN "gfx/startup/hudson_logo.tilemap", 0, $240
    assert @ == $4b55
