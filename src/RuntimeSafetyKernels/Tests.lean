import RuntimeSafetyKernels.Policy
import RuntimeSafetyKernels.Concurrency
import RuntimeSafetyKernels.Shape
import RuntimeSafetyKernels.ReliabilityTelemetry

namespace RuntimeSafetyKernels.Tests

open RuntimeSafetyKernels.Policy
open RuntimeSafetyKernels.Concurrency
open RuntimeSafetyKernels.Shape

def runPolicyChecks : Bool :=
  let cfg : PolicyConfig := { maxTokens := 4, policyVersion := "1.0" }
  let manager := initDefaultPolicyManager cfg
  match decodeToken manager "safe" with
  | .ok _ => true
  | .error _ => false

def runConcurrencyChecks : Bool :=
  let cfg : ConcurrencyConfig := ⟨64, 4096, 1000, 5000⟩
  let manager := initConcurrencyManager cfg
  let (nextManager, _) := submitRequest manager 0
  isHealthy nextManager

def runShapeChecks : Bool :=
  validateShapeAtCompileTime [2, 3, 4]

def main : IO Unit := do
  let checks := [
    ("policy", runPolicyChecks),
    ("concurrency", runConcurrencyChecks),
    ("shape", runShapeChecks)
  ]
  let failed := checks.filter (fun (_, ok) => not ok)
  for (name, ok) in checks do
    RuntimeSafetyKernels.ReliabilityTelemetry.emit
      ⟨name, "reliability_check", ok, if ok then "pass" else "fail"⟩
    IO.println s!"{name}: {if ok then "pass" else "fail"}"
  if failed.isEmpty then
    IO.println "all reliability checks passed"
  else
    IO.eprintln s!"failed checks: {failed.map Prod.fst}"
    IO.Process.exit 1

end RuntimeSafetyKernels.Tests
