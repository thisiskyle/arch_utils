
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'

EDITOR="nvim"
VISUAL="nvim"

# PS1="[\u@\h \W]\$ "
# PS1="\n┌──[ \u@\h ]─[ \w ]\n└╴\$ "

PS1="\w ❱ "
