#!/usr/bin/env bash
set -euo pipefail

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
source "$BASEDIR/../common"

# Note: See functions `osascript_debug_anchors` and `osascript_debug_elements` for AppleScript inspection

main() {
    h1 "Manual Settings"
    confirm_action "Do you want to review all manual settings?" \
        "all_manual_settings" \
        "echo Manual settings skipped"
    echo
}

all_manual_settings() {
    review_system_settings
    review_1password_settings
    review_chrome_settings
    review_contacts_settings
    review_facetime_settings
    review_notes_settings
    review_shortcuts_settings
    review_slack_settings
}

review_system_settings() {
    h2 "System Settings"

    echo "Accessibility ➤ Zoom"
    echo "              ➤ ${bold}ON${reset} Use scroll gesture with modifier keys to zoom"
    open "x-apple.systempreferences:com.apple.preference.universalaccess?Zoom"
    pause

    echo "Desktop & Dock ➤ Hot Corners"
    echo "              ➤ [ ${bold}—${reset} ]    [ ${bold}—${reset} ]"
    echo "              ➤ [ ${bold}—${reset} ]    [ ${bold}Desktop${reset} ]"
    open "x-apple.systempreferences:com.apple.preference.dock"
    pause

    echo "Time Machine  ➤ Options…"
    echo "              ➤ Backup Frequency: ${bold}Automatically Every Hour${reset}"
    open_time_machine_options
    pause
}

open_time_machine_options() {
    /usr/bin/osascript -e '
    tell application "System Settings"
        activate
        delay 0.5
        reveal anchor "main" of pane id "com.apple.Time-Machine-Settings.extension"
        delay 0.5
    end tell
    # Click the "Options…" button
    tell application "System Events" to tell process "System Settings"
        click button 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1
    end tell
    return -- silence output to terminal
    '
}

review_1password_settings() {
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

review_chrome_settings() {
    h2 "Chrome"
    echo "Chrome Profile [each]"
    echo "chrome://password-manager/settings"
    echo "Settings      ➤ ${bold}OFF${reset} Offer to save passwords and passkeys"
}

review_contacts_settings() {
    h2 "Contacts"
    echo "General       ➤ Sort By: ${bold}First Name${reset}"
    echo "              ➤ Short Name Format: ${bold}Full Name${reset}"
    echo "              ➤ ${bold}OFF${reset} Prefer nicknames"
    echo "              ➤ Address Format: Portugal"
    echo "              ➤ Default Account: iCloud"
    echo
    echo "Template      ➤ First    Middle    Last"
    echo "              ➤ Job Title    Department"
    echo "              ➤ Company"
    echo "              ➤ mobile: Phone"
    echo "              ➤ work: Email"
    echo "              ➤ home page: URL"
    echo "              ➤ birthday: day/month/year"
    echo "              ➤ daughter: Related Name"
    echo "              ➤ son: Related Name"
    echo "              ➤ LinkedIn: Username"
    echo "              ➤ work: Address"
    echo "              ➤ home: Address"
    open_contacts_settings
    pause
}

open_contacts_settings() {
    /usr/bin/osascript -e '
    tell application "Contacts" to activate
    tell application "System Events" to tell process "Contacts"
        click menu item "Settings…" of menu "Contacts" of menu bar 1
    end tell
    return -- silence output to terminal
    '
}

review_facetime_settings() {
    if [[ "$(yadm config --get local.class)" == "Work" ]]; then
        h2 "FaceTime"
        echo "General   ➤ ${bold}OFF${reset} Calls From iPhone"
    fi
}

review_notes_settings() {
    h2 "Notes"
    echo "Settings      ➤ Sort notes by: ${bold}Title${reset}"
    echo "              ➤ ${bold}ON${reset} Use Touch ID [use same pwd as personal login]"
}

review_shortcuts_settings() {
    h2 "Shortcuts"
    echo "Advanced      ➤ ${bold}ON${reset} Allow Running Scripts"
}

review_slack_settings() {
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
