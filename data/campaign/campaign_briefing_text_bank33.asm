; Campaign briefing/result text payloads in physical Bank $33.
;
; converts the complete pointer-addressed block into byte-authoritative
; per-message source without translating it. The supplied custom-English build
; and Japanese retail base are byte-identical over $33:$4000-$7460, confirming
; these historical Campaign messages were still untranslated. Each section ends
; at the next pointer target, so every stream can be translated independently in
; later work while preserving stable symbolic table entries.

section "Campaign Briefing ResultB 00", romx[$4000], bank[$33]
CampaignBriefing_ResultB_00::
    db $00
    assert @ == $4001

section "Campaign Briefing ResultB 01", romx[$4001], bank[$33]
CampaignBriefing_ResultB_01::
    db $00
    assert @ == $4002

section "Campaign Briefing ResultB 02", romx[$4002], bank[$33]
CampaignBriefing_ResultB_02::
    db $6b, $9d, $68, $79, $74, $af, $a2, $76, $73, $7f, $9c, $af, $70, $8e, $01, $1b
    db $c0, $ee, $cf, $ca, $c5, $6b, $9d, $68, $1d, $9b, $79, $01, $7a, $8d, $91, $67
    db $7a, $6e, $62, $6a, $63, $6c, $01, $73, $67, $7a, $6a, $63, $70, $62, $6c, $73
    db $62, $af, $70, $2e, $01, $01, $01, $01, $01, $72, $8f, $76, $8c, $8a, $8c, $8a
    db $7a, $01, $1b, $da, $ba, $b1, $dd, $66, $62, $8e, $8d, $1d, $7e, $63, $82, $8d
    db $76, $01, $6c, $8d, $76, $ad, $63, $6c, $70, $73, $67, $7d, $79, $01, $91, $62
    db $91, $67, $60, $65, $6a, $75, $63, $2e, $00
    assert @ == $406b

section "Campaign Briefing ResultB 03", romx[$406b], bank[$33]
CampaignBriefing_ResultB_03::
    db $8c, $8a, $8c, $8a, $79, $7a, $8d, $91, $67, $74, $01, $73, $67, $67, $ae, $73
    db $8d, $79, $6a, $63, $88, $ac, $68, $7a, $01, $86, $6f, $63, $8e, $62, $79, $67
    db $66, $8d, $74, $75, $af, $70, $2e, $01, $01, $6f, $79, $70, $82, $01, $72, $8f
    db $76, $86, $73, $62, $6c, $73, $62, $70, $01, $1b, $c9, $d9, $f1, $8e, $8c, $1d
    db $7e, $63, $82, $8d, $7d, $79, $01, $6a, $63, $91, $67, $60, $7d, $8d, $6a, $63
    db $6c, $01, $1b, $d7, $ff, $bc, $b1, $7a, $8d, $74, $63, $1d, $7d, $79, $01, $6a
    db $63, $88, $ac, $68, $60, $65, $6a, $75, $63, $2e, $00
    assert @ == $40d6

section "Campaign Briefing ResultB 04", romx[$40d6], bank[$33]
CampaignBriefing_ResultB_04::
    db $7a, $91, $6c, $62, $6e, $8d, $74, $63, $79, $69, $af, $66, $01, $8c, $8a, $8c
    db $8a, $7a, $01, $1b, $f0, $f8, $c4, $dd, $6b, $9d, $68, $1d, $6a, $63, $88, $ac
    db $68, $76, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $6c, $66, $6c, $75
    db $8e, $87, $01, $74, $63, $6c, $ae, $79, $86, $73, $62, $6c, $73, $62, $70, $01
    db $67, $66, $8d, $60, $b5, $2d, $ed, $2d, $6c, $70, $70, $82, $01, $72, $8f, $76
    db $6a, $63, $88, $ac, $68, $86, $73, $62, $79, $01, $1b, $bb, $c8, $cb, $8e, $8c
    db $1d, $6a, $63, $88, $ac, $68, $60, $01, $71, $ad, $63, $6c, $6c, $70, $2e, $01
    db $01, $6f, $6c, $73, $2c, $8c, $8a, $8c, $8a, $7a, $01, $72, $8f, $76, $1b, $c9
    db $d9, $f1, $8e, $8c, $1d, $7e, $63, $82, $8d, $79, $01, $6a, $63, $88, $ac, $68
    db $60, $66, $62, $6c, $6d, $89, $6a, $74, $74, $01, $75, $af, $70, $2e, $00
    assert @ == $4175

section "Campaign Briefing ResultB 05", romx[$4175], bank[$33]
CampaignBriefing_ResultB_05::
    db $1b, $bb, $c8, $cb, $8e, $8c, $1d, $79, $74, $af, $a2, $76, $7a, $01, $65, $83
    db $8c, $77, $94, $66, $8d, $8e, $66, $66, $af, $70, $8e, $01, $75, $8d, $74, $66
    db $8c, $8a, $8c, $8a, $7a, $01, $73, $67, $67, $ae, $73, $8d, $60, $6e, $62, $61
    db $72, $6c, $70, $2e, $01, $01, $01, $01, $01, $8c, $8a, $8c, $8a, $7a, $2c, $01
    db $1b, $bb, $c8, $cb, $8e, $8c, $1d, $94, $ae, $63, $88, $ad, $63, $79, $01, $1b
    db $c9, $d9, $f1, $8e, $8c, $1d, $7e, $63, $82, $8d, $7d, $79, $01, $72, $62, $91
    db $67, $60, $66, $62, $6c, $6d, $89, $6a, $74, $76, $01, $75, $af, $70, $2e, $00
    assert @ == $41e5

section "Campaign Briefing ResultB 06", romx[$41e5], bank[$33]
CampaignBriefing_ResultB_06::
    db $1b, $d7, $ff, $bc, $b1, $7a, $8d, $74, $63, $1d, $79, $01, $73, $67, $90, $8d
    db $79, $7a, $62, $94, $ae, $76, $7a, $01, $6e, $62, $6a, $63, $6c, $70, $83, $79
    db $79, $01, $73, $67, $79, $6c, $ad, $88, $ae, $68, $7a, $01, $6d, $9b, $76, $1b
    db $c9, $e4, $2d, $66, $62, $67, $ae, $63, $1d, $7d, $74, $01, $6a, $63, $70, $62
    db $6c, $70, $61, $74, $98, $af, $70, $2e, $01, $01, $01, $8c, $8a, $8c, $8a, $7a
    db $2c, $01, $6a, $79, $73, $67, $6c, $ad, $88, $ae, $68, $60, $70, $70, $68, $a0
    db $68, $01, $1b, $c9, $e4, $2d, $66, $62, $67, $ae, $63, $1d, $7d, $74, $81, $66
    db $63, $2e, $00
    assert @ == $4258

section "Campaign Briefing ResultB 07", romx[$4258], bank[$33]
CampaignBriefing_ResultB_07::
    db $00
    assert @ == $4259

section "Campaign Briefing ResultB 08", romx[$4259], bank[$33]
CampaignBriefing_ResultB_08::
    db $00
    assert @ == $425a

section "Campaign Briefing ResultB 09", romx[$425a], bank[$33]
CampaignBriefing_ResultB_09::
    db $00
    assert @ == $425b

section "Campaign Briefing ResultB 10", romx[$425b], bank[$33]
CampaignBriefing_ResultB_10::
    db $73, $67, $79, $73, $62, $6a, $63, $7a, $7a, $91, $6c, $68, $01, $1b, $d8, $fd
    db $b3, $d9, $66, $62, $8e, $8d, $1d, $7d, $79, $01, $94, $ae, $63, $88, $68, $7a
    db $2c, $75, $8d, $6a, $63, $6c, $70, $2e, $01, $01, $6c, $66, $6c, $2c, $75, $8d
    db $74, $66, $66, $62, $67, $ae, $63, $60, $01, $66, $68, $7e, $6c, $70, $8c, $8a
    db $8c, $8a, $7a, $01, $72, $8f, $76, $1b, $bd, $fb, $ec, $66, $62, $1d, $7e, $63
    db $82, $8d, $76, $01, $81, $66, $63, $6a, $74, $76, $75, $af, $70, $2e, $00
    assert @ == $42ba

section "Campaign Briefing ResultB 11", romx[$42ba], bank[$33]
CampaignBriefing_ResultB_11::
    db $00
    assert @ == $42bb

section "Campaign Briefing ResultB 12", romx[$42bb], bank[$33]
CampaignBriefing_ResultB_12::
    db $1b, $c3, $f8, $c5, $dd, $8c, $8d, $1d, $66, $87, $79, $01, $94, $ae, $63, $88
    db $68, $6b, $68, $6e, $8d, $7a, $01, $86, $73, $62, $94, $66, $8d, $60, $b5, $2d
    db $ed, $2d, $6c, $72, $72, $83, $01, $83, $68, $73, $67, $60, $70, $af, $6e, $62
    db $6c, $70, $2e, $01, $01, $72, $8f, $76, $8c, $8a, $8c, $8a, $7a, $01, $1b, $cf
    db $d8, $de, $2d, $74, $63, $1d, $60, $63, $66, $62, $6c, $01, $1b, $df, $d6, $dd
    db $66, $62, $1d, $7e, $63, $82, $8d, $66, $87, $01, $94, $ae, $63, $88, $68, $60
    db $65, $6a, $75, $63, $6a, $74, $76, $01, $75, $af, $70, $2e, $00
    assert @ == $4328

section "Campaign Briefing ResultB 13", romx[$4328], bank[$33]
CampaignBriefing_ResultB_13::
    db $1b, $bd, $fb, $ec, $66, $62, $1d, $76, $01, $71, $ad, $63, $88, $ad, $63, $6d
    db $89, $73, $67, $7a, $01, $6e, $62, $67, $ae, $63, $60, $67, $8c, $82, $2c, $01
    db $7a, $91, $6c, $62, $73, $67, $79, $6a, $63, $6e, $62, $76, $01, $8c, $8a, $8c
    db $8a, $7a, $94, $8d, $98, $62, $75, $01, $7b, $8e, $62, $60, $6a, $63, $81, $af
    db $70, $8e, $01, $73, $67, $79, $91, $67, $7a, $76, $6e, $62, $6a, $63, $6c, $70
    db $2e, $01, $01, $6f, $6c, $73, $01, $8c, $8e, $90, $8d, $79, $a0, $72, $9c, $63
    db $70, $62, $8e, $01, $1b, $d8, $cf, $7a, $8d, $74, $63, $1d, $7d, $79, $01, $6e
    db $62, $66, $62, $69, $8d, $60, $66, $68, $7e, $6c, $70, $2e, $01, $01, $72, $8f
    db $76, $8c, $8a, $8c, $8a, $7a, $01, $1b, $d8, $cf, $7a, $8d, $74, $63, $1d, $7d
    db $74, $01, $96, $8d, $6c, $8d, $60, $66, $62, $6c, $6d, $89, $2e, $00
    assert @ == $43c6

section "Campaign Briefing ResultB 14", romx[$43c6], bank[$33]
CampaignBriefing_ResultB_14::
    db $1b, $d7, $b2, $c4, $b3, $8c, $8d, $1d, $79, $01, $73, $67, $66, $8d, $70, $62
    db $7a, $01, $65, $83, $62, $79, $7e, $66, $73, $92, $8c, $68, $01, $8c, $8a, $8c
    db $8a, $7a, $66, $75, $88, $79, $01, $6e, $8d, $88, $ae, $68, $60, $63, $6c, $75
    db $af, $70, $2e, $01, $01, $01, $01, $8c, $8a, $8c, $8a, $8e, $7a, $8d, $91, $67
    db $76, $01, $9b, $70, $74, $67, $76, $7a, $2c, $6d, $9b, $76, $01, $73, $67, $66
    db $8d, $70, $62, $79, $62, $71, $9f, $8e, $01, $6a, $63, $70, $62, $6c, $73, $62
    db $70, $2e, $01, $01, $6a, $79, $73, $67, $60, $72, $62, $91, $67, $6d, $89, $70
    db $82, $01, $1b, $c0, $d1, $c0, $66, $62, $67, $ae, $63, $1d, $76, $81, $66, $62
    db $01, $66, $62, $67, $ae, $63, $60, $7c, $63, $6b, $6e, $86, $2e, $00
    assert @ == $4454

section "Campaign Briefing ResultB 15", romx[$4454], bank[$33]
CampaignBriefing_ResultB_15::
    db $1b, $d8, $cf, $7a, $8d, $74, $63, $1d, $79, $01, $75, $8e, $68, $79, $9e, $67
    db $af, $70, $6e, $8d, $6e, $8d, $7a, $01, $88, $ae, $63, $90, $8d, $76, $7e, $67
    db $ad, $63, $79, $01, $7c, $70, $8d, $60, $6c, $62, $70, $2e, $01, $01, $73, $67
    db $79, $91, $67, $7a, $76, $7a, $01, $6e, $62, $6a, $63, $6c, $70, $83, $79, $79
    db $01, $86, $73, $62, $8e, $62, $79, $94, $66, $8d, $8e, $01, $69, $62, $66, $6c
    db $73, $62, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $01, $6a, $6a, $60, $6a
    db $63, $70, $62, $6c, $01, $1b, $d7, $d0, $d8, $e5, $70, $62, $88, $68, $1d, $7d
    db $01, $73, $8d, $6c, $8d, $6d, $89, $6a, $74, $76, $75, $af, $70, $2e, $00
    assert @ == $44d3

section "Campaign Briefing ResultB 16", romx[$44d3], bank[$33]
CampaignBriefing_ResultB_16::
    db $1b, $c0, $d1, $c0, $66, $62, $67, $ae, $63, $1d, $79, $01, $66, $68, $7e, $7a
    db $6e, $62, $6a, $63, $6c, $70, $2e, $01, $6c, $66, $6c, $2c, $8c, $8a, $8c, $8a
    db $79, $01, $91, $8d, $93, $62, $79, $6e, $8d, $88, $ae, $68, $9b, $7a, $2c, $01
    db $6e, $8d, $6e, $8d, $79, $62, $94, $7a, $01, $7c, $66, $79, $63, $9b, $61, $89
    db $2e, $01, $01, $01, $6f, $79, $70, $82, $01, $6a, $63, $97, $68, $76, $6a, $6a
    db $60, $7f, $66, $6e, $01, $8c, $8a, $8c, $8a, $7a, $01, $1b, $b2, $c8, $dd, $6c
    db $af, $71, $1d, $7d, $74, $01, $73, $8d, $6c, $8d, $6d, $89, $6a, $74, $76, $75
    db $af, $70, $2e, $00
    assert @ == $4547

section "Campaign Briefing ResultB 17", romx[$4547], bank[$33]
CampaignBriefing_ResultB_17::
    db $8c, $8a, $8c, $8a, $7a, $01, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d
    db $7f, $9b, $79, $01, $67, $ae, $73, $8d, $60, $66, $68, $7e, $6c, $70, $2e, $01
    db $01, $6f, $6c, $73, $2c, $72, $8f, $76, $01, $1b, $d7, $d0, $d8, $e5, $70, $62
    db $88, $68, $1d, $7e, $63, $82, $8d, $76, $01, $74, $63, $76, $ad, $63, $6b, $8a
    db $89, $6a, $74, $76, $75, $af, $70, $2e, $00
    assert @ == $4590

