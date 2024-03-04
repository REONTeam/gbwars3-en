include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "Medal_Header_String", romx[$5b42], bank[$14]
    ;text "くんしょう"
    text "MEDAL" ; Seemingly unused
    done

section "Medal_code5f4a", romx[$5f4a], bank[$14]
Medal_code5f4a:
    lb bc, 2, 36
    ld a, [$cc7a]
    call $5f7a
    ld a, [$cc7a]
    add a
    ld hl, Medal_Strings
    call $29bc
    ld a, [hl+]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    lb bc, 2, 37
    call $2b38
    jr Medal_code5f74

Medal_code5f6b:
    ld hl, Medal_String_None
    lb bc, 2, 36
    call $2b38

Medal_code5f74:
    pop af
    ldh [$83], a
    ldh [$4f], a
    ret

Medal_code5f7a:
    push bc
    add a
    ld hl, $5fbd
    call $29bc
    ld a, [hl+]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    pop bc
    call $2b38
    ret

section "Medal_Strings", romx[$5f8d], bank[$14]
Medal_Strings:
    dw .graduation_description
    dw .master_description
    dw .honorary_description
    dw .special_description
    dw .s_clear_description
    dw .a_clear_description
    dw .b_clear_description
    dw .c_clear_description
    dw .d_clear_description
    dw .b_unarmored_description
    dw .a_unarmored_description
    dw .b_armored_description
    dw .a_armored_description
    dw .b_air_description
    dw .a_air_description
    dw .b_sea_description
    dw .a_sea_description
    dw .b_capture_description
    dw .a_capture_description
    dw .b_engineer_description
    dw .a_engineer_description
    dw .unit_description
    dw .reaper_description
    dw .engineer_special_description
    dw .graduation_name
    dw .master_name
    dw .honorary_name
    dw .special_name
    dw .s_clear_name
    dw .a_clear_name
    dw .b_clear_name
    dw .c_clear_name
    dw .d_clear_name
    dw .b_unarmored_name
    dw .a_unarmored_name
    dw .b_armored_name
    dw .a_armored_name
    dw .b_air_name
    dw .a_air_name
    dw .b_sea_name
    dw .a_sea_name
    dw .b_capture_name
    dw .a_capture_name
    dw .b_engineer_name
    dw .a_engineer_name
    dw .unit_name
    dw .reaper_name
    dw .engineer_special_name

.graduation_name:
    text "「ソツギョウキショウ」"
    ;text "「GRADUATE MEDAL」"
    done

.master_name:
    ;text "「マスターウォーズ キショウ」"
    text "「MASTER MEDAL」"
    done

.honorary_name:
    text "「メイヨ センショウショウ」"
    ;text "「HONORARY MEDAL」"
    done

.special_name:
    ;text "「トクベツ シュクンショウ」"
    text "「SPECIAL MEDAL」"
    done

.s_clear_name:
    text "「Sエンド シュクンショウ」"
    ;text "「S CLEAR MEDAL」"
    done

.a_clear_name:
    text "「Aエンド カントウショウ」"
    ;text "「A CLEAR AWARD」"
    done

.b_clear_name:
    text "「Bエンド カントウショウ」"
    ;text "「B CLEAR AWARD」"
    done

.c_clear_name:
    text "「Cエンド カントウショウ」"
    ;text "「C CLEAR AWARD」"
    done

.d_clear_name:
    text "「Dエンド ドリョクショウ」"
    ;text "「D CLEAR PRIZE」"
    done

.b_unarmored_name:
    text "「シャリョウ クンショウB」"
    done

.a_unarmored_name:
    text "「シャリョウ クンショウA」"
    done

.b_armored_name:
    text "「センシャ クンショウB」"
    ;text "「TANK MEDAL B」"
    done

.a_armored_name:
    text "「センシャ クンショウA」"
    ;text "「TANK MEDAL A」"
    done

.b_air_name:
    ;text "「クウセン クンショウB」"
    text "「AIR MEDAL B」"
    done

