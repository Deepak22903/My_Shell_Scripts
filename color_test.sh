
#!/bin/bash

# Define color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

# Function to check display of colored text
test_colors() {
    echo -e "${YELLOW}🔍 Checking for large files...${RESET}"
    echo -e "${BLUE}➕ Adding changes...${RESET}"
    echo -e "${GREEN}✍️ Commit Message: ${RESET}\c"
    read commit_message
    echo -e "${YELLOW}🚀 Pushing to repository...${RESET}"
    echo -e "${GREEN}✅ Push successful!${RESET}"
}

# Run test
test_colors
