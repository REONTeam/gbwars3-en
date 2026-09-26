# Map AI direct-attack planner support (the project)

Bank `$0D:$4BE1-$4E52` is the support layer called directly from the project direct-attack planners. It sits between the capture-target-mask builder ending at `$4BE0` and the procurement planner beginning at `$4E53`.

Direct calls prove six stable public boundaries: `$4BE1/$4BE5` shared candidate preparation, `$4C4F/$4CCA` family-0 target/approach selection, and `$4D3A/$4D99` family-1 target/approach selection. The callers treat `B = $FF` as a no-candidate result and feed successful coordinates into the already-source-owned movement-cost field and direct-attack action staging.

The deeper ranking formula and temporary scratch meanings remain byte-row exact in the project. Names describe caller-visible contracts only; they do not assert an unsupported tactical policy.
