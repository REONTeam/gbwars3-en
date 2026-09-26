include "macros/macros.inc"

; Fan out the per-subsystem resets performed whenever the title flow returns to
; the top-level mode selector.
section "Main Mode Subsystem Reset", romx[$64d1], bank[$15]
Main_ResetModeSubsystemState::
    farcall UnitReference_ResetWorkState
    farcall Versus_ResetSetupSelectionState
    farcall MapSave_ResetCategorySelection
    farcall Options_ResetState
    farcall MapMenu_ResetRuntimeState
    farcall Versus_ResetMapSelectionState
    farcall BattleSceneBank31Runtime_50FA
    farcall MapSave_ResetOverwritePromptState
    farcall Bank26_ResetRuntimeState
    ret

    assert @ == $64f6

section "Map Save Post Overwrite Flow", romx[$7137], bank[$15]
MapSave_PostOverwriteFlow::
    xor a
    ld [$ccd7], a
.retry_selection
    call MapSelection_Run
    cp $ff
    jr z, .cancel
.retry_map
    farcall MapRuntime_PrepareSelectedMap
    cp $ff
    jr z, .retry_selection
    farcall MapEconomy_RecalculateIncome
    farcall MapStatus_Run
    cp $ff
    jr z, .retry_map
    xor a
.cancel
    ret

    assert @ == $7158
