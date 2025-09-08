#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <file.cpp>"
  exit 1
fi

g++ "$1" -o a.out && ./a.out
