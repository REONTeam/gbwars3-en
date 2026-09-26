# Map-control late-phase resolution / refresh helper contract

the project sources the exact helper entry ranges reached by `MapControl_TriggerLatePhaseResolution` and `MapControl_RefreshPhaseState`. The names describe proven call roles rather than claiming an unproven player-facing event identity.

The late-phase resolution branch now names its four farcall destinations: a Bank $0B scene/effect refresh helper, the Bank $27 phase-result dispatcher, a Bank $11 Campaign-statistics increment wrapper, and a Bank $0B map-state reinitializer.

The phase-refresh path now also owns the exact Bank $0D helper entries at $58A2, $59D4, $5A86, and $5D9C. Their internal scratch fields remain conservatively unnamed until the surrounding $58F2-$5D9B family is source-backed.

No English/custom text, graphics, briefing relocation, or map records are changed.
