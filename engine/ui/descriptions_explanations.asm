include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main

; The retail words at $5884/$5891/$589E are immediate operands in the
; description runtime, not independent pointer-table records.
DEF Gas_Explanation_Pointer EQU $5884
DEF Initiative_Explanation_Pointer EQU $5891
DEF Promotion_Explanation_Pointer EQU $589e

section "Gas_Explanation", romx[$7b6b], bank[$32]
Gas_Explanation::
    text "さいだいねんりょうは"
    line "そのユニットがもつことができる"
    line "さいだいのねんりょうすうを"
    line "あらわしています。"
    skip 1
    line "りく•うみユニットは"
    line "ねんりょうがなくなると"
    line "うごけなくなります。"
    line "また,そらユニットのばあいは"
    line "ついらくしてしまいます。"
    skip 1
    line "りく•うみユニットは"
    line "いどうしないかぎり"
    line "ねんりょうをしょうひしません。"
    skip 1
    line "そらユニットのばあいは"
    line "いどうしないばあいでも"
    line "たいくうしていることから"
    line "いっていのねんりょうを"
    line "1にちごとにしょうひします。"
    skip 1
    line "1HEXにしょうひするねんりょうは"
    line "いどうロスひょうにひょうじしてある"
    line "すうちになります。"
    skip 1
    line "いどうロスが"
    line "いどうりょくをうわまわると"
    line "いどうできません。"
    done

section "Initiative_Explanation", romx[$7c93], bank[$32]
Initiative_Explanation::
    text "イニシアティブとは"
    line "そのユニットがもつ"
    line "こうげきゆうせんちです。"
    skip 1
    line "このこうげきゆうせんちが"
    line "たたかうあいてよりも"
    line "おおきいすうじのばあい"
    line "せんせいこうげきできます。"
    skip 1
    line "イニシアティブは"
    line "いどうするごとに"
    line "しょうひするので"
    line "ちょうきょりをいどうするユニットは"
    line "ちゅういがひつようです。"
    done

section "Promotion_Explanation", romx[$7d22], bank[$32]
Promotion_Explanation::
    text "しんかは"
    line "ユニットがけいけんちをためて"
    line "ちがうユニットにへんかする"
    line "こうどうです。"
    skip 1
    line "けいけんちは"
    line "せんとうやせんりょうなど"
    line "MAPでのユニットのこうどうで"
    line "ためることができます。"
    skip 1
    line "Sランクにたっすると"
    line "つぎのMAPのはいちまえに"
    line "ユニットをしんかできます。"
    skip 1
    line "また,しんかした"
    line "ユニットのけいけんちは"
    line "ふたたびDランクにもどります。"
    skip 1
    line "しんかは"
    line "キャンペーンモードのみです。"
    line "しんかできるユニットと"
    line "できないユニットがあります。"
    done
