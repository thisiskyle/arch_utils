#!/bin/bash

# the file with the list of dotfiles and their locations relative to the $HOME directory
dotfileList="${HOME}/arch_utils/dotfilelist.txt"

# the location of where to store the dotfiles
dotfileDir="${HOME}/arch_utils/dotfiles"


# ignore any lines that are comments this will only work for lines that start with '#'
grep -v "^#" < ${dotfileList} | {
    # for each line grep output
    while read line; do

        linkSrc="${dotfileDir}/${line}"

        # check if the source exists. If it doesnt skip it
        if [[ ! -f "${linkSrc}" ]]; then
            echo "WARNING: File ${linkSrc} does not exist"
            continue;
        fi

        link="${HOME}/${line}"
        linkDir="${link%/*}"

        # check if destination directory exists. If not, we make it
        if [[ ! -d "$linkDir" ]]; then
            echo "Destination directory ${linkDir} does not exist. Creating it now."
            mkdir -p "${linkDir}"
        fi

        rm "${HOME}/${line}
        ln -sf ${linkSrc} ${link}
    done
}
