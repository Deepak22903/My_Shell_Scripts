#!/bin/bash
tmpfile=$(mktemp /tmp/screenshot_XXXX.png)
grim -g "$(slurp)" "$tmpfile"
tesseract "$tmpfile" - -l eng | wl-copy
rm "$tmpfile"
