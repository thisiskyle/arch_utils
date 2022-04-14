# $HOME/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'

EDITOR="vim"
VISUAL="vim"

cd $HOME

#default prompt
#PS1='[\u@\h \W]\$ '

c1="\[\033[38;5;240m\]"
c2="\[\033[38;5;245m\]"
c3="\[\033[38;5;0m\]"
r="\[\033[0m\]"

PS1="
${c3}┌────[${c2}\u${c3}@${c2}\h${c3}]─[${c2}\w${c3}]
${c3}└─> ${r}"
