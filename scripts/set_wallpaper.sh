#!/bin/bash

if [ ! -z ${1+x} ]; then
    export WALLPAPER="${1}"
fi;


feh --bg-scale ${WALLPAPER} &
