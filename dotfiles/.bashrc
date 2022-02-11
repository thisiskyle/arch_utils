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
c2="\[\033[38;5;249m\]"
r="\[\033[0m\]"

PS1="
${c1}┌────[ ${c2}\u${c1}@${c2}\h${c1} ]─[ ${c2}\w${c1} ]
${c1}└─> ${r}"
