# fix-icon

Cleans up macOS `Icon\r` files from Git repos.

## Background

macOS creates a hidden file named `Icon` + carriage return (ASCII 13) inside any folder that has a custom icon set. These files are invisible in Finder but show up in Git and cause errors in GitHub Desktop. This tool deletes them.

## How it works

`clean-icons.applescript` scans a hard-coded list of directories, finds any `Icon\r` files using `find`, deletes them, and shows a native dialog with the count. No terminal window.

## Deploying for a non-technical user

1. Edit `myDirectories` at the top of `clean-icons.applescript` with the correct folder paths
2. Open the file in Script Editor (Applications > Utilities > Script Editor)
3. File > Export… > File Format: **Application**
4. Save the `.app` to the user's Desktop
5. User double-clicks it — dialog appears, done

## Re-deploying after path changes

Same steps: edit the list, re-export, overwrite the `.app` on the Desktop.
