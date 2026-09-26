include "macros/macros.inc"

; Bank $0F Map Editor main-menu handler family. The eight public entries are
; selected by MapEditor_MenuHandlerPointers in the interaction controller.
; The executable spans are intentionally split around the existing player-facing
; editor message resources, which keep their independent source ownership.

DEF wMapEditorMenuSelectionIndex EQU $c940
DEF wMapEditorSubmenuValue0      EQU $c941
DEF wMapEditorSubmenuValue1      EQU $c942
DEF wMapEditorSubmenuMax         EQU $c943
DEF wMapEditorSubmenuMin         EQU $c944
DEF wMapEditorSubmenuId          EQU $c945
DEF wMapEditorArrangeMode        EQU $ca52
DEF wMapEditorFillAnchorX        EQU $ca53
DEF wMapEditorFillAnchorY        EQU $ca54
DEF wMapEditorFillAnchorActive   EQU $ca55
DEF wMapEditorFillPreviewCounter EQU $ca56
DEF wMapEditorArrangeSelectionClass EQU $ca57
DEF wMapEditorSelectedTerrainId   EQU $ca65
DEF wMapEditorRecordIndex        EQU $ca4f
DEF wMapInteractionInputState    EQU $ca91

section "Map Editor Arrange Handler", romx[$460f], bank[$0f]
MapEditor_HandleArrangeMenu::
    ld a, $00                          ; $460F  3e 00
    ld [wMapEditorSubmenuId], a                      ; $4611  ea 45 c9
    ld a, [wMapEditorArrangeMode]                      ; $4614  fa 52 ca
    ld [wMapEditorMenuSelectionIndex], a                      ; $4617  ea 40 c9
    call EditorSubmenu                         ; $461A  cd 3a 4c
    ld d, $55                          ; $461D  16 55
    call MapEditor_InitializeSubmenuSelection                         ; $461F  cd e2 4d
    ld a, $68                          ; $4622  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $4624  ef 0b 22 48
.loc_4628:
    call Joypad_Update                         ; $4628  cd a2 05
    ldh a, [hJoyRepeat]                       ; $462B  f0 92
    bit 0, a                           ; $462D  cb 47
    jr nz, .loc_4649                   ; $462F  20 18
    bit 1, a                           ; $4631  cb 4f
    jr nz, .loc_4656                   ; $4633  20 21
    bit 6, a                           ; $4635  cb 77
    jr nz, .loc_463f                   ; $4637  20 06
    bit 7, a                           ; $4639  cb 7f
    jr nz, .loc_463f                   ; $463B  20 02
    jr .loc_4628                       ; $463D  18 e9
.loc_463f:
    ld a, [wMapEditorMenuSelectionIndex]                      ; $463F  fa 40 c9
    xor $01                            ; $4642  ee 01
    call MapEditor_UpdateSubmenuSelection                         ; $4644  cd cf 4d
    jr .loc_4628                       ; $4647  18 df
.loc_4649:
    ld a, $02                          ; $4649  3e 02
    call Audio_PlaySFX                         ; $464B  cd 44 38
    ld a, [wMapEditorMenuSelectionIndex]                      ; $464E  fa 40 c9
    ld [wMapEditorArrangeMode], a                      ; $4651  ea 52 ca
    jr .loc_465b                       ; $4654  18 05
.loc_4656:
    ld a, SFX_CANCEL                          ; $4656  3e 0c
    call Audio_PlaySFX                         ; $4658  cd 44 38
.loc_465b:
    farcall LCDScanlineTransition_Reset                 ; $465B  ef 0b 60 48
    xor a                              ; $465F  af
    ret                                ; $4660  c9

    assert @ == $4661

section "Map Editor Size Handler", romx[$4661], bank[$0f]
MapEditor_HandleMapSizeMenu::
    ld a, [wMapGridWidth]                      ; $4661  fa 89 c9
    ld [wMapEditorSubmenuValue0], a                      ; $4664  ea 41 c9
    ld a, [wMapGridHeight]                      ; $4667  fa 8a c9
    ld [wMapEditorSubmenuValue1], a                      ; $466A  ea 42 c9
    ld a, $14                          ; $466D  3e 14
    ld [wMapEditorSubmenuMin], a                      ; $466F  ea 44 c9
    ld a, $32                          ; $4672  3e 32
    ld [wMapEditorSubmenuMax], a                      ; $4674  ea 43 c9
.loc_4677:
    xor a                              ; $4677  af
    ld [wMapEditorMenuSelectionIndex], a                      ; $4678  ea 40 c9
    ld a, $01                          ; $467B  3e 01
    ld [wMapEditorSubmenuId], a                      ; $467D  ea 45 c9
    call EditorSubmenu                         ; $4680  cd 3a 4c
    ld d, $55                          ; $4683  16 55
    call MapEditor_InitializeSubmenuSelection                         ; $4685  cd e2 4d
    ld a, $68                          ; $4688  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $468A  ef 0b 22 48
    call MapEditor_RunTwoValueSubmenuInput                         ; $468E  cd b4 4b
    cp $ff                             ; $4691  fe ff
    jr z, .loc_46f9                    ; $4693  28 64
    call MapEditor_RunYesNoConfirmation                         ; $4695  cd 79 48
    cp $ff                             ; $4698  fe ff
    jr z, .loc_4677                    ; $469A  28 db
    ld a, [wMapGridWidth]                      ; $469C  fa 89 c9
    ld b, a                            ; $469F  47
    ld c, $00                          ; $46A0  0e 00
    ld d, $32                          ; $46A2  16 32
    ld e, $32                          ; $46A4  1e 32
    ld a, $29                          ; $46A6  3e 29
    call MapEditor_FillRectangle                         ; $46A8  cd da 52
    ld a, [wMapGridHeight]                      ; $46AB  fa 8a c9
    ld c, a                            ; $46AE  4f
    ld b, $00                          ; $46AF  06 00
    ld d, $32                          ; $46B1  16 32
    ld e, $32                          ; $46B3  1e 32
    ld a, $29                          ; $46B5  3e 29
    call MapEditor_FillRectangle                         ; $46B7  cd da 52
    ld a, [wMapEditorSubmenuValue0]                      ; $46BA  fa 41 c9
    ld [wMapGridWidth], a                      ; $46BD  ea 89 c9
    ld a, [wMapEditorSubmenuValue1]                      ; $46C0  fa 42 c9
    ld [wMapGridHeight], a                      ; $46C3  ea 8a c9
    ld a, [wMapGridWidth]                      ; $46C6  fa 89 c9
    ld b, a                            ; $46C9  47
    ld c, $00                          ; $46CA  0e 00
    ld d, $3f                          ; $46CC  16 3f
    ld e, $36                          ; $46CE  1e 36
    xor a                              ; $46D0  af
    call MapEditor_FillRectangle                         ; $46D1  cd da 52
    ld a, [wMapGridHeight]                      ; $46D4  fa 8a c9
    ld c, a                            ; $46D7  4f
    ld b, $00                          ; $46D8  06 00
    ld d, $3f                          ; $46DA  16 3f
    ld e, $36                          ; $46DC  1e 36
    xor a                              ; $46DE  af
    call MapEditor_FillRectangle                         ; $46DF  cd da 52
    xor a                              ; $46E2  af
    ld [$c98b], a                      ; $46E3  ea 8b c9
    ld [$c98c], a                      ; $46E6  ea 8c c9
    ld a, $04                          ; $46E9  3e 04
    ld [$c98f], a                      ; $46EB  ea 8f c9
    ld [$c990], a                      ; $46EE  ea 90 c9
    farcall Bank0B_MapSetup_428A                 ; $46F1  ef 0b 8a 42
    farcall MapGrid_RebuildTileCountsAndHQCoordinates                 ; $46F5  ef 0b 78 41
.loc_46f9:
    farcall LCDScanlineTransition_Reset                 ; $46F9  ef 0b 60 48
    xor a                              ; $46FD  af
    ret                                ; $46FE  c9

    assert @ == $46ff

section "Map Editor Funds Handler", romx[$46ff], bank[$0f]
MapEditor_HandleFundsMenu::
    ld a, $02                          ; $46FF  3e 02
    ld [wMapEditorSubmenuId], a                      ; $4701  ea 45 c9
    ld a, [$c8ad]                      ; $4704  fa ad c8
    ld [wMapEditorSubmenuValue0], a                      ; $4707  ea 41 c9
    ld a, [$c8ae]                      ; $470A  fa ae c8
    ld [wMapEditorSubmenuValue1], a                      ; $470D  ea 42 c9
    xor a                              ; $4710  af
    ld [wMapEditorSubmenuMin], a                      ; $4711  ea 44 c9
    ld a, $63                          ; $4714  3e 63
    ld [wMapEditorSubmenuMax], a                      ; $4716  ea 43 c9
    xor a                              ; $4719  af
    ld [wMapEditorMenuSelectionIndex], a                      ; $471A  ea 40 c9
    call EditorSubmenu                         ; $471D  cd 3a 4c
    ld d, $55                          ; $4720  16 55
    call MapEditor_InitializeSubmenuSelection                         ; $4722  cd e2 4d
    ld a, $68                          ; $4725  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $4727  ef 0b 22 48
    call MapEditor_RunTwoValueSubmenuInput                         ; $472B  cd b4 4b
    cp $ff                             ; $472E  fe ff
    jr z, .loc_473e                    ; $4730  28 0c
    ld a, [wMapEditorSubmenuValue0]                      ; $4732  fa 41 c9
    ld [$c8ad], a                      ; $4735  ea ad c8
    ld a, [wMapEditorSubmenuValue1]                      ; $4738  fa 42 c9
    ld [$c8ae], a                      ; $473B  ea ae c8
.loc_473e:
    farcall LCDScanlineTransition_Reset                 ; $473E  ef 0b 60 48
    xor a                              ; $4742  af
    ret                                ; $4743  c9

    assert @ == $4744

section "Map Editor Materials Handler", romx[$4744], bank[$0f]
MapEditor_HandleMaterialsMenu::
    ld a, $03                          ; $4744  3e 03
    ld [wMapEditorSubmenuId], a                      ; $4746  ea 45 c9
    ld a, [$c8af]                      ; $4749  fa af c8
    ld [wMapEditorSubmenuValue0], a                      ; $474C  ea 41 c9
    ld a, [$c8b0]                      ; $474F  fa b0 c8
    ld [wMapEditorSubmenuValue1], a                      ; $4752  ea 42 c9
    xor a                              ; $4755  af
    ld [wMapEditorSubmenuMin], a                      ; $4756  ea 44 c9
    ld a, $63                          ; $4759  3e 63
    ld [wMapEditorSubmenuMax], a                      ; $475B  ea 43 c9
    xor a                              ; $475E  af
    ld [wMapEditorMenuSelectionIndex], a                      ; $475F  ea 40 c9
    call EditorSubmenu                         ; $4762  cd 3a 4c
    ld d, $55                          ; $4765  16 55
    call MapEditor_InitializeSubmenuSelection                         ; $4767  cd e2 4d
    ld a, $68                          ; $476A  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $476C  ef 0b 22 48
    call MapEditor_RunTwoValueSubmenuInput                         ; $4770  cd b4 4b
    cp $ff                             ; $4773  fe ff
    jr z, .loc_4783                    ; $4775  28 0c
    ld a, [wMapEditorSubmenuValue0]                      ; $4777  fa 41 c9
    ld [$c8af], a                      ; $477A  ea af c8
    ld a, [wMapEditorSubmenuValue1]                      ; $477D  fa 42 c9
    ld [$c8b0], a                      ; $4780  ea b0 c8
