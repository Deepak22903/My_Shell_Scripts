#!/bin/bash

# Fetch current brightness level
current_brightness=$(qdbus6 org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement/Actions/BrightnessControl org.kde.Solid.PowerManagement.Actions.BrightnessControl.brightness)

if [ -z "$current_brightness" ]; then
    echo "Failed to retrieve current brightness level."
    exit 1
fi

# Calculate maximum brightness (assuming maximum is 100)
max_brightness=100

# Calculate 5% increase in brightness
increase_amount=$(echo "$max_brightness * 0.05" | bc)

# Calculate new brightness level (ensure it's an integer)
new_brightness=$(echo "$current_brightness + $increase_amount" | bc | cut -d '.' -f 1)

# Set the new brightness level
qdbus6 org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement/Actions/BrightnessControl org.kde.Solid.PowerManagement.Actions.BrightnessControl.setBrightness $new_brightness
