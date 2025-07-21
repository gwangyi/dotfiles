#!/bin/sh

_arch="$(uname -m)"
case "$_arch" in
	aarch64) _arch=arm64 ;;
	x86_64) _arch=amd64 ;;
esac

_os="$(uname -s)"
case "$_os" in
	Linux) _os=linux ;;
	# TODO: MacOS
esac

_version="$1"
_destination="$(realpath "${2:-.}")"

[ -z "${_version}" ] && (echo "need go version"; exit 1)

if [ ! -e "${_destination}/go${_version}.tar.gz" ]; then
	curl -fSL "https://go.dev/dl/go${_version}.${_os}-${_arch}.tar.gz" -o "${_destination}/go${_version}.tar.gz" || exit $!
fi

"${_destination}/go/bin/go" version 2> /dev/null | grep "${_version}" > /dev/null && exit 0

rm "${_destination}/go" -rf 2> /dev/null
tar xf "${_destination}/go${_version}.tar.gz" -C "${_destination}" || exit $!

cat <<EOF > "${_destination}/plugin.zsh"
export GOROOT="${_destination}/go"
_add_path "$("${_destination}/go/bin/go" env GOPATH)/bin"
EOF
