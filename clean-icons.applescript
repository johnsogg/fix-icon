-- CleanIcons.applescript
--
-- Finds and deletes macOS "Icon\r" files that cause Git errors.
--
-- HOW TO DEPLOY:
--   1. Edit the 'myDirectories' list below with the correct folder paths
--   2. Open this file in Script Editor (Applications > Utilities > Script Editor)
--   3. File > Export… > File Format: Application
--   4. Save the exported app to the Desktop

-- Hard-coded list of Git project folders to clean
set myDirectories to {¬
    "/Users/april/Documents/projects/repo1", ¬
    "/Users/april/Documents/projects/repo2"¬
}

set deletedCount to 0
set skippedDirs to {}
set errorMessages to {}

repeat with dirPath in myDirectories
    -- Skip directories that don't exist
    try
        do shell script "test -d " & quoted form of dirPath
    on error
        set skippedDirs to skippedDirs & {dirPath}
        -- continue to next iteration
        set dirPath to ""
    end try

    if dirPath is not "" then
        try
            -- Count matching files first
            set countStr to do shell script "find " & quoted form of dirPath & " -type f -name $'Icon\\r' | wc -l | tr -d ' '"
            set fileCount to countStr as integer
            if fileCount > 0 then
                do shell script "find " & quoted form of dirPath & " -type f -name $'Icon\\r' -delete"
                set deletedCount to deletedCount + fileCount
            end if
        on error errMsg
            set errorMessages to errorMessages & {dirPath & ": " & errMsg}
        end try
    end if
end repeat

-- Build summary message
if deletedCount = 0 then
    set msg to "No Icon files found — nothing to clean."
else if deletedCount = 1 then
    set msg to "Cleaned 1 Icon file."
else
    set msg to "Cleaned " & deletedCount & " Icon files."
end if

if (count of skippedDirs) > 0 then
    set msg to msg & return & return & "Skipped (folder not found):"
    repeat with d in skippedDirs
        set msg to msg & return & "  • " & d
    end repeat
end if

if (count of errorMessages) > 0 then
    set msg to msg & return & return & "Errors:"
    repeat with e in errorMessages
        set msg to msg & return & "  • " & e
    end repeat
    display dialog msg buttons {"OK"} default button "OK" with icon caution with title "Clean Icons"
else
    display dialog msg buttons {"OK"} default button "OK" with icon note with title "Clean Icons"
end if
