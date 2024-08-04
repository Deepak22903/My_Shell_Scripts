#!/bin/bash

# Define the output file
output_file="workout_data.csv"

# Write the header to the CSV file
echo "Date,Exercise,Reps,Weight" > "$output_file"

# Define the data
data="25/07/2024
Shoulder day-
Pushup-
12,,
9,,
7,,
Shoulder bar-
12,no weight
10,5kg
8,5kg
6,5kg
Shoulder dumbbell raises-
12,7.5
6,10
3,10
Rotating Shoulder dumbbell raises-
8,7.5
7,7.5
6,7.5
Butterfly shoulder-
8,16
6,16
4,16
Rope to face (for shoulder)-
12,16
10,16
8,20
Collar-
12,only bar
8,2.5
6,2.5"

# Read the data and format it into the CSV file
date=""
exercise=""
while IFS= read -r line; do
    if [[ "$line" =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
        date="$line"
    elif [[ "$line" == *-* ]]; then
        exercise="${line%-}"
    else
        IFS=',' read -r reps weight <<< "$line"
        echo "$date,$exercise,$reps,$weight" >> "$output_file"
    fi
done <<< "$data"

echo "Data has been written to $output_file"
