#!/usr/bin/env bash
set -euo pipefail

# Generates labeled perf-stat measurements for scheduler inference.
# Output CSV schema:
# timestamp,session_id,policy,workload,task_clock,context_switches,cpu_migrations,cycles,instructions,branches,branch_misses

POLICY="cfs"
WORKLOAD="burn"
CORE="3"
REPEAT=1
OUT="data/results_v2.csv"
SESSION_ID="$(date +%F)_A"

while [[ $# -gt 0 ]]; do
  case $1 in
    --policy) POLICY="$2"; shift 2;;
    --workload) WORKLOAD="$2"; shift 2;;
    --core) CORE="$2"; shift 2;;
    --repeat) REPEAT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    --session) SESSION_ID="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

# Resolve workload command
case "$WORKLOAD" in
  burn)  CMD="python3 workloads/cpu_burn.py" ;;
  pulse) CMD="python3 workloads/cpu_pulse.py" ;;
  yield) CMD="python3 workloads/cpu_burn_yield.py" ;;
  *) echo "Unknown workload: $WORKLOAD" >&2; exit 1;;
esac

# Resolve scheduling policy wrapper
# Note: RT policies (rr/fifo) require sudo to set policy via chrt.
case "$POLICY" in
  cfs)  FINAL="taskset -c $CORE $CMD" ;;
  rr)   FINAL="sudo chrt -r 50 taskset -c $CORE $CMD" ;;
  fifo) FINAL="sudo chrt -f 50 taskset -c $CORE $CMD" ;;
  *) echo "Unknown policy: $POLICY" >&2; exit 1;;
esac

# Ensure output directory exists
mkdir -p "$(dirname "$OUT")"

# Write header if file doesn't exist
if [[ ! -f "$OUT" ]]; then
  echo "timestamp,session_id,policy,workload,task_clock,context_switches,cpu_migrations,cycles,instructions,branches,branch_misses" > "$OUT"
fi

for ((i=1;i<=REPEAT;i++)); do
  echo "Run $i/$REPEAT: session=$SESSION_ID policy=$POLICY workload=$WORKLOAD core=$CORE"
  TS="$(date +%s)"

  # -x, makes perf emit CSV-like lines to stderr; we capture that.
  # We run perf as sudo so it can read kernel-level scheduling counters consistently.
  sudo perf stat -x, -e task-clock,context-switches,cpu-migrations,cycles,instructions,branches,branch-misses \
    $FINAL 2> perf_tmp.txt

  LINE="$(scripts/perf_parser.sh perf_tmp.txt)"

  echo "$TS,$SESSION_ID,$POLICY,$WORKLOAD,$LINE" >> "$OUT"
done
