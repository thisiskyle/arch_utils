#!/bin/bash

if [[ ! -f "${1}" ]]; then
    image_path="$HOME/arch_utils/wallpaper/${1}"
else
    image_path="${1}"
fi

if [[ ! -f "${image_path}" ]]; then
    echo "ERROR: image could not be found at ${1} or ${image_path}"
    exit 1
fi

echo "WALLPAPER=\"${image_path}\"" > "$HOME/.wallpaper"
feh --bg-scale "${image_path}" &
