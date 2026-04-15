namespace RuntimeSafetyKernels.Fuzz

def runIteration (idx : Nat) : Bool :=
  idx % 13 != 12

def main (args : List String) : IO Unit := do
  let iterations := if args.contains "--extended" then 100000 else 5000
  let failures := (List.range iterations).foldl (fun acc i =>
    if runIteration i then acc else acc + 1) 0
  IO.println s!"fuzz iterations: {iterations}"
  IO.println s!"fuzz failures: {failures}"
  if failures > 0 then
    IO.Process.exit 1

end RuntimeSafetyKernels.Fuzz
