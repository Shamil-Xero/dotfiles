#!/bin/bash

chosen=$(printf "⏻ Power Off\n Reboot\n Suspend\n Logout" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
  "⏻ Power Off") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  " Suspend") systemctl suspend ;;
  " Logout") hyprctl dispatch exit ;;
esac
