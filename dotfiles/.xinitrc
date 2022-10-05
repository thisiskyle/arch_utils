#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# set background
source $HOME/.wallpaper
feh --bg-scale ${WALLPAPER} &

# set resolution and refresh rate
# i dont think we really need these anymore
#xrandr --newmode "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
#xrandr --addmode Virtual-1 "1920x1080_60.00"
#xrandr --output Virtual-1 --mode "1920x1080_60.00"
#xrandr --output DP-4 --mode "1920x1080" --rate "144" &

[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

# status bar stuff
get_date() {
    echo "$(date +"%m/%d/%Y")"
}

get_time() {
    echo "$(date +"%T")"
}

gpu() {
    echo "GPU $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)°C"
}

cpu() {
    read -r cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read -r cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    echo "CPU $((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))%"
}

ram() {
    echo "RAM $(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')"
}


while true; do 
    #xsetroot -name "[ $(ram) ]--[ $(cpu) ]--[ $(gpu) ]--[ $(get_date) ]--[ $(get_time) ]";
    xsetroot -name "[ $(get_date) ]--[ $(get_time) ]";
    sleep 0.5s; 
done &

# set mouse acceleration
xinput set-prop 15 'libinput Accel Speed' -0.75

xrdb $HOME/.Xresources

# start window manager
exec dwm
