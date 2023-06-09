#!/usr/bin/zsh
# Find exact dotfiles directory
function _find_dotfiles_dir() {
    unset -f _find_dotfiles_dir
    local SOURCE
    local _DOTFILESDIR
    SOURCE="${(%):-%x}"
    while [[ -h "$SOURCE" ]]; do
        _DOTFILESDIR="$(cd -P "$(dirname "$SOURCE")" 2> /dev/null; pwd)"
        SOURCE="$(readlink "$SOURCE")"
        [[ "$SOURCE" != /* ]] && SOURCE="$_DOTFILESDIR/$SOURCE"
    done
    _DOTFILESDIR="$(cd -P "$(dirname "$SOURCE")/.." 2> /dev/null; pwd)"
    echo "$_DOTFILESDIR"
}
_DOTFILESDIR=$(_find_dotfiles_dir)

# Corp pre-initialize things
[[ -f "$_DOTFILESDIR/corp/zsh/prepare.zsh" ]] && source "$_DOTFILESDIR/corp/zsh/prepare.zsh"

# get vim-plug for nvim
[[ -f ~/.local/share/nvim/site/autoload/plug.vim ]] || \
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null >/dev/null

# load zplug
export ZPLUG_HOME=$HOME/.zplug
if [ ! -e "$ZPLUG_HOME" ]; then
    git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
fi

function _zshrc_init() {
    unset -f _zshrc_init

    # If android
    if command -v getprop > /dev/null 2> /dev/null; then
        export HOSTNAME=$(getprop ro.build.product)
        POWERLEVEL9K_CONTEXT_TEMPLATE=$HOSTNAME
        POWERLEVEL9K_PUBLIC_IP_FILE=$TMPDIR/p9k_public_ip
    fi
}
_zshrc_init

source "$HOME/.zplug/init.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "chrissicool/zsh-256color"
zplug "zsh-users/zsh-autosuggestions"
zplug "Tarrasch/zsh-command-not-found"
zplug "joel-porquet/zsh-dircolors-solarized"
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "davidparsson/zsh-pyenv-lazy"
zplug "oz/safe-paste"
zplug "zlsun/solarized-man"
zplug "AnonGuy/yapipenv.zsh"
zplug "zsh-users/zsh-history-substring-search"

zplug "romkatv/powerlevel10k", as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -rq; then
        echo; zplug install
    fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zplug load

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

ZSH_PYENV_LAZY_VIRTUALENV=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

function vimplug() {
    local -a ARGS=("+let g:plug_window='enew'")

    case "$1" in
        install)  ${VIM:-nvim} "${ARGS[@]}" +PlugInstall ;;
        update)   ${VIM:-nvim} "${ARGS[@]}" +PlugUpdate ;;
        upgrade)  ${VIM:-nvim} "${ARGS[@]}" +PlugUpgrade ;;
        clean)    ${VIM:-nvim} "${ARGS[@]}" +PlugClean ;;
        status)   ${VIM:-nvim} "${ARGS[@]}" +PlugStatus ;;
        diff)     ${VIM:-nvim} "${ARGS[@]}" +PlugDiff ;;
        snapshot) ${VIM:-nvim} "${ARGS[@]}" +PlugSnapshot "$2" ;;
    esac
}

function update-dotfiles() {
    cd $_DOTFILESDIR && git pull --recurse-submodules --rebase && \
        zplug update && \
        ${VIM:-nvim} "+let g:plug_window='enew'" +PlugUpgrade +PlugUpdate +q
}

export MANPAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    nvim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

if [[ -n "${NVIM}" ]]; then
  alias nvim="nvr -cc split"
  export MANPAGER=$(sed 's/nvim/nvr -cc split/g' <<< $MANPAGER)
fi

# Corp initialize things
[[ -f "$_DOTFILESDIR/corp/zsh/init.zsh" ]] && source "$_DOTFILESDIR/corp/zsh/init.zsh"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# --- Local configurations
