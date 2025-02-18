#!/bin/bash
kitty &
sleep 0.5  # adjust delay if needed
hyprctl dispatch movetoworkspace special:magic
sleep 0.1  # optional: allow the move to finish
hyprctl dispatch workspace 1
