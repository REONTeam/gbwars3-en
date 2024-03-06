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

dump 0x01 0x4118 0x1000 > charmap.orig.2bpp
conv charmap.orig.2bpp -w 128

dump 0x01 0x5120 0x140 > symbols.orig.2bpp
conv symbols.orig.2bpp -w 40

dump 0x10 0x51e8 0x1680 > title_screen.orig.2bpp
conv title_screen.orig.2bpp -w 160

dump 0x11 0x4e88 0x0f80 > action_menu.orig.2bpp
conv action_menu.orig.2bpp -w 32

dump 0x11 0x5e10 0x18a0 > system_messages.orig.2bpp
conv system_messages.orig.2bpp -w 64

dump 0x14 0x5708 0x260 > img_14_5708.orig.2bpp
conv img_14_5708.orig.2bpp -w 304
