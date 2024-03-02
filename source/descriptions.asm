include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "descriptions.asm", romx[$58aa], bank[$32]
Description_Strings:
    dw .infantry
    dw .infantry
    dw .missile_infantry
    dw .mercenary_infantry
    dw .construction_truck
    dw .supply_truck
    dw .supply_truck_s
    dw .transport_truck
    dw .transport_truck_s
    dw .combat_buggy
    dw .combat_buggy_s
    dw .combat_vehicle
    dw .combat_vehicle_s
    dw .apc
    dw .apc_s
    dw .rocket_launcher
    dw .rocket_launcher_s
    dw .anti_air_tank
    dw .mercenary_anti_air_missiles
    dw .anti_air_missiles
    dw .anti_air_missiles_s
    dw .artillery
    dw .artillery_s
    dw .ifv
    dw .ifv_s
    dw .tank_destroyer
    dw .tank_destroyer_s
    dw .tank
    dw .mercenary_tank
    dw .fighter_plane_a
    dw .fighter_plane_b
    dw .fighter_plane_s
    dw .attack_plane_a
    dw .attack_plane_b
    dw .attack_plane_s
    dw .bomber
    dw .mercenary_bomber
    dw .transport_plane
    dw .refueling_plane
    dw .battle_helicopter
    dw .battle_helicopter_s
    dw .anti_sub_helicopter
    dw .transport_helicopter
    dw .transport_helicopter_s
    dw .aegis_warship
    dw .mercenary_missile_frigate
    dw .large_carrier
    dw .small_carrier
    dw .transport_ship
    dw .supply_tanker
    dw .submarine
    dw .submarine_s
	dw .HQ
	dw .city
	dw .base
	dw .airport
	dw .port
	dw .com_tower
	dw .temporary_airport
	dw .city_ruins
	dw .base_ruins
	dw .airport_ruins
	dw .port_ruins
	dw .plain
	dw .mountain
	dw .wood
	dw .wasteland
	dw .desert
	dw .road
	dw .river
	dw .bridge
	dw .shoal
	dw .sea

.infantry:
    text "たてものをせんりょうする"
    line "のうりょくがある。"
    skip 1
    line "こうげきりょく•ぼうぎょりょく"
    line "ともにとてもひくい。"
    done

.missile_infantry:
    text "たてものをせんりょうする"
    line "のうりょくがある。"
    skip 1
    line "そうこうユニットにたいして"
    line "かんせつこうげきできる。"
    line "ぼうぎょりょくがとてもひくい。"
    skip 1
    line "また,いどうりょくもひくい。"
    done

.mercenary_infantry:
    text "たてものをせんりょうする"
    line "のうりょくがある。"
    skip 1
    line "いどうりょくがたかく"
    line "ウミもいどうできる。"
    skip 1
    line "モバイルシステムGBの"
    line "せんようユニットのため"
    line "せいさんすることはできない。"
    done

.construction_truck:
    text "けんちくにより"
    line "たてもののたいきゅうどをあげたり"
    line "ホウカイしたしせつをふっきゅう"
    line "できる。"
    skip 1
    line "けんせつにより"
    line "カンイクウコウ•ドウロ•ハシをつくり"
    line "アレチ•モリをヘイチにかえることが"
    line "できる。"
    skip 1
    line "こうげきりょくはひくい。"
    skip 1
    line "コウサクシャを"
    line "せいさんできるのはコウジョウのみ。"
    skip 1
    line "ほきゅう•ほじゅうは"
    line "シュト•コウジョウでおこなう。"
    done

.supply_truck:
    text "りくユニットや"
    line "ヘリ•コウゲキキBなどの"
    line "そらユニットに"
    line "ねんりょう•だんやくをほきゅうする。"
    line "こうげきりょくはない。"
    skip 1
    line "ホキュウシャをせいさんできるのは"
    line "コウジョウのみ。"
    skip 1
    line "ほきゅう•ほじゅうは"
    line "シュト•コウジョウでおこなう。"
    skip 1
    line "「ホキュウシャS」に"
    line "しんかする。"
    done

