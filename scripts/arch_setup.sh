#!/bin/bash

update() {
    echo ------------------- Updating Arch
    sudo pacman -Syu
}

install_basic_packages() {
    echo ------------------- Installing basic packages
    sudo pacman -S base-devel i3-gaps i3blocks vim neofetch feh rofi firefox xorg xorg-xinit xorg-server
}

install_picom() {
    echo ------------------- Installing picom
    git clone https://github.com/ibhagwan/picom-ibhagwan-git $HOME/picom
    cd $HOME/picom
    makepkg -si
}

install_yay() {
    echo ------------------- Installing Yay
    git clone https://aur.archlinux.org/yay-git.git ~/yay
    sudo chown -R ${USER}:users ./yay
    cd $HOME/yay
    makepkg -si
    cd $HOME 
    sudo rm -R $HOME/yay
    yay -Syu
}

install_fonts() {
    sudo pacman -S ttf-fira-code
    yay -S ttf-fixedsys-excelsior-linux

}

install_st() {
    echo ------------------- Installing simple terminal
    curl -o st-0.8.2.tar.gz dl.suckless.org/st/st-0.8.2.tar.gz
    tar -zvxf $HOME/st-0.8.2.tar.gz
    mkdir -p $HOME/.config/st
    mv $HOME/st-0.8.2 $HOME/.config/st
    rm $HOME/st-0.8.2.tar.gz
    sudo chown -R ${USER}:users $HOME/.config/st
}

install_dotfiles() {
    echo ------------------- Installing dotfiles
    $HOME/.dotfiles/scripts/dotman.sh -i
}

compile_st() {
    echo ------------------- Compile simple terminal
    cd $HOME/.config/st
    sudo make clean install
}

download_vimrc() {
    echo ------------------- Downloading vimrc
    git clone https://github.com/thisiskyle/vimfiles $HOME/.vim
    cp $HOME/.vim/.vimrc $HOME/
}

update
install_basic_packages
install_picom
install_yay
install_st
install_fonts
install_dotfiles
compile_st
download_vimrc


echo ------------------- Arch setup complete!
