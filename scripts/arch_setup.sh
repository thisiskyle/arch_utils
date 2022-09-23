#!/bin/bash

echo "\n------- Updating Arch -------"
sudo pacman -Syu

echo "\n------ Installing basic packages -------"
sudo pacman -S - < $HOME/arch_utils/pkglist.txt

echo "\n------- Cloning yay -------"
git clone https://aur.archlinux.org/yay.git $HOME/yay

echo "\n------- Installing yay -------"
cd $HOME/yay && makepkg -si

echo "\n------- Updating yay -------"
yay -Syu

echo "\n------- Installing AUR packages -------"
yay -S yt-dlp yt-dlp-drop-in 

echo "\n------- Cloning st -------"
git clone https://git.suckless.org/st $HOME/suckless/st

echo "\n------- Cloning dwm -------"
git clone https://git.suckless.org/dwm $HOME/suckless/dwm

echo "\n------- Cloning dmenu -------"
git clone https://git.suckless.org/dmenu $HOME/suckless/dmenu

echo "\n------- Cloning slock -------"
git clone https://git.suckless.org/slock $HOME/suckless/slock

echo "\n------- Installing dotfiles -------"
$HOME/arch_utils/dotfiles_install.sh

echo "\n------- Compiling st -------"
cd $HOME/suckless/st
sudo make clean install

echo "\n------- Compiling dwm -------"
cd $HOME/suckless/dwm
sudo make clean install

echo "\n------- Compiling dmenu -------"
cd $HOME/suckless/dmenu
sudo make clean install

echo "\n------- Compiling slock -------"
cd $HOME/suckless/slock
sudo make clean install

echo "\n------- Downloading vim config -------"
git clone https://github.com/thisiskyle/vim.git $HOME/.vim

echo "\n------- Creating symlinks -------"
mkdir $HOME/bin
ln -sf ${HOME}/.vim/.vimrc ${HOME}/.vimrc
ln -sf ${HOME}/arch_utils/scripts/dotman.sh ${HOME}/bin/dotman
ln -sf ${HOME}/arch_utils/scripts/wallpaper.sh ${HOME}/bin/wallpaper

echo "\n------- Sourcing .bash_profile -------"
source ${HOME}/.bash_profile

echo "\n------- Setting background -------"
feh --bg-scale $WALLPAPER &

echo "\n------- Cleanup -------"
sudo rm -R $HOME/yay

echo "\n------- Arch environment setup complete! -------"
