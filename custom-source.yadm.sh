#!/usr/bin/env zsh

yadm_check_changes() {
    yadm status --porcelain | cut -c4- | while read -r filename; do
        if [[ "$filename" == *.plist && "$(file --brief --mime "$filename")" == application/octet-stream* ]]; then
            pl2xml "$filename"
        fi
    done
    yadm diff --color-words
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
