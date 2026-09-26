include "macros/macros.inc"

; Fixed battle-scene staging descriptor presets consumed by the Bank $14
; resource controller. Each entry writes the 11-byte side-specific descriptor
; later copied into the advanced-sprite staging area. Keep individual field
; meanings structural until the downstream behavior record is fully named.
section "Battle Scene Resource Descriptor Presets", romx[$4000], bank[$18]
BattleScene_StageFamily0Side0Descriptor::
    ld a, $04
    ld [$db31], a
    xor a
    ld [$db32], a
    ld [$db33], a
    ld [$db34], a
    ld [$db35], a
    ld [$db36], a
    xor a
    ld [$db37], a
    ld a, $05
    ld [$db38], a
    ld a, $4b
    ld [$db39], a
    ld a, $22
    ld [$db3a], a
    ld a, $18
    ld [$db3b], a
    ret

    assert @ == $402e

BattleScene_StageFamily0Side1Descriptor::
    ld a, $fc
    ld [$db3e], a
    xor a
    ld [$db3f], a
    ld [$db40], a
    ld [$db41], a
    ld [$db42], a
    ld [$db43], a
    xor a
    ld [$db44], a
    ld a, $05
    ld [$db45], a
    ld a, $4b
    ld [$db46], a
    ld a, $b6
    ld [$db47], a
    ld a, $18
    ld [$db48], a
    ret

    assert @ == $405c

BattleScene_StagePhase1Side0Descriptor::
    ld a, $03
    ld [$db31], a
    ld a, $00
    ld [$db32], a
    ld a, $fd
    ld [$db33], a
    ld a, $00
    ld [$db34], a
    xor a
    ld [$db35], a
    ld [$db36], a
    xor a
    ld [$db37], a
    ld a, $03
    ld [$db38], a
    ld a, $4c
    ld [$db39], a
    ld a, $1a
    ld [$db3a], a
    ld a, $18
    ld [$db3b], a
    ret

    assert @ == $4090

BattleScene_StageFamily1Side0Descriptor::
    ld a, $03
    ld [$db31], a
    ld a, $00
    ld [$db32], a
    ld a, $fd
    ld [$db33], a
    ld a, $00
    ld [$db34], a
    xor a
    ld [$db35], a
    ld [$db36], a
    xor a
    ld [$db37], a
    ld a, $02
    ld [$db38], a
    ld a, $4c
    ld [$db39], a
    ld a, $ec
    ld [$db3a], a
    ld a, $18
    ld [$db3b], a
    ret

    assert @ == $40c4

BattleScene_StageFamily1Side1Descriptor::
    ld a, $fd
    ld [$db3e], a
    ld a, $00
    ld [$db3f], a
    ld a, $fd
    ld [$db40], a
    ld a, $00
    ld [$db41], a
    xor a
    ld [$db42], a
    ld [$db43], a
    xor a
    ld [$db44], a
    ld a, $02
    ld [$db45], a
    ld a, $4e
    ld [$db46], a
    ld a, $1c
    ld [$db47], a
    ld a, $18
    ld [$db48], a
    ret

    assert @ == $40f8

BattleScene_StageFamily2Side0Descriptor::
    ld a, $03
    ld [$db31], a
    ld a, $00
    ld [$db32], a
    ld a, $fd
    ld [$db33], a
    ld a, $00
    ld [$db34], a
    xor a
    ld [$db35], a
    ld [$db36], a
    xor a
    ld [$db37], a
    ld a, $05
    ld [$db38], a
    ld a, $4d
    ld [$db39], a
    ld a, $82
    ld [$db3a], a
    ld a, $18
    ld [$db3b], a
    ret

    assert @ == $412c

BattleScene_StageFamily2Side1Descriptor::
    ld a, $fd
    ld [$db3e], a
    ld a, $00
    ld [$db3f], a
    ld a, $fd
    ld [$db40], a
    ld a, $00
    ld [$db41], a
    xor a
    ld [$db42], a
    ld [$db43], a
    xor a
    ld [$db44], a
    ld a, $05
    ld [$db45], a
    ld a, $4e
    ld [$db46], a
    ld a, $b2
    ld [$db47], a
    ld a, $18
    ld [$db48], a
    ret

    assert @ == $4160

BattleScene_StagePhase2Side0Descriptor::
    ld a, $03
    ld [$db31], a
    ld a, $00
    ld [$db32], a
    ld a, $03
    ld [$db33], a
    ld a, $00
    ld [$db34], a
    xor a
    ld [$db35], a
    ld [$db36], a
    xor a
    ld [$db37], a
    ld a, $07
    ld [$db38], a
    ld a, $50
    ld [$db39], a
    ld a, $93
    ld [$db3a], a
    ld a, $18
    ld [$db3b], a
    ret

    assert @ == $4194

BattleScene_StagePhase1Side1Descriptor::
    ld a, $fd
    ld [$db3e], a
    ld a, $00
    ld [$db3f], a
    ld a, $fd
    ld [$db40], a
    ld a, $00
    ld [$db41], a
    xor a
    ld [$db42], a
    ld [$db43], a
    xor a
    ld [$db44], a
    ld a, $03
    ld [$db45], a
    ld a, $4f
    ld [$db46], a
    ld a, $f9
    ld [$db47], a
    ld a, $18
    ld [$db48], a
    ret

    assert @ == $41c8

BattleScene_StagePhase2Side1Descriptor::
    ld a, $fd
    ld [$db3e], a
    ld a, $00
    ld [$db3f], a
    ld a, $03
    ld [$db40], a
    ld a, $00
    ld [$db41], a
    xor a
    ld [$db42], a
    ld [$db43], a
    xor a
    ld [$db44], a
    ld a, $07
    ld [$db45], a
    ld a, $51
    ld [$db46], a
    ld a, $25
    ld [$db47], a
    ld a, $18
    ld [$db48], a
    ret

    assert @ == $41fc
