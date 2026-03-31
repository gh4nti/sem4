# Write a shell script to calculate the gross salary. GS=Basics + TA + 10% of Basics. Floating point calculations have to be performed.

#!/bin/bash

echo "Enter basic salary:"
read basic

echo "Enter TA:"
read ta

gs=$(echo "$basic + $ta + ($basic * 0.10)" | bc)

echo "Gross Salary = $gs"