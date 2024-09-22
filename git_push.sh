#!/bin/bash

# update .gitignore for larger files (>=50M)
/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/check_large_file_for_git_push_after_diff.sh

# Add all changes
git add .

# Prompt for commit message
echo -n "Commit Message: "
read commit_message

# Use default message if none provided
commit_message=${commit_message:-"Updated"}

# Commit with the provided or default message
git commit -m "$commit_message"

# Push to the remote repository
git push origin main

# Show the status
git status

