_dotfiles=${0:a:h:h}

# =============================================================================
# Aqua Configuration                                                       {{{1
# =============================================================================
# Define the root directory for Aqua and add it to the PATH so managed tools
# (like fzf, bat, exa, etc.) are available immediately.
export AQUA_ROOT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua"
export PATH="${AQUA_ROOT_DIR}/bin:$PATH"

# Specify the global configuration file location for Aqua
export AQUA_GLOBAL_CONFIG="$_dotfiles/aqua/aqua.yaml"

# Automatically install Aqua if the binary does not exist
if [ ! -f "${AQUA_ROOT_DIR}/bin/aqua" ]; then
    echo "Installing Aqua..."
    $_dotfiles/zsh/secure_runner.py https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.2/aqua-installer 98b883756cdd0a6807a8c7623404bfc3bc169275ad9064dc23a6e24ad398f43d || return

    aqua i -a -l
fi

# =============================================================================
# Rustup                                                                   {{{1
# =============================================================================

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"

if ! command -v cargo &> /dev/null; then
    mkdir -p "${CARGO_HOME:-$HOME/.cargo/bin}"
    ln -s "$(aqua which rustup)" "${CARGO_HOME:-$HOME/.cargo/bin}"
    rustup toolchain install stable
fi

# =============================================================================
# Zinit Installation & Initialization                                      {{{1
# =============================================================================
# Set the directory where Zinit and its plugins will be downloaded
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Automatically install Zinit if it does not exist on the system
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit to initialize it
source "${ZINIT_HOME}/zinit.zsh"


# =============================================================================
# Zsh Basic Settings (History & Navigation)                                {{{1
# =============================================================================
# Configure command history limits and file location
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt EXTENDED_HISTORY     # Write the timestamp and duration to the history file
setopt SHARE_HISTORY        # Share history between all active Zsh sessions
setopt HIST_IGNORE_DUPS     # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded events if a new event is a duplicate
setopt HIST_IGNORE_SPACE    # Do not record events starting with a space
setopt HIST_SAVE_NO_DUPS    # Do not write duplicate events to the history file
setopt HIST_VERIFY          # Do not execute immediately upon history expansion

# Directory navigation options
setopt AUTO_CD              # Change directory by just typing its name without 'cd'
setopt AUTO_PUSHD           # Push the current directory onto the stack when changing
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the directory stack


# =============================================================================
# Completion Settings                                                      {{{1
# =============================================================================
# Initialize the completion system
autoload -Uz compinit
compinit

# Allow selecting completion entries with arrow keys
zstyle ':completion:*' menu select
# Group completions by categories
zstyle ':completion:*' group-name ''
# Enable case-insensitive and partial-word completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


# =============================================================================
# Zinit Plugins                                                            {{{1
# =============================================================================

# Zsh Completions                                                          {{{2
# wait: Loads the plugin asynchronously in the background.
# lucid: Silences the loading messages in the terminal.
# blockf: Prevents the plugin from manipulating fpath directly
#         (Zinit handles it).
zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions

# FZF Shell Integration (Ctrl-R, Ctrl-T, Alt-C)                            {{{2
# We fetch only the shell scripts from the official repo.
# pick"/dev/null" tells Zinit not to load the fzf binary itself, 
# as we assume Aqua manages the actual fzf binary.
zinit ice wait lucid multisrc"shell/completion.zsh shell/key-bindings.zsh" id-as"junegunn/fzf" pick"/dev/null"
zinit light junegunn/fzf

# FZF-Tab (Replaces standard Zsh completion menu with FZF)                 {{{2
# MUST be loaded after completions, but before autosuggestions and syntax highlighting.
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Autosuggestions                                                          {{{2
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Syntax Highlighting & Initialize Completions                             {{{2
# This MUST be loaded last to work correctly.
# atinit'...': Compiles and applies the delayed completion setups
#              (zicompinit, zicdreplay) all at once when this syntax
#              highlighting plugin loads.
zinit ice wait lucid atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting

# Key Bindings                                                             {{{2
zinit snippet "$_dotfiles/zsh/snippets/keybindings.zsh"

# Aliases                                                                  {{{2
zinit snippet "$_dotfiles/zsh/snippets/aliases.zsh"

# Neovim                                                                   {{{2
zinit snippet "$_dotfiles/nvim/init.zsh"

# execution time                                                           {{{2
zinit snippet "$HOME/workspace/execution-time/execution-time.plugin.zsh"

# =============================================================================
# Starship                                                                 {{{1
# =============================================================================

export STARSHIP_CONFIG=$_dotfiles/starship/starship.toml
eval "$(starship init zsh)"

# vim: set fdm=marker fmr={{{,}}} ts=4 sw=4 et:
