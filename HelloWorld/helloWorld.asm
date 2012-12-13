.area _DATA (ABS)
.org 0x00

main:
	ld hl, #setup
	ld b, #message-setup
	ld c, #0x00
loop:
	call #testFlag
	outi
	jp nz, loop
	ld hl, #message
	ld b, #end-message
	ld c, #0x01
loop2:
	call testFlag
	outi
	jp nz, loop2
	halt

testFlag:
	in a, (#0x00)
	bit 7, a
	jp nz, testFlag
	ret


setup:
	.db 0x0F
	.db 0x02
message:
	.ascii "Hello, world!"
end:
