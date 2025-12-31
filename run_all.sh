#!/usr/bin/env bash
set -euo pipefail

# Runs a full grid: 3 policies x 3 workloads, with configurable repeats.
# Example:
#   ./run_all.sh --session 2025-12-31_A --repeat 50 --out data/results_v2.csv

SESSION_ID="$(date +%F)_A"
REPEAT=30
OUT="data/results_v2.csv"
CORE="3"

while [[ $# -gt 0 ]]; do
  case $1 in
    --session) SESSION_ID="$2"; shift 2;;
    --repeat) REPEAT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    --core) CORE="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

# Collect environment info
scripts/collect_env.sh "$SESSION_ID" "data"

policies=("cfs" "rr" "fifo")
workloads=("burn" "yield" "pulse")

for p in "${policies[@]}"; do
  for w in "${workloads[@]}"; do
    ./run_experiment.sh \
      --policy "$p" \
      --workload "$w" \
      --core "$CORE" \
      --repeat "$REPEAT" \
      --session "$SESSION_ID" \
      --out "$OUT"
  done
done

echo "Done. Wrote: $OUT"
