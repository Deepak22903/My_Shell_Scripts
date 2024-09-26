#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/spinner.sh

# Function to stop spinner if script exits unexpectedly
cleanup() {
    stop_spinner
}
trap cleanup EXIT

# Start the spinner for checking large files changes
start_spinner "Checking for large files..."

# Update .gitignore for larger files (>=50M), suppress all output
/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/check_large_file_for_git_push_after_diff.sh >/dev/null 2>&1

sleep 0.5

# Stop the spinner 
stop_spinner

# Start the spinner for adding changes
start_spinner "Adding changes..."

# Add all changes, suppress output
git add . >/dev/null 2>&1

sleep 0.5

# Stop the spinner once the add is complete
stop_spinner

# Reset cursor position to avoid prompt shift
echo -ne "\r\033[K"

# Temporarily disable trap to allow Ctrl+C during commit message prompt
trap - SIGINT

# Prompt for commit message
echo -n "Commit Message: "
read commit_message

# Re-enable the trap after getting the commit message
trap cleanup EXIT

# Use default message if none provided
commit_message=${commit_message:-"Updated"}

# Commit with the provided or default message, suppress output
git commit -m "$commit_message" >/dev/null 2>&1

# Start the spinner with the message "Pushing to repository"
start_spinner "Pushing to repository..."

# Push to the remote repository and wait for it to finish
git push origin main >/dev/null 2>&1

# Stop the spinner once the push is complete
stop_spinner

# Reset cursor position to avoid prompt shift
echo -ne "\r\033[K"

# Display push success message
echo -e "Push success!"
