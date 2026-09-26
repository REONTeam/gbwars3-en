# Map Editor interaction and placement runtime

Bank `$0F` now source-owns the editor interaction/placement core at `$4170-$4463`, the placement-preview/menu-selector block at `$4490-$4599`, and the menu-label renderer at `$45AA-$45BC`.

The main controller initializes the map editor presentation, updates the shared map interaction state, applies terrain/unit placements, handles cursor movement and paint-while-moving behavior, enters coordinate selection, and dispatches the eight editor menu handlers through the pointer table at `$4280-$428F`.

Terrain placement validates any occupying unit's movement compatibility, updates the raw-tile histogram, rejects a new property/building when the active map already has 100 such tiles, and prevents duplicate raw HQ classes `$01/$0C`. Unit placement validates terrain compatibility, treats selected unit ID zero as deletion, and maintains the two `wUnitCountBySide` counters with a retail limit of 50 per side.

The custom-English warning text at `$4464-$448F` remains owned by `engine/map/map_editor.asm`. The warning presenter selects the building-limit or unit-limit first line plus the shared second line, preserving the existing localization unchanged.

The adjacent preview helper alternates between the selected placement and the real map cell at 10-frame intervals. The menu selector uses the existing eight cursor coordinates and `EditorMenu_Strings`; its handler targets remain structural until each handler family is sourced independently.

Focused verification: `make check-map-editor-interaction-runtime`.
