
#!/bin/bash

# Ensure zoxide and fzf are installed
if ! command -v zoxide &> /dev/null || ! command -v fzf &> /dev/null; then
    echo "zoxide and fzf are required for this script."
    exit 1
fi

# Get the source path using zoxide and fzf
source_path=$(zoxide query -l | fzf --height 40% --ansi --preview "ls -l {}" --preview-window=up:30%)

# Check if the user selected a path
if [[ -z "$source_path" ]]; then
    echo "No source path selected. Exiting."
    exit 1
fi

# Modify the destination path by replacing 'data' with 'telegramfs'
destination_path="${source_path/data/telegramfs}"

# Print the source and destination paths
echo "Source Path: $source_path"
echo "Destination Path: $destination_path"

# Use rsync to synchronize the files, excluding the base directory
rsync -av --mkpath --no-relative "$source_path/" "$destination_path"

# Check the exit status of the rsync command
if [[ $? -eq 0 ]]; then
    echo "Files synchronized successfully."
else
    echo "An error occurred during synchronization."
fi
