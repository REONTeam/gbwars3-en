include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "Beginner_Briefings", romx[$4ba9], bank[$25]
Beginner_Strings:
    dw .beginner01
    dw .beginner02
    dw .beginner03
    dw .beginner04
    dw .beginner05
    dw .beginner06
    dw .beginner07
    dw .beginner08
    dw .beginner09
    dw .beginner10
    dw .beginner11
    dw .beginner12
    dw .beginner13
    dw .beginner14
    dw .beginner15
    dw .beginner16
    dw .standard00

.beginner01:
    db "「えんしゅう1」", 1
    db 1
    db "4にちいないに", 1
    db "てきのシュトを", 1
    db "せんりょうせよ。", 1
    db 1, 1, 1
    db "ホヘイは", 1
    db "シュト•トシ•コウジョウで", 1
    db "せいさんします。", 1
    db "せいさんしたユニットは", 1
    db "つぎのひからこうどうできます。", 1
    db 1, 1, 1
    db "たてものをせんりょうするには,", 1
    db "せんりょうしたいたてものに", 1
    db "ホヘイをいどうし", 1
    db "「せんりょう」をえらびます。", 1
    db "たてもののたいきゅうどが", 1
    db "0になると", 1
    db "じぐんのたてものになります。", 1
    db 1
    db "なお,「START+B」で", 1
    db "このがめんを", 1
    db "みることができます。", 1
    db "マップのクリアじょうけんや", 1
    db "せいげんにっすうに", 1
    db "ちゅういしてください。", 0
    ;db "「DRILL1」", 1
    ;db 1
    ;db "CAPTURE THE", 1
    ;db "ENEMY'S HQ", 1
    ;db "WITHIN 4 TURNS。", 1
    ;db 1, 1, 1
    ;db "INFANTRY CAN BE", 1
    ;db "DEPLOYED FROM", 1
    ;db "THE HQ, CITIES,", 1
    ;db "AND FACTORIES。", 1
    ;db 1
    ;db "A DEPLOYED UNIT", 1
    ;db "CAN BE USED ON", 1
    ;db "THE NEXT DAY。", 1
    ;db "TO CAPTURE A", 1
    ;db "BUILDING, MOVE", 1
    ;db "AN INFANTRY UNIT", 1
    ;db "TO IT AND SELECT", 1
    ;DB "「CAPTURE」。", 1
    ;db "BUILDINGS ARE", 1
    ;db "CAPTURED AT 0", 1
    ;db "DURABILITY。", 1
    ;db "THIS SCREEN CAN", 1
    ;db "BE SEEN AGAIN", 1
    ;db "WITH 「START+B」。", 1
    ;db "KEEP THE CLEAR", 1
    ;db "TERMS AND NUMBER", 1
    ;db "OF DAYS IN MIND。", 0

.beginner02:
    ;db "「えんしゅう2」", 1
    ;db 1
    ;db "2にちいないに", 1
    ;db "てきのぶたいを", 1
    ;db "ぜんめつさせよ。", 1
    ;db 1, 1, 1
    ;db "こうげきするときは", 1
    ;db "じぶんのユニットを", 1
    ;db "てきのとなりまでいどうして", 1
    ;db "「せんとう」をえらびます。", 1
    ;db 1, 1, 1, 1
    ;db "ユニットはしゅるいによって", 1
    ;db "とくちょうがあり,たとえば", 1
    ;db "コンバットバギーのグレネードは", 1
    ;db "ひそうこうユニットにつよく,", 1
    ;db "セントウシャリョウの", 1
    ;db "ATミサイルBは", 1
    ;db "そうこうユニットにつよい", 1
    ;db "などがあります。", 1
    ;db "こうげきあいてを", 1
    ;db "けっていするまえに", 1
    ;db "「START」をおすと", 1
    ;db "せんとうにかんする", 1
    ;db "くわしいじょうほうを", 1
    ;db "みることができます。", 0
    db "「DRILL2」", 1
    db 1
    db "2にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "こうげきするときは", 1
    db "じぶんのユニットを", 1
    db "てきのとなりまでいどうして", 1
    db "「せんとう」をえらびます。", 1
    db 1, 1, 1, 1
    db "ユニットはしゅるいによって", 1
    db "とくちょうがあり,たとえば", 1
    db "コンバットバギーのグレネードは", 1
    db "ひそうこうユニットにつよく,", 1
    db "セントウシャリョウの", 1
    db "ATミサイルBは", 1
    db "そうこうユニットにつよい", 1
    db "などがあります。", 1
    db "こうげきあいてを", 1
    db "けっていするまえに", 1
    db "「START」をおすと", 1
    db "せんとうにかんする", 1
    db "くわしいじょうほうを", 1
    db "みることができます。", 0

