macro sym
    if \2 < $4000 && \1 == 0
        section "\3", rom0[\2]
    elif \2 < $8000
        section "\3", romx[\2], bank[\1]
    elif \2 < $a000
        section "\3", vram[\2], bank[\1]
    elif \2 < $c000
        section "\3", sram[\2], bank[\1]
    elif \2 < $d000 && \1 == 0
        section "\3", wram0[\2]
    elif \2 < $e000
        section "\3", wramx[\2], bank[\1]
    else
        section "\3", hram[\2]
    endc
\3::
endm

; Gets absolute location in the VRAM tilemap (At least, I think)
; b = x coord, c = y coord
; hl = result
    sym $00, $0ed4, Vram_TilemapCoord

; Writes data into VRAM, while keeping in mind whether the LCD is on or not
; a = data, hl = address
    sym $00, $0f1c, Vram_Put

; Writes data during vblank or hblank
; a = data, hl = address
    sym $00, $0f2d, Vram_PutWaitBlank

; Places text at a specific coordinate in the tilemap inmediately
; This function interprets newlines in the main charmap
; b = x coord, c = y coord, hl = text location
    sym $00, $2b38, TextPrint

; Places text at a specific coordinate in the tilemap
; Uses the VBlank FIFO to delay blitting until vblank
; b = x coord, c = y coord, hl = text location
    sym $00, $3353, TextPut

; Places text at a coordinate embedded in the data, using the coord_text macro
; Uses the VBlank FIFO to delay blitting until vblank
; hl = data location
    sym $00, $336e, CoordTextPut

; Writes a byte to the VBlank FIFO, to be later picked up during VBlank
; This function waits until there's enough space available
; a = byte to write
    sym $00, $34d8, VBlankFIFO_Write

; Copies b bytes from hl into de in vram
; b = count, de = destination, hl = source
    sym $00, $350f, VBlankFIFO_Queue

; Processes the next command in the VBlank FIFO
    sym $00, $3537, VBlankFIFO_Process

; Calls function in a different bank
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

; 256 fifo buffer
    sym $00, $c300, wVBlankFIFO

; Head and tail pointers for the VBlank FIFO
    sym $00, $ffc8, hVBlankFIFO_Head
    sym $00, $ffc9, hVBlankFIFO_Tail
    sym $00, $ffca, hVBlankFIFO_Count  ; Amount of commands in the fifo
    sym $00, $ffcb, hVBlankFIFO_Bank  ; Bank to copy data to
