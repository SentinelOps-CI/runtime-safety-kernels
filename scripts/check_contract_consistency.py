#!/usr/bin/env python3
import pathlib
import sys


REQUIRED_FILES = [
  pathlib.Path("src/RuntimeSafetyKernels/Contracts.lean"),
  pathlib.Path("src/RuntimeSafetyKernels/Policy/Extract.lean"),
  pathlib.Path("src/RuntimeSafetyKernels/Concurrency/Extract.lean"),
  pathlib.Path("src/RuntimeSafetyKernels/Shape/Extract.lean"),
]


def ensure_import(path: pathlib.Path) -> bool:
  text = path.read_text(encoding="utf-8")
  return "import RuntimeSafetyKernels.Contracts" in text


def main() -> int:
  for path in REQUIRED_FILES:
    if not path.exists():
      print(f"Contract consistency check failed: missing {path}")
      return 1

  for path in REQUIRED_FILES[1:]:
    if not ensure_import(path):
      print(f"Contract consistency check failed: missing canonical import in {path}")
      return 1

  print("Contract consistency check passed.")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
