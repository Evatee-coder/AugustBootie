#!/bin/bash

# # This script checks if a given number is even or odd.

# # Prompt the user to enter a number
# echo "Enter a number:"
# read number

# # Check if the input is a valid integer using a regular expression
# if ! [[ "$number" =~ ^-?[0-9]+$ ]]; then
#     echo "Error: Please enter a valid integer."
#     exit 1
# fi

# # Use modulo operator to check if the number is even or odd
# # If the remainder when divided by 2 is 0, it's even; otherwise, it's odd
# if (( number % 2 == 0 )); then
#     echo "$number is even."

# else
#     echo "$number is odd."
# fi


#################################

# # Prompt the user to enter a value
# echo "Enter a value:"
# read value

# # Check if the input is a valid integer
# if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
#     echo "Error: Please enter a valid integer."
#     exit 1
# fi

# # Compare the value to 10
# if (( value > 10 )); then
#     echo "$value is greater than 10."
# elif (( value < 10 )); then
#     echo "$value is less than 10."
# else
#     echo "$value is equal to 10."
# fi

###############################################

#echo "Enter a number:"
#read number

#if [ $((number % 2)) -eq 0 ]; then
 #   echo "$number is even."
#else
 #   echo "number is odd."
#fi

#############################################

echo "Enter a filename:"
read filename

if [ -e "$filename" ]; then
    echo "File '$filename' exists."
else
    echo "File '$filename' does not exist."
fi
