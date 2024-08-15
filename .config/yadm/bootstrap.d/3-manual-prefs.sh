#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

main() {
    h1 "Manual Settings"
    read -r -p "Do you want to review all manual settings? [y/N] " answer < /dev/tty
    if [[ "$answer" != "y" ]]; then
        echo "Manual settings skipped"
    else
        set_1password_settings
    fi
    echo
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

    h2 "1Password Chrome Extension"
    echo "Chrome Profile [each] ➤ chrome://extensions/shortcuts"
    echo "                      ➤ Activate the extension: ${bold}⇧ ⌘ P${reset}"
}

main "$@"
