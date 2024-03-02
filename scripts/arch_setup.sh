#!/bin/bash

echo "------- Updating Arch -------"
sudo pacman -Syu

echo "------ Installing basic packages -------"
sudo pacman -S - < $HOME/arch_utils/pkglist.txt

echo "------- Linking scripts to bin -------"
mkdir $HOME/bin
ln -sf ${HOME}/arch_utils/scripts/dotman.sh ${HOME}/bin/dotman
ln -sf ${HOME}/arch_utils/scripts/wallpaper.sh ${HOME}/bin/wallpaper
ln -sf ${HOME}/arch_utils/scripts/cursor.sh ${HOME}/bin/cursor

echo "------- Cloning yay -------"
git clone https://aur.archlinux.org/yay.git $HOME/yay

echo "------- Installing yay -------"
cd $HOME/yay && makepkg -si

echo "------- Updating yay -------"
yay -Syu

echo "------- Installing AUR packages -------"
yay -S yt-dlp yt-dlp-drop-in 

echo "------- Cloning st -------"
git clone https://git.suckless.org/st $HOME/suckless/st

echo "------- Cloning dwm -------"
git clone https://git.suckless.org/dwm $HOME/suckless/dwm

echo "------- Cloning dmenu -------"
git clone https://git.suckless.org/dmenu $HOME/suckless/dmenu

echo "------- Cloning slock -------"
git clone https://git.suckless.org/slock $HOME/suckless/slock

echo "------- Linking dotfiles -------"
dotman

echo "------- Compiling st -------"
cd $HOME/suckless/st
sudo make clean install

echo "------- Compiling dwm -------"
cd $HOME/suckless/dwm
sudo make clean install

echo "------- Compiling dmenu -------"
cd $HOME/suckless/dmenu
sudo make clean install

echo "------- Compiling slock -------"
cd $HOME/suckless/slock
sudo make clean install

echo "------- Downloading vim config -------"
git clone https://github.com/thisiskyle/vim.git $HOME/.vim
ln -sf ${HOME}/.vim/.vimrc ${HOME}/.vimrc

echo "------- Downloading neovim config -------"
rm -rf $HOME/.config/nvim
git clone https://github.com/thisiskyle/nvim.git $HOME/.config/nvim

echo "------- Installing Cursor -------"
cd $HOME
curl -L https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons/
cursor phinger-cursors-light

echo "------- Installing Fonts -------"
mkdir /usr/share/fonts/TTF
curl -L https://github.com/blobject/agave/releases/latest/download/Agave-Regular-slashed.ttf -o /usr/share/fonts/TTF/agave.ttf
curl -L https://github.com/subframe7536/maple-font/releases/download/v7.0-beta6/ttf.zip -o $HOME/downloads/maple.zip
sudo unzip $HOME/downloads/maple.zip -d /usr/share/fonts/TTF/

echo "------- Setting Wallpaper -------"
wallpaper cat.png

echo "------- Sourcing .bash_profile -------"
source ${HOME}/.bash_profile

echo "------- Cleanup -------"
sudo rm -R $HOME/yay

echo "------- Arch environment setup complete! -------"
