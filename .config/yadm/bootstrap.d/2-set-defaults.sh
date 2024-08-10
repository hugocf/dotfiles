#!/usr/bin/env bash
set -euo pipefail

main() {
    echo -e "\n=== Set main preferences ==="
    set_system_settings
    set_application_preferences
}

set_system_settings() {
    echo -e "\n--- System Settings ---"
    set_system_touchid_sudo
}

set_system_touchid_sudo() {
    if grep -e "^auth.*pam_tid.so" /etc/pam.d/sudo_local &> /dev/null; then
        echo "Touch ID for sudo is enabled"
    else
        echo "Touch ID for sudo must be enabled..."
        sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
    fi
}

set_application_preferences() {
    echo -e "\n--- Application Preferences ---"
    set_choosy_preferences
    set_maccy_preferences
    set_textedit_open_plain_text
}

set_choosy_preferences() {
    echo "Choosy preferences"
    defaults write com.choosyosx.Choosy displayMenuBarItem 0
    defaults write com.choosyosx.Choosy launchAtLogin 1
}

set_maccy_preferences() {
    echo "Maccy preferences"
    defaults write org.p0deje.Maccy imageMaxHeight 16
    defaults write org.p0deje.Maccy pasteByDefault 1
    defaults write org.p0deje.Maccy searchMode fuzzy
    defaults write org.p0deje.Maccy showInStatusBar 0
    defaults write org.p0deje.Maccy SUEnableAutomaticChecks 1
    # ctrl-alt-v
    defaults write org.p0deje.Maccy KeyboardShortcuts_popup -string '{"carbonKeyCode":9,"carbonModifiers":6144}'
}

set_textedit_open_plain_text() {
    echo "TextEdit default to plain text"
    defaults write com.apple.TextEdit RichText 0
}

main "$@"
