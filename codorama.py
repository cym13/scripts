#!/bin/env python3

"""
Usage: codorama.py [-h] [-t n] [-d delay] DIR...

Argument:
    DIR     Directories containing the sources codes.

Options:
    -d, --delay delay     Sleep time in seconds. Default is 5.
    -t, --tabs  n         Number of spaces to replace tabs with.
    -h, --help            Print this help and exit.
"""

import os
import subprocess
import random
from time import sleep
from docopt import docopt


def get_file(directories, exts):
    for d in directories:
        process = subprocess.Popen(['find', d, '-type', 'f'],
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.PIPE)
        file_list = process.stdout.readlines()
        random.shuffle(file_list)
        for f in file_list:
            f = f[:-1].decode('utf-8')
            if f.split('.')[-1] in exts:
                yield f


def main():
    args = docopt(__doc__)
    exts = ['c', 'cpp', 'cc', 'h', 'hpp', 'py', 'rb', 'rkt', 'java', 'pl',
            'sh', 'lisp', 'scm', 'js' ]
    styles = ['blacknblue', 'candy', 'dante', 'darkness', 'dusk',
              'manxome', 'pablo', 'relaxedgreen', 'solarized-light']
    time = args['--delay'] or 5
    time = float(time)

    tabs = args['--tabs'] or 4
    tabs = str(tabs)

    try:
        while True:
            for s in styles:
                for f in get_file(args['DIR'], exts):
                    subprocess.call(['highlight', '-O', 'xterm256',
                                                  '-s', s,
                                                  '-t', tabs,
                                                  f])
                    sleep(time)

    except KeyboardInterrupt:
        os.sys.exit()


if __name__=="__main__":
    main()
