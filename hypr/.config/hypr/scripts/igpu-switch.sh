#!/bin/bash

if envycontrol -q | grep -q "^integrated$"; then
    notify-send "Already in Integrated mode"
else
    kitty -e pkexec envycontrol -s integrated && reboot
fi