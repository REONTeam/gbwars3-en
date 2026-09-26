include "macros/macros.inc"

; logical 9-character map-name support.
;
; Persistent map records remain exactly 46 bytes through the prefix. Characters
; 1-8 occupy the retail name field and character 9 occupies reserved map-header
; byte $1F. Transient UI buffers use their existing ninth byte and temporarily
; zero the following live byte only while TextPut consumes the string.
section "Map Name 9 Character Helpers", romx[$6368], bank[$13]

; Compute mode-2 text-input length without scanning into live $CC38 state.
; Characters 1-8 are in wTextInputBuffer; character 9 is at $CC37.
MapName9_TextInputInitLength::
    ld hl, wTextInputBuffer
    ld b, 0
.loop
    ld a, b
    cp MAP_RECORD_NAME_SIZE
    jr z, .base_full
    ld a, [hli]
    and a
    jr z, .done
    inc b
    jr .loop
.base_full
    ld a, [wTextInputMapNameExtra]
    and a
    jr z, .done
    inc b
.done
    ld a, b
    ld [$cc3a], a
    ret

; Retail append behavior for non-map modes is retained. Mode 2 grows to a
; logical length of 9 and places the ninth character in the sidecar byte.
MapName9_TextInputAppend::
    ld a, [$cc43]
    cp 2
    jr z, .map_name_mode
    ld a, [$cc3a]
    cp 6
    jr z, .redraw
    jr .append_base
.map_name_mode
    ld a, [$cc3a]
    cp MAP_RECORD_NAME_LOGICAL_SIZE
    jr z, .redraw
    cp MAP_RECORD_NAME_SIZE
    jr z, .append_extra
.append_base
    ld hl, wTextInputBuffer
    ld a, [$cc3a]
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [$cc3b]
    ld [hl], a
    inc hl
    xor a
    ld [hl], a
    ld a, [$cc3a]
    inc a
    ld [$cc3a], a
    jr .redraw
.append_extra
    ld a, [$cc3b]
    ld [wTextInputMapNameExtra], a
    ld a, MAP_RECORD_NAME_LOGICAL_SIZE
    ld [$cc3a], a
.redraw
    farcall TextInput_RedrawCurrentValue
    ret

; Backspace character 9 without touching $CC38. Other map-name characters and
; non-map input modes preserve the retail buffer-clearing behavior.
MapName9_TextInputBackspace::
    ld a, [$cc43]
    cp 2
    jr nz, .retail
    ld a, [$cc3a]
    and a
    ret z
    cp MAP_RECORD_NAME_LOGICAL_SIZE
    jr nz, .map_base
    ld a, MAP_RECORD_NAME_SIZE
    ld [$cc3a], a
    xor a
    ld [wTextInputMapNameExtra], a
    farcall TextInput_RedrawCurrentValue
    ret
.map_base
    dec a
    ld [$cc3a], a
    ld hl, wTextInputBuffer
    ld b, 0
    ld c, a
    add hl, bc
    xor a
    ld [hl], a
    farcall TextInput_RedrawCurrentValue
    ret
.retail
    ld a, [$cc3a]
    and a
    ret z
    dec a
    ld [$cc3a], a
    ld hl, wTextInputBuffer
    ld b, 0
    ld c, a
    add hl, bc
    xor a
    ld [hl], a
    farcall TextInput_RedrawCurrentValue
    ret

; Draw the loaded map name through the Map Menu's existing scratch.
; The ninth-character slot is followed by an independently live byte that is
; saved/zeroed/restored as a temporary terminator.
; Input: BC = text coordinates.
MapName9_DrawLoadedViaDC3B::
    push bc
    ld de, wMapRecordName
    ld hl, wMapMenuMapNameScratch
    ld bc, MAP_RECORD_NAME_SIZE
    call Memcpy
    ld a, [wMapRecordNameExtra]
    ld [wMapMenuMapNameScratchExtra], a
    pop bc
    ld a, [wMapMenuMapNameScratchBorrowedTerminator]
    push af
    xor a
    ld [wMapMenuMapNameScratchBorrowedTerminator], a
    ld hl, wMapMenuMapNameScratch
    call TextPut
    pop af
    ld [wMapMenuMapNameScratchBorrowedTerminator], a
    ret

; Cache all nine logical characters without moving the selected-map index.
; The index byte itself is used as a temporary zero terminator by DrawCache.
MapName9_CacheSelectedMapName::
    push bc
    push de
    ld de, wMapRecordName
    ld hl, wMapNameCache
    ld bc, MAP_RECORD_NAME_SIZE
    call Memcpy
    ld a, [wMapRecordNameExtra]
    ld [wMapNameCacheExtra], a
    ld a, [wMapRecordIndex]
    ld [wMapNameCacheIndex], a
    pop de
    pop bc
    ret

; Input: BC = text coordinates.
MapName9_DrawCache::
    ld a, [wMapNameCacheIndex]
    push af
    xor a
    ld [wMapNameCacheIndex], a
    ld hl, wMapNameCache
    call TextPut
    pop af
    ld [wMapNameCacheIndex], a
    ret

; Input: BC = text coordinates.
MapName9_DrawEditorCurrent::
    push bc
    ld de, wEditorMapName
    ld hl, wEditorMapNameDisplayScratch
    ld bc, MAP_RECORD_NAME_SIZE
    call Memcpy
    ld a, [wEditorMapNameExtra]
    ld [wEditorMapNameDisplayExtra], a
    pop bc
    ld a, [wEditorMapNameDisplayBorrowedTerminator]
    push af
    xor a
    ld [wEditorMapNameDisplayBorrowedTerminator], a
    ld hl, wEditorMapNameDisplayScratch
    call TextPut
    pop af
    ld [wEditorMapNameDisplayBorrowedTerminator], a
    ret

; Unit Status uses a WRAM-bank-4 scratch. The ninth-character slot is followed
; by an independently live byte borrowed as the terminator only while rendering.
MapName9_DrawLoadedUnitStatus::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, wMapRecordName
    ld hl, wUnitStatusMapNameScratch
    ld bc, MAP_RECORD_NAME_SIZE
    call MemcpyWaitLCD
    ld a, [wMapRecordNameExtra]
    ld [wUnitStatusMapNameScratchExtra], a
    ld a, [wUnitStatusMapNameScratchBorrowedTerminator]
    push af
    xor a
    ld [wUnitStatusMapNameScratchBorrowedTerminator], a
    ld hl, wUnitStatusMapNameScratch
    call TextPut
    pop af
    ld [wUnitStatusMapNameScratchBorrowedTerminator], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

MapName9_DrawLoadedUnitStatusAlt::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, wMapRecordName
    ld hl, wUnitStatusMapNameScratch
    ld bc, MAP_RECORD_NAME_SIZE
    call MemcpyWaitLCD
    ld a, [wMapRecordNameExtra]
    ld [wUnitStatusMapNameScratchExtra], a
    ld a, [wUnitStatusMapNameScratchBorrowedTerminator]
    push af
    xor a
    ld [wUnitStatusMapNameScratchBorrowedTerminator], a
    ld de, wUnitStatusMapNameScratch
    call Vram_DrawZeroTerminatedRow
    pop af
    ld [wUnitStatusMapNameScratchBorrowedTerminator], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ <= $6600, "9-character map-name helper block exceeds reserved Bank $13 tail budget"
