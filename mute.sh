#!/bin/bash
# (s)ound (tog)gle
# toggles mute of audio sinks via pulseaudio/pactl
pactl set-sink-mute 0 toggle # mute hdmi sound
pactl set-sink-mute 1 toggle # mute speaker sound
