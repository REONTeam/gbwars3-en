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
    text "「えんしゅう1」"
    skip 1
    line "4にちいないに"
    line "てきのシュトを"
    line "せんりょうせよ。"
    skip 3
    line "ホヘイは"
    line "シュト•トシ•コウジョウで"
    line "せいさんします。"
    line "せいさんしたユニットは"
    line "つぎのひからこうどうできます。"
    skip 3
    line "たてものをせんりょうするには,"
    line "せんりょうしたいたてものに"
    line "ホヘイをいどうし"
    line "「せんりょう」をえらびます。"
    line "たてもののたいきゅうどが"
    line "0になると"
    line "じぐんのたてものになります。"
    skip 1
    line "なお,「START+B」で"
    line "このがめんを"
    line "みることができます。"
    line "マップのクリアじょうけんや"
    line "せいげんにっすうに"
    line "ちゅういしてください。"
    done
    ;text "「DRILL1」"
    ;skip 1
    ;line "CAPTURE THE"
    ;line "ENEMY'S HQ"
    ;line "WITHIN 4 TURNS。"
    ;skip 3
    ;line "INFANTRY CAN BE"
    ;line "DEPLOYED FROM"
    ;line "THE HQ, CITIES,"
    ;line "AND FACTORIES。"
    ;skip 1
    ;line "A DEPLOYED UNIT"
    ;line "CAN BE USED ON"
    ;line "THE NEXT DAY。"
    ;line "TO CAPTURE A"
    ;line "BUILDING, MOVE"
    ;line "AN INFANTRY UNIT"
    ;line "TO IT AND SELECT"
    ;line "「CAPTURE」。"
    ;line "BUILDINGS ARE"
    ;line "CAPTURED AT 0"
    ;line "DURABILITY。"
    ;line "THIS SCREEN CAN"
    ;line "BE SEEN AGAIN"
    ;line "WITH 「START+B」。"
    ;line "KEEP THE CLEAR"
    ;line "TERMS AND NUMBER"
    ;line "OF DAYS IN MIND。"
    ;done

.beginner02:
    ;line "「えんしゅう2」"
    ;skip 1
    ;line "2にちいないに"
    ;line "てきのぶたいを"
    ;line "ぜんめつさせよ。"
    ;skip 3
    ;line "こうげきするときは"
    ;line "じぶんのユニットを"
    ;line "てきのとなりまでいどうして"
    ;line "「せんとう」をえらびます。"
    ;skip 4
    ;line "ユニットはしゅるいによって"
    ;line "とくちょうがあり,たとえば"
    ;line "コンバットバギーのグレネードは"
    ;line "ひそうこうユニットにつよく,"
    ;line "セントウシャリョウの"
    ;line "ATミサイルBは"
    ;line "そうこうユニットにつよい"
    ;line "などがあります。"
    ;line "こうげきあいてを"
    ;line "けっていするまえに"
    ;line "「START」をおすと"
    ;line "せんとうにかんする"
    ;line "くわしいじょうほうを"
    ;line "みることができます。"    ;done
    text "「DRILL2」"
    skip 1
    line "2にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "こうげきするときは"
    line "じぶんのユニットを"
    line "てきのとなりまでいどうして"
    line "「せんとう」をえらびます。"
    skip 4
    line "ユニットはしゅるいによって"
    line "とくちょうがあり,たとえば"
    line "コンバットバギーのグレネードは"
    line "ひそうこうユニットにつよく,"
    line "セントウシャリョウの"
    line "ATミサイルBは"
    line "そうこうユニットにつよい"
    line "などがあります。"
    line "こうげきあいてを"
    line "けっていするまえに"
    line "「START」をおすと"
    line "せんとうにかんする"
    line "くわしいじょうほうを"
    line "みることができます。"    done

