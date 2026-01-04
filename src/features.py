import numpy as np
import pandas as pd

FEATURE_COLUMNS = [
    "task_sec",
    "cs_per_sec",
    "mig_per_sec",
    "cycles_per_sec",
    "instr_per_sec",
    "branches_per_sec",
    "ipc",
    "branch_miss_rate",
]

def add_features(raw: pd.DataFrame) -> pd.DataFrame:
    """
    Adds time-normalized and ratio features for scheduler inference.

    Expected raw columns:
      task_clock (ms), context_switches, cpu_migrations,
      cycles, instructions, branches, branch_misses
    """
    df = raw.copy()

    # perf task-clock is in milliseconds in your CSV
    df["task_sec"] = df["task_clock"] / 1000.0

    # rates
    df["cs_per_sec"] = df["context_switches"] / df["task_sec"]
    df["mig_per_sec"] = df["cpu_migrations"] / df["task_sec"]
    df["cycles_per_sec"] = df["cycles"] / df["task_sec"]
    df["instr_per_sec"] = df["instructions"] / df["task_sec"]
    df["branches_per_sec"] = df["branches"] / df["task_sec"]

    # ratios
    df["ipc"] = df["instructions"] / df["cycles"]
    df["branch_miss_rate"] = df["branch_misses"] / df["branches"]

    # safety
    df.replace([np.inf, -np.inf], np.nan, inplace=True)

    return df
