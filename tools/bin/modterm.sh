#!/usr/bin/env bash
# set title
printf '\e]0;'$1'\007'
# modify terminal size
printf '\e[8;'$2';'$3't'
# modify terminal location
printf '\e[3;'$4';'$5't'

# modify terminal colors
# $8 not working properly --> default = 0 changes everything
# printf '\e['$6'm\e['$7'm\e['$8'm\e[2J\e[1;1H'
printf '\e['$6'm\e['$7'm\e[2J\e[1;1H'

# $5 = Foreground:
# 30 Black
# 31 Red
# 32 Green
# 33 Yellow
# 34 Blue
# 35 Magenta
# 36 Cyan
# 37 White
#
# $6 = Background:
# 40 Black
# 41 Red
# 42 Green
# 43 Yellow
# 44 Blue
# 45 Magenta
# 46 Cyan
# 47 White
#
# $7 character attributes
# 0  -> Normal.
# 1  -> Bold.
# 2  -> Faint, decreased intensity (ISO 6429).
# 3  -> Italicized (ISO 6429).
# 4  -> Underlined.
# 5  -> Blink (appears as Bold).
# 7  -> Inverse.
# 8  -> Invisible, i.e., hidden (VT300).
# 9  -> Crossed-out characters (ISO 6429).