#!/usr/bin/env bash
set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

# https://brew.sh
if ! type brew &> /dev/null; then
    echo -e "\n=== Install homebrew ==="
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Do the work
echo -e "\n=== Install brew apps ==="
brew bundle --file="$BASEDIR"/Brewfile
