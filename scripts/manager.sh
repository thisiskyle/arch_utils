#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo ''
    echo 'Erro: No arguments'
    echo 'Include -i for install or -s for saving.'
    echo ''
    exit 1
fi

dotfiles=(\
    ".bashrc" \
    ".xinitrc" \
    ".profile" \
    ".config/i3/config" \
    ".config/i3blocks/config" \
    ".config/rofi/config" \
    ".config/st/config.h" \
) 

dotfile_repo="${HOME}/.dotfiles"




if [ "$1" == "-install" ] || [ "$1" == "-i" ]
then 
    echo "Installing dotfiles"

    if [ ! -d "$HOME/.config/i3" ]
    then 
        mkdir $HOME/.config/i3/ 
    fi

    if [ ! -d "$HOME/.config/i3blocks" ]
    then 
        mkdir $HOME/.config/i3blocks/ 
    fi

    if [ ! -d "$HOME/.config/rofi" ]
    then 
        mkdir $HOME/.config/rofi/ 
    fi

    for dotfile in "${dotfiles[@]}"
    do
        cp "${dotfile_repo}/${dotfile}" "${HOME}/${dotfile}"
    done


elif [ "$1" == "-save" ] || [ "$1" == "-s" ]
then 
    echo "Saving dotfiles"

    for dotfile in "${dotfiles[@]}"
    do
        cp "${HOME}/${dotfile}" "${dotfile_repo}/${dotfile}"
    done
fi

echo "Done!"
