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

	call spiPrepare

cmd0:
	ld d, #6
	ld hl, #spi_cmd0
	call spiCommand
	dec a
	jr nz, cmd0
	call LCDPrintHex
	
cmd1:
	ld d, #6
	ld hl, #spi_cmd1
	call spiCommand
	push af
	pop af
	and a
	jr nz, cmd1
	call LCDPrintHex
	halt


s_lcd_setup:
	.db 0x0F, 0x01, 0x38
s_loading_msg:
	.asciz "Loading"

spi_cmd0:
	.db 0x40, 0x00, 0x00, 0x00, 0x00, 0x95
spi_cmd1:
	.db 0x41, 0x00, 0x00, 0x00, 0x00, 0xFF

