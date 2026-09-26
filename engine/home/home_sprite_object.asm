; Fixed-bank sprite object lifecycle, animation, and shadow-OAM construction.
; This module is byte-authoritative to the Japanese retail ROM while preserving
; the project's custom English content elsewhere in the tree.
;
; Sprite objects live in WRAM bank 4. There are 40 slots, each 16 bytes long.
; A separate 40-byte key table tracks occupied slots and feeds a linked ordering
; structure used when rebuilding the 40-entry shadow OAM table at wShadowOAM.
;
; Field names are intentionally conservative until the banked sprite-data tables
; and all callers have been mapped. Known behavior is documented at each helper.

DEF NUM_SPRITE_OBJECTS EQU 40
DEF SPRITE_STRUCT_LENGTH EQU $10
DEF OAM_ENTRY_LENGTH EQU 4

; Confirmed object layout fields. Remaining bytes are left unnamed until callers
; prove their semantics.
DEF SPRITE_FLAGS EQU 0
DEF SPRITE_Y EQU 1
DEF SPRITE_X EQU 2
DEF SPRITE_ATTRIBUTES EQU 3
DEF SPRITE_BASE_TILE EQU 4
DEF SPRITE_ANIMATION_BANK EQU 5
DEF SPRITE_OAM_FRAME_POINTER EQU 6 ; 2 bytes
DEF SPRITE_ANIMATION_POINTER EQU 8 ; 2 bytes
DEF SPRITE_ANIMATION_INDEX EQU 10
DEF SPRITE_ANIMATION_DELAY EQU 11

; No generic accessor or fixed-engine use has yet been found for bytes 12-15.
; Keep them explicitly reserved rather than assigning speculative meanings.
DEF SPRITE_RESERVED_12 EQU 12
DEF SPRITE_RESERVED_13 EQU 13
DEF SPRITE_RESERVED_14 EQU 14
DEF SPRITE_RESERVED_15 EQU 15

section "Sprite Engine", rom0[$2d7c]

; Clear all sprite-object state, the slot-ordering tables, and shadow OAM.
SpriteObject_ResetAll::
    ldh a, [hWRAMBank]
    push af
    push bc
    push hl
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld bc, NUM_SPRITE_OBJECTS * SPRITE_STRUCT_LENGTH
    ld hl, wSpriteObjects
    xor a
    call Memset
    ld bc, NUM_SPRITE_OBJECTS
    ld hl, wSpriteSlotKeys
    xor a
    call Memset
    xor a
    ldh [hSpriteCount], a
    ld a, $01
    ld [wSpriteOrderPrefix], a
    ld a, $ff
    ld [wSpriteOrderPrefix + 1], a
    ld a, NUM_SPRITE_OBJECTS + 1
    ld [wSpriteListHead], a
    ld a, $ff
    ld [wSpriteListHead + 1], a
    ld a, $ff
    ld [wSpritePrevSentinels], a
    ld a, NUM_SPRITE_OBJECTS
    ld [wSpritePrevSentinels + 1], a
    ld hl, wShadowOAM
    ld bc, NUM_SPRITE_OBJECTS * OAM_ENTRY_LENGTH
    xor a
    call Memset
    ld a, NUM_SPRITE_OBJECTS
    ldh [hOAMEntriesFree], a
    ld a, $01
    ld [wOAMDMAPending], a
    pop hl
    pop bc
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ret

; Clear the 16-byte object structure for sprite slot A.
SpriteObject_ClearStruct::
    push bc
    push hl
    ld b, $00
    call SpriteObject_GetStructAddress
    ld bc, SPRITE_STRUCT_LENGTH
    xor a
    call Memset
    pop hl
    pop bc
    ret

