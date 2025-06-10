#!/bin/sh

DOTFILES="${DOTFILES:-${HOME}/.dotfiles}"

[ -z "${DOTFILES}" ] && (echo empty DOTFILES >&2; exit -1)

git clone https://github.com/gwangyi/dotfiles "${DOTFILES}"

grep ". ${DOTFILES}/zsh/init.zsh" "${HOME}/.zshrc" > /dev/null 2>&1 || echo ". ${DOTFILES}/zsh/init.zsh" >> "${HOME}/.zshrc"
