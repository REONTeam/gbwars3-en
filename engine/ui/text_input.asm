include "macros/macros.inc"

; Retail mode 2 called TextInput_GetLength directly at $4CD3. The 9-character
; sidecar format cannot expose a permanent terminator after character 9 because
; $CC38 is live text-input state, so mode 2 now uses a bounded length helper.
section "Text Input Map Name Length Hook", romx[$4cd3], bank[$14]
TextInput_MapNameLengthHook::
    farcall MapName9_TextInputInitLength
    jp $4cef

    assert @ <= $4cdb

; Return the zero-terminated string length of the shared text-input buffer in A.
section "Text Input Length", romx[$4e3b], bank[$14]
TextInput_GetLength::
    ld hl, wTextInputBuffer
    ld b, 0
.loop
    ld a, [hli]
    cp 0
    jr z, .done
    ld a, b
    inc a
    ld b, a
    jr .loop
.done
    ld a, b
    ret

; A selects the input mode. Mode 2 is the Map Editor name-entry path.
section "Text Input Main", romx[$4e4c], bank[$14]
TextInput_Run::
    ld [$cc43], a
    call LCD_Disable
    call VBlankFIFO_Clear
    call $2d7c
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call $4c96
.loop
    call FadeFromWhite8
    call Joypad_Update
    call Sprite_Update
    call $4fe6
    ld a, 0
    farcall Gfx_UpdateCommonAnimatedTile
    call $5541
    ld a, [$cc3e]
    cp 1
    jr z, .done
    jr .loop
.done
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call SpriteObject_DestroyAll
    call FadeToWhite8
    ret

    assert @ == $4e8d

; Mode-2 redraw hook. Retail's $52B6-$531E path assumes a hard maximum of
; eight characters. Jump to a tail implementation that treats $CC37 as the
; ninth character and borrows $CC38 as a temporary terminator only while
; TextPut is executing.
section "Text Input Map Name Redraw Hook", romx[$52b6], bank[$14]
TextInput_MapNameRedrawHook::
    jp TextInput_MapNameRedraw

    assert @ <= $52bb

; Preserve the retail entry points while moving the expanded logic into Bank
; $14's unused tail. Non-map modes retain their original six-character rules.
section "Text Input Append Character", romx[$531f], bank[$14]
TextInput_AppendCharacter::
    farcall MapName9_TextInputAppend
    ret

    assert @ <= $5355

section "Text Input Backspace", romx[$5355], bank[$14]
TextInput_Backspace::
    farcall MapName9_TextInputBackspace
    ret

    assert @ <= $5375

; uses retail-FF space after the existing translated Name Screen
; confirmation string. The redraw routine stays in Bank $14 because it
; references retail cursor-decoration data at $522A-$5244.
section "Text Input 9 Character Map Name Redraw", romx[$7f20], bank[$14]
TextInput_MapNameRedraw::
    ld a, [$ffcb]
    push af
    ld hl, $982a
    ld a, [$cc3a]
    call AddAtoHL
    ld d, h
    ld e, l
    push de
    ld a, [$cc3a]
    ld c, a
    ld a, MAP_RECORD_NAME_LOGICAL_SIZE
    sub c
    ld b, a
    push bc
    ld a, [$cc3a]
    cp MAP_RECORD_NAME_LOGICAL_SIZE
    jr z, .skip_first_fill
    ld hl, $522a
    call VBlankFIFO_Queue
.skip_first_fill
    ld a, 1
    ld [$ffcb], a
    pop bc
    pop de
    ld a, [$cc3a]
    cp MAP_RECORD_NAME_LOGICAL_SIZE
    jr z, .skip_second_fill
    ld hl, $5233
    call VBlankFIFO_Queue
.skip_second_fill
    ld a, 1
    ld [$ffcb], a
    ld de, $982a
    ld a, [$cc3a]
    ld b, a
    and a
    jr z, .skip_third_fill
    ld hl, $523c
    call VBlankFIFO_Queue
.skip_third_fill
    xor a
    ld [$ffcb], a
    ld a, [$cc3a]
    and a
    jr z, .restore_attr
    ld a, [$cc38]
    push af
    xor a
    ld [$cc38], a
    ld bc, $0a01
    ld hl, wTextInputBuffer
    call TextPut
    pop af
    ld [$cc38], a
.restore_attr
    pop af
    ld [$ffcb], a
    ret

    assert @ <= $8000, "9-character map-name text-input runtime exceeds Bank $14"
