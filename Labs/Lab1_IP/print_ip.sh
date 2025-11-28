#!/bin/bash

# LAB 1 (IP)
# ================================

input="$1"

# -z means "string length is zero"
if [[ -z "$input" ]]; then
    echo "Usage: $0 ip/mask"
    exit 1
fi


# ================================
# SPLIT IP AND MASK
# ================================

# Remove everything after the first "/" including "/"
ip="${input%/*}"

# Remove everything before the first "/" including "/"
mask="${input#*/}"

# If there was no "/" in input, ip and mask will be identical
# In that case, set mask to empty string
if [[ "$ip" == "$mask" ]]; then
    mask=""
fi


# ================================
# VALIDATE IP FORMAT
# ================================

# Split IP by dots using Internal Field Separator
# -r - read only
# -a - store split parts in an array
# <<< - sends variable into read
IFS='.' read -r -a octets <<< "$ip"

# Check octets array size
if [[ ${#octets[@]} -ne 4 ]]; then
    echo "Invalid IP address: wrong octets count"
    exit 1
fi

# Check each octet
for octet in "${octets[@]}"; do
    # Check if octet is a number (by using regex)
    if ! [[ "$octet" =~ ^[0-9]+$ ]]; then
        echo "Invalid IP address: octet '$octet' is not a number"
        exit 1
    fi

    # Check leading zeros
    if [[ "$octet" =~ ^0[0-9]+$ ]]; then
        echo "Invalid IP address: octet '$octet' has leading zeros"
        exit 1
    fi

    # Check numeric range 0-255
    if (( octet < 0 || octet > 255 )); then
        echo "Invalid IP address: octet '$octet' out of range"
        exit 1
    fi
done


# ================================
# DETERMINE CIDR MASK
# ================================

# If mask was not provided then determine by IP class
if [[ -z "$mask" ]]; then
    first_octet=${ip%%.*}

    if (( first_octet >= 1 && first_octet <= 126 )); then
        mask=8

    elif (( first_octet >= 128 && first_octet <= 191 )); then
        mask=16

    elif (( first_octet >= 192 && first_octet <= 223 )); then
        mask=24

    else
        echo "Unknown IP class for this first octet '$first_octet'"
        exit 1
    fi

# If mask provided
else
    case "$mask" in
        "255.0.0.0") mask=8 ;;
        "255.255.0.0") mask=16 ;;
        "255.255.255.0") mask=24 ;;
        8|16|24) ;; # Already numeric, do nothing
        *)
            # Default commands
            echo "Unknown mask '$mask'"
            exit 1
            ;;
    esac
fi


# ================================
# Print result
echo $ip/$mask