#!/bin/sh

urxvtd -f -q -o
keychain --inherit any-once id_dsa&
xset r rate 200 70 +fp ~/.fonts b off
LD_BIND_NOW=true kdeinit4&

wm=${1:-awesome}
echo "Running $wm" 1>&2

case $wm in
*)
	exec $wm
	;;
esac

#xsetroot -solid gray10
feh --bg-center ~/.wallpaper

display=`echo $DISPLAY | sed 's/\(.*\)\..*$/\1/'`
DISPLAY=$display.1 feh --bg-center ~/.wallpaper2&
