include "include/macros.inc"
include "include/char_main.inc"

setcharmap main
section "Rank_Strings", romx[$6159], bank[$15]
Rank_Strings:
    dw .cadet
    dw .warrantOfficer
    dw .secondLieutenant
    dw .firstLieutenant
    dw .captain
    dw .major
    dw .lieutenantColonel
    dw .colonel
    dw .brigadierGeneral
    dw .majorGeneral
    dw .lieutenantGeneral
    dw .general
    dw .armyGeneral

.cadet
    text "こうほせいに"
    done

.warrantOfficer
    text "じゅんいに"
    done

.secondLieutenant
    text "しょういに"
    done

.firstLieutenant
    text "ちゅういに"
    done

.captain
    text "たいいに"
    done

.major
    text "しょうさに"
    done

.lieutenantColonel
    text "ちゅうさに"
    done

.colonel
    text "たいさに"
    done

.brigadierGeneral
    text "じゅんしょうに"
    done

.majorGeneral
    text "しょうしょうに"
    done

.lieutenantGeneral
    text "ちゅうじょうに"
    done

.general
    text "たいしょうに"
    done

.armyGeneral
    text "げんすいに"
    done

section "Rank_Award_String", romx[$6295], bank[$15]
    text "このせんせんでのせいかにより"
    line "きでんを"
    line "しょうしんする。"
    skip 1
    line "こんごのかつやくに"
    line "きたいする。"
    
section "Rank_Save_Prompt", romx[$662e], bank[$15]
    text "セーブしますか?"
    done
