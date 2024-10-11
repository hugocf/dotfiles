#!/usr/bin/env zsh

typeset -U path
path=(~/.local/bin/scripts $path)

[[ -f "$HOME/custom-source.work.sh" ]] && source "$HOME/custom-source.work.sh" || :
[[ -f "$HOME/custom-source.yadm.sh" ]] && source "$HOME/custom-source.yadm.sh" || :
