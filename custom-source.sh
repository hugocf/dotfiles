#!/usr/bin/env zsh

defaults_domains() {
    local filter="$1"
    defaults domains | tr ',' '\n' | sort | grep -i "$filter"
}

# See `which things.sh` for inspiration
things_dates() {
    local id="$1"
    local db=$(find ~/Library/Group\ Containers/JLMPQHK86H.com.culturedcode.ThingsMac -name 'main.sqlite' | head -1)
    local task="
        select
            datetime(creationDate, 'unixepoch', 'localtime') as creationDate,
            datetime(userModificationDate, 'unixepoch', 'localtime') as modificationDate,
            datetime(stopDate, 'unixepoch', 'localtime') as stopDate,
            title
        from TMTask
        where uuid = '$id';"
    local checklist="
        select
            datetime(creationDate, 'unixepoch', 'localtime') as creationDate,
            datetime(userModificationDate, 'unixepoch', 'localtime') as modificationDate,
            datetime(stopDate, 'unixepoch', 'localtime') as stopDate,
            title
        from TMChecklistItem
        where task = '$id'
        order by \"index\";
    "

    sqlite3 "$db" "$task $checklist"
}

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
# user aliases
alias history='fc -l -iD 1 | less +G'
alias h=history

alias plcat='plutil -convert xml1 -o -'
alias plread=plcat

alias g=git
alias y=yadm
alias ll='ls -lh'
alias lla='ll -a'

[[ -f "$HOME/custom-source.work.sh" ]] && source "$HOME/custom-source.work.sh" || :
[[ -f "$HOME/custom-source.yadm.sh" ]] && source "$HOME/custom-source.yadm.sh" || :
