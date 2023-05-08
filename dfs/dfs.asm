LoadScreenTilesFromBuffer2_Origin::
	call LoadScreenTilesFromBuffer2DisableBGTransfer_Origin
	ld a, 1
	ld [hAutoBGTransferEnabled], a
	ret

LoadScreenTilesFromBuffer2DisableBGTransfer_Origin::
	xor a
	ld [hAutoBGTransferEnabled], a
	ld hl, wTileMapBackup2
	coord de, 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp CopyData

SaveScreenTilesToBuffer1_Origin::
	hlcoord 0, 0
	ld de, wTileMapBackup
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp CopyData

LoadScreenTilesFromBuffer1_Origin::
	xor a
	ld [hAutoBGTransferEnabled], a
	ld hl, wTileMapBackup
	coord de, 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyData
	ld a, 1
	ld [hAutoBGTransferEnabled], a
	ret

_SaveScreenTilesToBuffer2::
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	ld hl, sDFSCache
	ld de, sDFSCacheTileMapBackup2
	ld bc, $36 * 4
	call CopyData
	xor a
	ld [MBC1SRamEnable], a
	hlcoord 0, 0
	ld de, wTileMapBackup2
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp CopyData

_LoadScreenTilesFromBuffer2DisableBGTransfer::
	xor a
	ld [hAutoBGTransferEnabled], a
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	; call dfsClearCacheLite
	hlcoord 0, 0
	ld de, wTileMapBackup2
	ld b, SCREEN_HEIGHT
.loop1
	ld c, SCREEN_WIDTH
.loop2
	ld a, [de]
	cp a, $EC
	jr nc, .normal
	cp a, $80
	jr c, .normal
	push bc
	push de
	push hl
	ld b, a
	and $7E
	ld d, 0
	ld e, a
	ld hl, sDFSCacheTileMapBackup2
	add hl, de
	add hl, de
	ld a, [hli]
	and a
	jr z, .eng
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	pop hl
	push hl
	call DoubleCodeMain
	pop hl
	pop de
	ld b, a
	ld a, [de]
	and $81
	or b
	jr .double_end
.eng
	inc hl
	bit 0, b
	jr z, .engisc1
	inc hl
	inc hl
.engisc1
	ld a, [hl]
	pop hl
	push hl
	call SingleCodeMain
	or $80
	pop hl
	pop de
.double_end
	pop bc
.normal
	ld [hli], a
	inc de
	dec c
	jr nz, .loop2
	dec b
	jr nz, .loop1
	xor a
	ld [MBC1SRamEnable], a
	ret

_SaveScreenTilesToBuffer1::
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	ld hl, sDFSCache
	ld de, sDFSCacheTileMapBackup
	ld bc, $36 * 4
	call CopyData
	xor a
	ld [MBC1SRamEnable], a
	hlcoord 0, 0
	ld de, wTileMapBackup
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp CopyData

_LoadScreenTilesFromBuffer1::
	xor a
	ld [hAutoBGTransferEnabled], a
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	; call dfsClearCacheLite
	hlcoord 0, 0
	ld de, wTileMapBackup
	ld b, SCREEN_HEIGHT
.loop1
	ld c, SCREEN_WIDTH
.loop2
	ld a, [de]
	cp a, $EC
	jr nc, .normal
	cp a, $80
	jr c, .normal
	push bc
	push de
	push hl
	ld b, a
	and $7E
	ld d, 0
	ld e, a
	ld hl, sDFSCacheTileMapBackup
	add hl, de
	add hl, de
	ld a, [hli]
	and a
	jr z, .eng
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	pop hl
	push hl
	call DoubleCodeMain
	pop hl
	pop de
	ld b, a
	ld a, [de]
	and $81
	or b
	jr .double_end
.eng
	inc hl
	bit 0, b
	jr z, .engisc1
	inc hl
	inc hl
.engisc1
	ld a, [hl]
	pop hl
	push hl
	call SingleCodeMain
	pop hl
	pop de
.double_end
	pop bc
