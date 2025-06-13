#!/bin/sh

_arch="$(uname -m)"
case "$_arch" in
	aarch64)
		_arch=arm64
		;;
esac

_os="$(uname -s)"
case "$_os" in
	Linux)
		_os=linux
		;;
		# TODO: MacOS
esac

_version="$1"
_destination="$(realpath ${2:-.})"

[ -z "${_version}" ] && (echo "need version"; exit 1)

if [ ! -e "${_destination}/nvim-${_version}.tar.gz" ]; then
	curl -fSL "https://github.com/neovim/neovim/releases/download/v${_version}/nvim-${_os}-${_arch}.tar.gz" -o "${_destination}/nvim-${_version}.tar.gz" || exit $!
fi

${_destination}/nvim/bin/nvim --version | grep ${_version} > /dev/null 2>&1 && exit 0

rm -rf "${_destination}/nvim"
mkdir "${_destination}/nvim"

tar xf "${_destination}/nvim-${_version}.tar.gz" -C ${_destination}/nvim --strip-components=1

cat <<EOF > "${_destination}/plugin.zsh"
export VIMRUNTIME="${_destination}/nvim/share/nvim/runtime"
EOF
