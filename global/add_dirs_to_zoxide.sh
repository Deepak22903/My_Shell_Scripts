#!/bin/bash

# Function to add directories to zoxide recursively
add_dirs_to_zoxide() {
    local dir="$1"
    shopt -s globstar nullglob
    for subdir in "$dir"/*/; do
        # Check if the directory matches any of the exclusion patterns
        if [[ "$subdir" != *".git/" && "$subdir" != *"env/" && "$subdir" != *"__pycache__/" && "$subdir" != *"node_modules/" ]]; then
            zoxide add "$subdir"
            echo "Added $subdir to zoxide."
            add_dirs_to_zoxide "$subdir" # Recursively add subdirectories
        fi
    done
}

# Start adding from the current directory
add_dirs_to_zoxide "."

echo "All relevant directories have been added to zoxide!"
