#!/bin/bash

# Fetch current brightness level
current_brightness=$(brightnessctl get)

if [ -z "$current_brightness" ]; then
    echo "Failed to retrieve current brightness level."
    exit 1
fi

# Fetch maximum brightness level
max_brightness=$(brightnessctl max)

# Calculate 5% decrease in brightness
decrease_amount=$(echo "$max_brightness * 0.05" | bc)

# Calculate new brightness level
new_brightness=$(echo "$current_brightness - $decrease_amount" | bc | cut -d '.' -f 1)

# Ensure new brightness level is not less than 0
if [ "$new_brightness" -lt 0 ]; then
    new_brightness=0
fi

# Set the new brightness level
brightnessctl set "$new_brightness"

