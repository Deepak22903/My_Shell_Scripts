#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh
# Define the MAC address of the Bluetooth device
DEVICE_MAC="71:A2:60:FD:59:78"  # Replace with your device MAC address

# Start the spinner
start_spinner "Connecting to device..."

# Power on and connect to the device using bluetoothctl
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
