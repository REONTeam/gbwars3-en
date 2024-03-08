include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_unit.inc"

setcharmap unit
section "Terrain_Name_Strings", romx[$599c], bank[$0c]
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
    dw Terrain_Name_Strings_comTower

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

section fragment "Terrain_Name_Strings_Fragment", romx[bank0c_end_addrA], bank[$0c]
Terrain_Name_Strings_comTower:
    ;text "ツウシントウ"
    text "COM TOWER"
    done