#!/bin/zsh

export EDITOR="vim"
export TERMINAL="wezterm"
export BROWSER="chrome"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZPLUGINDIR="$ZDOTDIR/plugins"

export HISTFILE="$XDG_CACHE_HOME/zsh/zsh_history"
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE

export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/.asdfrc"
export ASDF_DATA_DIR="$HOME/.asdf"
export ASDF_PLUGINS="$ASDF_DATA_DIR/plugins"

export SKHD_HOME="$XDG_CONFIG_HOME/skhd"
export SKHD_SCRIPTS_DIR="$SKHD_HOME/scripts"

export YABAI_HOME="$XDG_CONFIG_HOME/yabai"
export YABAI_SCRIPTS_DIR="$YABAI_HOME/scripts"
