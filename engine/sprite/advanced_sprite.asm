include "macros/macros.inc"

; Advanced sprite behavior scheduler in Bank $17.
;
; Each behavior occupies a 32-byte WRAM-bank-4 record. The engine stages the
; first 20 bytes through wAdvancedSpriteX..wAdvancedSpriteActivationSfx while
; updating it; bytes 20-31 remain reserved/unstaged here. Coordinates are
; big-endian 8.8 fixed-point values and velocities are signed 8.8 values; only
; the integer high bytes are passed to SpriteObject_SetPosition.

DEF ADVANCED_SPRITE_RECORD_LENGTH EQU $20
DEF ADVANCED_SPRITE_STAGED_LENGTH EQU $14
DEF ADVANCED_SPRITE_INACTIVE EQU $ff

section "Advanced Sprite Behavior", romx[$4000], bank[$17]
; Clear all ordinary sprites and all advanced-behavior records/state.
AdvancedSprite_Reset::

    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call SpriteObject_DestroyAll
    xor a
    ld [wAdvancedSpriteX], a
    ld [wAdvancedSpriteX + 1], a
    ld [wAdvancedSpriteY], a
    ld [wAdvancedSpriteY + 1], a
    ld [wAdvancedSpriteVelocityX], a
    ld [wAdvancedSpriteVelocityX + 1], a
    ld [wAdvancedSpriteVelocityY], a
    ld [wAdvancedSpriteVelocityY + 1], a
    ld [wAdvancedSpriteSlot], a
    ld [wAdvancedSpriteDelay], a
    ld [wAdvancedSpriteDelay + 1], a
    ld [wAdvancedSpriteDuration], a
    ld [wAdvancedSpriteDuration + 1], a
    ld [wAdvancedSpriteCallback], a
    ld [wAdvancedSpriteCallback + 1], a
    ld [wAdvancedSpriteCallbackBank], a
    ld [wAdvancedSpriteUser0], a
    ld [wAdvancedSpriteUser1], a
    ld [wAdvancedSpriteHideWhileActive], a
    ld [wAdvancedSpriteActivationSfx], a
    ld [wAdvancedSpriteSpawnX], a
    ld [wAdvancedSpriteSpawnY], a
    ld hl, wAdvancedSpriteRecords
    ld bc, $0780
    xor a
    call Memset
    xor a
    ld [wAdvancedSpriteCount], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret


; Create a sprite and append one 32-byte behavior record.
; In: A = sprite ordering key, B/C/DE = SpriteObject_Create metadata, H = initial X,
;     L = initial Y. Velocity/timers/callback/options are supplied through the
;     staging fields wAdvancedSpriteVelocityX..wAdvancedSpriteActivationSfx.
; Out: A = created sprite slot.
AdvancedSprite_Add::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    push bc
    push af
    ld a, h
    ld [wAdvancedSpriteSpawnX], a
    ld a, l
    ld [wAdvancedSpriteSpawnY], a
    ld a, [wAdvancedSpriteCount]
    call AdvancedSprite_GetRecordAddress
    ld a, [wAdvancedSpriteSpawnX]
    ld [hl+], a
    inc hl
    ld a, [wAdvancedSpriteSpawnY]
    ld [hl+], a
    inc hl
    ld a, [wAdvancedSpriteVelocityX]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityX + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityY]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityY + 1]
    ld [hl+], a
    pop af
    pop bc
    push hl
    ld a, $20
    call SpriteObject_Create
    pop hl
    ld [hl+], a
    ld [wAdvancedSpriteSlot], a
    ld a, [wAdvancedSpriteDelay]
    ld [hl+], a
    ld a, [wAdvancedSpriteDelay + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteDuration]
    ld [hl+], a
    ld a, [wAdvancedSpriteDuration + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteCallback]
    ld [hl+], a
    ld a, [wAdvancedSpriteCallback + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteCallbackBank]
    ld [hl+], a
    ld a, [wAdvancedSpriteUser0]
    ld [hl+], a
    ld a, [wAdvancedSpriteUser1]
    ld [hl+], a
    ld a, [wAdvancedSpriteHideWhileActive]
    ld [hl+], a
    ld a, [wAdvancedSpriteActivationSfx]
    ld [hl+], a
    ld a, [wAdvancedSpriteCount]
    inc a
    ld [wAdvancedSpriteCount], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wAdvancedSpriteSlot]
    ret


