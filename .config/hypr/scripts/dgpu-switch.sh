#!/bin/bash

if envycontrol -q | grep -q "^hybrid$"; then
    notify-send "Already in Hybrid mode"
else
    kitty -e pkexec envycontrol -s hybrid && reboot
fi