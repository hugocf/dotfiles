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
    echo "Security  ➤ Touch ID: ${bold}ON${reset}"
    echo "          ➤ Apple Watch: ${bold}ON${reset}"
    echo "          ➤ Hold Option to toggle revelead fields: ${bold}ON${reset}"
    echo "Privacy   ➤ Check for vulnerable passwords: ${bold}ON${reset}"
    echo "Developer ➤ Use the SSH Agent: ${bold}ON${reset}"
    echo "          ➤ Integrate with 1Password CLI: ${bold}ON${reset}"

    h2 "1Password Chrome Extension"
    echo "Chrome Profile [each] ➤ chrome://extensions/shortcuts"
    echo "                      ➤ Activate the extension: ${bold}⇧ ⌘ P${reset}"
}

main "$@"
