#!/bin/bash

# Function to remove AI_Lab directories from zoxide recursively
remove_ai_lab_dirs_from_zoxide() {
    local dir="$1"
    shopt -s globstar nullglob
    for subdir in "$dir"/*/; do
        # Check if the directory contains "AI_Lab"
        if [[ "$subdir" == *"AI_Lab"* ]]; then
            zoxide remove "$subdir" # Remove from zoxide
            echo "Removed $subdir from zoxide."
        else
            # Recursively process subdirectories
            remove_ai_lab_dirs_from_zoxide "$subdir"
        fi
    done
}

# Start removing from the current directory
remove_ai_lab_dirs_from_zoxide "."

echo "All AI_Lab directories have been removed from zoxide!"
