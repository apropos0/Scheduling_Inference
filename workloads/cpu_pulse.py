#!/usr/bin/env python3
"""
cpu_pulse.py
A pulsed CPU workload: alternating busy / idle.
Goal: create more structured activity than cpu_burn.
"""
import time
import math

TOTAL_SEC = 10.0
ON_SEC = 0.5
OFF_SEC = 0.5

def busy_for(seconds: float) -> float:
    end = time.time() + seconds
    x = 0.0
    while time.time() < end:
        x = math.sin(x + 0.000001) * math.cos(x + 0.000002) + 1.0
    return x

def main():
    start = time.time()
    x = 0.0
    while (time.time() - start) < TOTAL_SEC:
        x = busy_for(ON_SEC)
        time.sleep(OFF_SEC)
    print("done", x)

if __name__ == "__main__":
    main()
