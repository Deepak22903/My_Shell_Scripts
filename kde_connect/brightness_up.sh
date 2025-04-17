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

# Calculate 5% increase in brightness (using integer arithmetic)
increase_amount=$((max_brightness * 5 / 100))
[ "$increase_amount" -eq 0 ] && increase_amount=1 # Ensure minimum increase

# Calculate new brightness level
new_brightness=$((current_brightness + increase_amount))

# Ensure new brightness level does not exceed max brightness
if [ "$new_brightness" -gt "$max_brightness" ]; then
  new_brightness=$max_brightness
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
