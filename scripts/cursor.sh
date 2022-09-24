#!/bin/bash

icons="$HOME/.local/share/icons"

ln -sf "$icons/$1/cursor.theme" "$icons/default/index.theme"

