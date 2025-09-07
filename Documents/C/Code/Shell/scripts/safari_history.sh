#!/usr/bin/env bash
set -euo pipefail

readonly DEFAULT_HISTORY_DB="$HOME/Library/Safari/History.db"
readonly SAFARI_TABS_DB="$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/SafariTabs.db"
readonly PROFILES_DIR="$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/Profiles"
readonly ROWS_DEFAULT=20

readonly COLUMN_MAX_LEN=90
readonly COLUMN_SEP="§"
readonly COLUMN_DATE="date visited"
readonly COLUMN_PROFILE="profile name"
readonly COLUMN_DOMAIN="domain expansion"
readonly COLUMN_URL="url address"
readonly COLUMN_TITLE="page title"

main() {
    local mode rows
    rows=$ROWS_DEFAULT

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -m|--merged)    mode="merged"; shift ;;
            -p|--profile)   mode="profile"; shift ;;
            -h|--help)      usage; shift ;;
            *)
                if [[ "$1" =~ ^[0-9]+$ ]]; then
                    rows="$1"; shift
                else
                    echo "Unknown argument: $1" >&2
                    usage 1
                fi ;;
        esac
    done

    case "$mode" in
        profile) show_history_profile "$rows" ;;
        *) show_history_merged "$rows"
    esac
}

usage() {
    local cmd="${BASH_SOURCE[0]##*/}"
    echo "Show last Safari history with timestamps.

Usage:
    $cmd [-m | --merged | -p | --profile] [rows]

    -m | --merged   Merged view across all profiles (default)
    -p | --profile  Grouped view, one table per profile
    rows            Number of rows of history to display per profile (default $ROWS_DEFAULT)

Example:
    $cmd -p 5"
    exit "${1:-0}"
}

show_history_profile() {
    local rows="$1"

    show_history_for_profile "$rows" "Default" "$DEFAULT_HISTORY_DB"
    list_profiles | while IFS="$COLUMN_SEP" read -r profile uuid; do
        show_history_for_profile "$rows" "$profile" "$PROFILES_DIR/$uuid/History.db"
    done
}

show_history_for_profile() {
    local rows="$1"
    local profile="$2"
    local db="$3"

    h1 "$profile"
    if [[ -f "$db" ]]; then
        sqlite3 -batch -init /dev/null -column -header "$db" "$(show_history_sql "$rows")"
    else
        echo "No History.db found for profile: $profile ($db)"
    fi
}

h1() {
    local bold=$(tput bold)
    local invert=$(tput setaf 0; tput setab 7)
    local reset=$(tput sgr0)
    echo -e "\n${bold}${invert} === $* === ${reset}"
}

show_history_merged() {
    local rows="$1"
    local tmp_table

    tmp_table=$(mktemp)
    create_table_data "$rows" "$tmp_table"
    show_full_table "$tmp_table"
    rm "$tmp_table"
}

create_table_data() {
    local rows="$1"
    local file="$2"

    show_history_for_merge "$rows" "Default" "$DEFAULT_HISTORY_DB" > "$file"
    list_profiles | while IFS="$COLUMN_SEP" read -r profile uuid; do
        show_history_for_merge "$rows" "$profile" "$PROFILES_DIR/$uuid/History.db" >> "$file"
    done
}

show_history_for_merge() {
    local rows="$1"
    local profile="$2"
    local db="$3"

    if [[ -f "$db" ]]; then
        sqlite3 -batch -init /dev/null -separator "$COLUMN_SEP" "$db" "$(show_history_sql "$rows")"
    else
        echo "No History.db found for profile: $profile ($db)"
    fi
}

show_history_sql() {
    local rows="$1"
    echo "
        select
            datetime(v.visit_time + 978307200, 'unixepoch', 'localtime') as '$COLUMN_DATE',
            '$profile' as '$COLUMN_PROFILE',
            i.domain_expansion as 'domain expansion',
            case when length(i.url) > $COLUMN_MAX_LEN then substr(i.url, 1, $COLUMN_MAX_LEN) || '...' else i.url end as 'url address',
            case when length(v.title) > $COLUMN_MAX_LEN then substr(v.title, 1, $COLUMN_MAX_LEN) || '...' else v.title end as 'page title'
        from history_items i left join history_visits v on i.id = v.history_item
        order by i.id desc
        limit $rows;
    "
}

list_profiles() {
    sqlite3 -batch -init /dev/null -separator "$COLUMN_SEP" "$SAFARI_TABS_DB" "
        select title, external_uuid
        from bookmarks
        where type=1 and subtype=2 and title <> '';
    "
}

show_full_table() {
    local file="$1"
    {
        table_header
        sort -r "$file"
    } | sed "s/$COLUMN_SEP$COLUMN_SEP/$COLUMN_SEP $COLUMN_SEP/g" | column -t -s "$COLUMN_SEP"
}

table_header() {
    dash() {
        printf '%*s' ${#1} | tr ' ' '-'
    }
    # shellcheck disable=SC2116
    echo "$(echo "$COLUMN_DATE")$COLUMN_SEP$(echo "$COLUMN_PROFILE")$COLUMN_SEP$(echo "$COLUMN_DOMAIN")$COLUMN_SEP$(echo "$COLUMN_URL")$COLUMN_SEP$(echo "$COLUMN_TITLE")"
    echo "$(dash "$COLUMN_DATE")$COLUMN_SEP$(dash "$COLUMN_PROFILE")$COLUMN_SEP$(dash "$COLUMN_DOMAIN")$COLUMN_SEP$(dash "$COLUMN_URL")$COLUMN_SEP$(dash "$COLUMN_TITLE")"
}

main "$@"