.loc_4783:
    farcall LCDScanlineTransition_Reset                 ; $4783  ef 0b 60 48
    xor a                              ; $4787  af
    ret                                ; $4788  c9

    assert @ == $4789

; MapEditor_EditName at $4789 now jumps to the 9-character implementation at
; $5400. These retail instructions are therefore preserved but unreachable from
; the active custom-English editor path.
section "Map Editor Retail Name Body Unused", romx[$478c], bank[$0f]
MapEditor_EditNameRetailBody_Unused::
    call $07b4                         ; $478C  cd b4 07
    ld de, wEditorMapName                       ; $478F  11 a5 c8
    ld bc, $0008                       ; $4792  01 08 00
    ld hl, wTextInputBuffer                       ; $4795  21 2f cc
    call Memcpy                         ; $4798  cd 50 3b
    ld a, $00                          ; $479B  3e 00
    ld [hli], a                        ; $479D  22
    ld a, $02                          ; $479E  3e 02
    farcall $14, TextInput_Run                 ; $47A0  ef 14 4c 4e
    ld de, wTextInputBuffer                       ; $47A4  11 2f cc
    ld hl, wEditorMapName                       ; $47A7  21 a5 c8
    ld bc, $0008                       ; $47AA  01 08 00
    call Memcpy                         ; $47AD  cd 50 3b
    ld a, $fe                          ; $47B0  3e fe
    ret                                ; $47B2  c9

    assert @ == $47b3

section "Map Editor Save Handler", romx[$47b3], bank[$0f]
MapEditor_HandleSaveMenu::
    call MapEditor_RunYesNoConfirmation                         ; $47B3  cd 79 48
    push af                            ; $47B6  f5
    farcall LCDScanlineTransition_Reset                 ; $47B7  ef 0b 60 48
    pop af                             ; $47BB  f1
    cp $ff                             ; $47BC  fe ff
    jr z, .loc_47c3                    ; $47BE  28 03
    call MapEditor_CommitSaveIfHQCountsValid                     ; $47C0  cd c5 47
.loc_47c3:
    xor a                              ; $47C3  af
    ret                                ; $47C4  c9
MapEditor_CommitSaveIfHQCountsValid::
    ld a, [wMapSide0HQTileCount]                      ; $47C5  fa 4b c6
    cp $01                             ; $47C8  fe 01
    jr nz, .loc_47e8                   ; $47CA  20 1c
    ld a, [wMapSide1HQTileCount]                      ; $47CC  fa 56 c6
    cp $01                             ; $47CF  fe 01
    jr nz, .loc_47e8                   ; $47D1  20 15
    ld a, [wMapGridWidth]                      ; $47D3  fa 89 c9
    ld [$c8b1], a                      ; $47D6  ea b1 c8
    ld a, [wMapGridHeight]                      ; $47D9  fa 8a c9
    ld [$c8b2], a                      ; $47DC  ea b2 c8
    ld a, [wMapEditorRecordIndex]                      ; $47DF  fa 4f ca
    farcall $13, MapEditor_SaveCurrentMapToSRAM                 ; $47E2  ef 13 fe 5c
    xor a                              ; $47E6  af
    ret                                ; $47E7  c9
.loc_47e8:
    call .loc_47ee                     ; $47E8  cd ee 47
    ld a, $ff                          ; $47EB  3e ff
    ret                                ; $47ED  c9
.loc_47ee:
    ld a, SFX_ERROR                          ; $47EE  3e 03
    call Audio_PlaySFX                         ; $47F0  cd 44 38
    farcall MapCursor_Hide                 ; $47F3  ef 0b 00 47
    call Sprite_Update                         ; $47F7  cd 56 30
    call DelayFrame                         ; $47FA  cd d2 04
    ld bc, $0020                       ; $47FD  01 20 00
    ld de, $1405                       ; $4800  11 05 14
    farcall UIWindow_DrawFrame                 ; $4803  ef 10 09 6a
    ld hl, EditorSubmenu_Message_HQ                       ; $4807  21 37 48
    call CoordTextPut                         ; $480A  cd 6e 33
    ld hl, EditorSubmenu_Message_HQ_Line2                       ; $480D  21 49 48
    call CoordTextPut                         ; $4810  cd 6e 33
    ld hl, EditorSubmenu_Message_HQ_Line3                       ; $4813  21 55 48
    call CoordTextPut                         ; $4816  cd 6e 33
    ld a, $68                          ; $4819  3e 68
    farcall LCDScanlineTransition_RunToTarget             ; $481B  ef 0b 22 48
.loc_481f:
    call Joypad_Update                         ; $481F  cd a2 05
