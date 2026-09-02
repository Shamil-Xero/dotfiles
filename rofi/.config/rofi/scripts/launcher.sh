#!/usr/bin/env bash

##
# Launcher Script using Rofi
##

dir="$HOME/.config/rofi"
theme="launcher"

## Run
rofi \
    -show drun \
    -theme "${dir}/themes/${theme}.rasi"
