# Unit Reference navigation and detail runtime

The Bank `$25` Unit Reference path is source-backed from its shared frontend into the type chooser, main detail renderer, and detail controller. The custom-English strings remain owned by the existing Unit Status source sections; this runtime owns only the proven retail code/data ranges around them.

## Source-owned ranges

- `$5E7B-$5F35` — detail-field helpers (maximum fuel, weapon summary/name, base focus, focus loss, movement power).
- `$5F36-$60D7` — shared scroll-arrow creation, input/sprite service, frame/divider drawing, and common Unit Reference screen setup.
- `$60D8-$60F8` — existing custom-English `UnitStatus_Header` resource; deliberately remains a separate owner.
- `$60F9-$62D5` — internal 13-row unit-type chooser and scrolling/navigation controller.
- `$62D6+` — existing Unit Status menu/resources remain separate owners.
- `$638A-$66FD` — detail-value renderer, weapon/ammo value helpers, compact inline text/control resources, load/promotion availability staging, and first/last-unit arrow visibility.
- `$66FE-$6706` — existing custom-English Unit Status availability strings remain separate owners.
- `$6707-$6ACF` — detail cursor/graphic setup, main `$6831` detail controller, unit-to-unit navigation, submenu dispatch, submenu scroll-arrow synchronization, and common cost/header setup.
- `$6AD0+` — existing Unit Status cost strings and deeper subpages remain separate owners.

The two bytes at `$6388-$6389` remain deliberately unclaimed. They are immediately before the detail-value renderer but currently have no proven entry point or resource consumer.

## Type chooser

`UnitReference_ChooseType` at `$61B9` displays 13 unit names at a time over the one-based unit-type domain. The chooser stores a scroll offset plus a cursor row and returns the selected type as `offset + row + 1`. The final viewport begins at offset `$26`; the last selectable type is `$33`.

The chooser supports single-row up/down movement, page movement, A confirmation, and B cancellation. Scroll-arrow visibility is synchronized against the current viewport rather than hard-coded by callers.

## Main detail controller

`UnitReference_RunDetailController` at `$6831` receives the selected unit type in `A`, temporarily selects WRAM bank 3, builds the detail page, and drives its ten-entry cursor. Left/right move between adjacent unit types while respecting the `$01..$33` domain. B reconstructs the chooser scroll/cursor state before returning `$FF` to the frontend, allowing chooser-mode callers to return to the same selected type.

`UnitReference_DrawDetailValues` at `$6503` populates the main page from UnitData/WeaponData. It renders movement and fuel values, weapon names/ammunition/value pairs, caches load capacity and promotion availability for submenu dispatch, and hides only the previous/next arrow that would cross the first/last unit boundary.

The submenu selector at `$68A1` dispatches ten detail categories through nine controller routines because the two weapon entries share one controller. Those controller loops are now source-owned, and the movement page beneath `$6F83` is source-owned through its renderer/data/selection layer. The still-separate page-renderer work begins with the connected `$7061-$731C` region and later setup families; see `docs/unit/unit_reference_submenus.md`.

## Verification

`make check-unit-reference-navigation-detail` verifies five retail-exact ranges totaling 2,935 bytes, public entry addresses, symbolic frontend integration, the preserved string/resource boundaries, and the unchanged custom-English ROM SHA-256.