section "Campaign Briefing ResultB 18", romx[$4590], bank[$33]
CampaignBriefing_ResultB_18::
    db $8c, $8a, $8c, $8a, $7a, $01, $7a, $91, $6c, $62, $70, $70, $66, $62, $79, $6d
    db $64, $01, $1b, $de, $d8, $b1, $dd, $7a, $8d, $74, $63, $1d, $7d, $79, $01, $94
    db $ae, $63, $88, $68, $76, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $01
    db $01, $6c, $66, $6c, $2c, $73, $67, $6c, $ad, $88, $ae, $68, $7a, $01, $6d, $9b
    db $76, $1b, $de, $d8, $b1, $dd, $7a, $8d, $74, $63, $1d, $67, $70, $76, $01, $6a
    db $63, $70, $62, $6c, $73, $62, $70, $2e, $01, $01, $6a, $79, $7f, $7f, $01, $1b
    db $ed, $c4, $cf, $dd, $66, $62, $1d, $60, $65, $63, $98, $8d, $6c, $01, $73, $67
    db $79, $72, $62, $91, $67, $60, $66, $62, $6c, $6e, $86, $2e, $00
    assert @ == $460d

section "Campaign Briefing ResultB 19", romx[$460d], bank[$33]
CampaignBriefing_ResultB_19::
    db $00
    assert @ == $460e

section "Campaign Briefing ResultB 20", romx[$460e], bank[$33]
CampaignBriefing_ResultB_20::
    db $1b, $ef, $e8, $dd, $7a, $8d, $74, $63, $1d, $9b, $79, $01, $73, $67, $90, $8d
    db $79, $73, $62, $6a, $63, $7a, $01, $86, $6f, $63, $60, $63, $8c, $7f, $8c, $89
    db $01, $7a, $91, $6c, $6b, $98, $af, $70, $2e, $01, $01, $6b, $87, $76, $2c, $66
    db $62, $67, $ae, $63, $60, $8c, $70, $89, $79, $76, $01, $73, $7f, $9c, $af, $70
    db $8c, $8e, $90, $8d, $7a, $01, $94, $66, $8d, $74, $6e, $8d, $88, $ae, $68, $60
    db $01, $6c, $ae, $63, $83, $63, $6c, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a
    db $2c, $6a, $79, $7a, $8d, $74, $63, $60, $01, $65, $65, $67, $68, $63, $66, $62
    db $6c, $01, $1b, $e8, $e5, $dd, $8c, $8d, $1d, $7e, $63, $82, $8d, $66, $87, $79
    db $01, $6c, $8d, $76, $ad, $63, $60, $66, $62, $6c, $6d, $89, $6a, $74, $76, $01
    db $75, $af, $70, $2e, $00
    assert @ == $46a3

section "Campaign Briefing ResultB 21", romx[$46a3], bank[$33]
CampaignBriefing_ResultB_21::
    db $66, $62, $67, $ae, $63, $60, $8c, $70, $89, $7f, $64, $76, $01, $1b, $bd, $db
    db $f1, $98, $62, $71, $1d, $7e, $63, $82, $8d, $66, $87, $79, $01, $73, $67, $67
    db $6a, $63, $9f, $70, $62, $91, $67, $70, $62, $76, $01, $70, $62, $7d, $8d, $75
    db $94, $66, $8d, $74, $6e, $8d, $88, $ae, $68, $8e, $01, $6c, $ae, $63, $83, $63
    db $6c, $73, $6c, $7f, $af, $70, $2e, $01, $01, $01, $01, $6f, $79, $70, $82, $1b
    db $d7, $d0, $d8, $e5, $70, $62, $88, $68, $1d, $01, $6a, $63, $88, $ac, $68, $7d
    db $79, $01, $61, $8d, $96, $8d, $66, $68, $7e, $79, $70, $82, $76, $01, $6a, $79
    db $7f, $7f, $2c, $1b, $bd, $b7, $d1, $6b, $9d, $68, $1d, $60, $01, $6a, $63, $88
    db $ac, $68, $6d, $89, $6a, $74, $76, $75, $af, $70, $2e, $00
    assert @ == $472f

section "Campaign Briefing ResultB 22", romx[$472f], bank[$33]
CampaignBriefing_ResultB_22::
    db $1b, $e8, $e5, $dd, $8c, $8d, $1d, $79, $01, $73, $67, $67, $ae, $73, $8d, $66
    db $68, $7e, $7a, $01, $62, $71, $65, $63, $6e, $62, $6a, $63, $6c, $2c, $73, $67
    db $7a, $01, $1b, $ed, $ec, $2d, $6b, $8d, $80, $ac, $68, $1d, $7e, $63, $82, $8d
    db $7d, $01, $73, $af, $70, $62, $6c, $73, $62, $af, $70, $2e, $01, $01, $01, $01
    db $6a, $79, $7f, $7f, $2c, $8c, $8a, $8c, $8a, $7a, $01, $94, $ae, $63, $88, $68
    db $67, $ae, $73, $8d, $66, $87, $01, $1b, $ed, $ec, $2d, $6b, $8d, $80, $ac, $68
    db $1d, $7e, $63, $82, $8d, $7d, $01, $6a, $63, $91, $67, $60, $66, $62, $6c, $6d
    db $89, $2e, $00
    assert @ == $47a2

section "Campaign Briefing ResultB 23", romx[$47a2], bank[$33]
CampaignBriefing_ResultB_23::
    db $8c, $8a, $8c, $8a, $7a, $01, $73, $67, $79, $75, $8e, $68, $79, $9e, $67, $af
    db $70, $01, $7e, $67, $ad, $63, $79, $94, $ac, $68, $73, $8d, $60, $72, $67, $01
    db $73, $67, $60, $91, $67, $7a, $6c, $70, $2e, $01, $01, $01, $01, $01, $6c, $66
    db $6c, $01, $1b, $b1, $ff, $c2, $8c, $8d, $1d, $79, $73, $67, $66, $87, $01, $66
    db $75, $88, $79, $6f, $8d, $8e, $62, $60, $63, $69, $70, $2e, $01, $6f, $79, $70
    db $82, $1b, $db, $dd, $ec, $6b, $9d, $68, $1d, $9b, $79, $01, $6b, $68, $6e, $8d
    db $76, $7a, $6b, $8d, $66, $6e, $95, $01, $1b, $ed, $ec, $2d, $6b, $8d, $80, $ac
    db $68, $1d, $7e, $63, $82, $8d, $7d, $74, $01, $81, $66, $63, $6a, $74, $76, $75
    db $af, $70, $2e, $00
    assert @ == $4826

section "Campaign Briefing ResultB 24", romx[$4826], bank[$33]
CampaignBriefing_ResultB_24::
    db $00
    assert @ == $4827

section "Campaign Briefing ResultB 25", romx[$4827], bank[$33]
CampaignBriefing_ResultB_25::
    db $8c, $8a, $8c, $8a, $7a, $2c, $6c, $8d, $6a, $63, $d9, $2d, $c4, $60, $01, $6b
    db $8d, $80, $ac, $68, $76, $7a, $9d, $7f, $8a, $01, $86, $6f, $63, $8e, $62, $79
    db $94, $66, $8d, $60, $01, $6c, $ae, $63, $7b, $6c, $70, $83, $79, $79, $01, $73
    db $67, $79, $91, $67, $7a, $76, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $01
    db $01, $7b, $74, $7f, $95, $61, $8d, $73, $62, $6c, $70, $01, $6a, $79, $6e, $8d
    db $6e, $8d, $60, $61, $74, $76, $6c, $73, $01, $8c, $8a, $8c, $8a, $7a, $7c, $70
    db $70, $9e, $01, $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $7d, $01, $73, $8d, $97
    db $68, $74, $75, $af, $70, $2e, $00
    assert @ == $489e

section "Campaign Briefing ResultB 26", romx[$489e], bank[$33]
CampaignBriefing_ResultB_26::
    db $00
    assert @ == $489f

section "Campaign Briefing ResultB 27", romx[$489f], bank[$33]
CampaignBriefing_ResultB_27::
    db $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $76, $6c, $8d, $76, $ad, $63, $6c, $70
    db $01, $73, $67, $90, $8d, $7a, $2c, $6d, $9b, $76, $67, $ae, $63, $88, $ae, $68
    db $75, $01, $a1, $63, $64, $62, $70, $62, $6e, $62, $60, $01, $74, $74, $79, $64
    db $73, $62, $70, $2e, $01, $01, $6c, $66, $6c, $2c, $91, $67, $6e, $8d, $79, $6d
    db $64, $01, $8c, $8a, $8c, $8a, $7a, $2c, $73, $67, $67, $ae, $73, $8d, $60, $01
    db $91, $67, $7a, $6c, $6e, $8d, $88, $ae, $63, $6c, $70, $2e, $01, $67, $ae, $73
    db $8d, $60, $63, $6c, $75, $af, $70, $73, $67, $7a, $01, $80, $75, $80, $7d, $74
    db $6a, $63, $70, $62, $6c, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $01, $6a
    db $79, $73, $67, $60, $70, $70, $68, $a0, $68, $01, $1b, $cf, $d8, $de, $2d, $74
    db $63, $1d, $71, $ad, $63, $65, $63, $9f, $66, $87, $01, $1b, $d8, $ec, $2d, $dd
    db $8e, $8c, $1d, $7e, $63, $82, $8d, $7d, $01, $96, $8d, $6c, $8d, $60, $66, $62
    db $6c, $6d, $89, $2e, $00
    assert @ == $4954

section "Campaign Briefing ResultB 28", romx[$4954], bank[$33]
CampaignBriefing_ResultB_28::
    db $1b, $bd, $c3, $dd, $66, $62, $67, $ae, $63, $1d, $60, $65, $63, $98, $8d, $6c
    db $01, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $79, $01, $73, $67, $67
    db $ae, $73, $8d, $60, $6e, $8d, $88, $ae, $63, $6c, $70, $2e, $01, $01, $01, $01
    db $01, $01, $7e, $67, $ad, $63, $d9, $2d, $c4, $60, $63, $6c, $75, $62, $01, $6a
    db $88, $72, $6c, $70, $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $79, $01, $73, $67
    db $60, $70, $70, $68, $70, $82, $2c, $8c, $8a, $8c, $8a, $7a, $01, $1b, $cf, $d8
    db $de, $2d, $74, $63, $1d, $71, $ad, $63, $65, $63, $9f, $66, $87, $01, $1b, $d8
    db $ec, $2d, $dd, $8e, $8c, $1d, $7e, $63, $82, $8d, $7d, $01, $96, $8d, $6c, $8d
    db $60, $66, $62, $6c, $6d, $89, $6a, $74, $76, $01, $75, $af, $70, $2e, $00
    assert @ == $49e3

section "Campaign Briefing ResultB 29", romx[$49e3], bank[$33]
CampaignBriefing_ResultB_29::
    db $71, $ad, $63, $65, $63, $9f, $79, $01, $6a, $63, $7a, $62, $6c, $70, $74, $6c
    db $90, $8d, $79, $01, $6f, $63, $96, $72, $75, $6f, $63, $98, $72, $6e, $8d, $74
    db $75, $af, $70, $8e, $01, $8c, $8a, $8c, $8a, $79, $6c, $ae, $63, $88, $74, $75
    db $af, $70, $2e, $01, $01, $01, $01, $01, $72, $8f, $76, $01, $8c, $8e, $90, $8d
    db $7a, $1b, $d8, $da, $f0, $66, $62, $8b, $63, $1d, $76, $73, $01, $65, $6a, $75
    db $8c, $8a, $89, $6b, $68, $6e, $8d, $60, $01, $7e, $94, $ae, $6d, $89, $a0, $68
    db $01, $1b, $cf, $b9, $e7, $dd, $61, $8a, $71, $1d, $7e, $63, $82, $8d, $7d, $74
    db $01, $6c, $8d, $90, $8d, $6d, $89, $6a, $74, $76, $75, $af, $70, $2e, $00
    assert @ == $4a62

section "Campaign Briefing ResultB 30", romx[$4a62], bank[$33]
CampaignBriefing_ResultB_30::
    db $1b, $d8, $ec, $2d, $dd, $8e, $8c, $1d, $74, $af, $a2, $76, $01, $86, $6f, $63
    db $8e, $62, $79, $01, $94, $66, $8d, $74, $6e, $8d, $88, $ae, $68, $60, $01, $63
    db $6c, $75, $af, $73, $6c, $7f, $af, $70, $2e, $01, $01, $69, $af, $66, $74, $6c
    db $73, $2c, $8c, $8a, $8c, $8a, $79, $01, $6c, $ae, $63, $88, $76, $75, $af, $70
    db $83, $79, $79, $01, $73, $67, $90, $8d, $79, $6a, $63, $70, $62, $60, $01, $85
    db $89, $6c, $73, $6c, $7f, $af, $70, $2e, $01, $01, $73, $67, $7a, $1b, $bd, $d8
    db $b8, $6b, $9d, $68, $1d, $76, $01, $6e, $8d, $88, $ae, $68, $60, $6c, $ad, $63
    db $69, $72, $6c, $73, $62, $89, $2e, $01, $01, $70, $98, $71, $76, $2c, $72, $62
    db $91, $67, $6c, $01, $6a, $79, $73, $67, $60, $91, $67, $7a, $6e, $86, $2e, $00
    assert @ == $4af2

section "Campaign Briefing ResultB 31", romx[$4af2], bank[$33]
CampaignBriefing_ResultB_31::
    db $1b, $cf, $b9, $e7, $dd, $61, $8a, $71, $1d, $79, $74, $af, $a2, $76, $01, $73
    db $7f, $9c, $af, $73, $6c, $7f, $af, $70, $2e, $01, $01, $75, $62, $88, $68, $79
    db $73, $67, $60, $01, $8c, $8a, $8c, $8a, $8e, $7a, $62, $94, $ae, $6c, $70, $8e
    db $01, $73, $67, $6c, $ad, $88, $ae, $68, $7a, $2c, $6d, $9b, $76, $01, $6a, $63
    db $70, $62, $6c, $73, $62, $af, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $01
    db $6a, $79, $73, $67, $60, $70, $70, $68, $a0, $68, $01, $1b, $cf, $d8, $de, $2d
    db $74, $63, $1d, $7e, $63, $82, $8d, $66, $87, $01, $1b, $bb, $e3, $2d, $dd, $66
    db $62, $1d, $79, $6a, $63, $88, $ac, $68, $60, $01, $65, $6a, $75, $63, $2e, $00
    assert @ == $4b72

