#!/usr/bin/env zsh

defaults_domains() {
    local filter="$1"
    defaults domains | tr ',' '\n' | sort | grep -i "$filter"
}

yadm_check_changes() {
    yadm status --porcelain | cut -c4- | while read -r filename; do
        if [[ "$filename" == *.plist && "$(file --brief --mime "$filename")" == application/octet-stream* ]]; then
            pl2xml "$filename"
        fi
    done
    yadm diff
}

yadm_restore_unstaged_plist() {
    yadm status --porcelain | grep "^.[M?].*plist.*" | cut -c4- | xargs -I{} yadm restore {}
}

pl2xml() {
    local bin="$1"
    local xml="$1.xml"

    cp "$bin" "$xml"
    plutil -convert xml1 "$xml"
    echo "Converted copy to xml in $xml"
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
