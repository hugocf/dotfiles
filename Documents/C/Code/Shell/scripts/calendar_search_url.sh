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
