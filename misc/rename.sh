#!/bin/bash
files=($(ls $1*))
for ((i = 0; i < ${#files[@]}; i++)); do
  j=${i}
  ((j++))
  echo "changing ${files[i]} to ${2}${j}.png"
  echo "choose y/n"
  read -r confirm
  if [[ ${confirm} -eq "y" ]]; then
    mv "${files[i]}" "${2}${j}.png"
  else
    continue
  fi

done
