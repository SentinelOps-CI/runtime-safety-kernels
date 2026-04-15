<div align="center">

# Runtime Safety Kernels

Lean-based runtime kernels engineered for **reliability, auditability, and deterministic validation**.

The project focuses on safety-critical runtime behavior across policy, concurrency, and shape handling, with strict documentation-to-gate alignment.

</div>

---

## Why This Repository Exists

Runtime systems fail in production when guarantees are implicit, tests are brittle, or builds are environment-sensitive.  
This repository hardens that path by making reliability properties explicit and mechanically checkable.

## Reliability Guarantees

- **Canonical contracts:** shared runtime-critical aliases live in `src/RuntimeSafetyKernels/Contracts.lean`.
- **Proof-hole enforcement:** safety-critical modules must stay free of `sorry`, enforced by `python scripts/check_proof_completeness.py`.
- **Contract consistency:** extraction paths are checked by `python scripts/check_contract_consistency.py`.
- **Resilient execution:** validation runs with diagnostics, retry/backoff, and fallback runtime checks for unstable environments.

## Quick Start

Run the full local reliability pipeline:

```bash
python scripts/validate_local.py
```

This command orchestrates diagnostics, gate checks, build, and runtime verification through a primary path plus fallback path where needed.

## Build and Validation Tooling

| Tool | Purpose | Output/Behavior |
|---|---|---|
| `scripts/lake_doctor.py` | Collect environment, toolchain, and network diagnostics | Writes `build/lake-diagnostics.json` |
| `scripts/lake_resilient.py` | Execute `lake` commands with retry/backoff and timeout | Improves reliability under flaky fetch/toolchain states |
| `scripts/run_runtime_checks.py` | Run tests, fuzz, benchmarks | Uses Windows-safe fallback from `lake exe` to `lake env lean --run` when native linking fails |
| `scripts/validate_local.py` | Orchestrate full local validation | Runs primary sequence, then fallback sequence on failure |

## Project Entry Points

- Main module: `src/RuntimeSafetyKernels.lean`
- Tests: `src/RuntimeSafetyKernels/Tests.lean`
- Fuzz checks: `src/RuntimeSafetyKernels/Fuzz.lean`
- Benchmarks: `src/RuntimeSafetyKernels/Benchmarks.lean`
- Canonical contracts: `src/RuntimeSafetyKernels/Contracts.lean`

Fallback Lean runners used by runtime checks:
- `src/RuntimeSafetyKernels/Runner/TestsMain.lean`
- `src/RuntimeSafetyKernels/Runner/FuzzMain.lean`
- `src/RuntimeSafetyKernels/Runner/BenchmarksMain.lean`

## Documentation Map

- API surface: `docs/api.md`
- Contribution standards: `CONTRIBUTING.md`

## Contribution Expectations

All changes are expected to preserve reliability guarantees, provide verification evidence, and keep documentation aligned with implementation reality.
