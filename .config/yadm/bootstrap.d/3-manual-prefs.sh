#!/usr/bin/env bash
set -euo pipefail

main() {
    echo -e "\n=== Settings (manual) ==="
    set_1password_settings
    echo
}

set_1password_settings() {
    echo -e "\n--- 1Password Settings ---"
    echo "General   ➤ Show Quick Access: ⌃ ⌥ ⌘ P"
    echo "Security  ➤ Touch ID: ON"
    echo "          ➤ Apple Watch: ON"
    echo "          ➤ Hold Option to toggle revelead fields: ON"
    echo "Privacy   ➤ Check for vulnerable passwords: ON"
    echo "Developer ➤ Use the SSH Agent: ON"
}

main "$@"