.beginner03:
    text "「えんしゅう3」"
    skip 1
    line "4にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "はなれたばしょから"
    line "こうげきすることを"
    line "「かんせつこうげき」といい"
    line "はんげきをうけません。"
    line "かんせつこうげきでも"
    line "ぶそうによって"
    line "とくちょうがあります。"
    skip 1
    line "たとえば,ジソウホウは"
    line "そうこうユニットにつよく,"
    line "Rランチャーは"
    line "ひそうこうユニットにつよい"
    line "などがあります。"
    skip 3
    line "ホキュウシャのよこにいる"
    line "みこうどうのりくユニットは"
    line "ねんりょう•だんやくの"
    line "ほきゅうをうけることができます。"
    skip 4
    line "カーソルでユニットをさし"
    line "「SELECT」をおすと"
    line "そのユニットのじょうほうが"
    line "ひょうじされます。"
    line "これを"
    line "「ユニットじょうほうがめん」と"
    line "いいます。"    done

.beginner04:
    text "「えんしゅう4」"
    skip 1
    line "3にちいないに"
    line "すべてのちゅうりつトシを"
    line "せんりょうせよ。"
    skip 3
    line "ひがいをうけて"
    line "ユニットのかずがへったばあい,"
    line "おなじしゅるいの"
    line "ユニットどうしで"
    line "ごうりゅうすることができます。"
    skip 3
    line "ごうりゅうしたいぶたいの"
    line "よこにいどうして"
    line "「ごうりゅう」をえらび"
    line "おたがいのユニットすうを"
    line "ちょうせいします。"
    skip 3
    line "ただし,ユニットを"
    line "とうさいしているばあいは"
    line "ごうりゅうできません。"
    skip 5
    line "コマンドメニューの「ぶたい」から"
    line "じぐんのユニットいちらんを"
    line "みることができます。"
    line "ユニットのダメージや"
    line "のこりねんりょうを"
    line "しらべるのにべんりです。"    done

.beginner05:
    text "「えんしゅう5」"
    skip 1
    line "4にちいないに"
    line "てきのシュトを"
    line "せんりょうせよ。"
    skip 3
    line "ホヘイのようにいどうりょくの"
    line "ひくいユニットは"
    line "ゆそうユニットにのせると"
    line "こうりつよく"
    line "いどうすることができます。"
    skip 3
    line "ユニットじょうほうがめんの"
    line "「とうさい」が「かのう」と"
    line "ひょうじされているユニットは"
    line "ほかのユニットを"
    line "とうさいできます。"
    line "ホヘイをとうさいできる"
    line "ユニットをしらべてみましょう。"    done

.beginner06:
    text "「えんしゅう6」"
    skip 1
    line "1にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "カワは,りくユニットのいどうに"
    line "おおきなしょうがいとなります。"
    line "しかし,コウサクシャで"
    line "カワにハシをかけ"
    line "いどうをスムーズにすることが"
    line "できます。"
    skip 2
    line "こうげきのときは"
    line "てきユニットのぞくせいに"
    line "ちゅういしましょう。"
    line "ぞくせいは「ひそうこうユニット」"
    line "「そうこうユニット」"
    line "「そらユニット」「うみユニット」"
    line "「せんすいかん」の"
    line "5しゅるいです。"
    line "ユニットじょうほうがめんの"
    line "ユニットのなまえのしたに"
    line "ぞくせいがひょうじされています。"    done

.beginner07:
    text "「えんしゅう7」"
    skip 1
    line "2にちいないに"
    line "にゅうしゅしざいを"
    line "20にせよ。"
    skip 3
    line "コウサクシャは"
    line "けんちくすることによって"
    line "たてもののたいきゅうどを"
    line "あげることができます。"
    skip 4
    line "たいきゅうどがあがると"
    line "にゅうしゅする"
    line "しきん•しざいがふえ"
    line "ほじゅうできるかずが"
    line "おおくなります。"
    skip 3
    line "シュトから3HEXいないの"
    line "たてものは,ユニットの"
    line "せいさんができます。"
    line "たてものによってせいさんできる"
    line "ユニットはちがいます。"
    line "コウサクシャをせいさんできるのは"
    line "コウジョウだけです。"
    skip 1
    line "コマンドメニューの"
    line "「じょうきょう」で"
    line "りょうぐんのしきん•しざいや"
    line "たてもののかずを"
    line "しらべることができます。"    done

