include "include/macros.inc"
include "include/bank_ends.inc"
include "include/char_main.inc"
include "include/char_unit.inc"
include "include/char_news.inc"

section "Image_Charmap", romx[$4118], bank[$01]
incbin "gfx/charmap.2bpp"

section "Image_Symbols", romx[$5120], bank[$01]
incbin "gfx/symbols.2bpp"

section "Image_Units", romx[$5898], bank[$01]
incbin "gfx/units.2bpp"

section "Attrmap_Title_Screen", romx[$5080], bank[$10]
incbin "gfx/title_screen.attrmap"

section "Image_Title_Screen", romx[$51e8], bank[$10]
incbin "gfx/title_screen.2bpp"

section "Pals_Title_Screen", romx[$6868], bank[$10]
incbin "gfx/title_screen.orig.pal"

section "Image_Action_Menu", romx[$4e88], bank[$11]
incbin "gfx/action_menu.2bpp"

section "Image_System_Messages", romx[$5e10], bank[$11]
incbin "gfx/system_messages.2bpp"

section "Image_Map_Menu", romx[$57cc], bank[$13]
incbin "gfx/map_menu.2bpp"

section "Image_Name_Screen", romx[$5708], bank[$14]
incbin "gfx/name_screen.2bpp"

section "Image_File_Select_Numbers", romx[$6341], bank[$14]
incbin "gfx/file_select_numbers.2bpp" ; Unused?

section "Image_File_Select_General", romx[$6401], bank[$14]
incbin "gfx/file_select_general.2bpp"

section "Image_File_Select_Modes", romx[$65b1], bank[$14]
incbin "gfx/file_select_modes.2bpp"

section "Image_File_Select_Medals", romx[$6b41], bank[$14]
incbin "gfx/file_select_medals.2bpp"

section "Image_File_Select_Ranks", romx[$73e1], bank[$14]
incbin "gfx/file_select_ranks.2bpp"

section "Image_Configuration", romx[$4513], bank[$15]
incbin "gfx/config.2bpp"

section "Image_VS_Menu_Type", romx[$76f2], bank[$15]
incbin "gfx/vs_menu_type.2bpp"

setcharmap main
section "18:5e5b", romx[$5e5b], bank[$18] ; VS Menu - Type Selection Header
    ;text "たいせん ほうほう"
    text " VS STYLE"
    done

section "Image_Unit_Status", romx[$7ab8], bank[$18]
incbin "gfx/unit_status.2bpp"

section "Image_Mobile_Menu", romx[$720c], bank[$19]
incbin "gfx/mobile_menu.2bpp"

setcharmap news
section "Mobile_Mail_Header", romx[$792c], bank[$19]
    ;coord_text 2, 1, "メッセージサービス"
    coord_text 2, 1, "MESSAGES "

section "Image_Charmap_News", romx[$64d4], bank[$22]
incbin "gfx/charmap_news.2bpp"

setcharmap main
section "25:48a0", romx[$48a0], bank[$25] ; Campaign Mode - Map - Win Count
    ;text "しょうりかいすう   /"
    text "WINS       /"
    done

section "27:65a0", romx[$65a0], bank[$27] ; Battle - Status Menu
    ;text "ユニット"
    text "UNIT"
    done
    ;text "せいさんユニット"
    text "DEPLOYED"
    done
    ;text "ぜんめつユニット"
    text "LOST    "
    done

section "Image_Results", romx[$65e3], bank[$27]
incbin "gfx/results.2bpp"

section "27:6c30", romx[$6c2e], bank[$27] ; File Select - Save/Mode Prompts
    ;coord_text 1, 3, "どこにセーブしますか?      "
    coord_text 1, 3, "SAVE WHERE?      "

    ;coord_text 1, 3, "ビギナーモードをあそびますか?  "
    coord_text 1, 3, "PLAY BEGINNER?   "

    ;coord_text 1, 3, "キャンペーンモードをあそびますか?"
    coord_text 1, 3, "PLAY CAMPAIGN?   "

    ;coord_text 1, 3, "スタンダードモードをあそびますか?"
    coord_text 1, 3, "PLAY STANDARD?"

