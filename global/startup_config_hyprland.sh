#!/bin/bash
# Function to wait until a window containing a specific keyword appears
wait_for_window() {
  local keyword=$1
  while ! hyprctl clients | grep -iq "$keyword"; do
    sleep 0.1
  done
}

kitty &
wait_for_window "kitty"
hyprctl dispatch movetoworkspacesilent special:magic

firefox &
wait_for_window "firefox" # adjust keyword if needed
hyprctl dispatch movetoworkspacesilent 2

obsidian &
wait_for_window "obsidian" # adjust keyword if needed
hyprctl dispatch movetoworkspacesilent 9

# hyprctl dispatch exec "kitty -e yazi"
# wait_for_window "yazi"     # adjust keyword if needed
# hyprctl dispatch movetoworkspacesilent 3

kitty
