# Campaign introduction full Bank $34 relocation

the project completes the migration that the regression suite prepared.

The supplied historical custom-English archive contains a built `GBWARS3.gbc`
with SHA-1 `2fd5074878763dbd00e6514f3856a6a466b999e9`.  The map briefing viewer is
physically in Bank `$25`; its group-0 pointer table begins at `$25:$405A`.
Entry 0 is `$4F3A`, so the first Campaign pre-map message is read from
`$33:$4F3A`.

That stream is 129 bytes including its `$00` terminator, SHA-1
`4fc4e5a0161d0b4fbc019ea9b8d8e19a555fa2e1`.

## Historical English-build finding

The custom `GBWARS3.gbc` differs from the Japanese retail ROM overall, but this
specific 129-byte Campaign introduction stream is byte-identical between the
two.  The original English project's README also lists both "Import the
remaining text" and "Split the Campaign Mode briefings from bank[$33] into
bank[$33] and bank[$34]" as unfinished work.  Therefore there was no missing
translated Campaign-introduction payload to recover: this introduction was
never translated in that historical build.

## New layout

The exact stream now lives at:

- `$34:$4000` — `CampaignIntroductionBank34Payload`

For Campaign briefing group 0 / map index 0, `CampaignBriefing_ReadByte`
installs that Bank `$34` pointer on the first byte and reads the entire message
from Bank `$34`.  Other Campaign briefings/results remain in Bank `$33`.

The current payload consumes 129 bytes, leaving **16,255 bytes** available for
expansion in the same bank.  The old Bank `$33:$4F3A` bytes remain untouched in
the preserved overlay but are no longer used by this message.

## Source representation

The relocated payload is intentionally emitted as byte-exact `db` data.  The
historical project used a modified glyph sheet and retained original encoded
briefing bytes; representing those bytes as guessed English characters would
change behavior.  Once the introduction is translated/rewritten, the raw
payload can be converted to higher-level text macros using the translation
font's proven encoding.

`tools/recover_campaign_intro_bank34.py` now follows the correct contract:
`$25:$405A` supplies a pointer into Bank `$33`, and the recovered stream is
written directly to Bank `$34` source.


## the project English payload

The Bank `$34` owner is no longer a byte-for-byte copy of the Japanese stream. the project intentionally replaces it with editable English `text`/`line` source. The current payload is 551 bytes including line controls and terminator, leaving 15,833 bytes before `$8000`. Rows are limited to 18 characters and use the viewer's normal eight-row pagination. The historical `$33:$4F3A` 129-byte stream remains documented as the project relocation source, but it is not the active text.


## the project capacity update

Bank `$34:$7EF0-$7FFF` is now permanently reserved for the generalized Campaign relocation directory. The active English introduction is therefore guarded against `$7EF0`, not `$8000`. Its current 551-byte size leaves 15,561 contiguous bytes before the directory.
