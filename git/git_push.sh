#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh


# Define color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[0;31m"
RESET="\033[0m"

# Function to stop spinner if script exits unexpectedly
cleanup() {
    stop_spinner
}
trap cleanup EXIT

# Start the spinner for checking large files changes
start_spinner "${YELLOW}🔍 Checking for large files...${RESET}"

# Update .gitignore for larger files (>=50M), suppress all output
/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/git/check_large_file_for_git_push_after_diff.sh

sleep 0.5

# Stop the spinner 
stop_spinner

# Start the spinner for adding changes
start_spinner "${BLUE}➕ Adding changes...${RESET}"

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
echo -e "${GREEN}✍️  Commit Message: ${RESET}\c"
read commit_message

# Re-enable the trap after getting the commit message
trap cleanup EXIT

# Use default message if none provided
commit_message=${commit_message:-"Updated"}

# Commit with the provided or default message, suppress output
git commit -m "$commit_message" >/dev/null 2>&1

# Start the spinner with the message "Pushing to repository"
start_spinner "${YELLOW}🚀 Pushing to repository...${RESET}"

# Push to the remote repository and wait for it to finish
git push origin main >/dev/null 2>&1

# Stop the spinner once the push is complete
stop_spinner

# Reset cursor position to avoid prompt shift
echo -ne "\r\033[K"

# Display push success message
echo -e "${GREEN}✅ Push successful!${RESET}"
