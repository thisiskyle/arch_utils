#!/bin/bash

# dotfiles
cp "${HOME}/.bashrc" "${HOME}/arch_utils/dotfiles/.bashrc"
cp "${HOME}/.bash_profile" "${HOME}/arch_utils/dotfiles/.bash_profile"
cp "${HOME}/.xinitrc" "${HOME}/arch_utils/dotfiles/.xinitrc"
cp "${HOME}/.profile" "${HOME}/arch_utils/dotfiles/.profile"
cp "${HOME}/.gitconfig" "${HOME}/arch_utils/dotfiles/.gitconfig"

# suckless config
cp "${HOME}/suckless/st/config.h" "${HOME}/arch_utils/dotfiles/suckless/st/config.h"

cp "${HOME}/suckless/dwm/config.h" "${HOME}/arch_utils/dotfiles/suckless/dwm/config.h"
cp "${HOME}/suckless/dwm/dwm.c" "${HOME}/arch_utils/dotfiles/suckless/dwm/dwm.c"
cp "${HOME}/suckless/dmenu/config.h" "${HOME}/arch_utils/dotfiles/suckless/dmenu/config.h"

cp "${HOME}/suckless/slock/config.h" "${HOME}/arch_utils/dotfiles/suckless/slock/config.h"
