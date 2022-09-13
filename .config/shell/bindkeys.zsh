#!/bin/zsh

# Use arrow-like keys in tab complete menu:
# bindkey -M menuselect 'j' vi-backward-char
# bindkey -M menuselect 'i' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'k' vi-down-line-or-history

# Edit line in vim with double escape:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# bindkey -M vicmd '^[[P' vi-delete-char
# bindkey -M visual '^[[P' vi-delete

# history substring search options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '^u' beginning-of-line
bindkey '^o' end-of-line
bindkey "\e[3~" delete-char
# bindkey "^y" delete-char

bindkey "^y" yank
bindkey '^Z' undo

bindkey "${terminfo[kcbt]}" reverse-menu-complete
# bindkey "^[OA" up-line-or-history
# bindkey "^[OB" down-line-or-history

# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search; zle -N up-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search; zle -N down-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

bindkey "^b" backward-word
bindkey "^f" forward-word
bindkey "^j" backward-word
bindkey "^l" forward-word

bindkey "^k" clear-screen

bindkey "^[[105;5u" kill-word # i
bindkey "^[[44;5u" vi-backward-kill-word # ,
bindkey "^[[46;5u" vi-forward-char # .
bindkey "^[[109;5u" vi-backward-char # m 

setopt ignore_eof
bindkey -r '^d'
bindkey -M viins '^d' vi-cmd-mode
# Remove the escape key binding.
bindkey -r '^['

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# setopt PROMPT_CR
setopt PROMPT_SP
export PROMPT_EOL_MARK=""