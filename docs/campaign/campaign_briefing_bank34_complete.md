# Campaign briefing Bank $34 extension

All 136 Campaign briefing pointer entries now have Bank $34 relocation targets: 45 Result-B messages, 46 Pre-map entries (including the extra pointer-table entry), and 45 Result-A messages.

The existing English replacements for the opening maps are retained. Every other relocation target is a byte-identical copy of its historical Japanese Bank $33 stream. This completes the relocation coverage without requiring the remaining Campaign text to be translated first.

The Japanese copies occupy one contiguous Bank $34 section from `$45E4` through `$779E`; the relocation directory remains fixed at `$7EF0-$7FFF`. This leaves `$751` bytes (1,873 bytes) of unallocated Bank $34 space between the current payload and the directory for text growth. The original Bank $33 streams remain authoritative historical source and fallback data.

The runtime reader continues to support a zero relocation entry as a Bank $33 fallback, although the current directory contains no zero Campaign entries.
