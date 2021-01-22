#!/bin/bash

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function deliver {
    [[ -f "$2" ]] && mv -v "$2" "$2.$(date +%Y%m%d)" 2> /dev/null
    mkdir -p "$(dirname "$2")"
    ln -sv "$BASE/$1" "$2" 2> /dev/null
}

function replace {
    python -c 'import sys; [sys.stdout.write(line.replace(sys.argv[1], sys.argv[2])) for line in sys.stdin]' "$@"
}

deliver ssh/ssh_config "$HOME/.ssh/config"
deliver vim/init.vim "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim"
deliver zsh/env.zsh "$HOME/.zshenv"
deliver zsh/init.zsh "$HOME/.zshrc"
[[ -f "$HOME/.p10k.zsh" ]] && mv -v "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.$(date +%Y%m%d)" 2> /dev/null
cp -v "$BASE/zsh/p10k.zsh" "$HOME/.p10k.zsh" 2> /dev/null

echo "Install udev rule for adb forwarding..."
[[ -f "/etc/udev/rules.d/" ]] && \
    replace \$BASE "$BASE" < "$BASE/udev/99-adb.rules" | sudo tee /etc/udev/rules.d/99-adb.rules > /dev/null

echo dircolors.ansi-dark > "$HOME/.zsh-dircolors.conf"

[[ -f "$HOME/.ssh/id_rsa" ]] || ssh-keygen -f "$HOME/.ssh/id_rsa" -N '' && (echo -n "SSH pub key: "; cat "$HOME/.ssh/id_rsa.pub")
