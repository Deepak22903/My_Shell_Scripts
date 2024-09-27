#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Find the process IDs (PIDs) of create_ap
pids=$(pgrep create_ap)

# Check if any PIDs were found
if [ -n "$pids" ]; then
    echo "Stopping create_ap with PIDs: $pids"
    
    # Iterate over each PID and kill it
    for pid in $pids; do
        kill "$pid"
        
        # Optionally, wait for the process to terminate and check
        sleep 2
        if ps -p "$pid" > /dev/null; then
            echo "Failed to stop create_ap with PID: $pid, trying to kill forcefully."
            kill -9 "$pid"  # Force kill if it doesn't stop
        else
            echo "create_ap with PID $pid stopped successfully."
        fi
    done
else
    echo "create_ap is not running."
fi