; Create/prepare a sprite object.
; In:  A = ordering key/priority (0 returns no slot)
;      B = source ROM bank
;      C = base tile/VRAM selection value
;      DE = pointer into sprite animation/frame metadata
; Out: A = allocated slot, or NUM_SPRITE_OBJECTS if none is available.
SpriteObject_Create::
    push hl
    ldh [hSpriteCreateKey], a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ldh a, [hSpriteCreateKey]
    call SpriteObject_AllocateSlot
    cp NUM_SPRITE_OBJECTS
    jr z, .no_slot
    push bc
    ld b, $04
    call SpriteObject_GetStructAddress
    pop bc
    ld [hl], c
    inc hl
    ld [hl], b
    inc hl
    inc hl
    inc hl
    ld [hl], e
    inc hl
    ld [hl], d
    ldh a, [hSpriteAllocatedSlot]
    call SpriteObject_LoadAnimationFrame
    jr .done
.no_slot
    ldh [hSpriteAllocatedSlot], a
.done
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ldh a, [hSpriteAllocatedSlot]
    pop hl
    ret

; Remove sprite slot A from the active ordering list and clear its structure.
SpriteObject_Destroy::
    push bc
    push de
    push hl
    cp NUM_SPRITE_OBJECTS
    jr nc, .done
    ld b, $00
    ld c, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld hl, wSpriteSlotKeys
    add hl, bc
    ld a, [hl]
    and a
    jr z, .restore_bank
    xor a
    ld [hl], a
    ld a, c
    call SpriteObject_ClearStruct
    ld hl, wSpritePrevSlots
    add hl, bc
    ld e, [hl]
    xor a
    ld [hl], a
    ld hl, wSpriteNextSlots
    add hl, bc
    ld d, [hl]
    xor a
    ld [hl], a
    ld hl, wSpriteNextSlots
    ld c, e
    add hl, bc
    ld [hl], d
    ld hl, wSpritePrevSlots
    ld c, d
    add hl, bc
    ld [hl], e
    ld hl, hSpriteCount
    dec [hl]
.restore_bank
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
.done
    pop hl
    pop de
    pop bc
    ret

; Remove every sprite and clear shadow OAM.
SpriteObject_DestroyAll::
    push bc
    push hl
    ld b, $00
.loop
    ld a, b
    call SpriteObject_Destroy
    inc b
    ld a, b
    cp NUM_SPRITE_OBJECTS
    jr nz, .loop
    ld hl, wShadowOAM
    ld bc, NUM_SPRITE_OBJECTS * OAM_ENTRY_LENGTH
    xor a
    call Memset
    ld a, $01
    ld [wOAMDMAPending], a
    pop hl
    pop bc
    ret

; Write C to byte B of sprite structure A.
SpriteObject_SetField::
    call SpriteObject_GetStructAddress
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld [hl], c
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ret

; Read byte B of sprite structure A.
SpriteObject_GetField::
    call SpriteObject_GetStructAddress
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld b, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, b
    ret

; Store C/B into object fields 1/2 for sprite A.
; These values feed directly into the Y/X calculations during OAM construction.
SpriteObject_SetPosition::
    push hl
    push bc
    ld b, $01
    call SpriteObject_GetStructAddress
    pop bc
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld [hl], c
    inc hl
    ld [hl], b
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    ret

; Replace only the low three bits of object field 3.
SpriteObject_SetPalette::
    push de
    push hl
    ld c, b
    ld b, $03
    call SpriteObject_GetField
    and $f8
    or c
    ld c, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, c
    ld [hl], a
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop de
    ret

; Update the animation ROM bank and animation-table pointer for sprite A.
SpriteObject_SetAnimation::
    push bc
    push hl
    ld c, a
    push bc
    ld b, $05
    call SpriteObject_GetStructAddress
    pop bc
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld [hl], b
    inc hl
    inc hl
    inc hl
    ld [hl], e
    inc hl
    ld [hl], d
    inc hl
    xor a
    ld [hl], a
    ld a, c
    call SpriteObject_LoadAnimationFrame
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

SpriteObject_DisableAutoAnimation::
    push bc
    push hl
    ld b, $00
    call SpriteObject_GetStructAddress
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    set 1, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

