from pathlib import Path

def repo_root() -> Path:
    # src/paths.py -> src -> repo root
    return Path(__file__).resolve().parents[1]

def raw_csv(session_id: str) -> Path:
    return repo_root() / "data" / "raw" / f"results_{session_id}.csv"

def clean_parquet(session_id: str) -> Path:
    return repo_root() / "data" / "processed" / f"clean_{session_id}.parquet"
