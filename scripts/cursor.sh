#!/bin/bash

cat << EOF > $HOME/.local/share/icons/default/index.theme
[Icon Theme]
Name=${1}
Inherits=${1}
EOF
