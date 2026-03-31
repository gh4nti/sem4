# Write a shell script which deletes all the even numbered lines in a text file.

#!/bin/bash

echo "Enter file name:"
read file

if [ ! -f "$file" ]; then
    echo "File does not exist"
    exit 1
fi

sed '2~2d' "$file"