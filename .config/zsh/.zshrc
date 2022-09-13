# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f $ASDF_DATA_DIR/asdf.sh ]; then
  source $ASDF_DATA_DIR/asdf.sh
  fpath=($fpath ${ASDF_DIR}/completions)

  if [ -f $ASDF_PLUGINS/java/set-java-home.zsh ]; then
    source $ASDF_PLUGINS/java/set-java-home.zsh
  fi
fi

fpath=($fpath /usr/local/sbin)

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/unplugged"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functions"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/completion"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/history"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bindkeys.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# auto notify options
AUTO_NOTIFY_IGNORE+=("lf" "hugo serve")

# To customize prompt, run `p10k configure` or edit $XDG_CONFIG_HOME/.p10k.zsh.
[[ ! -f "$XDG_CONFIG_HOME/.p10k.zsh" ]] || source "$XDG_CONFIG_HOME/.p10k.zsh"

autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi
