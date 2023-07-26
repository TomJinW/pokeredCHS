DEF DEFAULT_PAGE EQU 1
DEF DEFAULT_PAGE_PUN EQU 7

; ld hl, address1     ; Load the first memory address into register HL
; ld de, address2     ; Load the second memory address into register DE
;-> z: Found, z NotFound
;-> hl = lastPointedCharacter
;-> b: tmp Var
CompareHLBytesWithDE:

    push de
    ld c, 7           ; Load the number of bytes to compare into register BC

.compare_loop
    ld a, [de]         ; Load the byte at the address stored in DE into register A
    cp [hl]      ; Compare the byte at the address stored in HL with the value in A

    jr nz, .not_equal   ; If they are not equal, jump to "not_equal"
    inc hl             ; Increment HL to point to the next byte
    inc de             ; Increment DE to point to the next byte
    dec c             ; Decrement the byte counter
    jr nz, .compare_loop; If not all bytes compared yet, repeat the loop
    ; If the loop completes without jumping to "not_equal," it means all bytes are equal
    ; Add your code here for the case when the bytes are equal
    ld a, 1
    cp 1
    pop de
    ret
.not_equal
    inc hl
    dec c
    jr nz, .not_equal
; Add your code here for the case when the bytes are not equal
    ld a, 1
    cp 0
    pop de
    ret



; ld hl, PinyinStrTableLenX 
; ld de, CurrentPinYinAddr 
; ld a, TableLength 
; ->ld de, PinyinCharAddr
; ->ld a, PageNumbers
GetStrCodeAddress:
.loop
    ld [wIMETmpVar], a
    call CompareHLBytesWithDE
    push hl
    jr z, .found
    ld a, [wIMETmpVar]
    dec a
    jr z, .notFound
    pop hl
    ld bc, 3
    add hl, bc
    jr .loop
.found
    ld a, [hli]
	ld e, a
    ld a, [hli]
	ld d, a
    ld a, [hl]
    pop hl
    ret
.notFound
    pop hl
    ld de,IMEBlank
    ld a, DEFAULT_PAGE
    ret


; ld hl, PinyinStrTableLengthTable
; call GetAddrInDWPointertable
; a will be broken
; ld hl, PinyinStrTableLengthTable
; ld c, index
; -> ld de, PointerAddr
GetAddrInDWPointertable:
.loop
    dec c
    jr z, .done
    inc hl
    inc hl
    jr .loop
.done
    ld a, [hli]
	ld e, a
    ld a, [hli]
	ld d, a
    ret

; ld hl, PinyinStrTableInfoTable
; ld c, index
; -> ld a, value
GetAddrInDBPointertable:
.loop
    dec c
    jr z, .done
    inc hl
    jr .loop
.done
    ld a, [hl]
    ret

CalcStringLengthAtHL2:
	ld c, $0
.loop
	ld a, [hl]
	cp "@"
	ret z
	inc hl
	inc c
	jr .loop

LookupPinyinTable:
    ld hl,wIMEPinyin
    call CalcStringLengthAtHL2
    ld a, c
    cp 0

    ld de, IMEBlank
    ld a, DEFAULT_PAGE
    jr z, .emptyStr

    ld hl,PinyinStrTableInfoTable
    call GetAddrInDBPointertable
    push af
    ld hl,wIMEPinyin
    call CalcStringLengthAtHL2
    ld hl,PinyinStrTableLengthTable
    call GetAddrInDWPointertable
    ld h, d
    ld l, e
    ld de, wIMEPinyin
    pop af
    call GetStrCodeAddress
.emptyStr
    ld [wIMEMaxPage], a
    ld a, 1
    ld [wIMECurrentPage], a
    ; ld h, d
    ; ld l, e
    ld a, d
    ld [wIMEAddr], a
    ld a, e
    ld [wIMEAddr + 1], a
    farcall CopyIMECharacters
    call DisplayPinyinOptions
    ret


UpdatePinyinOptions:
    farcall CopyIMECharacters
    call DisplayPinyinOptions
    ret

UpdateCharacterOptions:
    ld a, DEFAULT_PAGE_PUN
    ld [wIMEMaxPage], a
    ld a, 1
    ld [wIMECurrentPage], a
    ld de, IMEDefault
    ld a, d
    ld [wIMEAddr], a
    ld a, e
    ld [wIMEAddr + 1], a
    farcall CopyIMECharacters
    call DisplayPinyinOptions
    ret

; DisplaySingleIMEChar:
;     cp 6
;     jr c, .line1
;     ld bc, SCREEN_WIDTH
;     add hl, bc
; .line1
;     push af
;     ld b, a
;     add a
;     add b

;     ld b, 0
;     ld c, a
;     add hl, bc
;     ld de,wIMETmpVar
;     call PlaceString
;     pop af
;     cp 6
;     jr c, .line1A
;     ld bc, SCREEN_WIDTH
;     push af
;     call SubtractHLbyBC3
;     pop af
; .line1A
;     ret

CopySingleIMEChar:
    ld de,wIMETmpVar
    ld bc, 2
    call CopyData
    ld a, $50
    ld [wIMETmpVarEnding], a
    ret

ModifyBuffer:
    ld hl, wIMEBuffer
    ld c, 25