.normal
	ld [hli], a
	inc de
	dec c
	jr nz, .loop2
	dec b
	jr nz, .loop1
	xor a
	ld [MBC1SRamEnable], a
	inc a; ld a, 1
	ld [hAutoBGTransferEnabled], a
	ret

dfsClearCache::
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	ld [wDFSCombineCode], a
	ld a, $FF
	ld [sDFSFreeEng], a
	ld hl, sDFSUsed
	ld b, $36
.loop1
	res 0, [hl]
	inc hl
	dec b
	jr nz, .loop1
	ld hl, sDFSCache
	ld b, $36
	ld de, 0004
	ld a, $FF
.loop2
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop2
	xor a
	ld [MBC1SRamEnable], a
	ret

_dfsUnion::
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	
	push de
	push hl
	ld b, h
	ld c, l

	ld hl, wDFSCode
	ld a, [hli]
	cp a, $EC
	jr nc, StaticSingleCode
	cp a, $80
	jr nc, SingleCode
	cp a, $2F
	jr nc, StaticSingleCode
	; ld a, [wDFSStack]
	; cp 2
	; jr c, .not_combine
	ld a, [wDFSCombineCode]
	and a
	jr z, .not_combine
	ld a, [sDFSCombineAddr]
	cp c
	jr nz, .not_combine
	ld a, [sDFSCombineAddr + 1]
	cp b
	jp z, CombineDoubleCode
.not_combine
	inc hl
	ld a, [hl]
	and a
	jr z, DoubleCode
	cp a, $14
	jp c, QuadrupleCode
	cp a, $2F
	jr nc, DoubleCode
	bit 3, a
	jp nz, QuadrupleCode
	jr DoubleCode
	
StaticSingleCode:
	pop hl
	; ld bc, wAttrmap - wTileMap
	; add hl, bc
	; res 3, [hl]
	; ld bc, wTileMap - wAttrmap
	; add hl, bc
	ld [hli], a
	call PrintLetterDelay
	pop de
	xor a
	ld [wDFSCombineCode], a
	ld [MBC1SRamEnable], a
	ret
	
SingleCode:
	call SingleCodeMain
	pop hl
	call SingleCodeDrawMap
	call PrintLetterDelay
	pop de
	xor a
	ld [wDFSCombineCode], a
	ld [MBC1SRamEnable], a
	ret
; SingleCode_Restore:
; 	push hl
; 	call SingleCodeMain
; 	pop hl
; 	call SingleCodeDrawMap_Restore
; 	ret
; SingleCode_TempTileMap:
; 	push hl
; 	call SingleCodeMain
; 	pop hl
; 	call SingleCodeDrawMap
; 	ret
	
DoubleCode:
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	push hl
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld c, [hl]
	ld de, $0000
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	pop de
	inc de
	; ld a, [wDFSStack]
	; cp 2
	; jr c, .not_combine
	ld a, [wDFSCode]
	ld [wDFSCombineCode], a
	ld a, [wDFSCode + 1]
	ld [wDFSCombineCode + 1], a
	ld a, l
	ld [sDFSCombineAddr], a
	ld a, h
	ld [sDFSCombineAddr + 1], a
.not_combine
	xor a
	ld [MBC1SRamEnable], a
	ret
; DoubleCode_Restore:
; 	push hl
; 	call DoubleCodeMain
; 	pop hl
; 	jp DoubleCodeDrawMap_Restore
; DoubleCode_TempTileMap:
; 	push hl
; 	call DoubleCodeMain
; 	pop hl
; 	jp DoubleCodeDrawMap_TempTileMap

CombineDoubleCode:
	ld hl, wDFSCombineCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld c, [hl]
	ld hl, wDFSCode
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call DoubleCodeMain
	pop hl
	dec hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	push hl
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, b
	set 7, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	pop de
	inc de
	xor a
	ld [wDFSCombineCode], a
	ld [MBC1SRamEnable], a
	ret

