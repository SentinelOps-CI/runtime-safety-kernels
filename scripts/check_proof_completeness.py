#!/usr/bin/env python3
import pathlib
import re
import sys


def main() -> int:
  root = pathlib.Path("src/RuntimeSafetyKernels")
  pattern = re.compile(r"\bsorry\b")
  failures = []

  for path in root.rglob("*.lean"):
    text = path.read_text(encoding="utf-8")
    if pattern.search(text):
      failures.append(path)

  if failures:
    print("Proof completeness check failed: found 'sorry' in safety-critical modules.")
    for path in failures:
      print(f"- {path}")
    return 1

  print("Proof completeness check passed.")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
