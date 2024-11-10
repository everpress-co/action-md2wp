#!/bin/bash

# Check if README.md exists
if [ ! -f "README.md" ]; then
    echo "README.md file not found!"
    exit 1
fi

# Define output file
OUTPUT_FILE="readme.txt"

# Initialize output file
echo "Generating $OUTPUT_FILE..."

# Read the README.md file line by line
while IFS= read -r line; do

    # Convert # Headers
    if [[ $line == '### '* ]]; then
        echo "= ${line:4} =" >> "$OUTPUT_FILE"
    elif [[ $line == '## '* ]]; then
        echo "== ${line:3} ==" >> "$OUTPUT_FILE"
    elif [[ $line == '# '* ]]; then
        echo "=== ${line:2} ===" >> "$OUTPUT_FILE"

    # Add a blank line for better readability
    elif [[ -z "$line" ]]; then
        echo "" >> "$OUTPUT_FILE"
    
    # Otherwise, print the line as-is
    else
        echo "$line" >> "$OUTPUT_FILE"
    fi

done < README.md

# Add Tags and License if they don’t already exist in the output
if ! grep -q "Tags:" $OUTPUT_FILE; then
    echo -e "\nTags: tag1, tag2, tag3" >> "$OUTPUT_FILE"
fi
if ! grep -q "License:" $OUTPUT_FILE; then
    echo "License: GPLv2 or later" >> "$OUTPUT_FILE"
fi

echo "Conversion complete. Check $OUTPUT_FILE for the results."
