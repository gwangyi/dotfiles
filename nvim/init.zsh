local _config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}"

[ -e "${_config_dir}/nvim-dotfiles" ] || ln -s "${0%/*}" "${_config_dir}/nvim-dotfiles"

export NVIM_APPNAME="nvim-dotfiles"
export EDITOR='nvim'
