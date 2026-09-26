# Map AI repair / resupply routing

the project resolves the two previously numeric Bank `$0C` service-target builders used by the project post-procurement action runtime.

`MapAI_BuildRepairPropertyOffsets` at `$0C:$6F9A` builds a zero-terminated list in `$C949+` of side-relative property IDs appropriate to the selected unit. Ordinary ground units accept HQ/City/Base, Construction Truck and Supply Truck variants omit City, aircraft accept Airport only, and sea/submarine units accept Port. This exactly mirrors the already-sourced `Unit_CanRepairAtCurrentTerrain` contract.

`MapAI_BuildResupplyPropertyOffsets` at `$0C:$7022` is the adjacent mirror. Its only domain-level difference is the aircraft case: Airport **and Runway** are emitted. This matches `Unit_CanResupplyAtCurrentTerrain` and proves the project tertiary routing branch is a resupply/recovery path rather than a generic map-class search.

The same source tranche also owns `MapAI_ClearServiceTargetList`, `MapAI_BuildCompatibleCarrierTypeList`, and `MapAI_BuildResupplyProviderTypeList`. The latter scans unit types Supply Truck through Supply Tanker with `Unit_CanReceiveSupplyFrom`, appending only compatible suppliers; units whose carried-class contract is class 3 additionally admit the Large/Small Carrier pair.

the project therefore promotes compatibility aliases `MapAI_TryRepairRecoveryAction` and `MapAI_TryResupplyRecoveryAction` over the older Secondary/Tertiary names. Their exact player-facing order/animation semantics remain separate from the routing identity.