.loop
    ld a, [hl]
    cp $50
    jr z, .copyRest
    inc hl
    dec c
    jr z, .done
    jr .loop
.done
    ret
.copyRest
    ld a, $50
    ld [hl], a
    inc hl
    dec c
    jr z, .done
    jr .copyRest


DisplayPinyinOptions:
    hlcoord 1, 10
	lb bc, 4, 18
	call ClearScreenArea
    call ModifyBuffer
    call Delay3
    ld hl, wIMEBuffer
    call CopySingleIMEChar
    hlcoord 2,$B
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 2,$a
    lb bc, 2, 2
    ld a, 1
    call DFSStaticize
    push af

    ld hl, wIMEBuffer2
    call CopySingleIMEChar
    hlcoord 5,$B
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 5,$a
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer3
    call CopySingleIMEChar
    hlcoord 8,$B
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 8,$a
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer4
    call CopySingleIMEChar
    hlcoord 11,$B
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 11,$a
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer5
    call CopySingleIMEChar
    hlcoord 14,$B
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 14,$a
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer6
    call CopySingleIMEChar
    hlcoord 17,$B
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 17,$a
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer7
    call CopySingleIMEChar
    hlcoord 2,$D
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 2,$C
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer8
    call CopySingleIMEChar
    hlcoord 5,$D
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 5,$C
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer9
    call CopySingleIMEChar
    hlcoord 8,$D
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 8,$C
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af


    ld hl, wIMEBuffer10
    call CopySingleIMEChar
    hlcoord 11,$D
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 11,$C
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer11
    call CopySingleIMEChar
    hlcoord 14,$D
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 14,$C
    lb bc, 2, 2
    pop af
    call DFSStaticize
    push af

    ld hl, wIMEBuffer12
    call CopySingleIMEChar
    hlcoord 17,$D
    ld de, wIMETmpVar
    call PlaceString
    hlcoord 17,$C
    lb bc, 2, 1
    pop af
    call DFSStaticize

    ret
    


PinyinStrTableLengthTable:
    dw PinyinStrTableLen1
    dw PinyinStrTableLen2
    dw PinyinStrTableLen3
    dw PinyinStrTableLen4
    dw PinyinStrTableLen5
    dw PinyinStrTableLen6
    

PinyinStrTableInfoTable:
	db 4
	db 80
	db 174
	db 120
	db 25
	db 3

PinyinStrTableLen1:
	db "A@@@@@@"
	dw IME_A_Char
	db 1
	;6
	db "E@@@@@@"
	dw IME_E_Char
	db 3
	;32
	db "O@@@@@@"
	dw IME_O_Char
	db 1
	;2
	db "M@@@@@@"
	dw IME_M_Char
	db 1
	;1