.supply_truck_s:
    text "ホキュウシャがしんかしたユニットで"
    line "ホキュウブッシがおおい。"
    skip 1
    line "りくユニットや"
    line "ヘリ•コウゲキキBなどの"
    line "そらユニットに"
    line "ねんりょう•だんやくをほきゅうする。"
    line "こうげきりょくはない。"
    skip 1
    line "ほきゅう•ほじゅうは"
    line "シュト•コウジョウでおこなう。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.transport_truck:
    text "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "ドウロはとおくまでいどうできるが"
    line "アレチではそれほどいどうできない。"
    skip 1
    line "こうげきりょく•ぼうぎょりょくともに"
    line "とてもひくい。"
    skip 1
    line "「ユソウトラックS」に"
    line "しんかする。"
    done

.transport_truck_s:
    text "ユソウトラックがしんかしたユニット。"
    skip 1
    line "ユソウトラックよりも"
    line "こうげきりょくがあるが"
    line "せんとうにはちゅういがひつよう。"
    skip 1
    line "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "ドウロはとおくまでいどうできるが"
    line "アレチではそれほどいどうできない。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.combat_buggy:
    text "ドウロのうえでは"
    line "とおくまでいどうできる。"
    skip 1
    line "ぶそう1のグレネードは"
    line "ひそうこうユニットにたいし"
    line "とてもつよい。"
    skip 1
    line "しかし,"
    line "ぼうぎょりょくがとてもひくく"
    line "そうこうユニットによわい。"
    skip 1
    line "「コンバットバギーS」に"
    line "しんかする。"
    done

.combat_buggy_s:
    text "コンバットバギーの"
    line "こうげきりょくを"
    line "きょうかしたもの。"
    skip 1
    line "ぼうぎょりょくはひくいが"
    line "そうこうユニットには"
    line "こうげきりょくがたしょうある。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.combat_vehicle:
    text "いどうりょくがたかく"
    line "そうこうユニットにたいして"
    line "こうげきりょくがある。"
    line "ぼうぎょりょくはとてもひくい。"
    skip 1
    line "「セントウシャリョウS」に"
    line "しんかする。"
    done

.combat_vehicle_s:
    text "セントウシャリョウの"
    line "ひそうこうユニットにたいする"
    line "こうげきりょくをきょうかしたもの。"
    skip 1
    line "いどうりょくがたかく"
    line "そうこうユニットにたいして"
    line "こうげきりょくがある。"
    line "ぼうぎょりょくはとてもひくい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.apc:
    text "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "たしょうのぼうぎょりょくと"
    line "ホヘイユニットにたいする"
    line "たかいこうげきりょくがある。"
    line "そうこうユニットにはよわい。"
    skip 1
    line "「ソウコウユソウシャS」に"
    line "しんかする。"
    done

.apc_s:
    text "ソウコウユソウシャの"
    line "こうげきりょくを"
    line "きょうかしたもの。"
    skip 1
    line "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "ホヘイユニットにたいする"
    line "たかいこうげきりょくがある。"
    line "そうこうユニットにたいする"
    line "こうげきりょくもあるが"
    line "ぼうぎょりょくがひくい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.rocket_launcher:
    text "はなれたところから"
    line "りくユニット•うみユニットに"
    line "かんせつこうげきできる。"
    skip 1
    line "ひそうこうユニットにたいする"
    line "こうげきりょくがたかい。"
    skip 1
    line "ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "「RランチャーS」に"
    line "しんかする。"
    done

.rocket_launcher_s:
    text "Rランチャーの"
    line "しゃていといりょくを"
    line "きょうかしたもの。"
    skip 1
    line "はなれたところから"
    line "りくユニット•うみユニットに"
    line "かんせつこうげきできる。"
    skip 1
    line "ひそうこうユニットにたいする"
    line "こうげきりょくがとてもたかい。"
    skip 1
    line "ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.anti_air_tank:
    text "そらユニットにたいし"
    line "こうげきできるユニット。"
    skip 1
    line "ぶそうのキカンホウBー4は"
    line "ひそうこうユニットにも"
    line "こうげきりょくがたかい。"
    done

