# Use Emacs keybindings (default) even if EDITOR is set to vi
bindkey -e

# Search history based on what has been typed so far (Up/Down arrows)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Accept autosuggestion with Ctrl+Space
bindkey '^ ' autosuggest-accept