SpriteObject_EnableAutoAnimation::
    push bc
    push hl
    ld b, $00
    call SpriteObject_GetStructAddress
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    res 1, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

; Field 0 bit 0 suppresses OAM generation when set. Clearing it shows the sprite.
SpriteObject_Show::
    push bc
    push hl
    ld b, $00
    call SpriteObject_GetStructAddress
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    res 0, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

; Set the OAM-suppression bit, hiding the sprite.
SpriteObject_Hide::
    push bc
    push hl
    ld b, $00
    call SpriteObject_GetStructAddress
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    set 0, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

SpriteObject_ShowAll::
    push bc
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld hl, wSpriteSlotKeys
    ld b, $00
.loop
    ld a, [hl+]
    and a
    jr z, .next
    ld a, b
    call SpriteObject_Show
.next
    inc b
    ld a, b
    cp NUM_SPRITE_OBJECTS
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

SpriteObject_HideAll::
    push bc
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld hl, wSpriteSlotKeys
    ld b, $00
.loop
    ld a, [hl+]
    and a
    jr z, .next
    ld a, b
    call SpriteObject_Hide
.next
    inc b
    ld a, b
    cp NUM_SPRITE_OBJECTS
    jr nz, .loop
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop hl
    pop bc
    ret

; Allocate a free slot and insert it into the key-ordered slot list.
; A = key/priority. A=0 is treated as no sprite.
SpriteObject_AllocateSlot::
    and a
    jr z, .none
    push bc
    push hl
    ldh [hSpriteCreateKey], a
    call SpriteObject_FindFreeSlot
    cp NUM_SPRITE_OBJECTS
    jr z, .done
    ldh [hSpriteAllocatedSlot], a
    ldh a, [hSpriteCreateKey]
    call SpriteObject_InsertSortedSlot
    ldh a, [hSpriteAllocatedSlot]
    call SpriteObject_ClearStruct
    ld hl, hSpriteCount
    inc [hl]
    ldh a, [hSpriteAllocatedSlot]
.done
    pop hl
    pop bc
    ret
.none
    ld a, NUM_SPRITE_OBJECTS
    ret

SpriteObject_FindFreeSlot::
    push bc
    push hl
    ld hl, wSpriteSlotKeys
    ld b, $00
.loop
    ld a, [hl+]
    and a
    jr z, .found
    inc b
    ld a, b
    cp NUM_SPRITE_OBJECTS
    jr nz, .loop
.found
    ld a, b
    pop hl
    pop bc
    ret

; Insert hSpriteAllocatedSlot into the linked ordering tables according to
; hSpriteCreateKey, and store that key in wSpriteSlotKeys[slot].
SpriteObject_InsertSortedSlot::
    push bc
    push de
    push hl
    ldh [hSpriteCreateKey], a
    ld d, a
    ld a, [wSpriteListHead]
    ld c, a
    ld b, $00
.search
    ld hl, wSpriteSlotKeys
    add hl, bc
    ld a, [hl]
    cp d
    jr nc, .insert
    ld hl, wSpriteNextSlots
    add hl, bc
    ld c, [hl]
    jr .search
.insert
    ldh a, [hSpriteAllocatedSlot]
    ld e, a
    ld d, $00
    ld hl, wSpriteNextSlots
    add hl, de
    ld [hl], c
    ld hl, wSpritePrevSlots
    ld b, $00
    add hl, bc
    ld b, [hl]
    ld [hl], e
    ld hl, wSpriteNextSlots
    ld a, b
    add l
    ld l, a
    ld a, h
    adc $00
    ld h, a
    ld [hl], e
    ld hl, wSpritePrevSlots
    add hl, de
    ld [hl], b
    ld hl, wSpriteSlotKeys
    add hl, de
    ldh a, [hSpriteCreateKey]
    ld [hl], a
    pop hl
    pop de
    pop bc
    ret

; HL = wSpriteObjects + A * 16 + B.
SpriteObject_GetStructAddress::
    swap a
    ld h, a
    and $f0
    add b
    ld l, a
    ld a, h
    and $0f
    add HIGH(wSpriteObjects)
    ld h, a
    ret

