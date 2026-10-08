#!bin/bash

# open tmux with a dev env setup already
tmuxdev() {
    sessionName="${1:-my-session}"
    tmux new-session -d -s "${sessionName}" -n "editor"
    tmux new-window -t "${sessionName}":1
    tmux new-window -t "${sessionName}":2 -n "client"
    tmux new-window -t "${sessionName}":3 -n "server"
    tmux select-window -t "${sessionName}":0
    tmux attach-session -t "${sessionName}"
}


set_cursor() {
    cat << EOF > $HOME/.Xresources
Xcursor.theme: ${1}
Xcursor.size: 32
EOF

}


dotman() {

    # the file with the list of dotfiles and their locations relative to the $HOME directory
    dotfileList="${HOME}/arch_utils/dotfilelist.txt"

    # the location of where to store the dotfiles
    dotfileDir="${HOME}/arch_utils/dotfiles"

    # todo: instead of a dotfile list, we could just get all that information
    #       for the files in the directory... but this is just easier for now

    # todo: we could also take user input for this directory location
    #       instead of guessing that its in the home directory

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

            rm "${HOME}/${line}"
            ln -sf ${linkSrc} ${link}
        done
    }

}


# todo: this whole thing is broken
set_wallpaper() {

    wallpaper_locations=(
        "$HOME/wallpaper/cosmere/"
        "$HOME/wallpaper/cozy/"
        "$HOME/wallpaper/misc/"
        "$HOME/wallpaper/outerwilds/"
        "$HOME/wallpaper/space/"
        "$HOME/wallpaper/zelda/"
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

}


# This is only for using virtual machines I think... I cant remember
fix_vm_resolution() {
    xrandr --newmode "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
    xrandr --addmode Virtual-1 "1920x1080_60.00"
    xrandr --output Virtual-1 --mode "1920x1080_60.00"
}
