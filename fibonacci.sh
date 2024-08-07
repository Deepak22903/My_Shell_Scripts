#!/bin/bash

fibonacci() {
    local n=$1
    local a=0
    local b=1

    echo "Fibonacci series up to $n terms:"
    for (( i=0; i<n; i++ )); do
        echo -n "$a "
        local temp=$(( a + b ))
        a=$b
        b=$temp
    done
    echo
}

read -p "Enter the number of terms: " terms

if ! [[ "$terms" =~ ^[0-9]+$ ]] || [ "$terms" -le 0 ]; then
    echo "Please enter a valid positive integer."
    exit 1
fi

fibonacci $terms
