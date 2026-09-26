include "macros/macros.inc"

; High-level Game Boy Color infrared feature controller.
;
; This ROM0 layer drives the Bank $18 IR connection UI/session API and the
; ROM0 timing-sensitive hardware backend. It owns the feature state machine,
; result transitions, chunked transfer orchestration, and transfer graphics setup.

section "Infrared Feature Controller", rom0[$0c30]
InfraredController_Run::
    call $3843
    call $3815
    farcall InfraredUI_Initialize
    farcall Infrared_ResetSessionState
    xor a
    ld [$c61a], a
    ld hl, $0000
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0000
    farcall InfraredUI_DrawPrompt
    call $081d
    call $04d2
    call $3056
    call $05ac
    call $05eb
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    call $0c73
    jr nc, $0c53
    push af
    farcall Infrared_ResetHardware
    pop af
    and a
    ret
    jp hl
InfraredController_DispatchState::
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c61a]
    add a, a
    ld e, a
    ld d, $00
    ld hl, $0c9e
    add hl, de
    ld a, [hli]
    ld h, [hl]
    ld l, a
    call $0c72
    ld a, [$c61a]
    cp $13
    jr z, $0c97
    cp $14
    jr z, $0c9b
    xor a
    ret
    ld a, $01
    scf
    ret
    xor a
    scf
    ret
InfraredController_StateTable::
    db $b0, $0c, $30, $0d, $63, $0d, $ec, $0d, $0b, $0e, $2a, $0e, $e5, $0c, $4d, $0d
    db $cc, $0d
InfraredController_State00::
    farcall Infrared_StartSession
    ld [$c61b], a
    jr nc, $0cbc
    jp $0e11
    ld a, [$c61b]
    or a
    jr z, $0cee
    ld a, $06
    ld [$c61a], a
    ld hl, $0001
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0001
    farcall InfraredUI_DrawPrompt
    push bc
    ld a, $01
    call $3844
    ld c, $1e
    call $04d2
    dec c
    jr nz, $0cdd
    pop bc
    ret
InfraredController_State06::
    farcall Infrared_CheckSessionHealth
    jr nc, $0cee
    jp $0e11
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0101
    ld de, $1103
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $01
    ld [$c61a], a
    ld hl, $0002
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0001
    farcall InfraredUI_DrawPrompt
    push bc
    ld a, $02
    call $3844
    ld c, $3c
    call $04d2
    dec c
    jr nz, $0d22
    pop bc
    ld a, $02
    farcall InfraredUI_LoadPromptGraphics
    ret
InfraredController_State01::
    farcall Infrared_VerifyPeerSignature
    jp c, $0df2
    ld a, [$c61c]
    farcall Infrared_ComparePeerByte
    jp c, $0df2
    or a
    jr z, $0d47
    jp $0df2
    ld a, $07
    ld [$c61a], a
    ret
InfraredController_State07::
    ld a, [$c61d]
    farcall Infrared_ComparePeerByte
    jp c, $0dd3
    or a
    jr nz, $0d5d
    jp $0d85
    ld a, $02
    ld [$c61a], a
    ret
InfraredController_State02::
    call $0e3a
    jp c, $0dd3
    ld a, $14
    farcall InfraredUI_LoadPromptGraphics
    farcall Infrared_CheckLinkReady
    push bc
    ld a, $0d
    call $3844
    ld c, $1e
    call $04d2
    dec c
    jr nz, $0d7b
    pop bc
    jp $0e34
    ld a, $08
    ld [$c61a], a
    ld a, [$c61c]
    cp $02
    jr z, $0d96
    ld hl, $0003
    jr $0da5
    ld a, [$c61d]
    cp $00
    jr nz, $0da2
    ld hl, $0db8
    jr $0da5
    ld hl, $0dc2
    ld b, $18
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0002
    farcall InfraredUI_DrawPrompt
    ld a, $03
    call $3844
    ret
InfraredController_ResultTextA::
    db $61, $91, $89, $9c, $63, $6c, $9b, $6d, $2e, $00
InfraredController_ResultTextB::
    db $83, $87, $63, $9c, $63, $6c, $9b, $6d, $2e, $00
InfraredController_State08::
    ldh a, [$ff91]
    or a
    ret z
    jp $0e30
    ld a, $03
    ld [$c61a], a
    ld hl, $0004
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0002
    farcall InfraredUI_DrawPrompt
    ld a, $03
    call $3844
    ret
InfraredController_State03::
    ldh a, [$ff91]
    or a
    jr nz, $0e30
    ret
    ld a, $04
    ld [$c61a], a
    ld hl, $0003
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0002
    farcall InfraredUI_DrawPrompt
    ld a, $03
    call $3844
    ret
InfraredController_State04::
    ldh a, [$ff91]
    or a
    jr nz, $0e30
    ret
    ld a, $05
    ld [$c61a], a
    ld hl, $0003
    farcall InfraredUI_DrawConnectionStatus
    ld hl, $0002
    farcall InfraredUI_DrawPrompt
    ld a, $03
    call $3844
    ret
InfraredController_State05::
    ldh a, [$ff91]
    or a
    jr nz, $0e30
    ret
    ld a, $14
    jr $0e36
    ld a, $13
    ld [$c61a], a
    ret
InfraredController_TransferChunks::
    ld a, [$c61e]
    ld l, a
    ld e, a
    ld a, [$c61f]
    ld h, a
    ld d, a
    ld a, [$c620]
    or a
    jr z, $0e67
    ld c, a
    ld a, [$c622]
    ld b, a
    call $0e9b
    jr c, $0e9a
    ld a, $04
    farcall InfraredUI_LoadPromptGraphics
    ld a, [$c620]
    add a, l
    ld l, a
    ld a, h
    adc a, $00
    ld h, a
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    ld a, $04
    ld [$c620], a
    ld a, [$c621]
    or a
    jr z, $0e99
    ld c, $00
    ld a, [$c622]
    ld b, a
    call $0e9b
    jr c, $0e9a
    inc h
    inc d
    ld a, [$c621]
    dec a
    ld [$c621], a
    ld a, [$c620]
    inc a
    ld [$c620], a
    cp $14
    jr c, $0e93
    ld a, $14
    farcall InfraredUI_LoadPromptGraphics
    jr $0e6c
    xor a
    ret
InfraredController_TransferChunk::
    push hl
    push de
    ld a, [$c61d]
    cp $00
    jr z, $0eaa
    farcall Infrared_ReceiveBuffer
    jr $0eae
    farcall Infrared_SendBuffer
    pop de
    pop hl
    ret
InfraredController_LoadTransferTiles::
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ldh a, [$ff80]
    push af
    ld a, $01
    ldh [$ff80], a
    ld [$2000], a
    ld de, $5180
    ld hl, $9010
    ld bc, $0030
    call $3b50
    pop af
    ldh [$ff80], a
    ld [$2000], a
    ret
    assert @ == $0ed4
