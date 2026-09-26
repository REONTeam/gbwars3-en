include "macros/macros.inc"

; Campaign briefing relocation directory.
;
; Each entry is a Bank $34 address. All Campaign entries are populated. The
; reader still accepts zero as a Bank $33 fallback for compatibility, but the
; current directory redirects every pre-map/result stream to Bank $34.
;
; The directory is fixed at the end of Bank $34 so translated messages can grow
; upward from $4000 without moving the directory itself. Its 136 entries mirror
; the three Bank $25 Campaign pointer families exactly: 45 Result B, 46 Pre-map,
; and 45 Result A entries (272 bytes total).
;
; Every Campaign entry now resolves to Bank $34. Existing English opening-map
; replacements are retained; all other entries use plaintext Japanese sources that emit byte-identically.

section "Campaign Briefing Result B Relocation Table", romx[$7ef0], bank[$34]
CampaignBriefing_ResultBRelocationTable::
    dw CampaignBriefing_ResultB_00_Bank34 ; 00
    dw CampaignBriefing_ResultB_01_Bank34 ; 01
    dw CampaignBriefing_ResultB_02_English ; 02
    dw CampaignBriefing_ResultB_03_Bank34 ; 03
    dw CampaignBriefing_ResultB_04_Bank34 ; 04
    dw CampaignBriefing_ResultB_05_Bank34 ; 05
    dw CampaignBriefing_ResultB_06_Bank34 ; 06
    dw CampaignBriefing_ResultB_07_Bank34 ; 07
    dw CampaignBriefing_ResultB_08_Bank34 ; 08
    dw CampaignBriefing_ResultB_09_Bank34 ; 09
    dw CampaignBriefing_ResultB_10_Bank34 ; 10
    dw CampaignBriefing_ResultB_11_Bank34 ; 11
    dw CampaignBriefing_ResultB_12_Bank34 ; 12
    dw CampaignBriefing_ResultB_13_Bank34 ; 13
    dw CampaignBriefing_ResultB_14_Bank34 ; 14
    dw CampaignBriefing_ResultB_15_Bank34 ; 15
    dw CampaignBriefing_ResultB_16_Bank34 ; 16
    dw CampaignBriefing_ResultB_17_Bank34 ; 17
    dw CampaignBriefing_ResultB_18_Bank34 ; 18
    dw CampaignBriefing_ResultB_19_Bank34 ; 19
    dw CampaignBriefing_ResultB_20_Bank34 ; 20
    dw CampaignBriefing_ResultB_21_Bank34 ; 21
    dw CampaignBriefing_ResultB_22_Bank34 ; 22
    dw CampaignBriefing_ResultB_23_Bank34 ; 23
    dw CampaignBriefing_ResultB_24_Bank34 ; 24
    dw CampaignBriefing_ResultB_25_Bank34 ; 25
    dw CampaignBriefing_ResultB_26_Bank34 ; 26
    dw CampaignBriefing_ResultB_27_Bank34 ; 27
    dw CampaignBriefing_ResultB_28_Bank34 ; 28
    dw CampaignBriefing_ResultB_29_Bank34 ; 29
    dw CampaignBriefing_ResultB_30_Bank34 ; 30
    dw CampaignBriefing_ResultB_31_Bank34 ; 31
    dw CampaignBriefing_ResultB_32_Bank34 ; 32
    dw CampaignBriefing_ResultB_33_Bank34 ; 33
    dw CampaignBriefing_ResultB_34_Bank34 ; 34
    dw CampaignBriefing_ResultB_35_Bank34 ; 35
    dw CampaignBriefing_ResultB_36_Bank34 ; 36
    dw CampaignBriefing_ResultB_37_Bank34 ; 37
    dw CampaignBriefing_ResultB_38_Bank34 ; 38
    dw CampaignBriefing_ResultB_39_Bank34 ; 39
    dw CampaignBriefing_ResultB_40_Bank34 ; 40
    dw CampaignBriefing_ResultB_41_Bank34 ; 41
    dw CampaignBriefing_ResultB_42_Bank34 ; 42
    dw CampaignBriefing_ResultB_43_Bank34 ; 43
    dw CampaignBriefing_ResultB_44_Bank34 ; 44
    assert @ == $7f4a

