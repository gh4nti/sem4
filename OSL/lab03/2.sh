# Write a shell script to list all files (only file names) containing the input pattern (string) in the folder entered by the user.

#!/bin/bash

echo "Enter the directory path:"
read dir

echo "Enter the pattern to search:"
read pattern

if [ ! -d "$dir" ]; then
    echo "Directory does not exist"
    exit 1
fi

grep -l "$pattern" "$dir"/* 2>/dev/null