.mercenary_anti_air_missiles:
    text "そらユニットにたいし"
    line "こうげきできるユニット。"
    skip 1
    line "タイクウセンシャの"
    line "こうげきりょくを"
    line "きょうかしたもの。"
    skip 1
    line "ぶそうのキカンホウSは"
    line "ひそうこうユニットにも"
    line "こうげきりょくがとてもたかい。"
    skip 1
    line "モバイルシステムGBの"
    line "せんようユニットのため"
    line "せいさんすることはできない。"
    done

.anti_air_missiles:
    text "そらユニットにたいし"
    line "こうげきできるユニット。"
    skip 1
    line "はなれたところから"
    line "そらユニットに"
    line "かんせつこうげきができる。"
    skip 1
    line "りくユニットにたいする"
    line "こうげきりょくがない。"
    line "また,ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "「タイクウミサイルS」に"
    line "しんかする。"
    done

.anti_air_missiles_s:
    text "タイクウミサイルの"
    line "しゃていをきょうかしたもの。"
    skip 1
    line "はなれたところから"
    line "そらユニットに"
    line "かんせつこうげきができる。"
    skip 1
    line "りくユニットにたいする"
    line "こうげきりょくがない。"
    line "また,ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.artillery:
    text "はなれたところから"
    line "りくユニット•うみユニットに"
    line "かんせつこうげきできる。"
    skip 1
    line "そうこうユニットにたいする"
    line "こうげきりょくがたかい。"
    skip 1
    line "ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "「ジソウホウS」に"
    line "しんかする。"
    done

.artillery_s:
    text "ジソウホウの"
    line "しゃていといりょくを"
    line "きょうかしたもの。"
    skip 1
    line "はなれたところから"
    line "りくユニット•うみユニットに"
    line "かんせつこうげきできる。"
    skip 1
    line "そうこうユニットにたいする"
    line "こうげきりょくがとてもたかい。"
    skip 1
    line "ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.ifv:
    text "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "そうこうユニットにたいする"
    line "ぼうぎょりょくがあるので"
    line "そうこうユニットにたいしても"
    line "あるていどたたかえる。"
    skip 1
    line "「ホヘイセントウシャS」に"
    line "しんかする。"
    done

.ifv_s:
    text "ホヘイセントウシャの"
    line "しゃていを"
    line "きょうかしたユニット。"
    skip 1
    line "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "そうこうユニットにたいして"
    line "しゃていはみじかいが"
    line "かんせつこうげきできる。"
    line "ぼうぎょりょくもある。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.tank_destroyer:
    text "センシャとくらべて"
    line "こうげきりょくはおとるが"
    line "ねだんがやすい。"
    skip 1
    line "りくユニットにたいして"
    line "バランスよくつよい。"
    skip 1
    line "「クチクセンシャS」に"
    line "しんかする。"
    done

.tank_destroyer_s:
    text "クチクセンシャの"
    line "こうげきりょくとしゃていを"
    line "きょうかしたユニット。"
    skip 1
    line "そうこうユニットにたいして"
    line "しゃていはみじかいが"
    line "かんせつこうげきできる。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.tank:
    text "そうこう•ひそうこうユニットをとわず"
    line "こうげきりょく•ぼうぎょりょくが"
    line "バランスよくつよい。"
    skip 1
    line "しかし,そらユニットのこうげきや"
    line "ジソウホウにはよわい。"
    done

.mercenary_tank:
    text "そうこうユニットにたいし"
    line "こうげきりょく•ぼうぎょりょくが"
    line "もっともつよい。"
    skip 1
    line "しかし,そらユニットのこうげきや"
    line "ジソウホウにはよわい。"
    skip 1
    line "モバイルシステムGBの"
    line "せんようユニットのため"
    line "せいさんすることはできない。"
    done