.loc_4822:
    ldh a, [hJoyPressed]                       ; $4822  f0 91
    bit 0, a                           ; $4824  cb 47
    jr nz, .loc_482e                   ; $4826  20 06
    bit 1, a                           ; $4828  cb 4f
    jr nz, .loc_482e                   ; $482A  20 02
    jr .loc_481f                       ; $482C  18 f1
.loc_482e:
    farcall LCDScanlineTransition_Reset                 ; $482E  ef 0b 60 48
    farcall MapCursor_Show                 ; $4832  ef 0b f9 46
    ret                                ; $4836  c9

    assert @ == $4837

section "Map Editor End Handler", romx[$4866], bank[$0f]
MapEditor_HandleEndMenu::
    call MapEditor_RunEndPrompt                     ; $4866  cd c7 48
    push af                            ; $4869  f5
    farcall LCDScanlineTransition_Reset                 ; $486A  ef 0b 60 48
    pop af                             ; $486E  f1
    cp $ff                             ; $486F  fe ff
    jr nz, .loc_4876                   ; $4871  20 03
    xor a                              ; $4873  af
    jr .loc_4878                       ; $4874  18 02
.loc_4876:
    ld a, $ff                          ; $4876  3e ff
.loc_4878:
    ret                                ; $4878  c9
MapEditor_RunYesNoConfirmation::
    ld a, $08                          ; $4879  3e 08
    ld [wMapEditorSubmenuId], a                      ; $487B  ea 45 c9
    xor a                              ; $487E  af
    ld [wMapEditorMenuSelectionIndex], a                      ; $487F  ea 40 c9
    call EditorSubmenu                         ; $4882  cd 3a 4c
    ld d, $55                          ; $4885  16 55
    call MapEditor_InitializeSubmenuSelection                         ; $4887  cd e2 4d
    ld a, $68                          ; $488A  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $488C  ef 0b 22 48
.loc_4890:
    call Joypad_Update                         ; $4890  cd a2 05
    ldh a, [hJoyRepeat]                       ; $4893  f0 92
    bit 0, a                           ; $4895  cb 47
    jr nz, .loc_48b1                   ; $4897  20 18
    bit 1, a                           ; $4899  cb 4f
    jr nz, .loc_48bc                   ; $489B  20 1f
    bit 6, a                           ; $489D  cb 77
    jr nz, .loc_48a7                   ; $489F  20 06
    bit 7, a                           ; $48A1  cb 7f
    jr nz, .loc_48a7                   ; $48A3  20 02
    jr .loc_4890                       ; $48A5  18 e9
.loc_48a7:
    ld a, [wMapEditorMenuSelectionIndex]                      ; $48A7  fa 40 c9
    xor $01                            ; $48AA  ee 01
    call MapEditor_UpdateSubmenuSelection                         ; $48AC  cd cf 4d
    jr .loc_4890                       ; $48AF  18 df
.loc_48b1:
    ld a, $02                          ; $48B1  3e 02
    call Audio_PlaySFX                         ; $48B3  cd 44 38
    ld a, [wMapEditorMenuSelectionIndex]                      ; $48B6  fa 40 c9
    and a                              ; $48B9  a7
    jr nz, .loc_48c5                   ; $48BA  20 09
.loc_48bc:
    ld a, SFX_CANCEL                          ; $48BC  3e 0c
    call Audio_PlaySFX                         ; $48BE  cd 44 38
    ld a, $ff                          ; $48C1  3e ff
    jr .loc_48c6                       ; $48C3  18 01
.loc_48c5:
    xor a                              ; $48C5  af
.loc_48c6:
    ret                                ; $48C6  c9
MapEditor_RunEndPrompt::
    ld a, $09                          ; $48C7  3e 09
    ld [wMapEditorSubmenuId], a                      ; $48C9  ea 45 c9
    xor a                              ; $48CC  af
    ld [wMapEditorMenuSelectionIndex], a                      ; $48CD  ea 40 c9
    ld bc, $0020                       ; $48D0  01 20 00
    ld de, $1406                       ; $48D3  11 06 14
    farcall UIWindow_DrawFrame                 ; $48D6  ef 10 09 6a
    ld hl, EditorSubmenu_Save                       ; $48DA  21 54 49
    call CoordTextPut                         ; $48DD  cd 6e 33
    ld hl, EditorSubmenu_Save_Line2                       ; $48E0  21 62 49
    call CoordTextPut                         ; $48E3  cd 6e 33
    ld hl, EditorSubmenu_Save_Line3                       ; $48E6  21 70 49
    call CoordTextPut                         ; $48E9  cd 6e 33
    ld hl, EditorSubmenu_Save_Line4                       ; $48EC  21 80 49
    call CoordTextPut                         ; $48EF  cd 6e 33
    ld d, $55                          ; $48F2  16 55
    call MapEditor_InitializeSubmenuSelection                         ; $48F4  cd e2 4d
    ld a, $60                          ; $48F7  3e 60
    farcall LCDScanlineTransition_RunToTarget                 ; $48F9  ef 0b 22 48
.loc_48fd:
    call Joypad_Update                         ; $48FD  cd a2 05
    ldh a, [hJoyRepeat]                       ; $4900  f0 92
    bit 0, a                           ; $4902  cb 47
    jr nz, .loc_4930                   ; $4904  20 2a
    bit 1, a                           ; $4906  cb 4f
    jr nz, .loc_4949                   ; $4908  20 3f
    bit 6, a                           ; $490A  cb 77
    jr nz, .loc_4914                   ; $490C  20 06
    bit 7, a                           ; $490E  cb 7f
    jr nz, .loc_4922                   ; $4910  20 10
    jr .loc_48fd                       ; $4912  18 e9
