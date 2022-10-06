#!/bin/bash

checks=(
    "${1}"
    "$HOME/arch_utils/wallpaper/${1}"
)

for i in "${checks[@]}"
do
    if [[ -f "${i}" ]]; then
        image_path="${i}"
    fi
done


if [[ ! -f "${image_path}" ]]; then
    echo "ERROR: image could not be found"
    exit 1
fi

echo "WALLPAPER=\"${image_path}\"" > "$HOME/.wallpaper"

pgrep 'startx' && feh --bg-scale "${image_path}" &
