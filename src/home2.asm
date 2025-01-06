DEF rLCDC_DEFAULT EQU %11100011
Init_home2::
	xor a
	ld [rIF], a
	ld [rIE], a
	ld [rSCX], a
	ld [rSCY], a
	ld [rSB], a
	ld [rSC], a
	ld [rWX], a
	ld [rWY], a
	ld [rTMA], a
	ld [rTAC], a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a

	ld a, rLCDC_ENABLE_MASK
	ld [rLCDC], a
	call DisableLCD

	ld sp, wStack

	ld hl, $c000 ; start of WRAM
	ld bc, $2000 ; size of WRAM
.loop
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop

	call ClearVram

	ld hl, $ff80
	ld bc, $fffe - $ff80
	call FillMemory


	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
	; ld hl, sDFSUsed
	; ld bc, sHallOfFame - sDFSUsed
	; call FillMemory
	ld hl, sDFSFreeEng
	ld bc, $C000 - sDFSFreeEng
	call FillMemory
	ld [MBC1SRamEnable], a

	call ClearSprites

	call WriteDMACodeToHRAM_home2

	xor a
	ld [hTileAnimations], a
	ld [rSTAT], a
	ld [hSCX], a
	ld [hSCY], a
	ld [rIF], a
	ld [wc0f3], a
	ld [wc0f4], a
	ld a, 1 << VBLANK + 1 << TIMER + 1 << SERIAL
	ld [rIE], a

	ld a, 144 ; move the window off-screen
	ld [hWY], a
	ld [rWY], a
	ld a, 7
	ld [rWX], a

	ld a, CONNECTION_NOT_ESTABLISHED
	ld [hSerialConnectionStatus], a

	ld h, vBGMap0 / $100
	call ClearBgMap
	ld h, vBGMap1 / $100
	call ClearBgMap

	ld a, rLCDC_DEFAULT
	ld [rLCDC], a
	ld a, 16
	ld [hSoftReset], a
	jp home2_ret


WriteDMACodeToHRAM_home2:
; Since no other memory is available during OAM DMA,
; DMARoutine is copied to HRAM and executed there.
	ld c, $ff80 % $100
	ld b, DMARoutineEnd_home2 - DMARoutine_home2
	ld hl, DMARoutine_home2
.copy
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .copy
	ret

DMARoutine_home2:
	; initiate DMA
	;DMA Fix
	ld a, wShadowOAM / $100
	; ldh a, [wShadowOAM / $100]
	ldh [rDMA], a

	; wait for DMA to finish
	ld a, $28
.wait
	dec a
	jr nz, .wait
	ret
DMARoutineEnd_home2:

; TrackPlayTime_home2:
; 	call CountDownIgnoreInputBitReset_home2
; 	ld hl, wd47a
; 	bit 0, [hl]
; 	jr nz, .maxIGT
; 	ld a,[wd732]
; 	bit 0,a
; 	ret z
; 	ld a, [wPlayTimeMaxed]
; 	and a
; 	ret nz
; 	ld a, [wPlayTimeFrames]
; 	inc a
; 	ld [wPlayTimeFrames], a
; 	cp 60
; 	ret nz
; 	xor a
; 	ld [wPlayTimeFrames], a
; 	ld a, [wPlayTimeSeconds]
; 	inc a
; 	ld [wPlayTimeSeconds], a
; 	cp 60
; 	ret nz
; 	xor a
; 	ld [wPlayTimeSeconds], a
; 	ld a, [wPlayTimeMinutes]
; 	inc a
; 	ld [wPlayTimeMinutes], a
; 	cp 60
; 	ret nz
; 	xor a
; 	ld [wPlayTimeMinutes], a
; 	ld a, [wPlayTimeHours]
; 	inc a
; 	ld [wPlayTimeHours], a
; 	cp $ff
; 	ret nz
; 	ld hl, wd47a
; 	set 0, [hl]
; .maxIGT
; 	ld a, 59
; 	ld [wPlayTimeSeconds], a
; 	ld [wPlayTimeMinutes], a
; 	ld a, $ff
; 	ld [wPlayTimeHours], a
; 	ld [wPlayTimeMaxed], a
; 	ret

CountDownIgnoreInputBitReset_home2:
	ld a, [wIgnoreInputCounter]
	and a
	jr nz, .asm_1f5e
	ld a, $ff
	jr .asm_1f5f
.asm_1f5e
	dec a
.asm_1f5f
	ld [wIgnoreInputCounter], a
	and a
	ret nz
	ld a, [wd730]
	res 1, a
	res 2, a
	bit 5, a
	res 5, a
	ld [wd730], a
	ret z
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ret
