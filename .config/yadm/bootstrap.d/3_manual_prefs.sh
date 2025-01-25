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
    set_system_settings
    set_1password_settings
    set_chrome_settings
    set_facetime_settings
    set_notes_settings
    set_shortcuts_settings
    set_slack_settings
}

set_system_settings() {
    h2 "System Settings"
    echo "Accessibility ➤ Zoom"
    echo "              ➤ ${bold}ON${reset} Use scroll gesture with modifier keys to zoom"
    open "x-apple.systempreferences:com.apple.preference.universalaccess?Zoom"
    pause
}

set_1password_settings() {
    h2 "1Password"
    echo "General       ➤ Show Quick Access: ${bold}⌃ ⌥ ⌘ P${reset}"
    echo "Security      ➤ ${bold}ON${reset} Touch ID"
    echo "              ➤ ${bold}ON${reset} Apple Watch"
    echo "              ➤ ${bold}ON${reset} Hold Option to toggle revelead fields"
    echo "Privacy       ➤ ${bold}ON${reset} Check for vulnerable passwords"
    echo "Browser       ➤ ${bold}OFF${reset} Connect with 1Password in the browser"
    echo "Developer     ➤ ${bold}ON${reset} Use the SSH Agent"
    echo "              ➤ ${bold}ON${reset} Integrate with 1Password CLI"
    echo "[Create a New Password]"
    echo "              ➤ Characters: ${bold}32${reset} "
    echo "              ➤ Symbols:    ${bold}ON${reset} "

    h2 "1Password Chrome Extension [Installed by Your Administrator]"
    echo "Chrome Profile [each]"
    echo "chrome-extension://aeblfdkhhhdcdjpifhhbdiojplfjncoa/app/app.html#/page/settings"
    echo "Autofill …    ➤ ${bold}OFF${reset} Offer to fill and save passwords"
    echo "              ➤ ${bold}OFF${reset} Offer save and sign in with passkeys"
    echo "chrome://extensions/shortcuts"
    echo "Keyboard …    ➤ Activate the extension: ${bold}Not set${reset}"
}

set_chrome_settings() {
    h2 "Chrome"
    echo "Chrome Profile [each]"
    echo "chrome://password-manager/settings"
    echo "Settings      ➤ ${bold}OFF${reset} Offer to save passwords and passkeys"
}

set_facetime_settings() {
    if [[ "$(yadm config --get local.class)" == "Work" ]]; then
        h2 "FaceTime"
        echo "General   ➤ ${bold}OFF${reset} Calls From iPhone"
    fi
}

set_notes_settings() {
    h2 "Notes"
    echo "Settings      ➤ Sort notes by: ${bold}Title${reset}"
    echo "              ➤ ${bold}ON${reset} Use Touch ID [use same pwd as personal login]"
}

set_shortcuts_settings() {
    h2 "Shortcuts"
    echo "Advanced      ➤ ${bold}ON${reset} Allow Running Scripts"
}

set_slack_settings() {
    h2 "Slack"
    echo "Notifications ➤ My keywords: ${bold}Hugo, Ferreira${reset}"
    echo "              ➤ Allow notifications: ${bold}Weekdays${reset} ${bold}9:00${reset} to ${bold}18:00${reset} [default]"
    echo "              ➤ Notification sound (messages): ${bold}None${reset}"
    echo "              ➤ If I’m not active… ${bold}OFF${reset} Send me a mobile notification, summarising activity that I’ve missed"
    echo "Navigation    ➤ ${bold}ON${reset} Home [default]"
    echo "              ➤ ${bold}ON${reset} DMs"
    echo "              ➤ ${bold}ON${reset} Activity [default]"
    echo "              ➤ ${bold}ON${reset} Later"
    echo "              ➤ ${bold}ON${reset} People"
    echo "              ➤ ${bold}OFF${reset} (all others)"
    echo "Home          ➤ Show… ${bold}ON${reset} Unread only"
    echo "              ➤ Sort… ${bold}ON${reset} By most recent"
    echo "              ➤ ${bold}OFF${reset} Move items with unread mentions to top of sections"
    echo "              ➤ ${bold}OFF${reset} Organise external conversations into the External connections section"
    echo "              ➔ See also ${bold}https://hugo.ferreira.cc/slack-inbox/${reset}"
    echo "Appearance    ➤ Colour mode: ${bold}System${reset}"
    echo "Messages …    ➤ Emoji Customise: ${bold}👍 🙂 🙏${reset} [:simple_smile:]"
    echo "              ➤ In-line… ${bold}ON${reset} Even if they’re larger than 20 MB"
    echo "Language …    ➤ Language: ${bold}English (UK)${reset}"
    echo "Accessibility ➤ Press… ${bold}ON${reset} Move focus to the message list, only if the message field is empty [default]"
    echo "Mark as read  ➤ When I view… ${bold}ON${reset} Start me at the newest message but leave unseen messages unread"
    echo "              ➤ When I mark… ${bold}ON${reset} Prompt to confirm [default]"
    echo "Advanced      ➤ Other… ${bold}OFF${reset} Send me occasional surveys via Slackbot"
}

main "$@"
