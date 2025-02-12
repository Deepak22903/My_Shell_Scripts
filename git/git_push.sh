#!/bin/bash

# Define color codes
# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color
RESET="\033[0m"

if [ ! -d "./.git" ]; then
  echo -e "${RED}${BOLD}Not in the root git directory!${NC}"
  exit 1
fi

source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh


# Function to stop spinner if script exits unexpectedly
cleanup() {
    stop_spinner
}
trap cleanup EXIT

# Start the spinner for checking large files changes (no color codes)
start_spinner "🔍 Checking for large files..."

# Update .gitignore for larger files (>=50M), suppress all output
/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/git/check_large_file_for_git_push_after_diff.sh

sleep 0.25

# Stop the spinner 
stop_spinner

# Start the spinner for adding changes (no color codes)
start_spinner "➕ Adding changes..."

# Add all changes, suppress output
git add . >/dev/null 2>&1

sleep 0.25

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

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Start the spinner with the message "Pushing to repository" (no color codes)
start_spinner "🚀 Pushing to $current_branch branch..."

# Push to the current branch of the remote repository and wait for it to finish
git push origin "$current_branch" >/dev/null 2>&1

# Stop the spinner once the push is complete
stop_spinner

# Reset cursor position to avoid prompt shift
echo -ne "\r\033[K"

# Display push success message
echo -e "${GREEN}✅ Push to $current_branch successful!${RESET}"
