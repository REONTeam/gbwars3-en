include "macros/macros.inc"
include "charmaps/char_main.inc"

setcharmap main

; Complete Bank $34 Campaign briefing extension.
;
; This file is the authoritative source for every relocated Campaign briefing
; and result message. The opening messages use the custom English text; all
; remaining entries preserve their original Japanese wording as editable
; plaintext until they are translated. The relocation directory in campaign_briefing_relocations.asm
; points into the labels defined here.

; Expanded English first Campaign pre-map briefing.
;
; relocated the original 129-byte stream from $33:$4F3A to this
; otherwise-free Bank $34. replaces that untranslated Japanese
; stream with editable English source and deliberately uses the extra bank
; capacity for a fuller opening briefing.
;
; The viewer advances automatically after eight [LF] rows, so the text below
; is arranged as four compact pages. Keep individual rows at 18 characters or
; fewer to match the established briefing window. Bank $34:$7EF0-$7FFF is
; reserved for the generalized Campaign relocation directory ().
section "Campaign Introduction Bank 34", romx[$4000], bank[$34]
CampaignIntroductionBank34::
CampaignIntroductionBank34Payload::
    text "COMMANDER, REPORT!"
    line "WHITE MOON GROUND"
    line "FORCES ARE CLOSING"
    line "ON OUR POSITION."
    line "THEIR ADVANCE HAS"
    line "ALREADY BEGUN."
    line "WE CANNOT ALLOW"
    line "THEM BREAK THRU."

    line "MOVE OUT AT ONCE."
    line "INTERCEPT THEM NOW"
    line "HALT THEIR PUSH."
    line "SECURE THE AREA,"
    line "THEN STRIKE AT THE"
    line "ENEMY FRONT BASE."
    line "DESTROY IT TO WIN"
    line "THIS FIRST BATTLE."

    line "YOUR ARMY IS NEW."
    line "SO USE THE TERRAIN"
    line "KEEP UNITS CLOSE"
    line "WORKING TOGETHER."
    line "GUARD SUPPLIES"
    line "AND DO NOT WASTE"
    line "TIME OR FIREPOWER."
    line "EVERY DAY COUNTS."

    line "YOU HAVE 30 DAYS."
    line "IF THE ENEMY STILL"
    line "STANDS AFTER THAT,"
    line "OUR CAMPAIGN FAILS"
    line "THE WHOLE ARMY IS"
    line "COUNTING ON YOU."
    line "GOOD LUCK, SIR."
    done

CampaignIntroductionBank34End::
    assert CampaignIntroductionBank34End <= $7ef0

; /337 compatibility aliases.
DEF CampaignIntroductionExtension EQU CampaignIntroductionBank34Payload
DEF CampaignIntroductionExtensionEnd EQU CampaignIntroductionBank34End

; Expanded English Campaign briefing/result messages for the opening maps.
;
; The historical Bank $33 streams remain byte-authoritative source in
; campaign_briefing_text_bank33.asm.  The relocation directory selects these
; Bank $34 replacements at runtime, so the English text is not constrained by
; the original Japanese message sizes.
;
; covers the first two Campaign map indices in map order.  Result-B
; 00 and 01 are intentional empty streams and remain on Bank $33.

section "Campaign English Result A 00", romx[$4227], bank[$34]
CampaignBriefing_ResultA_00_English::
    text "CONGRATULATIONS!"
    line "YOUR COMMAND MADE"
    line "THE INTERCEPTION"
    line "A TOTAL SUCCESS."
    line "THE ENEMY HAS"
    line "FALLEN BACK TO"
    line "KWELL COAST."
    line "ADVANCE TO"
    line "KWELL COAST AND"
    line "PRESS THE ATTACK."
    done
CampaignBriefing_ResultA_00_EnglishEnd::
    assert @ == $42c3

section "Campaign English Pre-Map 01", romx[$42c3], bank[$34]
CampaignBriefing_PreMap_01_English::
    text "ENEMY SURVIVORS"
    line "HAVE REGROUPED."
    line "THEY ARE GATHERED"
    line "BEYOND THE FOREST"
    line "IN THE CENTER."
    line "BREAK THROUGH IT"
    line "AND DESTROY THEM."
    line "YOU HAVE 30 DAYS."
    line "IF THEY STILL"
    line "REMAIN AFTER THAT,"
    line "DEFEAT WILL FOLLOW"
    line "WE EXPECT SUCCESS."
    line "DO NOT FAIL US."
    done
CampaignBriefing_PreMap_01_EnglishEnd::
    assert @ == $43a2

section "Campaign English Result A 01", romx[$43a2], bank[$34]
CampaignBriefing_ResultA_01_English::
    text "THE ENEMY HAS"
    line "FALLEN BACK TOWARD"
    line "TABIMAHANA DESERT."
    line "MOVE ON THE DESERT"
    line "AND DESTROY THEM."
    done
CampaignBriefing_ResultA_01_EnglishEnd::
    assert @ == $43fb

DEF CampaignBriefing_EnglishMap00_01_End EQU $43fb
assert CampaignBriefing_EnglishMap00_01_End <= $7ef0

; Expanded English Campaign briefing/result messages for Campaign map 02.
;
; Historical Bank $33 streams remain byte-authoritative source. The Bank $34
; relocation directory selects these replacements at runtime, allowing natural
; English without the original Japanese per-message size limits.

section "Campaign English Result B 02", romx[$43fb], bank[$34]
CampaignBriefing_ResultB_02_English::
    text "THE DESERT ADVANCE"
    line "WAS DIFFICULT,"
    line "BUT OUR COUNTER"
    line "AT TABIMAHANA"
    line "DESERT SUCCEEDED."
    line "ENEMY FORCES FELL"
    line "BACK."
    line "NEXT, WE INTERCEPT"
    line "THE FORCE INVADING"
    line "RECOAN COAST."
    done
CampaignBriefing_ResultB_02_EnglishEnd::
    assert @ == $4499

section "Campaign English Pre-Map 02", romx[$4499], bank[$34]
CampaignBriefing_PreMap_02_English::
    text "THE ENEMY IS"
    line "ADVANCING FROM"
    line "TABIMAHANA DESERT."
    line "PRESS ACROSS THE"
    line "DESERT AND SECURE"
    line "AIR SUPERIORITY."
    line "DESTROY THE ENEMY."
    line "YOU HAVE 30 DAYS."
    line "IF THEY REMAIN,"
    line "IT MEANS DEFEAT."
    line "WE EXPECT SUCCESS."
    done
CampaignBriefing_PreMap_02_EnglishEnd::
    assert @ == $4555

