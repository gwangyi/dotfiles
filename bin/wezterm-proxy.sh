#!/bin/bash

ln -sf $SSH_AUTH_SOCK ~/.wezterm-auth-sock
wezterm cli proxy
