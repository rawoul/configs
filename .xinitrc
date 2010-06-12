#!/bin/sh

display=`echo $DISPLAY | sed 's/\(.*\)\..*$/\1/'`
export RXVT_SOCKET="$HOME/.rxvt-unicode.$display"

#xsetroot -solid gray10
DISPLAY=$display.0 feh --bg-scale ~/.wallpaper 2>/dev/null &
DISPLAY=$display.1 feh --bg-scale ~/.wallpaper2 2>/dev/null &

urxvtd -f -q -o
keychain --inherit any-once id_dsa
xset r rate 200 70 +fp ~/.fonts b off
LD_BIND_NOW=true kdeinit4&

wm=${1:-awesome}
echo "Running $wm" 1>&2

case $wm in
*)
	exec $wm
	;;
esac
