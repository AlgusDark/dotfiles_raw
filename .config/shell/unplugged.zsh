#!/bin/zsh

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
  olets/zsh-window-title
)

# load plugins
plugin-load $repos