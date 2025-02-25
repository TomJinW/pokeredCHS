SECTION "Sprite Buffers", SRAM

sSpriteBuffer0:: ds SPRITEBUFFERSIZE
sSpriteBuffer1:: ds SPRITEBUFFERSIZE
sSpriteBuffer2:: ds SPRITEBUFFERSIZE

	ds $100

sHallOfFame:: ds HOF_TEAM * HOF_TEAM_CAPACITY

	ds $8
	
sDFSFreeEng:: ds 1
sDFSRaw4Font:: ds 6
sDFSCombineAddr:: ds 2
sDFSReserved:: ds 16 - 1 - 6 - 2
sDFS8Font::
	ds $20
	ds $70
sDFSUsed:: ; start at XX00
	ds $100 ; $36 really
sDFSCache:: ; start at XX00
	ds $36 * 4
sDFSCacheTileMapBackup::
	ds $36 * 4
sDFSCacheTileMapBackup2::
	ds $36 * 4
sDFSCacheMenuBuffer::
	ds $36 * 4
sMenuBuffer::
	ds 6 * 6

SECTION "Save Data", SRAM
sENGNameMark::ds 1
	ds $597

sGameData::
sPlayerName::  ds NAME_LENGTH
sMainData::    ds wMainDataEnd - wMainDataStart
sSpriteData::  ds wSpriteDataEnd - wSpriteDataStart
sPartyData::   ds wPartyDataEnd - wPartyDataStart
sCurBoxData::  ds wBoxDataEnd - wBoxDataStart
sTileAnimations:: db
sGameDataEnd::
sMainDataCheckSum:: db


; The PC boxes will not fit into one SRAM bank,
; so they use multiple SECTIONs
DEF box_n = 0
MACRO boxes
	REPT \1
		DEF box_n += 1
	sBox{d:box_n}:: ds wBoxDataEnd - wBoxDataStart
	ENDR
ENDM

SECTION "Saved Boxes 1", SRAM

; sBox1 - sBox6
	boxes 6
sBank2AllBoxesChecksum:: db
sBank2IndividualBoxChecksums:: ds 6

SECTION "Saved Boxes 2", SRAM

; sBox7 - sBox12
	boxes 6
sBank3AllBoxesChecksum:: db
sBank3IndividualBoxChecksums:: ds 6

; All 12 boxes fit within 2 SRAM banks
	ASSERT box_n == NUM_BOXES, \
		"boxes: Expected {d:NUM_BOXES} total boxes, got {d:box_n}"
