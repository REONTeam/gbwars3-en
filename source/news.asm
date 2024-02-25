include "include/macros.inc"
include "include/char_news.inc"

setcharmap news
section "News_Menu_Service", romx[$77c2], bank[$22]
News_Menu_Message_Service:
    ;db 2, 1, "メッセージサービ", 0
    db 2, 1, "MESSAGES", 0

section "News_Menu_Retrieve", romx[$79b5], bank[$22]
News_Menu_Message_Retrieve:
    db "このメッセージを", 0
    db "さくじょしますか?", 0

; Preloaded News
section "News_Mercenary_1", romx[$6716], bank[$31]
News_Mercenary_1: ; Badge Reward for calling 10 total Mercenaries
    db "ようへい10かいきねんバッジ", 0, 0
    db " ", 0, 0
    db "ようへいユニットのよびだし", 0, 0
    db "10かいめをきねんして", 0, 0
    db "とくべつにバッジを", 0, 0
    db "  ", "こプレゼントします.", 0, 0
    db " ", 0, 0
    db "バッジはキャンぺーンモードで", 0, 0
    db "つかえます.", 0, 0
    db "バッジをつかってユニットの", 0, 0
    db "レべルをあげましょう!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "MERCENARY BADGE", 0, 0
    db "ID:2200000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Mercenary_2", romx[$67F0], bank[$31]
News_Mercenary_2: ; Badge Reward for calling 20 total Mercenaries
    db "ようへい20かいきねんバッジ", 0, 0
    db " ", 0, 0
    db "ようへいユニットのよびだし", 0, 0
    db "20かいめをきねんして", 0, 0
    db "とくべつにバッジを", 0, 0
    db "  ", "こプレゼントします.", 0, 0
    db " ", 0, 0
    db "つぎのスぺシャルかいすうは", 0, 0
    db "ヒミツです.", 0, 0
    db "これからもようへいユニットを", 0, 0
    db "よびだしてください!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "MERCENARY BADGE", 0, 0
    db "ID:2300000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Mercenary_3", romx[$68c9], bank[$31]
News_Mercenary_3: ; Badge Reward for calling 50 total Mercenaries
    db "ようへい50かいきねんバッジ", 0, 0
    db " ", 0, 0
    db "ようへいユニットのよびだし", 0, 0
    db "50かいめをきねんして", 0, 0
    db "とくべつにバッジを", 0, 0
    db "  ", "こプレゼントします.", 0, 0
    db " ", 0, 0
    db "ようへいユニットを", 0, 0
    db "たくさんつかってくれて", 0, 0
    db "ありがとう!!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "MERCENARY BADGE", 0, 0
    db "ID:2400000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Mercenary_4", romx[$6993], bank[$31]
News_Mercenary_4: ; Badge Reward for calling 77 total Mercenaries
    db "ようへい77かいきねんバッジ", 0, 0
    db " ", 0, 0
    db "ようへいユニットのよびだし", 0, 0
    db "77かいめをきねんして", 0, 0
    db "とくべつにバッジを", 0, 0
    db "  ", "こプレゼントします.", 0, 0
    db " ", 0, 0
    db "こんかいは", 0, 0
    db "ラッキー77スぺシャルで", 0, 0
    db "バッジをおおくりしました!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "MERCENARY BADGE", 0, 0
    db "ID:2500000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Mercenary_5", romx[$6a60], bank[$31]
News_Mercenary_5: ; Badge Reward for calling 100 total Mercenaries
    db "ようへい100かいきねんバッジ", 0, 0
    db " ", 0, 0
    db "ようへいユニットのよびだし", 0, 0
    db "100かいめをきねんして", 0, 0
    db "とくべつにバッジを", 0, 0
    db "まんたんサービスプレゼント!", 0, 0
    db " ", 0, 0
    db "これでユニットを", 0, 0
    db "さいきょうにしてください!!", 0, 0
    db "バッジをおおくりしました!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "MERCENARY BADGE", 0, 0
    db "ID:2600000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Mercenary_6", romx[$6b36], bank[$31]