; Update all records in spawn-first mode. During the pre-delay each sprite is
; hidden and has normal animation stepping suppressed.
AdvancedSprite_UpdateSpawnFirst::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wAdvancedSpriteCount]
    cp $00
    jr z, .done

    xor a
    ld [wAdvancedSpriteIndex], a
    ld [wAdvancedSpritePendingCount], a
    ld [wAdvancedSpriteProcessedCount], a

.loop:
    ld a, [wAdvancedSpriteCount]
    ld c, a
    ld a, [wAdvancedSpriteIndex]
    cp c
    jr z, .done

    call AdvancedSprite_UpdateOneSpawning
    ld a, [wAdvancedSpriteIndex]
    inc a
    ld [wAdvancedSpriteIndex], a
    jr .loop

.done:
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret


; When the associated effect flag at $c4ab is active, choose a small random
; vertical scroll offset and clear horizontal scroll. Used as screen shake.
AdvancedSprite_ChooseScrollDelta::
    ld a, [$c4ab]
    cp $00
    jr z, .done

    ld d, $03
    call Random_ZeroToDInclusive
    ldh [hSCY], a
    xor a
    ldh [hSCX], a
    ld a, $ff
    call Random_ZeroToDInclusive
    and $01
    cp $00
    jr z, .positive

    jr .negate

.negate:
    ldh a, [hSCY]
    add a
    ld c, a
    ldh a, [hSCY]
    sub c
    ldh [hSCY], a
    jr .done

.positive:
    ldh a, [hSCY]
    ld c, a
    xor a
    sub c
    ldh [hSCY], a

.done:
    ret


; Update all advanced sprites without forcibly hiding them during pre-delay.
AdvancedSprite_Update::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wAdvancedSpriteCount]
    cp $00
    jr z, .done

    xor a
    ld [wAdvancedSpriteIndex], a
    ld [wAdvancedSpritePendingCount], a
    ld [wAdvancedSpriteProcessedCount], a

.loop:
    ld a, [wAdvancedSpriteCount]
    ld c, a
    ld a, [wAdvancedSpriteIndex]
    cp c
    jr z, .done

    call AdvancedSprite_UpdateOneExisting
    ld a, [wAdvancedSpriteIndex]
    inc a
    ld [wAdvancedSpriteIndex], a
    jr .loop

.done:
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret


; Z is set when record A/current index has sprite slot $ff (inactive).
AdvancedSprite_RecordIsInactive::
    ld a, [wAdvancedSpriteIndex]
    call AdvancedSprite_GetRecordAddress
    ld b, $00
    ld a, $08
    ld c, a
    add hl, bc
    ld a, [hl]
    cp $ff
    ret


; Add signed 8.8 X/Y velocity to position and push integer coordinates to OAM sprite.
AdvancedSprite_ApplyVelocity::
    ld a, [wAdvancedSpriteVelocityX]
    ld b, a
    ld a, [wAdvancedSpriteVelocityX + 1]
    ld c, a
    ld a, [wAdvancedSpriteX]
    ld h, a
    ld a, [wAdvancedSpriteX + 1]
    ld l, a
    add hl, bc
    ld a, h
    ld [wAdvancedSpriteX], a
    ld a, l
    ld [wAdvancedSpriteX + 1], a
    ld a, [wAdvancedSpriteVelocityY]
    ld b, a
    ld a, [wAdvancedSpriteVelocityY + 1]
    ld c, a
    ld a, [wAdvancedSpriteY]
    ld h, a
    ld a, [wAdvancedSpriteY + 1]
    ld l, a
    add hl, bc
    ld a, h
    ld [wAdvancedSpriteY], a
    ld a, l
    ld [wAdvancedSpriteY + 1], a
    ld a, [wAdvancedSpriteX]
    ld b, a
    ld a, [wAdvancedSpriteY]
    ld c, a
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_SetPosition
    ret


