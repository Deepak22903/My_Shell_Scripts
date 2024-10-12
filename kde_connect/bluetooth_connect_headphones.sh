#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh

# Get the list of paired devices
DEVICE=$(bluetoothctl devices | fzf --prompt="Select a Bluetooth device: " --height=10 --border)

# Extract the MAC address from the selected device
DEVICE_MAC=$(echo "$DEVICE" | awk '{print $2}')

# If no device is selected, exit the script
if [ -z "$DEVICE_MAC" ]; then
    echo "No device selected. Exiting..."
    exit 1
fi

# Start the spinner
start_spinner "Connecting to device..."

# Power on and connect to the selected device using bluetoothctl
echo -e "power on\nconnect $DEVICE_MAC\nexit" | bluetoothctl >/dev/null 2>&1

# Continuously check if the device is connected
while true; do
    # Check if the device is connected
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        # Get the device name
        DEVICE_NAME=$(bluetoothctl info "$DEVICE_MAC" | grep "Name:" | awk -F ": " '{print $2}')
        echo -e "\nConnection to $DEVICE_NAME successful!"
        break
    else
        sleep 1  # Check every second
    fi
done

# Stop the spinner once the connection attempt is complete
stop_spinner
