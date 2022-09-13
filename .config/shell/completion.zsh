#!/bin/zsh

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME}/.zsh/.zcompcache"

zstyle ':completion:*' completer _extensions _complete _approximate

zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' complete-options true
zstyle ':completion:*:*:cp:*' file-sort size
zstyle ':completion:*' file-sort name
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:*' menu select=1
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*:default' list-colors ${(s.:.)ZLS_COLORS}

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true

# zstyle ':completion:*' add-space true
# zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
# zstyle ':completion:*' menu select=1
# 
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=** r:|=**'
# zstyle ':completion:*' menu select
# zstyle ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# zstyle ':completion:*' group 1
# zstyle ':completion:*' format '%B---- %d%b'
# zstyle ':completion:*:corrections' format '%B---- %d (errors %e)%b'
# zstyle ':completion:*:descriptions' format "%B---- %d%b"
# zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
# zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"