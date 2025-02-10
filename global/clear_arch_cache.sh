#!/bin/bash

echo "Clearing pacman cache..."
sudo pacman -Scc --noconfirm

echo "Clearing yay cache..."
yay -Scc --noconfirm

echo "Clearing systemd journal logs (optional, keeps last 100MB)..."
sudo journalctl --vacuum-size=100M

echo "Clearing temporary files..."
sudo rm -rf /tmp/*

echo "Clearing user cache..."
rm -rf ~/.cache/*

echo "Clearing unused orphaned packages..."
sudo pacman -Rns $(pacman -Qdtq) --noconfirm

echo "Syncing disk..."
sync

echo "Cache cleanup completed!"
