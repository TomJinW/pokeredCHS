SaveLearnToTiles: ;
	ld bc, -SCREEN_WIDTH ;
	add hl, bc ;
	lb bc, 2,6 ;
	ld a, $60 ;
	call DFSStaticize ;
	ret ;

InitLearnMark:
	ld a, 0
	ld [wPartyIndex], a
	ld a, 0
	ld [wCanLearnMark], a
	ret 

DisplayLearnText:
	ld bc, 0 + 11 ;ld bc, 20 + 9 ; down 1 row and right 9 columns
	push hl
	add hl, bc
	call PlaceString
	pop hl
	ret

DisplayLearnTextWithSave:
	ld bc, 0 + 11 ;ld bc, 20 + 9 ; down 1 row and right 9 columns
	push hl
	add hl, bc
	call PlaceString
	call SaveLearnToTiles
	pop hl
	ret

HandleDFS:
	ld a, [wPartyIndex]
	cp 1
	jr nz, .last5
	; first 1 pokemon
	call DisplayLearnText
	ld a, [wIfDexSeen]
	ld [wCanLearnMark], a
	ret
.last5
	ld a, [wCanLearnMark]
	ld b, a
	ld a, [wIfDexSeen]
	xor b
	jr z, .doNothing
	call DisplayLearnTextWithSave
	ret
.doNothing
	call DisplayLearnText
	ret

DrawPartyMenu_::
	xor a
	ldh [hAutoBGTransferEnabled], a
	call ClearScreen
	call UpdateSprites
	farcall LoadMonPartySpriteGfxWithLCDDisabled ; load pokemon icon graphics
RedrawPartyMenu_::
	ld a, [wPartyMenuTypeOrMessageID]
	cp SWAP_MONS_PARTY_MENU
	jp z, .printMessage
	call ErasePartyMenuCursors
	call InitLearnMark
	farcall InitPartyMenuBlkPacket
	hlcoord 3, 1 ;hlcoord 3, 0
	ld de, wPartySpecies
	xor a
	ld c, a
	ldh [hPartyMonIndex], a
	ld [wWhichPartyMenuHPBar], a
	ld b, a ; DFSStaticize First Char
.loop
	ld a, [wPartyIndex]
	add 1
	ld [wPartyIndex], a 
	ld a, [de]
	cp $FF ; reached the terminator?
	jp z, .afterDrawingMonEntries
	push bc
	push de
	push hl
	ld a, c
	push hl
	ld hl, wPartyMonNicks
	call GetPartyMonName


	ld a, 15 | (0 << 7)
	ld [wDummy], a
	callfar FixStrLength_Gen1
	pop hl
	call IncreaseDFSStack
	push hl
	push de
	dec hl
	dec hl
	ld de, .FullSpaceText
	call PlaceString
	ld [hl], " "
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld [hl], " "
	pop de

	pop hl
	call PlaceString ; print the pokemon's name
	call DecreaseDFSStack
	farcall WriteMonPartySpriteOAMByPartyIndex ; place the appropriate pokemon icon
	ldh a, [hPartyMonIndex]
	ld [wWhichPokemon], a
	inc a
	ldh [hPartyMonIndex], a
	call LoadMonData
	pop hl
	push hl
	ld a, [wMenuItemToSwap]
	and a ; is the player swapping pokemon positions?
	jr z, .skipUnfilledRightArrow
; if the player is swapping pokemon positions
	dec a
	ld b, a
	ld a, [wWhichPokemon]
	cp b ; is the player swapping the current pokemon in the list?
	jr nz, .skipUnfilledRightArrow
; the player is swapping the current pokemon in the list
	dec hl
	dec hl
	dec hl
	ld a, "▷" ; unfilled right arrow menu cursor
	ld [hli], a ; place the cursor
	inc hl
	inc hl
.skipUnfilledRightArrow
	ld a, [wPartyMenuTypeOrMessageID] ; menu type
	cp TMHM_PARTY_MENU
	jr z, .teachMoveMenu
	cp EVO_STONE_PARTY_MENU
	jr z, .evolutionStoneMenu
	push hl
	ld bc , -SCREEN_WIDTH + 7 ; ld bc, 14 ; 14 columns to the right
	add hl, bc
	ld de, wLoadedMonStatus
	call PrintStatusCondition_PartyMenu ; call PrintStatusCondition
	pop hl
	push hl
	ld bc, 10 ;ld bc, SCREEN_WIDTH + 1 ; down 1 row and right 1 column
	; ldh a, [hUILayoutFlags]
	; set 0, a
	; ldh [hUILayoutFlags], a
	add hl, bc
	predef DrawHP2 ; draw HP bar and prints current / max HP
	; ldh a, [hUILayoutFlags]
	; res 0, a
	; ldh [hUILayoutFlags], a
	call SetPartyMenuHPBarColor ; color the HP bar (on SGB)
	pop hl
	jr .printLevel
.teachMoveMenu
	push hl
	predef CanLearnTM ; check if the pokemon can learn the move
	pop hl
	ld de, .ableToLearnMoveText
	ld a, 1
	ld [wIfDexSeen], a
	ld a, c
	and a
	jr nz, .placeMoveLearnabilityString
	ld de, .notAbleToLearnMoveText
	ld a, 0
	ld [wIfDexSeen], a
.placeMoveLearnabilityString
	call HandleDFS