News_Mercenary_6: ; Either a general reward for calling higher numbers, or the reward for calling your first Mercenary
    db "ようへいバッジ", 0, 0
    db " ", 0, 0
    db "ようへいユニットのよびだし", 0, 0
    db "ありがとうございました.", 0, 0
    db "ウォーズネットセンターから", 0, 0
    db "バッジを", 0, 0
    db "  ", "こプレゼントします.", 0, 0
    db " ", 0, 0
    db "バッジはキャンぺーンモードで", 0, 0
    db "つかえます.", 0, 0
    db "これからもようへいユニットを", 0, 0
    db "よろしく!", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "MERCENARY BADGE", 0, 0
    db "ID:2100000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Map_1", romx[$6c0c], bank[$31]
News_Map_1: ; Badge Reward for downloading maps
    db "マップバッジ", 0, 0
    db " ", 0, 0
    db "マップダウンロード", 0, 0
    db "ありがとうございました.", 0, 0
    db "ウォーズネットセンターから", 0, 0
    db "バッジを", 0, 0
    db "  ", "こプレゼントします.", 0, 0
    db " ", 0, 0
    db "バッジはキャンぺーンモードで", 0, 0
    db "つかえます.", 0, 0
    db "いろいろなマップを", 0, 0
    db "ダウンロードしてください.", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "DOWNLOAD BADGE", 0, 0
    db "ID:1100000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Map_2", romx[$6cdf], bank[$31]
News_Map_2: ; Badge Reward for downloading maps
    db "マップラッキーバッジ", 0, 0
    db " ", 0, 0
    db "マップダウンロード", 0, 0
    db "ありがとうございました.", 0, 0
    db "ウォーズネットセンターから", 0, 0
    db "バッジをプレゼントします.", 0, 0
    db " ", 0, 0
    db "こんかいはラッキー!", 0, 0
    db "とくべつに", 0, 0
    db "  ", "こプレゼント!", 0, 0
    db "おめでとう!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "DOWNLOAD BADGE", 0, 0
    db "ID:1200000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0, 0

section "News_Map_3", romx[$6da8], bank[$31]
News_Map_3: ; Badge Reward for downloading maps
    db "マップスぺシャルラッキーバッジ", 0, 0
    db " ", 0, 0
    db "マップダウンロード", 0, 0
    db "ありがとうございました.", 0, 0
    db "ウォーズネットセンターから", 0, 0
    db "バッジをプレゼントします.", 0, 0
    db " ", 0, 0
    db "こんかいはスぺシャルラッキー!", 0, 0
    db "とくべつに", 0, 0
    db "  ", "こプレゼント!", 0, 0
    db "おめでとう!", 0, 0
    db " ", 0, 0
    db " ", 0, 0
    db "================", 0, 0
    db "DOWNLOAD BADGE", 0, 0
    db "ID:1300000", 0, 0
    db "WARS NET CENTER", 0, 0
    db "================", 0, 0
    db 0, 0

section "News_Welcome", romx[$7203], bank[$31]
News_Welcome:
    ;db "ようこそ!", 0, 0
    ;db " ", 0, 0
    ;db "ウォーズネットでりようできる", 0, 0
    ;db "サービスをしょうかいします.", 0, 0
    ;db "(1)マップデータダウンロード", 0, 0
    ;db "(2)ようへいユニットよびだし", 0, 0
    ;db "(3)センターからのメッセージ", 0, 0
    ;db " ", 0, 0
    ;db "[センターにアクセス]すると", 0, 0
    ;db "マップじょうほうやバッジが", 0, 0
    ;db "おくられてくることがあります.", 0, 0
    ;db " ", 0, 0
    ;db "ウォーズネットをりようすると", 0, 0
    ;db "よりゲームをたのしめます.", 0, 0
    ;db "モバイルシステムGBを", 0, 0
    ;db "もっているプレイヤーは", 0, 0
    ;db "ぜひアクセスしてください!"
    db "WELCOME!", 0, 0
    db " ", 0, 0
    db "List of WARS NET", 0, 0
    db "services:", 0, 0
    db "(1)DOWNLOAD MAPS", 0, 0
    db "(2)MERCENARIES", 0, 0
    db "(3)CENTER NEWS", 0, 0
    db " ", 0, 0
    db "[ACCESS CENTER]", 0, 0
    db "To receive map", 0, 0
    db "info and badges.", 0, 0
    db " ", 0, 0
    db "MOBILE ADAPTER", 0, 0
    db "players, go to", 0, 0
    db "the WARS NET", 0, 0
    db "CENTER for more", 0, 0
    db "fun! ", 0, 0
    db 0, 0, 0