section "27:6caa", romx[$6ca8], bank[$27]
    ;coord_text 6, 4, "セーブしました"
    coord_text 6, 4, "セーブしました"

section "27:75ea", romx[$75ea], bank[$27]
;db $06, $00, $18, $00, $60, $00, $80, $00, $60, $00, $18, $00, $06, $00, $00, $00, $10, $00, $20, $00, $20, $00, $70, $00, $48, $00, $8a, $00, $8c, $00, $00, $00, $80, $00, $80, $00, $80, $00, $82, $00, $82, $00, $84, $00, $78, $00, $00, $00, $00, $00, $10, $00, $1c, $00, $10, $00, $70, $00, $98, $00, $64, $00, $00, $00, $38, $00, $00, $00, $7c, $00, $82, $00, $02, $00, $04, $00, $78
db $4b, $00, $7a, $00, $4b, $00, $4a, $00, $4a, $00, $4b, $00, $00, $00, $00, $00, $b8, $00, $25, $00, $a5, $00, $25, $00, $25, $00, $b9, $00, $00, $00, $00, $00, $c9, $00, $29, $00, $29, $00, $e8, $00, $28, $00, $2d, $00, $00, $00, $00, $00, $c0, $00, $00, $00, $c0, $00, $40, $00, $40, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
section "27:7699", romx[$7699], bank[$27]
;db $7e, $81, $42, $bd, $42, $bd, $7e, $81, $42, $bd, $42, $bd, $7e, $81, $00, $ff, $7e, $81, $42, $bd, $7e, $81, $42, $bd, $7e, $81, $42, $bd, $7e, $81
db $78, $87, $44, $bb, $42, $bd, $42, $bd, $42, $bd, $44, $bb, $78, $87, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
section "27:77aa", romx[$77aa], bank[$27]
;db $20, $00, $fc, $00, $20, $00, $f8, $00, $42, $00, $42, $00, $3c, $00, $0a, $00, $40, $00, $4e, $00, $30, $00, $40, $00, $80, $00, $80, $00, $7e, $00, $00, $00, $7c, $00, $08, $00, $3c, $00, $c2, $00, $32, $00, $4a, $00, $3c
db $71, $00, $4a, $00, $72, $00, $4b, $00, $4a, $00, $72, $00, $00, $00, $00, $00, $9d, $00, $51, $00, $51, $00, $d1, $00, $51, $00, $5d, $00, $00, $00, $00, $00, $20, $00, $20, $00, $20, $00, $c0, $00, $20, $00, $20, $00, $00
section "27:78f8", romx[$78f8], bank[$27]
;db $0a, $00, $40, $00, $44, $00, $fe, $00, $44, $00, $4c, $00, $40, $00, $3e, $00, $00, $00, $10, $00, $20, $00, $20, $00, $70, $00, $48, $00, $8a, $00, $8c, $00, $00, $00, $40, $00, $fc, $00, $40, $00, $5e, $00, $80, $00, $a0, $00, $9e, $00, $00, $00, $00, $00, $84, $00, $82, $00, $82, $00, $82, $00, $a2, $00, $40, $00, $00, $00, $40, $00, $fc, $00, $40, $00, $7c, $00, $c2, $00, $02, $00, $3c, $00, $0a, $00, $10, $00, $fc, $00, $38, $00, $48, $00, $38, $00, $08, $00, $70
db $00, $00, $49, $00, $4a, $00, $4a, $00, $4a, $00, $7a, $00, $49, $00, $00, $00, $00, $00, $9c, $00, $52, $00, $52, $00, $5c, $00, $52, $00, $92, $00, $00, $00, $00, $00, $9c, $00, $92, $00, $92, $00, $92, $00, $92, $00, $dc, $00, $00, $00, $00, $00, $04, $00, $07, $00, $04, $00, $04, $00, $04, $00, $04, $00, $00, $00, $00, $00, $99, $00, $a5, $00, $a5, $00, $bd, $00, $a5, $00, $a5, $00, $00, $00, $00, $00, $c0, $00, $20, $00, $20, $00, $c0, $00, $00, $00, $00, $00, $00
