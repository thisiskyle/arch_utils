#!/bin/bash

echo ------------------- Updating Arch
sudo pacman -Syu

echo ------------------- Installing basic packages
sudo pacman -S i3-gaps i3blocks vim neofetch feh rofi qutebrowser xorg xorg-xinit xorg-server


echo ------------------- Installing picom
git clone https://github.com/ibhagwan/picom-ibhagwan-git $HOME/picom
cd $HOME/picom
makepkg -si


echo ------------------- Installing Yay
git clone https://aur.archlinux.org/yay.git ~/yay
cd $HOME/yay
makepkg -i
cd $HOME 
sudo rm -R $HOME/yay
sudo yay -Syu


echo ------------------- Installing fonts
yay -S ttf-courier-prime
yay -S ttf-cascadia-code


echo ------------------- Installing simple terminal
curl -o st-0.8.2.tar.gz dl.suckless.org/st/st-0.8.2.tar.gz
tar -zvxf $HOME/st-0.8.2.tar.gz
mv $HOME/st-0.8.2 $HOME/.config/st
rm $HOME/st-0.8.2.tar.gz
sudo chown root:users $HOME/.config/st/config.h


echo ------------------- Installing dotfiles
$HOME/.dotfiles/scripts/manager.sh -i


echo ------------------- Compile simple terminal
cd $HOME/.config/st
sudo make clean install
 

echo ------------------- Installing Vim config
git clone https://github.com/thisiskyle/vimfiles $HOME/.vim
cp $HOME/.vim/.vimrc $HOME/


echo ------------------- Arch setup complete!