.printLevel
	ld bc, 10 ; move 10 columns to the right
	ld bc, 7
	add hl, bc
	call PrintLevel
	ld hl, sp+5
	ld a, [hl] ; DFSStaticize Char
	pop hl
	push hl
	ld bc, -SCREEN_WIDTH - 1
	add hl, bc
	lb bc, 2, 8
	call DFSStaticize
	pop hl
	pop de
	inc de
	ld bc, 2 * 20
	add hl, bc
	pop bc
	inc c
	ld b, a
	jp .loop
.FullSpaceText
	db "　@"
.ableToLearnMoveText
	db "ABLE@"
.notAbleToLearnMoveText
	db "NOT ABLE@"
.evolutionStoneMenu
	push hl
	ld hl, EvosMovesPointerTable
	ld b, 0
	ld a, [wLoadedMonSpecies]
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld de, wEvosMoves
	ld a, BANK(EvosMovesPointerTable)
	ld bc, 2
	call FarCopyData
	ld hl, wEvosMoves
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wEvosMoves
	ld a, BANK(EvosMovesPointerTable)
	ld bc, wEvosMovesEnd - wEvosMoves
	call FarCopyData
	ld hl, wEvosMoves
	ld de, .notAbleToEvolveText
; loop through the pokemon's evolution entries
.checkEvolutionsLoop
	ld a, [hli]
	and a ; reached terminator?
	jr z, .placeEvolutionStoneString ; if so, place the "NOT ABLE" string
	inc hl
	inc hl
	cp EV_ITEM
	jr nz, .checkEvolutionsLoop
; if it's a stone evolution entry
	dec hl
	dec hl
	ld b, [hl]
	ld a, [wEvoStoneItemID] ; the stone the player used
	inc hl
	inc hl
	inc hl
	cp b ; does the player's stone match this evolution entry's stone?
	jr nz, .checkEvolutionsLoop
; if it does match
	ld de, .ableToEvolveText
.placeEvolutionStoneString
	ld bc, 11; ld bc, 20 + 9 ; down 1 row and right 9 columns
	pop hl
	push hl
	add hl, bc
	call PlaceString
	pop hl
	jp .printLevel ;jr .printLevel
.ableToEvolveText
	db "ABLE@"
.notAbleToEvolveText
	db "NOT ABLE@"
.afterDrawingMonEntries
	ld b, SET_PAL_PARTY_MENU
	call RunPaletteCommand
.printMessage
	ld hl, wd730
	ld a, [hl]
	push af
	push hl
	set 6, [hl] ; turn off letter printing delay
	ld a, [wPartyMenuTypeOrMessageID] ; message ID
	cp FIRST_PARTY_MENU_TEXT_ID
	jr nc, .printItemUseMessage
	add a
	ld hl, PartyMenuMessagePointers
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
.done
	pop hl
	pop af
	ld [hl], a
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	jp GBPalNormal
.printItemUseMessage
	and $0F
	ld hl, PartyMenuItemUseMessagePointers
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wUsedItemOnWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	call PrintText
	jr .done

PartyMenuItemUseMessagePointers:
	dw AntidoteText
	dw BurnHealText
	dw IceHealText
	dw AwakeningText
	dw ParlyzHealText
	dw PotionText
	dw FullHealText
	dw ReviveText
	dw RareCandyText

PartyMenuMessagePointers:
	dw PartyMenuNormalText
	dw PartyMenuItemUseText
	dw PartyMenuBattleText
	dw PartyMenuUseTMText
	dw PartyMenuSwapMonText
	dw PartyMenuItemUseText

PartyMenuNormalText:
	text_far _PartyMenuNormalText
	text_end

PartyMenuItemUseText:
	text_far _PartyMenuItemUseText
	text_end

PartyMenuBattleText:
	text_far _PartyMenuBattleText
	text_end

PartyMenuUseTMText:
	text_far _PartyMenuUseTMText
	text_end

PartyMenuSwapMonText:
	text_far _PartyMenuSwapMonText
	text_end

PotionText:
	text_far _PotionText
	text_end

AntidoteText:
	text_far _AntidoteText
	text_end

ParlyzHealText:
	text_far _ParlyzHealText
	text_end

BurnHealText:
	text_far _BurnHealText
	text_end

IceHealText:
	text_far _IceHealText
	text_end

AwakeningText:
	text_far _AwakeningText
	text_end

FullHealText:
	text_far _FullHealText
	text_end

ReviveText:
	text_far _ReviveText
	text_end

RareCandyText:
	text_far _RareCandyText
	sound_get_item_1 ; probably supposed to play SFX_LEVEL_UP but the wrong music bank is loaded
	text_promptbutton
	text_end

PrintStatusCondition_PartyMenu:
	push de
	dec de
	dec de ; de = address of current HP
	ld a, [de]
	ld b, a
	dec de
	ld a, [de]
	or b ; is the pokemon's HP zero?
	pop de
	jp nz, PrintStatusConditionNotFainted
; if the pokemon's HP is 0, print "FNT"
	ld de, .FNT
	call PlaceString
	and a
	ret

.FNT
	db $C0, $C1, $50 ; 濒死

SetPartyMenuHPBarColor:
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld c, a
	ld b, 0
	add hl, bc
	call GetShortHealthBarColor ;call GetHealthBarColor
	ld b, SET_PAL_PARTY_MENU_HP_BARS
	call RunPaletteCommand
	ld hl, wWhichPartyMenuHPBar
	inc [hl]
	ret

GetShortHealthBarColor::
	; Return at hl the palette of
	; an HP bar e pixels long.
	ld a, e
	cp 18
	ld d, 0 ; green
	jr nc, .gotColor
	cp 7
	inc d ; yellow
	jr nc, .gotColor
	inc d ; red
.gotColor
	ld [hl], d
	ret
	