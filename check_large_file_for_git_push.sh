#!/bin/bash

# Find all files larger than 50 MB
find_large_files() {
    find . -type f -size +50M
}

# Check if a file is already in .gitignore
is_in_gitignore() {
    local file=$1
    grep -Fxq "$file" .gitignore
}

# Add files larger than 50 MB to .gitignore
add_to_gitignore() {
    local file=$1
    if ! is_in_gitignore "$file"; then
        echo "$file" >> .gitignore
        echo "$file added to .gitignore"
    else
        echo "$file is already in .gitignore"
    fi
}

# Main script
find_large_files | while read -r file; do
    add_to_gitignore "$file"
done