section "Campaign Briefing ResultB 32", romx[$4b72], bank[$33]
CampaignBriefing_ResultB_32::
    db $1b, $d8, $da, $f0, $66, $62, $8b, $63, $1d, $79, $6a, $63, $88, $ac, $68, $76
    db $01, $6e, $62, $6a, $63, $6c, $70, $83, $79, $79, $01, $86, $6f, $63, $8e, $62
    db $79, $94, $66, $8d, $74, $6e, $8d, $88, $ae, $68, $60, $01, $6c, $ae, $63, $83
    db $63, $6c, $73, $6c, $7f, $af, $70, $2e, $01, $01, $01, $01, $01, $66, $62, $8b
    db $63, $60, $6a, $63, $70, $62, $6c, $70, $73, $67, $7a, $01, $1b, $bb, $e3, $2d
    db $dd, $66, $62, $1d, $7e, $63, $82, $8d, $76, $01, $6c, $ad, $63, $69, $72, $6c
    db $73, $62, $89, $2e, $01, $8c, $8a, $8c, $8a, $7a, $01, $6a, $79, $73, $67, $60
    db $70, $70, $68, $a0, $68, $01, $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $7e, $63
    db $82, $8d, $66, $87, $01, $1b, $bb, $e3, $2d, $dd, $66, $62, $1d, $79, $6a, $63
    db $88, $ac, $68, $60, $01, $65, $6a, $75, $63, $2e, $00
    assert @ == $4c0d

section "Campaign Briefing ResultB 33", romx[$4c0d], bank[$33]
CampaignBriefing_ResultB_33::
    db $00
    assert @ == $4c0e

section "Campaign Briefing ResultB 34", romx[$4c0e], bank[$33]
CampaignBriefing_ResultB_34::
    db $00
    assert @ == $4c0f

section "Campaign Briefing ResultB 35", romx[$4c0f], bank[$33]
CampaignBriefing_ResultB_35::
    db $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $76, $01, $6f, $8d, $93, $62
    db $6d, $89, $01, $96, $8d, $73, $67, $90, $8d, $8e, $01, $6c, $ad, $63, $69, $72
    db $6c, $73, $62, $70, $2e, $01, $01, $01, $01, $01, $7a, $91, $6c, $62, $6e, $8d
    db $74, $63, $79, $6d, $64, $01, $6a, $79, $73, $67, $60, $91, $67, $7a, $6c, $01
    db $8c, $8e, $90, $8d, $7a, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $79
    db $01, $6e, $62, $61, $72, $76, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $6a
    db $8a, $86, $88, $2c, $8c, $8e, $90, $8d, $7a, $01, $66, $68, $71, $79, $93, $8d
    db $97, $8d, $7d, $62, $88, $ae, $68, $79, $01, $6f, $63, $74, $63, $6b, $68, $6e
    db $8d, $76, $63, $72, $89, $2e, $00
    assert @ == $4c96

section "Campaign Briefing ResultB 36", romx[$4c96], bank[$33]
CampaignBriefing_ResultB_36::
    db $62, $88, $68, $81, $71, $69, $62, $76, $01, $68, $89, $6c, $80, $72, $72, $83
    db $01, $73, $67, $9f, $70, $62, $79, $7a, $62, $94, $ae, $76, $01, $6e, $62, $6a
    db $63, $6c, $70, $2e, $01, $01, $73, $67, $7a, $2c, $6a, $63, $70, $62, $6c, $72
    db $72, $01, $70, $62, $88, $68, $66, $87, $79, $98, $af, $6c, $ad, $72, $60, $01
    db $78, $87, $af, $73, $62, $89, $2e, $01, $73, $67, $9f, $70, $62, $8e, $7e, $8d
    db $92, $68, $7d, $74, $01, $92, $63, $88, $ad, $63, $6d, $89, $7f, $64, $76, $01
    db $1b, $d7, $b2, $b1, $2d, $8c, $8d, $1d, $7d, $94, $ae, $63, $88, $68, $6c, $01
    db $73, $67, $9f, $70, $62, $60, $70, $70, $69, $2e, $00
    assert @ == $4d11

section "Campaign Briefing ResultB 37", romx[$4d11], bank[$33]
CampaignBriefing_ResultB_37::
    db $73, $67, $7a, $1b, $d8, $da, $f0, $66, $62, $8b, $63, $1d, $79, $01, $93, $8d
    db $97, $8d, $6e, $62, $88, $ae, $68, $74, $7a, $01, $65, $83, $64, $77, $7e, $9c
    db $79, $73, $62, $6a, $63, $60, $01, $65, $6a, $75, $af, $70, $8e, $2c, $8c, $8a
    db $8c, $8a, $8e, $01, $6e, $62, $61, $72, $6c, $70, $2e, $01, $01, $01, $01, $6a
    db $8a, $9b, $2c, $73, $67, $79, $7d, $62, $88, $ae, $68, $7a, $01, $73, $67, $7e
    db $8d, $92, $68, $9b, $61, $89, $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3, $1d
    db $79, $80, $74, $75, $af, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $2c, $72
    db $8f, $76, $01, $73, $67, $7e, $8d, $92, $68, $7d, $79, $01, $7e, $94, $ae, $6b
    db $68, $6e, $8d, $60, $65, $6a, $75, $63, $2e, $00
    assert @ == $4d9b

section "Campaign Briefing ResultB 38", romx[$4d9b], bank[$33]
CampaignBriefing_ResultB_38::
    db $73, $67, $7a, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $79, $01, $93
    db $8d, $97, $8d, $6e, $62, $88, $ae, $68, $74, $7a, $01, $65, $83, $64, $77, $7e
    db $9c, $79, $73, $62, $6a, $63, $60, $01, $65, $6a, $75, $af, $70, $8e, $2c, $8c
    db $8a, $8c, $8a, $8e, $01, $6e, $62, $61, $72, $6c, $70, $2e, $01, $01, $01, $01
    db $6a, $8a, $9b, $2c, $73, $67, $79, $7d, $62, $88, $ae, $68, $7a, $01, $73, $67
    db $7e, $8d, $92, $68, $9b, $61, $89, $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3
    db $1d, $79, $80, $74, $75, $af, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $2c
    db $72, $8f, $76, $01, $73, $67, $7e, $8d, $92, $68, $7d, $79, $01, $7e, $94, $ae
    db $6b, $68, $6e, $8d, $60, $65, $6a, $75, $63, $2e, $00
    assert @ == $4e26

section "Campaign Briefing ResultB 39", romx[$4e26], bank[$33]
CampaignBriefing_ResultB_39::
    db $6a, $63, $70, $62, $71, $ad, $63, $79, $01, $73, $67, $7d, $79, $6a, $63, $91
    db $67, $74, $7a, $62, $64, $01, $73, $67, $96, $8d, $94, $ae, $63, $88, $68, $7a
    db $01, $6a, $8d, $75, $8d, $60, $67, $8c, $82, $70, $2e, $01, $01, $70, $98, $62
    db $75, $8f, $6e, $62, $60, $7a, $87, $62, $72, $72, $01, $6a, $79, $73, $67, $60
    db $6e, $62, $61, $72, $6c, $70, $2e, $01, $01, $6a, $8a, $9b, $2c, $73, $67, $79
    db $7d, $62, $88, $ae, $68, $7a, $01, $73, $67, $7e, $8d, $92, $68, $9b, $61, $89
    db $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3, $1d, $79, $80, $74, $75, $af, $70
    db $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $2c, $72, $8f, $76, $01, $73, $67, $7e
    db $8d, $92, $68, $7d, $79, $01, $7e, $94, $ae, $6b, $68, $6e, $8d, $60, $65, $6a
    db $75, $63, $2e, $00
    assert @ == $4eba

section "Campaign Briefing ResultB 40", romx[$4eba], bank[$33]
CampaignBriefing_ResultB_40::
    db $00
    assert @ == $4ebb

section "Campaign Briefing ResultB 41", romx[$4ebb], bank[$33]
CampaignBriefing_ResultB_41::
    db $73, $67, $7e, $8d, $9c, $79, $73, $62, $6a, $63, $7a, $01, $7b, $94, $ae, $63
    db $76, $7a, $91, $6c, $68, $01, $6b, $68, $6e, $8d, $7a, $01, $6a, $8d, $75, $8d
    db $60, $67, $8c, $82, $70, $2e, $01, $01, $01, $01, $01, $98, $8e, $2c, $74, $63
    db $6c, $ae, $79, $86, $73, $62, $9c, $65, $88, $01, $94, $ad, $8d, $9e, $6a, $63
    db $91, $67, $7a, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $8c, $8a, $8c
    db $8a, $7a, $01, $6e, $8d, $88, $ae, $68, $60, $74, $74, $79, $64, $01, $1b, $f4
    db $d7, $dd, $42, $1d, $76, $6f, $75, $64, $89, $70, $82, $01, $62, $71, $9c, $2c
    db $6a, $63, $70, $62, $60, $65, $6a, $75, $af, $70, $2e, $00
    assert @ == $4f37

section "Campaign Briefing ResultB 42", romx[$4f37], bank[$33]
CampaignBriefing_ResultB_42::
    db $00
    assert @ == $4f38

section "Campaign Briefing ResultB 43", romx[$4f38], bank[$33]
CampaignBriefing_ResultB_43::
    db $00
    assert @ == $4f39

section "Campaign Briefing ResultB 44", romx[$4f39], bank[$33]
CampaignBriefing_ResultB_44::
    db $00
    assert @ == $4f3a

section "Campaign Briefing PreMap 00", romx[$4f3a], bank[$33]
CampaignBriefing_PreMap_00::
    db $ce, $dc, $b2, $c4, $d1, $2d, $dd, $c4, $20, $b5, $f1, $bc, $b7, $01, $c1, $e4
    db $fe, $b3, $ef, $c0, $b2, $20, $be, $ff, $b7, $dd, $c1, $fd, $b3, $01, $01, $c0
    db $e8, $c1, $c6, $20, $c3, $b7, $c6, $c0, $b2, $bc, $c3, $01, $e1, $b2, $e1, $b7
    db $b0, $20, $b6, $b2, $bc, $bc, $01, $c3, $b7, $e6, $dd, $bc, $dd, $b7, $c1, $b0
    db $20, $e1, $b7, $ca, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $30, $c6, $c1
    db $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2
    db $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9
    db $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9
    db $00
    assert @ == $4fbb

section "Campaign Briefing PreMap 01", romx[$4fbb], bank[$33]
CampaignBriefing_PreMap_01::
    db $bb, $b7, $ce, $ec, $c9, $20, $e3, $dd, $e7, $dd, $ef, $c0, $b2, $de, $01, $cc
    db $c0, $c0, $ee, $20, $bc, $fd, $b3, $b9, $c2, $bc, $c3, $b2, $d9, $01, $01, $c1
    db $fd, $b3, $b5, $b3, $ef, $c9, $01, $d3, $d8, $b0, $c4, $ff, $f2, $bc, $c3, $01
    db $ba, $da, $b0, $20, $e1, $b7, $ca, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33
    db $30, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb
    db $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8
    db $c4, $c5, $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0
    db $b2, $bd, $d9, $00
    assert @ == $502f

section "Campaign Briefing PreMap 02", romx[$502f], bank[$33]
CampaignBriefing_PreMap_02::
    db $c3, $b7, $ca, $20, $1b, $c0, $ee, $cf, $ca, $c5, $bb, $ed, $b8, $1d, $b6, $d7
    db $01, $ba, $b3, $be, $b2, $c6, $20, $eb, $d6, $b3, $c4, $bc, $c3, $b2, $d9, $01
    db $01, $bb, $ed, $b8, $b0, $ba, $b4, $20, $be, $b2, $b8, $b3, $b9, $dd, $b0, $01
    db $b6, $b8, $ce, $bc, $20, $c3, $b7, $b0, $20, $e1, $b7, $ca, $be, $d6, $01, $01
    db $01, $01, $c5, $b5, $01, $33, $30, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7
    db $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc
    db $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $b7, $d0, $c9, $be, $b2
    db $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $50a9

section "Campaign Briefing PreMap 03", romx[$50a9], bank[$33]
CampaignBriefing_PreMap_03::
    db $1b, $c0, $ee, $cf, $ca, $c5, $bb, $ed, $b8, $1d, $b0, $01, $c4, $ff, $f2, $bc
    db $c0, $20, $c3, $b7, $de, $01, $1b, $da, $ba, $b1, $dd, $b6, $b2, $de, $dd, $1d
    db $c6, $01, $c4, $b3, $c0, $c2, $bc, $c0, $01, $01, $b6, $b2, $de, $dd, $c6, $20
    db $ef, $c0, $b2, $b0, $c3, $dd, $b6, $b2, $bc, $01, $c5, $b2, $d8, $b8, $c9, $c3
    db $b7, $b0, $20, $e1, $b7, $ca, $be, $d6, $01, $01, $c5, $b5, $01, $33, $30, $c6
    db $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5
    db $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5
    db $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd
    db $d9, $00
    assert @ == $512b

section "Campaign Briefing PreMap 04", romx[$512b], bank[$33]
CampaignBriefing_PreMap_04::
    db $1b, $f0, $f8, $c4, $dd, $bb, $ed, $b8, $1d, $cb, $de, $bc, $c6, $01, $c3, $b7
    db $e0, $dd, $de, $20, $c3, $dd, $b6, $b2, $c1, $fd, $b3, $01, $01, $bb, $ed, $b8
    db $b0, $ba, $b4, $20, $c3, $b7, $b0, $e1, $b7, $ca, $be, $d6, $01, $01, $cf, $c0
    db $01, $bc, $fd, $b3, $cd, $dd, $c9, $20, $b9, $dd, $c1, $b8, $ef, $c2, $b0, $01
    db $bc, $fd, $b3, $cc, $b8, $bc, $c3, $20, $bc, $d6, $b3, $be, $d6, $01, $c5, $b5
    db $01, $33, $30, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7
    db $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2
    db $f1, $b8, $c4, $c5, $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20
    db $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $51b1

section "Campaign Briefing PreMap 05", romx[$51b1], bank[$33]
CampaignBriefing_PreMap_05::
    db $c3, $b7, $ca, $01, $1b, $bb, $c8, $cb, $de, $dc, $1d, $b7, $c1, $b6, $d7, $c9
    db $01, $ba, $b3, $e1, $b7, $b0, $20, $b7, $b6, $b8, $20, $bc, $c3, $b2, $d9, $01
    db $01, $c3, $b7, $ef, $c0, $b2, $20, $b5, $d6, $ee, $20, $c3, $b7, $b7, $c1, $b0
    db $01, $e1, $b7, $ca, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $30, $c6, $c1
    db $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2
    db $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9
    db $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9
    db $00
    assert @ == $5222

section "Campaign Briefing PreMap 06", romx[$5222], bank[$33]
CampaignBriefing_PreMap_06::
    db $c3, $b7, $e0, $dd, $ca, $1b, $d7, $ff, $bc, $b1, $ca, $dd, $c4, $b3, $1d, $c9
    db $01, $be, $dd, $c0, $dd, $b6, $d7, $20, $ba, $b3, $e1, $b7, $b0, $01, $b7, $b6
    db $b8, $bc, $c3, $b2, $d9, $01, $01, $ca, $dd, $c4, $b3, $b0, $b8, $e8, $d8, $20
    db $c3, $b7, $e0, $dd, $b0, $01, $e1, $b7, $ca, $be, $d6, $01, $01, $01, $c5, $b5
    db $01, $33, $30, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7
    db $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2
    db $f1, $b8, $c4, $c5, $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20
    db $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $5298

