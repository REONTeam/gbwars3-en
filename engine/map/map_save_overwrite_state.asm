include "macros/macros.inc"

; Reset the three transient bytes used before the overwrite/save confirmation flow.
section "Map Save Overwrite State Reset", romx[$712c], bank[$15]
MapSave_ResetOverwritePromptState::
    xor a
    ld [$ccd4], a
    ld [$ccd5], a
    ld [$ccd9], a
    ret

    assert @ == $7137
