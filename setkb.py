#!/bin/env python3
import pyudev
import subprocess


context = pyudev.Context()
monitor = pyudev.Monitor.from_netlink(context)
monitor.filter_by(subsystem='input')


for action, device in monitor:
    if device.subsystem == 'input':
        try:
            if action == 'add' and device['ID_VENDOR_ID'] == '1e54' \
                                and device['ID_MODEL_ID'] == '2030':
                subprocess.call(['setxkbmap', 'fr', 'bepo'])
        except KeyError:
            pass
