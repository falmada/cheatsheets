#!/bin/bash

# Parameters
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -l|--local-sync-dir)
      LOCAL_SYNC_DIR="$2"
      shift
      shift
      ;;
    -v|--version)
      VERSION="$2"
      shift
      shift
      ;;
    -d|--dry-run)
      DRY_RUN="true"
      shift # past argument
      ;;
    -f|--force-sync)
      FORCE_SYNC="true"
      shift
      ;;
    -op|--operation)
      OPERATION="$2"
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters
