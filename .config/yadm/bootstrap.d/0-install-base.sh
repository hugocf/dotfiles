#!/usr/bin/env bash
set -euo pipefail

main() {
    :
}

yadm_fix_git_url() {
    echo "yadm: Update repo origin URL"
    yadm remote set-url origin "git@github.com:hugocf/dotfiles.git"
}

main "$@"
