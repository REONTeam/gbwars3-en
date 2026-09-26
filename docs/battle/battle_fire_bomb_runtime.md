# FIRE target selection and BOMB availability

Bank `$0C:$418F-$43CE` owns the map-side target-selection frontend for the
`FIRE` action and the availability predicate for `BOMB`.

## FIRE

`UnitAction_RunFireTargetSelection` receives the acting unit and its origin
coordinates, then drives the interactive target list used by the Unit Action
executor. The controller:

- cycles the prebuilt target-unit list in WRAM;
- pans the map cursor to each candidate and refreshes the map-unit overlay;
- rejects targets for which `Battle_SelectUsableWeaponAttack` cannot select a
  currently usable weapon at the staged distance;
- can enter Unit Status or the battle-information preview and return to the
  same candidate;
- stages the candidate HP/fuel overlay and the predicted first combat step;
- colors the cursor from the staged attacker/defender Focus comparison; and
- returns the selected live-unit ID, or `$FF` when the action is cancelled.

The Unit Action FIRE executor now calls this entry symbolically.

## BOMB

`UnitAction_CheckBombAvailable` proves the former numeric action `$1A` is the
`BOMB` action. Availability requires weapon-slot-0 ammunition and one of four
base unit types:

- Bomber;
- Mercenary Bomber;
- Mercenary Missile Frigate; or
- Submarine-S.

Those are the same four unit types handled by the separately source-backed BOMB
target-selection/execution path. The Unit Action menu therefore exposes this
predicate as `UnitActionMenu_AppendBombIfAvailable`; the old numeric label is
retained only as a compatibility alias.
