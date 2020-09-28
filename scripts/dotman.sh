#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Erro: No arguments'
    echo 'Include -i for install or -s for saving.'
    exit 1
fi


. ./dotman.conf


show_help() {
    cat << EOF


    Usage: ${0##*/} [option]

    Manage your dotfiles with Dotman!

        -s, --save                   Update the stored dotfiles, with the currently used dotfiles

        -i, --install                Install the stored dotfiles in the ${HOME} folder      

        -h, --help, -u, --usage, -?  Display this help text


EOF
}

copy_from_to() {
    for dotfile in "${dotfiles[@]}"
    do
        cp ${1}/${dotfile} ${2}/${dotfile}
    done
}

make_directories() {
    for dotfile in "${dotfiles[@]}"
    do
        mkdir -p "${HOME}/${dotfile}"
        rm -r "${HOME}/${dotfile}"
    done
}

install() {
    echo "Installing dotfiles"
    make_directories
    copy_from_to "${dotfile_repo}" "${HOME}"
}

save() {
    echo "Saving dotfiles"
    copy_from_to "${HOME}" "${dotfile_repo}"
}


while :;
do
    case "${1}" in
        "-s"|"--save") 
            save
            ;;
        "-i"|"--install") 
            install
            ;;
        "-h"|"-help"|"-u"|"--usage"|"-?") 
            _show_help
            exit 0
            ;;
        -?*)
            echo "Unknown option ${1} ignored"
            ;;
        --) # end of options
            shift
            break
            ;;
        *)
            break
            ;;
    esac
    # shift to next arg
    shift
done



echo "COMPLETE!"
