#!/usr/bin/env python3
import platform
import subprocess
import sys


def run(cmd):
  print("$ " + " ".join(cmd))
  subprocess.run(cmd, check=True)


def run_with_fallback(exe_cmd, run_cmd):
  try:
    run(exe_cmd)
  except subprocess.CalledProcessError:
    print("native executable path failed, falling back to `lake env lean --run`")
    run(run_cmd)


def main() -> int:
  mode = sys.argv[1] if len(sys.argv) > 1 else "all"
  is_windows = platform.system().lower().startswith("win")

  tasks = []
  if mode in ("all", "tests"):
    tasks.append((
      ["lake", "exe", "tests"],
      ["lake", "env", "lean", "--run", "src/RuntimeSafetyKernels/Runner/TestsMain.lean"],
    ))
  if mode in ("all", "fuzz"):
    tasks.append((
      ["lake", "exe", "fuzz"],
      ["lake", "env", "lean", "--run", "src/RuntimeSafetyKernels/Runner/FuzzMain.lean"],
    ))
  if mode in ("all", "benchmarks"):
    tasks.append((
      ["lake", "exe", "benchmarks", "--compare-baseline"],
      ["lake", "env", "lean", "--run", "src/RuntimeSafetyKernels/Runner/BenchmarksMain.lean"],
    ))

  for exe_cmd, run_cmd in tasks:
    if is_windows:
      run_with_fallback(exe_cmd, run_cmd)
    else:
      run(exe_cmd)

  return 0


if __name__ == "__main__":
  raise SystemExit(main())