section "Campaign English Result A 02", romx[$4555], bank[$34]
CampaignBriefing_ResultA_02_English::
    text "INTERCEPTION WAS"
    line "A SUCCESS."
    line "WITHOUT CONTROL"
    line "OF THE SKIES,"
    line "WHITE MOON HAS"
    line "ABANDONED ITS BASE"
    line "AND RETREATED TO"
    line "BEITON DESERT."
    line "BEGIN THE PURSUIT."
    done
CampaignBriefing_ResultA_02_EnglishEnd::
    assert @ == $45e4

DEF CampaignBriefing_EnglishMap02_End EQU $45e4
assert CampaignBriefing_EnglishMap02_End <= $7ef0

; Bank $34 copies of the historical Japanese Campaign briefing streams.
;
; Existing English replacements for the opening maps remain separate. Every
; other Campaign message preserves its exact historical Japanese wording as
; readable text/line source while gaining a Bank $34 relocation label. The messages share one contiguous
; section so later edits may grow or shrink individual streams without manually
; moving every following address.

section "Campaign Briefing Japanese Bank 34", romx[$45e4], bank[$34]
; Original Japanese Campaign briefing/result text retained as readable source.
; These strings intentionally preserve the retail Japanese wording and line layout.

CampaignBriefing_ResultB_00_Bank34::
    done

CampaignBriefing_ResultB_01_Bank34::
    done

CampaignBriefing_ResultB_03_Bank34::
    text "われわれのはんげきと"
    line "てききょてんのこうりゃくは"
    line "よそうがいのきかんとなった。"
    line ""
    line "そのため"
    line "つぎによていしていた"
    line "「ノルボがわ」ほうめんへの"
    line "こうげきをへんこうし"
    line "「ラッシアはんとう」への"
    line "こうりゃくをおこなう。"
    done

CampaignBriefing_ResultB_04_Bank34::
    text "はげしいせんとうのけっか"
    line "われわれは"
    line "「ベィトンさばく」こうりゃくに"
    line "せいこうした。"
    line ""
    line "しかしながら"
    line "とうしょのよていしていた"
    line "きかんをオーバーしたため"
    line "つぎにこうりゃくよていの"
    line "「サネヒがわ」こうりゃくを"
    line "ちゅうしした。"
    line ""
    line "そして,われわれは"
    line "つぎに「ノルボがわ」ほうめんの"
    line "こうりゃくをかいしすることと"
    line "なった。"
    done

CampaignBriefing_ResultB_05_Bank34::
    text "「サネヒがわ」のとっぱには"
    line "おもわぬじかんがかかったが"
    line "なんとかわれわれは"
    line "てききょてんをせいあつした。"
    line ""
    line ""
    line ""
    line ""
    line "われわれは,"
    line "「サネヒがわ」じょうりゅうの"
    line "「ノルボがわ」ほうめんへの"
    line "ついげきをかいしすることに"
    line "なった。"
    done

CampaignBriefing_ResultB_06_Bank34::
    text "「ラッシアはんとう」の"
    line "てきぐんのはいじょには"
    line "せいこうしたものの"
    line "てきのしゅりょくは"
    line "すでに「ノジーかいきょう」へと"
    line "こうたいしたあとだった。"
    line ""
    line ""
    line "われわれは,"
    line "このてきしゅりょくをたたくべく"
    line "「ノジーかいきょう」へとむかう。"
    done

CampaignBriefing_ResultB_07_Bank34::
    done

CampaignBriefing_ResultB_08_Bank34::
    done

CampaignBriefing_ResultB_09_Bank34::
    done

CampaignBriefing_ResultB_10_Bank34::
    text "てきのていこうははげしく"
    line "「リュウルかいがん」への"
    line "じょうりくは,なんこうした。"
    line ""
    line "しかし,なんとかかいきょうを"
    line "かくほしたわれわれは"
    line "つぎに「スォドかい」ほうめんに"
    line "むかうことになった。"
    done

CampaignBriefing_ResultB_11_Bank34::
    done

CampaignBriefing_ResultB_12_Bank34::
    text "「ティナンわん」からの"
    line "じょうりくさくせんは"
    line "よていじかんをオーバーしつつも"
    line "もくてきをたっせいした。"
    line ""
    line "つぎにわれわれは"
    line "「マリガーとう」をうかいし"
    line "「ギヨンかい」ほうめんから"
    line "じょうりくをおこなうことに"
    line "なった。"
    done

CampaignBriefing_ResultB_13_Bank34::
    text "「スォドかい」に"
    line "ちゅうりゅうするてきは"
    line "せいきょうをきわめ,"
    line "はげしいてきのこうせいに"
    line "われわれはじんだいな"
    line "ひがいをこうむったが"
    line "てきのげきはにせいこうした。"
    line ""
    line "そして"
    line "わがぐんのべつどうたいが"
    line "「リマはんとう」への"
    line "せいかいけんをかくほした。"
    line ""
    line "つぎにわれわれは"
    line "「リマはんとう」へと"
    line "ぜんしんをかいしする。"
    done

CampaignBriefing_ResultB_14_Bank34::
    text "「ライトウわん」の"
    line "てきかんたいは"
    line "おもいのほかてごわく"
    line "われわれはかなりの"
    line "せんりょくをうしなった。"
    line ""
    line ""
    line ""
    line "われわれがはんげきに"
    line "でたときには,すでに"
    line "てきかんたいのいちぶが"
    line "こうたいしていた。"
    line ""
    line "このてきをついげきするため"
    line "「タムタかいきょう」にむかい"
    line "かいきょうをふうさせよ。"
    done

CampaignBriefing_ResultB_15_Bank34::
    text "「リマはんとう」の"
    line "ながくのびきったせんせんは"
    line "りょうぐんにほきゅうの"
    line "ふたんをしいた。"
    line ""
    line "てきのげきはには"
    line "せいこうしたものの"
    line "よていがいのじかんが"
    line "けいかしていた。"
    line ""
    line "われわれは"
    line "ここをこうたいし"
    line "「ラミリズたいりく」へ"
    line "てんしんすることになった。"
    done

CampaignBriefing_ResultB_16_Bank34::
    text "「タムタかいきょう」の"
    line "かくほはせいこうした。"
    line "しかし,われわれの"
    line "げんざいのせんりょくでは,"
    line "せんせんのいじは"
    line "ふかのうである。"
    line ""
    line ""
    line "そのため"
    line "こうぞくにここをまかせ"
    line "われわれは"
    line "「イネンしっち」へと"
    line "てんしんすることになった。"
    done

CampaignBriefing_ResultB_17_Bank34::
    text "われわれは"
    line "「ミブロンはんとう」までの"
    line "きょてんをかくほした。"
    line ""
    line "そして,つぎに"
    line "「ラミリズたいりく」ほうめんに"
    line "とうにゅうされることになった。"
    done

