.area _DATA (REL, CON)


; A Control: 0x12
; A Data: 0x10
; B Control: 0x13
; B Data: 0x11

; SPI bit-bang
; CLK: bit 0
; MOSI: bit 1 output
; MISO: bit 2 input
; SS: bit 3

PIOSetup:
	ld c, #0x12 ; Command port A
	ld b, #0x03 ; Three bytes
	ld hl, #pio_setup_bytes
	otir ; Send command bytes

	ld a, #0xFE ; All high but clock which is low
	out (#0x10), a
	ret

pio_setup_bytes:
	.db 0xCF, 0x04, 0x07


spiPrepare: ; Send 80 clock pulses with SS high
ld b, #0x50
SPloop:
	ld a, #0xFF ; Clock high , SS high
	out (#0x10), a
	nop
	nop
	ld a, #0xFE ; Clock low, SS high
	out (#0x10), a
	djnz SPloop
	ret


spiCommand: ; Send D bytes from (HL) to the SPI bus
	ld a, #0xFF ; First, send FF to reset
	call spiWriteByte

SCloop1: ; Send data bytes
	ld a,(HL)
	call spiWriteByte
	inc hl
	dec d
	jr nz, SCloop1

SCloop2: ; Wait for reply that's not 0xFF
	call spiReadByte
	cp #0xFF
	jr z, SCloop2

	ld d, a ; Pull SS high when done
	ld a, #0xFF
	out (#0x10), a
	ld a, d
	ret

spiWriteByte: ; Write tye byte in A to the SPI bus
	push bc
	ld b, #0x08
SWBloop: ; One bit at a time
	rlca ; rotate MSB into carry
	push af
	jr nc, SWBzero ; If no carry, MSB was a zero

SWBone:
	ld a, #0xF6 ; Send a one
	jr SWBsend

SWBzero:
	ld a, #0xF4 ; Send a zero

SWBsend:
	call PIOsrec
	pop af
	djnz SWBloop ; Repeat for all eight bits
	pop bc
	ret
	

spiReadByte: ; Read one byte from the SPI bus into A
	push bc
	ld b, #0x08
	xor a ; Empty A
SRBloop:
	rlca ; Rotate A left (multiply by 2)
	ld c, a
	ld a, #0xF6 ; Send ones while receiving
	call PIOsrec

	bit 2, a
	ld a, c
	jr z, SRBzero ; If a zero was received...
	or #0x01 ; If a one was received

SRBzero:
	djnz SRBloop ; Repeat for all eight bits
	pop bc
	ret


PIOsrec: ; Send byte from A, receive byte into A
	push bc
	and a, #0xF6 ; Clock LOW, SS low
	out (#0x10), a ; Send data
	or a, #0x01 ; Clock HIGH
	out (#0x10), a ; Send clock pulse
	push af
	nop
	nop
	in a, (#0x10) ; Read data
	ld b, a
	pop af
	and a, #0xF6 ; Clock LOW, ss low
	out (#0x10), a ; Send end of clock
	ld a, b
	pop bc
	ret

