#!/bin/bash

# Parameters
while getopts 'sc:v' flag; do
  case "${flag}" in
    c) coption="${OPTARG}" ;;
    s) soption="1" ;;
    *) print_usage ;;
  esac
done