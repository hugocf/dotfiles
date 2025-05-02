#!/usr/bin/env bash
set -euo pipefail

readonly DB="$HOME/Library/Group Containers/group.com.apple.calendar/Calendar.sqlitedb"
readonly NSDATE_DELTA=978307200

main() {
    local usage="Usage: $(basename $0) command [args...]

    get_events_by_url <url>

This script requires sqlite3 and assumes the calendar database is located at: $DB"

    if [ $# -eq 0 ]; then
        echo "$usage"
        exit 1
    fi

    local command="$1"
    shift

    case "$command" in
        get_events_by_url)
            get_events_by_url "$@"
            ;;
        *)
            echo "Invalid command: $command"
            echo "$usage"
            exit 1
            ;;
    esac
}

get_events_by_url() {
    local url="${1:-:}"
    local sql="
        select
            rowid,
            datetime(start_date + $NSDATE_DELTA, 'unixepoch', 'localtime') as date,
            datetime(last_modified + $NSDATE_DELTA, 'unixepoch', 'localtime') as date,
            summary,
            url
        from CalendarItem
        where url like '%$url%'
        order by start_date;
    "
    sqlite3 "$DB" "$sql"
}

main "$@"
