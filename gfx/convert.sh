#!/bin/sh
set -eu

bpp2png=../tools/bpp2png
test -f "$bpp2png" || make -C ../tools bpp2png

set -x
"$bpp2png" -w 32 action_menu.orig.2bpp action_menu.orig.png
"$bpp2png" -w 64 system_messages.orig.2bpp system_messages.orig.png
