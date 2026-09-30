; copies a string from de to wStringBuffer
CopyToStringBuffer::
	ld hl, wStringBuffer
	; fall through

; copies a string from de to hl
CopyString::
	ld a, [de]
	inc de
	ld [hli], a
	cp CHARVAL("@")
	jr nz, CopyString
	ret