.fighter_plane_a:
    text "そらユニットにたいし"
    line "ぜつだいなこうげきりょくをもつ。"
    skip 1
    line "りくユニットにたいする"
    line "こうげきりょくはそれほどではない。"
    skip 1
    line "ながいきょりをいどうするので"
    line "イニシアティブにちゅうい。"
    done

.fighter_plane_b:
    text "そらユニットにたいし"
    line "たかいこうげきりょくをもつ。"
    skip 1
    line "りくユニットにたいする"
    line "こうげきりょくはそれほどではない。"
    skip 1
    line "ながいきょりをいどうするので"
    line "イニシアティブにちゅうい。"
    skip 1
    line "「セントウキS」に"
    line "しんかする。"
    done

.fighter_plane_s:
    text "セントウキBの"
    line "しゃていを"
    line "きょうかしたユニット。"
    skip 1
    line "たいくうせんとうせんようで"
    line "はなれたところから"
    line "そらユニットに"
    line "かんせつこうげきができる。"
    skip 1
    line "ながいきょりをいどうするので"
    line "イニシアティブにちゅうい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.attack_plane_a:
    text "りくユニットにたいし"
    line "ぜつだいなこうげきりょくをもつ。"
    line "しかしセントウキにはよわい。"
    skip 1
    line "ながいきょりをいどうするので"
    line "イニシアティブにちゅうい。"
    done

.attack_plane_b:
    text "りくユニットにたいし"
    line "たかいこうげきりょくをもつ。"
    line "しかしセントウキにはよわい。"
    skip 1
    line "ながいきょりをいどうするので"
    line "イニシアティブにちゅうい。"
    skip 1
    line "ホキュウシャから"
    line "ほきゅうをうけることができる。"
    skip 1
    line "「コウゲキキS」に"
    line "しんかする。"
    done

.attack_plane_s:
    text "コウゲキキBのしんかしたユニット。"
    line "たいちこうげきようだが"
    line "うみユニットにたいする"
    line "こうげきりょくもある。"
    skip 1
    line "てきユニットの"
    line "えいきょうをむししてHEXに"
    line "しんにゅうできる。"
    skip 1
    line "セントウキにはよわいので"
    line "ちゅういがひつよう。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.bomber:
    text "ばくげきで,しせつ•ちけいを"
    line "はかいすることができる。"
    skip 1
    line "また,こうげきはんいの"
    line "りくユニット•うみユニットにも"
    line "ダメージをあたえられる。"
    skip 1
    line "ぼうぎょりょくがひくい。"
    done

.mercenary_bomber:
    text "ばくげきで,しせつ•ちけいを"
    line "はかいすることができる。"
    skip 1
    line "また,こうげきはんいの"
    line "りくユニット•うみユニットにも"
    line "ダメージをあたえられる。"
    skip 1
    line "てきユニットの"
    line "えいきょうをむししてHEXに"
    line "しんにゅうすることができる。"
    skip 1
    line "モバイルシステムGBの"
    line "せんようユニットのため"
    line "せいさんすることはできない。"
    done

.transport_plane:
    text "ひそうこうユニットを2ぶたい"
    line "とうさいできる。"
    skip 1
    line "ぼうぎょりょくがとてもひくい。"
    done

.refueling_plane:
    text "セントウキとコウゲキキにたいして"
    line "ほきゅうできる。"
    skip 1
    line "ただし,コウゲキキBには"
    line "ほきゅうできない。"
    skip 1
    line "ぼうぎょりょくがとてもひくい。"
    done

.battle_helicopter:
    text "りくユニットにたいし"
    line "たかいこうげきりょくをもつ。"
    line "しかし,セントウキにはよわい。"
    skip 1
    line "ホキュウシャから"
    line "ほきゅうをうけることができる。"
    skip 1
    line "「コウゲキヘリS」に"
    line "しんかする。"
    done

