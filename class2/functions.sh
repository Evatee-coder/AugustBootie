#!/bin/bash

# # =============================================================================
# # BASIC SHELL FUNCTIONS - EXAMPLES
# # =============================================================================

# echo "=== BASIC SHELL FUNCTIONS EXAMPLES ==="
# echo

# # =============================================================================
# # 1. SIMPLEST FUNCTION - No parameters, no return value
# # =============================================================================
# echo "1. Simple Hello Function:"

# # Function definition
# hello() {
#     echo "Hello, World!"
#     echo "This is my first function"
# }

# # Function call
# hello

# echo
# echo "----------------------------------------"

# =============================================================================
# 2. FUNCTION TO PRINT CPU USAGE
# =============================================================================
echo "2. CPU Usage Function:"

print_cpu_usage() {
    local time_now cpu_usage mem_usage
    time_now=$(date +"%Y-%m-%d %H:%M:%S")
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    mem_usage=$(free -m | awk '/Mem:/ { printf "%.2f", $3/$2 * 100.0 }')
    echo "[$time_now] CPU Usage: $cpu_usage% | Memory Usage: $mem_usage MB"
}

print_cpu_usage

echo
echo "----------------------------------------"