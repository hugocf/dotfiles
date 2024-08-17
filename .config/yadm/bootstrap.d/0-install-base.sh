#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

main() {
    h1 "Base Components"
    install_homebrew
    yadm_set_machine_class
}

install_homebrew() {
    if ! type brew &> /dev/null; then
        echo "Install homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# TODO: Inception
yadm_init_repo() {
    echo "yadm clone dotfiles repo"
    yadm clone https://github.com/hugocf/dotfiles
}

# TODO: Inception fix [after systems knows about ssh]
yadm_fix_git_url() {
    echo "yadm update dotfiles origin url to ssh"
    yadm remote set-url origin "git@github.com:hugocf/dotfiles.git"
}

yadm_set_machine_class() {
    local class
    class=$(yadm config --get local.class)
    if [[ -n "$class" ]]; then
        echo "Machine set as local.class = $class"
    else
        confirm_action "Do you want to setup this machine as ${bold}Work${reset}?" \
            "yadm config local.class Work" \
            "yadm config local.class Personal"
    fi
}

main "$@"
