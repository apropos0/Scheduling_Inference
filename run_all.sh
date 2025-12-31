#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-$(date +%F)_A}"
REPEAT="${2:-30}"
CORE="${3:-3}"

OUT="data/results_${SESSION_ID}.csv"

POLICIES=(cfs rr fifo)
WORKLOADS=(burn pulse yield)

mkdir -p data

echo "Session: $SESSION_ID"
echo "Repeats per combo: $REPEAT"
echo "Output: $OUT"

# Capture environment once
scripts/collect_env.sh "$SESSION_ID" "data"

# Run experiments
for workload in "${WORKLOADS[@]}"; do
  for policy in "${POLICIES[@]}"; do
    echo "Running: policy=$policy workload=$workload"
    ./run_experiment.sh \
      --session "$SESSION_ID" \
      --policy "$policy" \
      --workload "$workload" \
      --core "$CORE" \
      --repeat "$REPEAT" \
      --out "$OUT"
  done
done

echo "Done. Data in $OUT"
