include "macros/macros.inc"

; The obsolete Bank $27:$5F97 editor-name stub was removed after a whole-ROM
; reference audit proved it had no callers or pointers and overlapped live STATUS code.

; The former Bank $15 cached-name overlay is now integrated into the complete
; SuspendResume_DrawSavedSessionPreview routine at Bank $15:$5F63.

section "Cached Map Name Display 27 Row 8", romx[$731a], bank[$27]
MapNameCache_DrawRow8::
    ld a, [wMapNameCacheIndex]
    inc a
    lb bc, 4, 8
    ld d, 2
    call DrawNumberFixedWidth
    lb bc, 7, 8
    farcall MapName9_DrawCache

    ds 2, 0
    assert @ == $732f

section "Cached Map Name Display 27 Row 11", romx[$73a7], bank[$27]
MapNameCache_DrawRow11::
    ld a, [wMapNameCacheIndex]
    inc a
    lb bc, 4, 11
    ld d, 2
    call DrawNumberFixedWidth
    lb bc, 7, 11
    farcall MapName9_DrawCache

    ds 2, 0
    assert @ == $73bc

section "Cached Map Name Display 27 Row 14", romx[$7460], bank[$27]
MapNameCache_DrawRow14::
    ld a, [wMapNameCacheIndex]
    inc a
    lb bc, 4, 14
    ld d, 2
    call DrawNumberFixedWidth
    lb bc, 7, 14
    farcall MapName9_DrawCache

    ds 2, 0
    assert @ == $7475
