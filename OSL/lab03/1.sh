# Write a shell script to find whether a given file is the directory or regular file.

#!/bin/bash

echo "Enter file or directory name:"
read fname

if [ -d "$fname" ]; then
    echo "$fname is a directory"
elif [ -f "$fname" ]; then
    echo "$fname is a regular file"
else
    echo "$fname does not exist"
fi