
#!/bin/bash

# Function to count even and odd numbers in a range
count_even_odd() {
    local start=$1
    local end=$2
    local even_count=0
    local odd_count=0

    echo "Printing Even Numbers : "
    for (( num=start; num<=end; num++ )); do
        if (( num % 2 == 0 )); then
            (( even_count++ ))
            echo $num
        fi
    done

    echo "Printing odd numbers : "
    for (( num=start; num<=end; num++ )); do
        if (( num % 2 != 0 )); then
            (( odd_count++ ))
            echo $num
        fi
    done
    echo "Number of even numbers: $even_count"
    echo "Number of odd numbers: $odd_count"
}

# Read range from user
read -p "Enter the start of the range: " start
read -p "Enter the end of the range: " end

# Validate input
if ! [[ "$start" =~ ^-?[0-9]+$ ]] || ! [[ "$end" =~ ^-?[0-9]+$ ]]; then
    echo "Please enter valid integers."
    exit 1
fi

# Ensure start is less than or equal to end
if [ $start -gt $end ]; then
    echo "Start of the range should be less than or equal to the end."
    exit 1
fi

# Count even and odd numbers in the range
count_even_odd $start $end
