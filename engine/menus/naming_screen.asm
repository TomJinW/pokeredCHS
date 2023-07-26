AskName:
	call SaveScreenTilesToBuffer1
	call GetPredefRegisters
	push hl
	ld a, [wIsInBattle]
	dec a
	hlcoord 0, 0
	lb bc, 4, 11
	call z, ClearScreenArea ; only if in wild battle
	ld a, [wcf91]
	ld [wd11e], a
	call GetMonName
	ld hl, DoYouWantToNicknameText
	call PrintText
	hlcoord 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declinedNickname
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	push hl
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wIsInBattle]
	and a
	jr nz, .inBattle
	call ReloadMapSpriteTilePatterns
.inBattle
	call LoadScreenTilesFromBuffer1
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ld a, [wStringBuffer]
	cp "@"
	ret nz
.declinedNickname
	ld d, h
	ld e, l
	ld hl, wcd6d
	ld bc, NAME_LENGTH
	jp CopyData

DoYouWantToNicknameText:
	text_far _DoYouWantToNicknameText
	text_end

DisplayNameRaterScreen::
	ld hl, wBuffer
	xor a
	ld [wUpdateSpritesEnabled], a
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	ld a, [wStringBuffer]
	cp "@"
	jr z, .playerCancelled
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wBuffer
	ld bc, NAME_LENGTH
	call CopyData
	and a
	ret
.playerCancelled
	scf
	ret

DisplayNamingScreen:
	push hl
	ld hl, wd730
	set 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call LoadHpBarAndStatusTilePatterns
	
	farcall LoadMonPartySpriteGfx
	hlcoord 0, 4
	lb bc, 9, 18
	call TextBoxBorder
	call LoadFontTilePatterns ;Fix Naming Screen CHS_Fix
	farcall DFSSetAlphabetCache 
	call ResetPinyinBuffer
	call LoadEDTile
	; ld a, $A0 ;XX
	; ld [wIMEAddr], a
	; ld a, $89 ;XX
	; ld [wIMEAddr], a
	ld a, 0
	ld [wIMECurrentPage], a
	call PrintNamingText
	; ld a, $63
	; hlcoord 0,0
	; lb bc, 2, 12
	; call DFSStaticize

	

	
	
	ld a, 4 ;ld a, 3
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld [wLastMenuItem], a
	ld [wCurrentMenuItem], a
	ld a, $ff
	ld [wMenuWatchedKeys], a
	ld a, 7
	ld [wMaxMenuItem], a
	ld a, "@"
	ld [wStringBuffer], a
	xor a
	ld hl, wNamingScreenSubmitName
	ld [hli], a
	ld [hli], a
	ld [wAnimCounter], a
	call PrintAlphabet
.selectReturnPoint
	call GBPalNormal
.ABStartReturnPoint
	ld a, [wNamingScreenSubmitName]
	and a
	jr nz, .submitNickname
	call PrintNicknameAndUnderscores
.dPadReturnPoint
	call PlaceMenuCursor
.inputLoop
	ld a, [wCurrentMenuItem]
	push af
	farcall AnimatePartyMon_ForceSpeed1
	pop af
	ld [wCurrentMenuItem], a
	call JoypadLowSensitivity
	ldh a, [hJoyPressed]
	and a
	jr z, .inputLoop
	ld hl, .namingScreenButtonFunctions
.checkForPressedButton
	sla a
	jr c, .foundPressedButton
	inc hl
	inc hl
	inc hl
	inc hl
	jr .checkForPressedButton
.foundPressedButton
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	jp hl

.submitNickname
	pop de
	ld hl, wStringBuffer
	ld bc, NAME_LENGTH
	call CopyData
	call GBPalWhiteOutWithDelay3
	;CHS_FIX p43
	call ResetAlphabet
	coord hl, 1, $D ;
	ld b, 4 ;
	ld c, 18 ;
	call ClearScreenArea
	ldh a, [hUILayoutFlags]
	res 1, a
	ldh [hUILayoutFlags],a
	call ClearScreen
	call ClearSprites
	call RunDefaultPaletteCommand
	call GBPalNormal
	xor a
	ld [wAnimCounter], a
	ld hl, wd730
	res 6, [hl]
	ld a, [wIsInBattle]
	and a
	jp z, LoadTextBoxTilePatterns
	jpfar LoadHudTilePatterns

.namingScreenButtonFunctions
	dw .dPadReturnPoint
	dw .pressedDown
	dw .dPadReturnPoint
	dw .pressedUp
	dw .dPadReturnPoint
	dw .pressedLeft
	dw .dPadReturnPoint
	dw .pressedRight
	dw .ABStartReturnPoint
	dw .pressedStart
	dw .selectReturnPoint
	dw .pressedSelect
	dw .ABStartReturnPoint
	dw .pressedB
	dw .ABStartReturnPoint
	dw .pressedA