QuadrupleCode:
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	push hl
	ld hl, wDFSCode
	ld a, [hli]
	ld b, a
	set 7, b
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	push hl
	ld hl, wDFSCode + 2
	ld a, [hli]
	ld b, a
	ld d, a
	set 6, b
	set 7, d
	ld c, [hl]
	ld e, c
	call DoubleCodeMain
	pop hl
	call DoubleCodeDrawMap
	call PrintLetterDelay
	pop de
	inc de
	inc de
	inc de
	xor a
	ld [wDFSCombineCode], a
	ld [MBC1SRamEnable], a
	ret

SingleCodeMain:
	ld b, a
	call Find8FontCacheEng
	ret nc
	call FindFree8FontCacheEng
	jr nc, .hitfree
	call RecoverFree8FontCache
	call FindFree8FontCacheEng
.hitfree
	push af
	call Send8FontToSramEng
	pop af
	push af
	call GetVramAddr
	; ld b, $10
	; call SendSram8FontToVram
	call SendSram8FontToVram10b
	pop af
	ret
DoubleCodeMain:
	call Find8FontCache
	ret nc
	call FindFree8FontCache
	jr nc, .hitfree
	call RecoverFree8FontCache
	call FindFree8FontCache
.hitfree
	push af
	call Send8FontToSram
	pop af
	push af
	call GetVramAddr
	; ld b, $20
	; call SendSram8FontToVram
	call SendSram8FontToVram20b
	pop af
	ret

Find8FontCache:
; 	ld a, [wDFSV0Only]
; 	and %00000011
; 	jr z, .normal
; 	dec a
; 	jr z, .v0only
; 	ld hl, sDFSCache
; 	ld a, $40
; 	jr .loop
; .v0only
; 	ld hl, sDFSCache + $40 * 4
; 	ld a, $36 - $40
; 	jr .loop
.normal
	ld hl, sDFSCache
	ld a, $36
.loop
	push af
	ld a, [hli]
	cp b
	jr nz, .next1
	ld a, [hli]
	cp c
	jr nz, .next2
	ld a, [hli]
	cp d
	jr nz, .next3
	ld a, [hl]
	cp e
	jr nz, .next3
	pop hl
	ld a, $36
	sub h
	ld l, a
	; call DFSCache2DFSUsed
	; srl h
	; ccf
	; rr l
	; srl l
	ld h, HIGH(sDFSUsed)
	set 0, [hl]
	ld a, l
	rlca
	ret
.next1
	inc hl
.next2
	inc hl
.next3
	inc hl
	pop af
	dec a
	jr nz, .loop
	scf
	ret
Find8FontCacheEng:
; 	ld a, [wDFSV0Only]
; 	and %00000011
; 	jr z, .normal
; 	dec a
; 	jr z, .v0only
; 	ld hl, sDFSCache
; 	ld c, $40
; 	jr .loop
; .v0only
; 	ld hl, sDFSCache + $40 * 4
; 	ld c, $36 - $40
; 	jr .loop
; .normal
	ld hl, sDFSCache
	ld c, $36
.loop
	ld a, [hli]
	and a
	jr nz, .next1
	ld a, [hli]
	cp b
	jr z, .target
	ld a, [hli]
	and a
	jr nz, .next3
	ld a, [hl]
	cp b
	jr nz, .next3
.target
	; call DFSCache2DFSUsed
	srl h
	
	; CHS_Fix for Displaying English
	ASSERT HIGH(sDFSCache) & 1 == 0, "Error HIGH(sDFSCache) & 1 != 0"
	; if Error HIGH(sDFSCache) & 1 != 0, uncomment line below
	; ccf

	rr l
	push af
	srl l
	ld h, HIGH(sDFSUsed)
	set 0, [hl]
	sla l
	pop af
	ld a, 0
	adc a, l
	and a
	ret
.next1
	inc hl
	inc hl
.next3
	inc hl
	dec c
	jr nz, .loop
	scf
	ret
	
