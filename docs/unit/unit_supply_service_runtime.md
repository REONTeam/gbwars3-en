# Unit SUPPLY service runtime

Bank `$0C:$6B44-$6F6F` owns the Unit Action SUPPLY availability and execution path. A unit can be serviced from compatible current-side terrain, by an adjacent supply-capable unit, or through the carried-aircraft path. The runtime stages and commits Gold/Materials costs, refills fuel and ammunition from unit definitions, applies repair HP, presents signed HP changes, and marks the serviced unit supplied for the turn.

Adjacent supplier servicing consumes one SUPPLIES stock from the first eligible adjacent supplier and awards that supplier experience equal to the receiver's current HP. The action's presentation selector runs only when that adjacent supplier path is actually consumed; direct carried-aircraft servicing pays economy costs without presenting an adjacent supplier.
