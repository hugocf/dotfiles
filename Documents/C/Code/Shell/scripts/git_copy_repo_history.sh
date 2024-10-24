#!/usr/bin/env bash
set -euo pipefail

main() {
    [[ $# != 4 ]] && usage
    local source_dir="${1:-}"
    local source_branch="${2:-}"
    local target_dir="${3:-}"
    local target_folder="${4:-}"

    cd "$source_dir"; ensure_is_git_repo
    cd "$target_dir"; ensure_is_git_repo
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

ensure_is_git_repo() {
    local is_git_repo=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    if [[ $is_git_repo != true ]]; then
        echo "Error: '$(pwd)' is not a git working directory. Make sure it holds a git repository."
        exit 1
    fi
}

main "$@"
