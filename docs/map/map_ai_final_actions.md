# Map AI final action identities (the project)

the project closes the remaining map-AI action-table ambiguity. The seven-entry dispatcher at Bank `$0D:$4426` is now behavior-backed as:

| ID | Canonical action | Proof source |
|---:|---|---|
| 0 | `MapAI_ActionMove` | Producer paths stage a movement coordinate and the handler performs no action-specific state mutation beyond the shared dispatcher movement/presentation flow. |
| 1 | `MapAI_ActionCaptureProperty` | Bank `$0B:$648C` capture executor and Campaign captured-property counter. |
| 2 | `MapAI_ActionDevelopTerrain` | Bank `$0B:$489C` development executor and developed-property counter. |
| 3 | `MapAI_ActionDirectAttack` | Producer stages a target live-unit index; Bank `$0D:$471D` passes acting/target IDs into Bank `$0C:$43CF`, which builds and executes the normal unit-vs-unit battle pipeline. |
| 4 | `MapAI_ActionBuildBridge` | Bank `$0D:$6183` selects a Construction Truck with at least two weapon-1 charges, routes it toward `wMapControlRouteRiverX/Y`, and emits action 4 only when adjacent. Bank `$0B:$4BF2` consumes two charges and replaces the River base terrain with `BRIDGE_1`. |
| 5 | `MapAI_ActionAreaAttack` | Bank `$0C:$504F` selected-hex plus six-neighbor attack runtime. |
| 6 | `MapAI_ActionLoadIntoCarrier` | Bank `$0B:$5D84-$5E1D` carrier compatibility and load/embark executor. |

## Newly source-owned ranges

- Bank `$0D:$6183-$6324` — bridge/direct-attack producer/planner family, 418 bytes, SHA-1 `44b3b5a151a5f74d884d623ae3d7a0ddf16f17e9`.
- Bank `$0D:$469F-$46B6` — bridge-action staging, 24 bytes, SHA-1 `4eaed8b50ad3d2939787a583f8feb4fe8c30c777`.
- Bank `$0D:$471D-$4748` — direct-attack staging, 44 bytes, SHA-1 `3e5887adf16bfb7b599359d270ab7decf1c6728b`.
- Bank `$0B:$4BF2-$4C17` — bridge-construction executor, 38 bytes, SHA-1 `2d8dc123de5e1736ba436b85f35d2df877c36833`.
- Bank `$0C:$43CF-$4487` — direct unit-attack executor, 185 bytes, SHA-1 `07f1e438ac02855c23475a824cfa6079f8c7e6f5`.

These five tranches total **708 retail bytes**. `tools/verify_map_ai_final_actions.py` ROM-locks each range and checks the complete seven-way action table plus the decisive bridge/direct-attack producer evidence.

The deeper target-ranking helpers used by the two attack-planner families remain deliberately positional. Their exact strategic policy names should be promoted only after the adjacent `$0D:$4Cxx-$4Exx/$63xx-$65xx` selectors and their caller modes are sourced.
