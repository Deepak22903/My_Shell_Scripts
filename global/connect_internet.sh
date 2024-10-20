#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh

# Get the list of saved Wi-Fi and Ethernet connections
# Use '-f NAME,TYPE' to get both connection names and types, preserving spaces in names
CONNECTIONS=$(nmcli -f NAME,TYPE connection show | tail -n +2 | fzf --prompt="Select a network (Wi-Fi or Ethernet): " --height=40% --border)

# If no connection is selected, exit the script
if [ -z "$CONNECTIONS" ]; then
    echo "No network selected. Exiting..."
    exit 1
fi

# Extract the selected connection name (until the last column, which is the type)
SELECTED_CONNECTION=$(echo "$CONNECTIONS" | awk '{$NF=""; print $0}' | sed 's/[[:space:]]*$//')

# Start the spinner
start_spinner "Connecting to $SELECTED_CONNECTION..."

# Attempt to connect to the selected network
nmcli connection up "$SELECTED_CONNECTION" >/dev/null 2>&1

# Continuously check if the device is connected
while true; do
    if nmcli -t -f STATE general | grep -q "connected"; then
        echo -e "\nConnected to $SELECTED_CONNECTION successfully!"
        break
    else
        sleep 1  # Check every second
    fi
done

# Stop the spinner once the connection attempt is complete
stop_spinner
