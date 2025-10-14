#!/bin/bash

###############Part 1########################

# a=14
# b=asdf
# c=123asdf

# echo $a
# echo $b
# echo $c

# echo "a =$a b =$b c =$c"
##############Part 2 user input ########################

# echo "What is your name?"
# read name
# echo "Hello, $name!"

##############Part 3 command line arguments ########################

# usage -> ./scripts.sh arg1 arg2 arg3
echo "Script name: $0"
echo "The first argument is: $1"
echo "The second argument is: $2"
echo "All argument is: $@"
echo "Total number of arguments: $#" 
echo "The process ID of this script is: $$"
echo "The last command's exit status was: $?" # exit code 0 means success, any other number indicates failure.
ls -lkkkkkkk
echo "The last command's exit status was: $?"



