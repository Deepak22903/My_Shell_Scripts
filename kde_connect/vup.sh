#!/bin/bash
# (v)olume (up)
# ups volume on all audio sinks via pactl/pulseaudio
pactl set-sink-volume 0 +5% #hdmi vup
pactl set-sink-volume 1 +5% #speaker vup
