#!/bin/bash

# Remove the unmanaged-devices line from NetworkManager.conf
sudo sed -i '/unmanaged-devices=interface-name:wlan0/d' /etc/NetworkManager/NetworkManager.conf

# Restart NetworkManager to apply changes
sudo systemctl restart NetworkManager

echo "wlan0 is now managed by NetworkManager again."