section "Campaign Briefing PreMap 07", romx[$5298], bank[$33]
CampaignBriefing_PreMap_07::
    db $c3, $b7, $c9, $20, $e4, $fd, $b3, $d6, $b3, $b7, $fe, $c3, $dd, $b0, $01, $ba
    db $c9, $bb, $b8, $be, $dd, $c6, $c3, $20, $c0, $c0, $b8, $01, $01, $e4, $fe, $b3
    db $d8, $b8, $ef, $c0, $b2, $b0, $20, $cb, $b7, $b2, $c3, $01, $c3, $b7, $b0, $20
    db $e1, $b7, $ca, $be, $d6, $01, $01, $01, $01, $c5, $b5, $01, $33, $30, $c6, $c1
    db $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2
    db $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9
    db $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9
    db $00
    assert @ == $5309

section "Campaign Briefing PreMap 08", romx[$5309], bank[$33]
CampaignBriefing_PreMap_08::
    db $1b, $c9, $d9, $f1, $de, $dc, $1d, $20, $bc, $fe, $b3, $d2, $dd, $20, $c6, $c3
    db $01, $c3, $b7, $e0, $dd, $be, $dd, $d8, $fe, $b8, $c9, $20, $e7, $b3, $e8, $b2
    db $de, $01, $b6, $b8, $c6, $dd, $20, $bb, $da, $c0, $01, $01, $bc, $fd, $b3, $b9
    db $c2, $c1, $fd, $b3, $c9, $20, $c3, $b7, $e0, $dd, $b0, $01, $ce, $bf, $b8, $bc
    db $20, $e1, $b7, $d2, $c2, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $30, $c6
    db $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5
    db $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5
    db $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd
    db $d9, $00
    assert @ == $538b

section "Campaign Briefing PreMap 09", romx[$538b], bank[$33]
CampaignBriefing_PreMap_09::
    db $c3, $b7, $c9, $20, $ce, $b7, $fd, $b3, $be, $dd, $b0, $01, $bc, $fc, $e8, $dd
    db $20, $bd, $d9, $01, $01, $1b, $c9, $e4, $2d, $b6, $b2, $b7, $fe, $b3, $1d, $c9
    db $01, $be, $b2, $b6, $b2, $b9, $dd, $b0, $20, $b5, $bb, $b4, $01, $c3, $b7, $b0
    db $20, $e1, $b7, $ca, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $32, $c6, $c1
    db $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2
    db $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9
    db $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9
    db $00
    assert @ == $53fc

section "Campaign Briefing PreMap 10", romx[$53fc], bank[$33]
CampaignBriefing_PreMap_10::
    db $1b, $d8, $fd, $b3, $d9, $b6, $b2, $de, $dd, $1d, $c6, $01, $c3, $b7, $b6, $dd
    db $c0, $b2, $de, $20, $bc, $fd, $b3, $b9, $c2, $c1, $fd, $b3, $01, $c4, $c9, $20
    db $e4, $fe, $b3, $ce, $b3, $20, $b1, $d8, $01, $01, $c3, $b7, $b6, $dd, $c0, $b2
    db $b0, $20, $e1, $b7, $d2, $c2, $bc, $01, $1b, $c9, $d9, $f1, $de, $dc, $1d, $ce
    db $b3, $d2, $dd, $20, $cd, $c9, $01, $ce, $b7, $fd, $b3, $be, $dd, $b0, $20, $b6
    db $b8, $ce, $be, $d6, $01, $01, $c5, $b5, $01, $33, $32, $c6, $c1, $b2, $c5, $b2
    db $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2
    db $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $b7
    db $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $548a

section "Campaign Briefing PreMap 11", romx[$548a], bank[$33]
CampaignBriefing_PreMap_11::
    db $1b, $c3, $2d, $c2, $de, $dc, $1d, $c6, $20, $c3, $b7, $c9, $01, $be, $dd, $d8
    db $fe, $b8, $de, $20, $b6, $b8, $c6, $dd, $bb, $da, $c0, $01, $01, $e6, $dd, $d2
    db $dd, $c9, $c3, $b7, $b0, $20, $ca, $b2, $e4, $fe, $bc, $c2, $c2, $01, $c3, $b7
    db $c9, $b7, $fe, $c3, $dd, $b0, $20, $cc, $dd, $bb, $b2, $be, $d6, $01, $01, $01
    db $01, $c5, $b5, $01, $33, $32, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0
    db $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da
    db $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba
    db $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $5503

section "Campaign Briefing PreMap 12", romx[$5503], bank[$33]
CampaignBriefing_PreMap_12::
    db $1b, $c3, $f8, $c5, $dd, $dc, $dd, $1d, $c6, $20, $c3, $b7, $c9, $01, $b6, $dd
    db $c0, $b2, $de, $20, $bc, $fd, $b3, $b9, $c2, $c1, $fd, $b3, $01, $01, $c3, $b7
    db $b6, $dd, $c0, $b2, $b0, $20, $e1, $b7, $ca, $bc, $01, $c3, $b3, $bd, $c5, $20
    db $b6, $b2, $de, $dd, $b6, $d7, $01, $e4, $fe, $b3, $d8, $b8, $b0, $20, $b5, $ba
    db $c5, $b2, $01, $c3, $b7, $c9, $b7, $fe, $c3, $dd, $b0, $20, $b6, $b8, $ce, $be
    db $d6, $01, $01, $c5, $b5, $01, $33, $32, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3
    db $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da
    db $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $b7, $d0, $c9, $be
    db $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $558e

section "Campaign Briefing PreMap 13", romx[$558e], bank[$33]
CampaignBriefing_PreMap_13::
    db $1b, $c9, $e4, $2d, $b6, $b2, $b7, $fe, $b3, $1d, $b0, $01, $b3, $bc, $c5, $ff
    db $c0, $20, $ce, $dc, $b2, $c4, $d1, $2d, $dd, $20, $ca, $01, $1b, $bd, $fb, $ec
    db $b6, $b2, $1d, $c9, $20, $be, $b2, $b6, $b2, $b9, $dd, $b0, $01, $bc, $bc, $fd
    db $20, $bd, $d9, $f0, $b8, $20, $ba, $b3, $be, $b2, $b0, $01, $b6, $b2, $bc, $bc
    db $c0, $01, $01, $1b, $bd, $fb, $ec, $b6, $b2, $1d, $b0, $20, $cc, $b3, $bb, $bc
    db $20, $cf, $c0, $01, $c3, $b7, $c9, $20, $b7, $fe, $c3, $dd, $b0, $20, $e1, $b7
    db $ca, $be, $d6, $01, $c5, $b5, $01, $33, $32, $c6, $c1, $b2, $c5, $b2, $c6, $20
    db $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc
    db $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $b7, $d0, $c9
    db $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $00
    assert @ == $562a

section "Campaign Briefing PreMap 14", romx[$562a], bank[$33]
CampaignBriefing_PreMap_14::
    db $1b, $bd, $fb, $ec, $b6, $b2, $1d, $ce, $b3, $d2, $dd, $b6, $d7, $01, $1b, $d7
    db $b2, $c4, $b3, $dc, $dd, $1d, $c6, $01, $c3, $b7, $c9, $20, $b6, $dd, $c0, $b2
    db $de, $01, $bc, $dd, $c6, $fd, $b3, $bc, $c0, $01, $01, $ba, $c9, $20, $b6, $dd
    db $c0, $b2, $b0, $20, $e1, $b7, $ca, $bc, $01, $c3, $b7, $c9, $20, $b7, $fe, $c3
    db $dd, $b0, $20, $b6, $b8, $ce, $be, $d6, $01, $01, $c5, $b5, $01, $33, $32, $c6
    db $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5
    db $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5
    db $d9, $01, $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd
    db $d9, $00
    assert @ == $56ac

section "Campaign Briefing PreMap 15", romx[$56ac], bank[$33]
CampaignBriefing_PreMap_15::
    db $dc, $da, $dc, $da, $ca, $20, $1b, $d8, $cf, $ca, $dd, $c4, $b3, $1d, $c9, $01
    db $e4, $fe, $b3, $d8, $b8, $c6, $20, $be, $b2, $ba, $b3, $bc, $c0, $01, $01, $e8
    db $de, $20, $c3, $b7, $c9, $20, $d5, $b3, $d8, $fe, $b8, $c5, $01, $be, $dd, $d8
    db $fe, $b8, $de, $20, $dc, $de, $e0, $dd, $e6, $dd, $d2, $dd, $c6, $01, $bc, $fd
    db $b3, $b9, $c2, $20, $bc, $c3, $b2, $d9, $01, $01, $01, $33, $32, $c6, $c1, $b2
    db $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed
    db $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01
    db $01, $c9, $ba, $d8, $c6, $ff, $bd, $b3, $c6, $20, $c1, $fd, $b3, $b2, $bc, $c2
    db $c2, $01, $1b, $d8, $cf, $ca, $dd, $c4, $b3, $1d, $c9, $20, $c3, $b7, $b0, $01
    db $e1, $b7, $c0, $b2, $be, $d6, $00
    assert @ == $5743

section "Campaign Briefing PreMap 16", romx[$5743], bank[$33]
CampaignBriefing_PreMap_16::
    db $1b, $c0, $d1, $c0, $b6, $b2, $b7, $fe, $b3, $1d, $b0, $20, $dc, $c0, $d8, $01
    db $1b, $d0, $ef, $db, $dd, $ca, $dd, $c4, $b3, $1d, $cd, $c9, $01, $b7, $fe, $c3
    db $dd, $b0, $20, $b6, $b8, $ce, $be, $d6, $01, $01, $c5, $b5, $20, $c3, $b7, $b6
    db $dd, $c0, $b2, $01, $bc, $fd, $b3, $b9, $c2, $c9, $20, $e4, $fe, $b3, $ce, $b3
    db $b1, $d8, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be
    db $d6, $01, $c5, $b5, $01, $33, $32, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7
    db $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc
    db $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $2e, $01, $01, $b7, $d0, $c9, $be
    db $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $2e, $00
    assert @ == $57cf

section "Campaign Briefing PreMap 17", romx[$57cf], bank[$33]
CampaignBriefing_PreMap_17::
    db $1b, $d7, $b2, $c4, $b3, $dc, $dd, $1d, $b6, $d7, $01, $bf, $b3, $c4, $b3, $bb
    db $da, $c0, $20, $c3, $b7, $b6, $dd, $c0, $b2, $de, $01, $bc, $fd, $b3, $b9, $c2
    db $c1, $fd, $b3, $01, $01, $ba, $c9, $20, $c3, $b7, $b6, $dd, $c0, $b2, $b0, $20
    db $e1, $b7, $ca, $bc, $01, $c3, $b7, $b7, $fe, $c3, $dd, $b0, $20, $be, $dd, $d8
    db $fe, $b3, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $32, $c6, $c1, $b2, $c5
    db $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1
    db $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $2e, $01
    db $01, $b7, $d0, $c9, $be, $b2, $ba, $b3, $b0, $20, $b7, $c0, $b2, $bd, $d9, $2e
    db $00
    assert @ == $5850

section "Campaign Briefing PreMap 18", romx[$5850], bank[$33]
CampaignBriefing_PreMap_18::
    db $ba, $da, $d6, $d8, $1b, $d7, $d0, $d8, $e5, $c0, $b2, $d8, $b8, $1d, $c9, $01
    db $ba, $b3, $d8, $fc, $b8, $b0, $20, $b6, $b2, $bc, $bd, $d9, $01, $01, $b6, $b2
    db $b7, $fe, $b3, $b0, $20, $b5, $b3, $e8, $dd, $bc, $01, $1b, $de, $d8, $b1, $dd
    db $ca, $dd, $c4, $b3, $1d, $c6, $01, $e4, $fe, $b3, $d8, $b8, $b0, $20, $b5, $ba
    db $c5, $b2, $01, $ba, $ba, $b0, $20, $ba, $b3, $d8, $fc, $b8, $be, $d6, $01, $01
    db $c5, $b5, $01, $33, $34, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01
    db $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9
    db $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20
    db $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $58d7

section "Campaign Briefing PreMap 19", romx[$58d7], bank[$33]
CampaignBriefing_PreMap_19::
    db $c3, $b7, $bc, $fd, $d8, $fe, $b8, $de, $01, $1b, $de, $d8, $b1, $dd, $ca, $dd
    db $c4, $b3, $1d, $c6, $01, $bc, $fd, $b3, $b9, $c2, $c1, $fd, $b3, $01, $01, $dc
    db $de, $e0, $dd, $ca, $20, $bf, $c9, $20, $ba, $b3, $ca, $b2, $b0, $01, $c2, $b2
    db $c3, $20, $1b, $b2, $c8, $dd, $bc, $ff, $c1, $1d, $cd, $01, $e4, $fe, $b3, $d8
    db $b8, $b0, $20, $b5, $ba, $c5, $b2, $01, $c3, $b7, $b0, $20, $e1, $b7, $ca, $bd
    db $d9, $01, $c5, $b5, $01, $33, $34, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7
    db $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc
    db $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd
    db $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5960

section "Campaign Briefing PreMap 20", romx[$5960], bank[$33]
CampaignBriefing_PreMap_20::
    db $1b, $ef, $e8, $dd, $ca, $dd, $c4, $b3, $1d, $cd, $c9, $01, $e4, $fe, $b3, $d8
    db $b8, $b0, $20, $b6, $dd, $ba, $b3, $bd, $d9, $01, $01, $ba, $ba, $c6, $ca, $20
    db $c3, $b7, $c9, $20, $d5, $b3, $d8, $fe, $b8, $c5, $01, $be, $dd, $d8, $fe, $b8
    db $de, $20, $b6, $b8, $c6, $dd, $bb, $da, $c3, $b2, $d9, $01, $01, $01, $01, $c5
    db $b5, $01, $33, $34, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1
    db $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca
    db $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1
    db $fd, $b3, $b2, $be, $d6, $00
    assert @ == $59d6

section "Campaign Briefing PreMap 21", romx[$59d6], bank[$33]
CampaignBriefing_PreMap_21::
    db $c3, $b7, $bc, $fd, $d8, $fe, $b8, $ca, $01, $1b, $de, $d8, $b1, $dd, $ca, $dd
    db $c4, $b3, $1d, $c6, $01, $cb, $b7, $c2, $b9, $d7, $da, $c3, $b2, $d9, $01, $01
    db $ba, $c9, $bd, $b7, $c6, $20, $1b, $ed, $c4, $cf, $dd, $b6, $b2, $1d, $b0, $01
    db $b5, $b3, $e8, $dd, $bc, $20, $c3, $b3, $bd, $c5, $20, $b7, $fe, $c3, $dd, $b0
    db $01, $be, $dd, $d8, $fe, $b3, $be, $d6, $01, $01, $33, $34, $c6, $c1, $b2, $c5
    db $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1
    db $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01
    db $c5, $b5, $20, $1b, $bd, $db, $f1, $e8, $b2, $c1, $1d, $ce, $b3, $d2, $dd, $c9
    db $01, $c3, $b7, $be, $dd, $d8, $fe, $b8, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6
    db $00
    assert @ == $5a67

