set target to "Pessoal"
set oldURL to "https://youtube.com"
set newURL to "https://www.youtube.com"

with timeout of 1800 seconds
    tell application "Calendar"
        set updatedCount to 0

        my logProgress("Loading...", "Currently", 0)
        set eventList to every event of calendar target
        my logProgress("Loaded!", "Retrieved", count of eventList)

        repeat with e in eventList
            try
                if (url of e) is oldURL then
                    set url of e to newURL

                    set updatedCount to updatedCount + 1
                    if (updatedCount mod 10) is 0 then
                        my logProgress("Working…", "Updated", updatedCount)
                    end if
                end if
            on error msg number num
                log "Error in event " & (uid of e) & ": " & msg & " (" & num & ")"
            end try
        end repeat

        my logProgress("Done!", "Updated", updatedCount)
    end tell
end timeout

on logProgress(msg, action, value)
    set currentTime to time string of (current date)
    log currentTime & " " & msg & " " & action & " " & value & " events."
end logProgress
