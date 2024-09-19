#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

main() {
    h1 "Manual Settings"
    confirm_action "Do you want to review all manual settings?" \
        "all_manual_settings" \
        "echo Manual settings skipped"
    echo
}

all_manual_settings() {
    set_1password_settings
    set_notes_settings
    set_shortcuts_settings
}

set_1password_settings() {
    h2 "1Password"
    echo "General   ➤ Show Quick Access: ${bold}⌃ ⌥ ⌘ P${reset}"
    echo "Security  ➤ ${bold}ON${reset} Touch ID"
    echo "          ➤ ${bold}ON${reset} Apple Watch"
    echo "          ➤ ${bold}ON${reset} Hold Option to toggle revelead fields"
    echo "Privacy   ➤ ${bold}ON${reset} Check for vulnerable passwords"
    echo "Developer ➤ ${bold}ON${reset} Use the SSH Agent"
    echo "          ➤ ${bold}ON${reset} Integrate with 1Password CLI"
    echo "[Create a New Password]"
    echo "          ➤ Characters: ${bold}32${reset} "
    echo "          ➤ Symbols:    ${bold}ON${reset} "

    h2 "1Password Chrome Extension"
    echo "Chrome Profile [each] ➤ chrome://extensions/shortcuts"
    echo "                      ➤ Activate the extension: ${bold}⇧ ⌘ P${reset}"
}

set_notes_settings() {
    h2 "Notes"
    echo "Settings  ➤ Sort notes by: ${bold}Title${reset}"
    echo "          ➤ ${bold}ON${reset} Use Touch ID [use same pwd as personal login]"
}

set_shortcuts_settings() {
    h2 "Shortcuts"
    echo "Advanced  ➤ ${bold}ON${reset} Allow Running Scripts"
}

main "$@"
