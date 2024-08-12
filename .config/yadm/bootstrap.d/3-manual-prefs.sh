#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

main() {
    h1 "Settings (manual)"
    set_1password_settings
    echo
}

set_1password_settings() {
    h2 "1Password Settings"
    echo "General   ➤ Show Quick Access: ${bold}⌃ ⌥ ⌘ P${reset}"
    echo "Security  ➤ Touch ID: ${bold}ON${reset}"
    echo "          ➤ Apple Watch: ${bold}ON${reset}"
    echo "          ➤ Hold Option to toggle revelead fields: ${bold}ON${reset}"
    echo "Privacy   ➤ Check for vulnerable passwords: ${bold}ON${reset}"
    echo "Developer ➤ Use the SSH Agent: ${bold}ON${reset}"
}

main "$@"