section "Campaign Briefing PreMap 22", romx[$5a67], bank[$33]
CampaignBriefing_PreMap_22::
    db $1b, $de, $d8, $b1, $dd, $ca, $dd, $c4, $b3, $1d, $b6, $d7, $01, $c3, $ff, $c0
    db $b2, $bc, $c0, $20, $c3, $b7, $b6, $dd, $c0, $b2, $b0, $01, $ce, $bf, $b8, $bc
    db $20, $e1, $b7, $c1, $dd, $be, $d6, $01, $01, $cf, $c0, $20, $1b, $e8, $e5, $dd
    db $dc, $dd, $1d, $c6, $b1, $d9, $01, $c3, $b7, $b7, $fe, $c3, $dd, $b0, $20, $be
    db $dd, $d8, $fe, $b3, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $34, $c6, $c1
    db $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2
    db $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9
    db $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5ae7

section "Campaign Briefing PreMap 23", romx[$5ae7], bank[$33]
CampaignBriefing_PreMap_23::
    db $1b, $b1, $ff, $c2, $dc, $dd, $1d, $c6, $20, $c6, $e1, $ba, $dd, $e8, $01, $c3
    db $b7, $b6, $dd, $c0, $b2, $b0, $20, $be, $dd, $d2, $c2, $bc, $01, $c3, $b7, $b7
    db $fe, $c3, $dd, $b0, $20, $be, $dd, $d8, $fe, $b3, $be, $d6, $01, $01, $c5, $b5
    db $01, $33, $34, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7
    db $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2
    db $f1, $b8, $c4, $c5, $d9, $00
    assert @ == $5b3d

section "Campaign Briefing PreMap 24", romx[$5b3d], bank[$33]
CampaignBriefing_PreMap_24::
    db $1b, $bd, $db, $f1, $e8, $b2, $c1, $1d, $ba, $b3, $d8, $fc, $b8, $b0, $01, $e8
    db $dd, $c8, $dd, $bc, $20, $1b, $bd, $b7, $d1, $bb, $ed, $b8, $1d, $c9, $01, $ba
    db $b3, $d8, $fc, $b8, $b0, $b6, $b2, $bc, $bd, $d9, $01, $01, $c5, $b5, $20, $c3
    db $b7, $c9, $20, $b7, $ba, $b3, $ef, $c0, $b2, $de, $01, $b6, $b8, $c6, $dd, $20
    db $bb, $da, $c3, $b2, $d9, $01, $c1, $fd, $b3, $b2, $20, $bb, $da, $c0, $bc, $01
    db $01, $c5, $b5, $01, $33, $34, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0
    db $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da
    db $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6
    db $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5bc5

section "Campaign Briefing PreMap 25", romx[$5bc5], bank[$33]
CampaignBriefing_PreMap_25::
    db $1b, $bd, $c1, $d1, $de, $dc, $1d, $ce, $b3, $d2, $dd, $b6, $d7, $c9, $01, $e3
    db $dd, $e7, $dd, $cd, $b2, $d8, $fe, $b8, $de, $20, $bc, $fd, $b3, $b9, $c2, $01
    db $bc, $c3, $b2, $d9, $c4, $c9, $20, $e4, $fe, $b3, $ce, $b3, $b1, $d8, $01, $01
    db $c3, $b7, $ca, $20, $e8, $ff, $bc, $fd, $c2, $c9, $c0, $d2, $c9, $01, $d0, $c5
    db $c4, $b0, $20, $b6, $b8, $ce, $bc, $d6, $b3, $c4, $bc, $c3, $b2, $d9, $01, $01
    db $01, $ba, $c9, $20, $e3, $dd, $e7, $dd, $cd, $b2, $d8, $fe, $b8, $b0, $01, $bf
    db $b3, $c4, $b3, $be, $d6, $01, $01, $c5, $b5, $01, $33, $34, $c6, $c1, $b2, $c5
    db $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1
    db $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $00
    assert @ == $5c54

section "Campaign Briefing PreMap 26", romx[$5c54], bank[$33]
CampaignBriefing_PreMap_26::
    db $1b, $db, $dd, $ec, $bb, $ed, $b8, $1d, $c6, $20, $c3, $b7, $c9, $01, $b7, $ba
    db $b3, $ef, $c0, $b2, $de, $20, $bc, $fd, $b3, $b9, $c2, $c1, $fd, $b3, $01, $01
    db $ba, $c9, $20, $c3, $b7, $b0, $20, $ce, $bf, $b8, $be, $dd, $d2, $c2, $be, $d6
    db $01, $01, $01, $01, $01, $c5, $b5, $01, $33, $34, $c6, $c1, $b2, $c5, $b2, $c6
    db $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01
    db $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd
    db $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5cc0

section "Campaign Briefing PreMap 27", romx[$5cc0], bank[$33]
CampaignBriefing_PreMap_27::
    db $ce, $dc, $b2, $c4, $d1, $2d, $dd, $de, $20, $cc, $c0, $c0, $ee, $01, $1b, $cf
    db $d8, $de, $2d, $c4, $b3, $1d, $c6, $01, $bc, $dd, $c6, $fd, $b3, $bc, $c0, $01
    db $01, $1b, $d4, $ca, $d7, $b6, $b2, $b7, $fe, $b3, $1d, $b0, $01, $b5, $b3, $e8
    db $dd, $bc, $01, $cc, $c0, $c0, $ee, $1b, $cf, $d8, $de, $2d, $c4, $b3, $1d, $b0
    db $01, $e8, $ff, $b6, $dd, $be, $d6, $01, $c5, $b5, $01, $33, $36, $c6, $c1, $b2
    db $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed
    db $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01
    db $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5d3f

section "Campaign Briefing PreMap 28", romx[$5d3f], bank[$33]
CampaignBriefing_PreMap_28::
    db $1b, $d7, $d0, $d8, $e5, $c0, $b2, $d8, $b8, $1d, $ce, $b3, $d2, $dd, $eb, $c9
    db $01, $be, $dd, $c4, $b3, $c9, $b1, $b2, $e8, $c6, $20, $cc, $c0, $c0, $ee, $01
    db $1b, $d0, $ef, $db, $dd, $ca, $dd, $c4, $b3, $1d, $c6, $01, $c3, $b7, $de, $20
    db $bc, $dd, $c6, $fd, $b3, $bc, $c0, $01, $01, $b6, $b2, $b7, $fe, $b3, $b0, $20
    db $b5, $b3, $e8, $dd, $bc, $01, $1b, $d0, $ef, $db, $dd, $ca, $dd, $c4, $b3, $1d
    db $b0, $01, $cc, $c0, $c0, $ee, $20, $e8, $ff, $b6, $dd, $be, $d6, $01, $c5, $b5
    db $01, $33, $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7
    db $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2
    db $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd
    db $b3, $b2, $be, $d6, $00
    assert @ == $5dd4

section "Campaign Briefing PreMap 29", romx[$5dd4], bank[$33]
CampaignBriefing_PreMap_29::
    db $1b, $cf, $d8, $de, $2d, $c4, $b3, $1d, $b5, $d6, $ee, $01, $1b, $d0, $ef, $db
    db $dd, $ca, $dd, $c4, $b3, $1d, $cd, $c9, $01, $d6, $ee, $bb, $b8, $be, $dd, $b0
    db $20, $b5, $ba, $c5, $b3, $01, $01, $1b, $db, $ed, $dd, $bb, $ed, $b8, $1d, $c9
    db $01, $ba, $b3, $d8, $fc, $b8, $b0, $20, $b6, $b2, $bc, $bd, $d9, $01, $01, $01
    db $c5, $b5, $01, $33, $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01
    db $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9
    db $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20
    db $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5e4b

section "Campaign Briefing PreMap 30", romx[$5e4b], bank[$33]
CampaignBriefing_PreMap_30::
    db $1b, $cf, $d8, $de, $2d, $c4, $b3, $1d, $c9, $01, $c1, $fd, $b3, $b5, $b3, $ef
    db $b0, $20, $b5, $bb, $b4, $d9, $01, $c3, $b7, $b7, $fe, $c3, $dd, $b0, $20, $ba
    db $b3, $d8, $fc, $b8, $bd, $d9, $01, $01, $cf, $e5, $01, $1b, $d8, $ec, $2d, $dd
    db $de, $dc, $1d, $b0, $20, $b5, $b3, $e8, $dd, $bc, $01, $c3, $b7, $b7, $fe, $c3
    db $dd, $b0, $20, $be, $dd, $d8, $fe, $b3, $be, $d6, $01, $01, $c5, $b5, $01, $33
    db $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb
    db $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8
    db $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2
    db $be, $d6, $00
    assert @ == $5ece

section "Campaign Briefing PreMap 31", romx[$5ece], bank[$33]
CampaignBriefing_PreMap_31::
    db $c5, $b2, $d8, $b8, $c6, $20, $ba, $b3, $c0, $b2, $bc, $c0, $20, $c3, $b7, $ca
    db $01, $1b, $cf, $b9, $e7, $dd, $b1, $da, $c1, $1d, $cf, $b4, $c6, $01, $f1, $b3
    db $df, $fe, $e4, $dd, $c1, $b0, $20, $ba, $b3, $c1, $b8, $bc, $c0, $01, $01, $ba
    db $c9, $f1, $b3, $df, $fe, $e4, $dd, $c1, $b0, $20, $c4, $ff, $f2, $bc, $c3, $01
    db $c3, $b7, $b7, $fe, $c3, $dd, $b0, $20, $be, $dd, $d8, $fe, $b3, $be, $d6, $01
    db $01, $01, $c5, $b5, $01, $33, $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7
    db $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc
    db $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd
    db $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $5f57

section "Campaign Briefing PreMap 32", romx[$5f57], bank[$33]
CampaignBriefing_PreMap_32::
    db $1b, $d8, $da, $f0, $b6, $b2, $db, $b3, $1d, $b0, $20, $dc, $da, $dc, $da, $de
    db $01, $b6, $b8, $ce, $bc, $c0, $ed, $b1, $b2, $01, $c3, $b7, $ca, $20, $ce, $b7
    db $fd, $b3, $be, $dd, $b0, $01, $b3, $bc, $c5, $b3, $e8, $db, $b3, $01, $01, $c4
    db $b3, $e6, $dd, $20, $c3, $b7, $c9, $20, $c3, $b2, $ba, $b3, $d3, $01, $ca, $e1
    db $bc, $b2, $ba, $c4, $de, $20, $d6, $bf, $b3, $bb, $da, $d9, $01, $01, $ba, $c9
    db $c3, $b7, $b0, $20, $ca, $b2, $e4, $fe, $bc, $01, $1b, $d8, $da, $f0, $b6, $b2
    db $db, $b3, $1d, $b0, $20, $b6, $b8, $ce, $be, $d6, $01, $01, $c5, $b5, $01, $33
    db $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb
    db $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8
    db $c4, $c5, $d9, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be
    db $d6, $00
    assert @ == $5ff9

section "Campaign Briefing PreMap 33", romx[$5ff9], bank[$33]
CampaignBriefing_PreMap_33::
    db $1b, $cf, $d8, $de, $2d, $c4, $b3, $1d, $c1, $fd, $b3, $b5, $b3, $ef, $eb, $c9
    db $01, $d6, $b3, $ec, $b3, $c6, $d6, $ff, $c3, $20, $c6, $bc, $c9, $01, $b6, $b2
    db $de, $dd, $cd, $c9, $20, $dc, $de, $e0, $dd, $c9, $01, $e4, $fe, $b3, $d8, $b8
    db $ca, $20, $be, $b2, $ba, $b3, $bc, $c0, $01, $01, $ba, $c9, $b7, $fe, $c3, $dd
    db $b0, $b6, $b8, $e8, $b2, $bc, $01, $c3, $b7, $b0, $be, $dd, $d2, $c2, $be, $d6
    db $01, $01, $c5, $b5, $01, $33, $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7
    db $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc
    db $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd
    db $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $6082

section "Campaign Briefing PreMap 34", romx[$6082], bank[$33]
CampaignBriefing_PreMap_34::
    db $1b, $cf, $d8, $de, $2d, $c4, $b3, $1d, $c9, $20, $ba, $b3, $d8, $fc, $b8, $c6
    db $01, $be, $b2, $ba, $b3, $bc, $c0, $20, $dc, $da, $dc, $da, $ca, $01, $c2, $df
    db $c6, $20, $1b, $d0, $ef, $db, $dd, $ca, $dd, $c4, $b3, $1d, $cd, $c9, $01, $e4
    db $fe, $b3, $d8, $b8, $c6, $20, $c9, $d8, $e8, $bc, $c0, $01, $01, $e6, $dd, $d2
    db $dd, $c6, $20, $c3, $dd, $b6, $b2, $bd, $d9, $01, $c3, $b7, $b6, $dd, $c0, $b2
    db $b0, $20, $ca, $b2, $e4, $fe, $bc, $c3, $01, $1b, $d0, $ef, $db, $dd, $ca, $dd
    db $c4, $b3, $1d, $cd, $c9, $01, $b7, $fe, $c3, $dd, $b0, $20, $b6, $b8, $ce, $be
    db $d6, $01, $01, $c5, $b5, $01, $33, $36, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3
    db $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da
    db $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef
    db $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $612c

section "Campaign Briefing PreMap 35", romx[$612c], bank[$33]
CampaignBriefing_PreMap_35::
    db $c3, $b7, $c9, $20, $ce, $dd, $b7, $fe, $c1, $ca, $20, $c1, $b6, $b2, $01, $bc
    db $b6, $bc, $20, $bf, $c9, $cf, $b4, $c6, $20, $c0, $c1, $ca, $e8, $b6, $d9, $01
    db $1b, $ee, $ff, $bd, $d1, $bb, $ed, $b8, $1d, $b0, $01, $c4, $ff, $f2, $bc, $c5
    db $b9, $da, $ed, $20, $c5, $d7, $c5, $b2, $01, $01, $c3, $b7, $ef, $c0, $b2, $b0
    db $20, $ca, $b2, $e4, $fe, $bc, $01, $c3, $b7, $b7, $fe, $c3, $dd, $b0, $20, $be
    db $dd, $d8, $fe, $b3, $be, $d6, $01, $01, $c5, $b5, $01, $33, $36, $c6, $c1, $b2
    db $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed
    db $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01
    db $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $61bb

section "Campaign Briefing PreMap 36", romx[$61bb], bank[$33]
CampaignBriefing_PreMap_36::
    db $1b, $d7, $d0, $d8, $e5, $c0, $b2, $d8, $b8, $1d, $bb, $b2, $e2, $c9, $01, $c3
    db $b7, $20, $ce, $b7, $fd, $b3, $b7, $c1, $20, $eb, $b1, $d9, $01, $1b, $d8, $fd
    db $b3, $c9, $ca, $e4, $cf, $1d, $b0, $20, $c0, $c0, $b9, $01, $01, $c5, $b5, $01
    db $33, $38, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca
    db $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1
    db $b8, $c4, $c5, $d9, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2
    db $be, $d6, $00
    assert @ == $621e

