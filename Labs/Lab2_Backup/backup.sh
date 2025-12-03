#!/bin/bash

# LAB 2 (BACKUP)
# ================================


# Check for correct number of arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /absolute/path/to/dir"
    exit 1
fi

path="$1"

if [[ "$path" != /* ]]; then
    echo "Error: path must be absolute"
    exit 1
fi

if [[ ! -d "$path" ]]; then
    echo "Error: '$path' is not a directory"
    exit 1
fi

# Create bakup output directory
backup_dir="./archives"
mkdir -p "$backup_dir" # -p to avoid error if dir exists

parent_dir=$(dirname "$path")
dir_name=$(basename "$path")

# Infinite backup loop for every 5 minutes, without using cron or systemd
while true; do
    date=$(date +%F) # YYYY-MM-DD
    time=$(date +%H:%M) # HH:MM
    
    archive_path="$backup_dir/${dir_name}-${date}-${time}.tgz"

    # Create the tar.gz archive
    # -c to create, -z to compress with gzip, -f for filename
    # -C to change to parent directory to avoid full path in archive
    tar -czf "$archive_path" -C "$parent_dir" "$dir_name"

    echo "Backup created: $archive_path"

    sleep 300 # 5 minutes
done