.loc_4914:
    ld a, [wMapEditorMenuSelectionIndex]                      ; $4914  fa 40 c9
    and a                              ; $4917  a7
    jr nz, .loc_491c                   ; $4918  20 02
    ld a, $03                          ; $491A  3e 03
.loc_491c:
    dec a                              ; $491C  3d
    call MapEditor_UpdateSubmenuSelection                         ; $491D  cd cf 4d
    jr .loc_48fd                       ; $4920  18 db
.loc_4922:
    ld a, [wMapEditorMenuSelectionIndex]                      ; $4922  fa 40 c9
    inc a                              ; $4925  3c
    cp $03                             ; $4926  fe 03
    jr nz, .loc_492b                   ; $4928  20 01
    xor a                              ; $492A  af
.loc_492b:
    call MapEditor_UpdateSubmenuSelection                         ; $492B  cd cf 4d
    jr .loc_48fd                       ; $492E  18 cd
.loc_4930:
    ld a, $02                          ; $4930  3e 02
    call Audio_PlaySFX                         ; $4932  cd 44 38
    ld a, [wMapEditorMenuSelectionIndex]                      ; $4935  fa 40 c9
    cp $01                             ; $4938  fe 01
    jr z, .loc_4952                    ; $493A  28 16
    cp $02                             ; $493C  fe 02
    jr z, .loc_4949                    ; $493E  28 09
    call MapEditor_CommitSaveIfHQCountsValid                         ; $4940  cd c5 47
    cp $ff                             ; $4943  fe ff
    jr z, .loc_4953                    ; $4945  28 0c
    jr .loc_4952                       ; $4947  18 09
.loc_4949:
    ld a, SFX_CANCEL                          ; $4949  3e 0c
    call Audio_PlaySFX                         ; $494B  cd 44 38
    ld a, $ff                          ; $494E  3e ff
    jr .loc_4953                       ; $4950  18 01
.loc_4952:
    xor a                              ; $4952  af
.loc_4953:
    ret                                ; $4953  c9

    assert @ == $4954

section "Map Editor Fill Handler", romx[$4986], bank[$0f]
MapEditor_HandleFillMenu::
    ld a, $02                          ; $4986  3e 02
    call Audio_PlaySFX                         ; $4988  cd 44 38
    ld a, [wMapEditorArrangeMode]                      ; $498B  fa 52 ca
    and a                              ; $498E  a7
    jr nz, .loc_499e                   ; $498F  20 0d
    ld a, [wMapEditorArrangeSelectionClass]                      ; $4991  fa 57 ca
    cp $03                             ; $4994  fe 03
    jp c, .loc_499e                    ; $4996  da 9e 49
    call MapEditor_RunFillRectangleSelection                         ; $4999  cd 07 4a
    jr .loc_49ec                       ; $499C  18 4e
.loc_499e:
    ld a, SFX_ERROR                          ; $499E  3e 03
    call Audio_PlaySFX                         ; $49A0  cd 44 38
    farcall MapCursor_Hide                 ; $49A3  ef 0b 00 47
    call Sprite_Update                         ; $49A7  cd 56 30
    call DelayFrame                         ; $49AA  cd d2 04
    farcall SharedGraphics_LoadMenuFontTiles                 ; $49AD  ef 01 fc 40
    ld bc, $0020                       ; $49B1  01 20 00
    ld de, $1405                       ; $49B4  11 05 14
    farcall UIWindow_DrawFrame                 ; $49B7  ef 10 09 6a
    ld hl, EditorSubmenu_Message_Limit                       ; $49BB  21 ed 49
    call CoordTextPut                         ; $49BE  cd 6e 33
    ld hl, EditorSubmenu_Message_Limit_Line2                       ; $49C1  21 f9 49
    call CoordTextPut                         ; $49C4  cd 6e 33
    ld a, $68                          ; $49C7  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $49C9  ef 0b 22 48
.loc_49cd:
    call Joypad_Update                         ; $49CD  cd a2 05
    ldh a, [hJoyPressed]                       ; $49D0  f0 91
    bit 0, a                           ; $49D2  cb 47
    jr nz, .loc_49e0                   ; $49D4  20 0a
    bit 1, a                           ; $49D6  cb 4f
    jr nz, .loc_49e0                   ; $49D8  20 06
    bit 3, a                           ; $49DA  cb 5f
    jr nz, .loc_49e0                   ; $49DC  20 02
    jr .loc_49cd                       ; $49DE  18 ed
.loc_49e0:
    farcall LCDScanlineTransition_Reset                 ; $49E0  ef 0b 60 48
    farcall MapCursor_LoadGraphics                 ; $49E4  ef 0b 21 46
    farcall MapCursor_Show                 ; $49E8  ef 0b f9 46
.loc_49ec:
    ret                                ; $49EC  c9

    assert @ == $49ed

section "Map Editor Fill Rectangle Controller", romx[$4a07], bank[$0f]
MapEditor_RunFillRectangleSelection::
    xor a                              ; $4A07  af
    ld [wMapEditorFillAnchorActive], a                      ; $4A08  ea 55 ca
