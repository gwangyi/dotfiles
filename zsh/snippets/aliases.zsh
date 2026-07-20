# =============================================================================
# Modern CLI Tools (Assumes tools are installed via Aqua)                  {{{1
# =============================================================================
# Use 'bat' instead of 'cat' for syntax highlighting
if command -v bat >/dev/null 2>&1; then
    alias cat="bat"
fi

# Use 'eza' (or 'exa') instead of 'ls' for better visuals
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons"
    alias ll="eza -alF --icons"
    alias la="eza -a --icons"
    alias l="eza -F --icons"
else
    # Fallback to standard ls if eza is not installed
    alias ls="ls --color=auto"
    alias ll="ls -alF"
    alias la="ls -A"
    alias l="ls -CF"
fi