.pressedA_changedCase
	pop de
	ld de, .selectReturnPoint
	push de
.pressedSelect
	ld a, [wIMEAlphabetCase]
	; xor $1
	; ld [wIMEAlphabetCase], a
	call ChangeCharacterSet
	ret

.pressedStart
	ld a, 1
	ld [wNamingScreenSubmitName], a
	ret

.pressedA
	ld a, [wCurrentMenuItem]
	cp $3 ;cp $5 ; "ED" row
	jr nz, .didNotPressED
	ld a, [wTopMenuItemX]
	cp $11 ; "ED" column
	jr z, .pressedStart
.didNotPressED
	ld a, [wCurrentMenuItem]
	cp $5 ;cp $6 ; case switch row
	jr nz, .didNotPressCaseSwtich
	ld a, [wTopMenuItemX]
	cp $1 ; case switch column
	jr z, .pressedA_changedCase
	cp 11
	jp z, PressedChangePageUP
	cp 15
	jp z, PressedChangePageDOWN
.didNotPressCaseSwtich
	ld hl, wMenuCursorLocation
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hl]
	ld [wNamingScreenLetter], a

	ld hl, wStringBuffer
	call CalcStringLengthAtHL

	; cp "ﾞ"
	; ld de, Dakutens
	; jr z, .dakutensAndHandakutens
	; cp "ﾟ"
	; ld de, Handakutens
	; jr z, .dakutensAndHandakutens
	ld a, [wIMEAlphabetCase]
	cp 0
	jr nz, .notPinyinMode
	ld a, [wCurrentMenuItem]
	cp 7
	jr nc, .notPinyinMode
	ld hl, wIMEPinyin
	call CalcStringLengthAtHL
	ld a, c
	cp $6
	jr .checkNameLength
.notPinyinMode
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, .checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp $7 ; max length of player/rival names
	jr .checkNameLength
.checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp $a ; max length of pokemon nicknames
.checkNameLength
	jr c, .addLetter
	ret

; .dakutensAndHandakutens
; 	push hl
; 	call DakutensAndHandakutens
; 	pop hl
; 	ret nc
; 	dec hl
.addLetter
	call AddPinyinLetter
	; ld a, [wNamingScreenLetter]
	; ld [hli], a
	; ld [hl], "@"
	; ld a, SFX_PRESS_AB
	; call PlaySound
	ret
.pressedB
	call RemoveCharacter
	ret
.pressedRight
	; ld a, [wCurrentMenuItem]
	; cp $6
	; ret z ; can't scroll right on bottom row
	ld a, [wTopMenuItemX]
	inc a
	inc a


	push af
	ld a, [wCurrentMenuItem]
	cp 5
	jr nz, .notLine5R
	pop af
	add 4
	jp .notLine5R2
.notLine5R
	pop af
.notLine5R2
	push af
	ld a, [wCurrentMenuItem]
	cp 7
	jr c, .noExtraTileR
	pop af
	inc a
	cp $12 ; max
	jp nc, .wrapToFirstColumn
	jr .done
.noExtraTileR
	pop af
	cp $12 ; max
	jp nc, .wrapToFirstColumn
	jr .done
.wrapToFirstColumn
	ld a, $1
	jr .done
.pressedLeft
	; ld a, [wCurrentMenuItem]
	; cp $6
	; ret z ; can't scroll right on bottom row
	ld a, [wTopMenuItemX]
	dec a
	jp z, .wrapToLastColumn
	dec a

	push af
	ld a, [wCurrentMenuItem]
	cp 5
	jr nz, .notLine5L
	pop af
	sub 4
	jr .done
.notLine5L
	pop af

	push af
	ld a, [wCurrentMenuItem]
	cp 7
	jr c, .noExtraTileL
	pop af
	dec a
	jr .done
.noExtraTileL
	pop af
	jr .done
.wrapToLastColumn
	ld a, [wCurrentMenuItem]
	cp 7
	ld a, $11 ; max
	jr c, .first5Rows
	ld a, $10 ; max
.first5Rows
	jr .done
.pressedUp
	ld a, [wCurrentMenuItem]
	cp 4
	jr c, .skipReducingExtra
	dec a
.skipReducingExtra
	dec a
	ld [wCurrentMenuItem], a
	cp 5
	ld a, [wTopMenuItemX]
	jr z, .done
	ld a, [wCurrentMenuItem]
	and a
	ret nz
	ld a, $1 ;ld a, $6 ; wrap to bottom row
	ld [wCurrentMenuItem], a
	ld a, [wTopMenuItemX]
	jr .done
.pressedDown
	ld a, [wCurrentMenuItem]
	cp 3
	jr c, .skipAddingExtra
	inc a
