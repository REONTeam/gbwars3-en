include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "Configuration_Menu", romx[$43c3], bank[$15]
Configuration_code43c3:
    ld hl, Configuration_Description_Strings
    ld a, [$c625]
    add a
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    ld d, a
    ld a, d
    ld h, a
    ld a, e
    ld l, a
    lb bc, 3, 6
    call $2b38
    ret

Configuration_Menu_Strings:
    coord_text 3, 6,  "ACTION " ; こうどうアニメ
    coord_text 3, 8,  "BATTLE " ; せんとうアニメ
    coord_text 3, 10, "SUPPLY" ; ぜんほきゅう
    coord_text 3, 12, "YIELD   " ; ゆうせいしょうり

Configuration_Action_Animations:
    text "こうどうアニメ" ; Action
    ;text "ACTION"
    skip 1
    line "せんりょう•けんちく"   ;占領•建築補給•搭載などユニットのアニメーションを見ることができます。
    line "ほきゅう•とうさいなど"
    line "ユニットのアニメーションを"
    line "みることができます。"
    done

Configuration_Supply_Notification: ; Supply
    text "ぜんほきゅう"
    skip 1
    line "じぐんのこうげきのとき"  ; じぐんのこうげきのときほきゅう可能な建物の上にいるユニットにじどうてきにほきゅうします。
    line "ほきゅうかのうなたてものの"
    line "うえにいるユニットに"
    line "じどうてきにほきゅうします。"
    done

Configuration_Enemy_Yield: ; Yield
    text "ゆうせいしょうり"
    skip 1
    line "てきぐんが,とてもふりな" ; 敵軍が,とてもふりなじょうきょうになると降伏してきます。幸福を認めるかきょひするか選べます。
    line "じょうきょうになると"
    line "こうふくしてきます。"
    line "こうふくをみとめるか"
    line "きょひするかえらべます。"
    done

Configuration_Battle_Animations: ; Battle
    text "せんとうアニメ"
    skip 1
    line "せんとうアニメーションを" ; せんとうアニメーションを見ることができます。OFFにするとじょうほうだけひょうじされます。
    line "みることができます。"
    line "OFFにするとじょうほうだけ"
    line "ひょうじされます。"
    done

Configuration_Description_Strings:
    dw Configuration_Action_Animations
    dw Configuration_Battle_Animations
    dw Configuration_Supply_Notification
    dw Configuration_Enemy_Yield
