# Map AI tactical planning driver (the project)

Bank `$0D:$4000-$4105` is the execution driver immediately before `MapAI_TacticalPolicySelector` at `$4106`.

The range contains two mirrored 50-unit sweeps. The first begins at `$4000` and calls its worker at `$4033`; the second begins at `$4097` and calls its worker at `$40C6`. `$4097` is fixed by instruction framing: both sweeps begin with the exact `FA A2 C9` encoding (`ld a,[$C9A2]`). Treating `$4099` as an entry would split that three-byte instruction.

Worker A directly calls `$4106` at `$404F`, independently proving the corrected target-priority-selector entry. Both workers feed the already source-owned `$4321` scheduler and `$4407` seven-way action dispatcher. Their higher-level strategic distinction remains positional (`SweepA`/`SweepB`) until the differing gate predicates are themselves behavior-classified.
