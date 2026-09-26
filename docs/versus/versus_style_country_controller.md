# Versus style/country controller

Bank $18 contains the Versus style/country selection frontend. The controller at
$5E65 is followed by two cursor-position helpers and the complete country-selection
screen setup at $5F0B-$6030. The screen setup clears and initializes the common UI,
loads the country-selection graphics, draws labels/windows/options, creates the
selection sprite, positions the country cursor, and then renders the country-conflict
message.

The conflict-message runtime at $6044-$6074 clears the message rectangle in VRAM
bank 0, selects the left/right country warning string from the current country state,
and prints it into the framed region.

These ranges were previously represented as executable `db` byte streams. They are
now mnemonic RGBDS source and rebuild byte-for-byte against the Japanese retail ROM.
The existing custom-English text resources at $6031-$6043 and $6075+ retain their
separate ownership.
