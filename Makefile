
all: atari.hex

%.o: %.asm
	gpasm -c $<

%.hex: %.o
	gplink --map -s /usr/share/gputils/lkr/16f716_g.lkr -o $@ $<

.PHONY: clean

clean:
	rm *.hex *.lst *.cod
