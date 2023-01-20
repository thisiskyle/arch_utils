#!/bin/bash

cat << EOF > $HOME/.Xresources
Xcursor.theme: ${1}
Xcursor.size: 32
EOF
