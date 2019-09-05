#!/bin/bash

echo
echo "========================== Running Updates"
echo

sudo pacman -Syu

echo
echo "========================== Installing Basic Packages"
echo

sudo pacman -S i3-gaps vim neofetch feh dmenu go qutebrowser

echo
echo "========================== Installing Yay"
echo

git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -i

echo "========================== Removing Build Files"

cd ..
sudo rm -R ~/yay

echo "========================== Copying Dotfiles"

$HOME/.dotfiles/cpToHome.sh

echo "========================== Done!"
