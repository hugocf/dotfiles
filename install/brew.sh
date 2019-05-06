#!/usr/bin/env bash
set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

readonly BREWFILE="$BASEDIR"/Brewfile

# https://brew.sh
if ! type brew &> /dev/null; then
    echo -e "\n=== Install homebrew ==="
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

install_apps () {
    brew bundle install --file="$BREWFILE"
}

cleanup_apps () {
    brew bundle cleanup --file="$BREWFILE"
    read -p "Are you sure to proceed with cleanup? [y/N] " answer
    if [[ "$answer" == "y" ]]; then
        brew bundle cleanup --file="$BREWFILE" --force
    else
        echo "Skipping..."
    fi
}

# Do the work
echo -e "\n=== Install brew apps ==="
install_apps
cleanup_apps
