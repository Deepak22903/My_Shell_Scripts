#!/bin/bash

# Fetch current brightness level
current_brightness=$(brightnessctl get)

if [ -z "$current_brightness" ]; then
    echo "Failed to retrieve current brightness level."
    exit 1
fi

# Fetch maximum brightness level
max_brightness=$(brightnessctl max)

# Calculate 5% increase in brightness
increase_amount=$(echo "$max_brightness * 0.05" | bc)

# Calculate new brightness level
new_brightness=$(echo "$current_brightness + $increase_amount" | bc | cut -d '.' -f 1)

# Ensure new brightness level does not exceed max brightness
if [ "$new_brightness" -gt "$max_brightness" ]; then
    new_brightness=$max_brightness
fi

# Set the new brightness level
brightnessctl set "$new_brightness"

