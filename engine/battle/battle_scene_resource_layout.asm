include "constants/battle_scene_resource_constants.inc"

; Bank $31 lookup helper used by the active-overlay scheduler.
; wBattleSceneLayoutUnitType selects a UnitData-type pointer from the table at $41EA.
; Each pointed record contains 10 two-byte entries for side 0 followed by the
; corresponding 10 entries for side 1. wBattleSceneSlotScanIndex selects the
; physical slot and BC receives the selected two-byte record. shows the current
; Bank $14 scheduling path preserves this pair into HL but does not consume it before return;
; keep the pair structural until another caller gives it a behavior-backed meaning.

section "Battle Scene Resource Layout Lookup", romx[$41bf], bank[$31]
BattleScene_GetUnitTypeLayoutEntry::
    ld a, [$c4b0]
    add a, a
    ld bc, $0000
    ld c, a
    ld hl, $41ea
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ld a, [$c4ad]
    cp $00
    jr z, $41dc
    ld bc, $0014
    add hl, bc
    ld a, [$c4b6]
    add a, a
    ld bc, $0000
    ld c, a
    add hl, bc
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ret
BattleSceneUnitLayoutPointerTable::
    db $52, $42, $52, $42, $7a, $42, $a2, $42, $ca, $42
    ldh a, [c]
    ld b, d
    ld a, [de]
    ld b, e
    ld b, d
    ld b, e
    ld l, d
    ld b, e
    sub d
    ld b, e
    cp d
    ld b, e
    ldh [c], a
    ld b, e
    ld a, [bc]
    ld b, h
    ld [hld], a
    ld b, h
    ld e, d
    ld b, h
    add a, d
    ld b, h
    xor d
    ld b, h
    jp nc, $fa44
    ld b, h
    ld [hli], a
    ld b, l
    ld c, d
    ld b, l
    ld [hl], d
    ld b, l
    sbc a, d
    ld b, l
    jp nz, $ea45
    ld b, l
    ld [de], a
    ld b, [hl]
    ld a, [hld]
    ld b, [hl]
    ld h, d
    ld b, [hl]
    adc a, d
    ld b, [hl]
    or d
    ld b, [hl]
    jp c, $0246
    ld b, a
    ld a, [hli]
    ld b, a
    ld d, d
    ld b, a
    ld a, d
    ld b, a
    and d
    ld b, a
    jp z, $f247
    ld b, a
    ld a, [de]
    ld c, b
    ld b, d
    ld c, b
    ld l, d
    ld c, b
    sub d
    ld c, b
    cp d
    ld c, b
    ldh [c], a
    ld c, b
    ld a, [bc]
    ld c, c
    ld [hld], a
    ld c, c
    ld e, d
    ld c, c
    add a, d
    ld c, c
    xor d
    ld c, c
    jp nc, $fa49
    ld c, c
    ld [hli], a
    ld c, d
BattleSceneLayout_Infantry::
    jr z, $42a4
    ld b, b
    ld d, b
    jr nz, $42b8
    jr c, $42ba
    jr z, $42cc
    ld b, b
    ld [hl], b
    jr nz, $41e0
    jr c, $41e2
    jr z, $41f4
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_MissileInfantry::
    jr z, $42cc
    ld b, b
    ld d, b
    jr nz, $42e0
    jr c, $42e2
    jr z, $42f4
    ld b, b
    ld [hl], b
    jr nz, $4208
    jr c, $420a
    jr z, $421c
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_MercenaryInfantry::
    jr z, $42f8
    ld b, b
    ld d, h
    jr nz, $430c
    jr c, $430e
    jr z, $4320
    ld b, b
    ld [hl], h
    jr nz, $4234
    jr c, $4236
    jr z, $4248
    ld b, b
    sub h
    adc a, b
    ld d, h
    ld [hl], b
    ld d, h
    sub b
    ld h, h
    ld a, b
    ld h, h
    adc a, b
    ld [hl], h
    ld [hl], b
    ld [hl], h
    sub b
    add a, h
    ld a, b
    add a, h
    adc a, b
    sub h
    ld [hl], b
    sub h
