#!/usr/bin/env python3
"""
cpu_burn_yield.py
A CPU workload that voluntarily yields periodically.
Goal: increase scheduler interaction via sleep/yield points.
"""
import time
import math

TOTAL_SEC = 10.0
YIELD_EVERY_SEC = 0.01
YIELD_SLEEP_SEC = 0.0  # 0.0 still yields; set small >0 to force sleep

def main():
    start = time.time()
    next_yield = start + YIELD_EVERY_SEC
    x = 0.0

    while (time.time() - start) < TOTAL_SEC:
        x = math.sin(x + 0.000001) * math.cos(x + 0.000002) + 1.0
        now = time.time()
        if now >= next_yield:
            time.sleep(YIELD_SLEEP_SEC)
            next_yield = now + YIELD_EVERY_SEC

    print("done", x)

if __name__ == "__main__":
    main()
