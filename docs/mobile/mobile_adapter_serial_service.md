# Mobile Adapter serial interrupt service (the project)

the project owns physical Bank `$30:$56CC-$58E3` (**536 retail bytes**), beginning at the fixed-bank Mobile serial-service ABI target and ending exactly before the independently exported LCD/timer-service entry at `$58E4`.

`MobileAdapter_DriverSerialInterrupt` is the per-byte interrupt-side transport core. It repeatedly reads `rSB` (`$FF01`), advances shared packet/receive state under `$D000+`, recognizes established response-form command values (including `$92/$95/$9F/$A3/$A8`), and funnels completion/error paths through a common service epilogue at `$58C2`. The source remains byte-exact while the individual packet-state fields are still being typed.

The receive-phase dispatcher at `$57EE` is behavior-backed as a four-way state machine keyed by `$D00B`. Two later branches call the existing Bank `$30:$566B` receive-buffer helper with the current `rSB` byte; `$58C8` additionally advances the pointer/counter state before returning. These relationships establish a real byte-receive/framing layer without requiring speculative names for every `$D0xx` field.

The next clean source boundary is `$58E4`, the exported LCD/timer service already reached by the fixed-bank API. That routine should be sourced next together with its timer/serial coordination helpers, after which the now-complete interrupt core can be used to strengthen any still-numeric SDK request semantics only where producer/consumer behavior agrees.
