#!/usr/bin/env bash
set -euo pipefail

url="${1:-:}"
db="$HOME/Library/Group Containers/group.com.apple.calendar/Calendar.sqlitedb"

events="
    select
        datetime(start_date + 978307200, 'unixepoch', 'localtime') as date,
        summary,
        url
    from CalendarItem
    where url like '%$url%'
    order by start_date;
"

sqlite3 "$db" "$events"

# Archived functions

set_event_url_by_title() {
    local title="$1"
    local url="$2"
    local sql="update CalendarItem set url = '$url' where summary = '$title';"

    sqlite3 "$db" "$sql"
}

remove_event_alarms_by_title() {
    local title="$1"
    local sql="delete from alarm where calendaritem_owner_id in (select rowid from CalendarItem where summary = '$title');"

    sqlite3 "$db" "$sql"
}
