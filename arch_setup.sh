#!/bin/bash

echo "========================== Running Updates"
sudo pacman -Syu

echo "========================== Installing Basic Packages"
sudo pacman -S i3-gaps i3blocks vim neofetch feh dmenu go qutebrowser

echo "========================== Installing Yay"
git clone https://aur.archlinux.org/yay.git ~/yay
cd $HOME/yay
makepkg -i
cd $HOME 
sudo rm -R $HOME/yay
sudo yay -Syu

echo "========================== Downloading Simple Terminal"
wget dl.suckless.org/st/st-0.8.2.tar.gz
tar -zvxf $HOME/st-0.8.2.tar.gz

echo "========================== Copying Dotfiles"
$HOME/.dotfiles/cpToHome.sh

echo "========================== Installing Simple Terminal"
cd $HOME/st-0.8.2
sudo make clean install
rm $HOME/st-0.8.2.tar.gz

echo "========================== Done!"
