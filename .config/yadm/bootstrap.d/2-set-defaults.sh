#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

main() {
    h1 "Automatic Defaults"
    set_system_settings
    set_application_settings
    force_settings_reload
}

set_system_settings() {
    h2 "System Settings"
    system_character_palette_categories
    system_lock_screen_message
    system_touchid_sudo
}

system_character_palette_categories() {
    echo "Character Palette categories reset"
    # Adding to the default: MusicalSymbols, SignStandardSymbols, TechnicalSymbols
    defaults write com.apple.CharacterPaletteIM CVActiveCategories -array \
        "Category-Emoji" \
        "Category-Arrows" \
        "Category-Bullets" \
        "Category-CurrencySymbols" \
        "Category-Latin" \
        "Category-LetterlikeSymbols" \
        "Category-MathematicalSymbols" \
        "Category-MusicalSymbols" \
        "Category-Parentheses" \
        "Category-Pictographs" \
        "Category-Punctuation" \
        "Category-SignStandardSymbols" \
        "Category-TechnicalSymbols"
}

system_lock_screen_message() {
    local default_msg current_msg
    default_msg=$(op inject --in-file "$CONFIG/system/lock-message")
    current_msg=$(defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText 2> /dev/null || echo "") # No error if it was deleted
    if [[ "$default_msg" == "$current_msg" ]]; then
        echo "Lock screen message already set as intended"
    else
        echo "Lock screen message needs resetting..."
        sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$default_msg"
    fi
}

system_touchid_sudo() {
    if grep -e "^auth.*pam_tid.so" /etc/pam.d/sudo_local &> /dev/null; then
        echo "Touch ID for sudo is enabled"
    else
        echo "Touch ID for sudo must be enabled..."
        sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
    fi
}

set_application_settings() {
    h2 "Application Settings"
    app_gitx_settings
    app_textedit_open_plain_text
}

app_gitx_settings() {
    echo "GitX commit message lines and auto update"
    defaults write net.phere.GitX PBCommitMessageViewVerticalBodyLineLength 69
    defaults write net.phere.GitX PBCommitMessageViewVerticalLineLength 72
    defaults write net.phere.GitX SUEnableAutomaticChecks 1
}

app_textedit_open_plain_text() {
    echo "TextEdit default to plain text"
    defaults write com.apple.TextEdit RichText 0
}

force_settings_reload() {
    killall sighup cfprefsd
}

main "$@"
