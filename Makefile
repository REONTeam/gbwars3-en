name := GBWARS3

RGBASMFLAGS := -p 0xff
RGBLINKFLAGS := -p 0xff
RGBFIXFLAGS := -O -v -p 0xff

dir_build := build

objects := \
	main.o \
	symbols.o \
	source/unit.o \
	source/news.o \
	source/editor.o \
	source/maps.o \
	source/suspend.o \
	source/beginner.o \
	source/map_menu.o \
	source/main_menu.o \
	source/name_screen.o \
	source/unit_status.o

.PHONY: all
all: $(name).gbc

.PHONY: clean
clean:
	rm -f $(objects) $(objects:.o=.d)
	rm -f $(name).gbc $(name).sym

$(name).gbc: $(objects) | baserom.gbc
	rgblink -O baserom.gbc -n $(@:.gbc=.sym) $(RGBLINKFLAGS) -o $@ $^
	rgbfix $(RGBFIXFLAGS) $@

%.o: %.asm
	rgbasm -MP -M $*.d $(RGBASMFLAGS) -o $@ $<

baserom.gbc:
	@echo "Missing baserom.gbc!" >&2; false

-include $(objects:.o=.d)
