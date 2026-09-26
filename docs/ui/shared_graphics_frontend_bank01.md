# Shared graphics frontend (Bank $01)

Bank `$01:$4000-$4117` is the shared VRAM graphics frontend used by gameplay and menu/status screens. The range is source-owned as one continuous family and reconstructs Japanese retail bytes exactly.

`SharedGraphics_LoadMainFontBG` at `$4000` selects VRAM bank 0 and restores the main `Image_Charmap` payload into both BG character regions at `$9000` and `$8800`. It is the lightweight font restore used across menus, result/briefing presentation, title/attract UI, and battle-related screens.

`MapGraphics_LoadGameplayAssets` at `$401C` is the established map/gameplay loader. It stages the main gameplay character/symbol ranges into VRAM bank 0, copies map terrain tiles, then selects VRAM bank 1 for the map-unit icon set.

`MapGraphics_LoadGameplayAssetsAndFontBG` at `$40CE` layers the gameplay set with three additional BG-font mirrors. Its independent Bank `$25` consumer is the Unit Status/reference UI path.

`SharedGraphics_LoadMenuFontTiles` at `$40FC` loads the compact menu/text blocks at `$8600` and `$8D00`. Editor warnings, unit-creation UI, retry dialogs, and related lower-panel text screens call this entry symbolically.

The exclusive end is `$4118`, where `Image_Charmap` data resumes. The verifier locks the complete 280-byte `$4000-$4117` range and the four public entry addresses.
