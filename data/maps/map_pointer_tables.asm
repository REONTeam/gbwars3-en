include "macros/macros.inc"

; Bank $28 map-record far-pointer tables.
; Each entry is one bank byte followed by one little-endian ROMX address.

macro map_record_pointer
    db \1
    dw \2
endm

section "Map Record Pointer Tables", romx[$41dc], bank[$28]
MapRecordPointers_Standard::
MapRecordPointer_Standard00:
    map_record_pointer bank(MapRecord_Standard00), MapRecord_Standard00
MapRecordPointer_Standard01:
    map_record_pointer bank(MapRecord_Standard01), MapRecord_Standard01
MapRecordPointer_Standard02:
    map_record_pointer bank(MapRecord_Standard02), MapRecord_Standard02
MapRecordPointer_Standard03:
    map_record_pointer bank(MapRecord_Standard03), MapRecord_Standard03
MapRecordPointer_Standard04:
    map_record_pointer bank(MapRecord_Standard04), MapRecord_Standard04
MapRecordPointer_Standard05:
    map_record_pointer bank(MapRecord_Standard05), MapRecord_Standard05
MapRecordPointer_Standard06:
    map_record_pointer bank(MapRecord_Standard06), MapRecord_Standard06
MapRecordPointer_Standard07:
    map_record_pointer bank(MapRecord_Standard07), MapRecord_Standard07
MapRecordPointer_Standard08:
    map_record_pointer bank(MapRecord_Standard08), MapRecord_Standard08
MapRecordPointer_Standard09:
    map_record_pointer bank(MapRecord_Standard09), MapRecord_Standard09
MapRecordPointer_Standard10:
    map_record_pointer bank(MapRecord_Standard10), MapRecord_Standard10
MapRecordPointer_Standard11:
    map_record_pointer bank(MapRecord_Standard11), MapRecord_Standard11
MapRecordPointer_Standard12:
    map_record_pointer bank(MapRecord_Standard12), MapRecord_Standard12
MapRecordPointer_Standard13:
    map_record_pointer bank(MapRecord_Standard13), MapRecord_Standard13
MapRecordPointer_Standard14:
    map_record_pointer bank(MapRecord_Standard14), MapRecord_Standard14
MapRecordPointer_Standard15:
    map_record_pointer bank(MapRecord_Standard15), MapRecord_Standard15
MapRecordPointer_Standard16:
    map_record_pointer bank(MapRecord_Standard16), MapRecord_Standard16
MapRecordPointer_Standard17:
    map_record_pointer bank(MapRecord_Standard17), MapRecord_Standard17
MapRecordPointer_Standard18:
    map_record_pointer bank(MapRecord_Standard18), MapRecord_Standard18
MapRecordPointer_Standard19:
    map_record_pointer bank(MapRecord_Standard19), MapRecord_Standard19
MapRecordPointer_Standard20:
    map_record_pointer bank(MapRecord_Standard20), MapRecord_Standard20
MapRecordPointer_Standard21:
    map_record_pointer bank(MapRecord_Standard21), MapRecord_Standard21
MapRecordPointer_Standard22:
    map_record_pointer bank(MapRecord_Standard22), MapRecord_Standard22
MapRecordPointer_Standard23:
    map_record_pointer bank(MapRecord_Standard23), MapRecord_Standard23
MapRecordPointer_Standard24:
    map_record_pointer bank(MapRecord_Standard24), MapRecord_Standard24
MapRecordPointer_Standard25:
    map_record_pointer bank(MapRecord_Standard25), MapRecord_Standard25
MapRecordPointer_Standard26:
    map_record_pointer bank(MapRecord_Standard26), MapRecord_Standard26
MapRecordPointer_Standard27:
    map_record_pointer bank(MapRecord_Standard27), MapRecord_Standard27
MapRecordPointer_Standard28:
    map_record_pointer bank(MapRecord_Standard28), MapRecord_Standard28
MapRecordPointer_Standard29:
    map_record_pointer bank(MapRecord_Standard29), MapRecord_Standard29
MapRecordPointer_Standard30:
    map_record_pointer bank(MapRecord_Standard30), MapRecord_Standard30
MapRecordPointer_Standard31:
    map_record_pointer bank(MapRecord_Standard31), MapRecord_Standard31
MapRecordPointer_Standard32:
    map_record_pointer bank(MapRecord_Standard32), MapRecord_Standard32
MapRecordPointer_Standard33:
    map_record_pointer bank(MapRecord_Standard33), MapRecord_Standard33
MapRecordPointer_Standard34:
    map_record_pointer bank(MapRecord_Standard34), MapRecord_Standard34
MapRecordPointer_Standard35:
    map_record_pointer bank(MapRecord_Standard35), MapRecord_Standard35
MapRecordPointer_Standard36:
    map_record_pointer bank(MapRecord_Standard36), MapRecord_Standard36
MapRecordPointer_Standard37:
    map_record_pointer bank(MapRecord_Standard37), MapRecord_Standard37
MapRecordPointer_Standard38:
    map_record_pointer bank(MapRecord_Standard38), MapRecord_Standard38
MapRecordPointer_Standard39:
    map_record_pointer bank(MapRecord_Standard39), MapRecord_Standard39
MapRecordPointer_Standard40:
    map_record_pointer bank(MapRecord_Standard40), MapRecord_Standard40
MapRecordPointer_Standard41:
    map_record_pointer bank(MapRecord_Standard41), MapRecord_Standard41
MapRecordPointer_Standard42:
    map_record_pointer bank(MapRecord_Standard42), MapRecord_Standard42
MapRecordPointer_Standard43:
    map_record_pointer bank(MapRecord_Standard43), MapRecord_Standard43
MapRecordPointer_Standard44:
    map_record_pointer bank(MapRecord_Standard44), MapRecord_Standard44
MapRecordPointer_Standard45:
    map_record_pointer bank(MapRecord_Standard45), MapRecord_Standard45
MapRecordPointer_Standard46:
    map_record_pointer bank(MapRecord_Standard46), MapRecord_Standard46
MapRecordPointer_Standard47:
    map_record_pointer bank(MapRecord_Standard47), MapRecord_Standard47
MapRecordPointer_Standard48:
    map_record_pointer bank(MapRecord_Standard48), MapRecord_Standard48
MapRecordPointer_Standard49:
    map_record_pointer bank(MapRecord_Standard49), MapRecord_Standard49
MapRecordPointer_Standard50:
    map_record_pointer bank(MapRecord_Standard50), MapRecord_Standard50
MapRecordPointer_Standard51:
    map_record_pointer bank(MapRecord_Standard51), MapRecord_Standard51
MapRecordPointer_Standard52:
    map_record_pointer bank(MapRecord_Standard52), MapRecord_Standard52
MapRecordPointer_Standard53:
    map_record_pointer bank(MapRecord_Standard53), MapRecord_Standard53
MapRecordPointer_Standard54:
    map_record_pointer bank(MapRecord_Standard54), MapRecord_Standard54
MapRecordPointer_Standard55:
    map_record_pointer bank(MapRecord_Standard55), MapRecord_Standard55
MapRecordPointer_Standard56:
    map_record_pointer bank(MapRecord_Standard56), MapRecord_Standard56
MapRecordPointer_Standard57:
    map_record_pointer bank(MapRecord_Standard57), MapRecord_Standard57
MapRecordPointer_Standard58:
    map_record_pointer bank(MapRecord_Standard58), MapRecord_Standard58
MapRecordPointer_Standard59:
    map_record_pointer bank(MapRecord_Standard59), MapRecord_Standard59

MapRecordPointer_Demo:
    map_record_pointer bank(MapRecord_Demo02), MapRecord_Demo02

