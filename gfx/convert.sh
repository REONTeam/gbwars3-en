#!/bin/sh
set -eu

baserom=../baserom.gbc
bpp2png=../tools/bpp2png
test -f "$bpp2png" || make -C ../tools bpp2png

dump() {
    echo dump "$@" >&2
    bank="$(printf %d "$1")"
    addr="$(printf %d "$2")"
    size="$(printf %d "$3")"
    skip="$(($bank * 0x4000 + $addr % 0x4000))"
    dd if="$baserom" bs=1 skip="$skip" count="$size" 2> /dev/null
}

conv() {
    echo conv "$@" >&2
    dest="$1"; shift
    "$bpp2png" "$@" "$dest" "${dest%.*}.png"
}

crgb() {
    echo crgb "$@" >&2
    dest="$1"; shift
    width="$(printf %d "$1")"; shift
    rgbgfx "$@" -o "$dest" -r $(($width / 8)) "${dest%.*}.png"
}

gen_tmap() {
    for x in $(seq 0 $(($(printf %d "$1") - 1))); do
        printf \\$(printf %o $x)
    done
}

dump 0x01 0x4118 0x1000 > charmap.orig.2bpp
conv charmap.orig.2bpp -w 128

dump 0x01 0x5120 0x140 > symbols.orig.2bpp
conv symbols.orig.2bpp -w 40

dump 0x01 0x5898 0xda0 > units.orig.2bpp
conv units.orig.2bpp -w 128

#gen_tmap 0x168 > title_screen.orig.tilemap
dump 0x10 0x5080 0x168 > title_screen.orig.attrmap
dump 0x10 0x51e8 0x1680 > title_screen.orig.2bpp
dump 0x10 0x6868 0x40 > title_screen.orig.pal
conv title_screen.orig.2bpp -w 160
#crgb title_screen.orig.2bpp 160 -a title_screen.orig.attrmap -p title_screen.orig.pal

dump 0x11 0x4e88 0x0f80 > action_menu.orig.2bpp
conv action_menu.orig.2bpp -w 32

dump 0x11 0x5e10 0x18a0 > system_messages.orig.2bpp
conv system_messages.orig.2bpp -w 64

dump 0x13 0x57cc 0x90 > map_menu.orig.2bpp
conv map_menu.orig.2bpp -w 72

dump 0x14 0x5708 0x260 > name_screen.orig.2bpp
conv name_screen.orig.2bpp -w 304

dump 0x14 0x6341 0xc0 > file_select_numbers.orig.2bpp
conv file_select_numbers.orig.2bpp -w 16

dump 0x14 0x6401 0x160 > file_select_general.orig.2bpp
conv file_select_general.orig.2bpp -w 176

dump 0x14 0x65b1 0x540 > file_select_modes.orig.2bpp
conv file_select_modes.orig.2bpp -w 128

dump 0x14 0x6b41 0x1c0 > file_select_medals.orig.2bpp
conv file_select_medals.orig.2bpp -w 96

