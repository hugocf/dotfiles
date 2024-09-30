#!/usr/bin/env zsh

defaults_domains() {
    local filter="$1"
    defaults domains | tr ',' '\n' | sort | grep -i "$filter"
}

typeset -U path
path=(~/.local/bin/scripts $path)

alias plcat='plutil -convert xml1 -o -'
alias plread=plcat

alias g=git
alias y=yadm
alias ll='ls -lh'
alias lla='ll -a'

[[ -f "$HOME/custom-source.work.sh" ]] && source "$HOME/custom-source.work.sh" || :
[[ -f "$HOME/custom-source.yadm.sh" ]] && source "$HOME/custom-source.yadm.sh" || :