section "Campaign Briefing PreMap 37", romx[$621e], bank[$33]
CampaignBriefing_PreMap_37::
    db $1b, $d8, $da, $f0, $b6, $b2, $db, $b3, $1d, $b0, $20, $b5, $b5, $b7, $b8, $01
    db $b3, $b6, $b2, $bc, $20, $c3, $b7, $de, $20, $c0, $c3, $ba, $d3, $d9, $01, $1b
    db $bb, $b7, $bc, $fe, $c4, $b3, $1d, $b0, $01, $ba, $b3, $d8, $fc, $b8, $be, $d6
    db $01, $01, $01, $01, $01, $c5, $b5, $01, $33, $38, $c6, $c1, $b2, $c5, $b2, $c6
    db $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01
    db $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd
    db $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $628a

section "Campaign Briefing PreMap 38", romx[$628a], bank[$33]
CampaignBriefing_PreMap_38::
    db $1b, $d0, $ef, $db, $dd, $ca, $dd, $c4, $b3, $1d, $b6, $d7, $01, $ba, $b3, $c0
    db $b2, $bc, $c0, $20, $c3, $b7, $de, $01, $1b, $e8, $d1, $de, $dd, $e0, $dd, $c4
    db $b3, $1d, $c6, $01, $bc, $fd, $b3, $b9, $c2, $20, $bc, $c3, $b2, $d9, $01, $01
    db $ba, $da, $d6, $d8, $20, $dc, $da, $dc, $da, $ca, $01, $1b, $e8, $d1, $de, $dd
    db $e0, $dd, $c4, $b3, $1d, $c9, $01, $ba, $b3, $d8, $fc, $b8, $b0, $20, $b6, $b2
    db $bc, $bd, $d9, $01, $c5, $b5, $01, $33, $38, $c6, $c1, $b2, $c5, $b2, $c6, $20
    db $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc
    db $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3
    db $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $6315

section "Campaign Briefing PreMap 39", romx[$6315], bank[$33]
CampaignBriefing_PreMap_39::
    db $c3, $b7, $ca, $20, $ba, $c9, $c0, $b2, $d8, $b8, $b6, $d7, $01, $e8, $ff, $bc
    db $fd, $c2, $b0, $20, $b6, $b2, $bc, $bc, $c0, $01, $01, $ba, $c9, $b7, $c6, $20
    db $e4, $fe, $b3, $e4, $c3, $01, $c3, $b7, $e6, $dd, $e4, $fe, $b3, $d8, $b8, $b0
    db $20, $b6, $dd, $ba, $b3, $bc, $01, $c3, $b7, $b7, $fe, $c3, $dd, $b0, $20, $be
    db $dd, $d8, $fe, $b3, $be, $d6, $01, $01, $01, $c5, $b5, $01, $33, $38, $c6, $c1
    db $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2
    db $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9
    db $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $6395

section "Campaign Briefing PreMap 40", romx[$6395], bank[$33]
CampaignBriefing_PreMap_40::
    db $c3, $b7, $ce, $dd, $b7, $fe, $c1, $cd, $c9, $01, $e4, $fd, $dd, $ee, $ba, $b3
    db $e1, $b7, $20, $c4, $bc, $c3, $01, $1b, $de, $2d, $e1, $dd, $b6, $b2, $1d, $b0
    db $20, $b5, $b3, $e8, $dd, $bc, $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3, $1d
    db $cd, $c9, $01, $ba, $b3, $e1, $b7, $b0, $20, $b5, $ba, $c5, $b3, $01, $01, $c4
    db $c1, $fd, $b3, $20, $c3, $b7, $b6, $dd, $c0, $b2, $c9, $01, $bc, $fd, $c2, $e1
    db $dd, $de, $20, $d6, $bf, $b3, $bb, $da, $d9, $01, $ba, $da, $d7, $b0, $20, $ca
    db $b2, $e4, $fe, $bc, $01, $e4, $fe, $b3, $d8, $b8, $c1, $c3, $dd, $b0, $20, $b6
    db $b8, $ce, $be, $d6, $01, $01, $c5, $b5, $01, $33, $38, $c6, $c1, $b2, $c5, $b2
    db $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2
    db $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $e4, $fd
    db $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $6441

section "Campaign Briefing PreMap 41", romx[$6441], bank[$33]
CampaignBriefing_PreMap_41::
    db $c3, $b7, $ce, $dd, $b7, $fe, $c1, $cd, $c9, $01, $e4, $fd, $dd, $ee, $ba, $b3
    db $e1, $b7, $c4, $bc, $c3, $01, $1b, $ef, $d8, $e8, $2d, $b6, $b2, $1d, $b0, $20
    db $b5, $b3, $e8, $dd, $bc, $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3, $1d, $cd
    db $c9, $ba, $b3, $e1, $b7, $b0, $01, $b5, $ba, $c5, $b3, $01, $01, $c4, $c1, $fd
    db $b3, $20, $c3, $b7, $b6, $dd, $c0, $b2, $c9, $01, $f1, $b3, $de, $b2, $de, $20
    db $d6, $bf, $b3, $bb, $da, $d9, $01, $ba, $da, $d7, $b0, $20, $ca, $b2, $e4, $fe
    db $bc, $20, $c3, $b7, $b7, $c1, $b0, $01, $cc, $dd, $bb, $b2, $be, $d6, $01, $01
    db $c5, $b5, $01, $33, $38, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01
    db $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9
    db $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1
    db $fd, $b3, $b2, $be, $d6, $00
    assert @ == $64e7

section "Campaign Briefing PreMap 42", romx[$64e7], bank[$33]
CampaignBriefing_PreMap_42::
    db $1b, $d2, $c0, $db, $dd, $b6, $b2, $1d, $b0, $20, $b5, $b3, $e8, $dd, $bc, $01
    db $c3, $b7, $ce, $dd, $b7, $fe, $c1, $eb, $b1, $d9, $01, $1b, $c6, $ec, $cd, $e0
    db $dd, $c4, $b3, $1d, $cd, $c9, $01, $ba, $b3, $e1, $b7, $b0, $20, $b5, $ba, $c5
    db $b3, $01, $01, $c3, $b7, $c9, $c3, $b2, $ba, $b3, $ca, $20, $ca, $e1, $bc, $b2
    db $d3, $c9, $c4, $01, $d6, $bf, $b8, $bb, $da, $d9, $20, $c1, $fd, $b3, $b2, $be
    db $d6, $01, $01, $c5, $b5, $01, $33, $38, $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3
    db $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7, $c5, $b2, $ed, $b1, $b2, $01, $dc, $da
    db $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4, $c5, $d9, $01, $01, $e4, $fd, $b3, $ef
    db $dd, $c6, $20, $c1, $fd, $b3, $b2, $be, $d6, $00
    assert @ == $6571

section "Campaign Briefing PreMap 43", romx[$6571], bank[$33]
CampaignBriefing_PreMap_43::
    db $ba, $da, $d6, $d8, $20, $dc, $da, $dc, $da, $ca, $01, $c3, $b7, $20, $ce, $dc
    db $b2, $c4, $d1, $2d, $dd, $c9, $01, $bb, $b2, $bc, $fd, $b3, $20, $ba, $b3, $d8
    db $fc, $b8, $20, $bb, $b8, $be, $dd, $01, $1b, $f4, $d7, $dd, $42, $1d, $b0, $20
    db $e4, $ff, $ba, $b3, $bd, $d9, $01, $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3
    db $1d, $c6, $bc, $d6, $d8, $01, $e4, $fe, $b3, $d8, $b8, $b0, $20, $b6, $b2, $bc
    db $bc, $01, $c3, $b7, $bc, $fd, $c4, $b0, $20, $ba, $b3, $d8, $fc, $b8, $be, $d6
    db $01, $c3, $b7, $c9, $20, $c3, $b2, $ba, $b3, $ca, $20, $b7, $dc, $d2, $c3, $01
    db $ca, $e1, $bc, $b2, $ba, $c4, $de, $20, $d6, $bf, $b3, $bb, $da, $d9, $de, $01
    db $b6, $b8, $b2, $dd, $20, $e6, $dd, $d8, $fe, $b8, $eb, $01, $ba, $da, $b0, $20
    db $ca, $b2, $e4, $fe, $be, $d6, $01, $01, $01, $01, $01, $c5, $b5, $01, $34, $30
    db $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7
    db $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4
    db $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be
    db $d6, $00
    assert @ == $6643

section "Campaign Briefing PreMap 44", romx[$6643], bank[$33]
CampaignBriefing_PreMap_44::
    db $ba, $da, $d6, $d8, $20, $dc, $da, $dc, $da, $ca, $01, $c3, $b7, $20, $ce, $dc
    db $b2, $c4, $d1, $2d, $dd, $c9, $01, $bb, $b2, $bc, $fd, $b3, $20, $ba, $b3, $d8
    db $fc, $b8, $20, $bb, $b8, $be, $dd, $01, $1b, $f4, $d7, $dd, $41, $1d, $b0, $20
    db $e4, $ff, $ba, $b3, $bd, $d9, $01, $01, $1b, $c6, $ec, $cd, $e0, $dd, $c4, $b3
    db $1d, $b7, $c0, $d6, $d8, $01, $e4, $fe, $b3, $d8, $b8, $b0, $20, $b6, $b2, $bc
    db $bc, $01, $c3, $b7, $bc, $fd, $c4, $b0, $20, $ba, $b3, $d8, $fc, $b8, $be, $d6
    db $01, $c3, $b7, $c9, $20, $c3, $b2, $ba, $b3, $ca, $20, $b7, $dc, $d2, $c3, $01
    db $ca, $e1, $bc, $b2, $ba, $c4, $de, $20, $d6, $bf, $b3, $bb, $da, $d9, $de, $01
    db $b6, $b8, $b2, $dd, $20, $e6, $dd, $d8, $fe, $b8, $eb, $01, $ba, $da, $b0, $20
    db $ca, $b2, $e4, $fe, $be, $d6, $01, $01, $01, $01, $01, $c5, $b5, $01, $34, $30
    db $c6, $c1, $b2, $c5, $b2, $c6, $20, $c3, $b7, $b0, $01, $e1, $b7, $ca, $eb, $b7
    db $c5, $b2, $ed, $b1, $b2, $01, $dc, $da, $dc, $da, $c9, $ca, $b2, $f1, $b8, $c4
    db $c5, $d9, $01, $01, $e4, $fd, $b3, $ef, $dd, $c6, $20, $c1, $fd, $b3, $b2, $be
    db $d6, $00
    assert @ == $6715

section "Campaign Briefing PreMap Extra45", romx[$6715], bank[$33]
CampaignBriefing_PreMap_Extra45::
    db $93, $8d, $78, $8d, $75, $8e, $87, $01, $6a, $8d, $66, $62, $79, $6b, $68, $6e
    db $8d, $7a, $01, $6c, $af, $a2, $62, $76, $65, $8c, $af, $70, $2e, $01, $01, $6c
    db $66, $6c, $2c, $6a, $79, $7f, $7f, $9b, $7a, $01, $8c, $8e, $90, $8d, $79, $7a
    db $62, $a1, $68, $7a, $01, $7b, $af, $6c, $9b, $61, $89, $2e, $01, $01, $6e, $8d
    db $94, $ad, $72, $60, $68, $7c, $63, $6c, $01, $7c, $70, $70, $9e, $7a, $8d, $91
    db $67, $60, $01, $66, $62, $6c, $6e, $86, $2e, $00
    assert @ == $676f

section "Campaign Briefing ResultA 00", romx[$676f], bank[$33]
CampaignBriefing_ResultA_00::
    db $65, $82, $9b, $74, $63, $2e, $01, $67, $80, $79, $6c, $67, $76, $86, $88, $01
    db $91, $62, $91, $67, $7a, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $73, $67
    db $90, $8d, $7a, $01, $1b, $b8, $b3, $fa, $d9, $66, $62, $8e, $8d, $1d, $7d, $01
    db $6a, $63, $70, $62, $6c, $70, $2e, $01, $01, $1b, $b8, $b3, $fa, $d9, $66, $62
    db $8e, $8d, $1d, $7d, $01, $96, $8d, $6c, $8d, $6e, $86, $2e, $00
    assert @ == $67bc

section "Campaign Briefing ResultA 01", romx[$67bc], bank[$33]
CampaignBriefing_ResultA_01::
    db $73, $67, $7a, $01, $1b, $c0, $ee, $cf, $ca, $c5, $6b, $9d, $68, $1d, $7e, $63
    db $82, $8d, $76, $01, $6a, $63, $70, $62, $6c, $70, $2e, $01, $01, $1b, $c0, $ee
    db $cf, $ca, $c5, $6b, $9d, $68, $1d, $76, $81, $66, $62, $01, $73, $67, $60, $91
    db $67, $7a, $6e, $86, $2e, $00
    assert @ == $67f2

section "Campaign Briefing ResultA 02", romx[$67f2], bank[$33]
CampaignBriefing_ResultA_02::
    db $91, $62, $91, $67, $7a, $6e, $62, $6a, $63, $98, $2e, $01, $01, $6e, $62, $68
    db $63, $69, $8d, $60, $63, $6c, $75, $af, $70, $01, $ce, $dc, $b2, $c4, $d1, $2d
    db $dd, $7a, $2c, $67, $71, $60, $01, $7e, $63, $67, $6c, $1b, $f0, $f8, $c4, $dd
    db $6b, $9d, $68, $1d, $7d, $01, $6a, $63, $70, $62, $6c, $70, $2e, $01, $01, $72
    db $62, $91, $67, $60, $66, $62, $6c, $6e, $86, $2e, $00
    assert @ == $683d

section "Campaign Briefing ResultA 03", romx[$683d], bank[$33]
CampaignBriefing_ResultA_03::
    db $75, $62, $88, $68, $9f, $79, $73, $67, $60, $01, $91, $67, $6e, $8d, $79, $6d
    db $64, $76, $01, $68, $71, $68, $6c, $70, $2e, $01, $01, $73, $67, $7a, $01, $1b
    db $c9, $d9, $f1, $8e, $8c, $1d, $7e, $63, $82, $8d, $76, $01, $70, $62, $67, $ac
    db $68, $6c, $70, $2e, $01, $01, $1b, $c9, $d9, $f1, $8e, $8c, $1d, $76, $73, $01
    db $70, $62, $67, $ac, $68, $6c, $70, $73, $67, $79, $01, $72, $62, $91, $67, $60
    db $66, $62, $6c, $6e, $86, $2e, $00
    assert @ == $6894

section "Campaign Briefing ResultA 04", romx[$6894], bank[$33]
CampaignBriefing_ResultA_04::
    db $7a, $91, $6c, $62, $6e, $8d, $74, $63, $79, $69, $af, $66, $01, $8c, $8a, $8c
    db $8a, $7a, $01, $1b, $f0, $f8, $c4, $dd, $6b, $9d, $68, $1d, $79, $74, $af, $a2
    db $76, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $72, $8f, $76, $8c, $8e
    db $90, $8d, $7a, $01, $1b, $bb, $c8, $cb, $8e, $8c, $1d, $7e, $63, $82, $8d, $76
    db $01, $96, $8d, $6c, $8d, $6d, $89, $2e, $00
    assert @ == $68dd

section "Campaign Briefing ResultA 05", romx[$68dd], bank[$33]
CampaignBriefing_ResultA_05::
    db $1b, $bb, $c8, $cb, $8e, $8c, $1d, $79, $67, $ae, $73, $8d, $60, $01, $63, $6c
    db $75, $af, $70, $73, $67, $7a, $01, $1b, $c9, $d9, $f1, $8e, $8c, $1d, $7e, $63
    db $82, $8d, $7d, $01, $6a, $63, $70, $62, $6c, $70, $2e, $01, $01, $6b, $68, $6e
    db $8d, $7a, $6e, $62, $6a, $63, $98, $2e, $01, $65, $82, $9b, $74, $63, $2e, $00
    assert @ == $691d

section "Campaign Briefing ResultA 06", romx[$691d], bank[$33]
CampaignBriefing_ResultA_06::
    db $1b, $d7, $ff, $bc, $b1, $7a, $8d, $74, $63, $1d, $7d, $01, $94, $ae, $63, $88
    db $68, $6c, $70, $73, $67, $90, $8d, $60, $01, $91, $67, $70, $62, $6c, $70, $2e
    db $01, $01, $8c, $8a, $8c, $8a, $7a, $01, $1b, $d8, $fd, $b3, $d9, $66, $62, $8e
    db $8d, $1d, $7e, $63, $82, $8d, $79, $01, $73, $67, $66, $8d, $70, $62, $60, $01
    db $6a, $63, $88, $ac, $68, $6d, $89, $2e, $00
    assert @ == $6966

section "Campaign Briefing ResultA 07", romx[$6966], bank[$33]
CampaignBriefing_ResultA_07::
    db $73, $67, $90, $8d, $7a, $01, $1b, $cc, $da, $b1, $2d, $74, $63, $1d, $7e, $63
    db $82, $8d, $79, $01, $67, $ae, $73, $8d, $60, $63, $6c, $75, $af, $70, $2e, $01
    db $01, $67, $80, $7a, $01, $9f, $70, $62, $60, $7b, $67, $62, $73, $01, $72, $8f
    db $79, $6e, $8d, $6e, $8d, $76, $62, $9c, $63, $6e, $86, $2e, $00
    assert @ == $69a3

section "Campaign Briefing ResultA 08", romx[$69a3], bank[$33]
CampaignBriefing_ResultA_08::
    db $7a, $91, $6c, $62, $70, $70, $66, $62, $79, $6d, $64, $01, $73, $67, $67, $ae
    db $73, $8d, $60, $01, $6e, $62, $61, $72, $6c, $70, $2e, $01, $01, $67, $ae, $73
    db $8d, $60, $63, $6c, $75, $af, $70, $01, $73, $67, $90, $8d, $7a, $2c, $01, $1b
    db $c3, $f8, $d7, $e4, $7a, $8d, $74, $63, $1d, $66, $87, $79, $01, $73, $af, $70
    db $62, $60, $66, $62, $6c, $6c, $70, $2e, $00
    assert @ == $69ec

section "Campaign Briefing ResultA 09", romx[$69ec], bank[$33]
CampaignBriefing_ResultA_09::
    db $1b, $c9, $e4, $2d, $66, $62, $67, $ae, $63, $1d, $79, $66, $68, $7e, $76, $01
    db $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $6f, $79, $69, $af, $66, $01, $1b
    db $c3, $f8, $c5, $dd, $8c, $8d, $1d, $7e, $63, $82, $8d, $7d, $79, $01, $d9, $2d
    db $c4, $60, $66, $68, $7e, $6c, $70, $2e, $01, $01, $6b, $68, $6e, $8d, $7a, $6e
    db $62, $6a, $63, $98, $2e, $00
    assert @ == $6a32

section "Campaign Briefing ResultA 10", romx[$6a32], bank[$33]
CampaignBriefing_ResultA_10::
    db $1b, $d8, $fd, $b3, $d9, $66, $62, $8e, $8d, $1d, $79, $73, $67, $60, $01, $91
    db $67, $7a, $6c, $70, $2e, $01, $01, $6f, $79, $69, $af, $66, $01, $75, $62, $88
    db $68, $9f, $79, $01, $1b, $c9, $d9, $f1, $8e, $8c, $1d, $7e, $63, $82, $8d, $7d
    db $79, $01, $7e, $67, $ad, $63, $6e, $8d, $60, $01, $66, $68, $7e, $6c, $70, $2e
    db $00
    assert @ == $6a73

section "Campaign Briefing ResultA 11", romx[$6a73], bank[$33]
CampaignBriefing_ResultA_11::
    db $1b, $c3, $2d, $c2, $8e, $8c, $1d, $79, $73, $67, $7a, $01, $66, $62, $82, $72
    db $6c, $70, $2e, $01, $01, $67, $ae, $73, $8d, $60, $63, $6c, $75, $af, $70, $73
    db $67, $7a, $01, $1b, $d7, $b2, $c4, $b3, $8c, $8d, $1d, $7e, $63, $82, $8d, $7d
    db $74, $01, $6a, $63, $70, $62, $6c, $70, $2e, $00
    assert @ == $6aad

section "Campaign Briefing ResultA 12", romx[$6aad], bank[$33]
CampaignBriefing_ResultA_12::
    db $1b, $c3, $f8, $c5, $dd, $8c, $8d, $1d, $79, $01, $73, $67, $66, $8d, $70, $62
    db $7a, $01, $66, $62, $82, $72, $6c, $70, $2e, $01, $01, $6a, $8a, $76, $86, $88
    db $01, $1b, $e4, $ef, $d8, $d9, $74, $63, $1d, $7d, $79, $01, $94, $ae, $63, $88
    db $68, $8e, $01, $66, $79, $63, $76, $75, $af, $70, $2e, $00
    assert @ == $6ae9

section "Campaign Briefing ResultA 13", romx[$6ae9], bank[$33]
CampaignBriefing_ResultA_13::
    db $73, $67, $79, $66, $8d, $70, $62, $7a, $01, $66, $62, $82, $72, $6c, $2c, $6e
    db $62, $66, $62, $69, $8d, $60, $01, $63, $6c, $75, $af, $70, $2e, $01, $01, $6a
    db $8a, $9b, $01, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $7d, $79, $01
    db $61, $6c, $8e, $66, $88, $60, $72, $66, $8d, $98, $2e, $00
    assert @ == $6b25

section "Campaign Briefing ResultA 14", romx[$6b25], bank[$33]
CampaignBriefing_ResultA_14::
    db $1b, $d7, $b2, $c4, $b3, $8c, $8d, $1d, $76, $01, $70, $73, $6a, $83, $af, $73
    db $62, $70, $01, $73, $67, $7a, $96, $8d, $82, $72, $6c, $70, $2e, $01, $01, $8c
    db $8a, $8c, $8a, $7a, $01, $1b, $da, $2d, $cc, $c4, $f9, $dd, $8c, $8d, $1d, $7d
    db $79, $01, $96, $8d, $6c, $8d, $60, $01, $66, $62, $6c, $6d, $89, $2e, $00
    assert @ == $6b64

section "Campaign Briefing ResultA 15", romx[$6b64], bank[$33]
CampaignBriefing_ResultA_15::
    db $1b, $d8, $cf, $7a, $8d, $74, $63, $1d, $60, $01, $66, $68, $7e, $6c, $70, $6a
    db $74, $76, $86, $88, $01, $1b, $e4, $ef, $d8, $d9, $74, $63, $1d, $74, $01, $1b
    db $cf, $d8, $de, $2d, $74, $63, $1d, $79, $61, $62, $98, $79, $01, $73, $67, $7e
    db $67, $ad, $63, $6e, $8d, $60, $01, $9f, $8d, $98, $8d, $6c, $70, $2e, $01, $01
    db $01, $67, $80, $70, $71, $7a, $2c, $7c, $70, $70, $9e, $01, $1b, $d7, $d0, $d8
    db $e5, $70, $62, $88, $68, $1d, $7d, $74, $01, $73, $8d, $6c, $8d, $6e, $86, $2e
    db $00
    assert @ == $6bc5

section "Campaign Briefing ResultA 16", romx[$6bc5], bank[$33]
CampaignBriefing_ResultA_16::
    db $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $76, $01, $71, $ad, $63, $88
    db $ad, $63, $6d, $89, $73, $67, $90, $8d, $7a, $01, $7a, $91, $6c, $68, $73, $62
    db $6a, $63, $6c, $70, $8e, $01, $8c, $8a, $8c, $8a, $7a, $01, $6a, $79, $73, $67
    db $79, $7a, $62, $94, $ae, $76, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01
    db $01, $6f, $6c, $73, $2c, $7c, $70, $70, $9e, $01, $1b, $d7, $d0, $d8, $e5, $70
    db $62, $88, $68, $1d, $7d, $01, $81, $66, $63, $6a, $74, $76, $75, $af, $70, $2e
    db $00
    assert @ == $6c26

section "Campaign Briefing ResultA 17", romx[$6c26], bank[$33]
CampaignBriefing_ResultA_17::
    db $1b, $da, $2d, $cc, $c4, $f9, $dd, $8c, $8d, $1d, $79, $01, $6e, $62, $61, $72
    db $76, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $01
    db $1b, $db, $ed, $dd, $6b, $9d, $68, $1d, $7d, $74, $01, $81, $66, $63, $6a, $74
    db $76, $75, $af, $70, $2e, $00
    assert @ == $6c5c

section "Campaign Briefing ResultA 18", romx[$6c5c], bank[$33]
CampaignBriefing_ResultA_18::
    db $8c, $8a, $8c, $8a, $7a, $01, $7a, $91, $6c, $62, $70, $70, $66, $62, $79, $6d
    db $64, $01, $1b, $de, $d8, $b1, $dd, $7a, $8d, $74, $63, $1d, $7d, $79, $01, $94
    db $ae, $63, $88, $68, $76, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $01
    db $01, $6a, $79, $7f, $7f, $01, $1b, $ed, $c4, $cf, $dd, $66, $62, $1d, $60, $65
    db $63, $98, $8d, $6c, $01, $1b, $e8, $e5, $dd, $8c, $8d, $1d, $7e, $63, $82, $8d
    db $76, $01, $76, $91, $6a, $8d, $98, $73, $67, $79, $72, $62, $91, $67, $60, $01
    db $66, $62, $6c, $6e, $86, $2e, $00
    assert @ == $6cc3

section "Campaign Briefing ResultA 19", romx[$6cc3], bank[$33]
CampaignBriefing_ResultA_19::
    db $73, $67, $7a, $62, $92, $7d, $79, $01, $94, $ae, $63, $88, $68, $76, $6e, $62
    db $6a, $63, $6c, $70, $2e, $01, $01, $6f, $79, $69, $af, $66, $01, $1b, $de, $d8
    db $b1, $dd, $7a, $8d, $74, $63, $1d, $76, $62, $89, $01, $73, $67, $7a, $6a, $88
    db $72, $6c, $70, $2e, $01, $01, $01, $8c, $8a, $8c, $8a, $7a, $6a, $79, $7f, $7f
    db $01, $1b, $e8, $e5, $dd, $8c, $8d, $1d, $7e, $63, $82, $8d, $76, $01, $6a, $63
    db $91, $67, $60, $66, $62, $6c, $6d, $89, $2e, $00
    assert @ == $6d1d

section "Campaign Briefing ResultA 20", romx[$6d1d], bank[$33]
CampaignBriefing_ResultA_20::
    db $1b, $ef, $e8, $dd, $7a, $8d, $74, $63, $1d, $7d, $79, $01, $8c, $8a, $8c, $8a
    db $79, $94, $ae, $63, $88, $68, $7a, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01
    db $01, $6b, $87, $76, $01, $70, $62, $8e, $8d, $79, $73, $67, $67, $71, $79, $01
    db $6e, $62, $61, $72, $76, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $6a, $8a
    db $9b, $8c, $8a, $8c, $8a, $7a, $01, $1b, $b1, $ff, $c2, $8c, $8d, $1d, $79, $61
    db $8d, $96, $8d, $60, $01, $66, $68, $7e, $6c, $70, $2e, $00
    assert @ == $6d79

section "Campaign Briefing ResultA 21", romx[$6d79], bank[$33]
CampaignBriefing_ResultA_21::
    db $1b, $bd, $db, $f1, $98, $62, $71, $1d, $79, $73, $67, $90, $8d, $8e, $01, $8c
    db $8a, $8c, $8a, $79, $6f, $68, $82, $8d, $76, $01, $74, $63, $70, $72, $6d, $89
    db $7f, $64, $76, $01, $73, $67, $67, $ae, $73, $8d, $60, $6e, $62, $61, $72, $6c
    db $70, $2e, $01, $01, $67, $ae, $73, $8d, $60, $63, $6c, $75, $af, $70, $73, $67
    db $7a, $01, $1b, $e8, $e5, $dd, $8c, $8d, $1d, $7d, $01, $6a, $63, $70, $62, $6c
    db $70, $2e, $01, $1b, $e8, $e5, $dd, $8c, $8d, $1d, $76, $81, $66, $62, $01, $73
    db $67, $60, $91, $67, $7a, $6e, $86, $2e, $00
    assert @ == $6de2

section "Campaign Briefing ResultA 22", romx[$6de2], bank[$33]
CampaignBriefing_ResultA_22::
    db $1b, $e8, $e5, $dd, $8c, $8d, $1d, $79, $01, $73, $67, $66, $8d, $70, $62, $60
    db $01, $91, $67, $70, $62, $6c, $70, $2e, $01, $01, $7f, $70, $01, $73, $67, $67
    db $71, $79, $6e, $8d, $88, $ae, $63, $83, $01, $9c, $63, $94, $76, $6e, $62, $6a
    db $63, $6c, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $01, $1b, $ed, $ec, $2d
    db $6b, $8d, $80, $ac, $68, $1d, $60, $6a, $64, $01, $1b, $d7, $d0, $d8, $e5, $70
    db $62, $88, $68, $1d, $7d, $01, $81, $66, $63, $2e, $00
    assert @ == $6e3d

section "Campaign Briefing ResultA 23", romx[$6e3d], bank[$33]
CampaignBriefing_ResultA_23::
    db $73, $67, $7a, $01, $8c, $8e, $90, $8d, $79, $6a, $63, $91, $67, $76, $86, $88
    db $01, $1b, $ef, $e8, $dd, $7a, $8d, $74, $63, $1d, $9b, $79, $01, $6e, $8d, $88
    db $ae, $68, $74, $67, $ae, $73, $8d, $60, $01, $63, $6c, $75, $af, $70, $2e, $01
    db $01, $01, $01, $73, $67, $90, $8d, $7a, $01, $1b, $db, $dd, $ec, $6b, $9d, $68
    db $1d, $7e, $63, $82, $8d, $7d, $01, $6a, $63, $70, $62, $6c, $73, $62, $af, $70
    db $2e, $00
    assert @ == $6e8f

