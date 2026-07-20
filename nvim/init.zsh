local _config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}"

[ -e "${_config_dir}/nvim-dotfiles" ] || ln -s "$_dotfiles/nvim" "${_config_dir}/nvim-dotfiles"
[ -e "$_dotfiles/nvim/py/.venv/bin/python" ] || uv sync --directory="$_dotfiles/nvim/py"

export NVIM_APPNAME="nvim-dotfiles"
# Neovim will set its own EDITOR variable.
if [ -z "${NVIM}" ]; then
	export EDITOR='nvim'
else
	alias nvim="$_dotfiles/nvim/py/.venv/bin/nvr -cc split"
fi
