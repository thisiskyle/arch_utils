#!/bin/bash

dotfileList="${HOME}/arch_utils/dotfiles.txt"
dotfileStorage="${HOME}/arch_utils/dotfiles"


# here we are collecting the arguments

if [[ ${1} == "-s" ]] || [[ ${1} == "--save" ]]; then
    srcRoot="${HOME}"
    destRoot="${dotfileStorage}"

elif [[ ${1} == "-i" ]] || [[ ${1} == "--install" ]]; then
    srcRoot="${dotfileStorage}"
    destRoot="${HOME}"
else
    echo "${1} is not a valid argument"
    exit 1;
fi

# ignore any lines that are comments
# this will only work for lines that start with '#'
grep -v "^#" < ${dotfileList} | {

    # for each line grep output
    while read line; do

        src="${srcRoot}/${line}"

        # check if the source exists. If it doesnt skip it
        if [[ ! -f "$src" ]]; then
            echo "WARNING: File ${src} does not exist"
            continue;
        fi

        dest="${destRoot}/${line}"
        destDir="${dest%/*}"

        # check if destination directory exists. If not, we make it
        if [[ ! -d "$destDir" ]]; then
            echo "Destination directory ${destDir} does not exist. Creating it now."
            mkdir -p "${destDir}"
        fi

        # copy source to destination
        echo "Coping ${src} to ${dest}"
        cp "${src}" "${dest}"
    done
}

