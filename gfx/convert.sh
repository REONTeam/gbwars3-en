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

dump 0x0c 0x76f1 0x440 > days_menu.orig.2bpp
conv days_menu.orig.2bpp -w 128

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

dump 0x14 0x6401 0x160 > file_select_general1.orig.2bpp
conv file_select_general1.orig.2bpp -w 176

dump 0x14 0x65b1 0x540 > file_select_modes.orig.2bpp
conv file_select_modes.orig.2bpp -w 128

dump 0x14 0x6b41 0x1c0 > file_select_medals.orig.2bpp
conv file_select_medals.orig.2bpp -w 96

dump 0x14 0x73e1 0x3c0 > file_select_ranks.orig.2bpp
conv file_select_ranks.orig.2bpp -w 48

dump 0x15 0x4513 0x380 > config.orig.2bpp
conv config.orig.2bpp -w 112

dump 0x15 0x76f2 0x250 > vs_menu_type.orig.2bpp
conv vs_menu_type.orig.2bpp -w 64

dump 0x18 0x7ab8 0x3c0 > unit_status.orig.2bpp
conv unit_status.orig.2bpp -w 96

dump 0x19 0x720c 0x6e0 > mobile_menu.orig.2bpp
conv mobile_menu.orig.2bpp -w 80

dump 0x22 0x64d4 0x1000 > charmap_news.orig.2bpp
conv charmap_news.orig.2bpp -w 128

dump 0x27 0x65e3 0x210 > results.orig.2bpp
conv results.orig.2bpp -w 96

dump 0x27 0x7577 0x3e0 > file_select_general2.orig.2bpp
conv file_select_general2.orig.2bpp -w 176