CampaignBriefing_ResultB_18_Bank34::
    text "われわれは"
    line "はげしいたたかいのすえ"
    line "「ガリアンはんとう」への"
    line "じょうりくに"
    line "せいこうした。"
    line ""
    line ""
    line ""
    line "しかし,てきしゅりょくは"
    line "すでに「ガリアンはんとう」きたに"
    line "こうたいしていた。"
    line ""
    line "このまま"
    line "「バトマンかい」をおうだんし"
    line "てきのついげきをかいしせよ。"
    done

CampaignBriefing_ResultB_19_Bank34::
    done

CampaignBriefing_ResultB_20_Bank34::
    text "「ブダンはんとう」での"
    line "てきぐんのていこうは"
    line "よそうをうわまわる"
    line "はげしさだった。"
    line ""
    line "さらに,かいきょうをわたるのに"
    line "てまどったわがぐんは"
    line "じかんとせんりょくを"
    line "しょうもうした。"
    line ""
    line "われわれは,このはんとうを"
    line "おおきくうかいし"
    line "「ダズンわん」ほうめんからの"
    line "しんにゅうをかいしすることに"
    line "なった。"
    done

CampaignBriefing_ResultB_21_Bank34::
    text "かいきょうをわたるまえに"
    line "「スロボだいち」ほうめんからの"
    line "てききこうぶたいげきたいに"
    line "たいへんなじかんとせんりょくが"
    line "しょうもうしてしまった。"
    line ""
    line ""
    line ""
    line "そのため「ラミリズたいりく」"
    line "こうりゃくへの"
    line "あんぜんかくほのために"
    line "このまま,「スキムさばく」を"
    line "こうりゃくすることになった。"
    done

CampaignBriefing_ResultB_22_Bank34::
    text "「ダズンわん」の"
    line "てききょてんかくほは"
    line "いちおうせいこうし,てきは"
    line "「バドーさんみゃく」ほうめんへ"
    line "てったいしていった。"
    line ""
    line ""
    line ""
    line "このまま,われわれは"
    line "じょうりくきょてんから"
    line "「バドーさんみゃく」ほうめんへ"
    line "こうげきをかいしする。"
    done

CampaignBriefing_ResultB_23_Bank34::
    text "われわれは"
    line "てきのながくのびきった"
    line "ほきゅうのじゃくてんをつき"
    line "てきをげきはした。"
    line ""
    line ""
    line ""
    line ""
    line "しかし"
    line "「アッツわん」のてきから"
    line "かなりのそんがいをうけた。"
    line "そのため「ロンドさばく」での"
    line "さくせんにはさんかせず"
    line "「バドーさんみゃく」ほうめんへと"
    line "むかうことになった。"
    done

CampaignBriefing_ResultB_24_Bank34::
    done

CampaignBriefing_ResultB_25_Bank34::
    text "われわれは,しんこうルートを"
    line "さんみゃくにはばまれ"
    line "よそうがいのじかんを"
    line "しょうひしたものの"
    line "てきのげきはにせいこうした。"
    line ""
    line ""
    line ""
    line "ひとまずあんていした"
    line "このせんせんをあとにして"
    line "われわれはふたたび"
    line "「マリガーとう」へ"
    line "てんぞくとなった。"
    done

CampaignBriefing_ResultB_26_Bank34::
    done

CampaignBriefing_ResultB_27_Bank34::
    text "「マリガーとう」にしんにゅうした"
    line "てきぐんは,すでにきょうりょくな"
    line "ぼうえいたいせいを"
    line "ととのえていた。"
    line ""
    line "しかし,げきせんのすえ"
    line "われわれは,てききょてんを"
    line "げきはしせんりょうした。"
    line "きょてんをうしなったてきは"
    line "みなみへとこうたいした。"
    line ""
    line "われわれは"
    line "このてきをたたくべく"
    line "「マリガーとう」ちゅうおうぶから"
    line "「リドーンがわ」ほうめんへ"
    line "ぜんしんをかいしする。"
    done

CampaignBriefing_ResultB_28_Bank34::
    text "「ステンかいきょう」をおうだんし"
    line "「ミブロンはんとう」の"
    line "てききょてんをせんりょうした。"
    line ""
    line ""
    line ""
    line ""
    line ""
    line "ほきゅうルートをうしない"
    line "こりつした「マリガーとう」の"
    line "てきをたたくため,われわれは"
    line "「マリガーとう」ちゅうおうぶから"
    line "「リドーンがわ」ほうめんへ"
    line "ぜんしんをかいしすることに"
    line "なった。"
    done

CampaignBriefing_ResultB_29_Bank34::
    text "ちゅうおうぶの"
    line "こうはいしたとしぐんの"
    line "そうぜつなそうだつせんとなったが"
    line "われわれのしょうりとなった。"
    line ""
    line ""
    line ""
    line ""
    line "つぎに"
    line "わがぐんは「リレベかいろう」にて"
    line "おこなわれるさくせんを"
    line "ほじょするべく"
    line "「マケゾンあれち」ほうめんへと"
    line "しんぐんすることになった。"
    done

CampaignBriefing_ResultB_30_Bank34::
    text "「リドーンがわ」とっぱに"
    line "よそうがいの"
    line "じかんとせんりょくを"
    line "うしなってしまった。"
    line ""
    line "けっかとして,われわれの"
    line "しょうりになったものの"
    line "てきぐんのこうたいを"
    line "ゆるしてしまった。"
    line ""
    line "てきは「スリクさばく」に"
    line "せんりょくをしゅうけつしている。"
    line ""
    line "ただちに,ついげきし"
    line "このてきをげきはせよ。"
    done

CampaignBriefing_ResultB_31_Bank34::
    text "「マケゾンあれち」のとっぱに"
    line "てまどってしまった。"
    line ""
    line "ないりくのてきを"
    line "われわれがはいじょしたが"
    line "てきしゅりょくは,すでに"
    line "こうたいしていった。"
    line ""
    line "われわれは"
    line "このてきをたたくべく"
    line "「マリガーとう」ほうめんから"
    line "「サザーンかい」のこうりゃくを"
    line "おこなう。"
    done

CampaignBriefing_ResultB_32_Bank34::
    text "「リレベかいろう」のこうりゃくに"
    line "せいこうしたものの"
    line "よそうがいのじかんとせんりょくを"
    line "しょうもうしてしまった。"
    line ""
    line ""
    line ""
    line ""
    line "かいろうをこうたいしたてきは"
    line "「サザーンかい」ほうめんに"
    line "しゅうけつしている。"
    line "われわれは"
    line "このてきをたたくべく"
    line "「マリガーとう」ほうめんから"
    line "「サザーンかい」のこうりゃくを"
    line "おこなう。"
    done

CampaignBriefing_ResultB_33_Bank34::
    done

CampaignBriefing_ResultB_34_Bank34::
    done

CampaignBriefing_ResultB_35_Bank34::
    text "「ミブロンはんとう」に"
    line "そんざいする"
    line "ぜんてきぐんが"
    line "しゅうけつしていた。"
    line ""
    line ""
    line ""
    line ""
    line "はげしいせんとうのすえ"
    line "このてきをげきはし"
    line "わがぐんは「ミブロンはんとう」の"
    line "せいあつにせいこうした。"
    line ""
    line "これより,わがぐんは"
    line "かくちのざんぞんへいりょくの"
    line "そうとうさくせんにうつる。"
    done

CampaignBriefing_ResultB_36_Bank34::
    text "いりくむちけいに"
    line "くるしみつつも"
    line "てきぶたいのはいじょに"
    line "せいこうした。"
    line ""
    line "てきは,こうたいしつつ"
    line "たいりくからのだっしゅつを"
    line "ねらっている。"
    line "てきぶたいがほんごくへと"
    line "ごうりゅうするまえに"
    line "「ライアーわん」へじょうりくし"
    line "てきぶたいをたたけ。"
    done

CampaignBriefing_ResultB_37_Bank34::
    text "てきは「リレベかいろう」の"
    line "ざんぞんせいりょくとは"
    line "おもえぬほどのていこうを"
    line "おこなったが,われわれが"
    line "せいあつした。"
    line ""
    line ""
    line ""
    line "これで,てきのへいりょくは"
    line "てきほんごくである"
    line "「ニドヘグントウ」のみとなった。"
    line ""
    line "われわれは,つぎに"
    line "てきほんごくへの"
    line "ほじょさくせんをおこなう。"
    done

CampaignBriefing_ResultB_38_Bank34::
    text "てきは「ミブロンはんとう」の"
    line "ざんぞんせいりょくとは"
    line "おもえぬほどのていこうを"
    line "おこなったが,われわれが"
    line "せいあつした。"
    line ""
    line ""
    line ""
    line "これで,てきのへいりょくは"
    line "てきほんごくである"
    line "「ニドヘグントウ」のみとなった。"
    line ""
    line "われわれは,つぎに"
    line "てきほんごくへの"
    line "ほじょさくせんをおこなう。"
    done

CampaignBriefing_ResultB_39_Bank34::
    text "こうたいちゅうの"
    line "てきへのこうげきとはいえ"
    line "てきぜんじょうりくは"
    line "こんなんをきわめた。"
    line ""
    line "ただいなぎせいをはらいつつ"
    line "このてきをせいあつした。"
    line ""
    line "これで,てきのへいりょくは"
    line "てきほんごくである"
    line "「ニドヘグントウ」のみとなった。"
    line ""
    line "われわれは,つぎに"
    line "てきほんごくへの"
    line "ほじょさくせんをおこなう。"
    done

CampaignBriefing_ResultB_40_Bank34::
    done

CampaignBriefing_ResultB_41_Bank34::
    text "てきほんどのていこうは"
    line "ひじょうにはげしく"
    line "さくせんは"
    line "こんなんをきわめた。"
    line ""
    line ""
    line ""
    line ""
    line "だが,とうしょのよていどおり"
    line "じゅんびこうげきは"
    line "せいこうした。"
    line ""
    line "われわれは"
    line "せんりょくをととのえ"
    line "「プランB」にそなえるため"
    line "いちど,こうたいをおこなった。"
    done

CampaignBriefing_ResultB_42_Bank34::
    done

CampaignBriefing_ResultB_43_Bank34::
    done

CampaignBriefing_ResultB_44_Bank34::
    done

CampaignBriefing_PreMap_03_Bank34::
    text "「タビマハナサバク」★"
    line "トッパシタ テキガ"
    line "「レコアンカイガン」ニ"
    line "トウタツシタ"
    line ""
    line "カイガンニ ブタイ★テンカイシ"
    line "ナイリクノテキ★ ゲキハセヨ"
    line ""
    line "ナオ"
    line "30ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_04_Bank34::
    text "「ベィトンサバク」ヒガシニ"
    line "テキグンガ テンカイチュウ"
    line ""
    line "サバク★コエ テキ★ゲキハセヨ"
    line ""
    line "マタ"
    line "シュウヘンノ ケンチクブツ★"
    line "シュウフクシテ シヨウセヨ"
    line "ナオ"
    line "30ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_05_Bank34::
    text "テキハ"
    line "「サネヒガワ」キチカラノ"
    line "コウゲキ★ キカク シテイル"
    line ""
    line "テキブタイ オヨビ テキキチ★"
    line "ゲキハセヨ"
    line ""
    line ""
    line "ナオ"
    line "30ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_06_Bank34::
    text "テキグンハ「ラッシアハントウ」ノ"
    line "センタンカラ コウゲキ★"
    line "キカクシテイル"
    line ""
    line "ハントウ★クダリ テキグン★"
    line "ゲキハセヨ"
    line ""
    line ""
    line "ナオ"
    line "30ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_07_Bank34::
    text "テキノ ジュウヨウキョテン★"
    line "コノサクセンニテ タタク"
    line ""
    line "ジョウリクブタイ★ ヒキイテ"
    line "テキ★ ゲキハセヨ"
    line ""
    line ""
    line ""
    line "ナオ"
    line "30ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_08_Bank34::
    text "「ノルボガワ」 ショウメン ニテ"
    line "テキグンセンリョクノ ゾウダイガ"
    line "カクニン サレタ"
    line ""
    line "シュウケツチュウノ テキグン★"
    line "ホソクシ ゲキメツセヨ"
    line ""
    line ""
    line "ナオ"
    line "30ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_09_Bank34::
    text "テキノ ホキュウセン★"
    line "シャダン スル"
    line ""
    line "「ノジーカイキョウ」ノ"
    line "セイカイケン★ オサエ"
    line "テキ★ ゲキハセヨ"
    line ""
    line ""
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_10_Bank34::
    text "「リュウルカイガン」ニ"
    line "テキカンタイガ シュウケツチュウ"
    line "トノ ジョウホウ アリ"
    line ""
    line "テキカンタイ★ ゲキメツシ"
    line "「ノルボガワ」ホウメン ヘノ"
    line "ホキュウセン★ カクホセヨ"
    line ""
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_11_Bank34::
    text "「テーツガワ」ニ テキノ"
    line "センリョクガ カクニンサレタ"
    line ""
    line "ゼンメンノテキ★ ハイジョシツツ"
    line "テキノキョテン★ フンサイセヨ"
    line ""
    line ""
    line ""
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_12_Bank34::
    text "「ティナンワン」ニ テキノ"
    line "カンタイガ シュウケツチュウ"
    line ""
    line "テキカンタイ★ ゲキハシ"
    line "テウスナ カイガンカラ"
    line "ジョウリク★ オコナイ"
    line "テキノキョテン★ カクホセヨ"
    line ""
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_13_Bank34::
    text "「ノジーカイキョウ」★"
    line "ウシナッタ ホワイトムーン ハ"
    line "「スォドカイ」ノ セイカイケン★"
    line "シシュ スルベク コウセイ★"
    line "カイシシタ"
    line ""
    line "「スォドカイ」★ フウサシ マタ"
    line "テキノ キョテン★ ゲキハセヨ"
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_14_Bank34::
    text "「スォドカイ」ホウメンカラ"
    line "「ライトウワン」ニ"
    line "テキノ カンタイガ"
    line "シンニュウシタ"
    line ""
    line "コノ カンタイ★ ゲキハシ"
    line "テキノ キョテン★ カクホセヨ"
    line ""
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "キミノセイコウ★ キタイスル"
    done