PinyinStrTableLen2:
	db "AI@@@@@"
	dw IME_AI_Char
	db 2
	;22
	db "YI@@@@@"
	dw IME_YI_Char
	db 9
	;106
	db "AN@@@@@"
	dw IME_AN_Char
	db 2
	;18
	db "AO@@@@@"
	dw IME_AO_Char
	db 2
	;23
	db "BA@@@@@"
	dw IME_BA_Char
	db 3
	;26
	db "PA@@@@@"
	dw IME_PA_Char
	db 1
	;11
	db "BO@@@@@"
	dw IME_BO_Char
	db 3
	;34
	db "PU@@@@@"
	dw IME_PU_Char
	db 3
	;25
	db "PI@@@@@"
	dw IME_PI_Char
	db 4
	;44
	db "BI@@@@@"
	dw IME_BI_Char
	db 5
	;56
	db "BU@@@@@"
	dw IME_BU_Char
	db 2
	;19
	db "CA@@@@@"
	dw IME_CA_Char
	db 1
	;3
	db "CE@@@@@"
	dw IME_CE_Char
	db 1
	;6
	db "CI@@@@@"
	dw IME_CI_Char
	db 2
	;17
	db "JU@@@@@"
	dw IME_JU_Char
	db 5
	;53
	db "CU@@@@@"
	dw IME_CU_Char
	db 1
	;12
	db "DA@@@@@"
	dw IME_DA_Char
	db 2
	;17
	db "DE@@@@@"
	dw IME_DE_Char
	db 1
	;5
	db "DI@@@@@"
	dw IME_DI_Char
	db 4
	;39
	db "DU@@@@@"
	dw IME_DU_Char
	db 2
	;24
	db "WU@@@@@"
	dw IME_WU_Char
	db 5
	;54
	db "EN@@@@@"
	dw IME_EN_Char
	db 1
	;4
	db "ER@@@@@"
	dw IME_ER_Char
	db 2
	;13
	db "FA@@@@@"
	dw IME_FA_Char
	db 1
	;10
	db "FO@@@@@"
	dw IME_FO_Char
	db 1
	;1
	db "FU@@@@@"
	dw IME_FU_Char
	db 7
	;83
	db "GA@@@@@"
	dw IME_GA_Char
	db 1
	;10
	db "GU@@@@@"
	dw IME_GU_Char
	db 4
	;43
	db "GE@@@@@"
	dw IME_GE_Char
	db 3
	;35
	db "HA@@@@@"
	dw IME_HA_Char
	db 1
	;3
	db "JI@@@@@"
	dw IME_JI_Char
	db 9
	;104
	db "HE@@@@@"
	dw IME_HE_Char
	db 3
	;28
	db "HU@@@@@"
	dw IME_HU_Char
	db 4
	;45
	db "QI@@@@@"
	dw IME_QI_Char
	db 6
	;68
	db "KA@@@@@"
	dw IME_KA_Char
	db 1
	;7
	db "LO@@@@@"
	dw IME_LO_Char
	db 1
	;1
	db "KE@@@@@"
	dw IME_KE_Char
	db 3
	;33
	db "KU@@@@@"
	dw IME_KU_Char
	db 1
	;12
	db "LA@@@@@"
	dw IME_LA_Char
	db 2
	;13
	db "LE@@@@@"
	dw IME_LE_Char
	db 1
	;7
	db "LI@@@@@"
	dw IME_LI_Char
	db 7
	;77
	db "LU@@@@@"
	dw IME_LU_Char
	db 4
	;41
	db "LV@@@@@"
	dw IME_LV_Char
	db 2
	;21
	db "MA@@@@@"
	dw IME_MA_Char
	db 2
	;15
	db "MO@@@@@"
	dw IME_MO_Char
	db 3
	;32
	db "ME@@@@@"
	dw IME_ME_Char
	db 1
	;2
	db "MI@@@@@"
	dw IME_MI_Char
	db 3
	;27
	db "MU@@@@@"
	dw IME_MU_Char
	db 2
	;22
	db "NA@@@@@"
	dw IME_NA_Char
	db 1
	;12
	db "NE@@@@@"
	dw IME_NE_Char
	db 1
	;2
	db "NI@@@@@"
	dw IME_NI_Char
	db 2
	;21
	db "NU@@@@@"
	dw IME_NU_Char
	db 1
	;7
	db "NV@@@@@"
	dw IME_NV_Char
	db 1
	;4
	db "OU@@@@@"
	dw IME_OU_Char
	db 1
	;11
	db "PO@@@@@"
	dw IME_PO_Char
	db 2
	;15
	db "XI@@@@@"
	dw IME_XI_Char
	db 7
	;76
	db "QU@@@@@"
	dw IME_QU_Char
	db 3
	;34
	db "RE@@@@@"
	dw IME_RE_Char
	db 1
	;3
	db "RI@@@@@"
	dw IME_RI_Char
	db 1
	;1
	db "RU@@@@@"
	dw IME_RU_Char
	db 2
	;20
	db "SA@@@@@"
	dw IME_SA_Char
	db 1
	;7
	db "SE@@@@@"
	dw IME_SE_Char
	db 1
	;7
	db "SI@@@@@"
	dw IME_SI_Char
	db 3
	;34
	db "SU@@@@@"
	dw IME_SU_Char
	db 2
	;22
	db "TA@@@@@"
	dw IME_TA_Char
	db 2
	;19
	db "TE@@@@@"
	dw IME_TE_Char
	db 1
	;5
	db "TI@@@@@"
	dw IME_TI_Char
	db 2
	;24
	db "TU@@@@@"
	dw IME_TU_Char
	db 2
	;16
	db "WA@@@@@"
	dw IME_WA_Char
	db 1
	;10
	db "YU@@@@@"
	dw IME_YU_Char
	db 8
	;93
	db "WO@@@@@"
	dw IME_WO_Char
	db 2
	;17
	db "XU@@@@@"
	dw IME_XU_Char
	db 3
	;34
	db "YA@@@@@"
	dw IME_YA_Char
	db 3
	;29
	db "YE@@@@@"
	dw IME_YE_Char
	db 2
	;24
	db "YO@@@@@"
	dw IME_YO_Char
	db 1
	;2
	db "ZA@@@@@"
	dw IME_ZA_Char
	db 1
	;6
	db "ZE@@@@@"
	dw IME_ZE_Char
	db 2
	;14
	db "ZI@@@@@"
	dw IME_ZI_Char
	db 4
	;38
	db "ZU@@@@@"
	dw IME_ZU_Char
	db 1
	;11
	db "EI@@@@@"
	dw IME_EI_Char
	db 1
	;1