section "Campaign Briefing Pre-Map Relocation Table", romx[$7f4a], bank[$34]
CampaignBriefing_PreMapRelocationTable::
    dw CampaignIntroductionBank34Payload ; 00
    dw CampaignBriefing_PreMap_01_English ; 01
    dw CampaignBriefing_PreMap_02_English ; 02
    dw CampaignBriefing_PreMap_03_Bank34 ; 03
    dw CampaignBriefing_PreMap_04_Bank34 ; 04
    dw CampaignBriefing_PreMap_05_Bank34 ; 05
    dw CampaignBriefing_PreMap_06_Bank34 ; 06
    dw CampaignBriefing_PreMap_07_Bank34 ; 07
    dw CampaignBriefing_PreMap_08_Bank34 ; 08
    dw CampaignBriefing_PreMap_09_Bank34 ; 09
    dw CampaignBriefing_PreMap_10_Bank34 ; 10
    dw CampaignBriefing_PreMap_11_Bank34 ; 11
    dw CampaignBriefing_PreMap_12_Bank34 ; 12
    dw CampaignBriefing_PreMap_13_Bank34 ; 13
    dw CampaignBriefing_PreMap_14_Bank34 ; 14
    dw CampaignBriefing_PreMap_15_Bank34 ; 15
    dw CampaignBriefing_PreMap_16_Bank34 ; 16
    dw CampaignBriefing_PreMap_17_Bank34 ; 17
    dw CampaignBriefing_PreMap_18_Bank34 ; 18
    dw CampaignBriefing_PreMap_19_Bank34 ; 19
    dw CampaignBriefing_PreMap_20_Bank34 ; 20
    dw CampaignBriefing_PreMap_21_Bank34 ; 21
    dw CampaignBriefing_PreMap_22_Bank34 ; 22
    dw CampaignBriefing_PreMap_23_Bank34 ; 23
    dw CampaignBriefing_PreMap_24_Bank34 ; 24
    dw CampaignBriefing_PreMap_25_Bank34 ; 25
    dw CampaignBriefing_PreMap_26_Bank34 ; 26
    dw CampaignBriefing_PreMap_27_Bank34 ; 27
    dw CampaignBriefing_PreMap_28_Bank34 ; 28
    dw CampaignBriefing_PreMap_29_Bank34 ; 29
    dw CampaignBriefing_PreMap_30_Bank34 ; 30
    dw CampaignBriefing_PreMap_31_Bank34 ; 31
    dw CampaignBriefing_PreMap_32_Bank34 ; 32
    dw CampaignBriefing_PreMap_33_Bank34 ; 33
    dw CampaignBriefing_PreMap_34_Bank34 ; 34
    dw CampaignBriefing_PreMap_35_Bank34 ; 35
    dw CampaignBriefing_PreMap_36_Bank34 ; 36
    dw CampaignBriefing_PreMap_37_Bank34 ; 37
    dw CampaignBriefing_PreMap_38_Bank34 ; 38
    dw CampaignBriefing_PreMap_39_Bank34 ; 39
    dw CampaignBriefing_PreMap_40_Bank34 ; 40
    dw CampaignBriefing_PreMap_41_Bank34 ; 41
    dw CampaignBriefing_PreMap_42_Bank34 ; 42
    dw CampaignBriefing_PreMap_43_Bank34 ; 43
    dw CampaignBriefing_PreMap_44_Bank34 ; 44
    dw CampaignBriefing_PreMap_Extra45_Bank34 ; Extra45
    assert @ == $7fa6

section "Campaign Briefing Result A Relocation Table", romx[$7fa6], bank[$34]
CampaignBriefing_ResultARelocationTable::
    dw CampaignBriefing_ResultA_00_English ; 00
    dw CampaignBriefing_ResultA_01_English ; 01
    dw CampaignBriefing_ResultA_02_English ; 02
    dw CampaignBriefing_ResultA_03_Bank34 ; 03
    dw CampaignBriefing_ResultA_04_Bank34 ; 04
    dw CampaignBriefing_ResultA_05_Bank34 ; 05
    dw CampaignBriefing_ResultA_06_Bank34 ; 06
    dw CampaignBriefing_ResultA_07_Bank34 ; 07
    dw CampaignBriefing_ResultA_08_Bank34 ; 08
    dw CampaignBriefing_ResultA_09_Bank34 ; 09
    dw CampaignBriefing_ResultA_10_Bank34 ; 10
    dw CampaignBriefing_ResultA_11_Bank34 ; 11
    dw CampaignBriefing_ResultA_12_Bank34 ; 12
    dw CampaignBriefing_ResultA_13_Bank34 ; 13
    dw CampaignBriefing_ResultA_14_Bank34 ; 14
    dw CampaignBriefing_ResultA_15_Bank34 ; 15
    dw CampaignBriefing_ResultA_16_Bank34 ; 16
    dw CampaignBriefing_ResultA_17_Bank34 ; 17
    dw CampaignBriefing_ResultA_18_Bank34 ; 18
    dw CampaignBriefing_ResultA_19_Bank34 ; 19
    dw CampaignBriefing_ResultA_20_Bank34 ; 20
    dw CampaignBriefing_ResultA_21_Bank34 ; 21
    dw CampaignBriefing_ResultA_22_Bank34 ; 22
    dw CampaignBriefing_ResultA_23_Bank34 ; 23
    dw CampaignBriefing_ResultA_24_Bank34 ; 24
    dw CampaignBriefing_ResultA_25_Bank34 ; 25
    dw CampaignBriefing_ResultA_26_Bank34 ; 26
    dw CampaignBriefing_ResultA_27_Bank34 ; 27
    dw CampaignBriefing_ResultA_28_Bank34 ; 28
    dw CampaignBriefing_ResultA_29_Bank34 ; 29
    dw CampaignBriefing_ResultA_30_Bank34 ; 30
    dw CampaignBriefing_ResultA_31_Bank34 ; 31
    dw CampaignBriefing_ResultA_32_Bank34 ; 32
    dw CampaignBriefing_ResultA_33_Bank34 ; 33
    dw CampaignBriefing_ResultA_34_Bank34 ; 34
    dw CampaignBriefing_ResultA_35_Bank34 ; 35
    dw CampaignBriefing_ResultA_36_Bank34 ; 36
    dw CampaignBriefing_ResultA_37_Bank34 ; 37
    dw CampaignBriefing_ResultA_38_Bank34 ; 38
    dw CampaignBriefing_ResultA_39_Bank34 ; 39
    dw CampaignBriefing_ResultA_40_Bank34 ; 40
    dw CampaignBriefing_ResultA_41_Bank34 ; 41
    dw CampaignBriefing_ResultA_42_Bank34 ; 42
    dw CampaignBriefing_ResultA_43_Bank34 ; 43
    dw CampaignBriefing_ResultA_44_Bank34 ; 44
CampaignBriefing_RelocationDirectoryEnd::
    assert @ == $8000
