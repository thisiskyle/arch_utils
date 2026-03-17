
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

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

