TARGET = hello
START = 0x100
SOURCES = $(patsubst %.asm,%.rel,$(shell find . -name "*.asm"))

CC = sdcc # brew install sdcc
AS = sdasz80 # brew install sdcc
LD = sdcc
BG = srec_cat # brew install srecord


ASFLAGS = -gloaxsff
LDFLAGS = -mz80 --no-std-crt0 --out-fmt-ihx --data-loc 0x0000

.default: $(TARGET).bin

all: $(TARGET).bin

print: $(TARGET).bin
	xxd $(TARGET).bin > $(TARGET).hex
	cat $(TARGET).hex

$(TARGET).bin: $(TARGET).ihx
	$(BG) $(TARGET).ihx -intel -O $(TARGET).bin -binary
#$(BG) $(TARGET).ihx -intel -offset -$(START) -o $(TARGET).bin -binary

$(TARGET).ihx: $(SOURCES)
	$(CC) $(LDFLAGS) $(SOURCES) -o $(TARGET).ihx
	
%.rel: %.asm
	$(AS) $(ASFLAGS) $<

clean:
	-rm -f *.{lst,rel,sym,ihx,lnk,map,mem,noi,rst} 2> /dev/null
	rm $(TARGET).bin
