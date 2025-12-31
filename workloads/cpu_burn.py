#!/usr/bin/env python3
"""
cpu_burn.py
A simple CPU-bound workload for ~10 seconds.
Goal: generate steady compute load.
"""
import time
import math

DURATION_SEC = 10.0

def main():
    start = time.time()
    x = 0.0
    while (time.time() - start) < DURATION_SEC:
        # A little floating point work in a tight loop.
        x = math.sin(x + 0.000001) * math.cos(x + 0.000002) + 1.0
    print("done", x)

if __name__ == "__main__":
    main()
