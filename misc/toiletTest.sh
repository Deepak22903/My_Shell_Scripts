#!/bin/bash

DIR="/usr/share/figlet"

# Convert output to an array
mapfile -t RAND < <(eza "$DIR" | grep '\.flf$' | sed 's/\.flf$//')

# Loop through the array
for ((i = 0; i < "${#RAND[@]}"; i++)); do
  # echo "$i"
  # echo "${RAND[i]}" # Use proper syntax to access array elements
  echo -e "${RAND[i]}: \n"
  (toilet hello -f ${RAND[i]})
done