; Rebuild the 40-entry shadow OAM table by traversing the sprite ordering list.
Sprite_Update::
    ldh a, [hROMBank]
    push af
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, NUM_SPRITE_OBJECTS
    ldh [hOAMEntriesFree], a
    xor a
    ldh [hShadowOAMOffset], a
    ld a, [wSpriteListHead]
    ldh [hSpriteCurrentSlot], a
    jr .check_slot
.next_slot
    swap a
    ld h, a
    and $f0
    ld l, a
    ld a, h
    and $0f
    add HIGH(wSpriteObjects)
    ld h, a
    bit 1, [hl]
    jr nz, .skip_animation
    call SpriteObject_UpdateAnimation
.skip_animation
    ldh a, [hSpriteCurrentSlot]
    call SpriteObject_AppendOAM
    ldh a, [hOAMEntriesFree]
    and a
    jr z, .finish
    ld hl, wSpriteNextSlots
    ldh a, [hSpriteCurrentSlot]
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [hl]
    ldh [hSpriteCurrentSlot], a
.check_slot
    cp NUM_SPRITE_OBJECTS
    jr c, .next_slot
    ldh a, [hPreviousOAMEntriesFree]
    ld b, a
    ldh a, [hOAMEntriesFree]
    sub b
    jr c, .finish
    jr z, .finish
    ld b, a
    ldh a, [hShadowOAMOffset]
    ld l, a
    ld h, HIGH(wShadowOAM)
    xor a
.clear_tail
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    dec b
    jr nz, .clear_tail
.finish
    ldh a, [hOAMEntriesFree]
    ldh [hPreviousOAMEntriesFree], a
    ld a, $01
    ld [wOAMDMAPending], a
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    pop af
    ldh [hROMBank], a
    ld [$2000], a
    ret

; Append all OAM pieces for sprite A to wShadowOAM.
SpriteObject_AppendOAM::
    push bc
    swap a
    ld h, a
    and $f0
    ld l, a
    ld a, h
    and $0f
    add HIGH(wSpriteObjects)
    ld h, a
    bit 0, [hl]
    jr nz, .done
    ld a, [hl+]
    ldh [hSpriteFlags], a
    ld a, [hl+]
    ldh [hSpriteBaseY], a
    ld a, [hl+]
    ldh [hSpriteBaseX], a
    ld a, [hl+]
    ldh [hSpriteAttributes], a
    ld a, [hl+]
    ldh [hSpriteBaseTile], a
    ld a, [hl+]
    ldh [hROMBank], a
    ld [$2000], a
    ld a, [hl+]
    ld e, a
    ld d, [hl]
    ld a, [de]
    inc de
    ldh [hSpritePiecesRemaining], a
.piece_loop
    ldh a, [hSpriteBaseY]
    ld c, a
    ld a, [de]
    inc de
    add c
    ldh [hSpritePieceY], a
    ldh a, [hSpriteBaseX]
    ld c, a
    ld a, [de]
    inc de
    add c
    ldh [hSpritePieceX], a
    ldh a, [hSpriteBaseTile]
    ld l, a
    ld h, $00
    add hl, hl
    ld a, [de]
    inc de
    ld c, a
    ld b, $00
    add hl, bc
    ld a, l
    ldh [hSpritePieceTile], a
    ld a, h
    rlca
    rlca
    rlca
    ldh [hSpritePieceAttributes], a
    ldh a, [hSpriteAttributes]
    ld c, a
    ldh a, [hSpritePieceAttributes]
    ld b, a
    ld a, [de]
    inc de
    or b
    add c
    ldh [hSpritePieceAttributes], a
    ldh a, [hShadowOAMOffset]
    ld l, a
    ld h, HIGH(wShadowOAM)
    ldh a, [hSpritePieceY]
    ld [hl+], a
    ldh a, [hSpritePieceX]
    ld [hl+], a
    ldh a, [hSpritePieceTile]
    ld [hl+], a
    ldh a, [hSpritePieceAttributes]
    ld [hl+], a
    ld a, l
    ldh [hShadowOAMOffset], a
    ld hl, hOAMEntriesFree
    dec [hl]
    jr z, .done
    ld hl, hSpritePiecesRemaining
    dec [hl]
    jr nz, .piece_loop
