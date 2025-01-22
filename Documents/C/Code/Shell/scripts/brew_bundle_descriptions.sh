#!/usr/bin/env bash
set -euo pipefail

readonly column_marker="§"  # Must be unlikely to be found in a description
readonly description_prefix="# "

main() {
    [[ ! "$*" ]] && usage 1
    local brewfile="$1"

    process_formulas "$brewfile"
    process_casks "$brewfile"
    process_appstore "$brewfile"
    process_vscode "$brewfile"
}

usage() {
    echo "Retrieve one line descriptions of each app in a brew bundle Brewfile.

Usage:
    $(basename "$0") path/to/Brewfile

Example:
    $(basename "$0") ~/.config/homebrew/Brewfile"
    exit "${1:-0}"
}

process_formulas() {
    local brewfile="$1"

    echo -e "\n# Formulas"
    brew bundle list --formula --file="$brewfile" | while read -r name; do
        brew desc --formula "$name" | sed "s/: /$column_marker$description_prefix/"
    done | column -s"$column_marker" -t
}

process_casks() {
    local brewfile="$1"

    echo -e "\n# Casks"
    brew bundle list --cask --file="$brewfile" | while read -r name; do
        brew desc --cask "$name" | sed "s/: /$column_marker$description_prefix/"
    done | column -s"$column_marker" -t
}

process_appstore() {
    local brewfile="$1"
    local id info

    echo -e "\n# App Store"
    brew bundle list --mas --file="$brewfile" | while read -r name; do
        id=$(grep "$name" "$brewfile" | cut -d':' -f2 | cut -d'#' -f1 | grep -o '[0-9]*')
        info=$(mas_info "$id")
        echo -e "$id$column_marker$description_prefix$info"
    done | column -s"$column_marker" -t
}

mas_info() {
    local id="$1"
    local url_local url_english

    url_local=$(mas info "$id" | grep "From:" | cut -d' ' -f2)
    url_english=${url_local//\/pt\//\/us\/}
    curl --silent "$url_english" | grep '<meta name="description" content="' | cut -d'"' -f4
}

process_vscode() {
    local brewfile="$1"

    echo -e "\n# VS Code"
    brew bundle list --vscode --file="$brewfile" | while read -r name; do
        info=$(vscode_info "$name" | sed 's/Extension for Visual Studio Code - //')
        echo -e "$name$column_marker$description_prefix$info"
    done | column -s"$column_marker" -t
}

vscode_info() {
    local name="$1"
    local url_english="https://marketplace.visualstudio.com/items?itemName=$1"

    curl --silent "$url_english" | grep '<meta name="description" content="' | cut -d'"' -f4 | perl -MHTML::Entities -C -pe 'decode_entities($_)'
}

main "$@"
