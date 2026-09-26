# Late music banks $3E/$3F

Banks `$3E` and `$3F` reuse the same sourced music-driver core through `$580A`; those duplicate executable bytes are assembled from `audio/driver_copies/music_driver_bank3e.asm` and `music_driver_bank3f.asm`.

Track/channel streams beginning at `$580B` are semantic RGBDS music source under `audio/music/bank3e/` and `audio/music/bank3f/`. No `.music`, `.dat`, or `.sound` blob is required for these banks.
