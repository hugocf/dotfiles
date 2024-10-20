#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

readonly BREWFILES="$CONFIG/homebrew/Brewfile.core $CONFIG/homebrew/Brewfile.temp $CONFIG/work/Brewfile"

main() {
    h1 "Applications"
    setup_xcode_license
    install_apps
    setup_post_install
    install_myrepos
    cleanup_apps
}

install_apps() {
    h2 "Homebrew Instalation"
    cat $BREWFILES | brew bundle install --file=-
}

setup_post_install() {
    h2 "Post-install Setup"
    remove_quarantines
    setup_1password_cli
    setup_things_helper
    setup_xcode_directory
}

remove_quarantines() {
    remove_from_app() {
        local full_path=$1
        xattr -r -d com.apple.quarantine "$full_path"
    }

    echo "Remove quarantine from apps"
    remove_from_app "/Applications/GitX.app"
    remove_from_app "/Applications/QLMarkdown.app"
    remove_from_app "/Applications/Syntax Highlight.app"
}

setup_1password_cli() {
    if [[ -n "$(op account list)" ]]; then
        echo "1Password integrated with CLI"
    else
        echo "1Password integration with CLI needed..."
        echo -e "\t${bold}1Password Settings${reset}"
        echo -e "\tDeveloper ➤ ${bold}ON${reset} Integrate with 1Password CLI"
        pause
    fi
}

# FIXME: Seems like this is failing on an upgrade; manual fix is: brew reinstall thingsmacsandboxhelper
setup_things_helper() {
    if [[ -e "/Applications/ThingsMacSandboxHelper.app" ]]; then
        echo "Things Helper needs setup..."
        open /Applications/ThingsMacSandboxHelper.app
    fi
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

install_myrepos() {
    echo "Checkout common local repos"
    cd "$HOME_REL"/Documents && mr update
}

cleanup_apps() {
    h2 "Homebrew Cleanup"
    # returns $? = 0 (success) if there’s nothing to clean up
    if cat $BREWFILES | brew bundle cleanup --file=-; then
        echo "Nothing to cleanup"
    else
        confirm_action "Are you sure to proceed with the listed uninstalls?" \
            "cat $BREWFILES | brew bundle cleanup --file=- --force" \
            "echo Cleanup skipped"
    fi
}

main "$@"