.beginner03:
    db "「えんしゅう3」", 1
    db 1
    db "4にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "はなれたばしょから", 1
    db "こうげきすることを", 1
    db "「かんせつこうげき」といい", 1
    db "はんげきをうけません。", 1
    db "かんせつこうげきでも", 1
    db "ぶそうによって", 1
    db "とくちょうがあります。", 1
    db 1
    db "たとえば,ジソウホウは", 1
    db "そうこうユニットにつよく,", 1
    db "Rランチャーは", 1
    db "ひそうこうユニットにつよい", 1
    db "などがあります。", 1
    db 1, 1, 1
    db "ホキュウシャのよこにいる", 1
    db "みこうどうのりくユニットは", 1
    db "ねんりょう•だんやくの", 1
    db "ほきゅうをうけることができます。", 1
    db 1, 1, 1, 1
    db "カーソルでユニットをさし", 1
    db "「SELECT」をおすと", 1
    db "そのユニットのじょうほうが", 1
    db "ひょうじされます。", 1
    db "これを", 1
    db "「ユニットじょうほうがめん」と", 1
    db "いいます。", 0

.beginner04:
    db "「えんしゅう4」", 1
    db 1
    db "3にちいないに", 1
    db "すべてのちゅうりつトシを", 1
    db "せんりょうせよ。", 1
    db 1, 1, 1
    db "ひがいをうけて", 1
    db "ユニットのかずがへったばあい,", 1
    db "おなじしゅるいの", 1
    db "ユニットどうしで", 1
    db "ごうりゅうすることができます。", 1
    db 1, 1, 1
    db "ごうりゅうしたいぶたいの", 1
    db "よこにいどうして", 1
    db "「ごうりゅう」をえらび", 1
    db "おたがいのユニットすうを", 1
    db "ちょうせいします。", 1
    db 1, 1, 1
    db "ただし,ユニットを", 1
    db "とうさいしているばあいは", 1
    db "ごうりゅうできません。", 1
    db 1, 1, 1, 1
    db 1
    db "コマンドメニューの「ぶたい」から", 1
    db "じぐんのユニットいちらんを", 1
    db "みることができます。", 1
    db "ユニットのダメージや", 1
    db "のこりねんりょうを", 1
    db "しらべるのにべんりです。", 0

.beginner05:
    db "「えんしゅう5」", 1
    db 1
    db "4にちいないに", 1
    db "てきのシュトを", 1
    db "せんりょうせよ。", 1
    db 1, 1, 1
    db "ホヘイのようにいどうりょくの", 1
    db "ひくいユニットは", 1
    db "ゆそうユニットにのせると", 1
    db "こうりつよく", 1
    db "いどうすることができます。", 1
    db 1, 1, 1
    db "ユニットじょうほうがめんの", 1
    db "「とうさい」が「かのう」と", 1
    db "ひょうじされているユニットは", 1
    db "ほかのユニットを", 1
    db "とうさいできます。", 1
    db "ホヘイをとうさいできる", 1
    db "ユニットをしらべてみましょう。", 0

.beginner06:
    db "「えんしゅう6」", 1
    db 1
    db "1にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "カワは,りくユニットのいどうに", 1
    db "おおきなしょうがいとなります。", 1
    db "しかし,コウサクシャで", 1
    db "カワにハシをかけ", 1
    db "いどうをスムーズにすることが", 1
    db "できます。", 1
    db 1, 1
    db "こうげきのときは", 1
    db "てきユニットのぞくせいに", 1
    db "ちゅういしましょう。", 1
    db "ぞくせいは「ひそうこうユニット」", 1
    db "「そうこうユニット」", 1
    db "「そらユニット」「うみユニット」", 1
    db "「せんすいかん」の", 1
    db "5しゅるいです。", 1
    db "ユニットじょうほうがめんの", 1
    db "ユニットのなまえのしたに", 1
    db "ぞくせいがひょうじされています。", 0

.beginner07:
    db "「えんしゅう7」", 1
    db 1
    db "2にちいないに", 1
    db "にゅうしゅしざいを", 1
    db "20にせよ。", 1
    db 1, 1, 1
    db "コウサクシャは", 1
    db "けんちくすることによって", 1
    db "たてもののたいきゅうどを", 1
    db "あげることができます。", 1
    db 1, 1, 1, 1
    db "たいきゅうどがあがると", 1
    db "にゅうしゅする", 1
    db "しきん•しざいがふえ", 1
    db "ほじゅうできるかずが", 1
    db "おおくなります。", 1
    db 1, 1, 1
    db "シュトから3HEXいないの", 1
    db "たてものは,ユニットの", 1
    db "せいさんができます。", 1
    db "たてものによってせいさんできる", 1
    db "ユニットはちがいます。", 1
    db "コウサクシャをせいさんできるのは", 1
    db "コウジョウだけです。", 1
    db 1
    db "コマンドメニューの", 1
    db "「じょうきょう」で", 1
    db "りょうぐんのしきん•しざいや", 1
    db "たてもののかずを", 1
    db "しらべることができます。", 0

