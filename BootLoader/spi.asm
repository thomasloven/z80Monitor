.area _DATA (REL, CON)

.define firstbyte /0xcf/

pio_setup_bytes:
	.db 0xCF, 0x80, 0x07
; A Control: 0x12
; A Data: 0x10
; B Control: 0x13
; B Data: 0x11
PIOSetup:
	ld c, #0x13
	ld b, #0x03
	ld hl, #pio_setup_bytes
	otir
	ret

; SPI bit-bang
; CLK: bit 1
; MOSI: bit 8
; MISO: bit 0
; SS: bit 3

spiCommand:
	; (HL) - commands
	; d - number of bytes
SCloop1:
	ld a,(HL)
	call spiWriteByte
	inc hl
	dec b
	jr nz, SCloop1
SCloop2:
	call spiReadByte
	cp #0xFF
	jr z, SCloop2
	ret

spiWriteByte:
	; Byte to write in a
	; clobbers b
	ld b, #0x08
SWBloop:
	push af
		and #0x80 
		call PIOsrec
		or #0x2 ; Set clock HIGH
		call PIOsrec
		and #0xFD ; Set clock LOW
	pop af
	rla
	dec b
	jr nz, SWBloop
	ret

spiReadByte:
	; Byte returned in a
	; clobbers b, c
	ld b, #0x08
	xor a
	ld c, a
SRBloop:
	xor a
	call PIOsrec
	or #0x2
	call PIOsrec
	and #0x01
	add c
	rla
	ld c, a
	dec b
	jr nz, SRBloop
	ld a, c
	ret

PIOsrec:
	out (#0x11), a
	in a, (#0x11)
	ret

