# {{{ Powerlevel10k instant prompt
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# {{{ Default .zshrc contents
# Set up the prompt

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
which dircolors > /dev/null 2> /dev/null && eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}

# {{{ Configuration 
local _GO_VERSION=1.24.3
export BINSTALL_MAXIMUM_RESOLUTION_TIMEOUT=60
# }}}

# {{{ Utility functions
function _add_path {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
            ;;
    esac
}

# Find exact dotfiles directory
function _find_dotfiles_dir() {
    unset -f _find_dotfiles_dir
    local _source
    local _dotfiles_dir
    _source="${(%):-%x}"
    while [[ -h "${_source}" ]]; do
        _dotfiles_dir="$(cd -P "$(dirname "${_source}")" 2> /dev/null; pwd)"
        _source="$(readlink "${_source}")"
        [[ "${_source}" != /* ]] && _source="${_dotfiles_dir}/${_source}"
    done
    _dotfiles_dir="$(cd -P "$(dirname "${_source}")/.." 2> /dev/null; pwd)"
    echo "$_dotfiles_dir"
}
local _dotfiles_dir="$(_find_dotfiles_dir)"
# }}}

# {{{ OS and Arch detection
local _arch="$(uname -m)"
case "$_arch" in
    aarch64)
        _nvim_arch=arm64
        _go_arch=arm64
        ;;
    x86_64)
        _nvim_arch=x86_64
        _go_arch=amd64
        ;;
    *)
        _nvim_arch="${_arch}"
        ;;
esac

local _os="$(uname -s)"
case "$_os" in
    Linux)
        _os=linux
        ;;
    # TODO: MacOS
esac
# }}}

# {{{ Run once
function __install_tools {
    curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

    touch ~/.firstrun
}

[[ -e ~/.firstrun ]] ||  __install_tools
# }}}

# {{{ ZPM
ZPM_PLUGINS="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

POWERLEVEL9K_INSTALLATION_DIR="${ZPM_PLUGINS}/romkatv---powerlevel10k"

if [[ ! -f "$ZPM_PLUGINS/@zpm/zpm.zsh" ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm "${ZPM_PLUGINS}/@zpm"
fi
source "${ZPM_PLUGINS}/@zpm/zpm.zsh"

zpm load romkatv/powerlevel10k
zpm load junegunn/fzf,hook:"./install --bin && cat shell/*.zsh > init.zsh"
zpm load @remote/nvim,origin:"https://github.com/neovim/neovim/releases/download/nightly/nvim-${_os}-${_nvim_arch}.appimage",destination:bin,apply:path
zpm load @exec/uv,origin:"uv self update > /dev/null 2>&1; echo '_add_path \"${HOME}/.local/bin\"'",apply:source
zpm load @exec/rustup,origin:"rustup self update > /dev/null 2>&1; cat \"${HOME}/.cargo/env\"",apply:source
zpm load @exec/cargo-binstall,origin:"cargo binstall -y cargo-binstall > /dev/null 2>&1"
zpm load @exec/go,origin:"[ -e 'go${_GO_VERSION}.tar.gz' ] || (curl -fSL https://go.dev/dl/go${_GO_VERSION}.${_os}-${_go_arch}.tar.gz -o go${_GO_VERSION}.tar.gz && (rm go -rf; tar xf 'go${_GO_VERSION}.tar.gz') ) > /dev/null 2>&1; echo export GOROOT=\"\${Plugin_destination_path:h}/go\"",path:go/bin,apply:source:path
zpm load @exec/ripgrep,origin:"cargo binstall -y ripgrep > /dev/null 2>&1"
zpm load @exec/lsd,origin:"cargo binstall -y lsd > /dev/null 2>&1 && echo alias ls=lsd"
zpm load @dir/nvim-dotfiles,origin:"${_dotfiles_dir}/nvim",apply:source,hook:"./hook.sh"
zpm load zsh-users/zsh-completions

zpm load zdharma-continuum/fast-syntax-highlighting
# }}}

eval "$(uv generate-shell-completion zsh)"

# {{{ Powerlevel10k configuration
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "${_dotfiles_dir}/zsh/p10k.zsh" ]] || source "${_dotfiles_dir}/zsh/p10k.zsh"
# }}}

# vim: set fdm=marker fmr={{{,}}} ts=4 sw=4 et:
