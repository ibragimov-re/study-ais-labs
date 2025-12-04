#!/bin/bash

# LAB 3 (SCHEDULING)
# ================================


# Check for correct number of arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /absolute/path/to/dir"
    exit 1
fi

TARGET_DIR="$1"

if [[ "$TARGET_DIR" != /* ]]; then
    echo "Error: path must be absolute"
    exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: '$TARGET_DIR' is not a directory"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup.sh"

# Install cron job to run backup script every 5 minutes
CRON_JOB="*/5 * * * * $BACKUP_SCRIPT $TARGET_DIR"

# Add cron job if not already present
# -l 2>/dev/null to list current cron jobs, suppress error if none
# grep to search pattern, -v to invert match (exclude existing), -F for fixed string (not regex)
#   this removes any old line with the same backup script and adds the new one
(crontab -l 2>/dev/null | grep -v -F "$BACKUP_SCRIPT"; echo "$CRON_JOB") | crontab -

service cron start

echo "Cron backup job is installed to run every 5 minutes for directory: $TARGET_DIR"