# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.local/share/zsh}/plugins}

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.plugin.zsh

# make list of the Zsh plugins you use
repos=(
  romkatv/powerlevel10k
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-autosuggestions
  MichaelAquilina/zsh-auto-notify
  MichaelAquilina/zsh-you-should-use
)

# load plugins
plugin-load $repos

# History
setopt HIST_IGNORE_ALL_DUPS
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# aliases
[ -f "${HOME}/.local/share/zsh/aliases" ] && source "${HOME}/.local/share/zsh/aliases"
# functions
[ -f "${HOME}/.local/share/zsh/functions" ] && source "${HOME}/.local/share/zsh/functions"

# asdf configuration
export ASDF_DATA_DIR=~/.asdf
. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# options
unsetopt menu_complete
unsetopt flowcontrol

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

zstyle :compinstall filename '/home/algus/.zshrc'
autoload -Uz compinit; compinit

# completions
[ -f "${HOME}/.local/share/zsh/completion" ] && source "${HOME}/.local/share/zsh/completion"

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey "\e[3~" delete-char 

# history substring search options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -s "^l" "clear\n"

# auto notify options
AUTO_NOTIFY_IGNORE+=("lf" "hugo serve")

. ~/.asdf/plugins/java/set-java-home.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
