include "include/macros.inc"
include "include/char_news.inc"

setcharmap news
section "News_Menu_Service", romx[$77c2], bank[$22]
News_Menu_Message_Service:
    ;coord_text 2, 1, "メッセージサービ"
    coord_text 2, 1, "MESSAGES"
    done

section "News_Menu_Retrieve", romx[$79b5], bank[$22]
News_Menu_Message_Retrieve:
    db "このメッセージを", 0
    db "さくじょしますか?", 0

; Preloaded News
section "News_Mercenary_1", romx[$6716], bank[$31]
News_Mercenary_1: ; Badge Reward for calling 10 total Mercenaries
    news "ようへい10かいきねんバッジ"
    news " "
    news "ようへいユニットのよびだし"
    news "10かいめをきねんして"
    news "とくべつにバッジを"
    news "  こプレゼントします."
    news " "
    news "バッジはキャンぺーンモードで"
    news "つかえます."
    news "バッジをつかってユニットの"
    news "レベルをあげましょう!"
    news " "
    news " "
    news "================"
    news "MERCENARY BADGE"
    news "ID:2200000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Mercenary_2", romx[$67F0], bank[$31]
News_Mercenary_2: ; Badge Reward for calling 20 total Mercenaries
    news "ようへい20かいきねんバッジ"
    news " "
    news "ようへいユニットのよびだし"
    news "20かいめをきねんして"
    news "とくべつにバッジを"
    news "  こプレゼントします."
    news " "
    news "つぎのスぺシャルかいすうは"
    news "ヒミツです."
    news "これからもようへいユニットを"
    news "よびだしてください!"
    news " "
    news " "
    news "================"
    news "MERCENARY BADGE"
    news "ID:2300000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Mercenary_3", romx[$68c9], bank[$31]
News_Mercenary_3: ; Badge Reward for calling 50 total Mercenaries
    news "ようへい50かいきねんバッジ"
    news " "
    news "ようへいユニットのよびだし"
    news "50かいめをきねんして"
    news "とくべつにバッジを"
    news "  こプレゼントします."
    news " "
    news "ようへいユニットを"
    news "たくさんつかってくれて"
    news "ありがとう!!"
    news " "
    news " "
    news " "
    news "================"
    news "MERCENARY BADGE"
    news "ID:2400000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Mercenary_4", romx[$6993], bank[$31]
News_Mercenary_4: ; Badge Reward for calling 77 total Mercenaries
    news "ようへい77かいきねんバッジ"
    news " "
    news "ようへいユニットのよびだし"
    news "77かいめをきねんして"
    news "とくべつにバッジを"
    news "  こプレゼントします."
    news " "
    news "こんかいは"
    news "ラッキー77スぺシャルで"
    news "バッジをおおくりしました!"
    news " "
    news " "
    news " "
    news "================"
    news "MERCENARY BADGE"
    news "ID:2500000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Mercenary_5", romx[$6a60], bank[$31]
News_Mercenary_5: ; Badge Reward for calling 100 total Mercenaries
    news "ようへい100かいきねんバッジ"
    news " "
    news "ようへいユニットのよびだし"
    news "100かいめをきねんして"
    news "とくべつにバッジを"
    news "まんたんサービスプレゼント!"
    news " "
    news "これでユニットを"
    news "さいきょうにしてください!!"
    news "バッジをおおくりしました!"
    news " "
    news " "
    news " "
    news "================"
    news "MERCENARY BADGE"
    news "ID:2600000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Mercenary_6", romx[$6b36], bank[$31]
News_Mercenary_6: ; Either a general reward for calling higher numbers, or the reward for calling your first Mercenary
    news "ようへいバッジ"
    news " "
    news "ようへいユニットのよびだし"
    news "ありがとうございました."
    news "ウォーズネットセンターから"
    news "バッジを"
    news "  こプレゼントします."
    news " "
    news "バッジはキャンぺーンモードで"
    news "つかえます."
    news "これからもようへいユニットを"
    news "よろしく!"
    news " "
    news "================"
    news "MERCENARY BADGE"
    news "ID:2100000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Map_1", romx[$6c0c], bank[$31]
News_Map_1: ; Badge Reward for downloading maps
    news "マップバッジ"
    news " "
    news "マップダウンロード"
    news "ありがとうございました."
    news "ウォーズネットセンターから"
    news "バッジを"
    news "  こプレゼントします."
    news " "
    news "バッジはキャンぺーンモードで"
    news "つかえます."
    news "いろいろなマップを"
    news "ダウンロードしてください."
    news " "
    news "================"
    news "DOWNLOAD BADGE"
    news "ID:1100000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Map_2", romx[$6cdf], bank[$31]
News_Map_2: ; Badge Reward for downloading maps
    news "マップラッキーバッジ"
    news " "
    news "マップダウンロード"
    news "ありがとうございました."
    news "ウォーズネットセンターから"
    news "バッジをプレゼントします."
    news " "
    news "こんかいはラッキー!"
    news "とくべつに"
    news "  こプレゼント!"
    news "おめでとう!"
    news " "
    news " "
    news "================"
    news "DOWNLOAD BADGE"
    news "ID:1200000"
    news "WARS NET CENTER"
    news "================"
    news 0

;section "News_Map_3", romx[$6da8], bank[$31]
News_Map_3: ; Badge Reward for downloading maps
    news "マップスぺシャルラッキーバッジ"
    news " "
    news "マップダウンロード"
    news "ありがとうございました."
    news "ウォーズネットセンターから"
    news "バッジをプレゼントします."
    news " "
    news "こんかいはスぺシャルラッキー!"
    news "とくべつに"
    news "  こプレゼント!"
    news "おめでとう!"
    news " "
    news " "
    news "================"
    news "DOWNLOAD BADGE"
    news "ID:1300000"
    news "WARS NET CENTER"
    news "================"
    news 0, 0

section "News_Welcome", romx[$7203], bank[$31]
News_Welcome:
    ;news "ようこそ!"
    ;news " "
    ;news "ウォーズネットでりようできる"
    ;news "サービスをしょうかいします."
    ;news "(1)マップデータダウンロード"
    ;news "(2)ようへいユニットよびだし"
    ;news "(3)センターからのメッセージ"
    ;news " "
    ;news "[センターにアクセス]すると"
    ;news "マップじょうほうやバッジが"
    ;news "おくられてくることがあります."
    ;news " "
    ;news "ウォーズネットをりようすると"
    ;news "よりゲームをたのしめます."
    ;news "モバイルシステムGBを"
    ;news "もっているプレイヤーは"
    ;news "ぜひアクセスしてください!"
    news "WELCOME!"
    news " "
    news "List of WARS NET"
    news "services:"
    news "(1)DOWNLOAD MAPS"
    news "(2)MERCENARIES"
    news "(3)CENTER NEWS"
    news " "
    news "[ACCESS CENTER]"
    news "To receive map"
    news "info and badges."
    news " "
    news "MOBILE ADAPTER"
    news "players, go to"
    news "the WARS NET"
    news "CENTER for more"
    news "fun! "
    news 0
