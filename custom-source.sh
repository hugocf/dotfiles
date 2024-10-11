#!/usr/bin/env zsh

typeset -U path
path=(~/.local/bin/scripts $path)

# [zsh: 15 Paramenters](https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell)
# man zshparam
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
# [zsh: 16 Options](https://zsh.sourceforge.io/Doc/Release/Options.html#History)
# man zshoptions
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY    # https://apple.stackexchange.com/a/427568

[[ -f "$HOME/custom-source.work.sh" ]] && source "$HOME/custom-source.work.sh" || :
[[ -f "$HOME/custom-source.yadm.sh" ]] && source "$HOME/custom-source.yadm.sh" || :
