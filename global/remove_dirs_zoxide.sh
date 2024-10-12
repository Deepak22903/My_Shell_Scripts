
#!/bin/bash

# Function to remove unnecessary directories from zoxide recursively
remove_useless_dirs_from_zoxide() {
    local dir="$1"
    shopt -s globstar nullglob
    for subdir in "$dir"/*/; do
        # Check if the directory matches any of the exclusion patterns
        if [[ "$subdir" == *".git/" || "$subdir" == *"env/" || "$subdir" == *"__pycache__/" || "$subdir" == *"node_modules/" ]]; then
            zoxide remove "$subdir" # Remove from zoxide
            echo "Removed $subdir from zoxide."
        fi
        remove_useless_dirs_from_zoxide "$subdir" # Recursively remove from subdirectories
    done
}

# Start removing from the current directory
remove_useless_dirs_from_zoxide "."

echo "All unnecessary directories have been removed from zoxide!"