BattleSceneLayout_ConstructionTruck::
    jr z, $431c
    ld b, b
    ld d, b
    jr nz, $4330
    jr c, $4332
    jr z, $4344
    ld b, b
    ld [hl], b
    jr nz, $4258
    jr c, $425a
    jr z, $426c
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_SupplyTruck::
    jr z, $4344
    ld b, b
    ld d, b
    jr nz, $4358
    jr c, $435a
    jr z, $436c
    ld b, b
    ld [hl], b
    jr nz, $4280
    jr c, $4282
    jr z, $4294
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_SupplyTruckS::
    jr z, $436c
    ld b, b
    ld d, b
    jr nz, $4380
    jr c, $4382
    jr z, $4394
    ld b, b
    ld [hl], b
    jr nz, $42a8
    jr c, $42aa
    jr z, $42bc
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_TransportTruck::
    jr z, $4394
    ld b, b
    ld d, b
    jr nz, $43a8
    jr c, $43aa
    jr z, $43bc
    ld b, b
    ld [hl], b
    jr nz, $42d0
    jr c, $42d2
    jr z, $42e4
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_TransportTruckS::
    jr z, $43bc
    ld b, b
    ld d, b
    jr nz, $43d0
    jr c, $43d2
    jr z, $43e4
    ld b, b
    ld [hl], b
    jr nz, $42f8
    jr c, $42fa
    jr z, $430c
    ld b, b
    sub b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld h, b
    ld a, b
    ld h, b
    adc a, b
    ld [hl], b
    ld [hl], b
    ld [hl], b
    sub b
    add a, b
    ld a, b
    add a, b
    adc a, b
    sub b
    ld [hl], b
    sub b