FindFree8FontCache:
; 	ld a, [wDFSV0Only]
; 	and %00000011
; 	jr z, .normal
; 	dec a
; 	jr z, .v0only
; 	ld hl, sDFSUsed
; 	ld a, $40
; 	jr .loop
; .v0only
; 	ld hl, sDFSUsed + $40
; 	ld a, $36 - $40
; 	jr .loop
; .normal
	ld hl, sDFSUsed
	ld a, $36
.loop
	bit 0, [hl]
	jr nz, .notfound
	set 0, [hl]
	push hl
	; call DFSUsed2DFSCache
	xor a
	sla l
	rla
	sla l
	rla
	add a, HIGH(sDFSCache)
	ld h, a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	pop hl
	ld a, l
	rlca
	ret
.notfound
	inc hl
	dec a
	jr nz, .loop
	scf
	ret
FindFree8FontCacheEng:
	; ld a, [wDFSV0Only]
	; and %00000011
	; ld l, a
	ld a, [sDFSFreeEng]
; 	jr z, .full
; 	dec l
; 	jr z, .v0only0
; 	cp a, $80
; 	jr c, .full
; 	ld a, $FF
; 	ld [sDFSFreeEng], a
; 	jr .full
; .v0only0
; 	cp a, $80
; 	jr nc, .full
; 	ld a, $FF
; 	ld [sDFSFreeEng], a
; .full
	inc a
	jr z, .regular
	push af
	; call DFSUsed2DFSCache
	ld l, a
	xor a
	sla l
	rla
	add a, HIGH(sDFSCache)
	ld h, a
	xor a
	ld [hli], a
	ld [hl], b
	ld hl, sDFSFreeEng
	ld [hl], $FF
	pop af
	and a
	ret
.regular
; 	ld a, [wDFSV0Only]
; 	and %00000011
; 	jr z, .normal
; 	dec a
; 	jr z, .v0only
; 	ld hl, sDFSUsed
; 	ld a, $40
; 	jr .loop
; .v0only
; 	ld hl, sDFSUsed + $40
; 	ld a, $36 - $40
; 	jr .loop
; .normal
	ld hl, sDFSUsed
	ld a, $36
.loop
	bit 0, [hl]
	jr nz, .notfound
	set 0, [hl]
	push hl
	; call DFSUsed2DFSCache
	xor a
	sla l
	rla
	sla l
	rla
	add a, HIGH(sDFSCache)
	ld h, a
	xor a
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], $FF
	pop hl
	sla l
	xor a
	ld a, l
	ld [sDFSFreeEng], a
	ret
.notfound
	inc hl
	dec a
	jr nz, .loop
	scf
	ret
	
RecoverFree8FontCache:
	push bc
	push de
	ld c, $36
	ld hl, sDFSUsed
.loop1
	res 0, [hl]
	inc hl
	dec c
	jr nz, .loop1

	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT + $0100
	ld de, wTileMap
	; ld hl, wAttrmap
.loop2
	ld a, [de]
	bit 7, a
	jr z, .next
.font
	and a, $7E
	rrca
; 	bit 3, [hl]
; 	jr nz, .setfree
; .vram0
; 	set 6, a
; .setfree
	; push hl
	ld h, HIGH(sDFSUsed)
	ld l, a
	set 0, [hl]
	; pop hl
.next
	; inc hl
	inc de
	dec c
	jr nz, .loop2
	dec b
	jr nz, .loop2
	ld a, [sDFSFreeEng]
	inc a
	jr z, .alreadyfree
	srl a
	ld h, HIGH(sDFSUsed)
	ld l, a
	bit 0, [hl]
	jr nz, .alreadyfree
	ld a, $FF
	ld [sDFSFreeEng], a
.alreadyfree
	pop de
	pop bc
	ret
	
Send8FontToSram:
	push de
	call Send4RawFontToSRAM
	call Send4RawFontTo8FontLeft
	pop bc
	ld a, b
	or c
	; jr z, .skip
	ret z
	call Send4RawFontToSRAM
	call Send4RawFontTo8FontRight
; .skip
	; jp SetFontStyle
	ret

