#!/usr/bin/env python3
import json
import os
import platform
import shutil
import socket
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse


TARGET_URLS = [
  "https://github.com",
  "https://raw.githubusercontent.com",
  "https://objects.githubusercontent.com",
]


def run(cmd):
  proc = subprocess.run(cmd, capture_output=True, text=True)
  return {
    "cmd": cmd,
    "code": proc.returncode,
    "stdout": proc.stdout.strip(),
    "stderr": proc.stderr.strip(),
  }


def dns_probe(url: str):
  host = urlparse(url).hostname
  if not host:
    return {"url": url, "ok": False, "error": "no hostname"}
  try:
    addr = socket.gethostbyname(host)
    return {"url": url, "ok": True, "host": host, "ip": addr}
  except Exception as ex:
    return {"url": url, "ok": False, "host": host, "error": str(ex)}


def tcp_probe(url: str):
  host = urlparse(url).hostname
  if not host:
    return {"url": url, "ok": False, "error": "no hostname"}
  try:
    with socket.create_connection((host, 443), timeout=5):
      return {"url": url, "ok": True, "host": host, "port": 443}
  except Exception as ex:
    return {"url": url, "ok": False, "host": host, "port": 443, "error": str(ex)}


def main() -> int:
  report = {
    "timestamp": datetime.now(timezone.utc).isoformat(),
    "platform": {
      "system": platform.system(),
      "release": platform.release(),
      "version": platform.version(),
      "python": sys.version,
    },
    "paths": {
      "elan": shutil.which("elan"),
      "lake": shutil.which("lake"),
      "lean": shutil.which("lean"),
      "git": shutil.which("git"),
    },
    "toolchain_file": Path("lean-toolchain").read_text(encoding="utf-8").strip() if Path("lean-toolchain").exists() else "",
    "commands": [],
    "dns": [],
    "tcp": [],
    "env": {
      "GITHUB_ACTIONS": os.getenv("GITHUB_ACTIONS", ""),
      "CI": os.getenv("CI", ""),
    },
  }

  for cmd in [["elan", "--version"], ["lake", "--version"], ["lean", "--version"], ["git", "--version"]]:
    report["commands"].append(run(cmd))

  for url in TARGET_URLS:
    report["dns"].append(dns_probe(url))
    report["tcp"].append(tcp_probe(url))

  Path("build").mkdir(parents=True, exist_ok=True)
  out = Path("build/lake-diagnostics.json")
  out.write_text(json.dumps(report, indent=2), encoding="utf-8")
  print(f"wrote diagnostics to {out}")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
