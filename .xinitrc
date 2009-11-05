#!/bin/sh

display=`echo $DISPLAY | sed 's/\(.*\)\..*$/\1/'`
export RXVT_SOCKET="$HOME/.rxvt-unicode.$display"

urxvtd -f -q -o
keychain --inherit any-once id_dsa&
xset r rate 200 70 +fp ~/.fonts b off
LD_BIND_NOW=true kdeinit4&

#xsetroot -solid gray10
DISPLAY=$display.0 awsetbg -F ~/.wallpaper& 2>/dev/null
DISPLAY=$display.1 awsetbg -F ~/.wallpaper2& 2>/dev/null

wm=${1:-awesome}
echo "Running $wm" 1>&2

case $wm in
*)
	exec $wm
	;;
esac
