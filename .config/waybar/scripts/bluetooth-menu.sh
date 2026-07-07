#!/bin/bash

options="Toggle Bluetooth\nConnect Device\nDisconnect Device\nOpen Blueman"

choice=$(echo -e "$options" | rofi -dmenu -p "Bluetooth")

case "$choice" in
    "Toggle Bluetooth")
        if bluetoothctl show | grep -q "Powered: yes"; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
        ;;
    "Connect Device")
        bluetoothctl devices | \
        cut -d' ' -f3- | \
        rofi -dmenu -p "Connect"
        ;;
    "Open Blueman")
        blueman-manager
        ;;
esac