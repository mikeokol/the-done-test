#!/bin/bash
# run_controls.sh — reproduce the README's seven-control table.
# Runs done_test.py against each control pair and prints each exit code.
# Expected exits: Positive 0, N1 1, N2 1, N3 1, N4 0, N5 1, N6 0.
# Exit 1 is an expected control outcome, not a script failure.
set -u
cd "$(dirname "$0")"

run() {
  echo "--- $1 ---"
  python3 done_test.py "$2" "$3"
  echo "exit=$?"
  echo
}

run "Positive: positive-trace + positive-report (expect PASS, exit 0)" \
  controls/positive-trace.jsonl controls/positive-report.md
run "N1: positive-trace + tampered-report (expect C3 FAIL, exit 1)" \
  controls/positive-trace.jsonl controls/tampered-report.md
run "N2: truncated-trace + positive-report (expect C1 FAIL, exit 1)" \
  controls/truncated-trace.jsonl controls/positive-report.md
run "N3: denied-trace + positive-report (expect C2 FAIL, exit 1)" \
  controls/denied-trace.jsonl controls/positive-report.md
run "N4: malformed-trace + positive-report (expect C4 WARN, PASS, exit 0)" \
  controls/malformed-trace.jsonl controls/positive-report.md
run "N5: positive-trace + added-sentence-report (expect C3 FAIL, exit 1)" \
  controls/positive-trace.jsonl controls/added-sentence-report.md
run "N6: rewrite-trace + rewrite-report (expect PASS, exit 0)" \
  controls/rewrite-trace.jsonl controls/rewrite-report.md
