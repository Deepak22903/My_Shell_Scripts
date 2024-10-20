#!/data/data/com.termux/files/usr/bin/bash

LOCAL_DIR="/data/data/com.termux/files/home/storage/shared/"
REMOTE_DIR="deepak@192.168.12.1:/mnt/deepak/data/Realme\ 6\ Pro/"

# Run rsync to sync the files, excluding the Android directory
rsync -avz --progress --exclude 'Android/' "$LOCAL_DIR" "$REMOTE_DIR"

rsync -avz --progress /data/data/com.termux/files/home/storage/shared/Android/media/com.whatsapp/WhatsApp/ deepak@192.168.12.1:/mnt/deepak/data/Realme\ 6\ Pro/WhatsApp/
