include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main

; Modal shown when a saved-data domain fails validation. A selects one of the
; 17 domain prefixes below; the fixed suffix states that the data was erased.
section "Map Save Recovery Notice", romx[$4b50], bank[$14]
MapSave_ShowSlotRecoveryNotice::
    push bc
    push de
    push hl
    push af

    ld a, $00
    farcall UIWindowStack_SetAttributes
    ld bc, $0204
    ld de, $1007
    farcall UIWindow_DrawFrame

    pop af
    ld hl, MapSave_RecoveryMessagePointers
    call WordTable_Get
    ld bc, $0406
    call TextPut

    ld hl, MapSave_RecoveryErasedSuffix
    ld bc, $0408
    call TextPut

    ld a, $2b
    call Audio_PlaySFX
.wait_sfx
    call Audio_IsSFXActive
    and a
    jr nz, .wait_sfx

.wait_confirm
    call Joypad_Update
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, .wait_confirm

    pop hl
    pop de
    pop bc
    ret

MapSave_RecoveryMessagePointers::
    dw MapSave_RecoveryData1
    dw MapSave_RecoveryData2
    dw MapSave_RecoveryData3
    dw MapSave_RecoveryAutosave
    dw MapSave_RecoveryEditPlay
    dw MapSave_RecoveryVersusPlay
    dw MapSave_RecoveryMessageBox
    dw MapSave_RecoveryEditData1
    dw MapSave_RecoveryEditData2
    dw MapSave_RecoveryEditData3
    dw MapSave_RecoveryEditData4
    dw MapSave_RecoveryEditData5
    dw MapSave_RecoveryEditData6
    dw MapSave_RecoveryEditData7
    dw MapSave_RecoveryEditData8
    dw MapSave_RecoveryEditData9
    dw MapSave_RecoveryEditData10

MapSave_RecoveryData1::
    db "DATA1が", $00
MapSave_RecoveryData2::
    db "DATA2が", $00
MapSave_RecoveryData3::
    db "DATA3が", $00
MapSave_RecoveryAutosave::
    db "オートセーブデータが", $00
MapSave_RecoveryEditPlay::
    db "エディットプレイのデータが", $00
MapSave_RecoveryVersusPlay::
    db "VSプレイのデータが", $00
MapSave_RecoveryMessageBox::
    db "メッセージBOXが", $00
MapSave_RecoveryEditData1::
    db "エディットデータ1が", $00
MapSave_RecoveryEditData2::
    db "エディットデータ2が", $00
MapSave_RecoveryEditData3::
    db "エディットデータ3が", $00
MapSave_RecoveryEditData4::
    db "エディットデータ4が", $00
MapSave_RecoveryEditData5::
    db "エディットデータ5が", $00
MapSave_RecoveryEditData6::
    db "エディットデータ6が", $00
MapSave_RecoveryEditData7::
    db "エディットデータ7が", $00
MapSave_RecoveryEditData8::
    db "エディットデータ8が", $00
MapSave_RecoveryEditData9::
    db "エディットデータ9が", $00
MapSave_RecoveryEditData10::
    db "エディットデータ10が", $00

MapSave_RecoveryErasedSuffix::
    db "きえてしまいました", $00

    assert @ == $4c70
