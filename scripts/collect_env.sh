#!/usr/bin/env bash
set -euo pipefail

SESSION_ID="${1:-$(date +%F)_A}"
OUTDIR="${2:-data}"

mkdir -p "$OUTDIR"
OUTFILE="$OUTDIR/env_${SESSION_ID}.txt"

{
  echo "session_id: $SESSION_ID"
  echo "timestamp_utc: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo

  echo "OS / Kernel: "
  uname -a || true
  echo
  cat /etc/os-release 2>/dev/null || true
  echo

  echo "CPU: "
  lscpu 2>/dev/null || true
  echo

  echo "Governor / cpufreq: "
  command -v cpupower >/dev/null 2>&1 && cpupower frequency-info || echo "cpupower not installed"
  echo

  echo "perf: "
  perf --version 2>/dev/null || echo "perf not found"
  echo

  echo "Memory: "
  free -h 2>/dev/null || true
  echo

  echo "Boot cmdline: "
  cat /proc/cmdline 2>/dev/null || true
  echo

  echo "Top 10 processes by CPU (snapshot): "
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11 2>/dev/null || true
  echo

  echo "Git state (if repo): "
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git rev-parse HEAD || true
    git status --porcelain || true
  else
    echo "not a git repo"
  fi
} > "$OUTFILE"

echo "Wrote: $OUTFILE"
