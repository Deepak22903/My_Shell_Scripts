#!/bin/bash

# Fetch current brightness level
current_brightness=$(brightnessctl get)

if [ -z "$current_brightness" ]; then
  echo "Failed to retrieve current brightness level."
  notify-send -u critical -t 3000 "Brightness Error" "Failed to retrieve current brightness." # Added notify-send
  exit 1
fi

# Fetch maximum brightness level
max_brightness=$(brightnessctl max)

# Calculate 5% decrease in brightness (using integer arithmetic)
decrease_amount=$((max_brightness * 5 / 100))
[ "$decrease_amount" -eq 0 ] && decrease_amount=1 # Ensure minimum decrease

# Calculate new brightness level
new_brightness=$((current_brightness - decrease_amount))

# Ensure new brightness level is not less than a minimum (e.g., 1 or 5%)
min_brightness_percent=5
min_brightness=$((max_brightness * min_brightness_percent / 100))
[ "$min_brightness" -eq 0 ] && min_brightness=1 # Ensure minimum is at least 1

if [ "$new_brightness" -lt "$min_brightness" ]; then
  new_brightness=$min_brightness
fi

# Set the new brightness level
if brightnessctl set "$new_brightness"; then
  # Get the percentage
  new_percent=$((new_brightness * 100 / max_brightness))
  # Send notification
  notify-send -h int:value:"$new_percent" -t 2000 "Brightness Control" "Brightness: ${new_percent}%" # Added notify-send
else
  echo "Failed to set brightness level."
  notify-send -u critical -t 3000 "Brightness Error" "Failed to set brightness." # Added notify-send
fi
