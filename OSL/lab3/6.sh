# Write a shell script to modify all occurrences of “ex:” with “Example:” in all the files present in current folder only if “ex:” occurs at the start of the line or after a period (.). Example: if a file contains a line: “ex: this is first occurrence so should be replaced” and “second ex: should not be replaced as it occurs in the middle of the sentence.

#!/bin/bash

for file in *
do
    if [ -f "$file" ]; then
        sed -i 's/\(^\|\. \)ex:/\1Example:/g' "$file"
    fi
done