.battle_helicopter_s:
    text "コウゲキヘリの"
    line "こうげきりょくとしゃていを"
    line "きょうかしたユニット。"
    skip 1
    line "りくユニットにたいする"
    line "ぜつだいなこうげきりょくをもつ。"
    line "しかし,セントウキにはよわい。"
    skip 1
    line "ホキュウシャから"
    line "ほきゅうをうけることができる。"
    skip 1
    line "そうこうユニットにたいして"
    line "かんせつこうげきができる。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.anti_sub_helicopter:
    text "センスイカンにたいして"
    line "こうげきができる。"
    skip 1
    line "また,りくユニットにたいしても"
    line "たしょうこうげきりょくがある。"
    skip 1
    line "ホキュウシャから"
    line "ほきゅうをうけることができる。"
    skip 1
    line "セントウキにはよわい。"
    done

.transport_helicopter:
    text "ホヘイユニットを1ぶたい"
    line "とうさいできる。"
    skip 1
    line "りくユニットにたいしても"
    line "たしょうこうげきりょくがある。"
    skip 1
    line "ぼうぎょりょくがひくく"
    line "セントウキにはよわい。"
    skip 1
    line "ホキュウシャから"
    line "ほきゅうをうけることができる。"
    skip 1
    line "「ユソウヘリS」に"
    line "しんかする。"
    done

.transport_helicopter_s:
    text "ホヘイユニットを2ぶたい"
    line "とうさいできる。"
    skip 1
    line "りくユニットにたいする"
    line "こうげきりょくがたかい。"
    skip 1
    line "ホキュウシャから"
    line "ほきゅうをうけることができる。"
    skip 1
    line "ぼうぎょりょくがひくいので"
    line "ちゅういがひつよう。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.aegis_warship:
    text "はなれたところから"
    line "うみユニットを"
    line "かんせつこうげきできる。"
    line "また,たいくうこうげきもかのう。"
    skip 1
    line "ただし,センスイカンには"
    line "こうげきできない。"
    done

.mercenary_missile_frigate:
    text "ばくげきで,しせつ•ちけいを"
    line "はかいすることができる。"
    skip 1
    line "また,こうげきはんいの"
    line "りくユニット•うみユニットにも"
    line "ダメージをあたえられる。"
    skip 1
    line "はなれたところから"
    line "そらユニットをこうげきすることが"
    line "できる。"
    skip 1
    line "ただし,センスイカンには"
    line "こうげきすることができない。"
    skip 1
    line "モバイルシステムGBの"
    line "せんようユニットのため"
    line "せいさんすることはできない。"
    done

.large_carrier:
    text "セントウキ•コウゲキキ•ヘリなど"
    line "4ぶたいをとうさいかのう。"
    line "また,とうさいしているユニットに"
    line "ほじゅう•ほきゅうができる。"
    skip 1
    line "そらユニットにたいして"
    line "はなれたところからこうげきできる。"
    skip 1
    line "イージスカン•センスイカンなどに"
    line "たいへんよわい。"
    done

.small_carrier:
    text "セントウキ•コウゲキキ•ヘリなど"
    line "3ぶたいをとうさいかのう。"
    line "また,とうさいしているユニットに"
    line "ほじゅう•ほきゅうができる。"
    skip 1
    line "そらユニットにたいして"
    line "はなれたところからこうげきできる。"
    skip 1
    line "イージスカン•センスイカンなどに"
    line "たいへんよわい。"
    done

.transport_ship:
    text "りくユニットを3ぶたい"
    line "とうさいできる。"
    skip 1
    line "とうさいは"
    line "ミナト•アサセでのみ"
    line "おこなう。"
    skip 1
    line "こうげきりょく•ぼうぎょりょくともに"
    line "うみユニットのなかで"
    line "とてもひくい。"
    done

.supply_tanker:
    text "うみユニットにたいして"
    line "ウミのうえでほきゅうできる。"
    skip 1
    line "ただし,センスイカンには"
    line "ほきゅうできない。"
    skip 1
    line "こうげきりょくがなく"
    line "また,ぼうぎょりょくも"
    line "うみユニットのなかで"
    line "とてもひくい。"
    done

