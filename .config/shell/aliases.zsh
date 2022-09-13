#!/bin/zsh

alias reload="source $ZDOTDIR/.zshrc"

# settings for common commands
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

alias cls="clear"
alias ls='ls --color=auto'
alias lsl='ls -l'
alias ll='ls -lahF'
alias lls='ls -lahFtr'
alias la='ls -A'

# git aliases

alias g="git"
alias gs="git status"
alias gc="git commit"
alias gaa="git add"
alias gaa="git add -A"
alias gpl="git pull"
alias gpom="git pull origin master"
alias gpu="git push"
alias gpuf="git push --force"
alias gpuom="git push origin master"
alias gd="git diff"
alias gch="git checkout"
alias gnb="git checkout -b"
alias gac="git add . && git commit"
alias gcl="git clone"
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold green)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold yellow)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias gb="git branch"
alias gf="git fetch"
alias gclean="git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 git branch -d" # Delete local branch merged with master