;b  > TlieNo
Send8FontToSramEng:
	ld h, 0
	ld l, b
	res 7, l
rept 3
	add hl, hl
endr
	ld bc, FontGraphics
	add hl, bc
	ld a, BANK(FontGraphics)
	ld bc, 8
	ld de, sDFS8Font
	call FarCopyDataDouble
	; jp SetFontStyle
	ret

Send4RawFontToSRAM:
	ld a, b
	push af
	and a, $3F
	sla c
	rla
	ld b, 0
	ld d, b
	ld e, a
	ld hl, FontAB
rept 3
	add hl, de
endr
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de
	ld d, a
	pop af
	ld c, 6
	cp a, $40
	jr c, .c1
	cp a, $80
	jr c, .c2
	add hl, bc
.c2
	add hl, bc
.c1
	ld a, d
	ld de, sDFSRaw4Font
	jp FarCopyData2

MACRO fontab
rept _NARG
	dwb DFS_C_\1_L, BANK(DFS_C_\1_L)
	dwb DFS_C_\1_H, BANK(DFS_C_\1_H)
	shift
endr
ENDM

FontAB:
	fontab FF, 01, 02, 03, 04, 05, 06, 07, 08, 09, 0A, 0B, 0C, 0D, 0E, 0F
	fontab 10, 11, 12, 13, FF, FF, FF, FF, 18, 19, 1A, 1B, 1C, 1D, 1E, 1F
	fontab FF, FF, FF, FF, FF, FF, FF, FF, 28, 29, 2A, 2B, 2C, 2D, 2E, FF

Send4RawFontTo8FontLeft:
	ld hl, sDFS8Font
	ld de, sDFSRaw4Font
	ld b, 8
	xor a
.loop1
	ld [hli], a
	dec b
	jr nz, .loop1
	ld b, 6
.loop2
	ld a, [de]
	and $F0
	ld [hli], a
	ld [hli], a
	ld a, [de]
	swap a
	and $F0
	ld [hli], a
	ld [hli], a
	inc de
	dec b
	jr nz, .loop2
	ret
	
Send4RawFontTo8FontRight:
	ld hl, sDFS8Font + 8
	ld de, sDFSRaw4Font
	ld b, 6
.loop
	ld a, [de]
	swap a
	and $0F
	or [hl]
	ld [hli], a
	ld [hli], a
	ld a, [de]
	and $0F
	or [hl]
	ld [hli], a
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ret
	
; SetFontStyle:
; 	ld a, [wDFSFontSytle]
; 	and a ; 0
; 	ret z
; 	ld hl, sDFS8Font
; 	dec a ; 1
; 	jr nz, .OverworldSytle8Font
; .DexStyle8Font
; 	ld b, $20
; .dexloop
; 	ld a, [hl]
; 	cpl
; 	ld [hli], a
; 	dec b
; 	jr nz, .dexloop
; 	ret
; .OverworldSytle8Font
; 	ld b, $10
; 	ld a, $FF
; .owloop
; 	ld [hli], a
; 	inc hl
; 	dec b
; 	jr nz, .owloop
; 	ret
	
;a  > CacheNo
;hl < Tile Addr
GetVramAddr:
	swap a
	ld e, a
	and a, $0F
	ld d, a
	ld a, e
	and a, $F0
	ld e, a
	ld hl, $8800
	add hl, de
	ret

; hl > Tile Addr
; b > Bytes
SendSram8FontToVram:
	; ld hl, rSTAT
	ld de, sDFS8Font
	ld c, LOW(rSTAT)
	di
.loop
	; ldh a, [rLY]
	; cp a, $8c
	; jr nc, .loop
	ldh a, [c]
	and $2
	jr nz, .loop
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	reti

; hl > Tile Addr
; b > Bytes
SendSram8FontToVram10b:
	ld de, sDFS8Font
	ld c, LOW(rSTAT)
	di
rept $10
.loop\@
	ldh a, [c]
	and $2
	jr nz, .loop\@
	ld a, [de]
	ld [hli], a
	inc de
endr
	reti

