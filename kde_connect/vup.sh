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
    echo "Warning: Failed to send volume notification or get its ID." >&2
  fi
}

# --- Main Script Logic ---

# Increase volume on all available sinks (or just default if preferred)
# Using default sink for simplicity in getting status
DEFAULT_SINK=$(pactl get-default-sink)
pactl set-sink-volume "$DEFAULT_SINK" +5%
# If you want to control *all* sinks, uncomment the loop and remove the line above
# for SINK in $(pactl list sinks short | awk '{print $1}'); do
#   pactl set-sink-volume "$SINK" +5%
# done

# Get current volume and mute status of the default sink
SINK_INFO=$(pactl list sinks | grep -A 15 "Name: $DEFAULT_SINK")
CURRENT_VOLUME=$(echo "$SINK_INFO" | grep 'Volume:' | head -n 1 | awk '{print $5}')
CURRENT_PERCENT=$(echo "$CURRENT_VOLUME" | sed 's/%//') # Extract percentage value
IS_MUTED=$(echo "$SINK_INFO" | grep 'Mute:' | awk '{print $2}')

# Determine icon based on volume and mute status
ICON="audio-volume-high" # Default
if [ "$IS_MUTED" == "yes" ]; then
  ICON="audio-volume-muted"
elif [ "$CURRENT_PERCENT" -lt 34 ]; then
  ICON="audio-volume-low"
elif [ "$CURRENT_PERCENT" -lt 67 ]; then
  ICON="audio-volume-medium"
fi

# Send notification using the function
if [ "$IS_MUTED" == "no" ]; then
  send_volume_notification "$ICON" "normal" 2000 "Volume Control" "Volume: ${CURRENT_VOLUME}" "$CURRENT_PERCENT"
else
  # Still show the underlying percentage, but indicate mute
  send_volume_notification "$ICON" "normal" 2000 "Volume Control" "Volume: MUTED (${CURRENT_VOLUME})" "$CURRENT_PERCENT"
fi
