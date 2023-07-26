
; ModifyBuffer2:
;     ld hl, wIMEBuffer
;     ld c, 25
; .loop
;     ld a, [hl]
;     cp $50
;     jr z, .copyRest
;     inc hl
;     dec c
;     jr z, .done
;     jr .loop
; .done
;     ret
; .copyRest
;     ld a, $50
;     ld [hl], a
;     inc hl
;     dec c
;     jr z, .done
;     jr .copyRest

ChangeCharacterSet:
	push af
	hlcoord 1, 10
	lb bc, 4, 18
	call ClearScreenArea
	ld hl, wIMEBuffer
	ld a, $50
	ld [hl], a
	farcall ModifyBufferWithReprintPage
	call DisplayPinyinLetter
	
	pop af

	add 1 ; 在 0：拼音 1:符号切换
	cp 2
	jr c, .noRounding
	ld a, 0
.noRounding
	ld [wIMEAlphabetCase], a
	cp 1
	jr nz, .notPunctuation
	farcall UpdateCharacterOptions
	ld a, 1
	ld [wIMECurrentPage], a
	jr .done
.notPunctuation
	ld a, 0
	ld [wIMECurrentPage], a
.done
	call UpdateInputMethodText
	call ResetPinyinBuffer
	

	ret

ResetAlphabet:
	ld a, 0
	ld [wIMECurrentPage], a
	ld [wIMEAlphabetCase], a
	call ResetPinyinBuffer
	ret

ConvertTopMenuXPosition:
	ld a,[wTopMenuItemX]
	add 1
	ld b, 0
.division_loop
	cp 3
	jr c, .division_end
	sub 3
	inc b
	jr .division_loop
.division_end
	ld a, b
	; dec a
	add a
	ld b, a
	ret

; ConvertTopMenuXPosition:
; 	ld a,[wTopMenuItemX]
; 	cp 1
; 	jr .one
; 	ret

AddPinyinLetter:
	ld a,[wCurrentMenuItem]
	cp 5
	jr nc, .AddDoubleCode
.addSingleCode
	ld a, [wNamingScreenLetter]
	ld [hli], a
	ld [hl], "@"
	ld a, SFX_PRESS_AB
	call PlaySound
	ld a, [wIMEAlphabetCase]
	cp 0
	jr z, .lookupTable
	ret
.lookupTable
	; push af
	; push bc
	; push de
	; push hl
	farcall LookupPinyinTable
	; pop af
	; pop bc
	; pop de
	; pop hl
	ret
.addSingleCodeNoPinyinTable
	ld a, [wNamingScreenLetter]
	ld [hli], a
	ld [hl], "@"
	ld a, SFX_PRESS_AB
	call PlaySound
	ret
.AddDoubleCode:
	ld d, h
	ld e, l
	ld a,[wCurrentMenuItem]
	sub 7
	sla a
	ld b, a
	sla a
	add b
	ld c, a
	call ConvertTopMenuXPosition
	ld a, c
	add b
	ld c, a
	ld b, 0
	ld hl, wIMEBuffer
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	cp $50
	jr z, .done
	cp $2F
	jr c, .chinese
	ld [wNamingScreenLetter], a
	ld h, d
	ld l, e
	jr AddPinyinLetter.addSingleCodeNoPinyinTable
.chinese
	ld c, a
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, .checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp $6 ; max length of player/rival names
	jr .checkNameLength
.checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp $9 ; max length of pokemon nicknames
.checkNameLength
	jr c, .addLetter
	ret
.addLetter
	ld h, d
	ld l, e
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], "@"
	call ResetPinyinBuffer
	ld a, SFX_PRESS_AB
	call PlaySound
.done
	ret

PressedChangePageUP:
	ld a, [wIMECurrentPage]
	cp 0
	ret z
	dec a
	ld [wIMECurrentPage], a
	jr nz, .dontWrap
	ld a,[wIMEMaxPage]
	ld [wIMECurrentPage], a
.dontWrap
	farcall UpdatePinyinOptions
	ret

PressedChangePageDOWN:
	ld a, [wIMECurrentPage]
	cp 0
	ret z
	inc a
	ld [wIMECurrentPage], a
	ld b, a
	ld a, [wIMEMaxPage]
	cp b
	jr nc, .dontWrap
	ld a, 1
	ld [wIMECurrentPage], a
.dontWrap
	farcall UpdatePinyinOptions
	ret

ResetPinyinBuffer:
	ld hl, wIMEPinyin
	ld c, 7
.loop
	ld a, "@"
	ld [hli], a
	dec c
	jr nz, .loop
	ret

DisplayPinyinLetter:
	hlcoord 5, 9
	lb bc, 1, 6
	call ClearScreenArea
	hlcoord 5, 9
	ld de, wIMEPinyin
	call PlaceString
	ret

DetectLastByte:
	ld hl, wStringBuffer
.loop
	ld a, [hl]
	cp $50
	jr z, .done
	cp $2F
	ld c, 0
	jr c, .doubleChar
	inc hl
	jr .loop
.doubleChar
	ld c, 1
	inc hl
	inc hl
	jr .loop
.done
	ld a, c
	cp 0
	ret

RemoveCharacter:
	ld a, [wIMEAlphabetCase]
	cp 0
	jr z, .Pinyin
.deleteActualName
	call DetectLastByte
	ld hl, wStringBuffer
	jr z, .deleteSingleChar
	call CalcStringLengthAtHL
	dec hl
	dec hl
	ld a, [hl]
	cp $2F
	ld hl, wStringBuffer
	jr c, .deleetDoubleCharater
.deleteSingleChar
	call CalcStringLengthAtHL
	dec hl
	ld [hl], "@"
	hlcoord $A, 1
	lb bc, 1, 10
	call ClearScreenArea
	ret
.deleetDoubleCharater
	call CalcStringLengthAtHL
	dec hl
	ld [hl], "@"
	dec hl
	ld [hl], "@"
	hlcoord $A, 1
	lb bc, 1, 10
	call ClearScreenArea
	ret
.Pinyin
	ld hl, wIMEPinyin
	call CalcStringLengthAtHL  
	ld a, c
	cp 0
	jr z, .deleteActualName
.deletePinyinName
	ld hl, wIMEPinyin
	call RemoveCharacter.deleteSingleChar
	farcall LookupPinyinTable
	ret

