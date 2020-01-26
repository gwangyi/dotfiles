# get vim-plug for nvim
[[ -f ~/.local/share/nvim/site/autoload/plug.vim ]] || \
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null >/dev/null

# load zplug
export ZPLUG_HOME=$HOME/.zplug
if [ ! -e "$ZPLUG_HOME" ]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

function _zshrc_init() {
    unset -f _zshrc_init
    DEFAULT_USER=$(whoami)

    # If android
    if command -v getprop > /dev/null 2> /dev/null; then
        export HOSTNAME=$(getprop ro.build.product)
        POWERLEVEL9K_CONTEXT_TEMPLATE=$HOSTNAME
        POWERLEVEL9K_PUBLIC_IP_FILE=$TMPDIR/p9k_public_ip
    fi
    # Add hg backend
    POWERLEVEL9K_VCS_BACKENDS=(git hg)
}
_zshrc_init

source "$HOME/.zplug/init.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "chrissicool/zsh-256color"
zplug "zsh-users/zsh-autosuggestions"
zplug "Tarrasch/zsh-command-not-found"
zplug "joel-porquet/zsh-dircolors-solarized"
zplug "zdharma/fast-syntax-highlighting"
zplug "davidparsson/zsh-pyenv-lazy"
zplug "oz/safe-paste"
zplug "zlsun/solarized-man"
zplug "AnonGuy/yapipenv.zsh"
zplug "zsh-users/zsh-history-substring-search"

zplug "romkatv/powerlevel10k", as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
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

function vimplug {
	case $1 in
		install) nvim "+let g:plug_window = 'enew'" "+map <cr> :qa!<cr>" +PlugInstall ;;
		update) nvim "+let g:plug_window = 'enew'" "+map <cr> :qa!<cr>" +PlugUpdate ;;
		upgrade) nvim "+let g:plug_window = 'enew'" "+map <cr> :qa!<cr>" +PlugUpgrade ;;
	esac
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
