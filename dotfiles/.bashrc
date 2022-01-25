# $HOME/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'

PS1='[\u@\h \W]\$ '
EDITOR="vim"
VISUAL="vim"

cd $HOME
