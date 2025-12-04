#!/bin/bash

# LAB 2 (BACKUP)
# ================================


path="$1"
echo $path

# Create bakup output directory
backup_dir="/home/archives"
mkdir -p "$backup_dir" # -p to avoid error if dir exists

parent_dir=$(dirname "$path")
dir_name=$(basename "$path")


date=$(date +%F) # YYYY-MM-DD
time=$(date +%H:%M) # HH:MM

archive_path="$backup_dir/${dir_name}-${date}-${time}.tgz"

# Create the tar.gz archive
# -c to create, -z to compress with gzip, -f for filename
# -C to change to parent directory to avoid full path in archive
tar -czf "$archive_path" -C "$parent_dir" "$dir_name"