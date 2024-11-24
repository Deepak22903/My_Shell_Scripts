#!/bin/bash
# Decrease volume on all available sinks
for SINK in $(pactl list sinks short | awk '{print $1}'); do
    pactl set-sink-volume "$SINK" -5%
done
