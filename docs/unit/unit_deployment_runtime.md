# Unit deployment runtime

Bank `$0C:$7B89-$7D67` owns both interactive deployment controllers. Reserve Unit List deployment accepts compatible current-side properties near HQ and can be cancelled. Selected-map CALL placement cannot be cancelled after unit creation and accepts an empty cell only when the called unit's movement profile can traverse the underlying terrain.

Both controllers commit through `UnitDeployment_CommitAtCoordinates`: destination coordinates are written to the live record, the reserve flag is cleared, end-turn is set, the map overlay is written, and the shared deployment transition surrounds the map-unit refresh. This caller evidence identifies the map-popup transition pair at `$5B5B/$5B6C` as the deployment transition.
