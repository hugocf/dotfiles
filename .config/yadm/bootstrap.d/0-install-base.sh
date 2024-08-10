#!/usr/bin/env bash
set -euo pipefail

main() {
    echo -e "\n=== Base Components ==="
    install_homebrew
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

main "$@"
