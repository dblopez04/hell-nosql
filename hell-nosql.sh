#!/usr/bin/env bash

# Environment Variables
DB_FILE="./data.db"
PROMPT="$(whoami)@hnsql ~ "
INDEX_KEYS=()
INDEX_VALUES=()

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

db_set() {
  local key=$1
  local value=$2

  echo "SET $key $value" >>"$DB_FILE"
}

db_get() {
  local key=$1

  grep "^SET $key " data.db | tail -1 | cut -d' ' -f3
}

initial_setup() {
  echo "Welcome to Hell NoSQL, this appears to be your first time"
  [[ ! -f "$DB_FILE" ]] && : >"$DB_FILE" && echo "Created DB file"
}

init_index() {
  while IFS= read -r line || [[ -n "$line" ]]; do
    key=$(echo "$line" | cut -d' ' -f2)
    value=$(echo "$line" | cut -d' ' -f3)
    index_set "$key" "$value"
  done <"$DB_FILE"
}



if [[ ! -f "$DB_FILE" ]]; then
  initial_setup
fi

init_index

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
