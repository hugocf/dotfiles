#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly HOMEBREW="$BASEDIR/../../homebrew"
readonly BREWFILES="$HOMEBREW/Brewfile.core $HOMEBREW/Brewfile.temp $HOMEBREW/Brewfile.work"

main() {
    install_apps
    post_install_setup
    cleanup_apps
}

install_apps() {
    echo -e "\n=== Install brew apps ==="
    cat $BREWFILES | brew bundle install --file=-
}

post_install_setup() {
    setup_xcode_license
    setup_things_helper
}

setup_xcode_license() {
    echo "Agreeing to the Xcode license"
    sudo xcodebuild -license accept
}

setup_things_helper() {
    if [[ -f "/Applications/ThingsMacSandboxHelper.app" ]]; then
        open /Applications/ThingsMacSandboxHelper.app
    fi
}

cleanup_apps() {
    echo -e "\n=== Cleanup brew apps ==="
    cat $BREWFILES | brew bundle cleanup --file=-
    read -r -p "Are you sure to proceed with the listed uninstalls? [y/N] " answer
    if [[ "$answer" == "y" ]]; then
        cat $BREWFILES | brew bundle cleanup --file=- --force
    else
        echo "Skipping..."
    fi
}

main "$@"