CampaignBriefing_PreMap_15_Bank34::
    text "ワレワレハ 「リマハントウ」ノ"
    line "ジョウリクニ セイコウシタ"
    line ""
    line "ダガ テキノ ユウリョクナ"
    line "センリョクガ ワガグンゼンメンニ"
    line "シュウケツ シテイル"
    line ""
    line ""
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ノコリニッスウニ チュウイシツツ"
    line "「リマハントウ」ノ テキ★"
    line "ゲキタイセヨ"
    done

CampaignBriefing_PreMap_16_Bank34::
    text "「タムタカイキョウ」★ ワタリ"
    line "「ミブロンハントウ」ヘノ"
    line "キョテン★ カクホセヨ"
    line ""
    line "ナオ テキカンタイ"
    line "シュウケツノ ジョウホウアリ"
    line ""
    line "ジュウブンニ チュウイセヨ"
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル。"
    line ""
    line "キミノセイコウ★ キタイスル。"
    done

CampaignBriefing_PreMap_17_Bank34::
    text "「ライトウワン」カラ"
    line "ソウトウサレタ テキカンタイガ"
    line "シュウケツチュウ"
    line ""
    line "コノ テキカンタイ★ ゲキハシ"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line ""
    line "ナオ"
    line "32ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル。"
    line ""
    line "キミノセイコウ★ キタイスル。"
    done

CampaignBriefing_PreMap_18_Bank34::
    text "コレヨリ「ラミリズタイリク」ノ"
    line "コウリャク★ カイシスル"
    line ""
    line "カイキョウ★ オウダンシ"
    line "「ガリアンハントウ」ニ"
    line "ジョウリク★ オコナイ"
    line "ココ★ コウリャクセヨ"
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_19_Bank34::
    text "テキシュリョクガ"
    line "「ガリアンハントウ」ニ"
    line "シュウケツチュウ"
    line ""
    line "ワガグンハ ソノ コウハイ★"
    line "ツイテ 「イネンシッチ」ヘ"
    line "ジョウリク★ オコナイ"
    line "テキ★ ゲキハスル"
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_20_Bank34::
    text "「ブダンハントウ」ヘノ"
    line "ジョウリク★ カンコウスル"
    line ""
    line "ココニハ テキノ ユウリョクナ"
    line "センリョクガ カクニンサレテイル"
    line ""
    line ""
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_21_Bank34::
    text "テキシュリョクハ"
    line "「ガリアンハントウ」ニ"
    line "ヒキツケラレテイル"
    line ""
    line "コノスキニ 「バトマンカイ」★"
    line "オウダンシ テウスナ キョテン★"
    line "センリョウセヨ"
    line ""
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ナオ 「スロボダイチ」ホウメンノ"
    line "テキセンリョクニ チュウイセヨ"
    done

CampaignBriefing_PreMap_22_Bank34::
    text "「ガリアンハントウ」カラ"
    line "テッタイシタ テキカンタイ★"
    line "ホソクシ ゲキチンセヨ"
    line ""
    line "マタ 「ダズンワン」ニアル"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_23_Bank34::
    text "「アッツワン」ニ ニゲコンダ"
    line "テキカンタイ★ センメツシ"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    done

CampaignBriefing_PreMap_24_Bank34::
    text "「スロボダイチ」コウリャク★"
    line "ダンネンシ 「スキムサバク」ノ"
    line "コウリャク★カイシスル"
    line ""
    line "ナオ テキノ キコウブタイガ"
    line "カクニン サレテイル"
    line "チュウイ サレタシ"
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_25_Bank34::
    text "「スチムガワ」ホウメンカラノ"
    line "ザンゾンヘイリョクガ シュウケツ"
    line "シテイルトノ ジョウホウアリ"
    line ""
    line "テキハ ダッシュツノタメノ"
    line "ミナト★ カクホシヨウトシテイル"
    line ""
    line ""
    line "コノ ザンゾンヘイリョク★"
    line "ソウトウセヨ"
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    done