BattleSceneLayout_CombatBuggy::
    jr z, $43e0
    ld b, b
    ld c, h
    jr nz, $43f4
    jr c, $43f6
    jr z, $4408
    ld b, b
    ld l, h
    jr nz, $441c
    jr c, $441e
    jr z, $4330
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_CombatBuggyS::
    jr z, $4408
    ld b, b
    ld c, h
    jr nz, $441c
    jr c, $441e
    jr z, $4430
    ld b, b
    ld l, h
    jr nz, $4444
    jr c, $4446
    jr z, $4358
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_CombatVehicle::
    jr z, $4430
    ld b, b
    ld c, h
    jr nz, $4444
    jr c, $4446
    jr z, $4458
    ld b, b
    ld l, h
    jr nz, $446c
    jr c, $446e
    jr z, $4380
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_CombatVehicleS::
    jr z, $4458
    ld b, b
    ld c, h
    jr nz, $446c
    jr c, $446e
    jr z, $4480
    ld b, b
    ld l, h
    jr nz, $4494
    jr c, $4496
    jr z, $43a8
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_Apc::
    jr z, $4480
    ld b, b
    ld c, h
    jr nz, $4494
    jr c, $4496
    jr z, $44a8
    ld b, b
    ld l, h
    jr nz, $44bc
    jr c, $44be
    jr z, $43d0
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_ApcS::
    jr z, $44a8
    ld b, b
    ld c, h
    jr nz, $44bc
    jr c, $44be
    jr z, $44d0
    ld b, b
    ld l, h
    jr nz, $44e4
    jr c, $44e6
    jr z, $43f8
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_RocketLauncher::
    jr z, $44d0
    ld b, b
    ld c, h
    jr nz, $44e4
    jr c, $44e6
    jr z, $44f8
    ld b, b
    ld l, h
    jr nz, $450c
    jr c, $450e
    jr z, $4420
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_RocketLauncherS::
    jr z, $44f8
    ld b, b
    ld c, h
    jr nz, $450c
    jr c, $450e
    jr z, $4520
    ld b, b
    ld l, h
    jr nz, $4534
    jr c, $4536
    jr z, $4448
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_AntiAirTank::
    jr z, $4520
    ld b, b
    ld c, h
    jr nz, $4534
    jr c, $4536
    jr z, $4548
    ld b, b
    ld l, h
    jr nz, $455c
    jr c, $455e
    jr z, $4470
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_MercenaryAntiAirMissiles::
    jr z, $4548
    ld b, b
    ld c, h
    jr nz, $455c
    jr c, $455e
    jr z, $4570
    ld b, b
    ld l, h
    jr nz, $4584
    jr c, $4586
    jr z, $4498
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_AntiAirMissiles::
    jr z, $4570
    ld b, b
    ld c, h
    jr nz, $4584
    jr c, $4586
    jr z, $4598
    ld b, b
    ld l, h
    jr nz, $45ac
    jr c, $45ae
    jr z, $44c0
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_AntiAirMissilesS::
    jr z, $4598
    ld b, b
    ld c, h
    jr nz, $45ac
    jr c, $45ae
    jr z, $45c0
    ld b, b
    ld l, h
    jr nz, $45d4
    jr c, $45d6
    jr z, $44e8
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_Artillery::
    jr z, $45c0
    ld b, b
    ld c, h
    jr nz, $45d4
    jr c, $45d6
    jr z, $45e8
    ld b, b
    ld l, h
    jr nz, $45fc
    jr c, $45fe
    jr z, $4510
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_ArtilleryS::
    jr z, $45e8
    ld b, b
    ld c, h
    jr nz, $45fc
    jr c, $45fe
    jr z, $4610
    ld b, b
    ld l, h
    jr nz, $4624
    jr c, $4626
    jr z, $4538
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_Ifv::
    jr z, $4610
    ld b, b
    ld c, h
    jr nz, $4624
    jr c, $4626
    jr z, $4638
    ld b, b
    ld l, h
    jr nz, $464c
    jr c, $464e
    jr z, $4560
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_IfvS::
    jr z, $4638
    ld b, b
    ld c, h
    jr nz, $464c
    jr c, $464e
    jr z, $4660
    ld b, b
    ld l, h
    jr nz, $4674
    jr c, $4676
    jr z, $4588
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_TankDestroyer::
    jr z, $4660
    ld b, b
    ld c, h
    jr nz, $4674
    jr c, $4676
    jr z, $4688
    ld b, b
    ld l, h
    jr nz, $469c
    jr c, $469e
    jr z, $45b0
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_TankDestroyerS::
    jr z, $4688
    ld b, b
    ld c, h
    jr nz, $469c
    jr c, $469e
    jr z, $46b0
    ld b, b
    ld l, h
    jr nz, $46c4
    jr c, $46c6
    jr z, $45d8
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_Tank::
    jr z, $46b0
    ld b, b
    ld c, h
    jr nz, $46c4
    jr c, $46c6
    jr z, $46d8
    ld b, b
    ld l, h
    jr nz, $46ec
    jr c, $46ee
    jr z, $4600
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_MercenaryTank::
    jr z, $46d8
    ld b, b
    ld c, h
    jr nz, $46ec
    jr c, $46ee
    jr z, $4700
    ld b, b
    ld l, h
    jr nz, $4714
    jr c, $4716
    jr z, $4628
    ld b, b
    adc a, h
    adc a, b
    ld c, h
    ld [hl], b
    ld c, h
    sub b
    ld e, h
    ld a, b
    ld e, h
    adc a, b
    ld l, h
    ld [hl], b
    ld l, h
    sub b
    ld a, h
    ld a, b
    ld a, h
    adc a, b
    adc a, h
    ld [hl], b
    adc a, h
