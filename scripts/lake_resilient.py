#!/usr/bin/env python3
import argparse
import subprocess
import sys
import time


def run_once(cmd, timeout):
  return subprocess.run(cmd, timeout=timeout).returncode


def run_with_retries(cmd, attempts, timeout, base_delay):
  for i in range(1, attempts + 1):
    print(f"[attempt {i}/{attempts}] {' '.join(cmd)}")
    try:
      code = run_once(cmd, timeout)
    except subprocess.TimeoutExpired:
      code = 124
      print(f"timeout after {timeout}s")
    if code == 0:
      return 0
    if i < attempts:
      delay = base_delay * i
      print(f"retrying in {delay}s")
      time.sleep(delay)
  return 1


def main() -> int:
  parser = argparse.ArgumentParser(description="Run Lake command with retries/backoff.")
  parser.add_argument("--attempts", type=int, default=4)
  parser.add_argument("--timeout", type=int, default=300)
  parser.add_argument("--delay", type=int, default=5)
  parser.add_argument("cmd", nargs=argparse.REMAINDER)
  args = parser.parse_args()

  if not args.cmd:
    print("no command provided")
    return 2
  if args.cmd[0] == "--":
    args.cmd = args.cmd[1:]
  if not args.cmd:
    print("empty command")
    return 2

  return run_with_retries(args.cmd, args.attempts, args.timeout, args.delay)


if __name__ == "__main__":
  raise SystemExit(main())
