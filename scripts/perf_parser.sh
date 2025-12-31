#!/usr/bin/env bash
set -euo pipefail

# Parses perf stat CSV output from perf_tmp.txt.
# We run: perf stat -x, -e <events> <cmd> 2> perf_tmp.txt
# Each line looks like:
#   10023.99,msec,task-clock,10023987661,100.00,1.000,CPUs utilized
# We extract the first field (value) for each event in a fixed order.

PERF_TMP="${1:-perf_tmp.txt}"

captures=("task-clock" "context-switches" "cpu-migrations" "cycles" "instructions" "branches" "branch-misses")

declare -A vals

while IFS=',' read -r value _ metric _; do
  for capture in "${captures[@]}"; do
    if [[ "$metric" == "$capture" ]]; then
      vals["$capture"]="$value"
      break
    fi
  done
done < "$PERF_TMP"

# Emit in the exact same order as captures[]
out=""
for capture in "${captures[@]}"; do
  v="${vals[$capture]:-}"
  if [[ -z "$v" ]]; then
    echo "ERROR: Missing metric '$capture' in $PERF_TMP" >&2
    exit 2
  fi
  if [[ -z "$out" ]]; then
    out="$v"
  else
    out="$out,$v"
  fi
done

echo "$out"
