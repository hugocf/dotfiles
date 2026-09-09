#!/usr/bin/env bash
set -euo pipefail

readonly DB="$HOME/Library/Group Containers/group.com.apple.calendar/Calendar.sqlitedb"
readonly NSDATE_DELTA=978307200

main() {
    local usage="Usage: $(basename $0) command [args...]

    get_events_by_url <url>
    get_events_by_summary <text>
    get_events_with_nbspace
    fix_events_with_nbspace

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
        get_events_by_summary)
            get_events_by_summary "$@"
            ;;
        get_events_with_nbspace)
            get_events_with_nbspace "$@"
            ;;
        fix_events_with_nbspace)
            fix_events_with_nbspace "$@"
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
            uuid,
            datetime(start_date + $NSDATE_DELTA, 'unixepoch', 'localtime') as start_date,
            datetime(last_modified + $NSDATE_DELTA, 'unixepoch', 'localtime') as modified_date,
            summary,
            url
        from CalendarItem
        where url like '$url'
        order by start_date;
    "
    sqlite3 "$DB" "$sql"
}

get_events_by_summary() {
    local summary="${1:-:}"
    local sql="
        select
            rowid,
            uuid,
            datetime(start_date + $NSDATE_DELTA, 'unixepoch', 'localtime') as start_date,
            datetime(last_modified + $NSDATE_DELTA, 'unixepoch', 'localtime') as modified_date,
            summary
        from CalendarItem
        where summary like '%$summary%'
        order by start_date;
    "
    sqlite3 "$DB" "$sql"
}

get_events_with_nbspace() {
    local sql="
        select
            rowid,
            uuid,
            datetime(start_date + $NSDATE_DELTA, 'unixepoch', 'localtime') as start_date,
            datetime(last_modified + $NSDATE_DELTA, 'unixepoch', 'localtime') as modified_date,
            replace(summary, char(160), '🁢') as summary
        from CalendarItem
        where summary like '%' || char(160) || '%'
        order by start_date;
    "
    sqlite3 "$DB" "$sql"
}

fix_events_with_nbspace() {
    local sql="
        update CalendarItem
        set summary = replace(summary, char(160), ' ')
        where summary like '%' || char(160) || '%';
    "
    sqlite3 "$DB" "$sql"
    get_events_with_nbspace
}

main "$@"
