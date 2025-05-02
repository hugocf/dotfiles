#!/usr/bin/env bash
set -euo pipefail

readonly DB="$HOME/Library/Group Containers/group.com.apple.calendar/Calendar.sqlitedb"
readonly NSDATE_DELTA=978307200

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

set_events_url_by_title() {
    local title="$1"
    local url="$2"
    local sql="update CalendarItem set url = '$url', last_modified = strftime('%s', 'now') - $NSDATE_DELTA where summary = '$title';"
    sqlite3 "$DB" "$sql"
}

set_events_url_by_url() {
    local old_url="$1"
    local new_url="$2"
    local sql="update CalendarItem set url = '$new_url', last_modified = strftime('%s', 'now') - $NSDATE_DELTA where url = '$old_url';"
    sqlite3 "$DB" "$sql"
}

remove_event_alarms_by_title() {
    local title="$1"
    local sql="
        delete from alarm where calendaritem_owner_id in (select rowid from CalendarItem where summary = '$title');
        update CalendarItem set last_modified = strftime('%s', 'now') - $NSDATE_DELTA  where summary = '$title';
    "
    sqlite3 "$DB" "$sql"
}

main() {
    local command="${1:-}"
    shift

    case "$command" in
        get_events_by_url)
            get_events_by_url "$@"
            ;;
        set_events_url_by_title)
            set_events_url_by_title "$@"
            ;;
        set_events_url_by_url)
            set_events_url_by_url "$@"
            ;;
        remove_event_alarms_by_title)
            remove_event_alarms_by_title "$@"
            ;;
        *)
            echo "Usage: $0 {get_events_by_url|set_event_url_by_title|remove_event_alarms_by_title} [args...]"
            exit 1
            ;;
    esac
}

main "$@"
