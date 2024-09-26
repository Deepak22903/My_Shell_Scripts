#!/bin/bash
# (v)olume (d)o(w)n
# lowers volume on audio sinks via pactl/pulseaudio
pactl set-sink-volume 0 -5% #hdmi vdw
pactl set-sink-volume 1 -5% #speaker vdw