.loc_4a0b:
    ld bc, $0020                       ; $4A0B  01 20 00
    ld de, $1405                       ; $4A0E  11 05 14
    farcall UIWindow_DrawFrame                 ; $4A11  ef 10 09 6a
    call .loc_4ae7                     ; $4A15  cd e7 4a
    farcall MapCursor_Hide                 ; $4A18  ef 0b 00 47
    call Sprite_Update                         ; $4A1C  cd 56 30
    call DelayFrame                         ; $4A1F  cd d2 04
    farcall SharedGraphics_LoadMenuFontTiles                 ; $4A22  ef 01 fc 40
    ld a, $68                          ; $4A26  3e 68
    farcall LCDScanlineTransition_RunToTarget                 ; $4A28  ef 0b 22 48
.loc_4a2c:
    farcall MapControl_UpdateInteractionInputState                 ; $4A2C  ef 0b fa 74
    call MapEditor_UpdatePlacementPreviewBlink                         ; $4A30  cd 90 44
    ld a, [wMapInteractionInputState]                      ; $4A33  fa 91 ca
    and a                              ; $4A36  a7
    jr z, .loc_4a2c                    ; $4A37  28 f3
    farcall LCDScanlineTransition_Reset                 ; $4A39  ef 0b 60 48
    farcall MapCursor_LoadGraphics                 ; $4A3D  ef 0b 21 46
    farcall MapCursor_Show                 ; $4A41  ef 0b f9 46
    jr .loc_4a51                       ; $4A45  18 0a
.loc_4a47:
    farcall MapControl_UpdateInteractionInputState                 ; $4A47  ef 0b fa 74
    call MapEditor_UpdatePlacementPreviewBlink                         ; $4A4B  cd 90 44
    call MapEditor_UpdateFillAnchorPreview                         ; $4A4E  cd 39 4b
.loc_4a51:
    ld a, [wMapInteractionInputState]                      ; $4A51  fa 91 ca
    bit 0, a                           ; $4A54  cb 47
    jr nz, .loc_4aa9                   ; $4A56  20 51
    bit 1, a                           ; $4A58  cb 4f
    jr nz, .loc_4a94                   ; $4A5A  20 38
    bit 5, a                           ; $4A5C  cb 6f
    jr nz, .loc_4a79                   ; $4A5E  20 19
    bit 4, a                           ; $4A60  cb 67
    jr nz, .loc_4a70                   ; $4A62  20 0c
    bit 6, a                           ; $4A64  cb 77
    jr nz, .loc_4a82                   ; $4A66  20 1a
    bit 7, a                           ; $4A68  cb 7f
    jp nz, .loc_4a8b                   ; $4A6A  c2 8b 4a
    jp .loc_4a47                       ; $4A6D  c3 47 4a
.loc_4a70:
    call MapEditor_RestoreCellAtCursor                         ; $4A70  cd ce 44
    farcall MapControl_AdvanceHorizontalMapPosition                 ; $4A73  ef 0b 25 75
    jr .loc_4a47                       ; $4A77  18 ce
.loc_4a79:
    call MapEditor_RestoreCellAtCursor                         ; $4A79  cd ce 44
    farcall MapControl_RetreatHorizontalMapPosition                 ; $4A7C  ef 0b 64 75
    jr .loc_4a47                       ; $4A80  18 c5
.loc_4a82:
    call MapEditor_RestoreCellAtCursor                         ; $4A82  cd ce 44
    farcall MapControl_RetreatVerticalMapPosition                 ; $4A85  ef 0b db 75
    jr .loc_4a47                       ; $4A89  18 bc
.loc_4a8b:
    call MapEditor_RestoreCellAtCursor                         ; $4A8B  cd ce 44
    farcall MapControl_AdvanceVerticalMapPosition                 ; $4A8E  ef 0b 9c 75
    jr .loc_4a47                       ; $4A92  18 b3
.loc_4a94:
    ld a, SFX_CANCEL                          ; $4A94  3e 0c
    call Audio_PlaySFX                         ; $4A96  cd 44 38
    ld a, [wMapEditorFillAnchorActive]                      ; $4A99  fa 55 ca
    and a                              ; $4A9C  a7
    jr z, .loc_4ae6                    ; $4A9D  28 47
    dec a                              ; $4A9F  3d
    ld [wMapEditorFillAnchorActive], a                      ; $4AA0  ea 55 ca
    call MapEditor_RestoreFillAnchorPreview                         ; $4AA3  cd 8d 4b
    jp .loc_4a0b                       ; $4AA6  c3 0b 4a
.loc_4aa9:
    ld a, SFX_CONFIRM                          ; $4AA9  3e 0a
    call Audio_PlaySFX                         ; $4AAB  cd 44 38
    ld a, [wMapEditorFillAnchorActive]                      ; $4AAE  fa 55 ca
    and a                              ; $4AB1  a7
    jr nz, .loc_4ac8                   ; $4AB2  20 14
    ld a, [wMapActionTargetX]                      ; $4AB4  fa 91 c9
    ld [wMapEditorFillAnchorX], a                      ; $4AB7  ea 53 ca
    ld a, [wMapActionTargetY]                      ; $4ABA  fa 92 c9
    ld [wMapEditorFillAnchorY], a                      ; $4ABD  ea 54 ca
    ld a, $01                          ; $4AC0  3e 01
    ld [wMapEditorFillAnchorActive], a                      ; $4AC2  ea 55 ca
    jp .loc_4a0b                       ; $4AC5  c3 0b 4a
