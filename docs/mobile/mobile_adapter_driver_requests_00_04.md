# Mobile Adapter driver request cluster $4115-$43AA

the project owns the first handler cluster reached by the Bank $30 request table. The numeric request IDs remain canonical because the project proves state/register behavior, not yet the user-facing protocol command names.

- `$4115` request `$00`: interprets the driver event/status state and returns an `A/HL` result through the fixed-bank epilogue.
- `$4225/$4230`: local event/state setters for `$21/$20`, with the `$21` path setting Mobile Adapter status bit 1.
- `$4234`: internal request-table entry `$40`; one-byte `NOP` followed by fall-through to request `$02`.
- `$4235` request `$02`: initialization/setup. It clears exactly `$0452` bytes at `$D000-$D451`, preserves caller arguments in the driver workspace, prepares the request channel, and enters the shared continuation.
- `$4290` request `$04`: builds a five-byte descriptor at `$D080+`, prepares request state, copies/advances a bounded payload, and enters the downstream engine.
- `$432B` internal request `$38`: related descriptor/payload setup using the same downstream engine.
- `$4392`: preserves IE while setting bits 2 and 3, enabling Timer and Serial interrupts.
- `$4399`: scans a zero-terminated string/byte sequence and validates the observed length against `C`.

The exact retail span is 662 bytes and is independently reconstructed by `tools/verify_mobile_adapter_driver_requests_00_04.py`.
