#!/bin/bash

# Define a file to store the notification ID for volume/mute
ID_FILE="${XDG_RUNTIME_DIR:-/tmp}/volume_notification_id.txt"

# --- Function to send volume/mute notification and store its ID ---
# Arguments: icon (optional), urgency, timeout, summary, body, progress_value (optional)
send_volume_notification() {
  local icon=$1 urgency=$2 timeout=$3 summary=$4 body=$5 progress=$6

  local notify_args=()
  [ -n "$icon" ] && notify_args+=(-i "$icon")
  [ -n "$urgency" ] && notify_args+=(-u "$urgency")
  [ -n "$timeout" ] && notify_args+=(-t "$timeout")
  # Mute notification doesn't usually have a progress bar, so we omit it here
  # If you wanted one, you could pass the current volume percentage
  # [ -n "$progress" ] && notify_args+=(-h "int:value:$progress")
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
    echo "Warning: Failed to send mute notification or get its ID." >&2
  fi
}

# --- Main Script Logic ---

# Toggle mute on the default sink only
DEFAULT_SINK=$(pactl get-default-sink)
pactl set-sink-mute "$DEFAULT_SINK" toggle

# Get mute status and volume of the default sink
SINK_INFO=$(pactl list sinks | grep -A 15 "Name: $DEFAULT_SINK")
MUTE_STATUS=$(echo "$SINK_INFO" | grep 'Mute:' | awk '{print $2}')
CURRENT_VOLUME=$(echo "$SINK_INFO" | grep 'Volume:' | head -n 1 | awk '{print $5}')
# CURRENT_PERCENT=$(echo "$CURRENT_VOLUME" | sed 's/%//') # Optional: if needed for progress

local MSG=""
local ICON=""

if [ "$MUTE_STATUS" == "yes" ]; then
  MSG="Audio Muted"
  ICON="audio-volume-muted"
else
  MSG="Audio Unmuted (${CURRENT_VOLUME})"
  # Choose icon based on volume when unmuting
  CURRENT_PERCENT=$(echo "$CURRENT_VOLUME" | sed 's/%//')
  if [ "$CURRENT_PERCENT" -lt 1 ]; then
    ICON="audio-volume-off"
  elif [ "$CURRENT_PERCENT" -lt 34 ]; then
    ICON="audio-volume-low"
  elif [ "$CURRENT_PERCENT" -lt 67 ]; then
    ICON="audio-volume-medium"
  else
    ICON="audio-volume-high"
  fi
fi

# Send notification using the function
# Pass "" for progress as mute status doesn't directly map to a progress bar value
send_volume_notification "$ICON" "normal" 2000 "Volume Control" "$MSG" ""
