#!/bin/bash

# Start the hotspot
sudo create_ap wlan0 eno1 "Deepak's Arch" password

# Wait for the user to stop the script
read -p "Press Enter to stop the hotspot and set wlan0 back to managed..."

# Remove the unmanaged-devices line from NetworkManager.conf
sudo sed -i '/unmanaged-devices=interface-name:wlan0/d' /etc/NetworkManager/NetworkManager.conf

# Restart NetworkManager to apply changes
sudo systemctl restart NetworkManager

echo "wlan0 is now managed by NetworkManager again."
