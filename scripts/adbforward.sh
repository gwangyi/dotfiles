#!/bin/bash

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE/../env.sh"

USER=$1
ACTION=$2
SYSFS=$3
DEVPATH=$4

if [[ -z "$USER" ]]; then
  exit
fi

if [[ "$(id -u)" == "0" ]]; then
  echo "sleep 1; $0 $*" | exec sudo -u "$USER" /usr/bin/at now
  exit
fi

[[ -z "$DEVPATH" ]] && exit 1
[[ -z "$ACTION" ]] && exit 1

USERDIR=$(getent passwd "$USER" | cut -d: -f 6)
ANDROID_SERIAL=$(cat "$SYSFS$DEVPATH/../serial")
export ANDROID_SERIAL

if [[ "$ACTION" == "bind" ]]; then
  if [[ -n "$ANDROID_SERIAL" ]]; then
    adb wait-for-device

    PORT=$(adb forward tcp:0 tcp:8022 2> /dev/null)
    if [[ -z "$PORT" ]]; then
      exit
    fi
    grep -F "$ANDROID_SERIAL" "$USERDIR/.ssh/adb_config" &> /dev/null || \
      echo "Include ~/.ssh/adb/config.$ANDROID_SERIAL" >> "$USERDIR/.ssh/adb_config"

    mkdir -p "$USERDIR/.ssh/adb/"
    cat <<EOF > "$USERDIR/.ssh/adb/config.$ANDROID_SERIAL"
Host $ANDROID_SERIAL
  Hostname localhost
  Port $PORT

# vim: set ft=sshconfig:
EOF
  fi
fi