; Decrement the 16-bit active-duration timer.
AdvancedSprite_DecrementActiveTimer::
    ld a, [wAdvancedSpriteDuration]
    ld h, a
    ld a, [wAdvancedSpriteDuration + 1]
    ld l, a
    dec hl
    ld a, h
    ld [wAdvancedSpriteDuration], a
    ld a, l
    ld [wAdvancedSpriteDuration + 1], a
    ret


; Update one record for the normal/already-existing behavior path.
AdvancedSprite_UpdateOneExisting::
    ld a, [wAdvancedSpriteIndex]
    call AdvancedSprite_GetRecordAddress
    push hl
    ld d, h
    ld e, l
    ld b, $00
    ld a, $08
    ld c, a
    add hl, bc
    ld a, [hl]
    cp $ff
    jp z, .inactive

    ld h, d
    ld l, e
    call AdvancedSprite_LoadRecord
    ld a, [wAdvancedSpriteDelay]
    ld h, a
    ld a, [wAdvancedSpriteDelay + 1]
    ld l, a
    ld de, $0000
    call Math_CompareHLToDE
    jr z, .delay_done

    ld a, [wAdvancedSpriteDelay]
    ld h, a
    ld a, [wAdvancedSpriteDelay + 1]
    ld l, a
    dec hl
    ld a, h
    ld [wAdvancedSpriteDelay], a
    ld a, l
    ld [wAdvancedSpriteDelay + 1], a
    ld a, [wAdvancedSpritePendingCount]
    inc a
    ld [wAdvancedSpritePendingCount], a
    jp .save


.delay_done:
    ld a, [wAdvancedSpriteActivationSfx]
    cp $00
    jr z, .check_duration

    call Audio_PlaySFX ; play sound effect A
    xor a
    ld [wAdvancedSpriteActivationSfx], a

.check_duration:
    ld a, [wAdvancedSpriteDuration]
    ld h, a
    ld a, [wAdvancedSpriteDuration + 1]
    ld l, a
    ld de, $0000
    call Math_CompareHLToDE
    jr nz, .active

    ld a, [wAdvancedSpriteCallback]
    ld h, a
    ld a, [wAdvancedSpriteCallback + 1]
    ld l, a
    ld de, $0000
    call Math_CompareHLToDE
    jr z, .remove

    ld a, [wAdvancedSpriteSlot]
    ld c, a
    ld a, [wAdvancedSpriteCallback]
    ld h, a
    ld a, [wAdvancedSpriteCallback + 1]
    ld l, a
    ld a, [wAdvancedSpriteCallbackBank]
    ld b, a
    call ROMBankCall
    ld a, [wAdvancedSpritePendingCount]
    inc a
    ld [wAdvancedSpritePendingCount], a
    jp .save


.remove:
    ld a, [wAdvancedSpriteSlot]
    cp $ff
    jp z, .save

    call SpriteObject_Destroy
    ld a, $ff
    ld [wAdvancedSpriteSlot], a
    jr .save

.active:
    ld a, [wAdvancedSpriteHideWhileActive]
    cp $01
    jr nz, .show

    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_Hide
    jr .move

.show:
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_Show

.move:
    call AdvancedSprite_DecrementActiveTimer
    call AdvancedSprite_ApplyVelocity
    ld a, [wAdvancedSpritePendingCount]
    inc a
    ld [wAdvancedSpritePendingCount], a

