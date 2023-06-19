#!/bin/bash

_pid=$$
while ! readlink "/proc/$_pid/fd/0" | grep -E "pts|tty" > /dev/null; do
  _pid=$(cat "/proc/$_pid/stat" | awk '{ print $4 }')
  [[ "$_pid" == "0" ]] && break
done
_tty=$(readlink "/proc/$_pid/fd/0")

osc52.sh $@ > $_tty
