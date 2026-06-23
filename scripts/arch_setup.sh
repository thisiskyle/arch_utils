#!/bin/bash


install_core_packages() {
    echo "------ Installing core packages -------"
    sudo pacman -Syu
    sudo pacman -S - < $HOME/arch_utils/pkglist.txt
}


create_script_symlinks() {
    echo "------- Linking scripts to bin -------"
    mkdir $HOME/bin
    ln -sf ${HOME}/arch_utils/scripts/dotman.sh ${HOME}/bin/dotman
    ln -sf ${HOME}/arch_utils/scripts/wallpaper.sh ${HOME}/bin/wallpaper
    ln -sf ${HOME}/arch_utils/scripts/cursor.sh ${HOME}/bin/cursor
}


install_yay() {
    echo "------- Installing yay -------"

    echo "Cloning"
    git clone https://aur.archlinux.org/yay.git $HOME/yay

    echo "Building" 
    cd $HOME/yay && makepkg -si

    echo "Updating" 
    yay -Syu

    echo "Cleanup"
    sudo rm -R $HOME/yay
}

install_aur_packages() {
    echo "------- Installing AUR packages -------"
    yay -S yt-dlp yt-dlp-drop-in 
}


clone_suckless() {
    echo "------- Cloning Suckless Software -------"
    git clone https://git.suckless.org/st $HOME/suckless/st

    echo "dwm"
    git clone https://git.suckless.org/dwm $HOME/suckless/dwm

    echo "dmenu"
    git clone https://git.suckless.org/dmenu $HOME/suckless/dmenu

    echo "slock"
    git clone https://git.suckless.org/slock $HOME/suckless/slock
}


compile_suckless() {
    echo "------- Compiling Suckless Software -------"
    cd $HOME/suckless/st
    sudo make clean install

    echo "dwm"
    cd $HOME/suckless/dwm
    sudo make clean install

    echo "dmenu"
    cd $HOME/suckless/dmenu
    sudo make clean install

    echo "slock"
    cd $HOME/suckless/slock
    sudo make clean install
}


create_dotfile_symlinks() {
    echo "------- Linking dotfiles -------"
    dotman
}


setup_vim_config() {
    echo "------- Cloning vim config -------"
    git clone https://github.com/thisiskyle/vim.git $HOME/.vim
    ln -sf ${HOME}/.vim/.vimrc ${HOME}/.vimrc
}


setup_neovim_config() {
    echo "------- Cloning neovim config -------"
    rm -rf $HOME/.config/nvim
    git clone https://github.com/thisiskyle/nvim.git $HOME/.config/nvim
}

setup_wallpaper() {
    echo "------- Setup wallpaper -------"
    rm -rf $HOME/wallpaper

    echo "Cloning"
    git clone https://github.com/thisiskyle/wallpaper.git $HOME/wallpaper

    echo "Setting"
    wallpaper cat.png
}

install_cursors() {
    echo "------- Installing Cursors -------"
    echo "Phinger"
    cd $HOME
    curl -L https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons/
    cursor phinger-cursors-light
}

install_fonts() {
    echo "------- Installing Fonts -------"
    mkdir /usr/share/fonts/TTF

    echo "Maple"
    curl -L https://github.com/subframe7536/maple-font/releases/download/v7.0-beta6/ttf.zip -o $HOME/downloads/maple.zip
    sudo unzip $HOME/downloads/maple.zip -d /usr/share/fonts/TTF/
}

finalize() {

    source ${HOME}/.bash_profile
    echo "------- Arch environment setup complete! -------"
}


install_core_packages
create_script_symlinks

# install_yay
# install_aur_packages

clone_suckless
create_dotfile_symlinks
compile_suckless

# setup_vim_config
setup_neovim_config

setup_wallpaper

install_cursors
install_fonts

finalize