.save:
    pop hl
    call AdvancedSprite_SaveRecord
    ld a, [wAdvancedSpriteProcessedCount]
    inc a
    ld [wAdvancedSpriteProcessedCount], a
    ret


.inactive:
    pop hl
    ret


; Update one record for the spawn-first behavior path.
AdvancedSprite_UpdateOneSpawning::
    call AdvancedSprite_RecordIsInactive
    jp z, .done

    ld a, [wAdvancedSpriteIndex]
    call AdvancedSprite_GetRecordAddress
    push hl
    call AdvancedSprite_LoadRecord
    ld a, [wAdvancedSpriteDelay]
    ld h, a
    ld a, [wAdvancedSpriteDelay + 1]
    ld l, a
    ld de, $0000
    call Math_CompareHLToDE
    jr z, .spawn_delay_done

    ld a, [wAdvancedSpriteDelay]
    ld h, a
    ld a, [wAdvancedSpriteDelay + 1]
    ld l, a
    dec hl
    ld a, h
    ld [wAdvancedSpriteDelay], a
    ld a, l
    ld [wAdvancedSpriteDelay + 1], a
    ld a, [wAdvancedSpritePendingCount]
    inc a
    ld [wAdvancedSpritePendingCount], a
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_DisableAutoAnimation
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_Hide
    jp .save


.spawn_delay_done:
    ld a, [wAdvancedSpriteActivationSfx]
    cp $00
    jr z, .spawn_check_duration

    call Audio_PlaySFX ; play sound effect A
    xor a
    ld [wAdvancedSpriteActivationSfx], a

.spawn_check_duration:
    ld a, [wAdvancedSpriteDuration]
    ld h, a
    ld a, [wAdvancedSpriteDuration + 1]
    ld l, a
    ld de, $0000
    call Math_CompareHLToDE
    jr nz, .spawn_active

    ld a, [wAdvancedSpriteCallback]
    ld h, a
    ld a, [wAdvancedSpriteCallback + 1]
    ld l, a
    ld de, $0000
    call Math_CompareHLToDE
    jr z, .spawn_remove

    ld a, [wAdvancedSpriteSlot]
    ld c, a
    ld a, [wAdvancedSpriteCallback]
    ld h, a
    ld a, [wAdvancedSpriteCallback + 1]
    ld l, a
    ld a, [wAdvancedSpriteCallbackBank]
    ld b, a
    call ROMBankCall
    jp .save


.spawn_remove:
    ld a, [wAdvancedSpriteSlot]
    cp $ff
    jp z, .save

    call SpriteObject_Destroy
    ld a, $ff
    ld [wAdvancedSpriteSlot], a
    jr .spawn_save

.spawn_active:
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_EnableAutoAnimation
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_Show
    ld a, [wAdvancedSpriteHideWhileActive]
    cp $01
    jr nz, .spawn_show

    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_Hide
    jr .spawn_move

.spawn_show:
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_Show

.spawn_move:
    ld a, [wAdvancedSpriteDuration]
    ld h, a
    ld a, [wAdvancedSpriteDuration + 1]
    ld l, a
    dec hl
    ld a, h
    ld [wAdvancedSpriteDuration], a
    ld a, l
    ld [wAdvancedSpriteDuration + 1], a
    ld a, [wAdvancedSpriteVelocityX]
    ld b, a
    ld a, [wAdvancedSpriteVelocityX + 1]
    ld c, a
    ld a, [wAdvancedSpriteX]
    ld h, a
    ld a, [wAdvancedSpriteX + 1]
    ld l, a
    add hl, bc
    ld a, h
    ld [wAdvancedSpriteX], a
    ld a, l
    ld [wAdvancedSpriteX + 1], a
    ld a, [wAdvancedSpriteVelocityY]
    ld b, a
    ld a, [wAdvancedSpriteVelocityY + 1]
    ld c, a
    ld a, [wAdvancedSpriteY]
    ld h, a
    ld a, [wAdvancedSpriteY + 1]
    ld l, a
    add hl, bc
    ld a, h
    ld [wAdvancedSpriteY], a
    ld a, l
    ld [wAdvancedSpriteY + 1], a
    ld a, [wAdvancedSpriteX]
    ld b, a
    ld a, [wAdvancedSpriteY]
    ld c, a
    ld a, [wAdvancedSpriteSlot]
    call SpriteObject_SetPosition
    ld a, [wAdvancedSpritePendingCount]
    inc a
    ld [wAdvancedSpritePendingCount], a

