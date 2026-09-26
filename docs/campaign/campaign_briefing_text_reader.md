# Campaign / Beginner briefing banked text reader

the project sources ROM0 `$26B7-$26CA` as `BankedText_ReadByteAndAdvance`.

The Bank `$25` map briefing viewer keeps its current text pointer in `$C025/$C026`. For Campaign groups 0, 2, and 3 it performs `farcall $33, BankedText_ReadByteAndAdvance`; the farcall selects Bank `$33`, while the routine itself remains in ROM0. Beginner group 1 calls the same ROM0 routine directly, leaving Bank `$25` selected.

The helper reads one byte from the selected ROM bank at the current pointer, advances the pointer, stores it back to `$C025/$C026`, and returns the byte in `A`. This explains the shared viewer architecture without claiming ownership of the customized English Campaign text bytes.

The three Bank `$33` Campaign pointer anchors remain non-emitting. No authoritative custom-English `$33/$34` payload exists in the project package, so Japanese retail text must not be transcribed over those locations.
