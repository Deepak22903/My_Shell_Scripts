#!/bin/bash

# Define a file to store the notification ID between runs
# Using /tmp is simple, but $XDG_RUNTIME_DIR is often preferred if available
# Adjust the path if needed
ID_FILE="${XDG_RUNTIME_DIR:-/tmp}/brightness_notification_id.txt"

# --- Function to send notification and store its ID ---
# Arguments: icon (optional), urgency, timeout, summary, body, progress_value (optional)
send_notification() {
  # Capture the icon argument first
  local icon=$1 urgency=$2 timeout=$3 summary=$4 body=$5 progress=$6

  # Prepare base notify-send command arguments in an array
  local notify_args=()
  # Add icon argument if provided
  [ -n "$icon" ] && notify_args+=(-i "$icon")
  [ -n "$urgency" ] && notify_args+=(-u "$urgency")
  [ -n "$timeout" ] && notify_args+=(-t "$timeout")
  [ -n "$progress" ] && notify_args+=(-h "int:value:$progress")
  notify_args+=("$summary" "$body" -p) # Always print the ID

  # Read the previous notification ID if the file exists
  local OLD_ID=""
  if [ -f "$ID_FILE" ]; then
    OLD_ID=$(cat "$ID_FILE")
  fi

  # If we have an old ID, add the replace option
  if [ -n "$OLD_ID" ]; then
    notify_args+=(-r "$OLD_ID")
  fi

  # Send the notification and capture the new ID
  local NEW_ID
  NEW_ID=$(notify-send "${notify_args[@]}")

  # Check if notify-send succeeded and returned an ID
  if [ $? -eq 0 ] && [ -n "$NEW_ID" ]; then
    # Store the new ID for the next run, overwriting the old one
    echo "$NEW_ID" >"$ID_FILE"
  else
    # If sending/getting ID failed, maybe clear the stored ID?
    # Or just report an error. For simplicity, we won't clear it here.
    echo "Warning: Failed to send notification or get its ID." >&2 # Print to stderr
  fi
}

# --- Main Script Logic ---

# Fetch current brightness level
current_brightness=$(brightnessctl get)
if [ -z "$current_brightness" ]; then
  echo "Failed to retrieve current brightness level." >&2
  # Send a critical error notification - Add an error icon here too?
  notify-send -i dialog-error -u critical -t 3000 "Brightness Error" "Failed to retrieve current brightness."
  exit 1
fi

# Fetch maximum brightness level
max_brightness=$(brightnessctl max)
if [ -z "$max_brightness" ]; then
  echo "Failed to retrieve max brightness level." >&2
  # Add an error icon here
  notify-send -i dialog-error -u critical -t 3000 "Brightness Error" "Failed to retrieve max brightness."
  exit 1
fi

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

  # <<< --- MODIFICATION HERE --- >>>
  # Define the icon name to use
  # Common names: display-brightness-symbolic, notification-display-brightness, gnome-settings-brightness
  # You might need to experiment to find one that exists in your theme
  ICON_NAME="notification-display-brightness"

  # Send the replaceable notification using our function, passing the icon name first
  send_notification "$ICON_NAME" "normal" 2000 "Brightness Control" "Brightness: ${new_percent}%" "$new_percent"
else
  echo "Failed to set brightness level." >&2
  # Send a critical error notification - let this one stack, add error icon
  notify-send -i dialog-error -u critical -t 3000 "Brightness Error" "Failed to set brightness."
fi