.save:
.spawn_save:
    pop hl
    call AdvancedSprite_SaveRecord
    ld a, [wAdvancedSpriteProcessedCount]
    inc a
    ld [wAdvancedSpriteProcessedCount], a

.done:
    ret


; Copy the staged 20-byte prefix from HL into fixed WRAM scratch.
AdvancedSprite_LoadRecord::
    ld a, [hl+]
    ld [wAdvancedSpriteX], a
    ld a, [hl+]
    ld [wAdvancedSpriteX + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteY], a
    ld a, [hl+]
    ld [wAdvancedSpriteY + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteVelocityX], a
    ld a, [hl+]
    ld [wAdvancedSpriteVelocityX + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteVelocityY], a
    ld a, [hl+]
    ld [wAdvancedSpriteVelocityY + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteSlot], a
    ld a, [hl+]
    ld [wAdvancedSpriteDelay], a
    ld a, [hl+]
    ld [wAdvancedSpriteDelay + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteDuration], a
    ld a, [hl+]
    ld [wAdvancedSpriteDuration + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteCallback], a
    ld a, [hl+]
    ld [wAdvancedSpriteCallback + 1], a
    ld a, [hl+]
    ld [wAdvancedSpriteCallbackBank], a
    ld a, [hl+]
    ld [wAdvancedSpriteUser0], a
    ld a, [hl+]
    ld [wAdvancedSpriteUser1], a
    ld a, [hl+]
    ld [wAdvancedSpriteHideWhileActive], a
    ld a, [hl+]
    ld [wAdvancedSpriteActivationSfx], a
    ret


; Copy the staged 20-byte prefix back to the behavior record at HL.
AdvancedSprite_SaveRecord::
    ld a, [wAdvancedSpriteX]
    ld [hl+], a
    ld a, [wAdvancedSpriteX + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteY]
    ld [hl+], a
    ld a, [wAdvancedSpriteY + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityX]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityX + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityY]
    ld [hl+], a
    ld a, [wAdvancedSpriteVelocityY + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteSlot]
    ld [hl+], a
    ld a, [wAdvancedSpriteDelay]
    ld [hl+], a
    ld a, [wAdvancedSpriteDelay + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteDuration]
    ld [hl+], a
    ld a, [wAdvancedSpriteDuration + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteCallback]
    ld [hl+], a
    ld a, [wAdvancedSpriteCallback + 1]
    ld [hl+], a
    ld a, [wAdvancedSpriteCallbackBank]
    ld [hl+], a
    ld a, [wAdvancedSpriteUser0]
    ld [hl+], a
    ld a, [wAdvancedSpriteUser1]
    ld [hl+], a
    ld a, [wAdvancedSpriteHideWhileActive]
    ld [hl+], a
    ld a, [wAdvancedSpriteActivationSfx]
    ld [hl+], a
    ret


; HL = wAdvancedSpriteRecords + A * 32.
AdvancedSprite_GetRecordAddress::
    rlca
    rlca
    rlca
    rlca
    rlca
    ld c, a
    and $1f
    ld h, a
    ld a, c
    and $e0
    ld l, a
    ld bc, wAdvancedSpriteRecords
    add hl, bc
    ret

assert @ == $4487
