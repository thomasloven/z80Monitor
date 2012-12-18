.area _DATA (REL, CON)

LCDPos:
	call LCDwait
	ld a, #0xC0
	out (#0x00), a
	ret

LCDwait:
	in a, (#0x00)
	bit 7, a
	jr nz, LCDwait
	ret

LCDCommandBytes:
	; HL - address of first byte
	; b - number of bytes
	ld c, #0x00
LCBloop:
	call LCDwait
	outi
	jr nz, LCBloop
	ret

LCDPrintString:
	; Print null terminated string to LCD
	; HL - address of first byte
	; Clobbers: a, b
	ld c, #0x01
LPSloop:
	call LCDwait
	outi
	xor a
	cp (HL)
	jr nz, LPSloop
	ret

LCDPrintHex:
	; Prints the byte in a
	; Does not preserve a!
	rrca
	rrca
	rrca
	rrca
	ld b, a
	call LCDWait
	ld a, b
	and #0x0F
	or #0x30
	out (#0x01),a
	call LCDWait
	ld a, b
	rrca
	rrca
	rrca
	rrca
	and #0x0F
	or #0x30
	out (#0x01),a
	ret