CampaignBriefing_PreMap_26_Bank34::
    text "「ロンドサバク」ニ テキノ"
    line "キコウブタイガ シュウケツチュウ"
    line ""
    line "コノ テキ★ ホソクセンメツセヨ"
    line ""
    line ""
    line ""
    line ""
    line "ナオ"
    line "34ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_27_Bank34::
    text "ホワイトムーンガ フタタビ"
    line "「マリガートウ」ニ"
    line "シンニュウシタ"
    line ""
    line "「ヤハラカイキョウ」★"
    line "オウダンシ"
    line "フタタビ「マリガートウ」★"
    line "ダッカンセヨ"
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_28_Bank34::
    text "「ラミリズタイリク」ホウメンデノ"
    line "セントウノアイダニ フタタビ"
    line "「ミブロンハントウ」ニ"
    line "テキガ シンニュウシタ"
    line ""
    line "カイキョウ★ オウダンシ"
    line "「ミブロンハントウ」★"
    line "フタタビ ダッカンセヨ"
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_29_Bank34::
    text "「マリガートウ」オヨビ"
    line "「ミブロンハントウ」ヘノ"
    line "ヨビサクセン★ オコナウ"
    line ""
    line "「ロバンサバク」ノ"
    line "コウリャク★ カイシスル"
    line ""
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_30_Bank34::
    text "「マリガートウ」ノ"
    line "チュウオウブ★ オサエル"
    line "テキキョテン★ コウリャクスル"
    line ""
    line "マズ"
    line "「リドーンガワ」★ オウダンシ"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_31_Bank34::
    text "ナイリクニ コウタイシタ テキハ"
    line "「マケゾンアレチ」マエニ"
    line "ボウギョジンチ★ コウチクシタ"
    line ""
    line "コノボウギョジンチ★ トッパシテ"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_32_Bank34::
    text "「リレベカイロウ」★ ワレワレガ"
    line "カクホシタバアイ"
    line "テキハ ホキュウセン★"
    line "ウシナウダロウ"
    line ""
    line "トウゼン テキノ テイコウモ"
    line "ハゲシイコトガ ヨソウサレル"
    line ""
    line "コノテキ★ ハイジョシ"
    line "「リレベカイロウ」★ カクホセヨ"
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_33_Bank34::
    text "「マリガートウ」チュウオウブデノ"
    line "ヨウドウニヨッテ ニシノ"
    line "カイガンヘノ ワガグンノ"
    line "ジョウリクハ セイコウシタ"
    line ""
    line "コノキョテン★カクダイシ"
    line "テキ★センメツセヨ"
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_34_Bank34::
    text "「マリガートウ」ノ コウリャクニ"
    line "セイコウシタ ワレワレハ"
    line "ツギニ 「ミブロンハントウ」ヘノ"
    line "ジョウリクニ ノリダシタ"
    line ""
    line "ゼンメンニ テンカイスル"
    line "テキカンタイ★ ハイジョシテ"
    line "「ミブロンハントウ」ヘノ"
    line "キョテン★ カクホセヨ"
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_35_Bank34::
    text "テキノ ホンキョチハ チカイ"
    line "シカシ ソノマエニ タチハダカル"
    line "「ビッスムサバク」★"
    line "トッパシナケレバ ナラナイ"
    line ""
    line "テキブタイ★ ハイジョシ"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line "ナオ"
    line "36ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_36_Bank34::
    text "「ラミリズタイリク」サイゴノ"
    line "テキ ホキュウキチ デアル"
    line "「リュウノハジマ」★ タタケ"
    line ""
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_37_Bank34::
    text "「リレベカイロウ」★ オオキク"
    line "ウカイシ テキガ タテコモル"
    line "「サキショトウ」★"
    line "コウリャクセヨ"
    line ""
    line ""
    line ""
    line ""
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_38_Bank34::
    text "「ミブロンハントウ」カラ"
    line "コウタイシタ テキガ"
    line "「ダムガングントウ」ニ"
    line "シュウケツ シテイル"
    line ""
    line "コレヨリ ワレワレハ"
    line "「ダムガングントウ」ノ"
    line "コウリャク★ カイシスル"
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_39_Bank34::
    text "テキハ コノタイリクカラ"
    line "ダッシュツ★ カイシシタ"
    line ""
    line "コノキニ ジョウジテ"
    line "テキゼンジョウリク★ カンコウシ"
    line "テキキョテン★ センリョウセヨ"
    line ""
    line ""
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_40_Bank34::
    text "テキホンキョチヘノ"
    line "ジュンビコウゲキ トシテ"
    line "「ガーゲンカイ」★ オウダンシ"
    line "「ニドヘグントウ」ヘノ"
    line "コウゲキ★ オコナウ"
    line ""
    line "トチュウ テキカンタイノ"
    line "シュツゲンガ ヨソウサレル"
    line "コレラ★ ハイジョシ"
    line "ジョウリクチテン★ カクホセヨ"
    line ""
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_41_Bank34::
    text "テキホンキョチヘノ"
    line "ジュンビコウゲキトシテ"
    line "「ブリダーカイ」★ オウダンシ"
    line "「ニドヘグントウ」ヘノコウゲキ★"
    line "オコナウ"
    line ""
    line "トチュウ テキカンタイノ"
    line "ボウガイガ ヨソウサレル"
    line "コレラ★ ハイジョシ テキキチ★"
    line "フンサイセヨ"
    line ""
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_42_Bank34::
    text "「メタロンカイ」★ オウダンシ"
    line "テキホンキョチデアル"
    line "「ニドヘグントウ」ヘノ"
    line "コウゲキ★ オコナウ"
    line ""
    line "テキノテイコウハ ハゲシイモノト"
    line "ヨソクサレル チュウイセヨ"
    line ""
    line "ナオ"
    line "38ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_43_Bank34::
    text "コレヨリ ワレワレハ"
    line "テキ ホワイトムーンノ"
    line "サイシュウ コウリャク サクセン"
    line "「プランB」★ ジッコウスル"
    line ""
    line "「ニドヘグントウ」ニシヨリ"
    line "ジョウリク★ カイシシ"
    line "テキシュト★ コウリャクセヨ"
    line "テキノ テイコウハ キワメテ"
    line "ハゲシイコトガ ヨソウサレルガ"
    line "カクイン ゼンリョクデ"
    line "コレ★ ハイジョセヨ"
    line ""
    line ""
    line ""
    line ""
    line "ナオ"
    line "40ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_44_Bank34::
    text "コレヨリ ワレワレハ"
    line "テキ ホワイトムーンノ"
    line "サイシュウ コウリャク サクセン"
    line "「プランA」★ ジッコウスル"
    line ""
    line "「ニドヘグントウ」キタヨリ"
    line "ジョウリク★ カイシシ"
    line "テキシュト★ コウリャクセヨ"
    line "テキノ テイコウハ キワメテ"
    line "ハゲシイコトガ ヨソウサレルガ"
    line "カクイン ゼンリョクデ"
    line "コレ★ ハイジョセヨ"
    line ""
    line ""
    line ""
    line ""
    line "ナオ"
    line "40ニチイナイニ テキ★"
    line "ゲキハデキナイバアイ"
    line "ワレワレノハイボクトナル"
    line ""
    line "ジュウブンニ チュウイセヨ"
    done

CampaignBriefing_PreMap_Extra45_Bank34::
    text "ざんねんながら"
    line "こんかいのさくせんは"
    line "しっぱいにおわった。"
    line ""
    line "しかし,このままでは"
    line "わがぐんのはいぼくは"
    line "ひっしである。"
    line ""
    line "せんじゅつをくふうし"
    line "ふたたびはんげきを"
    line "かいしせよ。"
    done

CampaignBriefing_ResultA_03_Bank34::
    text "ないりくぶのてきを"
    line "げきせんのすえに"
    line "くちくした。"
    line ""
    line "てきは"
    line "「ノルボがわ」ほうめんに"
    line "たいきゃくした。"
    line ""
    line "「ノルボがわ」にて"
    line "たいきゃくしたてきの"
    line "ついげきをかいしせよ。"
    done

CampaignBriefing_ResultA_04_Bank34::
    text "はげしいせんとうのけっか"
    line "われわれは"
    line "「ベィトンさばく」のとっぱに"
    line "せいこうした。"
    line ""
    line "つぎにわがぐんは"
    line "「サネヒがわ」ほうめんに"
    line "ぜんしんする。"
    done

