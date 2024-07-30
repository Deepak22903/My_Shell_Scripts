#!/bin/bash

# Add all changes
git add .

# Prompt for commit message
echo -n "Commit Message: "
read commit_message

# Commit with the provided message
git commit -m "$commit_message"

# Push to the remote repository
git push origin main

# Show the status
git status
