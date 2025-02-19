#!/bin/bash
kitty &
sleep 0.5  # adjust delay if needed
hyprctl dispatch movetoworkspace special:magic
