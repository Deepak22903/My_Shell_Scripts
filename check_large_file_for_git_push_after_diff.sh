#!/bin/bash

# Find all files larger than 50 MB that are new or modified after the last commit, including untracked files
find_large_new_files() {
    # Find modified and added files (staged or tracked)
    git diff --name-only --diff-filter=AM HEAD

    # Find untracked files
    git ls-files --others --exclude-standard
}

# Check if a file is larger than 50 MB
is_large_file() {
    local file=$1
    if [ -f "$file" ] && [ $(stat -c%s "$file") -gt $((50 * 1024 * 1024)) ]; then
        return 0
    else
        return 1
    fi
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
find_large_new_files | while read -r file; do
    if is_large_file "$file"; then
        add_to_gitignore "$file"
    fi
done
