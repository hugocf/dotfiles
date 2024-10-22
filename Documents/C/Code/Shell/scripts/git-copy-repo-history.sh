#!/usr/bin/env bash
set -euo pipefail

main() {
    [[ $# != 4 ]] && usage
    local source_dir="${1:-}"
    local source_branch="${2:-}"
    local target_dir="${3:-}"
    local target_folder="${4:-}"

    cd "$target_dir"
    git remote add source-repo "$source_dir"
    git fetch source-repo
    git subtree add --prefix="$target_folder" source-repo "$source_branch"
    git remote remove source-repo
}

usage() {
    echo "Copy a local repo into the target folder of another one, preserving all history.

    $(basename "$0") source_dir source_branch target_dir target_folder

    source_dir      path to the source repo being copied
    source_branch   local branch with the commits to copy
    target_dir      path to the target repo receiving the new commits
    target_folder   folder in the target repo where to copy the source files structure

Example:
    $(basename "$0") ./source.git main ./target.git old/repo/"
    exit 1
}

main "$@"
