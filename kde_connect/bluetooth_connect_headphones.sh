#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh

# Get the list of paired devices and use fzf with a preview window
DEVICE=$(bluetoothctl devices | fzf --prompt="Select a Bluetooth device: " --height=40% --border --ansi --preview 'bluetoothctl info $(echo {} | awk "{print \$2}")')

# Extract the MAC address from the selected device
DEVICE_MAC=$(echo "$DEVICE" | awk '{print $2}')

# If no device is selected, exit the script
if [ -z "$DEVICE_MAC" ]; then
    echo "No device selected. Exiting..."
    exit 1
fi

# Start the spinner
start_spinner "Attempting to connect to the device..."

# Retry connection at intervals
RETRY_INTERVAL=5  # Interval in seconds
CONNECTED=false

while [ "$CONNECTED" = false ]; do
    # Power on and attempt to connect to the selected device
    echo -e "power on\nconnect $DEVICE_MAC\nexit" | bluetoothctl >/dev/null 2>&1

    # Check if the device is connected
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        # Get the device name
        DEVICE_NAME=$(bluetoothctl info "$DEVICE_MAC" | grep "Name:" | awk -F ": " '{print $2}')
        echo -e "\nConnection to $DEVICE_NAME successful!"
        CONNECTED=true
    else
        echo "Connection attempt failed. Retrying in $RETRY_INTERVAL seconds..."
        sleep $RETRY_INTERVAL
    fi
done

# Stop the spinner once the connection is successful
stop_spinner