.beginner08:
    db "「えんしゅう8」", 1
    db 1
    db "3にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "ほうかいしたたてものは", 1
    db "コウサクシャで「けんちく」すると", 1
    db "ふっきゅうします。", 1
    db "ふっきゅうしたたてものは", 1
    db "じぐんのたてものとなり", 1
    db "「ほきゅう•ほじゅう」が", 1
    db "できます。", 1
    db 1
    db "カーソルがユニットいがいを", 1
    db "さしているときに", 1
    db "「SELECT」をおすと", 1
    db "すべてのユニットの", 1
    db "じょうほうがめんを", 1
    db "えらぶことができます。", 0

.beginner09:
    db "「えんしゅう9」", 1
    db 1
    db "4にちいないに", 1
    db "てきのシュトを", 1
    db "せんりょうせよ。", 1
    db 1, 1, 1
    db "コウサクシャをつかって", 1
    db "アレチやモリなどを", 1
    db "ドウロやヘイチにすると", 1
    db "ユニットをスムーズに", 1
    db "いどうさせることができます。", 1
    db 1, 1, 1
    db "ユニットじょうほうがめんの", 1
    db "「いどうりょく」をえらぶと", 1
    db "ちけいのいどうロスが", 1
    db "ひょうじされます。", 1
    db "いどうロスのすうちがたかいほど", 1
    db "いどうしにくいちけいです。", 1
    db 1, 1
    db "「START+うえ」か", 1
    db "「START+した」で", 1
    db "MAPじょうのユニットを", 1
    db "いちじてきにけします。", 1
    db "ユニットのしたのちけいにも", 1
    db "ちゅういしながら", 1
    db "せんとうをすすめましょう。", 0

.beginner10:
    db "「えんしゅう10」", 1
    db 1
    db "4にちいないに", 1
    db "てきのシュトを", 1
    db "せんりょうせよ。", 1
    db 1, 1, 1
    db "ユソウヘリはホヘイをのせて", 1
    db "いどうできます。", 1
    db "そらユニットは", 1
    db "ねんりょうが0になると", 1
    db "ついらくするので", 1
    db "ちゅういしてください。", 1
    db 1, 1
    db "ユニットじょうほうがめんで", 1
    db "「さいだいねんりょう」を", 1
    db "えらぶと", 1
    db "ねんりょうにかんする", 1
    db "くわしいじょうほうを", 1
    db "みることができます。", 1
    db 1, 1
    db "そらユニットのねんりょうは", 1
    db "クウコウ•カンイクウコウなどから", 1
    db "ほきゅうできます。", 1
    db "また,カンイクウコウは", 1
    db "コウサクシャで", 1
    db "アレチ•モリ•ヘイチに", 1
    db "けんせつできます。", 1
    db 1
    db "カンイクウコウは,", 1
    db "だんやく•ねんりょうの", 1
    db "ほきゅうはできますが", 1
    db "ユニットのほじゅうはできません。", 0

.beginner11:
    db "「えんしゅう11」", 1
    db 1
    db "2にちいないに", 1
    db "てきのにゅうしゅしざいを", 1
    db "0にせよ。", 1
    db 1, 1, 1
    db "てきの", 1
    db "せいさんりょくをおとすには,", 1
    db "てきのたてものをせんりょうするか", 1
    db "ばくげきでほうかいさせる", 1
    db "2つのほうほうがあります。", 1
    db 1, 1, 1
    db "「ばくげき」は", 1
    db "ばくげきした7HEXの", 1
    db "ちけいすべてに", 1
    db "えいきょうをあたえます。", 1
    db "ばくげきされたたてものは", 1
    db "たいきゅうどがさがります。", 1
    db 1, 1
    db "たいきゅうどが0になった", 1
    db "たてものはほうかいして", 1
    db "ちゅうりつになります。", 1
    db "てきのたてものを", 1
    db "せんりょうしたり", 1
    db "ほうかいさせると", 1
    db "にゅうしゅしざいをへらせます。", 1
    db 1
    db "なお,「START+みぎ」か", 1
    db "「START+ひだり」で", 1
    db "みこうどうユニットだけに", 1
    db "カーソルがいどうします。", 0

