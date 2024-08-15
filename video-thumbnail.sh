#!/bin/bash

VIDEO_PATH="$1"
THUMBNAIL_PATH="/tmp/video_thumbnail.png"

echo "Generating thumbnail for $VIDEO_PATH" >> /tmp/yazi_debug.log

ffmpeg -i "$VIDEO_PATH" -vf "thumbnail,scale=320:240" -frames:v 1 "$THUMBNAIL_PATH"

if [[ -f "$THUMBNAIL_PATH" ]]; then
    echo "Thumbnail created at $THUMBNAIL_PATH" >> /tmp/yazi_debug.log
else
    echo "Failed to create thumbnail" >> /tmp/yazi_debug.log
    exit 1
fi
