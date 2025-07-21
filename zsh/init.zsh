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

# {{{ Version
eval "$(grep -Ev "^#" $(_find_dotfiles_dir)/zsh/versions.env | sed 's/\([^=]*\)=\(.*\)/local _\1_version=\2/')"
# }}}

# {{{ Run once
local _tool_ver="8c5f6484-4f71-11f0-a555-1b5212f5891b"
function __install_tools {
    [ -e "${HOME}/.local/bin/uv" ] || \
        curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh
    [ -e "${HOME}/.cargo/bin/rustup" ] || \
        curl https://sh.rustup.rs -sSf | sh -s -- -y
    [ -e "${HOME}/.cargo/bin/cargo-binstall" ] || \
        curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    [ -e "${HOME}/.local/share/pnpm/pnpm" ] || \
        curl -fSL https://get.pnpm.io/install.sh | env ENV=/dev/null SHELL=$(which sh) bash -

    echo ${_tool_ver} > ${_dotfiles_dir}/.tools
}

[ "$(cat ${_dotfiles_dir}/.tools 2>/dev/null)" = "${_tool_ver}" ] || __install_tools
# }}}

# {{{ Powerlevel10k instant prompt
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# {{{ ZPM
ZPM_PLUGINS="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

POWERLEVEL9K_INSTALLATION_DIR="${ZPM_PLUGINS}/romkatv---powerlevel10k"

if [[ ! -f "$ZPM_PLUGINS/@zpm/zpm.zsh" ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm "${ZPM_PLUGINS}/@zpm"
fi
source "${ZPM_PLUGINS}/@zpm/zpm.zsh"

zpm load romkatv/powerlevel10k

zpm load @exec/uv,origin:"echo _add_path \"${HOME}/.local/bin\"; ${HOME}/.local/bin/uv generate-shell-completion zsh",hook:"${HOME}/.local/bin/uv self update",apply:source,async
zpm load @file/rustup,origin:"${HOME}/.cargo/env",hook:"rustup self update",apply:source,async
zpm load @empty/cargo-binstall,hook:"cargo binstall -y cargo-binstall",async
zpm load @empty/go,hook:"${_dotfiles_dir}/zsh/go-installer.sh \"${_go_version}\" \"\${Plugin_path}\"",path:go/bin,source:plugin.zsh,apply:source:path,async
zpm load @exec/pnpm,origin:"echo export PNPM_HOME=\"\${HOME}/.local/share/pnpm\"; echo _add_path '\"\${PNPM_HOME}\"'",hook:"${HOME}/.local/share/pnpm self-update",apply:source,async
zpm load @empty/node,hook:"pnpm env add --global ${_node_version} && pnpm env use --global ${_node_version} && pnpm add -g neovim",async

zpm load @empty/nvim,hook:"${_dotfiles_dir}/zsh/nvim-installer.sh \"${_nvim_version}\" \"\${Plugin_path}\"",path:nvim/bin,source:plugin.zsh,apply:path:source,async
zpm load @dir/nvim-dotfiles,origin:"${_dotfiles_dir}/nvim",apply:source,hook:"./hook.sh",async

zpm load junegunn/fzf,hook:"./install --bin && cat shell/*.zsh > init.zsh",async
zpm load @empty/ripgrep,hook:"cargo binstall -y ripgrep",async
zpm load @exec/eza,origin:"echo alias ls=eza",hook:"cargo binstall -y eza",async
zpm load @empty/bat,hook:"cargo binstall -y bat",async
zpm load @empty/gemini,hook:"pnpm i -g @google/gemini-cli",async

zpm load @empty/compiledb,hook:"go install github.com/fcying/compiledb-go/cmd/compiledb@latest",async
zpm load @remote/repo,origin:https://storage.googleapis.com/git-repo-downloads/repo,apply:path,destination:bin

zpm load zsh-users/zsh-completions

zpm load zdharma-continuum/fast-syntax-highlighting
# }}}

# {{{ Powerlevel10k configuration
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "${_dotfiles_dir}/zsh/p10k.zsh" ]] || source "${_dotfiles_dir}/zsh/p10k.zsh"
# }}}

# vim: set fdm=marker fmr={{{,}}} ts=4 sw=4 et:
