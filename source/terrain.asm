include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_unit.inc"

setcharmap unit
section "Property_Name_Strings", romx[$599c], bank[$0c]
Property_Name_Strings:
    dw .headquarters
    dw .headquarters
    dw .city
    dw .cityRuins
    dw .factory
    dw .factoryRuins
    dw .airport
    dw .airportRuins
    dw .airportTemporary
    dw .port
    dw .portRuins
    dw Property_Name_Strings_comTower

.headquarters
    ;text "シュト"
    text "HQ"
    done

.city
    ;text "トシ"
    text "CITY"
    done

.cityRuins
    ;text "ホウカイトシ"
    text "CITY R"
    done

.factory
    ;text "コウジョウ"
    text "BASE"
    done

.factoryRuins
    ;text "ホウカイコウジョウ"
    text "BASE R"
    done

.airport
    ;text "クウコウ"
    text "AIRPORT"
    done

.airportRuins
    ;text "ホウカイクウコウ"
    text "AIRPORT R"
    done

.airportTemporary
    ;text "カンイクウコウ"
    text "RUNWAY"
    done

.port
    ;text "ミナト"
    text "PORT"
    done

.portRuins
    ;text "ホウカイミナト"
    text "PORT R"
    done

    section_end $59fb

section fragment "Property_Name_Strings_Fragment", romx[bank0c_end_addrA], bank[$0c]
Property_Name_Strings_comTower:
    ;text "ツウシントウ"
    text "COM TOWER"
    done

section fragment "Terrain_Name_Strings", romx[$4f90], bank[$0f]
Terrain_Name_Strings:
    dw .headquarters
    dw .headquarters
    dw .city
    dw .cityRuins
    dw .factory
    dw .factoryRuins
    dw .airport
    dw .airportRuins
    dw .airportTemporary
    dw .port
    dw .portRuins
    dw .comTower
    dw .plain
    dw .road
    dw .bridge1
    dw .bridge2
    dw Terrain_Name_Strings_mountain
    dw Terrain_Name_Strings_wood
    dw Terrain_Name_Strings_wasteland
    dw Terrain_Name_Strings_desert
    dw Terrain_Name_Strings_river
    dw Terrain_Name_Strings_sea
    dw Terrain_Name_Strings_shoal
    
; 9 Character limit, could potentially modify the two menus that display terrain names to free up 4 more characters.
; Alternatively, if each name is padded out to 13 characters, then they'll clear the extra 4 tiles when drawn.
.headquarters:
    ;text "シュト"
    text "HQ"
    done

.city:
    ;text "トシ"
    text "CITY"
    done

.cityRuins:
    ;text "ホウカイトシ"
    text "CITY R" ; City Ruins
    done

.factory:
    ;text "コウジョウ"
    text "BASE"
    done

.factoryRuins:
    ;text "ホウカイコウジョウ"
    text "BASE R" ; Base Ruins
    done

.airport:
    ;text "クウコウ"
    text "AIRPORT"
    done

.airportRuins:
    ;text "ホウカイクウコウ"
    text "AIRPORT R" ; Airport Ruins
    done

.airportTemporary:
    ;text "カンイクウコウ"
    text "RUNWAY" ; Temp Airport
    done

.port:
    ;text "ミナト"
    text "PORT"
    done

.portRuins:
    ;text "ホウカイミナト"
    text "PORT R"
    done

.comTower:
    ;text "ツウシントウ"
    text "COM TOWER"
    done

.plain:
    ;text "ヘイチ"
    text "PLAIN"
    done

.road:
    ;text "ドウロ"
    text "ROAD"
    done

.bridge1:
    ;text "ハシ"
    text "BRIDGE"
    done

.bridge2:
    ;text "ハシ"
    text "BRIDGE"
    done

    section_end $502b

section fragment "Terrain_Name_Strings_Fragment", romx[bank0f_end_addr], bank[$0f]
Terrain_Name_Strings_mountain:
    ;text "ヤマ"
    text "MOUNTAIN"
    done

Terrain_Name_Strings_wood:
    ;text "モリ"
    text "WOOD"
    done

Terrain_Name_Strings_wasteland:
    ;text "アレチ"
    text "WASTELAND"
    done

Terrain_Name_Strings_desert:
    ;text "サバク"
    text "DESERT"
    done

Terrain_Name_Strings_river:
    ;text "カワ"
    text "RIVER"
    done

Terrain_Name_Strings_sea:
    ;text "ウミ"
    text "SEA"
    done

Terrain_Name_Strings_shoal:
    ;text "アサセ"
    text "SHOAL"
    done
