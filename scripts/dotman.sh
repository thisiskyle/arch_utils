#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Erro: No arguments'
    echo 'Include -i for install or -s for saving.'
    exit 1
fi

dotfiles=(\
    ".bashrc" \
    ".bash_profile" \
    ".xinitrc" \
    ".profile" \
    ".gitconfig" \
    ".tmux.conf" \
    ".config/i3/config" \
    ".config/i3blocks/config" \
    ".config/rofi/config" \
    ".config/picom/picom.conf" \
    ".config/st/config.h" \
) 

dotfile_repo="${HOME}/.dotfiles"


copy_from_to() {
    for dotfile in "${dotfiles[@]}"
    do
        cp ${1}/${dotfile} ${2}/${dotfile}
    done
}

make_directories() {
    mkdir -p "${HOME}/.config" 
    mkdir -p "${HOME}/.config/i3/" 
    mkdir -p "${HOME}/.config/i3blocks/" 
    mkdir -p "${HOME}/.config/rofi/"
    mkdir -p "${HOME}/.config/picom/"
}


if [ "${1}" == "-install" ] || [ "${1}" == "-i" ]
then 

    echo "Installing dotfiles"
    make_directories
    copy_from_to "${dotfile_repo}" "${HOME}"

elif [ "$1" == "-save" ] || [ "$1" == "-s" ]
then 

    echo "Saving dotfiles"
    copy_from_to "${HOME}" "${dotfile_repo}"

fi

echo "Done!"