.beginner12:
    db "「えんしゅう12」", 1
    db 1
    db "1にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "てきのユニットが", 1
    db "とおりみちにいると", 1
    db "ユニットのいどうはんいが", 1
    db "せいげんされます。", 1
    db 1, 1, 1, 1
    db "ここでは", 1
    db "ユニットのあいしょうを", 1
    db "かんがえてこうげきし", 1
    db "とおりみちにいるユニットを", 1
    db "たおすひつようがあります。", 1
    db 1, 1, 1
    db "こうげきについては", 1
    db "「えんしゅう2」を", 1
    db "さんこうにしてください。", 0

.beginner13:
    db "「えんしゅう13」", 1
    db 1
    db "1にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "みかたのユニットで", 1
    db "てきのユニットをかこんで", 1
    db "こうげきすると", 1
    db "てきのぼうぎょりょくが", 1
    db "さがります。", 1
    db 1, 1, 1
    db "さらに,てきのユニットを", 1
    db "りょうがわからはさむと", 1
    db "かんぜんに", 1
    db "ほういしたことになり", 1
    db "きょうりょくな", 1
    db "こうげきができます。", 0

.beginner14:
    db "「えんしゅう14」", 1
    db 1
    db "じぶんのぶたいに", 1
    db "ひがいをだすことなく", 1
    db "1にちいないに", 1
    db "てきのソウコウユソウシャを", 1
    db "ぜんめつさせよ。", 1
    db 1
    db "ユニットがいるちけいによって", 1
    db "ぼうぎょりょくがあがります。", 1
    db "ちけいのぼうぎょこうかを", 1
    db "かんがえてこうげきしてください。", 1
    db 1, 1, 1, 1
    db "ユニットじょうほうがめんで", 1
    db "「いどうりょく」をえらぶと", 1
    db "ちけいのいちらんがあります。", 1
    db "さらに,それぞれの", 1
    db "ちけいをえらぶと", 1
    db "くわしいじょうほうを", 1
    db "みることができます。", 1
    db 1
    db "「START+SELECT」でも", 1
    db "カーソルがさしているちけいの", 1
    db "じょうほうをひょうじできます。", 0

.beginner15:
    db "「えんしゅう15」", 1
    db 1
    db "じぶんのぶたいに", 1
    db "ひがいをだすことなく", 1
    db "1にちいないに", 1
    db "てきのソウコウユソウシャを", 1
    db "ぜんめつさせよ。", 1
    db 1
    db "こうげきをするとき", 1
    db "イニシアティブのおおきいほうが", 1
    db "さきにこうげきできます。", 1
    db "せんとうでは", 1
    db "せんせいこうげきをしたほうが", 1
    db "ゆうりです。", 1
    db 1, 1
    db "イニシアティブは", 1
    db "いどうすることによって", 1
    db "しょうひするので,", 1
    db "とおくからいどうして", 1
    db "こうげきをすると,", 1
    db "てきのせんせいこうげきを", 1
    db "うけやすくなります。", 1
    db 1
    db "せんとうあいてをえらぶときに", 1
    db "せんせいこうげきできるばあい", 1
    db "カーソルがあおになり,", 1
    db "てきのほうに", 1
    db "せんせいこうげきされるときは", 1
    db "あかになり,", 1
    db "どうじのときはしろになります。", 1
    db 1
    db "ユニットじょうほうがめんで", 1
    db "「イニシアティブ」をえらぶと", 1
    db "くわしいじょうほうを", 1
    db "みることができます。", 0

.beginner16:
    db "「えんしゅう16」", 1
    db 1
    db "1にちいないに", 1
    db "てきのぶたいを", 1
    db "ぜんめつさせよ。", 1
    db 1, 1, 1
    db "てきのユニットにたいして", 1
    db "こうげきするユニットのばしょや", 1
    db "じゅんばんによって", 1
    db "せんとうけっかが", 1
    db "おおきくかわります。", 1
    db 1, 1, 1
    db "このえんしゅうでは", 1
    db "ただしくてきをほういし,", 1
    db "あいしょうをかんがえて", 1
    db "せんせいこうげきをするなど,", 1
    db "もっともこうりつよく", 1
    db "せんとうを", 1
    db "おこなうひつようがあります。", 1
    db 1
    db "ユニットのあいしょうについては", 1
    db "「えんしゅう2」を,", 1
    db "ほういこうかにかんしては", 1
    db "「えんしゅう13」を,", 1
    db "イニシアティブにかんしては", 1
    db "「えんしゅう15」を", 1
    db "さんこうにしてください。", 0

.standard00:
    db "99にちいないに", 1
    db "てきのしゅとをせんりょう", 1
    db "もしくは,てきのぶたいを", 1
    db "ぜんめつさせよ。", 0
