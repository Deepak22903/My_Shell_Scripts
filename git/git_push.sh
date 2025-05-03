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

# --- Find Git Root Directory ---
# Use git rev-parse to find the top-level directory (root) of the Git repository
# Redirect stderr to /dev/null to suppress errors if not in a git repo
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# Check if git rev-parse succeeded (exit code 0)
if [ $? -ne 0 ]; then
  echo -e "${RED}${BOLD}Error: Not inside a Git repository.${NC}"
  exit 1
fi

# --- Change to Git Root Directory ---
# Store the original directory in case you need it later (optional here)
# ORIGINAL_DIR=$(pwd)
cd "$GIT_ROOT"
if [ $? -ne 0 ]; then
  echo -e "${RED}${BOLD}Error: Could not change directory to Git root: $GIT_ROOT${NC}"
  exit 1
fi
echo -e "${CYAN}󰘬 Operating from Git root directory: ${BOLD}$GIT_ROOT${RESET}"

# --- Source Helper Scripts (Assuming paths are absolute or relative to where the main script is located) ---
# Adjust the path if spinner.sh is relative to the script's location, not the execution location
# Assuming the path provided is absolute or correctly relative from anywhere
SCRIPT_DIR=$(dirname "$(readlink -f "$0")") # Get the directory where the script itself resides
# If spinner.sh is in the same directory structure relative to *this* script:
# SPINNER_SCRIPT_PATH="/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh" # Or calculate relative path if needed
# If the path is absolute, it's fine as is. Let's assume the provided path is correct.
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh
LARGE_FILE_CHECK_SCRIPT="/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/git/check_large_file_for_git_push_after_diff.sh"

# Function to stop spinner if script exits unexpectedly
cleanup() {
  stop_spinner
  # Optional: change back to original directory if needed
  # cd "$ORIGINAL_DIR"
}
trap cleanup EXIT

# --- Git Operations (Now running from the Git Root) ---

# Start the spinner for checking large files changes
start_spinner " Checking for large files..."
# Run the large file check script. It will now operate in the Git root directory.
"$LARGE_FILE_CHECK_SCRIPT" # Suppress output if needed by adding >/dev/null 2>&1
sleep 0.25
stop_spinner

# Start the spinner for adding changes
start_spinner " Adding changes..."
# Add all changes from the Git root directory downwards
git add . >/dev/null 2>&1
sleep 0.25
stop_spinner

# Reset cursor position to avoid prompt shift
echo -ne "\r\033[K"

# Temporarily disable trap to allow Ctrl+C during commit message prompt
trap - SIGINT

# Prompt for commit message
echo -e "${GREEN}󰞚 Commit Message: ${RESET}\c"
read commit_message

# Re-enable the trap after getting the commit message
trap cleanup EXIT # Or simply 'trap cleanup EXIT' if you only need the exit trap

# Use default message if none provided
commit_message=${commit_message:-"Updated"}

# Commit with the provided or default message
start_spinner "󰑘 Committing changes..."
git commit -m "$commit_message" >/dev/null 2>&1 # Suppress output
COMMIT_EXIT_CODE=$?                             # Capture exit code of commit
stop_spinner
echo -ne "\r\033[K" # Clear spinner line

# Check if commit was successful (exit code 0) or if there was nothing to commit (exit code 1 typically for 'nothing to commit')
# Note: `git commit` exits with 1 if there are no changes to commit. We might want to allow this.
if [ $COMMIT_EXIT_CODE -ne 0 ]; then
  # Check if the reason for non-zero exit was "nothing to commit"
  # This requires capturing the output, which we suppressed. Let's commit without suppression first.
  COMMIT_OUTPUT=$(git commit -m "$commit_message" 2>&1)
  COMMIT_EXIT_CODE=$?
  if [[ "$COMMIT_OUTPUT" == *"nothing to commit, working tree clean"* ]]; then
    echo -e "${YELLOW}󰋪 No changes added to commit.${RESET}"
    # Decide whether to exit or continue (e.g., maybe still try to push?)
    # Exit for now, as pushing without a new commit is usually pointless unless syncing tags/branches not locally updated.
    exit 0
  elif [ $COMMIT_EXIT_CODE -ne 0 ]; then
    echo -e "${RED}${BOLD} Commit failed.${RESET}"
    echo -e "${RED}$COMMIT_OUTPUT${RESET}" # Show the error message
    exit $COMMIT_EXIT_CODE
  # else: commit was successful (exit code 0, handled implicitly below)
  fi
fi
echo -e "${GREEN}󰑘 Commit successful.${RESET}"

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Start the spinner for pushing
start_spinner " Pushing to $current_branch branch..."
# Push to the current branch of the remote repository
PUSH_OUTPUT=$(git push origin "$current_branch" 2>&1) # Capture output to check for errors
PUSH_EXIT_CODE=$?
stop_spinner
echo -ne "\r\033[K" # Clear spinner line

# Check push status
if [ $PUSH_EXIT_CODE -eq 0 ]; then
  echo -e "${GREEN}󰸞 Push to $current_branch successful!${RESET}"
else
  echo -e "${RED}${BOLD} Push failed.${RESET}"
  echo -e "${RED}$PUSH_OUTPUT${RESET}" # Show the error message from git push
  exit $PUSH_EXIT_CODE
fi

# Optional: Change back to the original directory if needed
# cd "$ORIGINAL_DIR"

exit 0
