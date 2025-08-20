DEF DEFAULT_PAGE EQU 1
DEF DEFAULT_PAGE_PUN EQU 7

; ld hl, address1     ; Load the first memory address into register HL
; ld de, address2     ; Load the second memory address into register DE
;-> z: Found, z NotFound
;-> hl = lastPointedCharacter
;-> b: tmp Var
; CompareHLBytesWithDE:

;     push de
;     ld c, 7           ; Load the number of bytes to compare into register BC

; .compare_loop
;     ld a, [de]         ; Load the byte at the address stored in DE into register A
;     cp [hl]      ; Compare the byte at the address stored in HL with the value in A

;     jr nz, .not_equal   ; If they are not equal, jump to "not_equal"
;     inc hl             ; Increment HL to point to the next byte
;     inc de             ; Increment DE to point to the next byte
;     dec c             ; Decrement the byte counter
;     jr nz, .compare_loop; If not all bytes compared yet, repeat the loop
;     ; If the loop completes without jumping to "not_equal," it means all bytes are equal
;     ; Add your code here for the case when the bytes are equal
;     ld a, 1
;     cp 1
;     pop de
;     ret
; .not_equal
;     inc hl
;     dec c
;     jr nz, .not_equal
; ; Add your code here for the case when the bytes are not equal
;     ld a, 1
;     cp 0
;     pop de
;     ret

CompareHLBytesWithDE:

    push de
    ld c, 7           ; Load the number of bytes to compare into register BC

.compare_loop
    ld a, [de]         ; Load the byte at the address stored in DE into register A
	cp "@"
	jr z, .done
    cp [hl]      ; Compare the byte at the address stored in HL with the value in A

    jr nz, .not_equal   ; If they are not equal, jump to "not_equal"
    inc hl             ; Increment HL to point to the next byte
    inc de             ; Increment DE to point to the next byte
    dec c             ; Decrement the byte counter
    jr nz, .compare_loop; If not all bytes compared yet, repeat the loop
    ; If the loop completes without jumping to "not_equal," it means all bytes are equal
    ; Add your code here for the case when the bytes are equal
.done
	inc hl
    dec c
    jr nz, .done
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
; GetStrCodeAddress:
; .loop
;     ld [wIMETmpVar], a
;     call CompareHLBytesWithDE
;     push hl
;     jr z, .found
;     ld a, [wIMETmpVar]
;     dec a
;     jr z, .notFound
;     pop hl
;     ld bc, 3
;     add hl, bc
;     jr .loop
; .found
;     ld a, [hli]
; 	ld e, a
;     ld a, [hli]
; 	ld d, a
;     ld a, [hl]
;     pop hl
;     ret
; .notFound
;     pop hl
;     ld de,IMEBlank
;     ld a, DEFAULT_PAGE
;     ret

GetStrCodeAddress:
.loop
	ld a, [hl]
	cp "@"
	jr z, .notFound
	; ld [wIMETmpVar], a
	call CompareHLBytesWithDE
	push hl
	jr z, .found
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
	; pop hl
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

PrintPageNumbers:
	ld a, [wIMEMaxPage]
	cp 0
	jr nz, .continue
	hlcoord 9,8
	ld a, $7F
	ld [hli], a
	ld [hli], a
	ld [hli], a
.continue
	ld a, [wIMECurrentPage]
	hlcoord 9,8
	add "0"
	ld [hl], a

	hlcoord $A,8
	ld a, $F3
	ld [hl], a

	ld a, [wIMEMaxPage]
	hlcoord $B,8
	add "0"
	ld [hl], a
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

ModifyBufferWithReprintPage:
	ld a, 1
	ld [wIMECurrentPage], a
	ld [wIMEMaxPage], a
	call PrintPageNumbers
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

ResetAlphabet:
	ld a, 0
	ld [wIMECurrentPage], a
	ld [wIMEAlphabetCase], a
	call ResetPinyinBuffer2
	ld hl, wIMEBuffer
	ld a, $50
	ld [hl], a
	call ModifyBuffer
	ret

ResetPinyinBuffer2:
	ld hl, wIMEPinyin
	ld c, 7
.loop
	ld a, "@"
	ld [hli], a
	dec c
	jr nz, .loop
	ret


DisplayPinyinOptions:
    hlcoord 1, 10
	lb bc, 4, 18
	call ClearScreenArea
    call ModifyBuffer
	call PrintPageNumbers
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
    

INCLUDE "dfs/IMEPinTable.asm"