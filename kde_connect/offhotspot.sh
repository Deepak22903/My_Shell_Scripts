#!/bin/bash
sudo killall create_ap hostapd dnsmasq
sudo ip link set wlan0 down
sudo ip addr flush dev wlan0
sudo ip link set wlan0 up
sudo systemctl restart NetworkManager
