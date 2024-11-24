#!/bin/bash
# Mute all available sinks
for SINK in $(pactl list sinks short | awk '{print $1}'); do
    pactl set-sink-mute "$SINK" toggle
done
