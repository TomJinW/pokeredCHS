; These are all the asm constants needed to make the blue_vc patch.

MACRO vc_const
	DEF x = \1
	PRINTLN "00:{04x:x} \1" ; same format as rgblink's .sym file
ENDM

MACRO vc_char
	DEF x = CHARVAL(\1)
	PRINTLN "00:{04x:x} \1" ; same format as rgblink's .sym file
ENDM

; [FPA 001 Begin]
	vc_char "M"
	vc_char "E"
	vc_char "G"
	vc_char "A"
	vc_char "P"
	vc_char "S"
	vc_char "L"
	vc_char "F"
	vc_char "X"
	vc_const MEGA_PUNCH

; [FPA 001 End]
	vc_const EXPLOSION

; [FPA 002 Begin]
	vc_char "U"
	vc_char "I"
	vc_const GUILLOTINE

; [FPA 002 End]
	vc_char "K"
	vc_const MEGA_KICK

; [FPA 004 Begin]
	vc_char "B"
	vc_char "Z"
	vc_const BLIZZARD

; [FPA 005 Begin]
	vc_const BUBBLEBEAM

; [FPA 005 End]
	vc_const HYPER_BEAM

; [FPA 006 Begin]
	vc_char "H"
	vc_char "Y"

; [FPA 007 Begin]
	vc_char "T"
	vc_char "N"
	vc_const THUNDERBOLT

; [FPA 008 Begin]
	vc_char "R"
	vc_const REFLECT

; [FPA 009 Begin]
	vc_const SELFDESTRUCT

; [FPA 010 Begin]
	vc_char "D"
	vc_const DREAM_EATER

; [FPA 011 Begin]
	vc_char "O"
	vc_const SPORE

; [FPA 012 Begin]
	vc_char "C"
	vc_const ROCK_SLIDE
