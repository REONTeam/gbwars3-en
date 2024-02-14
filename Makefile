name := GBWARS3

dir_build := build

objects := \
	main.o

.PHONY: all
all: $(name).gbc

.PHONY: clean
clean:
	rm -f $(objects) $(objects:.o=.d)
	rm -f $(name).gbc $(name).sym

$(name).gbc: $(objects) | baserom.gbc
	rgblink -O baserom.gbc -n $@.sym -o $@ $^
	rgbfix -O -v $@

%.o: %.asm
	rgbasm -MP -M $*.d -o $@ $<

baserom.gbc:
	@echo "Missing baserom.gbc!" >&2; false

-include $(objects:.o=.d)
