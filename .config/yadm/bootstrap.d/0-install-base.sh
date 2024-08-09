#!/usr/bin/env bash
set -euo pipefail

main() {
    install_homebrew
}

install_homebrew() {
    if ! type brew &> /dev/null; then
        echo -e "\n=== Install homebrew ==="
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
    echo "yadm: Update repo origin URL"
    yadm remote set-url origin "git@github.com:hugocf/dotfiles.git"
}

main "$@"
