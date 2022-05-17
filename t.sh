#!/bin/bash

while getopts ":n:d" opt; do
  case $opt in
    n)
      NAMESPACE=$OPTARG
      echo "Selected namespace: $NAMESPACE" >&2
      ;;
    d)
      DRYRUN=1
      echo "Dry-run enabled"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z ${NAMESPACE} ]; then 
  echo "namespace parameter is mandatory"
  exit 1
fi

