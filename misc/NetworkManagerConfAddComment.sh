#!/bin/bash

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file_path> <start_line>"
    exit 1
fi

file_path="$1"
start_line="$2"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File not found."
    exit 1
fi

# Use sed to add # to lines after the specified line
sed -i "${start_line},\$s/^/#/" "$file_path"

echo -e "${YELLOW}Added${NC}${GREEN}${BOLD} # ${NC}${YELLOW}to lines after line $start_line in $file_path.${NC}" 

systemctl restart NetworkManager

echo -e "${GREEN}${BOLD}NetworkManager restarted!${NC}"