; hl > Tile Addr
; b > Bytes
SendSram8FontToVram20b:
	ld de, sDFS8Font
	ld c, LOW(rSTAT)
	di
rept $20
.loop\@
	ldh a, [c]
	and $2
	jr nz, .loop\@
	ld a, [de]
	ld [hli], a
	inc de
endr
	reti

; ;hl > Tile Addr
; ;b  > Vram Bank
; ;c  > Tile - 1
; SendWram8FontToVram:
; 	ld a, HIGH(sDFS8Font)
; 	ld [rHDMA1], a
; 	ld a, LOW(sDFS8Font)
; 	ld [rHDMA2], a
; 	ld a, h
; 	ld [rHDMA3], a
; 	ld a, l
; 	ld [rHDMA4], a
; 	ld a, [rLCDC]
; 	bit 7, a
; 	jr nz, .wait1
; 	di
; 	ld a, b
; 	ld [rVBK], a
; 	ld a, c
; 	ld [rHDMA5], a
; 	xor a
; 	ld [rVBK], a
; 	reti
; .wait1
; 	ld a, [rLY]
; 	cp a, $8c
; 	jr nc, .wait1
; 	di
; 	ld a, b
; 	ld [rVBK], a
; 	set 7, c
; .wait2
; 	ld a, [rSTAT]
; 	and a, 3
; 	jr nz, .wait2
; .wait3
; 	ld a, [rSTAT]
; 	and a, 3
; 	jr z, .wait3
; 	ld a, c
; 	ld [rHDMA5], a
; .wait4
; 	ld a, [rHDMA5]
; 	cp a, $FF
; 	jr nz, .wait4
; 	xor a
; 	ld [rVBK], a
; 	reti
	
SingleCodeDrawMap:
; 	push af
; 	ld a, [wDFSV0Only]
; 	ld b, a
; 	pop af
; 	bit 2, b
; 	jr nz, .skipAttr
; 	ld bc, wAttrmap - wTileMap
; 	add hl, bc
; 	bit 7, a
; 	jr z, .isv1
; 	res 3, [hl]
; 	jr .setTile
; .isv1
; 	set 3, [hl]
; 	set 7, a
; .setTile
; 	ld bc, wTileMap - wAttrmap
; 	add hl, bc
; 	ld [hli], a
; 	ret
; .skipAttr
	set 7, a
	ld [hli], a
	ret
SingleCodeDrawMap_Restore:
; 	ld bc, wAttrmap - wTileMap
; 	add hl, bc
; 	bit 7, a
; 	jr z, .isv1
; 	ld [hl], $07
; 	jr .setTile
; .isv1
; 	ld [hl], $0F
; 	set 7, a
; .setTile
; 	ld bc, wTileMap - wAttrmap
; 	add hl, bc
	ld [hli], a
	ret

DoubleCodeDrawMap:
; 	push af
; 	ld a, [wDFSV0Only]
; 	ld b, a
; 	pop af
; 	bit 2, b
; 	jr nz, .skipAttr
; 	ld bc, wAttrmap - wTileMap - SCREEN_WIDTH
; 	add hl, bc
; 	bit 7, a
; 	jr z, .isv1
; 	res 3, [hl]
; 	ld bc, SCREEN_WIDTH
; 	add hl, bc
; 	res 3, [hl]
; 	jr .setTile
; .isv1
; 	set 3, [hl]
; 	ld bc, SCREEN_WIDTH
; 	add hl, bc
; 	set 3, [hl]
; 	set 7, a
; .setTile
; 	ld bc, wTileMap - wAttrmap - SCREEN_WIDTH
; 	add hl, bc
; 	ld [hl], a
; 	inc a
; 	ld bc, SCREEN_WIDTH
; 	add hl, bc
; 	ld [hli], a
; 	ret
; .skipAttr
	set 7, a
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld [hl], a
	inc a
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hli], a
	ret
