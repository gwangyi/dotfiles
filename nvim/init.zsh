local _config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}"

[ -e "${_config_dir}/nvim-dotfiles" ] || ln -s "${0%/*}" "${_config_dir}/nvim-dotfiles"

export NVIM_APPNAME="nvim-dotfiles"
# Neovim will set its own EDITOR variable.
if [ -z "${NVIM}" ]; then
	export EDITOR='nvim'
else
	alias nvim="${0%/*}/py/.venv/bin/nvr -cc split"
fi
