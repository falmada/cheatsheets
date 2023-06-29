#!/bin/bash

# scriptName.sh
# Description: long description for my script to understand what it does
#              without having issues with linting

# Default values
coption="default"
soption=0

# Usage info
print_usage() {
  printf "Usage: $0 -s -c value\n"
  printf "More info to show as usage\n"
}

# Functions

# Parameters
while getopts 'sc:v' flag; do
  case "${flag}" in
    c) coption="${OPTARG}" ;;
    s) soption="1" ;;
    *) print_usage ;;
  esac
done

# Main