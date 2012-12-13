.area _DATA (ABS)

main:
	ld SP, #(0x7FFF)
	ld hl, #s_lcd_setup
	ld b, #0x3
	call LCDCommandBytes
	ld hl, #s_loading_msg
	call LCDPrintString
	call LCDPos
	call PIOSetup

	ld a, #0x13
	call LCDPrintHex

	halt



s_lcd_setup:
	.db 0x0F, 0x02, 0x38
s_loading_msg:
	.asciz "L"
s_init_msg:
	.asciz "I"
s_error_msg:
	.asciz "E!"
end:


