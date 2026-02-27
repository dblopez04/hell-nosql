#!/usr/bin/env bash

# Environment Variables
DB_FILE="./data.db"

PROMPT="$(whoami)@hnsql ~ "

# Imports
source ./lib/cmds.sh
source ./lib/index.sh
source ./lib/init.sh

if [[ ! -f "$DB_FILE" ]]; then
  initial_setup
fi

while read -rp "$PROMPT" cmd key value; do
  case "$cmd" in
  SET)
    db_set "$key" "$value"
    ;;
  GET)
    db_get "$key"
    ;;
  EXIT)
    echo "Exiting hnSQL"
    exit
    ;;
  esac
done
