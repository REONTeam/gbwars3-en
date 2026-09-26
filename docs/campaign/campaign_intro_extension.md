# Campaign briefing Bank $34 extension

`data/campaign/campaign_intro_extension.asm` is the authoritative source for the complete Campaign briefing extension in Bank $34.

It contains all 136 relocated Campaign message slots:

- 45 Result-B entries;
- 46 pre-map/introduction entries;
- 45 Result-A entries.

The opening custom messages remain editable English source. Every other Campaign message is represented directly in the same file as an explicitly labeled, byte-identical copy of its historical Japanese Bank $33 stream. These Japanese definitions are intentionally left untranslated so each entry can be translated independently later without changing the relocation system.

The relocation directory at `$34:$7EF0-$7FFF` points directly to labels in this file. Bank $34 message data must remain below `$7EF0`.
