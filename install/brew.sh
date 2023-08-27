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

install_mac_app_store_cli() {
    brew install --quiet "mas"
}

install_xcode_and_license() {
    mas install 497799835
    echo "Agreeing to the Xcode license"
    sudo xcodebuild -license accept
}

install_apps () {
    install_mac_app_store_cli
    install_xcode_and_license
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
