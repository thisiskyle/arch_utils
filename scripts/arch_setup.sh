#!/bin/bash

echo Updating Arch
sudo pacman -Syu

echo Installing Basic Packages
sudo pacman -S i3-gaps i3blocks gvim neofetch feh rofi go qutebrowser xorg xorg-xinit xorg-server

echo Installing Yay
git clone https://aur.archlinux.org/yay.git ~/yay
cd $HOME/yay
makepkg -i
cd $HOME 
sudo rm -R $HOME/yay
sudo yay -Syu

echo Installing gotop
yay -S gotop

echo Installing Simple Terminal
curl -o st-0.8.2.tar.gz dl.suckless.org/st/st-0.8.2.tar.gz
tar -zvxf $HOME/st-0.8.2.tar.gz
mv $HOME/st-0.8.2 $HOME/.config/st
cd $HOME/.config/st
sudo make clean install
rm $HOME/st-0.8.2.tar.gz
# @todo I might need to change permissions on config.h to be able to install the new dotfile

echo Installing Dotfiles
git clone https://github.com/thisiskyle/dotfiles $HOME/.dotfiles
$HOME/.dotfiles/scripts/manager.sh -i

# @todo Here I should recompile st with the new config.h

echo Installing Vim Config
git clone https://github.com/thisiskyle/vimfiles $HOME/.vim
cp $HOME/.vim/.vimrc $HOME/

echo Done!
