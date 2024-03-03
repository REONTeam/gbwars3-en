include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "Medal_Header_String", romx[$5f8d], bank[$14]
    ;text "くんしょう"
    text "MEDAL"
    done

section "Medal_Strings", romx[$5b42], bank[$14]
Medal_Strings:
    dw .graduation_name
    dw .master_name
    dw .campaign_clear_name
    dw .campaign_special_name
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
    dw .graduation_description
    dw .master_description
    dw .campaign_clear_description
    dw .campaign_special_description
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

.graduation_name:
    text "「ソツギョウキショウ」"
    done

.master_name:
    text "「マスターウォーズ キショウ」"
    done

.campaign_clear_name:
    text "「メイヨ センショウショウ」"
    done

.campaign_special_name:
    text "「トクベツ シュクンショウ」"
    done

.s_clear_name:
    text "「Sエンド シュクンショウ」"
    done

.a_clear_name:
    text "「Aエンド カントウショウ」"
    done

.b_clear_name:
    text "「Bエンド カントウショウ」"
    done

.c_clear_name:
    text "「Cエンド カントウショウ」"
    done

.d_clear_name:
    text "「Dエンド ドリョクショウ」"
    done

.b_unarmored_name:
    text "「シャリョウ クンショウB」"
    done

.a_unarmored_name:
    text "「シャリョウ クンショウA」"
    done

.b_armored_name:
    text "「センシャ クンショウB」"
    done

.a_armored_name:
    text "「センシャ クンショウA」"
    done

.b_air_name:
    text "「クウセン クンショウB」"
    done

.a_air_name:
    text "「クウセン クンショウA」"
    done

.b_sea_name:
    text "「カイセン クンショウB」"
    done

.a_sea_name:
    text "「カイセン クンショウA」"
    done

.b_capture_name:
    text "「センリョウ クンショウB」"
    done

.a_capture_name:
    text "「センリョウ クンショウA」"
    done

.b_engineer_name:
    text "「コウヘイ クンショウB」"
    done

.a_engineer_name:
    text "「コウヘイ クンショウA」"
    done

.unit_name:
    text "「オールユニット クンショウ」"
    done

.reaper_name:
    text "「シニガミ キショウ」"
    done

.engineer_special_name:
    text "「トクベツ コウヘイショウ」"
    done

.graduation_description:
    text "キクンノ ソツギョウヲ"
    line "ココニタタエル"
    done

.master_description:
    text "スベテノクリアヲ タタエル"
    done

.campaign_clear_description:
    text "ヨリイッソウノ ドリョクヲ"
    line "キタイスル"
    done

.campaign_special_description:
    text "サイタンクリアノ エイヨヲ"
    line "タタエル"
    done

.s_clear_description:
    text "Sエンディングノ エイヨヲ"
    line "タタエル"
    done

.a_clear_description:
    text "Aエンディングノ カントウヲ"
    line "タタエル"
    done

.b_clear_description:
    text "Bエンディングノ カントウヲ"
    line "タタエル"
    done

.c_clear_description:
    text "Cエンディングノ カントウヲ"
    line "タタエル"
    done

.d_clear_description:
    text "Dエンディングノ ドリョクヲ"
    line "タタエル"
    done

.b_unarmored_description:
    text "ヒソウコウブタイ 250ゲキハヲ"
    line "タタエル"
    done

.a_unarmored_description:
    text "ヒソウコウブタイ 500ゲキハヲ"
    line "タタエル"
    done

.b_armored_description:
    text "ソウコウブタイ 150ゲキハヲ"
    line "タタエル"
    done

.a_armored_description:
    text "ソウコウブタイ 300ゲキハヲ"
    line "タタエル"
    done

.b_air_description:
    text "ヒコウブタイ 100ゲキハヲ"
    line "タタエル"
    done

.a_air_description:
    text "ヒコウブタイ 200ゲキハヲ"
    line "タタエル"
    done

.b_sea_description:
    text "カンセンブタイ 100ゲキハヲ"
    line "タタエル"
    done

.a_sea_description:
    text "カンセンブタイ 200ゲキハヲ"
    line "タタエル"
    done

.b_capture_description:
    text "センリョウ200カショヲ"
    line "タタエル"
    done

.a_capture_description:
    text "センリョウ400カショヲ"
    line "タタエル"
    done

.b_engineer_description:
    text "ケンセツ 100カショヲ"
    line "タタエル"
    done

.a_engineer_description:
    text "ケンセツ 200カショヲ"
    line "タタエル"
    done

.unit_description:
    text "スベテノユニット ニュウシュヲ"
    line "タタエル"
    done

.reaper_description:
    text "キミニハ ヒトノココロガ"
    line "ナイノカ!"
    done

.engineer_special_description:
    text "コウサクシャ ミシヨウノ"
    line "ユウキヲタタエル"
    done

.no_medal_description:
    text "  ????"
    line "      "
    done

section "Medal_Reward_Strings", romx[$64c1], bank[$15]
    ; Player Name...
    coord_text 8, 36, "に"
    ; ...Medal Name Line...
    coord_text 2, 38, "が じゅよされた!"
