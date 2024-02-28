macro sym
    if \1 == 0
        section "\3", rom0[\2]
    else
        section "\3", romx[\2], bank[\1]
    endc
\3::
endm

; Writes data into VRAM, while keeping in mind whether the LCD is on or not
; a = data, hl = address
    sym $00, $0f1c, Vram_Put

; Writes data during vblank or hblank
; a = data, hl = address
    sym $00, $0f2d, Vram_PutWaitBlank

; Places text at a specific coordinate in the tilemap
; b = x coord, c = y coord, hl = text location
    sym $00, $3353, TextPut

; Farcall
; Operates on the three bytes following the "rst $28": bank, addr lo, addr hi
    sym $00, $3b06, Farcall
    sym $00, $3b46, Farcall_Jump

; Draws a single tile with attributes at $dc6d and increments the address
; a = tile, b = attributes, hl = address
    sym $10, $6acf, NameInput_PlaceTile

; Clears a horizontal line in the name confirmation dialog
    sym $10, $6a80, NameInput_ConfirmDialog_Horiz

; Fill an area in the tilemap with a tile
; a = tile, b = x coord, c = y coord, d = width, e = height
    sym $15, $6ad3, Gfx_TilemapFill
