#!/bin/bash

file=/tmp/$(hostname)_$(date "+%Y%m%d_%H%M%S").png; spectacle -bno "${file}" && kdeconnect-cli -d $(kdeconnect-cli -a --id-only) --share ${file}

