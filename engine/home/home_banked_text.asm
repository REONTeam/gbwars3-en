
; Shared byte reader used by the Bank $25 briefing viewer.  The caller selects
; the source ROM bank before entering this ROM0 helper, so the same routine can
; consume local Beginner strings or Campaign strings in Bank $33.
section "Home Banked Text Reader", rom0[$26b7]
BankedText_ReadByteAndAdvance::
    ld a, [$c025]
    ld l, a
    ld a, [$c026]
    ld h, a
    ld a, [hli]
    ld b, a
    ld a, l
    ld [$c025], a
    ld a, h
    ld [$c026], a
    ld a, b
    ret
    assert @ == $26cb