BattleSceneLayout_FighterPlaneA::
    jr z, $46ec
    ld b, b
    jr c, $46d7
    ld c, b
    jr c, $4702
    jr z, $4714
    ld b, b
    ld e, b
    jr nz, $4728
    jr c, $472a
    jr z, $473c
    ld b, b
    ld a, b
    adc a, b
    jr c, $4739
    jr c, $465b
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_FighterPlaneB::
    jr z, $4714
    ld b, b
    jr c, $46ff
    ld c, b
    jr c, $472a
    jr z, $473c
    ld b, b
    ld e, b
    jr nz, $4750
    jr c, $4752
    jr z, $4764
    ld b, b
    ld a, b
    adc a, b
    jr c, $4761
    jr c, $4683
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_FighterPlaneS::
    jr z, $473c
    ld b, b
    jr c, $4727
    ld c, b
    jr c, $4752
    jr z, $4764
    ld b, b
    ld e, b
    jr nz, $4778
    jr c, $477a
    jr z, $478c
    ld b, b
    ld a, b
    adc a, b
    jr c, $4789
    jr c, $46ab
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_AttackPlaneA::
    jr z, $4764
    ld b, b
    jr c, $474f
    ld c, b
    jr c, $477a
    jr z, $478c
    ld b, b
    ld e, b
    jr nz, $47a0
    jr c, $47a2
    jr z, $47b4
    ld b, b
    ld a, b
    adc a, b
    jr c, $47b1
    jr c, $46d3
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_AttackPlaneB::
    jr z, $478c
    ld b, b
    jr c, $4777
    ld c, b
    jr c, $47a2
    jr z, $47b4
    ld b, b
    ld e, b
    jr nz, $47c8
    jr c, $47ca
    jr z, $47dc
    ld b, b
    ld a, b
    adc a, b
    jr c, $47d9
    jr c, $46fb
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_AttackPlaneS::
    jr z, $47b4
    ld b, b
    jr c, $479f
    ld c, b
    jr c, $47ca
    jr z, $47dc
    ld b, b
    ld e, b
    jr nz, $47f0
    jr c, $47f2
    jr z, $4804
    ld b, b
    ld a, b
    adc a, b
    jr c, $4801
    jr c, $4723
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_Bomber::
    jr nz, $47ec
    jr c, $47ee
    jr z, $47e0
    ld b, b
    jr c, $47cb
    ld c, b
    jr c, $47f6
    jr z, $47e8
    ld b, b
    jr c, $47d3
    ld c, b
    jr c, $47fe
    adc a, b
    ld c, b
    ld [hl], b
    ld c, b
    sub b
    jr c, $4835
    jr c, $4747
    ld c, b
    ld [hl], b
    ld c, b
    sub b
    jr c, $483d
    jr c, $474f
    ld c, b
    ld [hl], b
    ld c, b
BattleSceneLayout_MercenaryBomber::
    jr nz, $481c
    jr c, $481e
    jr z, $4810
    ld b, b
    ld b, b
    jr nz, $4824
    jr c, $4826
    jr z, $4818
    ld b, b
    ld b, b
    jr nz, $482c
    jr c, $482e
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld b, b
    ld a, b
    ld b, b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
    sub b
    ld b, b
    ld a, b
    ld b, b
    adc a, b
    ld d, b
    ld [hl], b
    ld d, b
BattleSceneLayout_TransportPlane::
    jr nz, $483c
    jr c, $483e
    jr z, $4830
    ld b, b
    jr c, $481b
    ld c, b
    jr c, $4846
    jr z, $4838
    ld b, b
    jr c, $4823
    ld c, b
    jr c, $484e
    adc a, b
    ld c, b
    ld [hl], b
    ld c, b
    sub b
    jr c, $4885
    jr c, $4797
    ld c, b
    ld [hl], b
    ld c, b
    sub b
    jr c, $488d
    jr c, $479f
    ld c, b
    ld [hl], b
    ld c, b
BattleSceneLayout_RefuelingPlane::
    jr nz, $4864
    jr c, $4866
    jr z, $4858
    ld b, b
    jr c, $4843
    ld c, b
    jr c, $486e
    jr z, $4860
    ld b, b
    jr c, $484b
    ld c, b
    jr c, $4876
    adc a, b
    ld c, b
    ld [hl], b
    ld c, b
    sub b
    jr c, $48ad
    jr c, $47bf
    ld c, b
    ld [hl], b
    ld c, b
    sub b
    jr c, $48b5
    jr c, $47c7
    ld c, b
    ld [hl], b
    ld c, b
