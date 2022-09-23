#!/bin/bash

echo "WALLPAPER=\"$1\"" > "$HOME/.wallpaper"

feh --bg-scale "$1" &
