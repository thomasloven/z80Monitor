.area _DATA (ABS)
.org 0x00

main:
	ld hl, #setup
	ld b, #message-setup
	ld c, #0x00
	otir
	ld hl, #message
	ld b, #end-message
	ld c, #0x01
	otir
	halt


setup:
	.db 0x20
	.db 0x1E
message:
	.asciz "Hello, world!"
end:
