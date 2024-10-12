#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh

# Get the list of connected devices
CONNECTED_DEVICE=$(bluetoothctl devices | while read -r line; do
    MAC=$(echo "$line" | awk '{print $2}')
    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
        echo "$line"
    fi
done)

# Check if there is any connected device
if [ -z "$CONNECTED_DEVICE" ]; then
    echo "No device is currently connected."
    exit 1
fi

# Extract the MAC address and name of the connected device
DEVICE_MAC=$(echo "$CONNECTED_DEVICE" | awk '{print $2}')
DEVICE_NAME=$(echo "$CONNECTED_DEVICE" | awk '{for(i=3;i<=NF;i++) printf $i " "; print ""}')

# Start the spinner
start_spinner "Disconnecting from $DEVICE_NAME..."

# Disconnect from the device using bluetoothctl
echo -e "disconnect $DEVICE_MAC\nexit" | bluetoothctl >/dev/null 2>&1

# Continuously check if the device is disconnected
while true; do
    # Check if the device is disconnected
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: no"; then
        echo -e "\nDisconnected from $DEVICE_NAME successfully!"
        break
    else
        sleep 1  # Check every second
    fi
done

# Stop the spinner once the disconnection attempt is complete
stop_spinner
