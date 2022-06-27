#!/bin/zsh

# Runs on login. Environmental variables are set here.

# Default programs:
export TERMINAL="wezterm"
export BROWSER="chrome"

# export EDITOR="vim"
# KEYTIMEOUT=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZPLUGINDIR="$ZDOTDIR/plugins"

# asdf configuration
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/.asdfrc"
export ASDF_DATA_DIR="$HOME/.asdf"
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

. "$HOME/.asdf"/plugins/java/set-java-home.zsh

if [ -f "$HOME/.bash_profile" ]; then
  . "$HOME/.bash_profile";
fi