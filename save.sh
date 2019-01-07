#!/bin/bash

cp $HOME/.Xdefaults $HOME/.dotfiles/.Xdefaults 
cp $HOME/.bashrc $HOME/.dotfiles/.bashrc
cp $HOME/.fehbg $HOME/.dotfiles/.fehbg
cp $HOME/.xinitrc $HOME/.dotfiles/.xinitrc
cp -R $HOME/.config/* $HOME/.dotfiles/.config/
cp -R $HOME/wallpaper $HOME/.dotfiles/wallpaper/

