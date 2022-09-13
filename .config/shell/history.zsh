#!/bin/zsh

# History
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# options
unsetopt menu_complete
unsetopt flowcontrol
unsetopt BEEP

setopt interactive_comments
setopt autocd notify
setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

zstyle :compinstall filename "${ZDOTDIR}/.zshrc"