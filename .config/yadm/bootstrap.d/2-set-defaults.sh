#!/usr/bin/env bash
set -euo pipefail

main() {
    echo -e "\n=== Set main preferences ==="
    set_system_touchid_sudo
    set_textedit_open_plain_text
}

set_system_touchid_sudo() {
    if grep -e "^auth.*pam_tid.so" /etc/pam.d/sudo_local &> /dev/null; then
        echo "Touch ID for sudo is enabled"
    else
        echo "Touch ID for sudo must be enabled..."
        sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
    fi
}

set_textedit_open_plain_text() {
    echo "TextEdit open as plain text"
    defaults write com.apple.TextEdit RichText 0
}

main "$@"
