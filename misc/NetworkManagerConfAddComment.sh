#!/bin/bash

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

echo "Added # to lines after line $start_line in $file_path."
