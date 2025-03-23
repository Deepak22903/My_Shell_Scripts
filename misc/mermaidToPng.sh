#!/bin/bash

# Check if a file was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_mermaid_file> [output_file.png]"
    exit 1
fi

# Input file (convert to absolute path)
INPUT_FILE=$(realpath "$1")
INPUT_DIR=$(dirname "$INPUT_FILE")
INPUT_FILENAME=$(basename "$INPUT_FILE")

# Output file (default based on input filename if not provided)
if [ $# -ge 2 ]; then
    OUTPUT_FILE=$(realpath "$2")
else
    # Replace extension with .png
    OUTPUT_FILE="${INPUT_FILE%.*}.png"
fi
OUTPUT_FILENAME=$(basename "$OUTPUT_FILE")

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH."
    exit 1
fi

echo "Converting $INPUT_FILE to $OUTPUT_FILE..."

# Run the conversion using minlag/mermaid-cli Docker image
docker run --rm -v "$INPUT_DIR:/data" minlag/mermaid-cli \
    -i "/data/$INPUT_FILENAME" \
    -o "/data/$OUTPUT_FILENAME" \
    -t neutral

# Check if conversion was successful
if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ]; then
    echo "Conversion successful!