.beginner08:
    text "「えんしゅう8」"
    skip 1
    line "3にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "ほうかいしたたてものは"
    line "コウサクシャで「けんちく」すると"
    line "ふっきゅうします。"
    line "ふっきゅうしたたてものは"
    line "じぐんのたてものとなり"
    line "「ほきゅう•ほじゅう」が"
    line "できます。"
    skip 1
    line "カーソルがユニットいがいを"
    line "さしているときに"
    line "「SELECT」をおすと"
    line "すべてのユニットの"
    line "じょうほうがめんを"
    line "えらぶことができます。"    done

.beginner09:
    text "「えんしゅう9」"
    skip 1
    line "4にちいないに"
    line "てきのシュトを"
    line "せんりょうせよ。"
    skip 3
    line "コウサクシャをつかって"
    line "アレチやモリなどを"
    line "ドウロやヘイチにすると"
    line "ユニットをスムーズに"
    line "いどうさせることができます。"
    skip 3
    line "ユニットじょうほうがめんの"
    line "「いどうりょく」をえらぶと"
    line "ちけいのいどうロスが"
    line "ひょうじされます。"
    line "いどうロスのすうちがたかいほど"
    line "いどうしにくいちけいです。"
    skip 2
    line "「START+うえ」か"
    line "「START+した」で"
    line "MAPじょうのユニットを"
    line "いちじてきにけします。"
    line "ユニットのしたのちけいにも"
    line "ちゅういしながら"
    line "せんとうをすすめましょう。"    done

.beginner10:
    text "「えんしゅう10」"
    skip 1
    line "4にちいないに"
    line "てきのシュトを"
    line "せんりょうせよ。"
    skip 3
    line "ユソウヘリはホヘイをのせて"
    line "いどうできます。"
    line "そらユニットは"
    line "ねんりょうが0になると"
    line "ついらくするので"
    line "ちゅういしてください。"
    skip 2
    line "ユニットじょうほうがめんで"
    line "「さいだいねんりょう」を"
    line "えらぶと"
    line "ねんりょうにかんする"
    line "くわしいじょうほうを"
    line "みることができます。"
    skip 2
    line "そらユニットのねんりょうは"
    line "クウコウ•カンイクウコウなどから"
    line "ほきゅうできます。"
    line "また,カンイクウコウは"
    line "コウサクシャで"
    line "アレチ•モリ•ヘイチに"
    line "けんせつできます。"
    skip 1
    line "カンイクウコウは,"
    line "だんやく•ねんりょうの"
    line "ほきゅうはできますが"
    line "ユニットのほじゅうはできません。"    done

.beginner11:
    text "「えんしゅう11」"
    skip 1
    line "2にちいないに"
    line "てきのにゅうしゅしざいを"
    line "0にせよ。"
    skip 3
    line "てきの"
    line "せいさんりょくをおとすには,"
    line "てきのたてものをせんりょうするか"
    line "ばくげきでほうかいさせる"
    line "2つのほうほうがあります。"
    skip 3
    line "「ばくげき」は"
    line "ばくげきした7HEXの"
    line "ちけいすべてに"
    line "えいきょうをあたえます。"
    line "ばくげきされたたてものは"
    line "たいきゅうどがさがります。"
    skip 2
    line "たいきゅうどが0になった"
    line "たてものはほうかいして"
    line "ちゅうりつになります。"
    line "てきのたてものを"
    line "せんりょうしたり"
    line "ほうかいさせると"
    line "にゅうしゅしざいをへらせます。"
    skip 1
    line "なお,「START+みぎ」か"
    line "「START+ひだり」で"
    line "みこうどうユニットだけに"
    line "カーソルがいどうします。"    done

