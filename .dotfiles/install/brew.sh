#!/usr/bin/env bash
set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

readonly BREWFILE="$BASEDIR"/Brewfile

# https://brew.sh
if ! type brew &> /dev/null; then
    echo -e "\n=== Install homebrew ==="
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

install_mac_app_store_cli() {
    brew install --quiet "mas"
}

install_xcode_and_license() {
    mas install 497799835
    echo "Agreeing to the Xcode license"
    sudo xcodebuild -license accept
}

post_install_things() {
    if [[ -f "/Applications/ThingsMacSandboxHelper.app" ]]; then
        open /Applications/ThingsMacSandboxHelper.app
    fi
}

install_apps () {
    echo -e "\n=== Install brew apps ==="
    install_mac_app_store_cli
    install_xcode_and_license
    brew bundle install --file="$BREWFILE"
    post_install_things
}

cleanup_apps () {
    echo -e "\n=== Cleanup brew apps ==="
    brew bundle cleanup --file="$BREWFILE"
    read -p "Are you sure to proceed with the listed uninstalls? [y/N] " answer
    if [[ "$answer" == "y" ]]; then
        brew bundle cleanup --file="$BREWFILE" --force
    else
        echo "Skipping..."
    fi
}

# Do the work
install_apps
cleanup_apps