PinyinStrTableLen3:
	db "ANG@@@@"
	dw IME_ANG_Char
	db 1
	;3
	db "BAI@@@@"
	dw IME_BAI_Char
	db 1
	;10
	db "BAN@@@@"
	dw IME_BAN_Char
	db 2
	;21
	db "BAO@@@@"
	dw IME_BAO_Char
	db 3
	;28
	db "BEI@@@@"
	dw IME_BEI_Char
	db 3
	;26
	db "BEN@@@@"
	dw IME_BEN_Char
	db 1
	;8
	db "BIE@@@@"
	dw IME_BIE_Char
	db 1
	;5
	db "BIN@@@@"
	dw IME_BIN_Char
	db 2
	;16
	db "CAI@@@@"
	dw IME_CAI_Char
	db 1
	;11
	db "CAN@@@@"
	dw IME_CAN_Char
	db 1
	;12
	db "CEN@@@@"
	dw IME_CEN_Char
	db 1
	;3
	db "CAO@@@@"
	dw IME_CAO_Char
	db 1
	;9
	db "CHA@@@@"
	dw IME_CHA_Char
	db 3
	;25
	db "CHE@@@@"
	dw IME_CHE_Char
	db 1
	;8
	db "CHI@@@@"
	dw IME_CHI_Char
	db 4
	;38
	db "SHI@@@@"
	dw IME_SHI_Char
	db 6
	;65
	db "XIU@@@@"
	dw IME_XIU_Char
	db 2
	;18
	db "CHU@@@@"
	dw IME_CHU_Char
	db 3
	;29
	db "COU@@@@"
	dw IME_COU_Char
	db 1
	;4
	db "CUI@@@@"
	dw IME_CUI_Char
	db 2
	;15
	db "CUN@@@@"
	dw IME_CUN_Char
	db 1
	;5
	db "CUO@@@@"
	dw IME_CUO_Char
	db 2
	;15
	db "TAI@@@@"
	dw IME_TAI_Char
	db 2
	;18
	db "DAI@@@@"
	dw IME_DAI_Char
	db 2
	;20
	db "DAN@@@@"
	dw IME_DAN_Char
	db 3
	;30
	db "TAN@@@@"
	dw IME_TAN_Char
	db 3
	;26
	db "DAO@@@@"
	dw IME_DAO_Char
	db 2
	;16
	db "DIE@@@@"
	dw IME_DIE_Char
	db 2
	;15
	db "DIU@@@@"
	dw IME_DIU_Char
	db 1
	;2
	db "DOU@@@@"
	dw IME_DOU_Char
	db 2
	;13
	db "DUO@@@@"
	dw IME_DUO_Char
	db 2
	;20
	db "DUI@@@@"
	dw IME_DUI_Char
	db 1
	;9
	db "DUN@@@@"
	dw IME_DUN_Char
	db 2
	;15
	db "TUN@@@@"
	dw IME_TUN_Char
	db 1
	;9
	db "FAN@@@@"
	dw IME_FAN_Char
	db 3
	;26
	db "FEI@@@@"
	dw IME_FEI_Char
	db 3
	;30
	db "FEN@@@@"
	dw IME_FEN_Char
	db 2
	;20
	db "FOU@@@@"
	dw IME_FOU_Char
	db 1
	;2
	db "GAI@@@@"
	dw IME_GAI_Char
	db 1
	;11
	db "GAN@@@@"
	dw IME_GAN_Char
	db 2
	;24
	db "GAO@@@@"
	dw IME_GAO_Char
	db 2
	;19
	db "GEI@@@@"
	dw IME_GEI_Char
	db 1
	;1
	db "GEN@@@@"
	dw IME_GEN_Char
	db 1
	;6
	db "GOU@@@@"
	dw IME_GOU_Char
	db 2
	;21
	db "GUA@@@@"
	dw IME_GUA_Char
	db 1
	;12
	db "GUI@@@@"
	dw IME_GUI_Char
	db 3
	;28
	db "GUN@@@@"
	dw IME_GUN_Char
	db 1
	;7
	db "GUO@@@@"
	dw IME_GUO_Char
	db 2
	;18
	db "HAI@@@@"
	dw IME_HAI_Char
	db 1
	;11
	db "HAN@@@@"
	dw IME_HAN_Char
	db 3
	;31
	db "HAO@@@@"
	dw IME_HAO_Char
	db 2
	;20
	db "HUO@@@@"
	dw IME_HUO_Char
	db 2
	;21
	db "HEI@@@@"
	dw IME_HEI_Char
	db 1
	;2
	db "HEN@@@@"
	dw IME_HEN_Char
	db 1
	;4
	db "HOU@@@@"
	dw IME_HOU_Char
	db 2
	;15
	db "HUA@@@@"
	dw IME_HUA_Char
	db 2
	;13
	db "HUI@@@@"
	dw IME_HUI_Char
	db 4
	;38
	db "HUN@@@@"
	dw IME_HUN_Char
	db 1
	;11
	db "JIA@@@@"
	dw IME_JIA_Char
	db 3
	;36
	db "QIA@@@@"
	dw IME_QIA_Char
	db 1
	;7
	db "KAN@@@@"
	dw IME_KAN_Char
	db 2
	;13
	db "JUE@@@@"
	dw IME_JUE_Char
	db 3
	;28
	db "JIE@@@@"
	dw IME_JIE_Char
	db 4
	;42
	db "JIN@@@@"
	dw IME_JIN_Char
	db 3
	;34
	db "JIU@@@@"
	dw IME_JIU_Char
	db 3
	;26
	db "JUN@@@@"
	dw IME_JUN_Char
	db 2
	;15
	db "XUN@@@@"
	dw IME_XUN_Char
	db 3
	;32
	db "KAI@@@@"
	dw IME_KAI_Char
	db 2
	;13
	db "KAO@@@@"
	dw IME_KAO_Char
	db 1
	;8
	db "KEN@@@@"
	dw IME_KEN_Char
	db 1
	;6
	db "KOU@@@@"
	dw IME_KOU_Char
	db 1
	;10
	db "KUA@@@@"
	dw IME_KUA_Char
	db 1
	;6
	db "KUI@@@@"
	dw IME_KUI_Char
	db 3
	;28
	db "KUN@@@@"
	dw IME_KUN_Char
	db 1
	;11
	db "KUO@@@@"
	dw IME_KUO_Char
	db 1
	;5
	db "LAI@@@@"
	dw IME_LAI_Char
	db 1
	;12
	db "LAN@@@@"
	dw IME_LAN_Char
	db 2
	;22
	db "LAO@@@@"
	dw IME_LAO_Char
	db 2
	;19
	db "LUO@@@@"
	dw IME_LUO_Char
	db 3
	;27
	db "YUE@@@@"
	dw IME_YUE_Char
	db 2
	;19
	db "LEI@@@@"
	dw IME_LEI_Char
	db 2
	;19
	db "LIA@@@@"
	dw IME_LIA_Char
	db 1
	;1
	db "LIE@@@@"
	dw IME_LIE_Char
	db 2
	;13
	db "LIN@@@@"
	dw IME_LIN_Char
	db 2
	;24
	db "LIU@@@@"
	dw IME_LIU_Char
	db 2
	;21
	db "LOU@@@@"
	dw IME_LOU_Char
	db 2
	;16
	db "LUE@@@@"
	dw IME_LUE_Char
	db 1
	;3
	db "LVE@@@@"
	dw IME_LVE_Char
	db 1
	;3
	db "LUN@@@@"
	dw IME_LUN_Char
	db 1
	;8
	db "MAI@@@@"
	dw IME_MAI_Char
	db 1
	;9
	db "MAN@@@@"
	dw IME_MAN_Char
	db 2
	;18
	db "WAN@@@@"
	dw IME_WAN_Char
	db 3
	;28
	db "MAO@@@@"
	dw IME_MAO_Char
	db 3
	;26
	db "MEI@@@@"
	dw IME_MEI_Char
	db 3
	;27
	db "MEN@@@@"
	dw IME_MEN_Char
	db 1
	;7
	db "MIE@@@@"
	dw IME_MIE_Char
	db 1
	;6
	db "MIN@@@@"
	dw IME_MIN_Char
	db 2
	;16
	db "MIU@@@@"
	dw IME_MIU_Char
	db 1
	;2
	db "MOU@@@@"
	dw IME_MOU_Char
	db 1
	;9
	db "NUO@@@@"
	dw IME_NUO_Char
	db 1
	;8
	db "NAI@@@@"
	dw IME_NAI_Char
	db 1
	;10
	db "NAN@@@@"
	dw IME_NAN_Char
	db 1
	;10
	db "NAO@@@@"
	dw IME_NAO_Char
	db 2
	;13
	db "NEI@@@@"
	dw IME_NEI_Char
	db 1
	;2
	db "NEN@@@@"
	dw IME_NEN_Char
	db 1
	;2
	db "NIE@@@@"
	dw IME_NIE_Char
	db 2
	;14
	db "NIN@@@@"
	dw IME_NIN_Char
	db 1
	;1
	db "NIU@@@@"
	dw IME_NIU_Char
	db 1
	;8
	db "NUE@@@@"
	dw IME_NUE_Char
	db 1
	;3
	db "NVE@@@@"
	dw IME_NVE_Char
	db 1
	;3
	db "PAI@@@@"
	dw IME_PAI_Char
	db 1
	;9
	db "PAN@@@@"
	dw IME_PAN_Char
	db 2
	;16
	db "PAO@@@@"
	dw IME_PAO_Char
	db 1
	;12
	db "PEI@@@@"
	dw IME_PEI_Char
	db 2
	;15
	db "PEN@@@@"
	dw IME_PEN_Char
	db 1
	;3
	db "PIE@@@@"
	dw IME_PIE_Char
	db 1
	;6
	db "PIN@@@@"
	dw IME_PIN_Char
	db 1
	;10
	db "POU@@@@"
	dw IME_POU_Char
	db 1
	;3
	db "QIE@@@@"
	dw IME_QIE_Char
	db 2
	;13
	db "QIN@@@@"
	dw IME_QIN_Char
	db 2
	;23
	db "QIU@@@@"
	dw IME_QIU_Char
	db 2
	;23
	db "QUE@@@@"
	dw IME_QUE_Char
	db 1
	;11
	db "QUN@@@@"
	dw IME_QUN_Char
	db 1
	;4
	db "RAN@@@@"
	dw IME_RAN_Char
	db 1
	;7
	db "RAO@@@@"
	dw IME_RAO_Char
	db 1
	;6
	db "REN@@@@"
	dw IME_REN_Char
	db 2
	;16
	db "ROU@@@@"
	dw IME_ROU_Char
	db 1
	;6
	db "RUI@@@@"
	dw IME_RUI_Char
	db 1
	;8
	db "RUN@@@@"
	dw IME_RUN_Char
	db 1
	;2
	db "RUO@@@@"
	dw IME_RUO_Char
	db 1
	;4
	db "SAI@@@@"
	dw IME_SAI_Char
	db 1
	;5
	db "SAN@@@@"
	dw IME_SAN_Char
	db 1
	;9
	db "SAO@@@@"
	dw IME_SAO_Char
	db 1
	;9
	db "SEN@@@@"
	dw IME_SEN_Char
	db 1
	;1
	db "SHA@@@@"
	dw IME_SHA_Char
	db 2
	;18
	db "SUO@@@@"
	dw IME_SUO_Char
	db 2
	;17
	db "SHE@@@@"
	dw IME_SHE_Char
	db 2
	;20
	db "SHU@@@@"
	dw IME_SHU_Char
	db 4
	;47
	db "ZHU@@@@"
	dw IME_ZHU_Char
	db 4
	;48
	db "SOU@@@@"
	dw IME_SOU_Char
	db 2
	;14
	db "SUI@@@@"
	dw IME_SUI_Char
	db 2
	;18
	db "SUN@@@@"
	dw IME_SUN_Char
	db 1
	;8
	db "TAO@@@@"
	dw IME_TAO_Char
	db 2
	;17
	db "TIE@@@@"
	dw IME_TIE_Char
	db 1
	;5
	db "TOU@@@@"
	dw IME_TOU_Char
	db 1
	;5
	db "TUI@@@@"
	dw IME_TUI_Char
	db 1
	;8
	db "TUO@@@@"
	dw IME_TUO_Char
	db 2
	;24
	db "WAI@@@@"
	dw IME_WAI_Char
	db 1
	;3
	db "WEI@@@@"
	dw IME_WEI_Char
	db 5
	;60
	db "WEN@@@@"
	dw IME_WEN_Char
	db 2
	;17
	db "XIA@@@@"
	dw IME_XIA_Char
	db 2
	;21
	db "XUE@@@@"
	dw IME_XUE_Char
	db 1
	;12
	db "XIE@@@@"
	dw IME_XIE_Char
	db 4
	;39
	db "XIN@@@@"
	dw IME_XIN_Char
	db 2
	;17
	db "YAN@@@@"
	dw IME_YAN_Char
	db 6
	;67
	db "YAO@@@@"
	dw IME_YAO_Char
	db 3
	;33
	db "YIN@@@@"
	dw IME_YIN_Char
	db 3
	;33
	db "YOU@@@@"
	dw IME_YOU_Char
	db 4
	;43
	db "YUN@@@@"
	dw IME_YUN_Char
	db 2
	;24
	db "ZAI@@@@"
	dw IME_ZAI_Char
	db 1
	;10
	db "ZAN@@@@"
	dw IME_ZAN_Char
	db 1
	;10
	db "ZAO@@@@"
	dw IME_ZAO_Char
	db 2
	;15
	db "ZEI@@@@"
	dw IME_ZEI_Char
	db 1
	;1
	db "ZEN@@@@"
	dw IME_ZEN_Char
	db 1
	;2
	db "ZHA@@@@"
	dw IME_ZHA_Char
	db 2
	;24
	db "ZHE@@@@"
	dw IME_ZHE_Char
	db 2
	;22
	db "ZHI@@@@"
	dw IME_ZHI_Char
	db 7
	;76
	db "ZOU@@@@"
	dw IME_ZOU_Char
	db 1
	;9
	db "ZUI@@@@"
	dw IME_ZUI_Char
	db 1
	;6
	db "ZUN@@@@"
	dw IME_ZUN_Char
	db 1
	;5
	db "ZUO@@@@"
	dw IME_ZUO_Char
	db 2
	;16
	db "PUO@@@@"
	dw IME_PUO_Char
	db 1
	;1
	db "DIA@@@@"
	dw IME_DIA_Char
	db 1
	;1
	db "NOU@@@@"
	dw IME_NOU_Char
	db 1
	;1