.loc_4ac8:
    ld a, [wMapEditorFillAnchorX]                      ; $4AC8  fa 53 ca
    ld b, a                            ; $4ACB  47
    ld a, [wMapEditorFillAnchorY]                      ; $4ACC  fa 54 ca
    ld c, a                            ; $4ACF  4f
    ld a, [wMapActionTargetX]                      ; $4AD0  fa 91 c9
    ld d, a                            ; $4AD3  57
    ld a, [wMapActionTargetY]                      ; $4AD4  fa 92 c9
    ld e, a                            ; $4AD7  5f
    ld a, [wMapEditorSelectedTerrainId]                      ; $4AD8  fa 65 ca
    call MapEditor_FillRectangle                         ; $4ADB  cd da 52
    farcall MapGrid_RebuildTileCountsAndHQCoordinates                 ; $4ADE  ef 0b 78 41
    farcall Bank0B_MapSetup_428A                 ; $4AE2  ef 0b 8a 42
.loc_4ae6:
    ret                                ; $4AE6  c9
.loc_4ae7:
    ld hl, EditorSubmenu_Message_Fill                       ; $4AE7  21 08 4b
    call CoordTextPut                         ; $4AEA  cd 6e 33
    ld a, [wMapEditorFillAnchorActive]                      ; $4AED  fa 55 ca
    and a                              ; $4AF0  a7
    jr nz, .loc_4afb                   ; $4AF1  20 08
    ld hl, EditorSubmenu_Message_Fill_First                       ; $4AF3  21 14 4b
    call CoordTextPut                         ; $4AF6  cd 6e 33
    jr .loc_4b01                       ; $4AF9  18 06
.loc_4afb:
    ld hl, EditorSubmenu_Message_Fill_Last                       ; $4AFB  21 20 4b
    call CoordTextPut                         ; $4AFE  cd 6e 33
.loc_4b01:
    ld hl, EditorSubmenu_Message_Fill_Confirm                       ; $4B01  21 2b 4b
    call CoordTextPut                         ; $4B04  cd 6e 33
    ret                                ; $4B07  c9

    assert @ == $4b08

section "Map Editor Fill Preview and Shared Value Input", romx[$4b39], bank[$0f]
MapEditor_UpdateFillAnchorPreview::
    ld a, [wMapEditorFillAnchorActive]                      ; $4B39  fa 55 ca
    and a                              ; $4B3C  a7
    jr z, .loc_4b6e                    ; $4B3D  28 2f
    ld a, [wMapEditorFillAnchorX]                      ; $4B3F  fa 53 ca
    ld b, a                            ; $4B42  47
    ld a, [wMapEditorFillAnchorY]                      ; $4B43  fa 54 ca
    ld c, a                            ; $4B46  4f
    farcall $0b, Bank0B_MapSetup_44C6                 ; $4B47  ef 0b c6 44
    and a                              ; $4B4B  a7
    jr nz, .loc_4b6e                   ; $4B4C  20 20
    ld a, [wMapEditorFillPreviewCounter]                      ; $4B4E  fa 56 ca
    inc a                              ; $4B51  3c
    ld [wMapEditorFillPreviewCounter], a                      ; $4B52  ea 56 ca
    cp $0a                             ; $4B55  fe 0a
    jr z, .loc_4b66                    ; $4B57  28 0d
    cp $14                             ; $4B59  fe 14
    jr z, .loc_4b6b                    ; $4B5B  28 0e
    cp $1e                             ; $4B5D  fe 1e
    jr nz, .loc_4b6e                   ; $4B5F  20 0d
    call MapEditor_RestoreFillAnchorPreview                     ; $4B61  cd 8d 4b
    jr .loc_4b6e                       ; $4B64  18 08
.loc_4b66:
    call .loc_4b6f                     ; $4B66  cd 6f 4b
    jr .loc_4b6e                       ; $4B69  18 03
.loc_4b6b:
    call .loc_4b7f                     ; $4B6B  cd 7f 4b
.loc_4b6e:
    ret                                ; $4B6E  c9
.loc_4b6f:
    ld a, [wMapEditorFillAnchorX]                      ; $4B6F  fa 53 ca
    ld b, a                            ; $4B72  47
    ld a, [wMapEditorFillAnchorY]                      ; $4B73  fa 54 ca
    ld c, a                            ; $4B76  4f
    ld a, [wMapEditorSelectedTerrainId]                      ; $4B77  fa 65 ca
    farcall $0b, Bank0B_MapSetup_444D                 ; $4B7A  ef 0b 4d 44
    ret                                ; $4B7E  c9
.loc_4b7f:
    ld a, [wMapEditorFillAnchorX]                      ; $4B7F  fa 53 ca
    ld b, a                            ; $4B82  47
    ld a, [wMapEditorFillAnchorY]                      ; $4B83  fa 54 ca
    ld c, a                            ; $4B86  4f
    xor a                              ; $4B87  af
    farcall $0b, Bank0B_MapSetup_444D                 ; $4B88  ef 0b 4d 44
    ret                                ; $4B8C  c9
MapEditor_RestoreFillAnchorPreview::
    ld a, [wMapEditorFillAnchorX]                      ; $4B8D  fa 53 ca
    ld b, a                            ; $4B90  47
    ld a, [wMapEditorFillAnchorY]                      ; $4B91  fa 54 ca
    ld c, a                            ; $4B94  4f
    farcall $0b, Bank0B_MapSetup_44C6                 ; $4B95  ef 0b c6 44
    and a                              ; $4B99  a7
    jr nz, .loc_4baf                   ; $4B9A  20 13
    farcall MapTile_GetOverlayIdAtCoordinates                 ; $4B9C  ef 0b 92 47
    and a                              ; $4BA0  a7
    jr nz, .loc_4ba9                   ; $4BA1  20 06
    farcall MapTile_GetBaseIdAtCoordinates                 ; $4BA3  ef 0b 70 47
    jr .loc_4bab                       ; $4BA7  18 02
