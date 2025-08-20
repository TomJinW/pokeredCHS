CopyIMECharacters:
	ld a, [wIMEAddr]
	ld h, a
	ld a, [wIMEAddr + 1]
	ld l, a
	ld a,[wIMECurrentPage]
	ld de,wIMEBuffer
.loop
	dec a
	jr z, .done
	ld bc, 24
	add hl, bc
	jr .loop
.done
	ld bc, 25
	call CopyData
	ret

IMEBlank:
	db $50
IMEDefault:
	db $01,$01,$01,$E2,$01,$03,$01,$E4,$01,$02,$01,$D7,$01,$F5,$01,$0D,$01,$F0,$01,$F1,$01,$E5,$02,$19,$01,$04,$01,$25,$01,$0B,$01,$0A,$01,$0E,$01,$0F,$01,$10,$01,$11,$01,$DE,$01,$DF,$01,$21,$01,$23,$01,$12,$01,$13,$01,$17,$01,$18,$01,$19,$01,$1A,$01,$1B,$01,$1C,$01,$1D,$01,$1E,$01,$1F,$01,$20,$02,$18,$02,$1A,$02,$39,$02,$3B,$a0,$7F,$a1,$7F,$a2,$7F,$a3,$7F,$a4,$7F,$a5,$7F,$a6,$7F,$a7,$7F,$a8,$7F,$a9,$7F,$aa,$7F,$ab,$7F,$ac,$7F,$ad,$7F,$ae,$7F,$af,$7F,$b0,$7F,$b1,$7F,$b2,$7F,$b3,$7F,$b4,$7F,$b5,$7F,$b6,$7F,$b7,$7F,$b8,$7F,$b9,$7F,$f1,$7F,$9a,$7F,$9b,$7F,$9c,$7F,$9d,$7F,$9e,$7F,$9f,$7F,$e1,$7F,$e2,$7F,$e3,$7F,$e6,$7F,$e7,$7F,$ef,$7F,$f5,$7F,$f3,$7F,$f2,$7F,$f4,$7F,$7F,$7F,$50

INCLUDE "dfs/IMECharTable.asm"