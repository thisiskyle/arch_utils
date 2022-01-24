#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# set background
feh --bg-scale $HOME/arch_utils/wallpaper/outerwilds.jpg &

# set resolution and refresh rate
xrandr --output DP-4 --mode "1920x1080" --rate "144" &

# set the dwm status bar text
while true; do 
    xsetroot -name "$(date)";
    sleep 1s; 
done &

# start window manager
exec dwm
