#!/bin/bash
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh

# Get the list of currently active Wi-Fi and Ethernet connections
ACTIVE_CONNECTIONS=$(nmcli -f NAME,TYPE connection show --active | tail -n +2 | fzf --prompt="Select a network to disconnect (Wi-Fi or Ethernet): " --height=40% --border)

# If no connection is selected, exit the script
if [ -z "$ACTIVE_CONNECTIONS" ]; then
    echo "No network selected. Exiting..."
    exit 1
fi

# Extract the selected active connection name (until the last column, which is the type)
SELECTED_CONNECTION=$(echo "$ACTIVE_CONNECTIONS" | awk '{$NF=""; print $0}' | sed 's/[[:space:]]*$//')

# Start the spinner
start_spinner "Disconnecting from $SELECTED_CONNECTION..."

# Attempt to disconnect the selected network
nmcli connection down "$SELECTED_CONNECTION" >/dev/null 2>&1

# Continuously check if the specific selected connection is disconnected
while true; do
    # Check if the selected connection is no longer active
    if ! nmcli -f NAME connection show --active | grep -q "$SELECTED_CONNECTION"; then
        echo -e "\nDisconnected from $SELECTED_CONNECTION successfully!"
        break
    else
        sleep 1  # Check every second
    fi
done

# Stop the spinner once the disconnection attempt is complete
stop_spinner
