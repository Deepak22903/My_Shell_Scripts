#!/bin/bash
# Toggle mute on the default sink only for clearer notification
DEFAULT_SINK=$(pactl get-default-sink)
pactl set-sink-mute "$DEFAULT_SINK" toggle

# Get mute status of the default sink
MUTE_STATUS=$(pactl list sinks | grep -A 15 "Name: $DEFAULT_SINK" | grep 'Mute:' | awk '{print $2}')

if [ "$MUTE_STATUS" == "yes" ]; then
  MSG="Audio Muted"
  ICON="audio-volume-muted"
else
  # Also show current volume when unmuting
  CURRENT_VOLUME=$(pactl list sinks | grep -A 15 "Name: $DEFAULT_SINK" | grep 'Volume:' | head -n 1 | awk '{print $5}')
  MSG="Audio Unmuted (${CURRENT_VOLUME})"
  ICON="audio-volume-high" # Or medium/low based on volume if desired
fi

# Send notification
notify-send -i "$ICON" -t 2000 "Volume Control" "$MSG" # Added notify-send with icon
