GAS=tms9900-as
LD=tms9900-ld
CC=tms9900-gcc
LIBTI99?=/home/matthew/dev/ti99/libti99

ELF2CART=elf2cart

FNAME=exptest

LDFLAGS=\
  --section-start .text=6000 --section-start .data=8320

OBJECT_LIST=\
  header.o\
  crt0.o\
  main.o

all: $(FNAME).bin 

$(FNAME).bin: $(FNAME).elf
	$(ELF2CART) $(FNAME).elf $(FNAME).bin

$(FNAME).elf: $(OBJECT_LIST)
	$(LD) $(OBJECT_LIST) $(LDFLAGS) -L$(LIBTI99) -lti99 -o $(FNAME).elf -Map=mapfile

.phony clean:
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.i
	rm -f *.s
	rm -f mapfile

%.o: %.asm
	$(GAS) $< -o $@

%.o: %.c
	$(CC) -c $< -std=c99 -O1 --save-temp -I$(LIBTI99) -o $@

