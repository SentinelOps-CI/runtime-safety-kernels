import RuntimeSafetyKernels.Policy
import RuntimeSafetyKernels.Concurrency

namespace RuntimeSafetyKernels.Benchmarks

open RuntimeSafetyKernels.Policy
open RuntimeSafetyKernels.Concurrency

def benchmarkPolicy (iterations : Nat) : IO Nat := do
  let cfg : PolicyConfig := { maxTokens := iterations + 1, policyVersion := "1.0" }
  let manager := initDefaultPolicyManager cfg
  let start ← IO.monoMsNow
  for i in List.range iterations do
    let _ := decodeToken manager s!"token_{i}"
    pure ()
  let stop ← IO.monoMsNow
  pure (stop - start)

def benchmarkConcurrency (iterations : Nat) : IO Nat := do
  let cfg : ConcurrencyConfig := ⟨64, 4096, 1000, 5000⟩
  let manager := initConcurrencyManager cfg
  let start ← IO.monoMsNow
  let _ := (List.range iterations).foldl (fun m _ => (submitRequest m 0).fst) manager
  let stop ← IO.monoMsNow
  pure (stop - start)

def main (args : List String) : IO Unit := do
  let iterations := if args.contains "--performance" then 200000 else 20000
  let pMs ← benchmarkPolicy iterations
  let cMs ← benchmarkConcurrency iterations
  IO.println s!"policy benchmark ms: {pMs}"
  IO.println s!"concurrency benchmark ms: {cMs}"
  if args.contains "--compare-baseline" && (pMs > 5000 || cMs > 5000) then
    IO.Process.exit 1

end RuntimeSafetyKernels.Benchmarks
