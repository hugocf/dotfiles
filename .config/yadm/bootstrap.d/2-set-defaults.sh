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
            "Category-Emoji"                \
            "Category-Arrows"               \
            "Category-Bullets"              \
            "Category-CurrencySymbols"      \
            "Category-Latin"                \
            "Category-LetterlikeSymbols"    \
            "Category-MathematicalSymbols"  \
            "Category-MusicalSymbols"       \
            "Category-Parentheses"          \
            "Category-Pictographs"          \
            "Category-Punctuation"          \
            "Category-SignStandardSymbols"  \
            "Category-TechnicalSymbols"
}

system_lock_screen_message() {
    echo "Lock screen message definition"
    local msg=$(op inject --in-file "$CONFIG/system/lock-message")
    sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$msg"
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
    app_maccy_settings
    app_textedit_open_plain_text
}

app_maccy_settings() {
    echo "Maccy settings"
    defaults write org.p0deje.Maccy imageMaxHeight 16
    defaults write org.p0deje.Maccy pasteByDefault 1
    defaults write org.p0deje.Maccy searchMode fuzzy
    defaults write org.p0deje.Maccy showInStatusBar 0
    defaults write org.p0deje.Maccy SUEnableAutomaticChecks 1
    # ctrl-alt-v
    defaults write org.p0deje.Maccy KeyboardShortcuts_popup -string '{"carbonKeyCode":9,"carbonModifiers":6144}'
}

app_textedit_open_plain_text() {
    echo "TextEdit default to plain text"
    defaults write com.apple.TextEdit RichText 0
}

force_settings_reload() {
    killall sighup cfprefsd
}

main "$@"