CampaignBriefing_ResultA_05_Bank34::
    text "「サネヒがわ」のきょてんを"
    line "うしなったてきは"
    line "「ノルボがわ」ほうめんへ"
    line "こうたいした。"
    line ""
    line "さくせんはせいこうだ。"
    line "おめでとう。"
    done

CampaignBriefing_ResultA_06_Bank34::
    text "「ラッシアはんとう」へ"
    line "じょうりくしたてきぐんを"
    line "げきたいした。"
    line ""
    line "われわれは"
    line "「リュウルかいがん」ほうめんの"
    line "てきかんたいを"
    line "こうりゃくする。"
    done

CampaignBriefing_ResultA_07_Bank34::
    text "てきぐんは"
    line "「フレアーとう」ほうめんの"
    line "きょてんをうしなった。"
    line ""
    line "きみは"
    line "ぶたいをひきいて"
    line "つぎのせんせんにいどうせよ。"
    done

CampaignBriefing_ResultA_08_Bank34::
    text "はげしいたたかいのすえ"
    line "てききょてんを"
    line "せいあつした。"
    line ""
    line "きょてんをうしなった"
    line "てきぐんは,"
    line "「ティラジはんとう」からの"
    line "てったいをかいしした。"
    done

CampaignBriefing_ResultA_09_Bank34::
    text "「ノジーかいきょう」のかくほに"
    line "せいこうした。"
    line ""
    line "そのけっか"
    line "「ティナンわん」ほうめんへの"
    line "ルートをかくほした。"
    line ""
    line "さくせんはせいこうだ。"
    done

CampaignBriefing_ResultA_10_Bank34::
    text "「リュウルかいがん」のてきを"
    line "げきはした。"
    line ""
    line "そのけっか"
    line "ないりくぶの"
    line "「ノルボがわ」ほうめんへの"
    line "ほきゅうせんを"
    line "かくほした。"
    done

CampaignBriefing_ResultA_11_Bank34::
    text "「テーツがわ」のてきは"
    line "かいめつした。"
    line ""
    line "きょてんをうしなったてきは"
    line "「ライトウわん」ほうめんへと"
    line "こうたいした。"
    done

CampaignBriefing_ResultA_12_Bank34::
    text "「ティナンわん」の"
    line "てきかんたいは"
    line "かいめつした。"
    line ""
    line "これにより"
    line "「ジブリルとう」への"
    line "じょうりくが"
    line "かのうになった。"
    done

CampaignBriefing_ResultA_13_Bank34::
    text "てきのかんたいは"
    line "かいめつし,せいかいけんを"
    line "うしなった。"
    line ""
    line "これで"
    line "「ミブロンはんとう」への"
    line "あしがかりをつかんだ。"
    done

CampaignBriefing_ResultA_14_Bank34::
    text "「ライトウわん」に"
    line "たてこもっていた"
    line "てきはぜんめつした。"
    line ""
    line "われわれは"
    line "「レーフトゥンわん」への"
    line "ぜんしんを"
    line "かいしする。"
    done

CampaignBriefing_ResultA_15_Bank34::
    text "「リマはんとう」を"
    line "かくほしたことにより"
    line "「ジブリルとう」と"
    line "「マリガーとう」のあいだの"
    line "てきほきゅうせんを"
    line "ぶんだんした。"
    line ""
    line ""
    line "きみたちは,ふたたび"
    line "「ラミリズたいりく」へと"
    line "てんしんせよ。"
    done

CampaignBriefing_ResultA_16_Bank34::
    text "「ミブロンはんとう」に"
    line "ちゅうりゅうするてきぐんは"
    line "はげしくていこうしたが"
    line "われわれは"
    line "このてきのはいじょに"
    line "せいこうした。"
    line ""
    line ""
    line "そして,ふたたび"
    line "「ラミリズたいりく」へ"
    line "むかうことになった。"
    done

CampaignBriefing_ResultA_17_Bank34::
    text "「レーフトゥンわん」の"
    line "せいあつにせいこうした。"
    line ""
    line "われわれは"
    line "「ロバンさばく」へと"
    line "むかうことになった。"
    done

CampaignBriefing_ResultA_18_Bank34::
    text "われわれは"
    line "はげしいたたかいのすえ"
    line "「ガリアンはんとう」への"
    line "じょうりくに"
    line "せいこうした。"
    line ""
    line ""
    line ""
    line "このまま"
    line "「バトマンかい」をおうだんし"
    line "「ダズンわん」ほうめんに"
    line "にげこんだてきのついげきを"
    line "かいしせよ。"
    done

CampaignBriefing_ResultA_19_Bank34::
    text "てきはいごへの"
    line "じょうりくにせいこうした。"
    line ""
    line "そのけっか"
    line "「ガリアンはんとう」にいる"
    line "てきはこりつした。"
    line ""
    line ""
    line "われわれはこのまま"
    line "「ダズンわん」ほうめんに"
    line "こうげきをかいしする。"
    done

CampaignBriefing_ResultA_20_Bank34::
    text "「ブダンはんとう」への"
    line "われわれのじょうりくは"
    line "せいこうした。"
    line ""
    line "さらに"
    line "たいがんのてききちの"
    line "せいあつにせいこうした。"
    line ""
    line "これでわれわれは"
    line "「アッツわん」のあんぜんを"
    line "かくほした。"
    done

CampaignBriefing_ResultA_21_Bank34::
    text "「スロボだいち」のてきぐんが"
    line "われわれのそくめんに"
    line "とうたつするまえに"
    line "てききょてんをせいあつした。"
    line ""
    line "きょてんをうしなったてきは"
    line "「ダズンわん」へ"
    line "こうたいした。"
    line "「ダズンわん」にむかい"
    line "てきをげきはせよ。"
    done

CampaignBriefing_ResultA_22_Bank34::
    text "「ダズンわん」の"
    line "てきかんたいを"
    line "げきたいした。"
    line ""
    line "また"
    line "てききちのせんりょうも"
    line "どうじにせいこうした。"
    line ""
    line "われわれは"
    line "「バドーさんみゃく」をこえ"
    line "「ラミリズたいりく」へ"
    line "むかう。"
    done

CampaignBriefing_ResultA_23_Bank34::
    text "てきは"
    line "わがぐんのこうげきにより"
    line "「ブダンはんとう」での"
    line "せんりょくときょてんを"
    line "うしなった。"
    line ""
    line ""
    line ""
    line "てきぐんは"
    line "「ロンドさばく」ほうめんへ"
    line "こうたいしていった。"
    done

CampaignBriefing_ResultA_24_Bank34::
    text "てきの"
    line "「スキムさばく」きちを"
    line "せんりょうした。"
    line ""
    line "きょてんをうしなったてきは"
    line "「リマはんとう」から"
    line "てったいした。"
    done

