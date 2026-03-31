# Write a shell script that, given a file name as the  argument  will  write  the  even numbered line to a file with name evenfile and odd numbered lines to a file called oddfile.

#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

file=$1

if [ ! -f "$file" ]; then
    echo "File does not exist"
    exit 1
fi

awk 'NR % 2 == 0 { print > "evenfile" }
     NR % 2 != 0 { print > "oddfile" }' "$file"

echo "Odd lines written to oddfile"
echo "Even lines written to evenfile"