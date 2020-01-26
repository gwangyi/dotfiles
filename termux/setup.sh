#!/bin/bash

alias apt='apt -o Dpkg::Options::="--force-confnew"'

apt update
apt dist-upgrade -y
apt install -y openssh zsh git perl ncurses-utils neovim python python2 termux-api
PY2_OUTDATED=$(pip2 list -o --format freeze)
PY3_OUTDATED=$(pip list -o --format freeze)
[[ -n "$PY2_OUTDATED" ]] && sed 's/=.*//' <<<"$PY2_OUTDATED" | xargs pip2 install -U
[[ -n "$PY3_OUTDATED" ]] && sed 's/=.*//' <<<"$PY3_OUTDATED" | xargs pip install -U
pip install neovim
pip2 install neovim

mkdir -p "$HOME/.termux" 2> /dev/null

curl -fL https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf -o "$HOME/.termux/font.ttf"

curl -fL https://github.com/gwangyi/dotfiles/raw/master/termux/colors.properties -o "$HOME/.termux/colors.properties"

curl -fL https://github.com/gwangyi/dotfiles/raw/master/install.sh | bash
