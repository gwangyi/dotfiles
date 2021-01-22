# Find exact dotfiles directory
function _find_dotfiles_dir() {
    unset -f _find_dotfiles_dir
    local SOURCE
    local DOTFILESDIR
    SOURCE="${(%):-%x}"
    while [[ -h "$SOURCE" ]]; do
        DOTFILESDIR="$(cd -P "$(dirname "$SOURCE")" 2> /dev/null; pwd)"
        SOURCE="$(readlink "$SOURCE")"
        [[ "$SOURCE" != /* ]] && SOURCE="$DOTFILESDIR/$SOURCE"
    done
    DOTFILESDIR="$(cd -P "$(dirname "$SOURCE")/.." 2> /dev/null; pwd)"
    echo "$DOTFILESDIR"
}
_DOTFILESDIR=$(_find_dotfiles_dir)

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nvim'
export PATH=$HOME/bin:$PATH:/snap/bin:$HOME/.cargo/bin:$HOME/.yarn/bin:$HOME/.local/bin:$_DOTFILESDIR/bin
