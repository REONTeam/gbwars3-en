include "macros/macros.inc"

; Complete Campaign briefing pointer tables used by the Bank $25 viewer.
; promotes the previously non-emitting anchors into exact symbolic
; `dw` source. Entries address text streams in Bank $33. The PreMap family
; contains 46 entries: 45 map-indexed messages plus one extra entry at $6715
; whose higher-level purpose remains intentionally unnamed until a caller proves it.

section "Campaign Briefing Result B Pointer Table", romx[$4000], bank[$25]
CampaignBriefing_ResultBPointerTable::
    dw CampaignBriefing_ResultB_00
    dw CampaignBriefing_ResultB_01
    dw CampaignBriefing_ResultB_02
    dw CampaignBriefing_ResultB_03
    dw CampaignBriefing_ResultB_04
    dw CampaignBriefing_ResultB_05
    dw CampaignBriefing_ResultB_06
    dw CampaignBriefing_ResultB_07
    dw CampaignBriefing_ResultB_08
    dw CampaignBriefing_ResultB_09
    dw CampaignBriefing_ResultB_10
    dw CampaignBriefing_ResultB_11
    dw CampaignBriefing_ResultB_12
    dw CampaignBriefing_ResultB_13
    dw CampaignBriefing_ResultB_14
    dw CampaignBriefing_ResultB_15
    dw CampaignBriefing_ResultB_16
    dw CampaignBriefing_ResultB_17
    dw CampaignBriefing_ResultB_18
    dw CampaignBriefing_ResultB_19
    dw CampaignBriefing_ResultB_20
    dw CampaignBriefing_ResultB_21
    dw CampaignBriefing_ResultB_22
    dw CampaignBriefing_ResultB_23
    dw CampaignBriefing_ResultB_24
    dw CampaignBriefing_ResultB_25
    dw CampaignBriefing_ResultB_26
    dw CampaignBriefing_ResultB_27
    dw CampaignBriefing_ResultB_28
    dw CampaignBriefing_ResultB_29
    dw CampaignBriefing_ResultB_30
    dw CampaignBriefing_ResultB_31
    dw CampaignBriefing_ResultB_32
    dw CampaignBriefing_ResultB_33
    dw CampaignBriefing_ResultB_34
    dw CampaignBriefing_ResultB_35
    dw CampaignBriefing_ResultB_36
    dw CampaignBriefing_ResultB_37
    dw CampaignBriefing_ResultB_38
    dw CampaignBriefing_ResultB_39
    dw CampaignBriefing_ResultB_40
    dw CampaignBriefing_ResultB_41
    dw CampaignBriefing_ResultB_42
    dw CampaignBriefing_ResultB_43
    dw CampaignBriefing_ResultB_44
    assert @ == $405a

section "Campaign Briefing Pre-Map Pointer Table", romx[$405a], bank[$25]
CampaignBriefing_PreMapPointerTable::
    dw CampaignBriefing_PreMap_00
    dw CampaignBriefing_PreMap_01
    dw CampaignBriefing_PreMap_02
    dw CampaignBriefing_PreMap_03
    dw CampaignBriefing_PreMap_04
    dw CampaignBriefing_PreMap_05
    dw CampaignBriefing_PreMap_06
    dw CampaignBriefing_PreMap_07
    dw CampaignBriefing_PreMap_08
    dw CampaignBriefing_PreMap_09
    dw CampaignBriefing_PreMap_10
    dw CampaignBriefing_PreMap_11
    dw CampaignBriefing_PreMap_12
    dw CampaignBriefing_PreMap_13
    dw CampaignBriefing_PreMap_14
    dw CampaignBriefing_PreMap_15
    dw CampaignBriefing_PreMap_16
    dw CampaignBriefing_PreMap_17
    dw CampaignBriefing_PreMap_18
    dw CampaignBriefing_PreMap_19
    dw CampaignBriefing_PreMap_20
    dw CampaignBriefing_PreMap_21
    dw CampaignBriefing_PreMap_22
    dw CampaignBriefing_PreMap_23
    dw CampaignBriefing_PreMap_24
    dw CampaignBriefing_PreMap_25
    dw CampaignBriefing_PreMap_26
    dw CampaignBriefing_PreMap_27
    dw CampaignBriefing_PreMap_28
    dw CampaignBriefing_PreMap_29
    dw CampaignBriefing_PreMap_30
    dw CampaignBriefing_PreMap_31
    dw CampaignBriefing_PreMap_32
    dw CampaignBriefing_PreMap_33
    dw CampaignBriefing_PreMap_34
    dw CampaignBriefing_PreMap_35
    dw CampaignBriefing_PreMap_36
    dw CampaignBriefing_PreMap_37
    dw CampaignBriefing_PreMap_38
    dw CampaignBriefing_PreMap_39
    dw CampaignBriefing_PreMap_40
    dw CampaignBriefing_PreMap_41
    dw CampaignBriefing_PreMap_42
    dw CampaignBriefing_PreMap_43
    dw CampaignBriefing_PreMap_44
    dw CampaignBriefing_PreMap_Extra45
    assert @ == $40b6

section "Campaign Briefing Result A Pointer Table", romx[$40b6], bank[$25]
CampaignBriefing_ResultAPointerTable::
    dw CampaignBriefing_ResultA_00
    dw CampaignBriefing_ResultA_01
    dw CampaignBriefing_ResultA_02
    dw CampaignBriefing_ResultA_03
    dw CampaignBriefing_ResultA_04
    dw CampaignBriefing_ResultA_05
    dw CampaignBriefing_ResultA_06
    dw CampaignBriefing_ResultA_07
    dw CampaignBriefing_ResultA_08
    dw CampaignBriefing_ResultA_09
    dw CampaignBriefing_ResultA_10
    dw CampaignBriefing_ResultA_11
    dw CampaignBriefing_ResultA_12
    dw CampaignBriefing_ResultA_13
    dw CampaignBriefing_ResultA_14
    dw CampaignBriefing_ResultA_15
    dw CampaignBriefing_ResultA_16
    dw CampaignBriefing_ResultA_17
    dw CampaignBriefing_ResultA_18
    dw CampaignBriefing_ResultA_19
    dw CampaignBriefing_ResultA_20
    dw CampaignBriefing_ResultA_21
    dw CampaignBriefing_ResultA_22
    dw CampaignBriefing_ResultA_23
    dw CampaignBriefing_ResultA_24
    dw CampaignBriefing_ResultA_25
    dw CampaignBriefing_ResultA_26
    dw CampaignBriefing_ResultA_27
    dw CampaignBriefing_ResultA_28
    dw CampaignBriefing_ResultA_29
    dw CampaignBriefing_ResultA_30
    dw CampaignBriefing_ResultA_31
    dw CampaignBriefing_ResultA_32
    dw CampaignBriefing_ResultA_33
    dw CampaignBriefing_ResultA_34
    dw CampaignBriefing_ResultA_35
    dw CampaignBriefing_ResultA_36
    dw CampaignBriefing_ResultA_37
    dw CampaignBriefing_ResultA_38
    dw CampaignBriefing_ResultA_39
    dw CampaignBriefing_ResultA_40
    dw CampaignBriefing_ResultA_41
    dw CampaignBriefing_ResultA_42
    dw CampaignBriefing_ResultA_43
    dw CampaignBriefing_ResultA_44
    assert @ == $4110
