name := GBWARS3

RGBASMFLAGS := -p 0xff
RGBLINKFLAGS := -p 0xff
RGBFIXFLAGS := -O -v -p 0xff

objects := \
	main.o \
	symbols.o \
	source/unit.o \
	source/news.o \
	source/map_editor.o \
	source/maps.o \
	source/suspend.o \
	source/beginner.o \
	source/map_menu.o \
	source/main_menu.o \
	source/name_screen.o \
	source/unit_status.o \
	source/descriptions.o \
	source/mobile.o \
	source/medals.o \
	source/config.o \
	source/ranks.o \
	source/battle_info.o \
	source/terrain.o

graphics := \
	gfx/charmap.2bpp \
	gfx/symbols.2bpp \
	gfx/units.2bpp \
	gfx/title_screen.2bpp \
	gfx/action_menu.2bpp \
	gfx/system_messages.2bpp \
	gfx/map_menu.2bpp \
	gfx/name_screen.2bpp \
	gfx/file_select_numbers.2bpp \
	gfx/file_select_general.2bpp \
	gfx/file_select_modes.2bpp \
	gfx/file_select_medals.2bpp \
	gfx/file_select_ranks.2bpp \
	gfx/config.2bpp \
	gfx/vs_menu_type.2bpp

gfx/system_messages.2bpp: RGBGFXFLAGS := --trim-end 6
gfx/units.2bpp: RGBGFXFLAGS := --trim-end 5
gfx/file_select_modes.2bpp: RGBGFXFLAGS := --trim-end 12
gfx/file_select_medals.2bpp: RGBGFXFLAGS := --trim-end 8
gfx/vs_menu_type.2bpp: RGBGFXFLAGS := --trim-end 3

.PHONY: all
all: $(name).gbc
	@test -f $(name).gbc.orig || cp $(name).gbc $(name).gbc.orig
	@diff $(name).gbc.orig $(name).gbc

.PHONY: clean
clean:
	rm -f $(objects) $(objects:.o=.d)
	rm -f $(graphics)
	rm -f $(name).gbc $(name).map $(name).sym

$(name).gbc: $(objects) | baserom.gbc
	rgblink -O baserom.gbc -m $(@:.gbc=.map) -n $(@:.gbc=.sym) $(RGBLINKFLAGS) -o $@ $^
	rgbfix $(RGBFIXFLAGS) $@

%.o: %.asm
	rgbasm -MP -M $*.d $(RGBASMFLAGS) -o $@ $<

$(objects): | $(graphics)

%.2bpp: %.png
	rgbgfx $(RGBGFXFLAGS) -o $@ $<

baserom.gbc:
	@echo "Missing baserom.gbc!" >&2; false

-include $(objects:.o=.d)