.loc_4ba9:
    add a, $34                         ; $4BA9  c6 34
.loc_4bab:
    farcall $0b, Bank0B_MapSetup_444D                 ; $4BAB  ef 0b 4d 44
.loc_4baf:
    xor a                              ; $4BAF  af
    ld [wMapEditorFillPreviewCounter], a                      ; $4BB0  ea 56 ca
    ret                                ; $4BB3  c9
MapEditor_RunTwoValueSubmenuInput::
    call Joypad_Update                         ; $4BB4  cd a2 05
    ldh a, [hJoyRepeat]                       ; $4BB7  f0 92
    bit 0, a                           ; $4BB9  cb 47
    jr nz, .loc_4bd3                   ; $4BBB  20 16
    bit 1, a                           ; $4BBD  cb 4f
    jr nz, .loc_4bdb                   ; $4BBF  20 1a
    bit 5, a                           ; $4BC1  cb 6f
    jr nz, .loc_4be3                   ; $4BC3  20 1e
    bit 4, a                           ; $4BC5  cb 67
    jr nz, .loc_4c08                   ; $4BC7  20 3f
    bit 6, a                           ; $4BC9  cb 77
    jr nz, .loc_4c2d                   ; $4BCB  20 60
    bit 7, a                           ; $4BCD  cb 7f
    jr nz, .loc_4c2d                   ; $4BCF  20 5c
    jr MapEditor_RunTwoValueSubmenuInput                       ; $4BD1  18 e1
.loc_4bd3:
    ld a, $02                          ; $4BD3  3e 02
    call Audio_PlaySFX                         ; $4BD5  cd 44 38
    xor a                              ; $4BD8  af
    jr .loc_4be2                       ; $4BD9  18 07
.loc_4bdb:
    ld a, SFX_CANCEL                          ; $4BDB  3e 0c
    call Audio_PlaySFX                         ; $4BDD  cd 44 38
    ld a, $ff                          ; $4BE0  3e ff
.loc_4be2:
    ret                                ; $4BE2  c9
.loc_4be3:
    ld a, $01                          ; $4BE3  3e 01
    call Audio_PlaySFX                         ; $4BE5  cd 44 38
    ld a, [wMapEditorMenuSelectionIndex]                      ; $4BE8  fa 40 c9
    ld hl, wMapEditorSubmenuValue0                       ; $4BEB  21 41 c9
    call AddAtoHL                         ; $4BEE  cd bc 29
    ld a, [hl]                         ; $4BF1  7e
    ld b, a                            ; $4BF2  47
    ld a, [wMapEditorSubmenuMin]                      ; $4BF3  fa 44 c9
    cp b                               ; $4BF6  b8
    jr nz, .loc_4c02                   ; $4BF7  20 09
    ld a, [wMapEditorSubmenuMax]                      ; $4BF9  fa 43 c9
    ld [hl], a                         ; $4BFC  77
    call MapEditor_DrawSubmenuValues                         ; $4BFD  cd 65 4d
    jr MapEditor_RunTwoValueSubmenuInput                       ; $4C00  18 b2
.loc_4c02:
    dec [hl]                           ; $4C02  35
    call MapEditor_DrawSubmenuValues                         ; $4C03  cd 65 4d
    jr MapEditor_RunTwoValueSubmenuInput                       ; $4C06  18 ac
.loc_4c08:
    ld a, $01                          ; $4C08  3e 01
    call Audio_PlaySFX                         ; $4C0A  cd 44 38
    ld a, [wMapEditorMenuSelectionIndex]                      ; $4C0D  fa 40 c9
    ld hl, wMapEditorSubmenuValue0                       ; $4C10  21 41 c9
    call AddAtoHL                         ; $4C13  cd bc 29
    ld a, [hl]                         ; $4C16  7e
    ld b, a                            ; $4C17  47
    ld a, [wMapEditorSubmenuMax]                      ; $4C18  fa 43 c9
    cp b                               ; $4C1B  b8
    jr nz, .loc_4c27                   ; $4C1C  20 09
    ld a, [wMapEditorSubmenuMin]                      ; $4C1E  fa 44 c9
    ld [hl], a                         ; $4C21  77
    call MapEditor_DrawSubmenuValues                         ; $4C22  cd 65 4d
    jr MapEditor_RunTwoValueSubmenuInput                       ; $4C25  18 8d
.loc_4c27:
    inc [hl]                           ; $4C27  34
    call MapEditor_DrawSubmenuValues                         ; $4C28  cd 65 4d
    jr MapEditor_RunTwoValueSubmenuInput                       ; $4C2B  18 87
.loc_4c2d:
    ld a, [wMapEditorMenuSelectionIndex]                      ; $4C2D  fa 40 c9
    xor $01                            ; $4C30  ee 01
    call MapEditor_UpdateSubmenuSelection                         ; $4C32  cd cf 4d
    ld a, $02                          ; $4C35  3e 02
    jp MapEditor_RunTwoValueSubmenuInput                       ; $4C37  c3 b4 4b

    assert @ == $4c3a
