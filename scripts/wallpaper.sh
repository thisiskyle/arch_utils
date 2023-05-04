#!/bin/bash



wallpaper_locations=(
    "$HOME/arch_utils/wallpaper/"
)


if [[ "${1}" == "-list" ]]; then

    for i in "${wallpaper_locations[@]}"
    do
        for e in "${i}"*
        do
            echo "$(basename -- $e)"
        done
    done

    exit
fi




for i in "${wallpaper_locations[@]}"
do
    if [[ -f "${i}${1}" ]]; then
        image_path="${i}${1}"
    fi
done


if [[ ! -f "${image_path}" ]]; then
    echo "ERROR: image could not be found"
    exit 1
fi


feh --bg-scale "${image_path}" &
