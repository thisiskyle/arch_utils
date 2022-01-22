#!/bin/bash

echo "------------------- Updating Arch"
sudo pacman -Syu

echo "------------------- Installing basic packages"
sudo pacman -S - < $HOME/arch_utils/pkglist.txt

echo "------------------- Cloning yay"
git clone https://aur.archlinux.org/yay.git $HOME/yay

echo "------------------- Installing yay"
cd $HOME/yay && makepkg -si

echo "------------------- Updating yay"
yay -Syu

echo "------------------- Cloning st"
git clone https://git.suckless.org/st $HOME/st

echo "------------------- Cloning dwm"
git clone https://git.suckless.org/dwm $HOME/dwm

echo "------------------- Cloning dmenu"
git clone https://git.suckless.org/dmenu $HOME/dmenu

echo "------------------- Installing dotfiles"
$HOME/arch_utils/dotfiles_install.sh

echo "------------------- Installing st"
cd $HOME/st
sudo make clean install

echo "------------------- Installing dwm"
cd $HOME/dwm
sudo make clean install

echo "------------------- Installing dmenu"
cd $HOME/dmenu
sudo make clean install

echo "------------------- Downloading vim config package"
git clone https://github.com/thisiskyle/ke-vim-pack.git $HOME/.vim/pack/ke-vim-pack

echo "------------------- Cleanup"
cd $HOME 
sudo rm -R $HOME/yay

echo "------------------- Arch setup complete!"
