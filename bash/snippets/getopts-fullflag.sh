#!/bin/bash

# Usage
print_usage (){
  echo "Usage: ./script.sh [-i ACCESS_KEY_ID] [-k SECRET_KEY] [-r us-east-1]"
  echo "       -i|--AWS_ACCESS_KEY_ID        The access key used to communicate with AWS (Optional)"
  echo "       -k|--AWS_SECRET_ACCESS_KEY    The secret key used to communicate with AWS (Optional)"
  echo "       -r|--AWS_REGION               The region with AWS (Optional)"
  echo "       -h|--help                     Show help."
  echo "Note: Optional values may be fetched from your environment variables."
  exit 1
}

# Get variables from environment or whipe them
while [ "$1" != "" ]; do
    case $1 in
      -i|--AWS_ACCESS_KEY_ID)
        AWS_ACCESS_KEY_ID=$2
        shift 2
        ;;
      -k|--AWS_SECRET_ACCESS_KEY)
        AWS_SECRET_ACCESS_KEY=$2
        shift 2
		;;
	  -r|--AWS_REGION)
        AWS_REGION=$2
        shift 2
		;;
      *|-*|-h|--help|/?|help) print_usage ;;
    esac
done