.submarine:
    text "はなれたところから"
    line "うみユニットにたいして"
    line "かんせつこうげきできる。"
    skip 1
    line "ちょくせつこうげきようの"
    line "ぶきをそうびしていないので"
    line "てきユニットのせっきんにちゅうい。"
    skip 1
    line "タイセンヘリによわい。"
    skip 1
    line "「センスイカンS」に"
    line "しんかする。"
    done

.submarine_s:
    text "センスイカンがしんかしたユニットで"
    line "ばくげきで,しせつ•ちけいを"
    line "はかいすることができる。"
    skip 1
    line "また,こうげきはんいの"
    line "りくユニット•うみユニットにも"
    line "ダメージをあたえられる。"
    skip 1
    line "キンセツギョライで"
    line "ちょくせつこうげきできる。"
    skip 1
    line "タイセンヘリによわい。"
    skip 1
    line "しんかユニットのため"
    line "せいさんすることはできない。"
    done

.HQ:
    text "じぐん•てきぐんのそうしれいぶです。"
    line "てきのしゅとをせんりょうすると"
    line "そのMAPは"
    line "しょうりしたことになります。"
    skip 1
    line "ホキュウシャとコウサクシャをのぞく"
    line "りくユニットのせいさんができます。"
    line "また,すべてのりくユニットの"
    line "ほきゅう•ほじゅうができます。"
    skip 1
    line "たいきゅうどにおうじた"
    line "シキンがはいります。"
    skip 1
    line "コウサクシャによって"
    line "たいきゅうどをさいだい400まで"
    line "あげることができます。"
    line "また,たいきゅうどにおうじて"
    line "ユニットのほじゅうするかずが"
    line "きまります。"
    skip 1
    line "ばくげきによるほうかいはしませんが"
    line "たいきゅうどは1までへります。"
    done

.city:
    text "じぐんのトシは"
    line "ホキュウシャ•コウサクシャをのぞく"
    line "りくユニットのほきゅう•ほじゅうが"
    line "できます。"
    skip 1
    line "シュトから3HEXいないのトシは"
    line "ホキュウシャ•コウサクシャをのぞく"
    line "りくユニットのせいさんができます。"
    skip 1
    line "たいきゅうどにおうじた"
    line "シキンがはいります。"
    skip 1
    line "コウサクシャによって"
    line "たいきゅうどをさいだい300まで"
    line "あげることができます。"
    line "また,たいきゅうどにおうじて"
    line "ユニットのほじゅうするかずが"
    line "きまります。"
    skip 1
    line "ばくげきでたいきゅうどをうしなうと"
    line "ホウカイトシとなります。"
    done

.base:
    text "じぐんのコウジョウは"
    line "すべてのりくユニットの"
    line "ほきゅう•ほじゅうができます。"
    skip 1
    line "シュトから3HEXいないの"
    line "コウジョウは"
    line "すべてのりくユニットのせいさんが"
    line "できます。"
    skip 1
    line "たいきゅうどにおうじた"
    line "シザイがはいります。"
    skip 1
    line "コウサクシャによって"
    line "たいきゅうどをさいだい300まで"
    line "あげることができます。"
    line "また,たいきゅうどにおうじて"
    line "ユニットのほじゅうするかずが"
    line "きまります。"
    skip 1
    line "ばくげきでたいきゅうどをうしなうと"
    line "ホウカイコウジョウとなります。"
    done

.airport:
    text "じぐんのクウコウは"
    line "そらユニットのほきゅう•ほじゅうが"
    line "できます。"
    skip 1
    line "シュトから3HEXいないのクウコウは"
    line "そらユニットのせいさんができます。"
    skip 1
    line "たいきゅうどにおうじた"
    line "シキンがはいります。"
    skip 1
    line "コウサクシャによって"
    line "たいきゅうどをさいだい300まで"
    line "あげることができます。"
    line "また,たいきゅうどにおうじて"
    line "ユニットのほじゅうするかずが"
    line "きまります。"
    skip 1
    line "バクゲキでたいきゅうどをうしなうと"
    line "ホウカイクウコウとなります。"
    done

