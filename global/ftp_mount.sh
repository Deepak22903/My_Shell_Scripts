#!/bin/bash

# Define variables
MOUNT_POINT="/home/deepak/peekdeep.com"  # Replace with the actual mount point path
FTP_URL="ftp://u397715467:Deepak%409175@217.21.95.62:21/"

# Check if the mount point is already mounted
if mountpoint -q "$MOUNT_POINT"; then
    echo "FTP is already mounted. Unmounting..."
    fusermount -u "$MOUNT_POINT"
    sleep 5  # Give some time to unmount
else
    echo "FTP is not mounted."
fi

# Mount the FTP server
echo "Mounting FTP server..."
curlftpfs -v "$FTP_URL" "$MOUNT_POINT"

# Check if the mount was successful
if mountpoint -q "$MOUNT_POINT"; then
    echo "FTP server mounted successfully at $MOUNT_POINT."
else
    echo "Failed to mount FTP server."
fi