MapRecordPointers_Beginner::
MapRecordPointer_Drill01:
    map_record_pointer bank(MapRecord_Drill01), MapRecord_Drill01
MapRecordPointer_Drill02:
    map_record_pointer bank(MapRecord_Drill02), MapRecord_Drill02
MapRecordPointer_Drill03:
    map_record_pointer bank(MapRecord_Drill03), MapRecord_Drill03
MapRecordPointer_Drill04:
    map_record_pointer bank(MapRecord_Drill04), MapRecord_Drill04
MapRecordPointer_Drill05:
    map_record_pointer bank(MapRecord_Drill05), MapRecord_Drill05
MapRecordPointer_Drill06:
    map_record_pointer bank(MapRecord_Drill06), MapRecord_Drill06
MapRecordPointer_Drill07:
    map_record_pointer bank(MapRecord_Drill07), MapRecord_Drill07
MapRecordPointer_Drill08:
    map_record_pointer bank(MapRecord_Drill08), MapRecord_Drill08
MapRecordPointer_Drill09:
    map_record_pointer bank(MapRecord_Drill09), MapRecord_Drill09
MapRecordPointer_Drill10:
    map_record_pointer bank(MapRecord_Drill10), MapRecord_Drill10
MapRecordPointer_Drill11:
    map_record_pointer bank(MapRecord_Drill11), MapRecord_Drill11
MapRecordPointer_Drill12:
    map_record_pointer bank(MapRecord_Drill12), MapRecord_Drill12
MapRecordPointer_Drill13:
    map_record_pointer bank(MapRecord_Drill13), MapRecord_Drill13
MapRecordPointer_Drill14:
    map_record_pointer bank(MapRecord_Drill14), MapRecord_Drill14
MapRecordPointer_Drill15:
    map_record_pointer bank(MapRecord_Drill15), MapRecord_Drill15
MapRecordPointer_Drill16:
    map_record_pointer bank(MapRecord_Drill16), MapRecord_Drill16

MapRecordPointers_Campaign::
MapRecordPointer_Campaign00:
    map_record_pointer bank(MapRecord_Campaign00), MapRecord_Campaign00
MapRecordPointer_Campaign01:
    map_record_pointer bank(MapRecord_Campaign01), MapRecord_Campaign01
MapRecordPointer_Campaign02:
    map_record_pointer bank(MapRecord_Campaign02), MapRecord_Campaign02
MapRecordPointer_Campaign03:
    map_record_pointer bank(MapRecord_Campaign03), MapRecord_Campaign03
MapRecordPointer_Campaign04:
    map_record_pointer bank(MapRecord_Campaign04), MapRecord_Campaign04
MapRecordPointer_Campaign05:
    map_record_pointer bank(MapRecord_Campaign05), MapRecord_Campaign05
MapRecordPointer_Campaign06:
    map_record_pointer bank(MapRecord_Campaign06), MapRecord_Campaign06
MapRecordPointer_Campaign07:
    map_record_pointer bank(MapRecord_Campaign07), MapRecord_Campaign07
MapRecordPointer_Campaign08:
    map_record_pointer bank(MapRecord_Campaign08), MapRecord_Campaign08
MapRecordPointer_Campaign09:
    map_record_pointer bank(MapRecord_Campaign09), MapRecord_Campaign09
MapRecordPointer_Campaign10:
    map_record_pointer bank(MapRecord_Campaign10), MapRecord_Campaign10
MapRecordPointer_Campaign11:
    map_record_pointer bank(MapRecord_Campaign11), MapRecord_Campaign11
MapRecordPointer_Campaign12:
    map_record_pointer bank(MapRecord_Campaign12), MapRecord_Campaign12
MapRecordPointer_Campaign13:
    map_record_pointer bank(MapRecord_Campaign13), MapRecord_Campaign13
MapRecordPointer_Campaign14:
    map_record_pointer bank(MapRecord_Campaign14), MapRecord_Campaign14