.port:
    text "じぐんのミナトは"
    line "うみユニットのほきゅう•ほじゅうが"
    line "できます。"
    skip 1
    line "シュトから3HEXいないのミナトは"
    line "うみユニットのせいさんができます。"
    skip 1
    line "たいきゅうどにおうじた"
    line "シキンがはいります。"
    skip 1
    line "コウサクシャによって"
    line "たいきゅうどをさいだい300まで"
    line "あげることができます。"
    line "また,たいきゅうどにおうじて"
    line "ユニットのほじゅうするかずが"
    line "きまります。"
    skip 1
    line "バクゲキでたいきゅうどをうしなうと"
    line "ホウカイミナトとなります。"
    done

.com_tower:
    text "モバイルシステムGBの"
    line "せんようしせつです。"
    skip 1
    line "じぐんのツウシントウは "
    line "つうしんでヨウヘイブタイを"
    line "よぶことができます。"
    skip 1
    line "コウサクシャによって"
    line "さいだいたいきゅうどを300まで"
    line "あげることができます。"
    skip 1
    line "ばくげきによるほうかいはしませんが"
    line "たいきゅうどは1までへります。"
    done

.temporary_airport:
    text "カンイクウコウは"
    line "コウサクシャでつくることができます。"
    skip 1
    line "つくることができるちけいは"
    line "ヘイチ•モリ•アレチです。"
    skip 1
    line "そらユニットのほきゅうをおこなう"
    line "ことができます。"
    line "ほじゅうをおこなうことはできません。"
    skip 1
    line "コウサクシャによって"
    line "さいだいたいきゅうどを200まで"
    line "あげることができます。"
    line "ただし,たいきゅうどをあげても"
    line "シキン•シザイなどのしゅうにゅうは"
    line "ありません。"
    skip 1
    line "ばくげきでたいきゅうどをうしなうと"
    line "ヘイチとなります。"
    done

.city_ruins:
    text "ほうかいしたトシです。"
    skip 1
    line "しょぞくは"
    line "ちゅうりつトシのあつかいです。"
    line "ほきゅう•ほじゅうはおこなえません。"
    skip 1
    line "ほうかいしたトシのふっきゅうは"
    line "コウサクシャでおこないます。"
    skip 1
    line "ふっきゅうしたトシは"
    line "じぐんのしょゆうになります。"
    done

.base_ruins:
    text "ほうかいしたコウジョウです。"
    skip 1
    line "しょぞくは"
    line "ちゅうりつコウジョウのあつかいです。"
    line "ほきゅう•ほじゅうはおこなえません。"
    skip 1
    line "ほうかいしたコウジョウのふっきゅうは"
    line "コウサクシャでおこないます。"
    skip 1
    line "ふっきゅうしたコウジョウは"
    line "じぐんのしょゆうになります。"
    done

.airport_ruins:
    text "ほうかいしたクウコウです。"
    skip 1
    line "しょぞくは"
    line "ちゅうりつクウコウのあつかいです。"
    line "ほきゅう•ほじゅうはおこなえません。"
    skip 1
    line "ほうかいしたクウコウのふっきゅうは"
    line "コウサクシャでおこないます。"
    skip 1
    line "ふっきゅうしたクウコウは"
    line "じぐんのしょゆうになります。"
    done

.port_ruins:
    text "ほうかいしたミナトです。"
    skip 1
    line "しょぞくは"
    line "ちゅうりつミナトのあつかいです。"
    line "ほきゅう•ほじゅうはおこなえません。"
    skip 1
    line "ほうかいしたミナトのふっきゅうは"
    line "コウサクシャでおこないます。"
    skip 1
    line "ふっきゅうしたミナトは"
    line "じぐんのしょゆうになります。"
    done

