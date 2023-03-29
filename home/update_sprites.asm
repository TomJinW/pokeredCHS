UpdateSprites::
	ld a, [wUpdateSpritesEnabled]
	dec a
	ret nz

	; PKMNRB_Fix 01 
	; OAM updates can be interrupted by V-Blank
	; ld hl, hSkipOAMUpdates ;
	; set 0, [hl] ;

	homecall _UpdateSprites
	; ld hl, hSkipOAMUpdates ;
	; res 0, [hl] ;
	ret
