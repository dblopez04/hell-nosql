#!/usr/bin/env bash
set -x

db_set() {
  local key=$1
  local value=$2

  echo "SET $key $value" >>"$DB_FILE"
}

db_get() {
  local key=$1

  grep "^SET $key " data.db | tail -1 | cut -d' ' -f3
}
