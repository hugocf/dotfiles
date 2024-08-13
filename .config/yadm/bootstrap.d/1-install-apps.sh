#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

readonly CONFIG="$BASEDIR/../.."
readonly BREWFILES="$CONFIG/homebrew/Brewfile.core $CONFIG/homebrew/Brewfile.temp $CONFIG/work/Brewfile"

main() {
    h1 "Applications"
    install_apps
    setup_post_install
    cleanup_apps
}

install_apps() {
    h2 "Homebrew Instalation"
    cat $BREWFILES | brew bundle install --file=-
}

setup_post_install() {
    h2 "Post-install Setup"
    setup_xcode_directory
    setup_xcode_license
    setup_things_helper
}

setup_xcode_directory() {
    local current_path target_path
    current_path=$(xcode-select --print-path)
    target_path="/Applications/Xcode.app/Contents/Developer"

    if [[ "$current_path" == "$target_path" ]]; then 
        echo "Xcode developer directory set correctly"
    else
        echo "Xcode developer directory needs changing..."
        sudo xcode-select --switch $target_path
    fi
}

setup_xcode_license() {
    local xcode_version accepted_version
    xcode_version=$(xcodebuild -version | grep Xcode | cut -d' ' -f2)
    accepted_version=$(defaults read /Library/Preferences/com.apple.dt.Xcode IDEXcodeVersionForAgreedToGMLicense)
    
    if [[ "$xcode_version" == "$accepted_version" ]]; then 
        echo "Xcode license is accepted"
    else
        echo "Xcode license needs acceptance..."
        sudo xcodebuild -license accept
    fi
}

setup_things_helper() {
    if [[ -e "/Applications/ThingsMacSandboxHelper.app" ]]; then
        echo "Things Helper needs setup..."
        open /Applications/ThingsMacSandboxHelper.app
    fi
}

cleanup_apps() {
    h2 "Homebrew Cleanup"
    # returns $? = 0 (success) if there’s nothing to clean up
    if cat $BREWFILES | brew bundle cleanup --file=-; then
        echo "Nothing to cleanup"
    else
        read -r -p "Are you sure to proceed with the listed uninstalls? [y/N] " answer < /dev/tty
        if [[ "$answer" != "y" ]]; then
            echo "Cleanup skipped"
        else
            cat $BREWFILES | brew bundle cleanup --file=- --force
        fi
    fi
}

main "$@"
