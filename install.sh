#!/usr/bin/env bash
set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

cd "$BASEDIR"

source ./bash/bash_aliases
if ! isadmin $USER; then
    echo "ERROR: User $USER must be an Administrator!"
    exit 1
fi

./install/symlinks.sh
./install/defaults.sh

./install/brew.sh
./install/asdf.sh

../dotfiles_work.git/install.sh
