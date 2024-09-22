#!/bin/bash

# Update .gitignore for larger files (>=50M), suppress all output
/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/check_large_file_for_git_push_after_diff.sh >/dev/null 2>&1

# Add all changes, suppress output
git add . >/dev/null 2>&1

# Prompt for commit message
echo -n "Commit Message: "
read commit_message

# Use default message if none provided
commit_message=${commit_message:-"Updated"}

# Commit with the provided or default message, suppress output
git commit -m "$commit_message" >/dev/null 2>&1

# Display pushing message
echo "Pushing..."

# Push to the remote repository, suppress output
git push origin main >/dev/null 2>&1

# Display push success message
echo "Push success"
