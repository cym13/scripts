#!/bin/bash

# v - alsa quick volume control


volume=$( amixer get Master |
    sed -n '/Mono/s/^[^0-9]\+\([0-9]\+\) .*$/\1/p')
current_volume=$(cat ~/.current_volume)

setMaster () {
    amixer sset Master "$@" > /dev/null
}

if [ $volume -ne 0 ] ; then
    echo $volume > ~/.current_volume
fi

if [ $# -eq 0 ]; then
    echo ${volume}
    exit
elif [ $1 = '-m' ]; then
    desired='100-'
elif [ $1 = '-u' ]; then
    setMaster '100-'
    desired="${current_volume}+"
elif [ $1 = '-t' ]; then
    if [ $volume -eq 0 ]; then
        setMaster '100-'
        desired="${current_volume}+"
    else
        desired='100-'
    fi
elif [ $1 = '-' ]; then
    setMaster '100-'
    desired=$(( volume - $2 ))
elif [ $1 = '+' ]; then
    setMaster '100-'
    desired=$(( volume + $2 ))
elif [ $1 = '-h' ]; then
    echo "usage: v [-h] [-m] [-u] [-t] [- vol] [+ vol] [vol]"
    echo ""
    echo "Manage alsamixer volume."
    echo ""
    echo "positional arguments:"
    echo "  vol        integer number"
    echo ""
    echo "optional arguments:"
    echo "  -h         show this help message and exit"
    echo "  +          bring volume up by vol"
    echo "  -          bring volume down by vol"
    echo "  -m         mute"
    echo "  -t         toggle volume"
    echo "  -u         restablish previous volume"
    echo "  no arg     set volume to vol"
    exit
else
    desired=$1
fi

setMaster $desired
