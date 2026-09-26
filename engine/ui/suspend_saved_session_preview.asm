include "macros/macros.inc"

; Draw the saved-session summary used by the suspend/resume screen.  This used
; to be represented as a retail-code hole with several custom-English fixed
; sections laid over instruction operands.  Keeping the whole routine here
; makes those customized coordinates and the nine-character map-name path part
; of the actual instruction stream instead of pretending they are standalone
; data resources.
section "Suspend Saved Session Preview", romx[$5f63], bank[$15]
SuspendResume_DrawSavedSessionPreview::
    ; Slot 3 stores the suspend/resume save.  Read its saved game mode first so
    ; the matching mode label and mode-dependent map metadata can be selected.
    ld a, $00
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$a68e]
    call SRAM_Disable
    push af

    ; Saved modes 0..2 select BEGINNER/CAMPAIGN/STANDARD.
    add a
    ld hl, Suspend_Mode_Strings
    call AddAtoHL
    ld a, [hl+]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ld bc, $0703 ; custom-English MODE value position: x=3, y=7
    call TextPut

    ; Load the mode-aware summary and the commander/name preview for save slot 3.
    pop af
    ld b, a
    ld a, $03
    farcall MapSRAM_LoadSlotSummaryRow
    ld a, $03
    ld hl, $dc5e
    farcall MapSRAM_LoadSlotPreviewHeader
    ld bc, $0502 ; custom-English CO value position: x=2, y=5
    ld hl, $dc5e
    call TextPut

    ; Draw map number plus the custom nine-character cached map name.
    ld a, [wMapNameCacheIndex]
    inc a
    lb bc, 4, 6
    ld d, 2
    call DrawNumberFixedWidth
    lb bc, 4, 9
    farcall MapName9_DrawCache
    ds 2, 0

    ; The slot metadata phase counter is stored as alternating side phases.
    ; Convert it to a one-based day number for the suspend preview.
    ld a, [$cc93]
    srl a
    inc a
    ld bc, $0505 ; custom-English DAY value position: x=5, y=5
    ld d, $02
    call $31f5
    ret

    assert @ == $5fc3