.plain:
    text "すべてのりくユニットが"
    line "いどうできます。"
    skip 1
    line "ドウロよりもすこしぼうぎょこうかが"
    line "きたいできます。"
    skip 1
    line "コウサクシャのけんせつにより"
    line "カンイクウコウやドウロをつくることが"
    line "できます。"
    skip 1
    line "バクゲキにより"
    line "アレチにかわります。"
    done

.mountain:
    text "りくユニットのほとんどが"
    line "いどうにせいやくをうけます。"
    skip 1
    line "りくユニットのなかには"
    line "しんにゅうできないユニットも"
    line "あります。"
    skip 1
    line "しかし"
    line "ヤマにしんにゅうできるユニットは"
    line "ぼうぎょこうかがとてもたかく"
    line "なります。"
    skip 1
    line "ばくげきのえいきょうをうけません。"
    done

.wood:
    text "りくユニットのほとんどが"
    line "いどうにせいやくをうけます。"
    skip 1
    line "ぼうぎょこうかは"
    line "ヘイチにくらべてたいへんたかく"
    line "なります。"
    skip 1
    line "コウサクシャのけんせつにより"
    line "ヘイチ•カンイクウコウ•ドウロを"
    line "つくることができます。"
    skip 1
    line "ばくげきにより"
    line "ヘイチにかわります。"
    done

.wasteland:
    text "りくユニットのほとんどが"
    line "いどうにただいなせいやくを"
    line "うけます。"
    skip 1
    line "ぼうぎょこうかは"
    line "ヘイチにくらべてたしょうたかく"
    line "なります。"
    skip 1
    line "コウサクシャのけんせつにより"
    line "ヘイチ•カンイクウコウ•ドウロを"
    line "つくることができます。"
    skip 1
    line "ばくげきのえいきょうをうけません。"
    done

.desert:
    text "りくユニットのほとんどが"
    line "いどうにせいやくをうけます。"
    skip 1
    line "ぼうぎょこうかは"
    line "ヘイチにくらべてすこしたかく"
    line "なります。"
    skip 1
    line "けんせつをおこなうことはできません。"
    done

.road:
    text "すべてのりくユニットが"
    line "いどうできます。"
    skip 1
    line "ぼうぎょこうかはありません。"
    skip 1
    line "ばくげきにより"
    line "アレチにかわります。"
    done

.river:
    text "りくユニットのほとんどが"
    line "いどうにせいやくをうけます。"
    skip 1
    line "りくユニットのなかには"
    line "しんにゅうできないユニットも"
    line "あります。"
    skip 1
    line "ぼうぎょこうかはありません。"
    skip 1
    line "コウサクシャのけんせつにより"
    line "ハシをかけることができます。"
    done

.bridge:
    text "すべてのりくユニットが"
    line "いどうできます。"
    skip 1
    line "ぼうぎょこうかはありません。"
    skip 1
    line "ばくげきによりカワにかわります。"
    skip 1
    line "また,ユニットがのっているハシを"
    line "ばくげきでおとすと"
    line "のっていたユニットは"
    line "しょうめつします。"
    done

.shoal:
    text "いちぶのりくユニットと"
    line "うみユニットのうち"
    line "ユソウカンのみがいどうできます。"
    skip 1
    line "うみ•りくユニットのほとんどは"
    line "しんにゅうできません。"
    skip 1
    line "ばくげきのえいきょうをうけません。"
    done

.sea:
    text "すべてのうみユニットが"
    line "いどうできます。"
    skip 1
    line "りくユニットのほとんどは"
    line "しんにゅうできません。"
    skip 1
    line "ばくげきのえいきょうをうけません。"
    done

section "Gas_Explanation_Pointer", romx[$5884], bank[$32]
    dw $7b6b

section "Initiative_Explanation_Pointer", romx[$5891], bank[$32]
    dw $7c93

section "Promotion_Explanation_Pointer", romx[$589e], bank[$32]
    dw $7d22

section "Gas_Explanation", romx[$7b6b], bank[$32]
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