.beginner12:
    text "「えんしゅう12」"
    skip 1
    line "1にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "てきのユニットが"
    line "とおりみちにいると"
    line "ユニットのいどうはんいが"
    line "せいげんされます。"
    skip 4
    line "ここでは"
    line "ユニットのあいしょうを"
    line "かんがえてこうげきし"
    line "とおりみちにいるユニットを"
    line "たおすひつようがあります。"
    skip 3
    line "こうげきについては"
    line "「えんしゅう2」を"
    line "さんこうにしてください。"    done

.beginner13:
    text "「えんしゅう13」"
    skip 1
    line "1にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "みかたのユニットで"
    line "てきのユニットをかこんで"
    line "こうげきすると"
    line "てきのぼうぎょりょくが"
    line "さがります。"
    skip 3
    line "さらに,てきのユニットを"
    line "りょうがわからはさむと"
    line "かんぜんに"
    line "ほういしたことになり"
    line "きょうりょくな"
    line "こうげきができます。"    done

.beginner14:
    text "「えんしゅう14」"
    skip 1
    line "じぶんのぶたいに"
    line "ひがいをだすことなく"
    line "1にちいないに"
    line "てきのソウコウユソウシャを"
    line "ぜんめつさせよ。"
    skip 1
    line "ユニットがいるちけいによって"
    line "ぼうぎょりょくがあがります。"
    line "ちけいのぼうぎょこうかを"
    line "かんがえてこうげきしてください。"
    skip 4
    line "ユニットじょうほうがめんで"
    line "「いどうりょく」をえらぶと"
    line "ちけいのいちらんがあります。"
    line "さらに,それぞれの"
    line "ちけいをえらぶと"
    line "くわしいじょうほうを"
    line "みることができます。"
    skip 1
    line "「START+SELECT」でも"
    line "カーソルがさしているちけいの"
    line "じょうほうをひょうじできます。"    done

.beginner15:
    text "「えんしゅう15」"
    skip 1
    line "じぶんのぶたいに"
    line "ひがいをだすことなく"
    line "1にちいないに"
    line "てきのソウコウユソウシャを"
    line "ぜんめつさせよ。"
    skip 1
    line "こうげきをするとき"
    line "イニシアティブのおおきいほうが"
    line "さきにこうげきできます。"
    line "せんとうでは"
    line "せんせいこうげきをしたほうが"
    line "ゆうりです。"
    skip 2
    line "イニシアティブは"
    line "いどうすることによって"
    line "しょうひするので,"
    line "とおくからいどうして"
    line "こうげきをすると,"
    line "てきのせんせいこうげきを"
    line "うけやすくなります。"
    skip 1
    line "せんとうあいてをえらぶときに"
    line "せんせいこうげきできるばあい"
    line "カーソルがあおになり,"
    line "てきのほうに"
    line "せんせいこうげきされるときは"
    line "あかになり,"
    line "どうじのときはしろになります。"
    skip 1
    line "ユニットじょうほうがめんで"
    line "「イニシアティブ」をえらぶと"
    line "くわしいじょうほうを"
    line "みることができます。"    done

.beginner16:
    text "「えんしゅう16」"
    skip 1
    line "1にちいないに"
    line "てきのぶたいを"
    line "ぜんめつさせよ。"
    skip 3
    line "てきのユニットにたいして"
    line "こうげきするユニットのばしょや"
    line "じゅんばんによって"
    line "せんとうけっかが"
    line "おおきくかわります。"
    skip 3
    line "このえんしゅうでは"
    line "ただしくてきをほういし,"
    line "あいしょうをかんがえて"
    line "せんせいこうげきをするなど,"
    line "もっともこうりつよく"
    line "せんとうを"
    line "おこなうひつようがあります。"
    skip 1
    line "ユニットのあいしょうについては"
    line "「えんしゅう2」を,"
    line "ほういこうかにかんしては"
    line "「えんしゅう13」を,"
    line "イニシアティブにかんしては"
    line "「えんしゅう15」を"
    line "さんこうにしてください。"    done

.standard00:
    text "99にちいないに"
    line "てきのしゅとをせんりょう"
    line "もしくは,てきのぶたいを"
    line "ぜんめつさせよ。"    done

    section_end $5c15