.skipAddingExtra
	inc a
	cp 10 ;cp $7
	jr c, .keepAdding
	dec a
	dec a
.keepAdding
	ld [wCurrentMenuItem], a ;ld a, $1
	ld a, [wTopMenuItemX];ld a, $1
.done
	call HandleLine7
	call HandleLine5
	ld a, [wTempTopMenuItemX]
	ld [wTopMenuItemX], a
	jp EraseMenuCursor

HandleLine7:
	push af
	ld a, [wCurrentMenuItem]
	cp 7
	jr nz, .nochange
	ld a, [wTempTopMenuItemX]
	cp 11
	jr z, .up
	cp 15
	jr z, .down
	pop af
	jr .done
.up
	pop af
	ld a, 10
	jr .done
.down
	pop af
	ld a, 16
.done
	ld [wTempTopMenuItemX], a
	ret
.nochange
	pop af
	ret



HandleLine5:
	ld [wTempTopMenuItemX], a 
	ld a, [wCurrentMenuItem]
	cp 5
	ret nz
	ld a, [wTempTopMenuItemX]
	cp 7
	jr c, .leftMost
	cp 15
	jr c, .mid
	ld a, 15
	jr .done
.leftMost
	ld a, 1
	jr .done
.mid
	ld a, 11
.done
	ld [wTempTopMenuItemX], a
	ret


LoadEDTile:
	ld de, ED_Tile
	ld hl, vFont tile $70
	ld bc, (ED_TileEnd - ED_Tile) / $8
	; to fix the graphical bug on poor emulators
	;lb bc, BANK(ED_Tile), (ED_TileEnd - ED_Tile) / $8
	jp CopyVideoDataDouble
 
ED_Tile:
	INCBIN "gfx/font/ED.1bpp"
ED_TileEnd:

UpdateInputMethodText:
	hlcoord 2, 9
	push hl
	ld hl, InputPointerTable
	ld a, [wIMEAlphabetCase]
	add a
	ld b, 0 
	ld c, a
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop hl
	call PlaceString
	ret

PrintAlphabet:
	xor a
	ldh [hAutoBGTransferEnabled], a
	ldh a, [hUILayoutFlags]
	set 1, a
	ldh [hUILayoutFlags],a
	ld hl, AlphaPointerTable
	ld a, [wIMEAlphabetCase]
	add a
	ld b, 0 
	ld c, a
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	hlcoord 2,5 ;ld hl, $C406
	ld bc, $0309 ;3行9列
.newLine
	push bc
.singleLine
	ld a, [de]
	ld [hli], a
	inc hl
	inc de
	dec c
	jr nz, .singleLine
	ld bc,$0002
	add hl, bc
	pop bc
	dec b
	jr nz, .newLine
	; ld bc, $0014
	; add hl, bc
	; ld a, $A0 ;XX
	; ld [wIMEAddr], a
	; ld a, $8A ;XX
	; ld [wIMEAddr], a

	call UpdateInputMethodText

	ld hl,$C460 ;XXXX
	ld de, InputChangePage
	; ld a,$40
	; ld [wIMEAddr],a
	; ld a,$8F
	; ld [wIMEAddr + 1],a
	call PlaceString

	ld hl,$C4E2 ;XXXX
	inc de
	; ld a,$60
	; ld [wIMEAddr],a
	; ld a,$8E
	; ld [wIMEAddr + 1],a
	call PlaceString
; 	ld a, [wIMEAlphabetCase]
; 	cp 2
; 	jr z, .lowercase
; 	cp 3
; 	jr z, .puntucation
; 	jr .finish
; .lowercase
; 	ld de, LowerCaseAlphabetL1
; 	hlcoord 2,5
; 	call PlaceString
; 	ld de, LowerCaseAlphabetL2
; 	hlcoord 2,6
; 	call PlaceString
; 	ld de, LowerCaseAlphabetL3
; 	hlcoord 2,7
; 	call PlaceString
; 	jr .finish
; .puntucation
; 	ld de, PunctuationAlphabetL1
; 	hlcoord 2,5
; 	call PlaceString
; 	ld de, PunctuationAlphabetL2
; 	hlcoord 2,6
; 	call PlaceString
; 	ld de, PunctuationAlphabetL3
; 	hlcoord 2,7
; 	call PlaceString
; 	jr .finish
; .finish
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	jp Delay3


; LowerCaseAlphabetL1:
; 	db "a b c d e f g h i@"
; LowerCaseAlphabetL2:
; 	db "j k l m n o p q r@"
; LowerCaseAlphabetL3:
; 	db "s t u v w x y z <ED>@"

	
; PunctuationAlphabetL1:
; 	db "× ( ) : ; [ ] <PK> <MN>@"
; PunctuationAlphabetL2:
; 	db "- ? ! ♂ ♀ / <DOT> ,  @"
; PunctuationAlphabetL3:
; 	db "                <ED>@"


