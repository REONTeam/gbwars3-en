include "include/macros.inc"
include "include/char_news.inc"

setcharmap news

; Preloaded News
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
    db "fun! "
