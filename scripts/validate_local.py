#!/usr/bin/env python3
import subprocess
import sys


PRIMARY_COMMANDS = [
  [sys.executable, "scripts/lake_doctor.py"],
  [sys.executable, "scripts/lake_resilient.py", "--attempts", "4", "--timeout", "300", "--", "lake", "update"],
  [sys.executable, "scripts/check_proof_completeness.py"],
  [sys.executable, "scripts/check_contract_consistency.py"],
  [sys.executable, "scripts/lake_resilient.py", "--attempts", "3", "--timeout", "600", "--", "lake", "build"],
  [sys.executable, "scripts/lake_resilient.py", "--attempts", "2", "--timeout", "900", "--", sys.executable, "scripts/run_runtime_checks.py", "all"],
]

FALLBACK_COMMANDS = [
  [sys.executable, "scripts/lake_doctor.py"],
  [sys.executable, "scripts/check_proof_completeness.py"],
  [sys.executable, "scripts/check_contract_consistency.py"],
  [sys.executable, "scripts/lake_resilient.py", "--attempts", "2", "--timeout", "600", "--", "lake", "build"],
  [sys.executable, "scripts/lake_resilient.py", "--attempts", "1", "--timeout", "900", "--", sys.executable, "scripts/run_runtime_checks.py", "tests"],
]


def run(cmd):
  print("$ " + " ".join(cmd))
  subprocess.run(cmd, check=True)


def run_sequence(commands):
  for cmd in commands:
    run(cmd)


def main() -> int:
  try:
    run_sequence(PRIMARY_COMMANDS)
    print("local validation complete (primary path)")
    return 0
  except subprocess.CalledProcessError:
    print("primary validation path failed, switching to fallback path")
    run_sequence(FALLBACK_COMMANDS)
    print("local validation complete (fallback path)")
    return 0


if __name__ == "__main__":
  raise SystemExit(main())
