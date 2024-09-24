#!/bin/bash
source ./spinner.sh

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

# Start the spinner with the message "Pushing to repository"
start_spinner "Pushing to repository"

# Push to the remote repository and wait for it to finish
git push origin main >/dev/null 2>&1

# Stop the spinner once the push is complete
stop_spinner

# Display push success message
echo -e "\nPush success"
