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

c1="\033[38;5;240m"
c2="\033[38;5;249m"
r="\033[0m"

parse_git_branch () {
      git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
}

show_git_prompt () {
    git branch 2>/dev/null 1>&2 && echo -e "${c1}─[ ${c2}$(parse_git_branch)${c1} ]"
}

if [[ -n $(type -t git) ]] ; then
    PS1="\$(show_git_prompt)"
else
    PS1=""
fi

PS1="
${c1}┌────[ ${c2}\u${c1}@${c2}\h${c1} ]─[ ${c2}\w${c1} ]$PS1
${c1}└─> ${r}"
