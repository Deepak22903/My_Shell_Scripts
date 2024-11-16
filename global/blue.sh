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

# # ASCII Art Banner
# print_banner() {
#     echo -e "${BLUE}"
#     echo '  ____  _            _              _   _     '
#     echo ' | __ )| |_   _  ___| |_ ___   ___ | |_| |__  '
#     echo ' |  _ \| | | | |/ _ \ __/ _ \ / _ \| __| |_ \ '
#     echo ' | |_) | | |_| |  __/ || (_) | (_) | |_| | | |'
#     echo ' |____/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|'
#     echo -e "${NC}"
#     echo -e "${CYAN}Bluetooth Connection Manager${NC}\n"
# }

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
    local device_name="$1"
    local mac_address="$2"
    local status="$3"
    local symbol="$4"
    
    echo -e "${CYAN}╭─────────── Connection Status ───────────╮${NC}"
    echo -e "${CYAN} ${NC} Device Name: ${BOLD}$device_name${NC}"
    echo -e "${CYAN} ${NC} MAC Address: ${BOLD}$mac_address${NC}"
    echo -e "${CYAN} ${NC} Status: $status${BOLD}$symbol${NC}"
    echo -e "${CYAN}╰─────────────────────────────────────────╯${NC}"
}

# Function to check if a device is connected
is_device_connected() {
    bluetoothctl info "$1" | grep -q "Connected: yes"
    return $?
}

# Function to get device name
get_device_name() {
    bluetoothctl info "$1" | grep "Name:" | awk -F ": " '{print $2}'
}

# Function to connect to a device
connect_device() {
    local device_mac="$1"
    local retry_interval=5
    local retry_count=0
    local max_retries=5
    local connected=false

    start_spinner "Attempting to connect to the device..."

    while [ "$connected" = false ] && [ $retry_count -lt $max_retries ]; do
        echo -e "power on\nconnect $device_mac\nexit" | bluetoothctl >/dev/null 2>&1
        
        if is_device_connected "$device_mac"; then
            local device_name=$(get_device_name "$device_mac")
            stop_spinner
            print_success "Connected to ${BOLD}$device_name${NC}"
            print_status "$device_name" "$device_mac" "$GREEN" "Connected" "✓"
            connected=true
        else
            ((retry_count++))
            if [ $retry_count -lt $max_retries ]; then
                echo -e "\n${YELLOW}Connection attempt $retry_count failed. Retrying in $retry_interval seconds...${NC}"
                sleep $retry_interval
            fi
        fi
    done

    if [ "$connected" = false ]; then
        stop_spinner
        handle_error "Failed to connect after $max_retries attempts. Please try again."
    fi
}

 # Function to disconnect from a device
disconnect_device() {
    local device_mac="$1"
    local device_name=$(get_device_name "$device_mac")
    local max_attempts=10
    local attempt=0
    local disconnect_interval=1
    
    start_spinner "Disconnecting from $device_name..."
    echo -e "disconnect $device_mac\nexit" | bluetoothctl >/dev/null 2>&1
    
    # Wait and check disconnect status with multiple attempts
    while [ $attempt -lt $max_attempts ]; do
        sleep $disconnect_interval
        
        if ! is_device_connected "$device_mac"; then
            stop_spinner
            print_success "Disconnected from ${BOLD}$device_name${NC}"
            print_status "$device_name" "$device_mac" "${RED}Disconnected${NC} " "×"
            return 0
        fi
        
        ((attempt++))
    done
    
    stop_spinner
    handle_error "Failed to disconnect from $device_name after $max_attempts attempts"
}

# Main script
# clear  # Clear the screen before starting
# print_banner

# Get list of all devices
all_devices=$(bluetoothctl devices)
if [ -z "$all_devices" ]; then
    handle_error "No paired devices found."
fi

# Show action selection menu
echo -e "${YELLOW}Choose an action:${NC}"
action=$(echo -e "Connect\nDisconnect" | \
    fzf --prompt="🔍 Select action: " \
        --height=40% \
        --border rounded \
        --ansi)

case "$action" in
    "Connect")
        echo -e "\n${YELLOW}Select a device to connect:${NC}"
        DEVICE=$(echo "$all_devices" | \
            fzf --prompt="🔍 Select a Bluetooth device: " \
                --height=40% \
                --border rounded \
                --ansi \
                --preview "echo -e '${CYAN}Device Info:${NC}\n'; bluetoothctl info \$(echo {} | awk '{print \$2}')" \
                --preview-window=right:50%:wrap)
        
        # Extract the MAC address from the selected device
        DEVICE_MAC=$(echo "$DEVICE" | awk '{print $2}')
        
        # If no device is selected, exit the script
        [ -z "$DEVICE_MAC" ] && handle_error "No device selected. Exiting..."
        
        # Check if already connected
        if is_device_connected "$DEVICE_MAC"; then
            handle_error "Device is already connected!"
        else
            connect_device "$DEVICE_MAC"
        fi
        ;;
        
    "Disconnect")
        echo -e "\n${YELLOW}Select a device to disconnect:${NC}"
        # Only show connected devices in the disconnect menu
        connected_devices=""
        while IFS= read -r device; do
            device_mac=$(echo "$device" | awk '{print $2}')
            if is_device_connected "$device_mac"; then
                connected_devices+="$device\n"
            fi
        done <<< "$all_devices"
        
        if [ -z "$connected_devices" ]; then
            handle_error "No connected devices found."
        fi
        
        DEVICE=$(echo -e "$connected_devices" | \
            fzf --prompt="🔍 Select a device to disconnect: " \
                --height=40% \
                --border rounded \
                --ansi \
                --preview "echo -e '${CYAN}Device Info:${NC}\n'; bluetoothctl info \$(echo {} | awk '{print \$2}')" \
                --preview-window=right:50%:wrap)
        
        # Extract the MAC address from the selected device
        DEVICE_MAC=$(echo "$DEVICE" | awk '{print $2}')
        
        # If no device is selected, exit the script
        [ -z "$DEVICE_MAC" ] && handle_error "No device selected. Exiting..."
        
        disconnect_device "$DEVICE_MAC"
        ;;
        
    *)
        handle_error "Invalid action selected. Exiting..."
        ;;
esac
