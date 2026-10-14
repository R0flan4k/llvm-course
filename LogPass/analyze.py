#!/usr/bin/env python3
"""Analyze the IR usage trace (User <- Operand) for frequent patterns.

Counts how often every pattern of consecutive records of length 1..5
(sliding window) occurs in the trace and writes the top patterns into
the statistics file.
"""

import os
import sys
from collections import Counter

WINDOW_MAX = 5


def main():
    trace_file = sys.argv[1] if len(sys.argv) > 1 else "trace.txt"
    stats_file = sys.argv[2] if len(sys.argv) > 2 else "stats.txt"
    top = int(sys.argv[3]) if len(sys.argv) > 3 else 20

    if not os.path.isfile(trace_file):
        print("error: %s not found" % trace_file)
        print("collect the trace first: run ./build/mines_logged")
        sys.exit(1)

    with open(trace_file, "r") as f:
        records = [line.rstrip("\n") for line in f if line.strip()]

    n = len(records)
    with open(stats_file, "w") as out:
        out.write("IR usage trace statistics (User <- Operand)\n")
        out.write("app: mines, -O2\n")
        out.write("records: %d\n" % n)
        out.write("distinct records (window 1): %d\n\n" % len(set(records)))

        # windows[k-1] holds every pattern of length k as a rolling tuple
        windows = [records]
        for k in range(2, WINDOW_MAX + 1):
            windows.append([a + "\x1f" + b for a, b
                            in zip(windows[-1], records[k - 1:])])

        for k in range(1, WINDOW_MAX + 1):
            counter = Counter(windows[k - 1])
            total = len(windows[k - 1])
            out.write("== window size %d ==\n" % k)
            out.write("patterns: %d of %d (%.2f%%)\n"
                      % (len(counter), total,
                         100.0 * len(counter) / total if total else 0))
            for pattern, count in counter.most_common(top):
                parts = pattern.split("\x1f")
                out.write("%8d times %s\n" % (count, " ; ".join(parts)))
            out.write("\n")

    print("done: %d records -> %s" % (n, stats_file))


if __name__ == "__main__":
    main()
