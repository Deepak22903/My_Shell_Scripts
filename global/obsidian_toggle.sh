#!/bin/bash

# Check if window exists and get its state
window_info=$(hyprctl clients | grep -A 15 "nvimObsidian")

if echo "$window_info" | grep -q "nvimObsidian"; then
  # Get current workspace
  current_workspace=$(hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}')

  if echo "$window_info" | grep -q "workspace: -99 (special"; then
    # Window is in special workspace (minimized), bring it back
    hyprctl dispatch movetoworkspace "$current_workspace,title:nvimObsidian"
    hyprctl dispatch focuswindow "title:nvimObsidian"
  else
    # Window is visible, move it to special workspace
    hyprctl dispatch movetoworkspacesilent special,title:nvimObsidian
  fi
else
  # Window doesn't exist, create it
  kitty --title "nvimObsidian" -e nvim +ObsidianToday
fi