.a_air_name:
    ;text "「クウセン クンショウA」"
    text "「AIR MEDAL A」"
    done

.b_sea_name:
    ;text "「カイセン クンショウB」"
    text "「SEA MEDAL B」"
    done

.a_sea_name:
    ;text "「カイセン クンショウA」"
    text "「SEA MEDAL A」"
    done

.b_capture_name:
    ;text "「センリョウ クンショウB」"
    text "「CAPT MEDAL B」"
    done

.a_capture_name:
    ;text "「センリョウ クンショウA」"
    text "「CAPT MEDAL A」"
    done

.b_engineer_name:
    text "「コウヘイ クンショウB」"
    ;text "「BUILD MEDAL B」"
    done

.a_engineer_name:
    text "「コウヘイ クンショウA」"
    ;text "「BUILD MEDAL A」"
    done

.unit_name:
    text "「オールユニット クンショウ」"
    ;text "「ALL UNIT MEDAL」"
    done

.reaper_name:
    text "「シニガミ キショウ」"
    ;text "「REAPER MEDAL」"
    done

.engineer_special_name:
    text "「トクベツ コウヘイショウ」"
    done

.graduation_description:
    text "キクンノ ソツギョウ★"
    line "ココニタタエル"
    done

.master_description:
    text "スベテノクリア★ タタエル"
    done

.honorary_description:
    ;text "ヨリイッソウノ ドリョク★"
    ;line "キタイスル"
    text "PERSEVERE AND"
    line "WIN★" ; IMPROVE (?)
    done

.special_description:
    text "サイタンクリアノ エイヨ★"
    line "タタエル"
    done

.s_clear_description:
    text "Sエンディングノ エイヨ★"
    line "タタエル"
    done

.a_clear_description:
    text "Aエンディングノ カントウ★"
    line "タタエル"
    done

.b_clear_description:
    text "Bエンディングノ カントウ★"
    line "タタエル"
    done

.c_clear_description:
    text "Cエンディングノ カントウ★"
    line "タタエル"
    done

.d_clear_description:
    text "Dエンディングノ ドリョク★"
    line "タタエル"
    done

.b_unarmored_description:
    text "ヒソウコウブタイ 250ゲキハ★"
    line "タタエル"
    done

.a_unarmored_description:
    text "ヒソウコウブタイ 500ゲキハ★"
    line "タタエル"
    done

.b_armored_description:
    text "ソウコウブタイ 150ゲキハ★"
    line "タタエル"
    done

.a_armored_description:
    text "ソウコウブタイ 300ゲキハ★"
    line "タタエル"
    done

.b_air_description:
    text "ヒコウブタイ 100ゲキハ★"
    line "タタエル"
    done

.a_air_description:
    text "ヒコウブタイ 200ゲキハ★"
    line "タタエル"
    done

.b_sea_description:
    text "カンセンブタイ 100ゲキハ★"
    line "タタエル"
    done

.a_sea_description:
    text "カンセンブタイ 200ゲキハ★"
    line "タタエル"
    done

.b_capture_description:
    text "センリョウ200カショ★"
    line "タタエル"
    done

.a_capture_description:
    text "センリョウ400カショ★"
    line "タタエル"
    done

.b_engineer_description:
    text "ケンセツ 100カショ★"
    line "タタエル"
    done

.a_engineer_description:
    text "ケンセツ 200カショ★"
    line "タタエル"
    done

.unit_description:
    text "スベテノユニット ニュウシュ★"
    line "タタエル"
    done

.reaper_description:
    text "キミニハ ヒトノココロガ"
    line "ナイノカ!"
    done

.engineer_special_description:
    text "コウサクシャ ミシヨウノ"
    line "ユウキ★タタエル"
    done

Medal_String_None:
    text "  ????"
    line "      "
    done

    section_end $6330

section "Medal_Reward_Strings", romx[$64c1], bank[$15]
    ; Player Name...
    coord_text 8, 36, "に"
    ; ...Medal Name Line...
    coord_text 2, 38, "が じゅよされた!"
