#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Usage: v [-h] [-m] [-u] [-c] [-t] [-i] [-d] [-p] [VOLUME]

Manage your sound cards using ponymix

Arguments:
  VOLUME    integer number, if used with no option sets the volume to VOLUME

Options:
  -h    show this help message and exit
  -i    increase volume by vol
  -d    decrease volume by vol
  -m    mute
  -u    unmute
  -t    toggle volume
  -p    restablish previous volume
  -c    change sound card in use
"""

import sys
from sh import ponymix
from docopt import docopt


def cycle_card(card=None):
    # Get the number of available sound cards
    cards = int([ x.split("\t") for x in ponymix("list", "--short").splitlines()
                                if  x.startswith("sink") ][-1][1])
    current = int(default_card())

    if current < cards:
        new_card = current+1
    else:
        new_card = 0

    ponymix("-d", new_card, "set-default")
    return new_card


def default_card():
    return [ x.split("\t") for x in ponymix("defaults", "--short").splitlines()
                           if  x.startswith("sink") ][0][1]


def current_volume():
    return str(ponymix("get-volume"))


def update_volume(vol, *, volume_cache="/tmp/volume_cache"):
    open(volume_cache, 'w').write(current_volume())
    return ponymix("set-volume", vol)


def previous_volume(*, volume_cache="/tmp/volume_cache"):
    try:
        return open(volume_cache, "r").read()
    except:
        return current_volume()


def main():
    args = docopt(__doc__)

    if args["-i"]:
        ponymix("increase", args["VOLUME"])

    elif args["-d"]:
        print(args["VOLUME"])
        ponymix("decrease", args["VOLUME"])

    elif args["-m"]:
        ponymix("mute")

    elif args["-u"]:
        ponymix("unmute")

    elif args["-t"]:
        ponymix("toggle")

    elif args["-p"]:
        update_volume(previous_volume())

    elif args["-c"]:
        cycle_card()

    elif args["VOLUME"]:
        update_volume(args["VOLUME"])

    else:
        print(current_volume())


if __name__ == "__main__":
    main()
