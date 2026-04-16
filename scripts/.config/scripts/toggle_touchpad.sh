#!/bin/zsh

#Define the file and pattern
FILE="$HOME/.config/niri/config.kdl"

if grep -q "//off //toggle" "$FILE"; then
    sed -i 's/\/\/off \/\/toggle/off \/\/toggle/' "$FILE"
    notify-send "Output Changed" "Touch Pad is Off"
else
    sed -i 's/off \/\/toggle/\/\/off \/\/toggle/' "$FILE"
    notify-send "Output Changed" "Touch Pad is On"
fi
