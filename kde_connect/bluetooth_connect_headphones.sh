#!/bin/bash

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Source the spinner script
source /home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/global/spinner.sh

# ASCII Art Banner
print_banner() {
    echo -e "${BLUE}"
    echo '  ____  _            _              _   _     '
    echo ' | __ )| |_   _  ___| |_ ___   ___ | |_| |__  '
    echo ' |  _ \| | | | |/ _ \ __/ _ \ / _ \| __| |_ \ '
    echo ' | |_) | | |_| |  __/ || (_) | (_) | |_| | | |'
    echo ' |____/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|'
    echo -e "${NC}"
    echo -e "${CYAN}Bluetooth Connection Manager${NC}\n"
}

# Error handling function
handle_error() {
    echo -e "\n${RED}${BOLD}ERROR:${NC} $1"
    exit 1
}

# Success message function
print_success() {
    echo -e "\n${GREEN}${BOLD}✓ SUCCESS:${NC} $1\n"
}

# Print status function
print_status() {
    echo -e "${CYAN}╭─────────── Connection Status ───────────╮${NC}"
    echo -e "${CYAN} ${NC} Device Name: ${BOLD}$1${NC}"
    echo -e "${CYAN} ${NC} MAC Address: ${BOLD}$2${NC}"
    echo -e "${CYAN} ${NC} Status: ${GREEN}${BOLD}Connected${NC} ✓"
    echo -e "${CYAN}╰─────────────────────────────────────────╯${NC}"
}

# Main script
clear  # Clear the screen before starting
print_banner

# Get the list of paired devices and use fzf with a preview window
echo -e "${YELLOW}Scanning for paired devices...${NC}"
DEVICE=$(bluetoothctl devices | fzf \
    --prompt="🔍 Select a Bluetooth device: " \
    --height=40% \
    --border rounded \
    --ansi \
    --preview "echo -e '${CYAN}Device Info:${NC}\n'; bluetoothctl info \$(echo {} | awk '{print \$2}')" \
    --preview-window=right:50%:wrap)

# Extract the MAC address from the selected device
DEVICE_MAC=$(echo "$DEVICE" | awk '{print $2}')

# If no device is selected, exit the script
[ -z "$DEVICE_MAC" ] && handle_error "No device selected. Exiting..."

# Start the spinner with custom message
start_spinner "${YELLOW}Attempting to connect to the device...${NC}"

# Retry connection at intervals
RETRY_INTERVAL=5  # Interval in seconds
RETRY_COUNT=0
MAX_RETRIES=5
CONNECTED=false

while [ "$CONNECTED" = false ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    # Power on and attempt to connect to the selected device
    echo -e "power on\nconnect $DEVICE_MAC\nexit" | bluetoothctl >/dev/null 2>&1
    
    # Check if the device is connected
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        # Get the device name
        DEVICE_NAME=$(bluetoothctl info "$DEVICE_MAC" | grep "Name:" | awk -F ": " '{print $2}')
        stop_spinner
        print_success "Connected to ${BOLD}$DEVICE_NAME${NC}"
        CONNECTED=true
    else
        ((RETRY_COUNT++))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo -e "\n${YELLOW}Connection attempt $RETRY_COUNT failed. Retrying in $RETRY_INTERVAL seconds...${NC}"
            sleep $RETRY_INTERVAL
        fi
    fi
done

# Handle connection failure after max retries
if [ "$CONNECTED" = false ]; then
    stop_spinner
    handle_error "Failed to connect after $MAX_RETRIES attempts. Please try again."
fi

# Print connection status in a box
print_status "$DEVICE_NAME" "$DEVICE_MAC"
