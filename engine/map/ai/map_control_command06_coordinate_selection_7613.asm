include "macros/macros.inc"

; selected-map command $06 coordinate-selection executor.
; The only Bank-$0B caller is the command-controller branch at $72B6.
; Ownership stops at $762B, which is independently called from $0B:$4033.

section "Selected Map Command 06 Coordinate Selection", romx[$7613], bank[$0b]

MapControl_ExecuteSelectedMapCommandMap::
MapControl_ExecuteSelectedMapCommand06CoordinateSelection:: ; compatibility alias
    call MapTerrainAnimation_Reset
    call MapCursor_Destroy
    call Sprite_Update
    call FadeToWhite8
    call MapRuntime_RunCoordinateSelectionController
    cp $ff
    jp z, .done
    call MapViewport_CenterOnCoordinates
.done
    ret

    assert @ == $762b
