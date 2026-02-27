#!/usr/bin/env bash

# Environment Variables
DB_FILE="./data.db"
LOG_FILE="./hnsql.log"

# Imports
source ./lib/init.sh

if [[ ! -f "$DB_FILE" || ! -f "$LOG_FILE" ]]; then
	initial_setup
fi