section "Campaign Briefing ResultA 24", romx[$6e8f], bank[$33]
CampaignBriefing_ResultA_24::
    db $73, $67, $79, $01, $1b, $bd, $b7, $d1, $6b, $9d, $68, $1d, $67, $71, $60, $01
    db $6e, $8d, $88, $ae, $63, $6c, $70, $2e, $01, $01, $67, $ae, $73, $8d, $60, $63
    db $6c, $75, $af, $70, $73, $67, $7a, $01, $1b, $d8, $cf, $7a, $8d, $74, $63, $1d
    db $66, $87, $01, $73, $af, $70, $62, $6c, $70, $2e, $00
    assert @ == $6eca

section "Campaign Briefing ResultA 25", romx[$6eca], bank[$33]
CampaignBriefing_ResultA_25::
    db $1b, $ed, $ec, $2d, $6b, $8d, $80, $ac, $68, $1d, $60, $6a, $64, $01, $73, $67
    db $79, $67, $ae, $73, $8d, $60, $01, $6e, $8d, $88, $ae, $63, $6c, $70, $2e, $01
    db $01, $6a, $8a, $9b, $01, $1b, $d7, $d0, $d8, $e5, $70, $62, $88, $68, $1d, $66
    db $87, $01, $73, $67, $60, $91, $67, $70, $62, $6d, $89, $6a, $74, $76, $01, $6e
    db $62, $6a, $63, $6c, $70, $2e, $00
    assert @ == $6f11

section "Campaign Briefing ResultA 26", romx[$6f11], bank[$33]
CampaignBriefing_ResultA_26::
    db $73, $67, $79, $6a, $63, $68, $63, $9f, $70, $62, $8e, $01, $61, $87, $8c, $8a
    db $70, $8e, $01, $6e, $62, $61, $72, $76, $6e, $62, $6a, $63, $6c, $70, $2e, $01
    db $01, $1b, $d7, $d0, $d8, $e5, $70, $62, $88, $68, $1d, $7a, $01, $8c, $8e, $90
    db $8d, $8e, $2c, $66, $8d, $96, $8d, $76, $01, $6e, $8d, $88, $ae, $63, $6c, $70
    db $2e, $00
    assert @ == $6f53

section "Campaign Briefing ResultA 27", romx[$6f53], bank[$33]
CampaignBriefing_ResultA_27::
    db $8c, $8a, $8c, $8a, $7a, $01, $1b, $d4, $ca, $d7, $66, $62, $67, $ae, $63, $1d
    db $79, $01, $65, $63, $98, $8d, $76, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01
    db $7c, $70, $70, $9e, $01, $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $76, $01, $67
    db $ae, $73, $8d, $60, $66, $68, $7e, $6c, $70, $2e, $00
    assert @ == $6f8e

section "Campaign Briefing ResultA 28", romx[$6f8e], bank[$33]
CampaignBriefing_ResultA_28::
    db $1b, $bd, $c3, $dd, $66, $62, $67, $ae, $63, $1d, $79, $01, $73, $67, $66, $8d
    db $70, $62, $60, $2c, $91, $67, $7a, $6c, $01, $73, $67, $67, $ae, $73, $8d, $60
    db $01, $6e, $8d, $88, $ae, $63, $6c, $70, $2e, $01, $01, $7c, $70, $70, $9e, $01
    db $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $7d, $01, $67, $ae, $73, $8d
    db $60, $66, $68, $7e, $6c, $70, $2e, $00
    assert @ == $6fd6

section "Campaign Briefing ResultA 29", romx[$6fd6], bank[$33]
CampaignBriefing_ResultA_29::
    db $86, $6f, $63, $86, $88, $01, $67, $ae, $63, $88, $ae, $68, $75, $73, $67, $90
    db $8d, $8e, $01, $1b, $db, $ed, $dd, $6b, $9d, $68, $1d, $76, $01, $71, $ad, $63
    db $74, $8d, $6c, $73, $62, $70, $8e, $01, $6a, $79, $73, $67, $90, $8d, $79, $91
    db $67, $7a, $76, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $01, $1b, $db
    db $ed, $dd, $6b, $9d, $68, $1d, $60, $01, $65, $6b, $64, $70, $6a, $74, $9b, $01
    db $73, $67, $7e, $67, $ad, $63, $6e, $8d, $79, $01, $9f, $8d, $98, $8d, $76, $6e
    db $62, $6a, $63, $6c, $70, $2e, $01, $01, $1b, $d8, $da, $f0, $66, $62, $8b, $63
    db $1d, $86, $88, $01, $6a, $63, $91, $67, $60, $66, $62, $6c, $6e, $86, $2e, $00
    assert @ == $7056

section "Campaign Briefing ResultA 30", romx[$7056], bank[$33]
CampaignBriefing_ResultA_30::
    db $1b, $d8, $ec, $2d, $dd, $8e, $8c, $1d, $79, $01, $96, $8d, $82, $8d, $76, $73
    db $8d, $66, $62, $6d, $89, $01, $73, $67, $9f, $70, $62, $60, $7a, $62, $94, $ae
    db $6c, $01, $73, $67, $67, $ae, $73, $8d, $79, $6e, $62, $61, $72, $76, $01, $6e
    db $62, $6a, $63, $6c, $70, $2e, $00
    assert @ == $708d

section "Campaign Briefing ResultA 31", romx[$708d], bank[$33]
CampaignBriefing_ResultA_31::
    db $1b, $cf, $b9, $e7, $dd, $61, $8a, $71, $1d, $79, $01, $73, $67, $9f, $70, $62
    db $60, $7a, $62, $94, $ae, $6c, $70, $2e, $01, $01, $8c, $8a, $8c, $8a, $7a, $01
    db $73, $67, $67, $ae, $73, $8d, $79, $6e, $8d, $88, $ae, $63, $76, $01, $6e, $62
    db $6a, $63, $6c, $70, $2e, $00
    assert @ == $70c3

section "Campaign Briefing ResultA 32", romx[$70c3], bank[$33]
CampaignBriefing_ResultA_32::
    db $73, $67, $7a, $01, $7a, $91, $6c, $68, $73, $62, $6a, $63, $6c, $70, $8e, $01
    db $7a, $91, $6c, $62, $70, $70, $66, $62, $79, $6d, $64, $01, $74, $63, $6c, $ae
    db $79, $83, $68, $7b, $ae, $63, $60, $01, $66, $68, $7e, $6c, $70, $2e, $01, $01
    db $01, $01, $8c, $8a, $8c, $8a, $7a, $01, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74
    db $63, $1d, $79, $01, $80, $75, $80, $7e, $63, $82, $8d, $79, $01, $1b, $ee, $ff
    db $bd, $d1, $6b, $9d, $68, $1d, $76, $01, $6c, $8d, $91, $67, $60, $66, $62, $6c
    db $6d, $89, $2e, $00
    assert @ == $7127

section "Campaign Briefing ResultA 33", romx[$7127], bank[$33]
CampaignBriefing_ResultA_33::
    db $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $76, $01, $71, $ad, $63, $88, $ad, $63
    db $6d, $89, $01, $73, $67, $66, $8d, $70, $62, $65, $86, $9e, $01, $1b, $bd, $d8
    db $b8, $6b, $9d, $68, $1d, $76, $7b, $6f, $81, $01, $73, $67, $67, $6a, $63, $9f
    db $70, $62, $60, $01, $6c, $88, $97, $69, $70, $2e, $01, $01, $01, $6a, $8a, $9b
    db $1b, $cf, $d8, $de, $2d, $74, $63, $1d, $79, $01, $73, $67, $6e, $8d, $88, $ae
    db $68, $7a, $01, $96, $8d, $82, $72, $6c, $70, $2e, $00
    assert @ == $7182

section "Campaign Briefing ResultA 34", romx[$7182], bank[$33]
CampaignBriefing_ResultA_34::
    db $8c, $8a, $8c, $8a, $7a, $01, $1b, $bb, $e3, $2d, $dd, $66, $62, $1d, $60, $8c
    db $70, $88, $01, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $7d, $79, $01
    db $94, $ae, $63, $88, $68, $60, $7a, $70, $6c, $70, $2e, $01, $01, $6f, $6c, $73
    db $2c, $6a, $79, $6b, $68, $6e, $8d, $76, $86, $88, $01, $1b, $d0, $ef, $db, $dd
    db $7a, $8d, $74, $63, $1d, $79, $01, $6e, $8d, $6e, $8d, $7a, $2c, $61, $8d, $73
    db $62, $6c, $70, $2e, $01, $72, $8f, $76, $8c, $8a, $8c, $8a, $7a, $01, $1b, $d7
    db $d0, $d8, $e5, $70, $62, $88, $68, $1d, $7d, $01, $7a, $69, $8d, $6b, $8a, $89
    db $6a, $74, $76, $75, $af, $70, $2e, $00
    assert @ == $71fa

section "Campaign Briefing ResultA 35", romx[$71fa], bank[$33]
CampaignBriefing_ResultA_35::
    db $8c, $8a, $8c, $8a, $7a, $2c, $72, $62, $76, $01, $1b, $d0, $ef, $db, $dd, $7a
    db $8d, $74, $63, $1d, $79, $01, $6e, $62, $61, $72, $76, $6e, $62, $6a, $63, $6c
    db $70, $2e, $01, $01, $1b, $d0, $ef, $db, $dd, $7a, $8d, $74, $63, $1d, $60, $01
    db $65, $8c, $8a, $70, $73, $67, $90, $8d, $7a, $01, $1b, $e8, $d1, $de, $dd, $90
    db $8d, $74, $63, $1d, $76, $01, $6c, $ad, $63, $69, $72, $6c, $73, $62, $89, $2e
    db $01, $6a, $79, $73, $67, $60, $01, $70, $98, $71, $76, $91, $67, $7a, $6e, $86
    db $2e, $00
    assert @ == $725c

section "Campaign Briefing ResultA 36", romx[$725c], bank[$33]
CampaignBriefing_ResultA_36::
    db $62, $88, $68, $81, $71, $69, $62, $76, $01, $68, $89, $6c, $80, $72, $72, $83
    db $01, $73, $67, $9f, $70, $62, $79, $7a, $62, $94, $ae, $76, $01, $6e, $62, $6a
    db $63, $6c, $70, $2e, $01, $01, $01, $01, $01, $72, $8f, $76, $8c, $8a, $8c, $8a
    db $7a, $01, $1b, $bb, $b7, $6c, $ae, $74, $63, $1d, $7d, $79, $01, $97, $63, $64
    db $8d, $74, $6c, $73, $01, $7a, $69, $8d, $6b, $8a, $89, $2e, $00
    assert @ == $72a9

section "Campaign Briefing ResultA 37", romx[$72a9], bank[$33]
CampaignBriefing_ResultA_37::
    db $62, $88, $68, $81, $71, $69, $62, $76, $01, $68, $89, $6c, $80, $72, $72, $83
    db $01, $73, $67, $9f, $70, $62, $79, $7a, $62, $94, $ae, $76, $01, $6e, $62, $6a
    db $63, $6c, $70, $2e, $01, $01, $6a, $8a, $9b, $01, $6a, $79, $70, $62, $88, $68
    db $79, $73, $67, $60, $01, $66, $8d, $96, $8d, $76, $91, $67, $70, $62, $6c, $70
    db $2e, $00
    assert @ == $72eb

section "Campaign Briefing ResultA 38", romx[$72eb], bank[$33]
CampaignBriefing_ResultA_38::
    db $62, $88, $68, $81, $71, $69, $62, $76, $01, $68, $89, $6c, $80, $72, $72, $83
    db $01, $73, $67, $9f, $70, $62, $79, $7a, $62, $94, $ae, $76, $01, $6e, $62, $6a
    db $63, $6c, $70, $2e, $01, $01, $6a, $8a, $76, $73, $01, $6a, $79, $66, $62, $62
    db $67, $79, $6e, $62, $66, $62, $69, $8d, $60, $01, $73, $76, $62, $8a, $70, $2e
    db $00
    assert @ == $732c

section "Campaign Briefing ResultA 39", romx[$732c], bank[$33]
CampaignBriefing_ResultA_39::
    db $73, $67, $96, $8d, $94, $ae, $63, $88, $68, $7a, $01, $6a, $8d, $75, $8d, $60
    db $67, $8c, $82, $70, $8e, $01, $6e, $62, $6a, $63, $6c, $70, $2e, $01, $01, $6a
    db $8a, $9b, $01, $6a, $79, $70, $62, $88, $68, $79, $73, $67, $60, $01, $66, $8d
    db $96, $8d, $76, $91, $67, $70, $62, $6c, $70, $2e, $00
    assert @ == $7367

section "Campaign Briefing ResultA 40", romx[$7367], bank[$33]
CampaignBriefing_ResultA_40::
    db $73, $67, $7e, $8d, $9c, $79, $73, $62, $6a, $63, $7a, $01, $7b, $94, $ae, $63
    db $76, $7a, $91, $6c, $68, $01, $6b, $68, $6e, $8d, $7a, $01, $6a, $8d, $75, $8d
    db $60, $67, $8c, $82, $70, $2e, $01, $01, $01, $01, $01, $98, $8e, $01, $74, $63
    db $6c, $ae, $79, $86, $73, $62, $9c, $65, $88, $01, $62, $71, $65, $63, $79, $6e
    db $62, $6a, $63, $60, $01, $66, $68, $7e, $6c, $2c, $6a, $63, $70, $62, $6c, $70
    db $2e, $00
    assert @ == $73b9

section "Campaign Briefing ResultA 41", romx[$73b9], bank[$33]
CampaignBriefing_ResultA_41::
    db $73, $67, $7e, $8d, $9c, $79, $73, $62, $6a, $63, $7a, $01, $7b, $94, $ae, $63
    db $76, $7a, $91, $6c, $68, $01, $6b, $68, $6e, $8d, $7a, $01, $6a, $8d, $75, $8d
    db $60, $67, $8c, $82, $70, $2e, $01, $01, $01, $01, $01, $98, $8e, $01, $74, $63
    db $6c, $ae, $79, $86, $73, $62, $9c, $65, $88, $01, $62, $71, $65, $63, $79, $6e
    db $62, $6a, $63, $60, $01, $66, $68, $7e, $6c, $2c, $6a, $63, $70, $62, $6c, $70
    db $2e, $00
    assert @ == $740b

section "Campaign Briefing ResultA 42", romx[$740b], bank[$33]
CampaignBriefing_ResultA_42::
    db $1b, $d2, $c0, $db, $dd, $66, $62, $1d, $79, $01, $73, $67, $66, $8d, $70, $62
    db $91, $67, $82, $72, $76, $01, $6e, $62, $6a, $63, $6c, $2c, $01, $94, $ae, $63
    db $88, $68, $86, $63, $79, $67, $ae, $73, $8d, $60, $01, $66, $68, $7e, $6c, $70
    db $2e, $01, $01, $01, $01, $62, $86, $62, $86, $01, $73, $67, $7e, $8d, $67, $ae
    db $71, $7d, $79, $01, $7e, $8d, $66, $68, $73, $67, $94, $ae, $63, $88, $68, $9b
    db $61, $89, $2e, $00
    assert @ == $745f

section "Campaign Briefing ResultA 43", romx[$745f], bank[$33]
CampaignBriefing_ResultA_43::
    db $00
    assert @ == $7460

section "Campaign Briefing ResultA 44", romx[$7460], bank[$33]
CampaignBriefing_ResultA_44::
    db $00
    assert @ == $7461
