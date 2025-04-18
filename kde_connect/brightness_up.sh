#!/bin/bash

# Define a file to store the notification ID between runs
# Using /tmp is simple, but $XDG_RUNTIME_DIR is often preferred if available
ID_FILE="${XDG_RUNTIME_DIR:-/tmp}/brightness_notification_id.txt"

# --- Function to send notification and store its ID ---
# Arguments: icon (optional), urgency, timeout, summary, body, progress_value (optional)
send_brightness_notification() {
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

  local OLD_ID=""
  if [ -f "$ID_FILE" ]; then
    OLD_ID=$(cat "$ID_FILE")
  fi

  if [ -n "$OLD_ID" ]; then
    notify_args+=(-r "$OLD_ID")
  fi

  local NEW_ID
  NEW_ID=$(notify-send "${notify_args[@]}")

  if [ $? -eq 0 ] && [ -n "$NEW_ID" ]; then
    echo "$NEW_ID" >"$ID_FILE"
  else
    echo "Warning: Failed to send brightness notification or get its ID." >&2
  fi
}

# --- Main Script Logic ---

# Fetch current brightness level
current_brightness=$(brightnessctl get)
if [ -z "$current_brightness" ]; then
  echo "Failed to retrieve current brightness level." >&2
  # Add error icon
  notify-send -i dialog-error -u critical -t 3000 "Brightness Error" "Failed to retrieve current brightness."
  exit 1
fi

# Fetch maximum brightness level
max_brightness=$(brightnessctl max)
if [ -z "$max_brightness" ]; then
  echo "Failed to retrieve max brightness level." >&2
  # Add error icon
  notify-send -i dialog-error -u critical -t 3000 "Brightness Error" "Failed to retrieve max brightness."
  exit 1
fi

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

  # <<< --- MODIFICATION HERE --- >>>
  # Define the icon name to use
  ICON_NAME="notification-display-brightness"

  # Send the replaceable notification, passing icon name first
  send_brightness_notification "$ICON_NAME" "normal" 2000 "Brightness Control" "Brightness: ${new_percent}%" "$new_percent"
else
  echo "Failed to set brightness level." >&2
  # Add error icon
  notify-send -i dialog-error -u critical -t 3000 "Brightness Error" "Failed to set brightness."
fi
