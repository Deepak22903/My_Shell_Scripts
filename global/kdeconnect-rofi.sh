#!/bin/bash

# Function to get list of available devices
get_devices() {
  kdeconnect-cli -a --id-name-only | while read -r id name; do
    echo "$name ($id)"
  done
}

# Function to show rofi menu with devices
show_device_menu() {
  devices=$(get_devices)
  if [ -z "$devices" ]; then
    notify-send "KDE Connect" "No available devices found"
    exit 1
  fi
  echo "$devices" | rofi -dmenu -p "Select Device"
}

# Function to show action menu for selected device
show_action_menu() {
  local device_id=$1
  local device_name=$2
  actions="Send Clipboard\nSend Files\nFind Device\nPing Device"
  echo -e "$actions" | rofi -dmenu -p "Action for $device_name"
}

# Function to handle actions
handle_action() {
  local action=$1
  local device_id=$2
  local device_name=$3

  case "$action" in
  "Send Clipboard")
    kdeconnect-cli -d "$device_id" --send-clipboard
    notify-send "KDE Connect" "Clipboard sent to $device_name"
    ;;
  "Send Files")
    files=$(zenity --file-selection --multiple --title="Select files to send to $device_name")
    if [ -n "$files" ]; then
      IFS='|' read -ra file_array <<<"$files"
      for file in "${file_array[@]}"; do
        kdeconnect-cli -d "$device_id" --share "$file"
      done
      notify-send "KDE Connect" "Files sent to $device_name"
    fi
    ;;
  "Find Device")
    kdeconnect-cli -d "$device_id" --ring
    notify-send "KDE Connect" "Ringing $device_name"
    ;;
  "Ping Device")
    kdeconnect-cli -d "$device_id" --ping
    notify-send "KDE Connect" "Ping sent to $device_name"
    ;;
  esac
}

# Main script
selected_device=$(show_device_menu)
if [ -n "$selected_device" ]; then
  # Extract device ID from selection (format: name (id))
  device_id=$(echo "$selected_device" | grep -oP '\(\K[^)]+')
  device_name=$(echo "$selected_device" | sed 's/ *(.*)//')

  action=$(show_action_menu "$device_id" "$device_name")
  if [ -n "$action" ]; then
    handle_action "$action" "$device_id" "$device_name"
  fi
fi
