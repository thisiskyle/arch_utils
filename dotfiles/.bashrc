
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'

EDITOR="nvim"
VISUAL="nvim"

PS1="[\u@\h \w]\$ "

# source any machine specific bashrc stuff
[[ -f ${HOME}/.bashrc_local ]] && source ${HOME}/.bashrc_local


# source our bash_functions
[[ -f ${HOME}/arch_utils/scripts/bash_functions.sh ]] && source ${HOME}/arch_utils/scripts/bash_functions.sh

