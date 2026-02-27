#!/usr/bin/env bash

# Environment Variables
DB_FILE="./data.db"
LOG_FILE="./hnsql.log"

PROMPT="$(whoami)@hnsql ~ "

# Imports
source ./lib/get.sh
source ./lib/index.sh
source ./lib/init.sh
source ./lib/set.sh

if [[ ! -f "$DB_FILE" || ! -f "$LOG_FILE" ]]; then
  initial_setup
fi

while read -rp "$PROMPT" cmd key value; do
  case $cmd in
  EXIT)
    echo "Exiting hnSQL"
    exit
    ;;
  esac
done
