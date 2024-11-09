#!/bin/bash

# Ensure zoxide and fzf are installed
if ! command -v zoxide &> /dev/null || ! command -v fzf &> /dev/null; then
    echo -e "\e[31mError: zoxide and fzf are required for this script.\e[0m"
    exit 1
fi

# Get the source path using zoxide and fzf
source_path=$(zoxide query -l | fzf --height 40% --ansi --preview-window=up:30% --border)

# Check if the user selected a path
if [[ -z "$source_path" ]]; then
    echo -e "\e[33mNo source path selected. Exiting.\e[0m"
    exit 1
fi

# Modify the destination path by replacing 'data' with 'telegramfs'
destination_path="${source_path/data/telegramfs}"

# Print the source and destination paths
echo -e "\n\e[36mSource Path:\e[0m $source_path"
echo -e "\e[36mDestination Path:\e[0m $destination_path\n"

# Use rsync to synchronize the files, excluding specified directories and skipping files larger than 1 GB
echo -e "\e[34mStarting file transfer...\e[0m"
rsyncy -av -h --mkpath --no-relative --exclude='WIN_*' --exclude='Program Files*' --exclude='IntelliJ*' --exclude='Large_Files*' --exclude='Genshin*' --exclude='Fooocus*' --exclude='AI_Lab*' --exclude='node_modules/' --exclude='Adobe*' --exclude='.git/' --exclude='env/' --exclude='.*' --max-size=0.1G "$source_path/" "$destination_path"

# Check the exit status of rsync and print an appropriate message
if [[ $? -eq 0 ]]; then
    echo -e "\n\e[32mFiles synchronized successfully.\e[0m"
    notify-send "Backup Complete" "Files synchronized successfully."
else
    echo -e "\e[31mAn error occurred during synchronization.\e[0m"
    notify-send "Backup Failed" "An error occurred during file synchronization."
fi