CampaignBriefing_ResultA_25_Bank34::
    text "「バドーさんみゃく」をこえ"
    line "てきのきょてんを"
    line "せんりょうした。"
    line ""
    line "これで"
    line "「ラミリズたいりく」から"
    line "てきをげきたいすることに"
    line "せいこうした。"
    done

CampaignBriefing_ResultA_26_Bank34::
    text "てきのこうくうぶたいが"
    line "あらわれたが"
    line "せいあつにせいこうした。"
    line ""
    line "「ラミリズたいりく」は"
    line "わがぐんが,かんぜんに"
    line "せんりょうした。"
    done

CampaignBriefing_ResultA_27_Bank34::
    text "われわれは"
    line "「ヤハラかいきょう」の"
    line "おうだんにせいこうした。"
    line ""
    line "ふたたび"
    line "「マリガーとう」に"
    line "きょてんをかくほした。"
    done

CampaignBriefing_ResultA_28_Bank34::
    text "「ステンかいきょう」の"
    line "てきかんたいを,げきはし"
    line "てききょてんを"
    line "せんりょうした。"
    line ""
    line "ふたたび"
    line "「ミブロンはんとう」へ"
    line "きょてんをかくほした。"
    done

CampaignBriefing_ResultA_29_Bank34::
    text "よそうより"
    line "きょうりょくなてきぐんが"
    line "「ロバンさばく」に"
    line "ちゅうとんしていたが"
    line "このてきぐんのげきはに"
    line "せいこうした。"
    line ""
    line ""
    line "「ロバンさばく」を"
    line "おさえたことで"
    line "てきほきゅうせんの"
    line "ぶんだんにせいこうした。"
    line ""
    line "「リレベかいろう」より"
    line "こうげきをかいしせよ。"
    done

CampaignBriefing_ResultA_30_Bank34::
    text "「リドーンがわ」の"
    line "ぜんめんにてんかいする"
    line "てきぶたいをはいじょし"
    line "てききょてんのせいあつに"
    line "せいこうした。"
    done

CampaignBriefing_ResultA_31_Bank34::
    text "「マケゾンあれち」の"
    line "てきぶたいをはいじょした。"
    line ""
    line "われわれは"
    line "てききょてんのせんりょうに"
    line "せいこうした。"
    done

CampaignBriefing_ResultA_32_Bank34::
    text "てきは"
    line "はげしくていこうしたが"
    line "はげしいたたかいのすえ"
    line "とうしょのもくひょうを"
    line "かくほした。"
    line ""
    line ""
    line ""
    line "われわれは"
    line "「ミブロンはんとう」の"
    line "みなみほうめんの"
    line "「ビッスムさばく」に"
    line "しんげきをかいしする。"
    done

CampaignBriefing_ResultA_33_Bank34::
    text "「マリガーとう」に"
    line "ちゅうりゅうする"
    line "てきかんたいおよび"
    line "「スリクさばく」にひそむ"
    line "てききこうぶたいを"
    line "しりぞけた。"
    line ""
    line ""
    line "これで「マリガーとう」の"
    line "てきせんりょくは"
    line "ぜんめつした。"
    done

CampaignBriefing_ResultA_34_Bank34::
    text "われわれは"
    line "「サザーンかい」をわたり"
    line "「ミブロンはんとう」への"
    line "じょうりくをはたした。"
    line ""
    line "そして,このさくせんにより"
    line "「ミブロンはんとう」の"
    line "せんせんは,あんていした。"
    line "つぎにわれわれは"
    line "「ラミリズたいりく」へ"
    line "はけんされることになった。"
    done

CampaignBriefing_ResultA_35_Bank34::
    text "われわれは,ついに"
    line "「ミブロンはんとう」の"
    line "せいあつにせいこうした。"
    line ""
    line "「ミブロンはんとう」を"
    line "おわれたてきぐんは"
    line "「ダムガンぐんとう」に"
    line "しゅうけつしている。"
    line "このてきを"
    line "ただちにげきはせよ。"
    done

CampaignBriefing_ResultA_36_Bank34::
    text "いりくむちけいに"
    line "くるしみつつも"
    line "てきぶたいのはいじょに"
    line "せいこうした。"
    line ""
    line ""
    line ""
    line ""
    line "つぎにわれわれは"
    line "「サキしょとう」への"
    line "ぞうえんとして"
    line "はけんされる。"
    done

CampaignBriefing_ResultA_37_Bank34::
    text "いりくむちけいに"
    line "くるしみつつも"
    line "てきぶたいのはいじょに"
    line "せいこうした。"
    line ""
    line "これで"
    line "このたいりくのてきを"
    line "かんぜんにげきたいした。"
    done

CampaignBriefing_ResultA_38_Bank34::
    text "いりくむちけいに"
    line "くるしみつつも"
    line "てきぶたいのはいじょに"
    line "せいこうした。"
    line ""
    line "これにて"
    line "このかいいきのせいかいけんを"
    line "てにいれた。"
    done

CampaignBriefing_ResultA_39_Bank34::
    text "てきぜんじょうりくは"
    line "こんなんをきわめたが"
    line "せいこうした。"
    line ""
    line "これで"
    line "このたいりくのてきを"
    line "かんぜんにげきたいした。"
    done

CampaignBriefing_ResultA_40_Bank34::
    text "てきほんどのていこうは"
    line "ひじょうにはげしく"
    line "さくせんは"
    line "こんなんをきわめた。"
    line ""
    line ""
    line ""
    line ""
    line "だが"
    line "とうしょのよていどおり"
    line "いちおうのせいこうを"
    line "かくほし,こうたいした。"
    done

CampaignBriefing_ResultA_41_Bank34::
    text "てきほんどのていこうは"
    line "ひじょうにはげしく"
    line "さくせんは"
    line "こんなんをきわめた。"
    line ""
    line ""
    line ""
    line ""
    line "だが"
    line "とうしょのよていどおり"
    line "いちおうのせいこうを"
    line "かくほし,こうたいした。"
    done

CampaignBriefing_ResultA_42_Bank34::
    text "「メタロンかい」の"
    line "てきかんたいげきめつに"
    line "せいこうし,"
    line "じょうりくようのきょてんを"
    line "かくほした。"
    line ""
    line ""
    line ""
    line "いよいよ"
    line "てきほんきょちへの"
    line "ほんかくてきじょうりくである。"
    done

CampaignBriefing_ResultA_43_Bank34::
    done

CampaignBriefing_ResultA_44_Bank34::
    done

CampaignBriefing_Bank34JapaneseEnd::
    assert CampaignBriefing_Bank34JapaneseEnd <= $7ef0
