#!/bin/bash

# Get the currently focused window's address
focused_window_address=$(hyprctl activewindow -j | jq -r '.address')

if [ -z "$focused_window_address" ] || [ "$focused_window_address" == "null" ]; then
  echo "No window is currently focused."
  exit 1
fi

# Get window info
window_info=$(hyprctl clients -j | jq -r --arg addr "$focused_window_address" '.[] | select(.address == $addr)')

if [ -z "$window_info" ]; then
  echo "Window not found."
  exit 1
fi

# Extract window title and workspace
focused_window_title=$(echo "$window_info" | jq -r '.title')
workspace_id=$(echo "$window_info" | jq -r '.workspace.id')

if [ -z "$focused_window_title" ]; then
  echo "Could not determine window title."
  exit 1
fi

# Check if the window is in the special workspace
if [ "$workspace_id" == "-99" ]; then
  # Find the last active workspace (excluding special)
  last_workspace=$(hyprctl workspaces -j | jq -r '[.[] | select(.id != -99)] | sort_by(.lastwindow) | last | .id')

  if [ -z "$last_workspace" ] || [ "$last_workspace" == "null" ]; then
    last_workspace=1 # Default to workspace 1 if no valid workspace is found
  fi

  # Move the window back and focus on it
  hyprctl dispatch movetoworkspace "$last_workspace,address:$focused_window_address"
  hyprctl dispatch focuswindow "address:$focused_window_address"
else
  # Window is visible, move it to special workspace
  hyprctl dispatch movetoworkspacesilent special,address:$focused_window_address
fi
