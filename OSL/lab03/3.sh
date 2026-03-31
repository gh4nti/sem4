# Write a shell script to replace all files with .txt extension with .text in the current directory. This has to be done recursively i.e if the current folder contains a folder “OS” with abc.txt then it has to be changed to abc.text (Hint: use find, mv).

#!/bin/bash

find . -type f -name "*.txt" | while read file
do
    newfile="${file%.txt}.text"
    mv "$file" "$newfile"
done