#!/usr/bin/env bash

# --- Environment Variables ---
DB_FILE="./data.db" # Location of DB file
PROMPT="$(whoami)@hnsql ~ " # Bash-style prompt
INDEX_KEYS=() # In-memory index arrays
INDEX_VALS=()
DEBUG=false # Auto-sets debug flag to false



# --- Debug Flag ---
# When running with -d, displays the full
# in-memory index after every command.
while getopts "d" flag; do
    case "$flag" in
        d) DEBUG=true ;;
    esac
done

debug_index() {
  if [[ "$DEBUG" == true ]]; then
    echo "--INDEX--"
    for i in "${!INDEX_KEYS[@]}"; do
      echo "${INDEX_KEYS[$i]} ${INDEX_VALS[$i]}"
    done
    echo ""
  fi
}

# --- Index Functions ---

# Loops through the in-memory index to add
# new entries. Replaces old values on keys
# already present in the index.
index_set() {
  local key=$1
  local value=$2
  for i in "${!INDEX_KEYS[@]}"; do
    if [[ "${INDEX_KEYS[$i]}" == "$key" ]]; then
      INDEX_VALS[$i]="$value"
      return
    fi
  done
  INDEX_KEYS+=("$key")
  INDEX_VALS+=("$value")
}

# Initializes the in-memory index by
# looping through the database and
# calling index_set
init_index() {
  while IFS= read -r line || [[ -n "$line" ]]; do
    key=$(echo "$line" | cut -d' ' -f2)
    value=$(echo "$line" | cut -d' ' -f3)
    index_set "$key" "$value"
  done <"$DB_FILE"
}

# Adds a key and value to the DB, then
# updates the in-memory index.
db_set() {
  local key=$1
  local value=$2

  echo "SET $key $value" >>"$DB_FILE"

  index_set "$key" "$value"
}

# Loops through the in-memory index
# to find the value of any key
db_get() {
  local key=$1
    for i in "${!INDEX_KEYS[@]}"; do
        if [[ "${INDEX_KEYS[$i]}" == "$key" ]]; then
            echo "${INDEX_VALS[$i]}"
            return
        fi
    done
}

# Checks if the DB exists, if no
# DB file exists, create one.
# : > does the same thing as touch (pure bash bible, awesome resource)
if [[ ! -f "$DB_FILE" ]]; then
  echo "Welcome to Hell NoSQL, this appears to be your first time"
  : >"$DB_FILE" && echo "Created DB file"
fi

init_index
debug_index

# --- Main Loop ---
# Reads input into command, key, and value
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
  debug_index
done
