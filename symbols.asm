macro sym
    if \1 == 0
        section "\3", rom0[\2]
    else
        section "\3", romx[\2], bank[\1]
    endc
\3:
endm

; Writes data during vblank or hblank
; hl = address, a = data
    sym $00, $0f2d, Vram_Write
