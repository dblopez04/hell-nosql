#!/usr/bin/env bash
set -x

initial_setup() {
  echo "Welcome to Hell NoSQL, this appears to be your first time"
  [[ ! -f "$DB_FILE" ]] && : >"$DB_FILE" && echo "Created DB file"
}