PinyinStrTableLen4:
	db "BANG@@@"
	dw IME_BANG_Char
	db 2
	;14
	db "PANG@@@"
	dw IME_PANG_Char
	db 1
	;12
	db "BENG@@@"
	dw IME_BENG_Char
	db 1
	;9
	db "BIAN@@@"
	dw IME_BIAN_Char
	db 3
	;26
	db "PIAN@@@"
	dw IME_PIAN_Char
	db 1
	;11
	db "BIAO@@@"
	dw IME_BIAO_Char
	db 2
	;14
	db "BING@@@"
	dw IME_BING_Char
	db 2
	;14
	db "SHEN@@@"
	dw IME_SHEN_Char
	db 3
	;29
	db "CANG@@@"
	dw IME_CANG_Char
	db 1
	;6
	db "CENG@@@"
	dw IME_CENG_Char
	db 1
	;4
	db "CHAI@@@"
	dw IME_CHAI_Char
	db 1
	;8
	db "CHAN@@@"
	dw IME_CHAN_Char
	db 3
	;25
	db "CHAO@@@"
	dw IME_CHAO_Char
	db 2
	;15
	db "ZHAO@@@"
	dw IME_ZHAO_Char
	db 2
	;17
	db "CHEN@@@"
	dw IME_CHEN_Char
	db 2
	;21
	db "CHOU@@@"
	dw IME_CHOU_Char
	db 2
	;17
	db "CHUI@@@"
	dw IME_CHUI_Char
	db 1
	;9
	db "CHUN@@@"
	dw IME_CHUN_Char
	db 1
	;10
	db "CHUO@@@"
	dw IME_CHUO_Char
	db 1
	;6
	db "CONG@@@"
	dw IME_CONG_Char
	db 1
	;12
	db "CUAN@@@"
	dw IME_CUAN_Char
	db 1
	;8
	db "DANG@@@"
	dw IME_DANG_Char
	db 1
	;9
	db "DENG@@@"
	dw IME_DENG_Char
	db 2
	;13
	db "ZHAI@@@"
	dw IME_ZHAI_Char
	db 1
	;9
	db "DIAN@@@"
	dw IME_DIAN_Char
	db 3
	;26
	db "DIAO@@@"
	dw IME_DIAO_Char
	db 1
	;11
	db "TIAO@@@"
	dw IME_TIAO_Char
	db 2
	;16
	db "DING@@@"
	dw IME_DING_Char
	db 2
	;18
	db "DONG@@@"
	dw IME_DONG_Char
	db 2
	;19
	db "DUAN@@@"
	dw IME_DUAN_Char
	db 1
	;9
	db "FANG@@@"
	dw IME_FANG_Char
	db 2
	;16
	db "FENG@@@"
	dw IME_FENG_Char
	db 2
	;21
	db "PING@@@"
	dw IME_PING_Char
	db 2
	;14
	db "GANG@@@"
	dw IME_GANG_Char
	db 1
	;12
	db "GENG@@@"
	dw IME_GENG_Char
	db 1
	;11
	db "GONG@@@"
	dw IME_GONG_Char
	db 2
	;19
	db "GUAI@@@"
	dw IME_GUAI_Char
	db 1
	;4
	db "GUAN@@@"
	dw IME_GUAN_Char
	db 2
	;20
	db "HANG@@@"
	dw IME_HANG_Char
	db 1
	;8
	db "HENG@@@"
	dw IME_HENG_Char
	db 1
	;8
	db "HONG@@@"
	dw IME_HONG_Char
	db 2
	;17
	db "HUAI@@@"
	dw IME_HUAI_Char
	db 1
	;6
	db "HUAN@@@"
	dw IME_HUAN_Char
	db 3
	;29
	db "KUAI@@@"
	dw IME_KUAI_Char
	db 1
	;11
	db "JIAN@@@"
	dw IME_JIAN_Char
	db 6
	;68
	db "XIAN@@@"
	dw IME_XIAN_Char
	db 4
	;48
	db "JIAO@@@"
	dw IME_JIAO_Char
	db 4
	;46
	db "JING@@@"
	dw IME_JING_Char
	db 4
	;40
	db "JUAN@@@"
	dw IME_JUAN_Char
	db 2
	;15
	db "KANG@@@"
	dw IME_KANG_Char
	db 1
	;10
	db "QIAO@@@"
	dw IME_QIAO_Char
	db 3
	;29
	db "KENG@@@"
	dw IME_KENG_Char
	db 1
	;3
	db "KONG@@@"
	dw IME_KONG_Char
	db 1
	;7
	db "KUAN@@@"
	dw IME_KUAN_Char
	db 1
	;3
	db "LANG@@@"
	dw IME_LANG_Char
	db 1
	;12
	db "LENG@@@"
	dw IME_LENG_Char
	db 1
	;5
	db "LIAN@@@"
	dw IME_LIAN_Char
	db 3
	;26
	db "LIAO@@@"
	dw IME_LIAO_Char
	db 2
	;21
	db "LING@@@"
	dw IME_LING_Char
	db 3
	;27
	db "LONG@@@"
	dw IME_LONG_Char
	db 2
	;17
	db "LUAN@@@"
	dw IME_LUAN_Char
	db 1
	;11
	db "MANG@@@"
	dw IME_MANG_Char
	db 1
	;10
	db "MENG@@@"
	dw IME_MENG_Char
	db 2
	;19
	db "MIAN@@@"
	dw IME_MIAN_Char
	db 2
	;14
	db "MIAO@@@"
	dw IME_MIAO_Char
	db 2
	;16
	db "MING@@@"
	dw IME_MING_Char
	db 1
	;12
	db "NANG@@@"
	dw IME_NANG_Char
	db 1
	;5
	db "NENG@@@"
	dw IME_NENG_Char
	db 1
	;1
	db "NIAN@@@"
	dw IME_NIAN_Char
	db 2
	;14
	db "NIAO@@@"
	dw IME_NIAO_Char
	db 1
	;6
	db "NING@@@"
	dw IME_NING_Char
	db 1
	;10
	db "NONG@@@"
	dw IME_NONG_Char
	db 1
	;6
	db "NUAN@@@"
	dw IME_NUAN_Char
	db 1
	;1
	db "PENG@@@"
	dw IME_PENG_Char
	db 2
	;18
	db "PIAO@@@"
	dw IME_PIAO_Char
	db 1
	;12
	db "QIAN@@@"
	dw IME_QIAN_Char
	db 4
	;44
	db "SHAO@@@"
	dw IME_SHAO_Char
	db 2
	;19
	db "QING@@@"
	dw IME_QING_Char
	db 2
	;23
	db "QUAN@@@"
	dw IME_QUAN_Char
	db 2
	;22
	db "RANG@@@"
	dw IME_RANG_Char
	db 1
	;7
	db "RENG@@@"
	dw IME_RENG_Char
	db 1
	;2
	db "RONG@@@"
	dw IME_RONG_Char
	db 2
	;15
	db "RUAN@@@"
	dw IME_RUAN_Char
	db 1
	;3
	db "SANG@@@"
	dw IME_SANG_Char
	db 1
	;6
	db "SENG@@@"
	dw IME_SENG_Char
	db 1
	;1
	db "SHAI@@@"
	dw IME_SHAI_Char
	db 1
	;3
	db "SHAN@@@"
	dw IME_SHAN_Char
	db 3
	;33
	db "XING@@@"
	dw IME_XING_Char
	db 2
	;23
	db "SHOU@@@"
	dw IME_SHOU_Char
	db 2
	;13
	db "SHUO@@@"
	dw IME_SHUO_Char
	db 1
	;10
	db "SHUA@@@"
	dw IME_SHUA_Char
	db 1
	;3
	db "SHUI@@@"
	dw IME_SHUI_Char
	db 1
	;5
	db "SHUN@@@"
	dw IME_SHUN_Char
	db 1
	;4
	db "SONG@@@"
	dw IME_SONG_Char
	db 2
	;16
	db "SUAN@@@"
	dw IME_SUAN_Char
	db 1
	;4
	db "TANG@@@"
	dw IME_TANG_Char
	db 3
	;26
	db "TENG@@@"
	dw IME_TENG_Char
	db 1
	;5
	db "TIAN@@@"
	dw IME_TIAN_Char
	db 2
	;13
	db "TING@@@"
	dw IME_TING_Char
	db 2
	;17
	db "TONG@@@"
	dw IME_TONG_Char
	db 2
	;20
	db "TUAN@@@"
	dw IME_TUAN_Char
	db 1
	;5
	db "ZHUN@@@"
	dw IME_ZHUN_Char
	db 1
	;5
	db "WANG@@@"
	dw IME_WANG_Char
	db 2
	;14
	db "WENG@@@"
	dw IME_WENG_Char
	db 1
	;5
	db "ZHUA@@@"
	dw IME_ZHUA_Char
	db 1
	;3
	db "XIAO@@@"
	dw IME_XIAO_Char
	db 3
	;30
	db "XUAN@@@"
	dw IME_XUAN_Char
	db 3
	;26
	db "YANG@@@"
	dw IME_YANG_Char
	db 3
	;25
	db "YING@@@"
	dw IME_YING_Char
	db 4
	;39
	db "YONG@@@"
	dw IME_YONG_Char
	db 3
	;25
	db "YUAN@@@"
	dw IME_YUAN_Char
	db 3
	;35
	db "ZANG@@@"
	dw IME_ZANG_Char
	db 1
	;6
	db "ZENG@@@"
	dw IME_ZENG_Char
	db 1
	;9
	db "ZHAN@@@"
	dw IME_ZHAN_Char
	db 2
	;20
	db "ZHEN@@@"
	dw IME_ZHEN_Char
	db 3
	;33
	db "ZHOU@@@"
	dw IME_ZHOU_Char
	db 2
	;24
	db "ZHUI@@@"
	dw IME_ZHUI_Char
	db 1
	;11
	db "ZHUO@@@"
	dw IME_ZHUO_Char
	db 2
	;20
	db "ZONG@@@"
	dw IME_ZONG_Char
	db 1
	;10
	db "ZUAN@@@"
	dw IME_ZUAN_Char
	db 1
	;5

