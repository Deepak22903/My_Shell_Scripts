#!/bin/bash

# Check if zoxide is installed
if ! command -v zoxide &> /dev/null
then
    echo "zoxide could not be found. Please install it first."
    exit 1
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null
then
    echo "fzf could not be found. Please install it first."
    exit 1
fi

# Function to prompt for confirmation
confirm() {
    while true; do
        read -r -p "$1 (y/n): " choice
        case "$choice" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Prompt user to select source directory using fzf and zoxide
echo "Select the source directory (use fzf or zoxide shortcuts):"
source_dir=$(zoxide query -l | fzf)
if [ -z "$source_dir" ]; then
    echo "No source directory selected. Exiting."
    exit 1
fi
zoxide query "$source_dir" &> /dev/null
if [ $? -eq 0 ]; then
    cd "$(zoxide query "$source_dir")" || exit 1
    source_dir=$(pwd)
else
    echo "Invalid source directory. Using input as-is."
fi

# Confirm the source directory
if ! confirm "You selected '$source_dir' as the source directory. Is this correct?"; then
    echo "Aborting!"
    exit 1
fi

# Prompt user to select backup directory using fzf and zoxide
echo "Select the backup directory (use fzf or zoxide shortcuts):"
backup_dir=$(zoxide query -l | fzf)
if [ -z "$backup_dir" ]; then
    echo "No backup directory selected. Exiting."
    exit 1
fi
zoxide query "$backup_dir" &> /dev/null
if [ $? -eq 0 ]; then
    cd "$(zoxide query "$backup_dir")" || exit 1
    backup_dir=$(pwd)
else
    echo "Invalid backup directory. Using input as-is."
fi

# Confirm the backup directory
if ! confirm "You selected '$backup_dir' as the backup directory. Is this correct?"; then
    echo "Aborting!"
    exit 1
fi

# Check if the backup directory is the same as the source directory
if [ "$source_dir" = "$backup_dir" ]; then
    echo "Error: Source and backup directories cannot be the same!"
    exit 1
fi

# Check if the destination directory exists, if not, prompt to create it
if [ ! -d "$backup_dir" ]; then
    if confirm "The directory '$backup_dir' does not exist. Do you want to create it?"; then
        mkdir -p "$backup_dir"
        echo "Directory '$backup_dir' created."
    else
        echo "Aborting!"
        exit 1
    fi
fi

# Exclude patterns
excludes=(".git" "env" "__pycache__" "node_modules" "*.log")

# Build the exclusion arguments
exclude_args=""
for exclude in "${excludes[@]}"; do
    exclude_args="$exclude_args --exclude=$exclude"
done

# Perform the backup using rsync to handle exclusions and avoid unnecessary copying
rsync -av $exclude_args "$source_dir/" "$backup_dir/"

echo "Backup completed successfully!"
