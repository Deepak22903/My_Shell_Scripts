#!/bin/bash

# Add all changes
git add .

# Prompt for commit message
echo -n "Commit Message (default: 'Update'): "
read commit_message

# Use default message if none provided
commit_message=${commit_message:-"Update"}

# Commit with the provided or default message
git commit -m "$commit_message"

# Push to the remote repository
git push origin main

# Show the status
git status