PinyinStrTableLen5:
	db "CHANG@@"
	dw IME_CHANG_Char
	db 3
	;27
	db "ZHANG@@"
	dw IME_ZHANG_Char
	db 2
	;24
	db "CHENG@@"
	dw IME_CHENG_Char
	db 3
	;26
	db "SHENG@@"
	dw IME_SHENG_Char
	db 2
	;17
	db "CHONG@@"
	dw IME_CHONG_Char
	db 1
	;12
	db "CHUAI@@"
	dw IME_CHUAI_Char
	db 1
	;6
	db "CHUAN@@"
	dw IME_CHUAN_Char
	db 1
	;12
	db "ZHUAN@@"
	dw IME_ZHUAN_Char
	db 1
	;10
	db "GUANG@@"
	dw IME_GUANG_Char
	db 1
	;7
	db "HUANG@@"
	dw IME_HUANG_Char
	db 3
	;25
	db "JIANG@@"
	dw IME_JIANG_Char
	db 2
	;24
	db "QIANG@@"
	dw IME_QIANG_Char
	db 2
	;21
	db "XIANG@@"
	dw IME_XIANG_Char
	db 3
	;30
	db "JIONG@@"
	dw IME_JIONG_Char
	db 1
	;4
	db "KUANG@@"
	dw IME_KUANG_Char
	db 2
	;16
	db "LIANG@@"
	dw IME_LIANG_Char
	db 2
	;19
	db "SHUAI@@"
	dw IME_SHUAI_Char
	db 1
	;6
	db "NIANG@@"
	dw IME_NIANG_Char
	db 1
	;2
	db "QIONG@@"
	dw IME_QIONG_Char
	db 1
	;9
	db "SHANG@@"
	dw IME_SHANG_Char
	db 2
	;14
	db "SHUAN@@"
	dw IME_SHUAN_Char
	db 1
	;4
	db "XIONG@@"
	dw IME_XIONG_Char
	db 1
	;8
	db "ZHENG@@"
	dw IME_ZHENG_Char
	db 2
	;20
	db "ZHONG@@"
	dw IME_ZHONG_Char
	db 2
	;17
	db "ZHUAI@@"
	dw IME_ZHUAI_Char
	db 1
	;1

PinyinStrTableLen6:
	db "CHUANG@"
	dw IME_CHUANG_Char
	db 1
	;7
	db "ZHUANG@"
	dw IME_ZHUANG_Char
	db 1
	;9
	db "SHUANG@"
	dw IME_SHUANG_Char
	db 1
	;4

