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
    ".bash_profile" \
    ".xinitrc" \
    ".profile" \
    ".gitconfig" \
    ".config/i3/config" \
    ".config/i3blocks/config" \
    ".config/rofi/config" \
    ".config/st/config.h" \
) 

dotfile_repo="${HOME}/.dotfiles"


copy_from_to() {
    for dotfile in "${dotfiles[@]}"
    do
        cp $1/${dotfile} $2/${dotfile}
    done
}



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

    copy_from_to "${dotfile_repo}" "${HOME}"


elif [ "$1" == "-save" ] || [ "$1" == "-s" ]
then 
    echo "Saving dotfiles"

    copy_from_to "${HOME}" "${dotfile_repo}"
fi

echo "Done!"
