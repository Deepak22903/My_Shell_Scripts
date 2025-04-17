#!/bin/bash
# Decrease volume on all available sinks
for SINK in $(pactl list sinks short | awk '{print $1}'); do
  pactl set-sink-volume "$SINK" -5%
done

# Get current volume and mute status of the default sink
DEFAULT_SINK=$(pactl get-default-sink)
SINK_INFO=$(pactl list sinks | grep -A 15 "Name: $DEFAULT_SINK")
CURRENT_VOLUME=$(echo "$SINK_INFO" | grep 'Volume:' | head -n 1 | awk '{print $5}')
CURRENT_PERCENT=$(echo "$CURRENT_VOLUME" | sed 's/%//') # Extract percentage value
IS_MUTED=$(echo "$SINK_INFO" | grep 'Mute:' | awk '{print $2}')

# Send notification only if not muted
if [ "$IS_MUTED" == "no" ]; then
  notify-send -h int:value:"$CURRENT_PERCENT" -t 2000 "Volume Control" "Volume: ${CURRENT_VOLUME}" # Added notify-send
else
  notify-send -t 2000 "Volume Control" "Volume: MUTED" # Added notify-send for muted case
fi