.done
    pop bc
    ret

; Advance animation timing for hSpriteCurrentSlot and load a new frame when
; SPRITE_ANIMATION_DELAY reaches zero. $ff means no automatic countdown.
SpriteObject_UpdateAnimation::
    push bc
    ldh a, [hSpriteCurrentSlot]
    swap a
    ld h, a
    and $f0
    add $0b
    ld l, a
    ld a, h
    and $0f
    add HIGH(wSpriteObjects)
    ld h, a
    ld a, [hl]
    cp $ff
    jr z, .done
    and a
    jr nz, .decrement
    dec hl
    inc [hl]
    ldh a, [hSpriteCurrentSlot]
    call SpriteObject_LoadAnimationFrame
    jr .done
.decrement
    dec a
    ld [hl], a
.done
    pop bc
    ret

; Cleanup tail immediately after the animation updater.
; It expects the caller to have already saved BC, removes the current slot,
; restores BC, and returns.
SpriteObject_DestroyCurrentTail::
    ldh a, [hSpriteCurrentSlot]
    call SpriteObject_Destroy
    pop bc
    ret

; Load the animation entry selected by SPRITE_ANIMATION_INDEX for sprite A.
; Each real entry is `dw OAM frame pointer, db delay`; a bare `dw 0` ends the
; stream and loops it back to entry 0. Fields 6/7 therefore point directly to
; an OAM-frame structure and field 11 is the per-frame countdown delay.
; The banked animation-table pointer itself is stored in fields 8/9.
SpriteObject_LoadAnimationFrame::
    push de
    push hl
    swap a
    ld h, a
    and $f0
    add $05
    ld l, a
    ld a, h
    and $0f
    add HIGH(wSpriteObjects)
    ld h, a
    ldh a, [hROMBank]
    push af
    ld a, [hl]
    ldh [hROMBank], a
    ld [$2000], a
    inc hl
    inc hl
    inc hl
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    call SpriteObject_ReadAnimationEntry
    ld [hl], a
    ld a, c
    or b
    jr nz, .store_frame
    ld a, [de]
    inc de
    ld c, a
    ld a, [de]
    inc de
    ld b, a
    ld a, [de]
    ld [hl-], a
    xor a
    ld [hl+], a
.store_frame
    dec hl
    dec hl
    dec hl
    dec hl
    ld [hl], b
    dec hl
    ld [hl], c
    pop af
    ldh [hROMBank], a
    ld [$2000], a
    pop hl
    pop de
    ret

; Read a 3-byte animation entry at DE + A*3.
; Out: BC = first two bytes, A = third byte.
SpriteObject_ReadAnimationEntry::
    push hl
    ld h, d
    ld l, e
    ld c, a
    ld b, $00
    add hl, bc
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld b, a
    ld a, [hl]
    pop hl
    ret

; Queue a two-digit hexadecimal byte at tilemap coordinates BC.
; Used by debug/status-style numeric displays in nearby fixed-bank code.
Text_QueueHexByte::
    push hl
    push de
    ld hl, wNumberRenderBuffer
    call Text_ByteToHex
    call Vram_TilemapCoord
    ld e, l
    ld d, h
    ld hl, wNumberRenderBuffer
    ld b, $02
    call VBlankFIFO_Queue
    pop de
    pop hl
    ret

Text_ByteToHex::
    push af
    swap a
    call Text_NibbleToHex
    pop af
Text_NibbleToHex::
    and $0f
    add $30
    cp $3a
    jr c, .store
    add $07
.store
    ld [hl+], a
    ret

    assert @ == $31f5
