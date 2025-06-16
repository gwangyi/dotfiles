#!/bin/sh

_arch="$(uname -m)"
case "$_arch" in
	arm*)
		_arch=ARMv6
		;;
	aarch64)
		_arch=ARM64
		;;
	x86)
		_arch=32bit
		;;
	x86_64)
		_arch=64bit
		;;
esac

_os="$(uname -s)"
# TODO: MacOS

_version="$1"
_destination="$(realpath ${2:-.})"

[ -z "${_version}" ] && (echo "need version"; exit 1)

if [ ! -e "${_destination}/clangd_${_version}.tar.bz2" ] || [ ! -e "${_destination}/clang-format_${_version}.tar.bz2" ]; then
	curl -fSL "https://github.com/arduino/clang-static-binaries/releases/download/${_version}/clangd_${_version}_${_os}_${_arch}.tar.bz2" -o "${_destination}/clangd_${_version}.tar.bz2" || exit $!
	curl -fSL "https://github.com/arduino/clang-static-binaries/releases/download/${_version}/clang-format_${_version}_${_os}_${_arch}.tar.bz2" -o "${_destination}/clang-format_${_version}.tar.bz2" || exit $!
fi

${_destination}/bin/clangd --version 2>/dev/null | grep ${_version} > /dev/null 2>&1 && exit 0

rm "${_destination}/bin" -rf 2> /dev/null
mkdir "${_destination}/bin" || exit $!

tar xf ${_destination}/clangd_${_version}.tar.bz2 -C ${_destination}/bin --strip-components=1
tar xf ${_destination}/clang-format_${_version}.tar.bz2 -C ${_destination}/bin --strip-components=1
