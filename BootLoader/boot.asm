.area _DATA (ABS)

main:
	ld SP, #(0x7FFF)
	ld hl, #s_lcd_setup
	ld b, #0x3
	call LCDCommandBytes
	ld hl, #s_loading_msg
	call LCDPrintString
	;call LCDPos
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
	ld hl, #0x1000
	call LCDPos
	call sdReadBlock
	halt

sdReadBlock:
	push hl
	ld d, #6
	ld hl, #sd_cmd_read
	call spiCommand
	pop hl
SRBLoop:
	cp #0xFE
	jr z, SRBReadData
	call spiReadByte
	jr SRBLoop
SRBReadData:
	push hl
	ld hl, #s_data_start
	call LCDPrintString
	pop hl
	ld b, #0x0F
SRBReadData2:
	call spiReadByte
	ld (HL), a
	inc HL
	call spiReadByte
	ld (HL), a
	inc HL
	djnz SRBReadData2
	ld hl, #s_data_end
	call LCDPrintString
	ret




s_lcd_setup:
	.db 0x0F, 0x01, 0x38
s_loading_msg:
	.asciz "Loading"
s_data_start:
	.asciz "Start"
s_data_end:
	.asciz "End"

spi_cmd0:
	.db 0x40, 0x00, 0x00, 0x00, 0x00, 0x95
spi_cmd1:
	.db 0x41, 0x00, 0x00, 0x00, 0x00, 0xFF
sd_cmd_read:
	.db 0x51, 0x00, 0x00, 0x00, 0x00, 0xFF

