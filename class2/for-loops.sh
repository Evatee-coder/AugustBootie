#!/bin/bash

# =============================================================================
# FOR LOOP EXAMPLES - BASIC TO ADVANCED
# =============================================================================


# =============================================================================
# 1. BASIC - Simple Number Range
# =============================================================================
# for i in {1..5}; do
#     echo "Iteration number: $i"
# done

#----------------------------------------------------------------------------
# for fruit in apple banana cherry date elderberry fig grape
# do
#     echo "I like $fruit"
# done


# =============================================================================
# 2. BEGINNER - File Processing
# =============================================================================
# echo "2. BEGINNER - File Processing:"
# echo "Processing files in current directory:"

# # Create some test files first
# touch test1.txt test2.txt test3.log

# for file in *.txt *.log; do
#     if [ -f "$file" ]; then
#         echo "Processing file: $file"
#         echo "  - Size: $(stat -c%s "$file") bytes"
#         echo "  - Last modified: $(stat -c%y "$file" | cut -d' ' -f1)"
#     fi
# done

# # Clean up test files
# rm -f test1.txt test2.txt test3.log

# echo
# echo "----------------------------------------"

# =============================================================================
# 3. INTERMEDIATE - C-style Loop with Conditions
# =============================================================================
for ((i=1; i<=10; i++))
 do
    echo "Number: $i"
    #Calculate square of the number
    square=$((i * i))
    echo "Square of $i is $square"
done