; 	ld a, [wIMEAlphabetCase]
; 	and a
; 	ld de, LowerCaseAlphabet
; 	jr nz, .lowercase
; 	ld de, UpperCaseAlphabet
; .lowercase
; 	hlcoord 2, 5
; 	lb bc, 5, 9 ; 5 rows, 9 columns
; .outerLoop
; 	push bc
; .innerLoop
; 	ld a, [de]
; 	ld [hli], a
; 	inc hl
; 	inc de
; 	dec c
; 	jr nz, .innerLoop
; 	ld bc, SCREEN_WIDTH + 2
; 	add hl, bc
; 	pop bc
; 	dec b
; 	jr nz, .outerLoop
; 	call PlaceString
; 	ld a, $1
; 	ldh [hAutoBGTransferEnabled], a
; 	jp Delay3

INCLUDE "data/text/alphabets.asm"

PrintNicknameAndUnderscores:
	ld hl, wStringBuffer
	call CalcStringLengthAtHL
	ld a, c
	ld [wNamingScreenNameLength], a
	hlcoord 10, 2
	lb bc, 1, 10
	call ClearScreenArea
	hlcoord 10, 2
	ld de, wStringBuffer
	call PlaceString
	call DisplayPinyinLetter
	hlcoord 10, 3
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, .pokemon1
	ld b, 7 ; player or rival max name length
	jr .playerOrRival1
.pokemon1
	ld b, 10 ; pokemon max name length
.playerOrRival1
	ld a, $76 ; underscore tile id
.placeUnderscoreLoop
	ld [hli], a
	dec b
	jr nz, .placeUnderscoreLoop
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	ld a, [wNamingScreenNameLength]
	jr nc, .pokemon2
	cp 7 ; player or rival max name length
	jr .playerOrRival2
.pokemon2
	cp 10 ; pokemon max name length
.playerOrRival2
	jr nz, .emptySpacesRemaining
	; when all spaces are filled, force the cursor onto the ED tile
	call EraseMenuCursor
	; ld a, $11 ; "ED" x coord
	; ld [wTopMenuItemX], a
	; ld a, $3 ;ld a, $5 ; "ED" y coord
	; ld [wCurrentMenuItem], a
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	ld a, 9 ; keep the last underscore raised
	jr nc, .pokemon3
	ld a, 6 ; keep the last underscore raised
.pokemon3
.emptySpacesRemaining
	ld c, a
	ld b, $0
	hlcoord 10, 3
	add hl, bc
	ld [hl], $77 ; raised underscore tile id
	ret

; DakutensAndHandakutens:
; 	push de
; 	call CalcStringLength
; 	dec hl
; 	ld a, [hl]
; 	pop hl
; 	ld de, $2
; 	call IsInArray
; 	ret nc
; 	inc hl
; 	ld a, [hl]
; 	ld [wNamingScreenLetter], a
; 	ret

; INCLUDE "data/text/dakutens.asm"
; calculates the length of the string at wStringBuffer and stores it in c
CalcStringLengthAtHL:
	ld c, $0
.loop
	ld a, [hl]
	cp "@"
	ret z
	inc hl
	inc c
	jr .loop

; calculates the length of the string at wStringBuffer and stores it in c
; CalcStringLength:
; 	ld hl, wStringBuffer
; 	ld c, $0
; .loop
; 	ld a, [hl]
; 	cp "@"
; 	ret z
; 	inc hl
; 	inc c
; 	jr .loop

PrintNamingText:
	hlcoord 0, 1
	ld a, [wNamingScreenType]
	ld de, YourTextString
	and a
	jr z, .notNickname
	ld de, RivalsTextString
	dec a
	jr z, .notNickname
	ld a, [wcf91]
	ld [wMonPartySpriteSpecies], a
	push af
	farcall WriteMonPartySpriteOAMBySpecies
	pop af
	ld [wd11e], a
	call GetMonName
	ld a, [wENGNameMark]
	cp 1
	hlcoord 3, 1
	jr nz, .notENG
	hlcoord 3, 0
.notENG
	call PlaceString
	; ld hl, $1
	; add hl, bc
	; ld [hl], "の" ; leftover from Japanese version; blank tile $c9 in English
	hlcoord 1, 3
	ld de, NicknameTextString
	jr .placeString
.notNickname
	call PlaceString
	ld l, c
	ld h, b
	ld de, NameTextString
.placeString
	jp PlaceString

YourTextString:
	db "YOUR @"

RivalsTextString:
	db "RIVAL's @"

NameTextString:
	db "NAME?@"

NicknameTextString:
	db "NICKNAME?@"

INCLUDE "engine/menus/naming_screen_chs.asm"