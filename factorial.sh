#!/bin/bash

# Function to calculate factorial
factorial() {
    local num=$1
    if [ $num -le 1 ]; then
        echo 1
    else
        local temp=$(( num - 1 ))
        local result=$(factorial $temp)
        echo $(( num * result ))
    fi
}

# Read input from user
read -p "Enter a number: " number

# Validate input
if ! [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "Please enter a valid non-negative integer."
    exit 1
fi

# Calculate factorial
result=$(factorial $number)
echo "The factorial of $number is: $result"
