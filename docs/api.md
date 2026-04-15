# Runtime Safety Kernels API Reference

## Scope
This document reflects the APIs currently implemented in Lean source and used by the local/CI runtime validation flow. It intentionally avoids aspirational claims.

## Package Entry Modules
- `RuntimeSafetyKernels`
- `RuntimeSafetyKernels.Policy`
- `RuntimeSafetyKernels.Concurrency`
- `RuntimeSafetyKernels.Shape`
- `RuntimeSafetyKernels.Contracts`

## Canonical Contracts
Canonical cross-module types are re-exported in `src/RuntimeSafetyKernels/Contracts.lean`:
- Policy contract aliases (token/state/result).
- Concurrency contract aliases (request/worker/state/event).
- Shape contract alias (`Shape`).

Extraction and binding code must remain compatible with these aliases.

## Policy API
Implemented in `src/RuntimeSafetyKernels/Policy.lean` and `src/RuntimeSafetyKernels/Policy/Spec.lean`.

Primary operations:
- Initialize a policy manager with configuration.
- Decode a single token with explicit `Except` error semantics.
- Evaluate manager health status.

Reliability properties:
- Deterministic decode behavior for identical inputs.
- Explicit rejection path for invalid/blocked input.

## Concurrency API
Implemented in `src/RuntimeSafetyKernels/Concurrency.lean` and `src/RuntimeSafetyKernels/Concurrency/Spec.lean`.

Primary operations:
- Initialize concurrency manager state.
- Apply events to advance state transitions.
- Evaluate manager health status/invariant.

Reliability properties:
- Event-driven state transitions are explicit and testable.
- Invariant hooks are available for proof/test gating.

## Shape API
Implemented in `src/RuntimeSafetyKernels/Shape.lean` and `src/RuntimeSafetyKernels/Shape/Spec.lean`.

Primary operations:
- Validate tensor construction against shape size.
- Compute/validate tensor size from shape.
- Validate shape compatibility checks exposed by module functions.

Reliability properties:
- Shape mismatch is handled by validation failure, not unchecked behavior.

## Runtime Entry Points
Used by local/CI checks:
- `lake exe tests` (`src/RuntimeSafetyKernels/Tests.lean`)
- `lake exe fuzz` (`src/RuntimeSafetyKernels/Fuzz.lean`)
- `lake exe benchmarks` (`src/RuntimeSafetyKernels/Benchmarks.lean`)

Fallback runner entry points for Windows-safe execution:
- `src/RuntimeSafetyKernels/Runner/TestsMain.lean`
- `src/RuntimeSafetyKernels/Runner/FuzzMain.lean`
- `src/RuntimeSafetyKernels/Runner/BenchmarksMain.lean`

## Binding Smoke Interfaces
Current bindings are intentionally minimal/safe stubs:
- `src/RuntimeSafetyKernels/LanguageBindings/Python.lean`
- `src/RuntimeSafetyKernels/LanguageBindings/Go.lean`
- `src/RuntimeSafetyKernels/LanguageBindings/NodeJS.lean`

They demonstrate explicit error handling and avoid raw manual memory operations.

## Validation and Tooling API
- `python scripts/check_proof_completeness.py`
  - Enforces proof-hole policy.
- `python scripts/check_contract_consistency.py`
  - Enforces extraction/contract import alignment.
- `python scripts/lake_doctor.py`
  - Emits diagnostics JSON for environment/network/toolchain visibility.
- `python scripts/lake_resilient.py ...`
  - Wraps `lake` commands with retry/backoff and timeout.
- `python scripts/run_runtime_checks.py`
  - Runs runtime executables with fallback to `lake env lean --run`.
- `python scripts/validate_local.py`
  - Orchestrates primary path and fallback path for deterministic local validation.

## Non-Goals of Current API Surface
- No claim of stable public SDK bindings.
- No claim of formally proven performance SLOs.
- No claim of complete production FFI coverage.