MapRecordPointer_Campaign15:
    map_record_pointer bank(MapRecord_Campaign15), MapRecord_Campaign15
MapRecordPointer_Campaign16:
    map_record_pointer bank(MapRecord_Campaign16), MapRecord_Campaign16
MapRecordPointer_Campaign17:
    map_record_pointer bank(MapRecord_Campaign17), MapRecord_Campaign17
MapRecordPointer_Campaign18:
    map_record_pointer bank(MapRecord_Campaign18), MapRecord_Campaign18
MapRecordPointer_Campaign19:
    map_record_pointer bank(MapRecord_Campaign19), MapRecord_Campaign19
MapRecordPointer_Campaign20:
    map_record_pointer bank(MapRecord_Campaign20), MapRecord_Campaign20
MapRecordPointer_Campaign21:
    map_record_pointer bank(MapRecord_Campaign21), MapRecord_Campaign21
MapRecordPointer_Campaign22:
    map_record_pointer bank(MapRecord_Campaign22), MapRecord_Campaign22
MapRecordPointer_Campaign23:
    map_record_pointer bank(MapRecord_Campaign23), MapRecord_Campaign23
MapRecordPointer_Campaign24:
    map_record_pointer bank(MapRecord_Campaign24), MapRecord_Campaign24
MapRecordPointer_Campaign25:
    map_record_pointer bank(MapRecord_Campaign25), MapRecord_Campaign25
MapRecordPointer_Campaign26:
    map_record_pointer bank(MapRecord_Campaign26), MapRecord_Campaign26
MapRecordPointer_Campaign27:
    map_record_pointer bank(MapRecord_Campaign27), MapRecord_Campaign27
MapRecordPointer_Campaign28:
    map_record_pointer bank(MapRecord_Campaign28), MapRecord_Campaign28
MapRecordPointer_Campaign29:
    map_record_pointer bank(MapRecord_Campaign29), MapRecord_Campaign29
MapRecordPointer_Campaign30:
    map_record_pointer bank(MapRecord_Campaign30), MapRecord_Campaign30
MapRecordPointer_Campaign31:
    map_record_pointer bank(MapRecord_Campaign31), MapRecord_Campaign31
MapRecordPointer_Campaign32:
    map_record_pointer bank(MapRecord_Campaign32), MapRecord_Campaign32
MapRecordPointer_Campaign33:
    map_record_pointer bank(MapRecord_Campaign33), MapRecord_Campaign33
MapRecordPointer_Campaign34:
    map_record_pointer bank(MapRecord_Campaign34), MapRecord_Campaign34
MapRecordPointer_Campaign35:
    map_record_pointer bank(MapRecord_Campaign35), MapRecord_Campaign35
MapRecordPointer_Campaign36:
    map_record_pointer bank(MapRecord_Campaign36), MapRecord_Campaign36
MapRecordPointer_Campaign37:
    map_record_pointer bank(MapRecord_Campaign37), MapRecord_Campaign37
MapRecordPointer_Campaign38:
    map_record_pointer bank(MapRecord_Campaign38), MapRecord_Campaign38
MapRecordPointer_Campaign39:
    map_record_pointer bank(MapRecord_Campaign39), MapRecord_Campaign39
MapRecordPointer_Campaign40:
    map_record_pointer bank(MapRecord_Campaign40), MapRecord_Campaign40
MapRecordPointer_Campaign41:
    map_record_pointer bank(MapRecord_Campaign41), MapRecord_Campaign41
MapRecordPointer_Campaign42:
    map_record_pointer bank(MapRecord_Campaign42), MapRecord_Campaign42
MapRecordPointer_Campaign43:
    map_record_pointer bank(MapRecord_Campaign43), MapRecord_Campaign43
MapRecordPointer_Campaign44:
    map_record_pointer bank(MapRecord_Campaign44), MapRecord_Campaign44

MapRecordPointers_End:
    assert @ == $434a
