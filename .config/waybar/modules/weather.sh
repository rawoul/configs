#!/bin/bash

cachedir=~/.cache/weather
cachefile=last

if [ ! -d "$cachedir" ]; then
    mkdir -p "$cachedir"
fi

if [ ! -f "$cachedir/$cachefile" ]; then
    touch "$cachedir/$cachefile"
fi

cacheage=$(($(date +%s) - $(stat -c '%Y' "$cachedir/$cachefile")))
if [ $cacheage -gt 1740 ] || [ ! -s $cachedir/$cachefile ]; then
    data=$(curl -s https://fr.wttr.in?format=1 2>&1)
    echo "$data" > "$cachedir/$cachefile"
else
    data=$(cat $cachedir/$cachefile)
fi

echo "$data"
