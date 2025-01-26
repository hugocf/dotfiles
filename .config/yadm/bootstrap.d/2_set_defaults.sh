#!/usr/bin/env bash
set -eo pipefail
# FIXME: Had to remove -u because dock_apps_remove_after() give error "to_remove[@]: unbound variable"

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
    system_desktop_options
    system_dock_options
    system_dock_layout
    system_lock_screen_message
    system_touchid_sudo
}

system_character_palette_categories() {
    echo "Character Palette categories reset"
    # Adding to the default: MusicalSymbols, SignStandardSymbols, TechnicalSymbols
    defaults write com.apple.CharacterPaletteIM CVActiveCategories -array \
        "Category-Emoji" \
        "Category-Arrows" \
        "Category-Bullets" \
        "Category-CurrencySymbols" \
        "Category-Latin" \
        "Category-LetterlikeSymbols" \
        "Category-MathematicalSymbols" \
        "Category-MusicalSymbols" \
        "Category-Parentheses" \
        "Category-Pictographs" \
        "Category-Punctuation" \
        "Category-SignStandardSymbols" \
        "Category-TechnicalSymbols"
}

system_desktop_options() {
    echo "Desktop options set"
    defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
    defaults write -globalDomain AppleSpacesSwitchOnActivate -bool false
}

system_dock_options() {
    dock_corner_off() {
        local pos=$1
        defaults write com.apple.dock "wvous-$pos-corner"   1
        defaults write com.apple.dock "wvous-$pos-modifier" 0
    }

    dock_corner_desktop() {
        local pos=$1
        defaults write com.apple.dock "wvous-$pos-corner"   4
        defaults write com.apple.dock "wvous-$pos-modifier" 0
    }

    dock_magnification() {
        local on=$1
        local size=$([[ $on == true ]] && echo 128 || echo 64)
        defaults write com.apple.dock largesize $size
        defaults write com.apple.dock magnification -bool $on
    }

    echo "Dock options set"
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock mru-spaces -bool false
    dock_corner_off     "bl"
    dock_corner_desktop "br"
    dock_corner_off     "tl"
    dock_corner_off     "tr"
    dock_magnification true
}

system_dock_layout() {
    dock_cmd() {
        dockutil --no-restart "$@"
    }

    dock_app_set() {
        local pos desktop path
        local "$@"
        if dock_cmd --find "$path" &>/dev/null; then
            dock_cmd --move "$path" --position "$pos"
        else
            dock_cmd --add "$path" --position "$pos"
        fi
        manually_assign "$desktop" "$path"
    }

    manually_assign() {
        local desktop=$1
        local path=$2
        desktop_name=$([[ -z $desktop ]] && echo "None     " || echo "Desktop $desktop")
        app_name=$(remove_extension "$(remove_path "$path")")
        echo "    $desktop_name ← $app_name"
    }

    dock_apps_remove_after() {
        local pos
        local "$@"
        local all_apps=($(dockutil --list | grep persistentApps | cut -d$'\t' -f2))
        local to_remove=("${all_apps[@]:$pos}")
        for app in "${to_remove[@]}"; do
            dock_cmd --remove "$app"
        done
    }

    dock_folder_set() {
        local pos sort display view path
        local "$@"
        if dock_cmd --find "$path" &>/dev/null; then
            dock_cmd --move "$path" --position "$pos"
        else
            dock_cmd --add "$path" --position "$pos" --sort "$sort" --display "$display" --view "$view"
        fi
    }

    echo "Dock layout reset"
    dock_app_set pos=1  desktop=  path="/Applications/Google Chrome.app"
    dock_app_set pos=2  desktop=2 path="/System/Applications/Music.app"
    dock_app_set pos=3  desktop=2 path="/System/Applications/Calendar.app"
    dock_app_set pos=4  desktop=2 path="/System/Applications/Notes.app"
    dock_app_set pos=5  desktop=2 path="/System/Applications/Contacts.app"
    dock_app_set pos=6  desktop=2 path="/Applications/Things3.app"
    dock_app_set pos=7  desktop=2 path="/Applications/OfficeTime.app"
    dock_app_set pos=8  desktop=3 path="/System/Applications/Mail.app"
    dock_app_set pos=9  desktop=4 path="/System/Applications/Messages.app"
    dock_app_set pos=10 desktop=4 path="/Applications/Slack.app"
    dock_app_set pos=11 desktop=  path="/Applications/Visual Studio Code.app"
    dock_apps_remove_after pos=11
    dock_folder_set pos=1 sort=name      display=folder view=list path="/Users/Shared/Library Data"
    dock_folder_set pos=2 sort=name      display=stack  view=list path="/Users/hugo/Work/NewStore"
    dock_folder_set pos=3 sort=name      display=folder view=list path="/Users/hugo"
    dock_folder_set pos=4 sort=name      display=folder view=list path="/Users/hugo/Documents"
    dock_folder_set pos=5 sort=dateadded display=stack  view=fan  path="/Users/hugo/Downloads"
    dock_folder_set pos=6 sort=name      display=stack  view=list path="/Users/hugo/Cloud"
}

system_lock_screen_message() {
    local default_msg current_msg
    default_msg=$(op inject --in-file "$CONFIG/system/lock-message")
    current_msg=$(defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText 2> /dev/null || echo "") # No error if it was deleted
    if [[ "$default_msg" == "$current_msg" ]]; then
        echo "Lock screen message already set as intended"
    else
        echo "Lock screen message needs resetting..."
        sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$default_msg"
    fi
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
    app_gitx_settings
    app_textedit_open_plain_text
}

app_gitx_settings() {
    echo "GitX commit message lines and auto update"
    defaults write net.phere.GitX PBCommitMessageViewVerticalBodyLineLength 69
    defaults write net.phere.GitX PBCommitMessageViewVerticalLineLength 72
    defaults write net.phere.GitX SUEnableAutomaticChecks 1
}

app_textedit_open_plain_text() {
    echo "TextEdit default to plain text"
    defaults write com.apple.TextEdit RichText 0
}

force_settings_reload() {
    killall sighup cfprefsd
    killall Dock
}

main "$@"
