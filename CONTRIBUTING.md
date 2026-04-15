# Contributing

## Reliability-First Rules
1. Do not introduce `sorry` in safety-critical modules.
2. Keep extraction and bindings aligned with canonical contracts.
3. Prefer explicit errors over silent behavior changes.
4. Keep changes small, testable, and evidence-backed.

## Local Validation
Run this before opening a pull request:

```bash
python scripts/validate_local.py
```

## Minimal Manual Validation Matrix
- `python scripts/check_proof_completeness.py`
- `python scripts/check_contract_consistency.py`
- `python scripts/lake_doctor.py`
- `python scripts/lake_resilient.py --attempts 3 --timeout 600 lake build`
- `python scripts/run_runtime_checks.py`

## Pull Request Expectations
- Describe reliability impact and operational risk.
- Include command output evidence for changed behavior.
- Update `docs/api.md` and `README.md` if public behavior or guarantees change.
