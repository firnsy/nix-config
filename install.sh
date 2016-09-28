#!/bin/bash

# ensure config directory exists
[ -d "~/.config"] || mkdir ~/.config


# TODO: ensure our packages exist

# git
cp git/.gitconfig ~/.gitconfig

# powerline
cp -a powerline ~/.config/

# tmux
cp tmux/.tmux.conf ~/.tmux.conf

# vim
cp vim/.vimrc ~/.vimrc
