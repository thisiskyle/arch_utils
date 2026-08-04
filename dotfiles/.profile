
# set PATH so it includes user's private bins if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="${HOME}/.local/bin:$PATH"
fi

# start ssh-agent if it is not already started
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# source any machine specific profile stuff
[[ -f ${HOME}/.profile_local ]] && source ${HOME}/.profile_local


# uncomment to start X on login
# if [[ \ 
#     -z "$TMUX" \ 
#     && -z "$STY" \ 
#     && -z "$SSH_CONNECTION" \ 
#     && -z "$DISPLAY" \ 
#     && -z "$WAYLAND_DISPLAY" \ 
#     && ( ${XDG_VTNR:-0} -eq 1 || "$(tty)" = /dev/tty1 ) \ 
#     ]]; then
#
#     exec startx
# fi

