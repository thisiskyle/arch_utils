#!/bin/bash

cp $HOME/.Xdefaults $HOME/.dotfiles 
cp $HOME/.bashrc $HOME/.dotfiles
cp $HOME/.fehbg $HOME/.dotfiles
cp $HOME/.xinitrc $HOME/.dotfiles

cp $HOME/.config/i3/config $HOME/.dotfiles/.config/i3
cp $HOME/.config/i3status/config $HOME/.dotfiles/.config/i3status
cp $HOME/.config/compton.conf $HOME/.dotfiles/.config/compton.conf

cp -R $HOME/wallpaper $HOME/.dotfiles