BattleSceneLayout_BattleHelicopter::
    jr z, $487c
    ld b, b
    jr c, $4867
    ld c, b
    jr c, $4892
    jr z, $48a4
    ld b, b
    ld e, b
    jr nz, $48b8
    jr c, $48ba
    jr z, $48cc
    ld b, b
    ld a, b
    adc a, b
    jr c, $48c9
    jr c, $47eb
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_BattleHelicopterS::
    jr z, $48a4
    ld b, b
    jr c, $488f
    ld c, b
    jr c, $48ba
    jr z, $48cc
    ld b, b
    ld e, b
    jr nz, $48e0
    jr c, $48e2
    jr z, $48f4
    ld b, b
    ld a, b
    adc a, b
    jr c, $48f1
    jr c, $4813
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_AntiSubHelicopter::
    jr z, $48cc
    ld b, b
    jr c, $48b7
    ld c, b
    jr c, $48e2
    jr z, $48f4
    ld b, b
    ld e, b
    jr nz, $4908
    jr c, $490a
    jr z, $491c
    ld b, b
    ld a, b
    adc a, b
    jr c, $4919
    jr c, $483b
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_TransportHelicopter::
    jr z, $48f4
    ld b, b
    jr c, $48df
    ld c, b
    jr c, $490a
    jr z, $491c
    ld b, b
    ld e, b
    jr nz, $4930
    jr c, $4932
    jr z, $4944
    ld b, b
    ld a, b
    adc a, b
    jr c, $4941
    jr c, $4863
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_TransportHelicopterS::
    jr z, $491c
    ld b, b
    jr c, $4907
    ld c, b
    jr c, $4932
    jr z, $4944
    ld b, b
    ld e, b
    jr nz, $4958
    jr c, $495a
    jr z, $496c
    ld b, b
    ld a, b
    adc a, b
    jr c, $4969
    jr c, $488b
    ld c, b
    ld a, b
    ld c, b
    adc a, b
    ld e, b
    ld [hl], b
    ld e, b
    sub b
    ld l, b
    ld a, b
    ld l, b
    adc a, b
    ld a, b
    ld [hl], b
    ld a, b
BattleSceneLayout_AegisWarship::
    jr nz, $4974
    jr c, $4986
    jr $4988
    db $30, $68, $20, $68, $38, $78, $18, $78, $30
    ld l, b
    jr nz, $4984
    jr c, $4996
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_MercenaryMissileFrigate::
    jr nz, $499c
    jr c, $49ae
    jr $49b0
    db $30, $68, $20, $68, $38, $78, $18, $78, $30
    ld l, b
    jr nz, $49ac
    jr c, $49be
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_LargeCarrier::
    jr nz, $49c4
    jr c, $49d6
    jr $49d8
    db $30, $68, $20, $68, $38, $78, $18, $78, $30
    ld l, b
    jr nz, $49d4
    jr c, $49e6
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_SmallCarrier::
    jr nz, $49ec
    jr c, $49fe
    jr $4a00
    jr nc, $49f2
    jr nz, $49f4
    jr c, $4a06
    jr $4a08
    db $30, $68, $20, $68, $38, $78
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_TransportShip::
    jr nz, $4a14
    jr c, $4a26
    jr $4a28
    jr nc, $4a1a
    jr nz, $4a1c
    jr c, $4a2e
    jr $4a30
    db $30, $68, $20, $68, $38, $78
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_SupplyTanker::
    jr nz, $4a3c
    jr c, $4a4e
    jr $4a50
    jr nc, $4a42
    jr nz, $4a44
    jr c, $4a56
    jr $4a58
    db $30, $68, $20, $68, $38, $78
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_Submarine::
    jr nz, $4a64
    jr c, $4a76
    jr $4a78
    jr nc, $4a6a
    jr nz, $4a6c
    jr c, $4a7e
    jr $4a80
    jr nc, $4a72
    jr nz, $4a74
    jr c, $4a86
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
BattleSceneLayout_SubmarineS::
    jr nz, $4a8c
    jr c, $4a9e
    jr $4aa0
    jr nc, $4a92
    jr nz, $4a94
    jr c, $4aa6
    jr $4aa8
    jr nc, $4a9a
    jr nz, $4a9c
    jr c, $4aae
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    sbc a, b
    ld a, b
    add a, b
    ld l, b
    sub b
    ld l, b
    ld a, b
    ld a, b
    assert @ == $4a4a
