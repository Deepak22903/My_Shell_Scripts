#!/bin/bash

# Function to wait until a window containing a specific keyword appears
wait_for_window() {
    local keyword=$1
    while ! hyprctl clients | grep -iq "$keyword"; do
        sleep 0.1
    done
}

# Launch a second kitty instance, then firefox
kitty &
sleep 0.1
hyprctl dispatch workspace 2
firefox &
wait_for_window "firefox"  # adjust keyword if needed
hyprctl dispatch workspace 3
sleep 0.1

# Launch yazi and wait for its window
yazi &
wait_for_window "yazi"     # adjust keyword if needed
hyprctl dispatch workspace 1
