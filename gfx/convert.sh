#!/bin/sh
set -eu

bpp2png=../tools/bpp2png
test -f "$bpp2png" || make -C ../tools bpp2png

dump() {
    bank="$(printf %d "$1")"
    addr="$(printf %d "$2")"
    size="$(printf %d "$3")"
    skip="$(($bank * 0x4000 + $addr % 0x4000))"
    dd if=../baserom.gbc bs=1 skip="$skip" count="$size" 2> /dev/null
}

conv() {
    dest="$1"; shift
    "$bpp2png" "$@" "$dest" "${dest%.*}.png"
}

set -x

dump 0x11 0x4e88 0x0f80 > action_menu.orig.2bpp
conv action_menu.orig.2bpp -w 32

dump 0x11 0x5e10 0x18a0 > system_messages.orig.2bpp
conv system_messages.orig.2bpp -w 64
