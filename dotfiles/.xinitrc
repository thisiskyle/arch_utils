#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# set background
feh --bg-scale $HOME/arch_utils/wallpaper/Other_27.jpg &

# set resolution and refresh rate
# i dont think we really need these anymore
#xrandr --newmode "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
#xrandr --addmode Virtual-1 "1920x1080_60.00"
#xrandr --output Virtual-1 --mode "1920x1080_60.00"
#xrandr --output DP-4 --mode "1920x1080" --rate "144" &

# set the dwm status bar text
while true; do 
    d=$(date +"%Y%m%d")
    t=$(date +"%T")
    gpu=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    #cpu=$(cat /sys/class/thermal/thermal_zone0/temp | sed 's/000$/°C/')

    xsetroot -name "[GPU: ${gpu}°C] [${d}] [${t}]";
    sleep 1s; 

done &

# start window manager
exec dwm