; DoubleCodeDrawMap_Restore:
; 	ld bc, wAttrmap - wTileMap
; 	add hl, bc
; 	bit 7, a
; 	jr z, .isv1
; 	ld [hl], $07
; 	jr .setTile
; .isv1
; 	ld [hl], $0F
; 	set 7, a
; .setTile
; 	ld bc, wTileMap - wAttrmap
; 	add hl, bc
; 	ld [hl], a
; 	ld a, [wDFSCode + 2]
; 	bit 7, a
; 	jr z, .isc0
; 	inc [hl]
; .isc0
; 	inc hl
; 	ret
; DoubleCodeDrawMap_TempTileMap:
; 	ld bc, wAttrmap - wTileMap
; 	add hl, bc
; 	bit 7, a
; 	jr z, .isv1
; 	res 3, [hl]
; 	jr .setTile
; .isv1
; 	set 3, [hl]
; 	set 7, a
; .setTile
; 	ld bc, wTileMap - wAttrmap
; 	add hl, bc
; 	ld [hl], a
; 	ld a, [wDFSCode + 2]
; 	bit 7, a
; 	jr z, .isc0
; 	inc [hl]
; .isc0
; 	inc hl
; 	ret

MACRO dfs_alphabet_param
	ld hl, sDFSCache + ((\1 - $80) / 2) * 4
	ld de, sDFSUsed  + ((\1 - $80) / 2)
	lb bc, \1, (\2 / 2)
ENDM

DFSSetAlphabetCache:
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a

	dfs_alphabet_param $80, $40
	call .loop_used

	dfs_alphabet_param $E0, 12
	call .loop_used

	xor a
	ld [MBC1SRamEnable], a
	ret

.loop_used
	xor a
	ld [hli], a
	ld [hl], b
	inc hl
	inc b
	ld [hli], a
	ld [hl], b
	inc hl
	inc b
	inc a
	ld [de], a
	inc de
	dec c
	jr nz, .loop_used
	ret
	
; Gen2:
; >b : length (half tile)
; >c : start at left / right
; >de: straddr
; <de: straddr (same as input)
; <hl: new straddr end
; <[straddr] : fix legnth
; Gen1:
; >c bit0-6 : length (half tile)
; >c bit7   : start at left / right
; >de: straddr
; <de: straddr (same as input)
; <hl: new straddr end
; <[straddr] : fix legnth
FixStrLength_Gen1::
	ld a, c
	and $7F
	ld b, a
	rlc c

	inc b
	ld h, d
	ld l, e
.checkchar
; end of nick?
	ld a, [hli]
	cp "@" ; terminator
	ret z
	and a
	jr z, .singlechar
	cp $14
	jr c, .doublechar
	cp $2F
	jr nc, .singlechar
	bit 3, a
	jr nz, .doublechar
	
.singlechar
	bit 0, c
	jr z, .newsingle
	inc c
	dec b
	jr z, .done
.newsingle
rept 2
	dec b
	jr z, .done
endr
	jr .checkchar
	
.doublechar
	inc c
rept 3
	dec b
	jr z, .done
endr
	inc hl
	jr .checkchar
.done
	dec hl
	ld [hl], "@"
	ret

; Gen2:
; >de: straddr
; <b : length (tile)
; <c : last tile is half tile
; <de: straddr (same as input)
; <hl: new straddr end + 1
; Gen1:
; >de: straddr
; <d : length (tile)
; <e : last tile is half tile
; <hl: new straddr end + 1
GetStrLength_Gen1::
	ld h, d
	ld l, e
	ld de, 0
.checkchar
; end of nick?
	ld a, [hli]
	cp "@" ; terminator
	jr z, .done
	and a
	jr z, .singlechar
	cp $14
	jr c, .doublechar
	cp $2F
	jr nc, .singlechar
	bit 3, a
	jr nz, .doublechar
	
.singlechar
	bit 0, d
	jr z, .newsingle
	jr .leftsingle
.doublechar
	inc hl
.leftsingle
	inc d
.newsingle
	inc d
	inc d
	jr .checkchar

.done
	srl d
	ret nc
	rr e
	inc d
	ret
