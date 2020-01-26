#!/bin/bash

git clone https://github.com/gwangyi/dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles
git remote set-url origin git@github.com:gwangyi/dotfiles
./setup.sh
