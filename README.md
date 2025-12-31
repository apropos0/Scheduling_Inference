# CPU Scheduling Inference (User-Space Observables)

This project collects user-space observable performance signals and evaluates whether a Linux CPU scheduling policy can be inferred from them.

## What this repo contains

- `workloads/`
  - `cpu_burn.py`: steady CPU load (~10s)
  - `cpu_pulse.py`: pulsed load (busy/idle pattern)
  - `cpu_burn_yield.py`: CPU load with periodic voluntary yield
- `run_experiment.sh`: runs one policy/workload combination and appends a row to a CSV
- `run_all.sh`: runs a full grid across policies and workloads
- `scripts/perf_parser.sh`: parses `perf stat -x,` output into a single CSV row
- `data/`: output CSVs (created when you run experiments)

## Requirements (Pi)

- `perf` installed
- `cpupower` optional but recommended to reduce frequency variance
- sudo access (needed for RT scheduling policies via `chrt` and for perf counters in many setups)

## Recommended setup

Set CPU governor to reduce frequency variance:

```bash
sudo cpupower frequency-set -g performance
cpupower frequency-info
```

# Generate data
One run:

```bash
./run_experiment.sh --policy cfs --workload yield --repeat 5 --session 2025-12-31_A --out data/results_v2.csv
```

Full grid:

```bash
./run_all.sh --repeat 30 --session 2025-12-31_A --out data/results_v2.csv
```

# Output format

`data/results_v2.csv`

```python-repl
timestamp,session_id,policy,workload,task_clock,context_switches,cpu_migrations,cycles,instructions,branches,branch_misses
...
```

