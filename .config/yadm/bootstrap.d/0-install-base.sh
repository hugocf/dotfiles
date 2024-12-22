#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

main() {
    h1 "Base Components"
    install_xcode_cli
    install_homebrew
    install_yadm
    setup_yadm
}

install_xcode_cli() {
    if xcode-select -p &> /dev/null; then
        echo "Xcode CLI tools installed"
    else
        echo "Install Xcode CLI tools..."
        xcode-select --install
    fi
}

install_homebrew() {
    if type brew &> /dev/null; then
        echo "Homebrew installed"
    else
        echo "Install homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty
    fi
}

install_yadm() {
    if type yadm &> /dev/null; then
        echo "yadm installed"
    else
        echo "Install yadm..."
        brew instal yadm
    fi
}

setup_yadm() {
    yadm_clone_repo
    yadm_fix_git_url
    yadm_set_machine_class
}

yadm_clone_repo() {
    if yadm status &> /dev/null; then
        echo "yadm cloned"
    else
        echo "yadm clone repo"
        yadm clone https://github.com/hugocf/dotfiles
    fi
}

yadm_fix_git_url() {
    if ! yadm remote get-url origin | grep git@ &> /dev/null; then
        echo "yadm set repo url to ssh"
        yadm remote set-url origin "git@github.com:hugocf/dotfiles.git"
    fi
}

yadm_set_machine_class() {
    local class
    class=$(yadm config --get local.class)
    if [[ -n "$class" ]]; then
        echo "yadm set as local.class = $class"
    else
        confirm_action "yadm: Do you want to setup this machine as ${bold}Work${reset}?" \
            "yadm config local.class Work" \
            "yadm config local.class Personal"
    fi
}

main "$@"
